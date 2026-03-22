WITH source AS (
    SELECT * FROM raw.crops_district_production
),

renamed AS (
    SELECT
        date,
        state,
        district,
        crop_type,
        crop_species,
        production
    FROM source
)

SELECT * FROM renamed
