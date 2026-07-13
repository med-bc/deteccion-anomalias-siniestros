CREATE TABLE `dev-claims-01.datalab_claims.gold_features`
AS
WITH eventos_pivot AS (
  SELECT
    case_id,
    MAX(claim_amount)                    AS claim_amount,
    MAX(claimant_age)                    AS claimant_age,
    MAX(type_of_policy)                  AS type_of_policy,
    MAX(car_make)                        AS car_make,
    MAX(car_year)                        AS car_year,
    MAX(type_of_accident)                AS type_of_accident,
    COUNT(*)                             AS num_eventos,
    COUNTIF(user_type = 'RPA')           AS num_eventos_rpa,

    -- Posición de cada actividad clave
    MAX(CASE WHEN activity_name = 'First Notification of Loss (FNOL)'
        THEN orden_actividad END)        AS posicion_fnol,
    MAX(CASE WHEN activity_name = 'Assign Claim'
        THEN orden_actividad END)        AS posicion_assign,
    MAX(CASE WHEN activity_name = 'Claim Decision'
        THEN orden_actividad END)        AS posicion_decision,
    MAX(CASE WHEN activity_name = 'Set Reserve'
        THEN orden_actividad END)        AS posicion_reserve,
    MAX(CASE WHEN activity_name = 'Payment Sent'
        THEN orden_actividad END)        AS posicion_pago,
    MAX(CASE WHEN activity_name = 'Close Claim'
        THEN orden_actividad END)        AS posicion_cierre,

    -- Timestamps de actividades clave
    MIN(CASE WHEN activity_name = 'First Notification of Loss (FNOL)'
        THEN timestamp END)              AS ts_fnol,
    MIN(CASE WHEN activity_name = 'Payment Sent'
        THEN timestamp END)              AS ts_pago,
    MIN(CASE WHEN activity_name = 'Claim Decision'
        THEN timestamp END)              AS ts_decision,

    -- Duración total
    TIMESTAMP_DIFF(
      MAX(timestamp), MIN(timestamp), DAY
    )                                    AS duracion_total_dias

  FROM `dev-claims-01.datalab_claims.silver_eventos`
  GROUP BY case_id
)

SELECT
  case_id,
  claim_amount,
  claimant_age,
  type_of_policy,
  car_make,
  car_year,
  type_of_accident,
  num_eventos,
  num_eventos_rpa,
  posicion_fnol,
  posicion_assign,
  posicion_decision,
  posicion_reserve,
  posicion_pago,
  posicion_cierre,
  duracion_total_dias,

  -- Features derivados clave para el modelo
  TIMESTAMP_DIFF(ts_pago, ts_fnol, DAY)      AS dias_fnol_a_pago,
  TIMESTAMP_DIFF(ts_pago, ts_decision, DAY)  AS dias_decision_a_pago,
  CASE WHEN posicion_fnol < posicion_pago
       THEN 1 ELSE 0 END                     AS fnol_antes_pago,
  CASE WHEN num_eventos_rpa > 0
       THEN 1 ELSE 0 END                     AS tiene_rpa,

  -- LABEL: es happy path?
  CASE
    WHEN posicion_fnol = 1
     AND posicion_assign = 2
     AND posicion_decision = 3
     AND posicion_reserve = 4
     AND posicion_pago = 5
     AND posicion_cierre = 6
    THEN 1 ELSE 0
  END                                        AS es_happy_path

FROM eventos_pivot