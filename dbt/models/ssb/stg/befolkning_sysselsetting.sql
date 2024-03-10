WITH source AS (
  SELECT * FROM {{ source('ssb', 'befolkning_sysselsetting') }}
)
SELECT * FROM source
