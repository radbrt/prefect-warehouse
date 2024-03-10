WITH befolkning_sysselsetting AS (
  SELECT * FROM {{ ref('befolkning_sysselsetting') }}
),
pivoted_data AS (
  SELECT
    region,
    kjonn,
    alder,
    tid,
    MAX(
      CASE WHEN contentscode = 'Employed persons by place of residence' THEN value ELSE NULL END
    ) AS sysselsatte_bosatt_i_kommunen,
    MAX(
      CASE WHEN contentscode = 'Population by place of residence' THEN value ELSE NULL END
    ) AS befolkning,
    MAX(
      CASE WHEN contentscode = 'Employed persons by place of work' THEN value ELSE NULL END
    ) AS sysselsatte_i_kommunen
  FROM befolkning_sysselsetting
  GROUP BY 1,2,3,4
)
SELECT * FROM pivoted_data