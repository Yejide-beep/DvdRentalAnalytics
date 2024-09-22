with customers as (
    select * from {{ source('dvd_rental', 'customer')}}
),

top_loyal_customers as (
SELECT first_name ||' '|| last_name AS full_name, email, address, phone, city, country, sum(amount) AS total_purchase
FROM customers
JOIN {{ source('dvd_rental', 'address') }}
USING (address_id)
JOIN {{ source('dvd_rental', 'city') }}
USING (city_id)
JOIN {{ source('dvd_rental', 'country') }}
USING (country_id)
JOIN {{ source('dvd_rental', 'payment') }}
USING (customer_id)
GROUP BY 1, 2, 3, 4, 5, 6
ORDER BY 7 DESC
LIMIT 10
),

final AS (
SELECT * from top_loyal_customers
)

select * from final