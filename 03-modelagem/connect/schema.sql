CREATE TABLE "users" (
    "id" INTEGER,
    "first_name" TEXT,
    "last_name" TEXT,
    "username" TEXT,
    "password" TEXT,
    PRIMARY KEY ("id")
);

CREATE TABLE "schools" (
    "id" INTEGER,
    "name" TEXT,
    "type" TEXT,
    "location" TEXT,
    "year_founded" NUMERIC,
    PRIMARY KEY ("id")
);

CREATE TABLE "users_schools" (
    "id" INTEGER,
    "user_id" INTEGER,
    "school_id" INTEGER,
    "start_date" TEXT NOT NULL,
    "end_date" TEXT,
    "degree" TEXT NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("school_id") REFERENCES "schools"("id")
);

CREATE TABLE "companies" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "industry" TEXT,
    "location" TEXT,
    PRIMARY KEY ("id")
);

CREATE TABLE "users_companies" (
    "id" INTEGER,
    "user_id" INTEGER,
    "company_id" INTEGER,
    "start_date" TEXT NOT NULL,
    "end_date" TEXT,
    "title" TEXT NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("id")
);

CREATE TABLE "connections" (
    "user_id" INTEGER,
    "connected_user_id" INTEGER,
    PRIMARY KEY ("user_id", "connected_user_id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("connected_user_id") REFERENCES "users"("id"),
    CHECK ("user_id" < "connected_user_id")
);

