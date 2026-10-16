SELECT "city", COUNT(*) AS "Number of Public Schools"
FROM "schools"
WHERE "type" = 'Public School'
GROUP BY "city"
HAVING COUNT(*) <= 3
ORDER BY "Number of Public Schools" DESC, "city";
