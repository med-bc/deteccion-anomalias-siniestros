LOAD DATA OVERWRITE `dev-claims-01.datalab_claims.bronze_eventos`
FROM FILES (
format = 'CSV',
uris = ['gs://insurance-claims/claims.csv'],
skip_leading_rows = 1
);