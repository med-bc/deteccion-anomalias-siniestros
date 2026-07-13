CREATE OR REPLACE TABLE `dev-claims-01.datalab_claims.silver_eventos`
PARTITION BY DATE(timestamp)
CLUSTER BY case_id, activity_name
AS
SELECT
  case_id,
  TRIM(activity_name)        AS activity_name,
  TIMESTAMP(timestamp)       AS timestamp,
  TRIM(claimant_name)        AS claimant_name,
  TRIM(agent_name)           AS agent_name,
  TRIM(adjuster_name)        AS adjuster_name,
  CAST(claim_amount AS FLOAT64) AS claim_amount,
  CAST(claimant_age AS INT64)   AS claimant_age,
  TRIM(type_of_policy)       AS type_of_policy,
  TRIM(car_make)             AS car_make,
  TRIM(car_model)            AS car_model,
  CAST(car_year AS INT64)    AS car_year,
  TRIM(type_of_accident)     AS type_of_accident,
  TRIM(user_type)            AS user_type,
  ROW_NUMBER() OVER (
    PARTITION BY case_id
    ORDER BY timestamp
  ) AS orden_actividad
FROM `dev-claims-01.datalab_claims.bronze_eventos`
WHERE case_id IS NOT NULL
  AND activity_name IS NOT NULL
  AND timestamp IS NOT NULL