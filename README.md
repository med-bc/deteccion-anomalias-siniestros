# Detección de Anomalías en Siniestros
Pipeline end-to-end en Google Cloud para detectar posibles fraudes en siniestros de seguros mediante análisis de procesos y machine learning.

## Tecnologias
GCP (BigQuery, BigQuery ML, Cloud Storage), SQL

## Arquitectura
Pipeline de datos en arquitectura Medallion (Bronze–Silver–Gold) en BigQuery, procesando ~180,000 eventos y 30,000 casos.
<img width="1029" height="619" alt="image" src="https://github.com/user-attachments/assets/7a40d794-d526-4e6d-a09b-082d94789a99" />

## Modelo
Modelo de clasificación con BigQuery ML (Boosted Trees), logrando 99.4% de precisión y 94.5% F1-score en detección de anomalías.
