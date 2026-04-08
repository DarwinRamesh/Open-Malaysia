WITH base AS (
    SELECT * FROM {{ ref('stg_labour_force_monthly') }}
),
enriched AS (
    SELECT
        date,
        EXTRACT(YEAR FROM date)                   AS year,
        EXTRACT(MONTH FROM date)                  AS month_num,
        TO_CHAR(date, 'Mon YYYY')                 AS month_label,
        unemployment_rate,
        participation_rate,
        unemployed_labour_force,
        labour_force,
        unemployment_rate - LAG(unemployment_rate)
            OVER (ORDER BY date)                  AS unemployment_monthly_change
    FROM base
)
SELECT * FROM enriched
ORDER BY date
