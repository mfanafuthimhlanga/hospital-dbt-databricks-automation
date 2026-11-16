{{ config(materialized='table') }}

SELECT 
    INITCAP(TRIM(department)) AS department.
    CAST(total_beds AS INT) AS total_beds

FROM {{ source('hospital', 'raw_bed_capacity') }}

WHERE department IS NOT NULL
    AND total_beds >= 0