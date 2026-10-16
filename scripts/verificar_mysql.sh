#!/usr/bin/env bash
# Valida 07-escala/connect-mysql num MySQL 8.0 descartável (Docker).
# Cria o banco "linkedin", carrega schema.sql e dados_exemplo.sql e testa
# se as constraints rejeitam dados inválidos. O container é removido no fim.
#
# Uso: ./scripts/verificar_mysql.sh   (requer Docker em execução)

set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
P="$RAIZ/07-escala/connect-mysql"
NOME="cs50-connect-mysql-$$"

docker info >/dev/null 2>&1 || { echo "Erro: Docker não está em execução." >&2; exit 1; }

docker run -d --rm --name "$NOME" -e MYSQL_ROOT_PASSWORD=crimson mysql:8.0 >/dev/null
trap 'docker stop "$NOME" >/dev/null' EXIT

# Conexões por TCP (127.0.0.1): durante a inicialização a imagem sobe um servidor
# temporário só por socket e depois reinicia; esperar pelo TCP evita pegar esse servidor.
echo "Aguardando o MySQL iniciar..."
until docker exec "$NOME" mysql -h127.0.0.1 -uroot -pcrimson -e 'SELECT 1' >/dev/null 2>&1; do sleep 2; done

sql() { docker exec -i "$NOME" mysql -h127.0.0.1 -uroot -pcrimson --batch --skip-column-names "$@" 2>&1 | { grep -v 'Using a password' || true; }; }

sql -e 'CREATE DATABASE `linkedin`;'
sql linkedin < "$P/schema.sql"
sql linkedin < "$P/dados_exemplo.sql"
echo "✅ schema.sql e dados_exemplo.sql carregados"
sql linkedin -e 'SELECT COUNT(*) AS tabelas FROM information_schema.tables WHERE table_schema = "linkedin";'

# Cada inserção abaixo deve ser rejeitada pelas constraints
for teste in \
    "INSERT INTO schools (name, type, location, founded_year) VALUES ('X', 'Kindergarten', 'Y', 2000);" \
    "INSERT INTO connections (user_id_1, user_id_2) SELECT MAX(id), MIN(id) FROM users;" \
    "INSERT INTO company_affiliations (user_id, company_id, start_date, end_date, title) VALUES (1, 1, '2010-01-01', '2009-01-01', 'X');"
do
    saida=$(sql linkedin -e "$teste" || true)   # o erro do MySQL é o resultado esperado
    if grep -q ERROR <<< "$saida"; then
        echo "✅ rejeitado: ${teste:0:60}..."
    else
        echo "❌ aceito indevidamente: ${teste:0:60}..."; exit 1
    fi
done
