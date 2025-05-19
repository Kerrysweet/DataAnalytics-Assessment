import pandas as pd
from sqlalchemy import create_engine, text

# Database connection info
DB_USER = "root"
DB_PASS = input("Enter MySQL password: ")
DB_HOST = "127.0.0.1"
DB_PORT = "3306"
DB_NAME = "adashi_staging"

# Create engine
engine = create_engine(f"mysql+pymysql://{DB_USER}:{DB_PASS}@{DB_HOST}:{DB_PORT}/{DB_NAME}")

# List of tables you want to export
tables = ["users_customuser", "savings_savingsaccount", "plans_plan"]

for table in tables:
    query = text(f"SELECT * FROM {table}")
    with engine.connect() as conn:
        result = conn.execute(query)
        df = pd.DataFrame(result.fetchall(), columns=result.keys())
    
    # Save to CSV named after the table
    csv_filename = f"{table}.csv"
    df.to_csv(csv_filename, index=False)
    print(f"✅ Saved {table} to {csv_filename}")
