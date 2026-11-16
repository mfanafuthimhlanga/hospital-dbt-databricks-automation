{{ config(materialized='table') }}

WITH admissions AS (

    SELECT
        admission_date AS activity_date,
        COUNT(*) AS admissions,
        0 AS discharges
    
    FROM {{ ref('silver_admissions') }}

    GROUP BY admission_date
),

discharges AS (

    SELECT
        discharge_date AS activity_date,
        0 AS admissions,
        COUN(*) AS discharges
    
    FROM {{ ref('silver_admissions') }}

    WHERE discharge_date IS NOT NULL

    GROUP BY discharge_date
),

combined AS (
    SELECT * FROM admissions
    UNION ALL
    SELECT * FROM discharges
)

SELECT 
    activity_date,
    SUM(admissions) AS total_admissions,
    SUM(discharges) AS total_discharges

FROM combined

GROUP BY discharge_date

