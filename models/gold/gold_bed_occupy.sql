{{ config(materialized='table') }}

WITH reporting_date AS (

    SELECT DATE '2026-10-24' AS report_date

),

occipied AS (

    SELECT  
        a.department,
        COUNT(*) AS occupied_beds

    FROM {{ ref('silver_admissions')}}
    CROSS JOIN reporting_date

    WHERE a.department_date = r.report_date

        AND (
            a.discharge_date IS NULL
            OR r.discharge_date > r.report_date
        )

    GROUP BY a.department

)

SELECT 
    r.report_date,
    c.department,
    c.total_beds

    COALESCE(o.occupied_beds, 0) AS occiped_beds,

    c.total_beds -
    COALESCE(o.occupied_beds, 0) AS available_beds,

    ROUND(
        COALESCE(o.occiped_beds, 0) * 100.0
        / NULLIF(c.total_beds, 0)
    ) AS occupancy_rate
FROM {{ ref('silver_bed_capacity') }} c
CROSS JOIN reporting_date r

LEFT JOIN occipied o
    On c.department = o.department