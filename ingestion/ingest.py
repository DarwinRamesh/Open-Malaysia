import polars as pl
import psycopg
from dotenv import load_dotenv
import os

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")
PARQUET_URL = "https://storage.data.gov.my/agriculture/crops_district_production.parquet"

def get_connection():
    return psycopg.connect(DATABASE_URL)

def create_schema_and_table(conn):
    with conn.cursor() as cur:
        cur.execute("CREATE SCHEMA IF NOT EXISTS raw;")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS raw.crops_district_production (
                date            DATE,
                state           TEXT,
                district        TEXT,
                crop_type       TEXT,
                crop_species    TEXT,
                production      FLOAT,
                CONSTRAINT crops_district_production_pk
                    UNIQUE (date, state, district, crop_type, crop_species)
            );
        """)
        conn.commit()

def ingest(conn, df: pl.DataFrame):
    with conn.cursor() as cur:
        rows = df.to_dicts()
        cur.executemany("""
            INSERT INTO raw.crops_district_production
                (date, state, district, crop_type, crop_species, production) 
            VALUES
                (%(date)s, %(state)s, %(district)s, %(crop_type)s, %(crop_species)s, %(production)s)
            ON CONFLICT (date, state, district, crop_type, crop_species)
            DO UPDATE SET
                production = EXCLUDED.production;
        """, rows)
        conn.commit()
    print(f"Upserted {len(rows)} rows.")

def main():
    print("Fetching parquet...")
    df = pl.read_parquet(PARQUET_URL)
    df = df.with_columns(pl.col("date").cast(pl.Date))

    print(f"Loaded {len(df)} rows. Connecting to Postgres...")
    with get_connection() as conn:
        create_schema_and_table(conn)
        ingest(conn, df)
    print("Done.")

if __name__ == "__main__":
    main()
