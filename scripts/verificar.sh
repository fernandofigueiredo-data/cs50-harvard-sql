#!/usr/bin/env bash
# Executa todas as soluções contra os bancos oficiais e confere o resultado.
#
# Pré-requisitos: sqlite3 >= 3.40 e os bancos baixados (./scripts/baixar_dados.sh).
# Nenhum banco é alterado: consultas rodam em modo somente leitura, views viram
# TEMP VIEW e os scripts de escrita rodam em bancos em memória.
#
# Uso: ./scripts/verificar.sh
# Saída: uma linha por verificação (✅/❌) e um resumo; código de saída 1 se algo falhar.

set -uo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
cd "$RAIZ"

OK=0
FALHA=0

passou() { printf '  ✅ %s\n' "$1"; OK=$((OK + 1)); }
falhou() { printf '  ❌ %s\n' "$1"; FALHA=$((FALHA + 1)); }

confere() { # descrição, obtido, esperado
    if [ "$2" = "$3" ]; then passou "$1 → $2"; else falhou "$1 → obtido: $2 | esperado: $3"; fi
}

linhas() { # banco, arquivo .sql → número de linhas da saída
    sqlite3 -readonly "$1" < "$2" 2>&1 | wc -l | tr -d ' '
}

precisa() { # banco
    [ -f "$1" ] && return 0
    falhou "banco ausente: $1 (rode ./scripts/baixar_dados.sh)"
    return 1
}

consultas() { # pasta, banco, "arquivo:esperado ..."
    local pasta=$1 banco=$2; shift 2
    precisa "$pasta/$banco" || return
    for par in "$@"; do
        local arq=${par%%:*} esp=${par##*:}
        confere "$pasta/$arq" "$(linhas "$pasta/$banco" "$pasta/$arq") linhas" "$esp linhas"
    done
}

temp_view() { # banco, arquivo, nome da view → "linhas | colunas"
    { sed 's/CREATE VIEW/CREATE TEMP VIEW/' "$2"
      echo "SELECT COUNT(*) FROM \"$3\";"
      echo "SELECT group_concat(name, ',') FROM pragma_table_info('$3', 'temp');"
    } | sqlite3 -readonly "$1" 2>&1 | paste -sd'|' - | sed 's/|/ linhas | /'
}

echo "Etapa 1 — Consultas"
# Contagens de players vêm do enunciado; cyberchase e views não têm contagens
# publicadas, então os valores abaixo são os conferidos manualmente contra o banco.
consultas 01-consultas/cyberchase cyberchase.db \
    1.sql:26 2.sql:14 3.sql:1 4.sql:26 5.sql:1 6.sql:2 7.sql:6 8.sql:1 9.sql:1 \
    10.sql:140 11.sql:10 12.sql:1 13.sql:5
consultas 01-consultas/views views.db \
    1.sql:72 2.sql:3 3.sql:1 4.sql:1 5.sql:1 6.sql:1 7.sql:5 8.sql:5 9.sql:1 10.sql:5
consultas 01-consultas/players players.db \
    1.sql:1 2.sql:1 3.sql:213 4.sql:2814 5.sql:12878 6.sql:134 7.sql:1 8.sql:1 9.sql:516 10.sql:5

echo "Etapa 2 — Relacionamentos"
consultas 02-relacionamentos/dese dese.db \
    1.sql:1761 2.sql:121 3.sql:1 4.sql:10 5.sql:201 6.sql:9 7.sql:17 8.sql:396 \
    9.sql:1 10.sql:10 11.sql:391 12.sql:65 13.sql:10
consultas 02-relacionamentos/moneyball moneyball.db \
    1.sql:17 2.sql:17 3.sql:13 4.sql:50 5.sql:3 6.sql:5 7.sql:1 8.sql:1 9.sql:5 \
    10.sql:14915 11.sql:10 12.sql:6
P=02-relacionamentos/packages
if precisa "$P/packages.db"; then
    confere "$P/log.sql executa sem erro" \
        "$(sqlite3 -readonly "$P/packages.db" < "$P/log.sql" 2>&1 | grep -c -i error)" "0"
    confere "$P/answers.txt respostas preenchidas" \
        "$(grep -cE '\?: .+' "$P/answers.txt")" "6"
fi

echo "Etapa 3 — Modelagem"
for d in atl connect donuts; do
    P=03-modelagem/$d
    saida=$( { echo 'PRAGMA foreign_keys = ON;'; cat "$P/schema.sql" "$P/dados_exemplo.sql"
               echo 'PRAGMA foreign_key_check;'; } | sqlite3 :memory: 2>&1 )
    confere "$P schema + dados de exemplo (FKs ativas)" "${saida:-sem erros}" "sem erros"
done

echo "Etapa 4 — Escrita"
P=04-escrita/dont-panic
saida=$( cd "$P" && { cat reset.sql; echo ';'; cat hack.sql
    echo "SELECT password FROM users WHERE username = 'admin';"
    echo "SELECT COUNT(*) FROM user_logs WHERE new_password = '982c0381c279d139fd221fce974916e7';"
    echo "SELECT new_password = (SELECT password FROM users WHERE username = 'emily33')
          FROM user_logs WHERE old_username = 'admin' ORDER BY id DESC LIMIT 1;"
} | sqlite3 :memory: 2>&1 | paste -sd' ' - )
confere "$P/hack.sql (senha do admin | logs reais | log falso)" "$saida" \
    "982c0381c279d139fd221fce974916e7 0 1"
P=04-escrita/meteorites
if [ -f "$P/meteorites.csv" ]; then
    saida=$( cd "$P" && { cat import.sql; echo
        echo ".mode list"
        echo "SELECT COUNT(*) FROM meteorites;"
        echo "SELECT COUNT(*) FROM pragma_table_info('meteorites');"
        echo "SELECT COUNT(*) FROM meteorites WHERE mass = '' OR year = '' OR lat = '' OR long = '';"
        echo "SELECT MIN(id) || '-' || MAX(id) FROM meteorites;"
    } | sqlite3 :memory: 2>&1 | paste -sd' ' - )
    confere "$P/import.sql (linhas | colunas | vazios | ids)" "$saida" "45641 8 0 1-45641"
else
    falhou "$P/meteorites.csv ausente (rode ./scripts/baixar_dados.sh)"
fi

echo "Etapa 5 — Views"
P=05-views/census
if precisa "$P/census.db"; then
    confere "$P/rural.sql"          "$(temp_view $P/census.db $P/rural.sql rural)" \
        "461 linhas | id,district,locality,families,households,population,male,female"
    confere "$P/total.sql"          "$(temp_view $P/census.db $P/total.sql total)" \
        "1 linhas | families,households,population,male,female"
    confere "$P/by_district.sql"    "$(temp_view $P/census.db $P/by_district.sql by_district)" \
        "77 linhas | district,families,households,population,male,female"
    confere "$P/most_populated.sql" "$(temp_view $P/census.db $P/most_populated.sql most_populated)" \
        "77 linhas | district,families,households,population,male,female"
fi
P=05-views/private
if precisa "$P/private.db"; then
    saida=$( { sed 's/CREATE VIEW/CREATE TEMP VIEW/' $P/private.sql
               echo 'SELECT "phrase" FROM "message";'; } | sqlite3 -readonly $P/private.db | paste -sd' ' - )
    confere "$P/private.sql (mensagem)" "$saida" "find me in the place you least expect. behind the books"
fi
P=05-views/bnb
if precisa "$P/bnb.db"; then
    confere "$P/no_descriptions.sql"     "$(temp_view $P/bnb.db $P/no_descriptions.sql no_descriptions)" \
        "3973 linhas | id,property_type,host_name,accommodates,bedrooms"
    confere "$P/one_bedrooms.sql"        "$(temp_view $P/bnb.db $P/one_bedrooms.sql one_bedrooms)" \
        "1228 linhas | id,property_type,host_name,accommodates"
    confere "$P/available.sql"           "$(temp_view $P/bnb.db $P/available.sql available)" \
        "405201 linhas | id,property_type,host_name,date"
    confere "$P/frequently_reviewed.sql" "$(temp_view $P/bnb.db $P/frequently_reviewed.sql frequently_reviewed)" \
        "100 linhas | id,property_type,host_name,reviews"
    confere "$P/june_vacancies.sql"      "$(temp_view $P/bnb.db $P/june_vacancies.sql june_vacancies)" \
        "1895 linhas | id,property_type,host_name,days_vacant"
fi

echo "Etapa 6 — Otimização"
P=06-otimizacao/snap
if precisa "$P/snap.db"; then
    for par in "1.sql:search_users_by_last_login" "2.sql:USING INTEGER PRIMARY KEY" \
               "3.sql:search_messages_by_from_user_id" "4.sql:search_messages_by_to_user_id" \
               "5.sql:sqlite_autoindex_friends_1"; do
        arq=${par%%:*} idx=${par#*:}
        plano=$(sqlite3 -readonly $P/snap.db "EXPLAIN QUERY PLAN $(cat $P/$arq)")
        if grep -q "$idx" <<< "$plano"; then passou "$P/$arq usa $idx"; else falhou "$P/$arq não usa $idx"; fi
    done
fi
P=06-otimizacao/harvard
if precisa "$P/harvard.db"; then
    # Conta quantas das 7 consultas típicas deixam de varrer a tabela inteira (SCAN)
    # nas tabelas grandes depois dos índices. Copia o banco para a memória.
    plano() {
        { echo ".restore $P/harvard.db"; [ "$1" = depois ] && cat $P/indexes.sql
          awk 'BEGIN{RS=";"} /SELECT/{gsub(/^[ \n]+/,""); print "EXPLAIN QUERY PLAN " $0 ";"}' $P/consultas.sql
        } | sqlite3 :memory: | grep -cE 'SCAN (enrollments|satisfies|students)$|SCAN courses$'
    }
    confere "$P SCANs completos antes dos índices"  "$(plano antes)"  "10"
    confere "$P SCANs completos depois dos índices" "$(plano depois)" "2"
fi

echo "Etapa 7 — Escala"
P=07-escala/deep
confere "$P/answers.md seções" "$(grep -cE '^## (Random Partitioning|Partitioning by Hour|Partitioning by Hash Value)$' $P/answers.md)" "3"
P=07-escala/dont-panic-python
if command -v python3 >/dev/null; then
    if python3 -c "import ast,sys; ast.parse(open(sys.argv[1]).read())" "$P/hack.py" 2>/dev/null; then
        passou "$P/hack.py sintaxe válida"
    else
        falhou "$P/hack.py com erro de sintaxe"
    fi
fi
echo "  ℹ️  07-escala/connect-mysql: valide com ./scripts/verificar_mysql.sh (requer Docker)"

echo
echo "Resumo: $OK ok, $FALHA falha(s)"
[ "$FALHA" -eq 0 ]
