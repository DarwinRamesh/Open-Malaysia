WITH source AS (
    SELECT * FROM raw.cpi_core
),

renamed AS (
    SELECT
        date,
        CASE division
            WHEN '01' THEN 'food_beverage'
            WHEN '02' THEN 'alcohol_tobacco'
            WHEN '03' THEN 'clothing_footwear'
            WHEN '04' THEN 'housing_utilities'
            WHEN '05' THEN 'furnishings'
            WHEN '06' THEN 'health'
            WHEN '07' THEN 'transport'
            WHEN '08' THEN 'communication'
            WHEN '09' THEN 'recreation_culture'
            WHEN '10' THEN 'education'
            WHEN '11' THEN 'hospitality'
            WHEN '12' THEN 'insurance_finance'
            WHEN '13' THEN 'personal_care_misc'
            ELSE division
        END AS division,
        index
    FROM source
)

SELECT * FROM renamed
