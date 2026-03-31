import os

import polars as pl
import psycopg
from dotenv import load_dotenv

load_dotenv()

DATABASE_URL = os.getenv("DATABASE_URL")

DATASETS = [
    {
        "url": "https://storage.dosm.gov.my/labour/lfs_month_sa.parquet",
        "table": "raw.lfs_month_sa",
        "natural_key": ["date"],
        "value_columns": ["lf", "lf_employed", "lf_unemployed", "p_rate", "u_rate"],
        "format": "parquet",
    },
]


def get_connection():
    return psycopg.connect(DATABASE_URL)


def create_table(conn, dataset: dict, df: pl.DataFrame):
    schema, table = dataset["table"].split(".")
    all_columns = dataset["natural_key"] + dataset["value_columns"]

    col_defs = []
    for col in all_columns:
        dtype = df.schema[col]
        if dtype == pl.Date:
            pg_type = "DATE"
        elif dtype in (pl.Int32, pl.Int64):
            pg_type = "INTEGER"
        elif dtype in (pl.Float32, pl.Float64):
            pg_type = "FLOAT"
        else:
            pg_type = "TEXT"
        col_defs.append(f"{col} {pg_type}")

    constraint = ", ".join(dataset["natural_key"])
    col_defs_sql = ",\n                ".join(col_defs)

    with conn.cursor() as cur:
        cur.execute(f"CREATE SCHEMA IF NOT EXISTS {schema};")
        cur.execute(f"""
            CREATE TABLE IF NOT EXISTS {dataset["table"]} (
                {col_defs_sql},
                CONSTRAINT {table}_pk
                    UNIQUE ({constraint})
            );
        """)
        conn.commit()


def ingest(conn, dataset: dict, df: pl.DataFrame):
    all_columns = dataset["natural_key"] + dataset["value_columns"]
    cols_sql = ", ".join(all_columns)
    values_sql = ", ".join([f"%({c})s" for c in all_columns])
    updates_sql = ", ".join([f"{c} = EXCLUDED.{c}" for c in dataset["value_columns"]])
    conflict_sql = ", ".join(dataset["natural_key"])

    with conn.cursor() as cur:
        rows = df.select(all_columns).to_dicts()
        cur.executemany(
            f"""
            INSERT INTO {dataset["table"]} ({cols_sql})
            VALUES ({values_sql})
            ON CONFLICT ({conflict_sql})
            DO UPDATE SET {updates_sql};
        """,
            rows,
        )
        conn.commit()
    print(f"  Upserted {len(rows)} rows into {dataset['table']}.")


def load(dataset: dict) -> pl.DataFrame:
    print(f"  Fetching {dataset['url']}...")
    if dataset["format"] == "parquet":
        df = pl.read_parquet(dataset["url"])
    else:
        df = pl.read_csv(dataset["url"])
    df = df.with_columns(pl.col("date").cast(pl.Date))
    return df


def main():
    with get_connection() as conn:
        for dataset in DATASETS:
            print(f"\nProcessing {dataset['table']}...")
            df = load(dataset)
            create_table(conn, dataset, df)
            ingest(conn, dataset, df)
    print("\nAll datasets ingested successfully.")


if __name__ == "__main__":
    main()
