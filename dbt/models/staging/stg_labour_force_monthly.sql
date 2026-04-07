WITH source AS (
    SELECT * FROM raw.lfs_month_sa
),

renamed AS (
    SELECT
        date,
        lf as Labour_Force,
        lf_employed as Employed_Labour_Force,
        lf_unemployed as Unemployed_Labour_Force,
        p_rate as Participation_Rate,
        u_rate as Unemployment_Rate
    FROM source
)

SELECT * FROM renamed
