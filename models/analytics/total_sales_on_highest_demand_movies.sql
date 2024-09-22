WITH q1 AS (SELECT c.name AS genre, count(cs.customer_id) AS total_rent_demand
           FROM {{ source('dvd_rental', 'category') }} c
           JOIN {{ source('dvd_rental', 'film_category') }} fc
           USING(category_id)
           JOIN {{ source('dvd_rental', 'film') }} f
           USING(film_id)
           JOIN {{ source('dvd_rental', 'inventory') }} i
           USING(film_id)
           JOIN {{ source('dvd_rental', 'rental') }} r
           USING(inventory_id)
           JOIN {{ source('dvd_rental', 'customer') }} cs
           USING(customer_id)
           GROUP BY 1),

    q2 AS (SELECT c.name AS genre, SUM(p.amount) AS total_sales
          FROM {{ source('dvd_rental', 'category') }} c
          JOIN {{ source('dvd_rental', 'film_category') }} fc
          USING(category_id)
          JOIN {{ source('dvd_rental', 'film') }} f
          USING(film_id)
          JOIN {{ source('dvd_rental', 'inventory') }} i
          USING(film_id)
          JOIN {{ source('dvd_rental', 'rental') }} r
          USING(inventory_id)
          JOIN {{ source('dvd_rental', 'payment') }} p
          USING(rental_id)
          GROUP BY 1
          ORDER BY 2 DESC)
   SELECT q1.genre, q1.total_rent_demand, q2.total_sales
    FROM q1
    JOIN q2
    ON q1.genre = q2.genre
    order by q1.total_rent_demand desc
    limit 10