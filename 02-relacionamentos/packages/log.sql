
-- *** The Lost Letter ***

SELECT *
FROM "packages"
WHERE "contents" LIKE '%congratulatory%';

-- id: 384
-- #from_address_id: 432
-- #to_address_id: 854

SELECT *
FROM "scans"
WHERE "package_id" = 384;

SELECT "address", "type"
FROM "addresses"
WHERE "id" = 854;

-- *** The Devious Delivery ***

SELECT *
FROM "packages"
WHERE "from_address_id" IS NULL;

-- id: 5098
-- contents: Duck debugger
-- to_address_id: 50

SELECT *
FROM "scans"
WHERE "package_id" = 5098;

-- Drop: (id: 30140 / adreed_id: 348)

SELECT *
FROM "addresses"
WHERE "id" = 348;

-- id: 348
-- address: 7 Humboldt Place
-- type: Police Station

-- *** The Forgotten Gift ***

SELECT *
FROM "addresses"
WHERE "address" = '109 Tileston Street';

-- 9873 | 109 Tileston Street | Residential
-- id_address: 9873

SELECT *
FROM "packages"
WHERE "from_address_id" = 9873;

-- 9523 | Flowers | 9873 | 4983
-- id_package = 9523

SELECT *
FROM "scans"
WHERE "package_id" = 9523;

-- id   | driver_id | package_id | address_id | action |         timestamp          |
-- +-------+-----------+------------+------------+--------+----------------------------+
-- | 10432 |        11 |       9523 |       9873 | Pick   | 2023-08-16 21:41:43.219831 |
-- | 10500 |        11 |       9523 |       7432 | Drop   | 2023-08-17 03:31:36.856889 |
-- | 12432 |        17 |       9523 |       7432 | Pick   | 2023-08-23 19:41:47.913410

SELECT *
FROM "addresses"
WHERE "id" = 7432;

-- 7432 | 950 Brannon Harris Way | Warehouse

SELECT "name"
FROM "drivers"
WHERE "id" = 17;

--Mikel
