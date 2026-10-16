-- Dados de exemplo do enunciado, para provar que o schema os representa.
-- Uso: sqlite3 connect.db ".read schema.sql" ".read dados_exemplo.sql"

INSERT INTO "users" ("first_name", "last_name", "username", "password")
VALUES ('Alan', 'Garber', 'alan', 'password'),
       ('Reid', 'Hoffman', 'reid', 'password');

INSERT INTO "schools" ("name", "type", "location", "year_founded")
VALUES ('Harvard University', 'University', 'Cambridge, Massachusetts', 1636);

INSERT INTO "companies" ("name", "industry", "location")
VALUES ('LinkedIn', 'Technology', 'Sunnyvale, California');

INSERT INTO "users_schools" ("user_id", "school_id", "start_date", "end_date", "degree")
SELECT "users"."id", "schools"."id", '1973-09-01', '1976-06-01', 'BA'
FROM "users", "schools"
WHERE "users"."username" = 'alan' AND "schools"."name" = 'Harvard University';

INSERT INTO "users_companies" ("user_id", "company_id", "start_date", "end_date", "title")
SELECT "users"."id", "companies"."id", '2003-01-01', '2007-02-01', 'CEO and Chairman'
FROM "users", "companies"
WHERE "users"."username" = 'reid' AND "companies"."name" = 'LinkedIn';

-- Conexão mútua: o CHECK ("user_id" < "connected_user_id") guarda cada par uma única vez
INSERT INTO "connections" ("user_id", "connected_user_id")
SELECT MIN("id"), MAX("id") FROM "users" WHERE "username" IN ('alan', 'reid');
