import pandas as pd
from sqlalchemy import create_engine, text

# Database config
DB_NAME = "adashi_staging"
DB_USER = "root"
DB_HOST = "127.0.0.1"  # Updated from "localhost"
DB_PORT = "3306"
DB_PASS = input("Enter your MySQL password: ")  # Visible input for PowerShell

# Create engine
engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

try:
    with engine.connect() as conn:
        query = text("SELECT * FROM users_customuser LIMIT 10")
        result = conn.execute(query)
        df = pd.DataFrame(result.fetchall(), columns=result.keys())
    print("\n✅ Query Results:")
    print(df)
except Exception as e:
    print(f"\n❌ Error: {e}")
    #python script_that_connect_the_database_to_vscode.py
