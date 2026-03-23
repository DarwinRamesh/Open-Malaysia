WITH source AS (
    SELECT * FROM {{ ref('stg_crime_district') }}
),

aggregated AS (
    SELECT
        DATE_PART('year', date)::INT    AS year,
        category,
        SUM(crimes)                     AS total_crimes
    FROM source
    GROUP BY 1, 2
)

SELECT * FROM aggregated
