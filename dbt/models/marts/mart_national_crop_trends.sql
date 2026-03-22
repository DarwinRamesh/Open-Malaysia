WITH source AS (
    SELECT * FROM {{ ref('stg_crops_district_production') }}
),

aggregated AS (
    SELECT
        DATE_PART('year', date)::INT   AS year,
        crop_type,
        SUM(production)                AS total_production
    FROM source
    GROUP BY 1, 2
)

SELECT * FROM aggregated
