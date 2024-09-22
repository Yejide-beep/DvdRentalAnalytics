select *
from {{ source('dvd_rental', 'customer')}}
where active = 1

            
