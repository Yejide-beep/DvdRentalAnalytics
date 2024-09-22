with countries AS (
    select * from {{ source('dvd_rental', 'country')}}
),

countries_salesandcustomerbased_info as (
SELECT country, COUNT(DISTINCT customer_id) AS customer_base, SUM(amount) AS total_sales
FROM countries
JOIN {{ source('dvd_rental', 'city')}}
USING(country_id)
JOIN {{ source('dvd_rental', 'address')}}
USING(city_id)
JOIN {{ source('dvd_rental', 'customer')}}
USING(address_id)
JOIN {{ source('dvd_rental', 'payment')}}
USING(customer_id)
GROUP BY 1
ORDER BY 2 DESC
),

final as (
select * from countries_salesandcustomerbased_info
)

select * from final

