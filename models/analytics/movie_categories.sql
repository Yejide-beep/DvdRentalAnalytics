
with film_duration as (
    select film_id, title, length,
      CASE
      WHEN length < 50 THEN 'short'
      WHEN length > 50 AND LENGTH < 120 THEN 'medium'
      WHEN length > 120 THEN 'long'
      END  AS film_category
      FROM {{ source('dvd_rental', 'film') }}
    )
      

select * from film_duration