with avg_rental_rate_query as (
SELECT AVG (rental_rate) as avg_rent_rate
FROM {{ source('dvd_rental', 'film')}}
),
final as (
SELECT film_id, title 
FROM {{ source('dvd_rental', 'film')}}
WHERE rental_rate > (select avg_rent_rate from avg_rental_rate_query)
)
select * from final
limit 10

