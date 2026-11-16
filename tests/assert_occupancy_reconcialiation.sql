SELECT *
FROM {{ ref('gold_bed_occupancy') }}

WHERE occiped_beds + available_beds <> total_beds