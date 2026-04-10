WITH source AS (
    SELECT * FROM raw.cpi_core
),

renamed AS (
    SELECT
        date,
        division,
        index
    FROM source
)

SELECT * FROM renamed
