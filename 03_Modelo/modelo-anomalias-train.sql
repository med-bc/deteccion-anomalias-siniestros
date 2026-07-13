CREATE OR REPLACE MODEL 
  `dev-claims-01.datalab_claims.modelo_anomalias`
OPTIONS(
  model_type = 'BOOSTED_TREE_CLASSIFIER',
  input_label_cols = ['es_happy_path'],
  num_parallel_tree = 6,
  max_iterations = 50,
  auto_class_weights = TRUE
) AS
SELECT
  claim_amount,
  claimant_age,
  type_of_policy,
  car_make,
  car_year,
  type_of_accident,
  num_eventos_rpa,
  posicion_fnol,
  posicion_pago,
  duracion_total_dias,
  dias_fnol_a_pago,
  dias_decision_a_pago,
  fnol_antes_pago,
  tiene_rpa,
  es_happy_path
FROM `dev-claims-01.datalab_claims.gold_features`