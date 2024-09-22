with q1 AS (SELECT inventory_id,
            DATEDIFF ('day', return_date , rental_date) AS date_difference
            FROM {{ source('dvd_rental', 'rental')}}
           ),

q2 AS (SELECT f.film_id,
      CASE 
          WHEN rental_duration > date_difference THEN 'Returned early'
          WHEN rental_duration = date_difference THEN 'Returned on time'
          ELSE 'Returned late'
      END AS return_status
      FROM {{ source('dvd_rental', 'film')}} AS f
      JOIN {{ source('dvd_rental', 'inventory')}}
      USING(film_id)
      JOIN q1 
      USING(inventory_id)
      ),

performance_report AS (SELECT 
return_status, count(film_id) as total_films
from q2
group by return_status
)

select * from performance_report