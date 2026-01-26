from sqlalchemy import create_engine
import os
from dotenv import load_dotenv

def get_engine():
    """
    Create and return a SQLAlchemy engine for PostgreSQL.
    Environment variables are loaded from .env
    """
    load_dotenv()

    DB_USER = os.getenv("DB_USER")
    DB_PASSWORD = os.getenv("DB_PASSWORD")
    DB_HOST = os.getenv("DB_HOST")
    DB_PORT = os.getenv("DB_PORT")
    DB_NAME = os.getenv("DB_NAME")

    # Validación explícita (MUY importante)
    missing = {
        "DB_USER": DB_USER,
        "DB_PASSWORD": DB_PASSWORD,
        "DB_HOST": DB_HOST,
        "DB_PORT": DB_PORT,
        "DB_NAME": DB_NAME,
    }

    missing_vars = [k for k, v in missing.items() if not v]
    if missing_vars:
        raise ValueError(f"Variables de entorno faltantes: {missing_vars}")

    connection_string = (
        f"postgresql+psycopg2://{DB_USER}:{DB_PASSWORD}"
        f"@{DB_HOST}:{DB_PORT}/{DB_NAME}"
    )

    return create_engine(
        connection_string,
        pool_pre_ping=True
    )
