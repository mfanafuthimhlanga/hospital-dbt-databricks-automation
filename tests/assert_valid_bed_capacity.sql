SELECT *
FROM {{ ref('silver_admissions') }}

WHERE total_beds < 0