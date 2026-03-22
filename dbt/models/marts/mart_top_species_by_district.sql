WITH source AS (
    SELECT * FROM {{ ref('stg_crops_district_production') }}
),

aggregated AS (
    SELECT
        DATE_PART('year', date)::INT   AS year,
        state,
        district,
        crop_type,
        crop_species,
        SUM(production)                AS total_production
    FROM source
    GROUP BY 1, 2, 3, 4, 5
),

ranked AS (
    SELECT *,
        RANK() OVER (
            PARTITION BY year, district
            ORDER BY total_production DESC
        ) AS rank
    FROM aggregated
)

SELECT * FROM ranked WHERE rank = 1
