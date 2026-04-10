WITH base AS (
    SELECT * FROM {{ ref('stg_cpi_core') }}
),

enriched AS (
    SELECT
        date,
        division,
        index
    FROM base
)

SELECT * FROM enriched
ORDER BY date