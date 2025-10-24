SELECT *
FROM film
WHERE title IS NULL OR description IS NULL OR release_year IS NULL 
      OR rental_rate IS NULL OR length IS NULL;
