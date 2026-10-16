CREATE TABLE "passengers" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "age" INTEGER,
    PRIMARY KEY ("id")
);

CREATE TABLE "check_ins" (
    "id" INTEGER,
    "passenger_id" INTEGER,
    "flight_id" INTEGER,
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("passenger_id") REFERENCES "passengers"("id"),
    FOREIGN KEY ("flight_id") REFERENCES "flights"("id")
);

CREATE TABLE "airlines" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE "airline_concourses" (
    "airline_id" INTEGER,
    "concourse" TEXT NOT NULL CHECK ("concourse" IN ('A', 'B', 'C', 'D', 'E', 'F', 'T')),
    PRIMARY KEY ("airline_id", "concourse"),
    FOREIGN KEY ("airline_id") REFERENCES "airlines"("id")
);

CREATE TABLE "flights" (
    "id" INTEGER,
    "flight_number" INTEGER NOT NULL,
    "airline_id" INTEGER NOT NULL,
    "departure_airport" TEXT NOT NULL,
    "arrival_airport" TEXT NOT NULL,
    "datetime_departure" NUMERIC NOT NULL,
    "datetime_arrival" NUMERIC NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("airline_id") REFERENCES "airlines"("id")
);
