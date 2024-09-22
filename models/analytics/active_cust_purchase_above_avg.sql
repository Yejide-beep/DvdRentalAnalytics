with customer_purchase as (
select customer_id, SUM(amount) AS total_purchase 
from {{ source('dvd_rental', 'payment')}}
GROUP BY 1 
HAVING (SUM(amount) >= avg(amount))
),
final as ( select first_name, last_name, email, active, total_purchase
from customer_purchase
join {{ref('stg_active_customers') }}
using (customer_id)
)

select * from final 

