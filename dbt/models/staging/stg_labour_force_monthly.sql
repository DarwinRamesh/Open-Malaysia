WITH source AS (
    SELECT * FROM raw.lfs_month_sa
),

renamed AS (
    SELECT
        date,
        lf,
        lf_employed,
        lf_unemployed,
        p_rate,
        u_rate
    FROM source
)

SELECT * FROM renamed
