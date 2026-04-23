import sqlite3
import pandas as pd
import numpy as np
from datetime import datetime, timedelta

def generate_saas_db():
    conn = sqlite3.connect('/Users/rohankar/.gemini/antigravity/scratch/SQL-Business-Diagnostic/data/saas_data.db')
    cursor = conn.cursor()
    
    # 1. Users Table
    num_users = 1000
    channels = ['Organic', 'Paid Search', 'Social Media', 'Referral']
    users = pd.DataFrame({
        'user_id': range(1, num_users + 1),
        'signup_date': [datetime(2024, 1, 1) + timedelta(days=np.random.randint(0, 365)) for _ in range(num_users)],
        'channel': np.random.choice(channels, num_users)
    })
    users.to_sql('users', conn, index=False, if_exists='replace')
    
    # 2. Plans Table
    plans = pd.DataFrame({
        'plan_id': [1, 2, 3],
        'plan_name': ['Basic', 'Pro', 'Enterprise'],
        'monthly_price': [19.99, 49.99, 199.99]
    })
    plans.to_sql('plans', conn, index=False, if_exists='replace')
    
    # 3. Subscriptions Table
    subs = []
    for user_id in range(1, num_users + 1):
        signup = users.iloc[user_id-1]['signup_date']
        # Most users subscribe within 7 days
        sub_start = signup + timedelta(days=np.random.randint(0, 7))
        plan_id = np.random.choice([1, 2, 3], p=[0.6, 0.3, 0.1])
        # Random churn (40% churn rate)
        churned = np.random.choice([True, False], p=[0.4, 0.6])
        sub_end = sub_start + timedelta(days=np.random.randint(30, 180)) if churned else None
        subs.append([user_id, plan_id, sub_start, sub_end])
        
    subscriptions = pd.DataFrame(subs, columns=['user_id', 'plan_id', 'start_date', 'end_date'])
    subscriptions.to_sql('subscriptions', conn, index=False, if_exists='replace')
    
    # 4. Transactions Table (Generate monthly charges)
    transactions = []
    for _, sub in subscriptions.iterrows():
        start = sub['start_date']
        plan_price = plans.loc[plans['plan_id'] == sub['plan_id'], 'monthly_price'].values[0]
        end = sub['end_date'] if sub['end_date'] else datetime(2025, 4, 1)
        
        current = start
        while current < end:
            transactions.append([sub['user_id'], plan_price, current])
            current += timedelta(days=30)
            
    tx_df = pd.DataFrame(transactions, columns=['user_id', 'amount', 'transaction_date'])
    tx_df.to_sql('transactions', conn, index=False, if_exists='replace')
    
    conn.close()
    print("Database built successfully.")

if __name__ == "__main__":
    generate_saas_db()
