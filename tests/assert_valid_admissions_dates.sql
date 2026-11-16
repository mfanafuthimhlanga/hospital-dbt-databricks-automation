SELECT * 
FROM {{ ref('silver_admissions') }}

WHERE discharge_date < admission_date