-- Quais são os títulos dos episódios da 5ª temporada que foram ao ar em 2006?
SELECT "title" FROM "episodes" WHERE "season" = 5 AND "air_date" LIKE '2006%';
