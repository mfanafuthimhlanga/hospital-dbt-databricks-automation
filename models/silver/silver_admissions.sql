{{ config(materialized='table') }}

WITH source_data AS (

    SELECT *
    FROM {{ source('hospital', 'raw_admissions') }}

),

valid_records AS (

    SELECT *
    FROM source_data

    WHERE admissions_id IS NOT NULL
        AND patient_id IS NOT NULL
        AND admission_date IS NOT NULL
        AND department_id IS NOT NULL

        AND (
            discharge_date IS NULL
            OR discharge_date >= admission_date
        )  

),

deduplicated AS (

    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY admissions_id
            ORDER BY ingested_at DESC, patient_id
        ) AS row_num

    FROM valid_records

)

SELECT 
    admissions_id,
    patient_id,
    INITCAP(TRIM(department)) AS department,
    admission_date,
    discharge_date

FROM deduplicated

WHERE row_num = 1