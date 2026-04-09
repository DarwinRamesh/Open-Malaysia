WITH source AS (
    SELECT * FROM raw.cpi_headline
),

renamed AS (
    SELECT
        date,
        division,
        index
    FROM source
)

SELECT * FROM renamed
