CREATE TABLE "ingredients" (
    "id" INTEGER,
    "name" TEXT,
    "price_per_unit" NUMERIC NOT NULL,
    "unit" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "donuts" (
    "id" INTEGER,
    "name" TEXT,
    "gluten_free" TEXT NOT NULL
        CHECK ("gluten_free" IN ('yes', 'no')),
    "price" NUMERIC,
    PRIMARY KEY ("id")
);

CREATE TABLE "donuts_ingredients" (
    "ingredient_id" INTEGER,
    "donut_id" INTEGER,
    PRIMARY KEY ("ingredient_id", "donut_id"),
    FOREIGN KEY ("ingredient_id") REFERENCES "ingredients"("id"),
    FOREIGN KEY ("donut_id") REFERENCES "donuts"("id")
);

CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    PRIMARY KEY ("id")
);

CREATE TABLE "orders" (
    "id" INTEGER,
    "customer_id" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id")
);

CREATE TABLE "orders_donuts" (
    "order_id" INTEGER,
    "donut_id" INTEGER,
    "quantity" INTEGER NOT NULL,
    PRIMARY KEY ("order_id", "donut_id"),
    FOREIGN KEY ("order_id") REFERENCES "orders"("id"),
    FOREIGN KEY ("donut_id") REFERENCES "donuts"("id")
);
