WITH source AS (
  SELECT * FROM {{ ref('pivoted_sysselsetting') }}
),
calculated AS (
  SELECT 
    region,
    kjonn,
    alder,
    tid,
    sysselsatte_bosatt_i_kommunen,
    befolkning,
    sysselsatte_i_kommunen,
    CASE WHEN befolkning > 0 THEN sysselsatte_bosatt_i_kommunen::float / befolkning::float ELSE NULL END AS arbeidsmarkedsdeltagelse,
    CASE WHEN sysselsatte_i_kommunen > 0 THEN sysselsatte_bosatt_i_kommunen::float / sysselsatte_i_kommunen::float ELSE NULL END AS sysselsettingsbalanse
  FROM source
),
ordered AS (
  SELECT *,
  LAG(arbeidsmarkedsdeltagelse) OVER (PARTITION BY region, kjonn, alder ORDER BY tid) AS forrige_periode_arbeidsmarkedsdeltagelse
  FROM calculated
),
final AS (
  SELECT *,
  arbeidsmarkedsdeltagelse - COALESCE(forrige_periode_arbeidsmarkedsdeltagelse, arbeidsmarkedsdeltagelse) AS endring_i_sysselsettingsrate
  FROM ordered
)
SELECT * FROM final