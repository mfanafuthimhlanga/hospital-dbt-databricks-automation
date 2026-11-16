SELECT *
FROM {{ ref('gold_bed_occupancy') }}

WHERE occiped_beds > total_beds
    OR occiped_beds < 0
    OR available_beds < 0

