SELECT "english_title" AS "Brightest Hokusai Prints" FROM "views"
WHERE "artist" = 'Hokusai'
ORDER BY "brightness" DESC LIMIT 5;
