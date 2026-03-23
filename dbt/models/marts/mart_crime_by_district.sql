WITH source AS (
    SELECT * FROM {{ ref('stg_crime_district') }}
),

aggregated AS (
    SELECT
        DATE_PART('year', date)::INT    AS year,
        state,
        district,
        category,
        SUM(crimes)                     AS total_crimes
    FROM source
    GROUP BY 1, 2, 3, 4
)

SELECT * FROM aggregated
