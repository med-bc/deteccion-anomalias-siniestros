SELECT
  case_id,
  claim_amount,
  type_of_accident,
  duracion_total_dias,
  predicted_es_happy_path,
  ROUND(p.prob, 4) AS probabilidad_anomalia
FROM ML.PREDICT(
  MODEL `datalab-interseguro.insurance_claims.modelo_anomalias`,
  (SELECT * FROM `datalab-interseguro.insurance_claims.gold_features`)
),
UNNEST(predicted_es_happy_path_probs) p
WHERE p.label = 0
ORDER BY probabilidad_anomalia DESC
LIMIT 20