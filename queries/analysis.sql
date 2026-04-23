-- ==========================================================
-- 📊 SaaS Business Diagnostic - Analytical Queries
-- Focus: KPIs, Cohorts, and Predictive Metrics
-- ==========================================================

-- 1. Monthly Recurring Revenue (MRR) Trend
SELECT 
    strftime('%Y-%m', transaction_date) as month,
    SUM(amount) as total_revenue,
    COUNT(DISTINCT user_id) as active_customers
FROM transactions
GROUP BY 1
ORDER BY 1;

-- 2. MoM Revenue Growth Rate (%)
WITH monthly_rev AS (
    SELECT 
        strftime('%Y-%m', transaction_date) as month,
        SUM(amount) as revenue
    FROM transactions
    GROUP BY 1
)
SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) as prev_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY month)) / LAG(revenue) OVER (ORDER BY month)) * 100, 2) || '%' as growth_rate
FROM monthly_rev;

-- 3. Churn Rate (Percentage of users who ended in a given month)
SELECT 
    strftime('%Y-%m', end_date) as churn_month,
    COUNT(user_id) as churned_users,
    (SELECT COUNT(*) FROM subscriptions) as total_life_time_users
FROM subscriptions
WHERE end_date IS NOT NULL
GROUP BY 1;

-- 4. Cohort Analysis: Revenue by Signup Channel
SELECT 
    u.channel,
    p.plan_name,
    COUNT(DISTINCT u.user_id) as user_count,
    ROUND(SUM(t.amount), 2) as total_revenue,
    ROUND(SUM(t.amount) / COUNT(DISTINCT u.user_id), 2) as ARPU -- Average Revenue Per User
FROM users u
JOIN transactions t ON u.user_id = t.user_id
JOIN subscriptions s ON u.user_id = s.user_id
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY 1, 2
ORDER BY ARPU DESC;

-- 5. Rolling 3-Month Average Revenue
WITH monthly_rev AS (
    SELECT 
        strftime('%Y-%m', transaction_date) as month,
        SUM(amount) as revenue
    FROM transactions
    GROUP BY 1
)
SELECT 
    month,
    revenue,
    AVG(revenue) OVER (ORDER BY month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) as rolling_3mo_avg
FROM monthly_rev;

-- 6. Customer Lifetime Value (LTV) by Plan
SELECT 
    p.plan_name,
    AVG(total_user_spend) as avg_ltv
FROM (
    SELECT user_id, SUM(amount) as total_user_spend
    FROM transactions
    GROUP BY 1
) user_spend
JOIN subscriptions s ON user_spend.user_id = s.user_id
JOIN plans p ON s.plan_id = p.plan_id
GROUP BY 1;

-- 7. Retention Curve (Users active after X months)
-- (Simplified for SQLite: Users with transactions in month 1 vs month 6)
-- Query logic to find 'Sticky' users
SELECT 
    COUNT(DISTINCT user_id) as power_users
FROM transactions
GROUP BY user_id
HAVING COUNT(transaction_date) >= 6;

-- 8. Conversion Speed (Days from Registration to Subscription)
SELECT 
    AVG(julianday(s.start_date) - julianday(u.signup_date)) as avg_days_to_convert
FROM users u
JOIN subscriptions s ON u.user_id = s.user_id;

-- 9. Revenue Concentration (Pareto Principle)
-- Top 10% of users by spend
WITH user_ranking AS (
    SELECT 
        user_id,
        SUM(amount) as customer_spend,
        PERCENT_RANK() OVER (ORDER BY SUM(amount) DESC) as rank_pct
    FROM transactions
    GROUP BY 1
)
SELECT SUM(customer_spend) as revenue_from_top_10_percent
FROM user_ranking
WHERE rank_pct <= 0.1;

-- 10. Win-Back Opportunity (Users who churned but were high LTV)
SELECT 
    u.user_id,
    SUM(t.amount) as past_ltv,
    s.end_date
FROM users u
JOIN transactions t ON u.user_id = t.user_id
JOIN subscriptions s ON u.user_id = s.user_id
WHERE s.end_date IS NOT NULL
GROUP BY 1
HAVING past_ltv > 500
ORDER BY past_ltv DESC;
