WITH source AS (
  SELECT * FROM raw.crime_district
),

renamed AS (
  SELECT
    date,
    state,
    district,
    category,
    type,
    crimes 
  FROM source
  WHERE state != 'Malaysia'
  AND district != 'All'
)

Select * FROM renamed
