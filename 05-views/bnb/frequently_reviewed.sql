CREATE VIEW "frequently_reviewed" AS
SELECT
    "listings"."id",
    "listings"."property_type",
    "listings"."host_name",
    COUNT("reviews"."id") AS "reviews"
FROM "listings"
JOIN "reviews"
    ON "reviews"."listing_id" = "listings"."id"
GROUP BY
    "listings"."id",
    "listings"."property_type",
    "listings"."host_name"
ORDER BY "reviews" DESC, "property_type", "host_name"
LIMIT 100;
