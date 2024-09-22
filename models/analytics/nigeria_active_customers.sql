with customers as (
    select * from {{ source('dvd_rental', 'customer')}}
),


--  active_customers as ( 
--     select first_name, last_name, email, active, address_id
--     from customers
--     where active = 1
-- ),

customer_address_info  as (
    SELECT first_name, last_name, email, active, phone, country
    FROM customers
    JOIN {{ source('dvd_rental', 'address') }}
    USING (address_id)
    JOIN {{ source('dvd_rental', 'city') }} 
    USING (city_id)
    join {{ source('dvd_rental', 'country') }} 
    USING (country_id)
    ),

nigeria_active_customers as (
    select * from  customer_address_info 
    where country in ('Nigeria') AND active = 1
)  

select * from nigeria_active_customers 
