-- BUSN 32120 Final Project SQL Queries
-- Project: How Fed Policy, Inflation, and Recession Conditions Affect Cash and Stock Market Returns
-- SQL platform: Snowflake

-- ==========================================================
-- 0. Database and schema setup
-- ==========================================================

CREATE DATABASE IF NOT EXISTS BUSN32120_FINAL;
CREATE SCHEMA IF NOT EXISTS BUSN32120_FINAL.MACRO_PROJECT;

USE DATABASE BUSN32120_FINAL;
USE SCHEMA MACRO_PROJECT;


-- ==========================================================
-- 1. Create smaller logical tables from the uploaded ECON_FINAL table
-- ==========================================================
-- What: Split the uploaded final cleaned dataset into macro, market, and recession tables.
-- How: Use CREATE OR REPLACE TABLE AS SELECT from ECON_FINAL.
-- Why: This gives us separate tables so the SQL file can include meaningful JOIN queries.

CREATE OR REPLACE TABLE MACRO_DATA AS
SELECT
    DATE,
    FED_FUNDS_RATE,
    UNEMPLOYMENT_RATE,
    CPI_INDEX,
    INFLATION_YOY,
    REAL_INTEREST_RATE,
    MONTHLY_REAL_CASH_RETURN_PROXY,
    RATE_CHANGE,
    NEGATIVE_REAL_RATE,
    RATE_HIKING_MONTH,
    HIGH_INFLATION,
    DECADE,
    HIGH_INFLATION_LABEL,
    REAL_RATE_CATEGORY,
    INVESTMENT_ENVIRONMENT
FROM ECON_FINAL;

CREATE OR REPLACE TABLE MARKET_DATA AS
SELECT
    DATE,
    SP500,
    SP500_RETURN_MOM,
    STOCK_MINUS_CASH_GAP
FROM ECON_FINAL;

CREATE OR REPLACE TABLE RECESSION_DATA AS
SELECT
    DATE,
    RECESSION,
    RECESSION_LABEL
FROM ECON_FINAL;


-- ==========================================================
-- 2. Required SQL queries
-- ==========================================================

-- Query 1: Row count of the final uploaded dataset.
-- How: COUNT(*) over ECON_FINAL.
-- Why: Confirms the CSV was uploaded correctly before analysis.
SELECT
    COUNT(*) AS ROW_COUNT
FROM ECON_FINAL;


-- Query 2: Date range of the final dataset.
-- How: MIN() and MAX() of the DATE column.
-- Why: Confirms the sample period used in the final analysis.
SELECT
    MIN(DATE) AS FIRST_DATE,
    MAX(DATE) AS LAST_DATE
FROM ECON_FINAL;


-- Query 3: Basic missing value check for key variables.
-- How: SUM(CASE WHEN variable IS NULL THEN 1 ELSE 0 END) counts missing values.
-- Why: Data quality checks are important before doing EDA or modeling.
SELECT
    SUM(CASE WHEN FED_FUNDS_RATE IS NULL THEN 1 ELSE 0 END) AS MISSING_FED_FUNDS,
    SUM(CASE WHEN INFLATION_YOY IS NULL THEN 1 ELSE 0 END) AS MISSING_INFLATION,
    SUM(CASE WHEN UNEMPLOYMENT_RATE IS NULL THEN 1 ELSE 0 END) AS MISSING_UNEMPLOYMENT,
    SUM(CASE WHEN SP500_RETURN_MOM IS NULL THEN 1 ELSE 0 END) AS MISSING_SP500_RETURN,
    SUM(CASE WHEN REAL_INTEREST_RATE IS NULL THEN 1 ELSE 0 END) AS MISSING_REAL_RATE
FROM ECON_FINAL;


-- Query 4: Join macro data with market data.
-- How: INNER JOIN MACRO_DATA and MARKET_DATA on DATE.
-- Why: Connects macroeconomic conditions to S&P 500 market performance.
SELECT
    m.DATE,
    m.FED_FUNDS_RATE,
    m.INFLATION_YOY,
    m.REAL_INTEREST_RATE,
    s.SP500,
    s.SP500_RETURN_MOM,
    s.STOCK_MINUS_CASH_GAP
FROM MACRO_DATA AS m
INNER JOIN MARKET_DATA AS s
    ON m.DATE = s.DATE
ORDER BY m.DATE
LIMIT 20;


-- Query 5: Join macro data with recession data.
-- How: INNER JOIN MACRO_DATA and RECESSION_DATA on DATE.
-- Why: Compares interest rates, inflation, and unemployment across expansion and recession months.
SELECT
    m.DATE,
    m.FED_FUNDS_RATE,
    m.INFLATION_YOY,
    m.UNEMPLOYMENT_RATE,
    r.RECESSION,
    r.RECESSION_LABEL
FROM MACRO_DATA AS m
INNER JOIN RECESSION_DATA AS r
    ON m.DATE = r.DATE
ORDER BY m.DATE
LIMIT 20;


-- Query 6: Join macro, market, and recession data together.
-- How: Join all three logical tables on the DATE column.
-- Why: Creates a combined view of policy, inflation, market return, and recession status.
SELECT
    m.DATE,
    m.FED_FUNDS_RATE,
    m.INFLATION_YOY,
    m.REAL_INTEREST_RATE,
    s.SP500_RETURN_MOM,
    s.STOCK_MINUS_CASH_GAP,
    r.RECESSION_LABEL
FROM MACRO_DATA AS m
INNER JOIN MARKET_DATA AS s
    ON m.DATE = s.DATE
INNER JOIN RECESSION_DATA AS r
    ON m.DATE = r.DATE
ORDER BY m.DATE
LIMIT 20;


-- Query 7: Average macro and market conditions by decade.
-- How: GROUP BY DECADE and calculate average rates, returns, and recession months.
-- Why: Shows how the investment environment changes across time periods.
SELECT
    DECADE,
    COUNT(*) AS MONTHS,
    ROUND(AVG(FED_FUNDS_RATE), 2) AS AVG_FED_FUNDS,
    ROUND(AVG(INFLATION_YOY), 2) AS AVG_INFLATION,
    ROUND(AVG(UNEMPLOYMENT_RATE), 2) AS AVG_UNEMPLOYMENT,
    ROUND(AVG(REAL_INTEREST_RATE), 2) AS AVG_REAL_INTEREST_RATE,
    ROUND(AVG(SP500_RETURN_MOM), 2) AS AVG_SP500_MONTHLY_RETURN,
    ROUND(AVG(STOCK_MINUS_CASH_GAP), 2) AS AVG_STOCK_MINUS_CASH_GAP,
    SUM(RECESSION) AS RECESSION_MONTHS
FROM ECON_FINAL
GROUP BY DECADE
ORDER BY DECADE;


-- Query 8: Average conditions during expansions and recessions.
-- How: GROUP BY RECESSION_LABEL.
-- Why: Helps the target audience understand how recessions differ from normal expansion periods.
SELECT
    RECESSION_LABEL,
    COUNT(*) AS MONTHS,
    ROUND(AVG(FED_FUNDS_RATE), 2) AS AVG_FED_FUNDS,
    ROUND(AVG(INFLATION_YOY), 2) AS AVG_INFLATION,
    ROUND(AVG(UNEMPLOYMENT_RATE), 2) AS AVG_UNEMPLOYMENT,
    ROUND(AVG(REAL_INTEREST_RATE), 2) AS AVG_REAL_INTEREST_RATE,
    ROUND(AVG(SP500_RETURN_MOM), 2) AS AVG_SP500_MONTHLY_RETURN,
    ROUND(AVG(STOCK_MINUS_CASH_GAP), 2) AS AVG_STOCK_MINUS_CASH_GAP
FROM ECON_FINAL
GROUP BY RECESSION_LABEL
ORDER BY RECESSION_LABEL;


-- Query 9: Average conditions by real-rate category.
-- How: GROUP BY REAL_RATE_CATEGORY.
-- Why: Directly supports the main cash-investor question because cash should be evaluated in real terms.
SELECT
    REAL_RATE_CATEGORY,
    COUNT(*) AS MONTHS,
    ROUND(AVG(FED_FUNDS_RATE), 2) AS AVG_FED_FUNDS,
    ROUND(AVG(INFLATION_YOY), 2) AS AVG_INFLATION,
    ROUND(AVG(REAL_INTEREST_RATE), 2) AS AVG_REAL_INTEREST_RATE,
    ROUND(AVG(MONTHLY_REAL_CASH_RETURN_PROXY), 2) AS AVG_MONTHLY_REAL_CASH_RETURN,
    ROUND(AVG(SP500_RETURN_MOM), 2) AS AVG_SP500_MONTHLY_RETURN,
    ROUND(AVG(STOCK_MINUS_CASH_GAP), 2) AS AVG_STOCK_MINUS_CASH_GAP
FROM ECON_FINAL
WHERE REAL_RATE_CATEGORY IS NOT NULL
GROUP BY REAL_RATE_CATEGORY
ORDER BY REAL_RATE_CATEGORY;


-- Query 10: Rank investment environments by average stock-minus-cash gap.
-- How: GROUP BY INVESTMENT_ENVIRONMENT and ORDER BY the average gap.
-- Why: Shows which environments were more favorable for stocks versus cash.
SELECT
    INVESTMENT_ENVIRONMENT,
    COUNT(*) AS MONTHS,
    ROUND(AVG(FED_FUNDS_RATE), 2) AS AVG_FED_FUNDS,
    ROUND(AVG(INFLATION_YOY), 2) AS AVG_INFLATION,
    ROUND(AVG(REAL_INTEREST_RATE), 2) AS AVG_REAL_INTEREST_RATE,
    ROUND(AVG(SP500_RETURN_MOM), 2) AS AVG_SP500_MONTHLY_RETURN,
    ROUND(AVG(MONTHLY_REAL_CASH_RETURN_PROXY), 2) AS AVG_MONTHLY_REAL_CASH_RETURN,
    ROUND(AVG(STOCK_MINUS_CASH_GAP), 2) AS AVG_STOCK_MINUS_CASH_GAP
FROM ECON_FINAL
WHERE INVESTMENT_ENVIRONMENT IS NOT NULL
GROUP BY INVESTMENT_ENVIRONMENT
ORDER BY AVG_STOCK_MINUS_CASH_GAP DESC;


-- Query 11: Window function for month-over-month Fed Funds Rate change.
-- How: LAG(FED_FUNDS_RATE) OVER (ORDER BY DATE) gets the previous month's rate.
-- Why: Shows whether policy was tightening or easing month by month.
SELECT
    DATE,
    FED_FUNDS_RATE,
    LAG(FED_FUNDS_RATE) OVER (ORDER BY DATE) AS PREVIOUS_MONTH_RATE,
    FED_FUNDS_RATE - LAG(FED_FUNDS_RATE) OVER (ORDER BY DATE) AS MONTHLY_RATE_CHANGE
FROM ECON_FINAL
ORDER BY DATE;


-- Query 12: Window function for 12-month moving average of inflation.
-- How: AVG(INFLATION_YOY) OVER a trailing 12-row window.
-- Why: Smooths inflation to make the trend easier to interpret.
SELECT
    DATE,
    INFLATION_YOY,
    ROUND(
        AVG(INFLATION_YOY) OVER (
            ORDER BY DATE
            ROWS BETWEEN 11 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS INFLATION_12_MONTH_MOVING_AVG
FROM ECON_FINAL
ORDER BY DATE;


-- Query 13: Window function for cumulative S&P 500 return proxy.
-- How: SUM(SP500_RETURN_MOM) OVER (ORDER BY DATE) creates a simple cumulative monthly return approximation.
-- Why: Gives a time-series view of how stock returns accumulate over the sample.
SELECT
    DATE,
    SP500_RETURN_MOM,
    ROUND(
        SUM(SP500_RETURN_MOM) OVER (
            ORDER BY DATE
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS CUMULATIVE_SP500_RETURN_APPROX
FROM ECON_FINAL
WHERE SP500_RETURN_MOM IS NOT NULL
ORDER BY DATE;


-- Query 14: Above-average inflation months using a subquery.
-- How: The subquery calculates the sample average inflation, and the outer query keeps months above it.
-- Why: Identifies months where inflation pressure was relatively high.
SELECT
    DATE,
    FED_FUNDS_RATE,
    INFLATION_YOY,
    REAL_INTEREST_RATE,
    SP500_RETURN_MOM,
    STOCK_MINUS_CASH_GAP
FROM ECON_FINAL
WHERE INFLATION_YOY > (
    SELECT AVG(INFLATION_YOY)
    FROM ECON_FINAL
)
ORDER BY INFLATION_YOY DESC;


-- Query 15: Months when stocks underperformed the real cash proxy using a subquery.
-- How: The subquery calculates the average stock-minus-cash gap, and the outer query keeps months below it.
-- Why: Helps identify when cash-like returns looked better than stocks.
SELECT
    DATE,
    SP500_RETURN_MOM,
    MONTHLY_REAL_CASH_RETURN_PROXY,
    STOCK_MINUS_CASH_GAP,
    FED_FUNDS_RATE,
    INFLATION_YOY,
    REAL_INTEREST_RATE
FROM ECON_FINAL
WHERE STOCK_MINUS_CASH_GAP < (
    SELECT AVG(STOCK_MINUS_CASH_GAP)
    FROM ECON_FINAL
)
ORDER BY STOCK_MINUS_CASH_GAP ASC;


-- Query 16: Negative real-rate months by decade.
-- How: Filter to REAL_INTEREST_RATE < 0, then GROUP BY DECADE.
-- Why: Shows how often cash lost purchasing power in each decade.
SELECT
    DECADE,
    COUNT(*) AS NEGATIVE_REAL_RATE_MONTHS
FROM ECON_FINAL
WHERE REAL_INTEREST_RATE < 0
GROUP BY DECADE
ORDER BY NEGATIVE_REAL_RATE_MONTHS DESC;
