# 📈 SaaS Business Diagnostic: Strategic SQL Audit
### Full-Stack Database Analysis of a Subscription Platform

This project is a deep-dive into **Business Intelligence (BI)** using SQL. I simulated a complex SaaS database with 1,000+ users and built a diagnostic suite that calculates critical growth and retention metrics.

---

## 🧐 The Objective
To audit the health of a subscription business by answering 10+ core strategic questions ranging from **Revenue Concentration (Pareto Analysis)** to **Cohort Retention**.

## 🛠️ Data Infrastructure
The analysis is performed on a 4-table relational schema:
- `users`: Customer demographic and acquisition channel data.
- `plans`: Tiered pricing structures (Basic, Pro, Enterprise).
- `subscriptions`: Life-cycle tracking (Signup to Churn).
- `transactions`: Granular ledger of all payment events.

---

## 📊 Key Analytical Insights

### 1. Revenue & Growth
- **MRR Trends:** Developed MoM (Month-over-Month) growth tracking using `LAG()` window functions.
- **Concentration:** Identified that the top 10% of users contribute significantly to total revenue, suggesting a shift toward high-touch Enterprise sales.

### 2. Marketing ROI
- **ARPU by Channel:** Analyzed which acquisition channels (Organic vs. Paid) yield the highest Average Revenue Per User.
- **Conversion Lead Time:** Calculated the velocity of the sales funnel (Signup → Subscription).

### 3. Customer Retention (The "Leaky Bucket")
- **Churn Analysis:** Built a diagnostic to track churned users by month and identify high-value "Win-Back" opportunities.
- **Rolling Averages:** Used floating window frames (`ROWS BETWEEN 2 PRECEDING`) to smooth out revenue volatility.

---

## 🚀 SQL Techniques Showcased
- **CTEs (Common Table Expressions):** For modular, readable logic.
- **Window Functions:** `RANK()`, `LAG()`, `PERCENT_RANK()`, and `AVG() OVER()`.
- **Relational Algebra:** Multi-way joins across 4+ tables.
- **Date Arithmetic:** Granular time-series parsing for cohort logic.

---

## 📂 Project Structure
```text
├── data/
│   └── saas_data.db        # SQLite Relational Database
├── queries/
│   └── analysis.sql        # The "Big 10" Analytical Queries
├── src/
│   └── db_builder.py       # Data synthesis engine
└── README.md
```

## 📝 Conclusion
This audit reveals a strong growth trend in the **Enterprise Tiers**, while **Organic channels** show the highest retention rates. Strategic recommendation: Reallocate 15% of Paid Search budget to Organic SEO/Content to optimize LTV/CAC ratios.

---
*Created by [Rohan Kar](https://github.com/rohankar02) for the Data Analytics Portfolio.*
