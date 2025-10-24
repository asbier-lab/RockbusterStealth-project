SELECT 
    A.customer_id,
    A.first_name,
    A.last_name,
    E.country,
    D.city,
    SUM(F.amount) AS total_paid
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city D ON B.city_id = D.city_id
INNER JOIN country E ON D.country_id = E.country_id
INNER JOIN payment F ON A.customer_id = F.customer_id
WHERE D.city IN (
    SELECT C.city
    FROM customer A2
    INNER JOIN address B2 ON A2.address_id = B2.address_id
    INNER JOIN city C ON B2.city_id = C.city_id
    INNER JOIN country D2 ON C.country_id = D2.country_id
    GROUP BY C.city
    ORDER BY COUNT(A2.customer_id) DESC
    LIMIT 10
)
GROUP BY A.customer_id, A.first_name, A.last_name, E.country, D.city
ORDER BY total_paid DESC
LIMIT 5;
