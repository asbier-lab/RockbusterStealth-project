SELECT store_id, COUNT(*) AS count
FROM customer
GROUP BY store_id
ORDER BY count DESC
LIMIT 1;
