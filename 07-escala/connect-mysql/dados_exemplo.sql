-- Dados de exemplo do enunciado (MySQL 8.0), para provar que o schema os representa.
-- Uso: ver scripts/verificar_mysql.sh

INSERT INTO users (first_name, last_name, username, password)
VALUES ('Claudine', 'Gay', 'claudine', 'password'),
       ('Reid', 'Hoffman', 'reid', 'password');

INSERT INTO schools (name, type, location, founded_year)
VALUES ('Harvard University', 'Higher Education', 'Cambridge, Massachusetts', 1636);

INSERT INTO companies (name, industry, location)
VALUES ('LinkedIn', 'Technology', 'Sunnyvale, California');

INSERT INTO school_affiliations (user_id, school_id, start_date, end_date, degree)
SELECT users.id, schools.id, '1993-01-01', '1998-12-31', 'PhD'
FROM users, schools
WHERE users.username = 'claudine' AND schools.name = 'Harvard University';

INSERT INTO company_affiliations (user_id, company_id, start_date, end_date, title)
SELECT users.id, companies.id, '2003-01-01', '2007-02-01', 'CEO and Chairman'
FROM users, companies
WHERE users.username = 'reid' AND companies.name = 'LinkedIn';

INSERT INTO connections (user_id_1, user_id_2)
SELECT MIN(id), MAX(id) FROM users WHERE username IN ('claudine', 'reid');
