SELECT 
    outer_query.country,
    COUNT(DISTINCT outer_query.customer_id) AS all_customer_count,
    COUNT(DISTINCT top_5.customer_id) AS top_customer_count
FROM (
    SELECT 
        A.customer_id,
        D.country
    FROM customer A
    INNER JOIN address B ON A.address_id = B.address_id
    INNER JOIN city C ON B.city_id = C.city_id
    INNER JOIN country D ON C.country_id = D.country_id
) AS outer_query
**RIGHT** JOIN (
    SELECT 
        A.customer_id,
        A.first_name,
        A.last_name,
        D.country,
        C.city,
        SUM(F.amount) AS total_paid
    FROM customer A
    INNER JOIN address B ON A.address_id = B.address_id
    INNER JOIN city C ON B.city_id = C.city_id
    INNER JOIN country D ON C.country_id = D.country_id
    INNER JOIN payment F ON A.customer_id = F.customer_id
    WHERE C.city IN (
        SELECT C.city
        FROM customer A
        INNER JOIN address B ON A.address_id = B.address_id
        INNER JOIN city C ON B.city_id = C.city_id
        INNER JOIN country D ON C.country_id = D.country_id
        WHERE D.country IN (
            SELECT D.country
            FROM customer A
            INNER JOIN address B ON A.address_id = B.address_id
            INNER JOIN city C ON B.city_id = C.city_id
            INNER JOIN country D ON C.country_id = D.country_id
            GROUP BY D.country
            ORDER BY COUNT(A.customer_id) DESC
            LIMIT 10
        )
        GROUP BY D.country, C.city
        ORDER BY COUNT(A.customer_id) DESC
        LIMIT 10
    )
    GROUP BY A.customer_id, A.first_name, A.last_name, D.country, C.city
    ORDER BY total_paid DESC
    LIMIT 5
) AS top_5
ON outer_query.country = top_5.country
GROUP BY outer_query.country;
