WITH base AS (
    SELECT * FROM {{ ref('stg_cpi_headline') }}
),

enriched AS (
    SELECT
        date,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month,
        division,
        index,
        index - LAG(index)
            OVER (ORDER BY date) AS index_monthly_change
    FROM base
)

SELECT * FROM enriched
ORDER BY date
