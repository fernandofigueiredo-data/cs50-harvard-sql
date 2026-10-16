
SELECT "schools"."name", "expenditures"."per_pupil_expenditure", "graduation_rates"."graduated"
FROM "schools"
JOIN "graduation_rates"
    ON "graduation_rates"."school_id" = "schools"."id"
JOIN "expenditures"
    ON "expenditures"."district_id" = "schools"."district_id"
ORDER BY "expenditures"."per_pupil_expenditure" DESC, "schools"."name";
