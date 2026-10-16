# Don't Panic! (Python)

**Etapa 7 · Escala** · [Enunciado oficial](https://cs50.harvard.edu/sql/psets/6/dont-panic/python/)

Python + SQL · biblioteca `cs50` · consultas parametrizadas (*prepared statements*) · prevenção de SQL injection

## Contexto

Continuação do [Don't Panic! da Etapa 4](../../04-escrita/dont-panic/). Depois do primeiro pentest, a tarefa agora é **automatizar** o ataque: um programa em Python que se conecta ao mesmo banco SQLite e troca a senha do administrador pela senha que o operador digitar.

## Problema a resolver

Escrever [`hack.py`](hack.py), que:

1. conecta ao banco `dont-panic.db` pela biblioteca `cs50`;
2. pede uma senha ao usuário;
3. atualiza a senha da conta `admin` com esse valor.

## Solução

```python
from cs50 import SQL

db = SQL("sqlite:///dont-panic.db")

password = input("Enter a password: ")

db.execute(
    """
    UPDATE "users"
    SET "password" = ?
    WHERE "username" = 'admin';
    """,
    password
)
```

## Destaques

- **Placeholder `?` em vez de montar a string.** O valor digitado vai como parâmetro separado, e o driver garante que ele seja tratado como **dado**, nunca como parte do comando. Com uma f-string (`f"... SET password = '{password}' ..."`), alguém que digitasse `x' --` transformaria o resto da consulta em comentário (`SET password = 'x' --' WHERE username = 'admin'`) e trocaria a senha de **todos** os usuários. É a defesa padrão contra SQL injection.
- **O SQL continua legível.** A string de várias linhas mantém a consulta formatada como num arquivo `.sql`.

## Como executar

```bash
pip install cs50
python hack.py
```

Para voltar o banco ao estado original:

```bash
sqlite3 dont-panic.db ".read reset.sql"
```

## Limitações

- A senha é gravada **em texto puro**. O enunciado não pede hash, mas o resto da tabela guarda MD5, então o admin ficaria com um formato diferente dos demais usuários. Uma versão consistente gravaria `hashlib.md5(password.encode()).hexdigest()`, e uma versão segura de verdade usaria bcrypt ou Argon2.
- O programa não confirma o resultado (por exemplo, `print("Hacked!")` ou o número de linhas afetadas, que `db.execute` devolve num `UPDATE`).
- [`scripts/verificar.sh`](../../scripts/verificar.sh) confere só a sintaxe do `hack.py`, porque a biblioteca `cs50` não faz parte dos pré-requisitos do repositório.
