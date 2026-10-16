-- Dados de exemplo do enunciado, para provar que o schema os representa.
-- Uso: sqlite3 donuts.db ".read schema.sql" ".read dados_exemplo.sql"
-- Só cacau e açúcar têm preço no enunciado; os demais valores são ilustrativos.

INSERT INTO "ingredients" ("name", "price_per_unit", "unit")
VALUES ('Cocoa', 5.00, 'pound'),
       ('Sugar', 2.00, 'pound'),
       ('Flour', 1.50, 'pound'),
       ('Buttermilk', 3.00, 'quart'),
       ('Sprinkles', 4.00, 'pound');

INSERT INTO "donuts" ("name", "gluten_free", "price")
VALUES ('Belgian Dark Chocolate', 'no', 4.00),
       ('Back-To-School Sprinkles', 'no', 4.00);

INSERT INTO "donuts_ingredients" ("donut_id", "ingredient_id")
SELECT "donuts"."id", "ingredients"."id"
FROM "donuts", "ingredients"
WHERE ("donuts"."name" = 'Belgian Dark Chocolate'
       AND "ingredients"."name" IN ('Cocoa', 'Flour', 'Buttermilk', 'Sugar'))
   OR ("donuts"."name" = 'Back-To-School Sprinkles'
       AND "ingredients"."name" IN ('Flour', 'Buttermilk', 'Sugar', 'Sprinkles'));

INSERT INTO "customers" ("first_name", "last_name") VALUES ('Luis', 'Singh');

INSERT INTO "orders" ("id", "customer_id")
SELECT 1, "id" FROM "customers" WHERE "first_name" = 'Luis' AND "last_name" = 'Singh';

INSERT INTO "orders_donuts" ("order_id", "donut_id", "quantity")
SELECT 1, "id", CASE "name" WHEN 'Belgian Dark Chocolate' THEN 3 ELSE 2 END
FROM "donuts"
WHERE "name" IN ('Belgian Dark Chocolate', 'Back-To-School Sprinkles');
