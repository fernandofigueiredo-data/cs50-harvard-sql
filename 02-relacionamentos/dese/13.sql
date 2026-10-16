SELECT "districts"."name" AS "district",
       "schools"."name" AS "school",
       "graduation_rates"."graduated",
       "staff_evaluations"."proficient",
       ROUND(("graduation_rates"."graduated" +  "staff_evaluations"."proficient") / 2, 2)
       AS "School Performance Index"
FROM "districts"
JOIN "schools"
    ON "schools"."district_id" = "districts"."id"
JOIN "graduation_rates"
    ON "graduation_rates"."school_id" = "schools"."id"
JOIN "staff_evaluations"
    ON "staff_evaluations"."district_id" = "districts"."id"
WHERE "schools"."type" = 'Public School'
ORDER BY "School Performance Index" DESC
LIMIT 10;
