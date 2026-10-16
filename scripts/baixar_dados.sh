#!/usr/bin/env bash
# Baixa os bancos de dados oficiais do CS50 SQL (distribuição 2024) e extrai
# apenas os arquivos .db/.csv para a pasta de cada problema.
#
# Uso: ./scripts/baixar_dados.sh            # todos os problemas
#      ./scripts/baixar_dados.sh moneyball  # só um
#
# Os bancos não ficam versionados: somam ~170 MB (bnb.db sozinho tem 86 MB).

set -euo pipefail

RAIZ="$(cd "$(dirname "$0")/.." && pwd)"
CDN="https://cdn.cs50.net/sql/2024/x/psets"

# problema | semana no CDN | pasta no repositório
PROBLEMAS="
cyberchase|0|01-consultas/cyberchase
views|0|01-consultas/views
players|0|01-consultas/players
packages|1|02-relacionamentos/packages
dese|1|02-relacionamentos/dese
moneyball|1|02-relacionamentos/moneyball
dont-panic|3|04-escrita/dont-panic
meteorites|3|04-escrita/meteorites
census|4|05-views/census
private|4|05-views/private
bnb|4|05-views/bnb
snap|5|06-otimizacao/snap
harvard|5|06-otimizacao/harvard
dont-panic-python|6|07-escala/dont-panic-python
"
# atl, connect, donuts e connect-mysql não têm banco de distribuição:
# o banco é criado a partir de schema.sql (+ dados_exemplo.sql).
# deep é uma resposta dissertativa (answers.md).

for cmd in curl unzip; do
    command -v "$cmd" >/dev/null || { echo "Erro: '$cmd' não encontrado." >&2; exit 1; }
done

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "$PROBLEMAS" | while IFS='|' read -r nome semana pasta; do
    [ -z "$nome" ] && continue
    [ $# -gt 0 ] && [ "$1" != "$nome" ] && continue

    destino="$RAIZ/$pasta"
    echo "→ $nome"
    curl -fsSL "$CDN/$semana/$nome.zip" -o "$TMP/$nome.zip"
    # -j descarta a pasta interna do zip; -o sobrescreve sem perguntar.
    # O código 11 só indica que um dos padrões não existe naquele zip.
    unzip -joq "$TMP/$nome.zip" '*.db' '*.csv' -d "$destino" 2>/dev/null \
        || [ $? -eq 11 ]
done

echo "Pronto. Rode ./scripts/verificar.sh para conferir as soluções."
