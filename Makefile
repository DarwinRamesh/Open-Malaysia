include .env
export

dbt-run:
	cd dbt && dbt run --profiles-dir .

dbt-test:
	cd dbt && dbt test --profiles-dir .

ingest:
	python ingestion/ingest.py
