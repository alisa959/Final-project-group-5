# BUSN 32120 Final Project

## Project Title

How Fed Policy, Inflation, and Recession Conditions Affect Cash and Stock Market Returns

## Project Overview

This project studies how macroeconomic conditions affect simple investment decisions. The analysis focuses on the Federal Funds Rate, inflation, unemployment, S&P 500 returns, and U.S. recession periods. The main goal is to understand when cash is attractive in real terms and whether macroeconomic indicators help explain stock market returns or high inflation environments.

The project is designed for beginner investors and finance students. The analysis avoids overly complex methods and focuses on clear data cleaning, exploratory data analysis, feature engineering, SQL queries, and two basic machine learning models.

## Research Question

The main research question is:

How do interest rates, inflation, unemployment, and recession conditions affect the real return on cash and S&P 500 performance?

A related modeling question is:

Can macroeconomic variables help explain monthly S&P 500 returns and classify high inflation periods?

## Target Audience

The target audience is beginner investors and finance students who want to understand the relationship between Federal Reserve policy, inflation, and market performance. The analysis is especially relevant for people who want to compare cash and stock market exposure under different macroeconomic environments.

## Data Sources

This project uses more than one dataset.

1. FRED macroeconomic data
   - Federal Funds Rate
   - Consumer Price Index
   - Unemployment Rate

2. Long history S&P 500 market data
   - S&P 500 price level
   - Monthly S&P 500 return
   - Year over year S&P 500 return

3. FRED recession indicator data
   - U.S. recession indicator
   - Expansion and recession classification

The final cleaned dataset is exported as `final_project_cleaned_data.csv` so the project can still be reviewed even if live data downloads are unavailable.

## Main Files

| File | Description |
| --- | --- |
| `final_project_analysis_v4.ipynb` | Main polished Python notebook with data collection, cleaning, EDA, feature engineering, models, and conclusion |
| `final_project_cleaned_data.csv` | Final cleaned dataset exported from the Python notebook |
| `final_project_sql_queries.sql` | Separate SQL file with required SQL queries for the final project |
| `README.md` | Project overview and instructions |
| `presentation.pdf` | Final presentation deck exported as a PDF |

## Methods Used

The project uses both Python and SQL.

### Python

Python is used for:

- Downloading and cleaning public datasets
- Merging macroeconomic, market, and recession data
- Checking data quality
- Creating engineered features
- Building aggregate tables
- Creating charts
- Running two models
- Exporting the cleaned final dataset

### SQL

SQL is used for:

- Checking the final dataset
- Creating separate macro, market, and recession tables
- Joining datasets
- Grouping observations by decade and economic state
- Using window functions to calculate lagged values and moving averages
- Using subqueries to identify above average inflation and negative real rate periods

The SQL file is separate from the Python notebook to make grading easier.

## Feature Engineering

The project creates several new variables, including:

- Year over year inflation
- Real interest rate
- Monthly real cash return proxy
- S&P 500 monthly return
- S&P 500 year over year return
- Stock minus cash return gap
- Rate change
- Negative real rate indicator
- Rate hiking month indicator
- High inflation indicator
- Decade group
- Recession label
- Real rate category
- Investment environment category

These features help connect macroeconomic conditions to investor decisions.

## Exploratory Data Analysis

The EDA section includes:

- Missing value checks
- Summary statistics
- Aggregate tables by decade, recession status, real rate category, and investment environment
- Time series charts for macroeconomic variables
- Real interest rate chart
- S&P 500 return analysis
- Recession and expansion comparison
- Correlation heatmap

The goal of the EDA is to show that nominal interest rates are not enough to evaluate cash. Investors also need to consider inflation and real interest rates.

## Models

The project includes two models.

### Model 1

Linear regression is used to explain monthly S&P 500 returns using macroeconomic variables. The model is not expected to predict stock returns perfectly because monthly market returns are noisy. The goal is to test whether macro variables have an observable relationship with equity returns.

### Model 2

Logistic regression is used to classify high inflation periods using macroeconomic and market variables. This model is more stable than recession classification because high inflation observations are more common than recession months in the sample.

## Main Findings

The analysis shows that high nominal interest rates are not always attractive for investors. Cash is more meaningful when the interest rate is high relative to inflation. Periods with negative real rates can reduce purchasing power even when nominal rates are positive.

The S&P 500 return model has limited explanatory power, which is expected because monthly equity returns are difficult to predict. The high inflation classification model is more useful as a structured way to understand how unemployment, policy rates, and market performance differ during inflationary periods.

Overall, the project shows that investors should evaluate cash and stock exposure using real rates, inflation, and macroeconomic context rather than looking at nominal interest rates alone.

## Limitations

There are several limitations.

- The analysis uses monthly data, so it may miss short term market movements.
- The S&P 500 is only one measure of stock market performance.
- The models are simple and are used for interpretation rather than trading prediction.
- Recession months are relatively rare, so recession based modeling can be unstable.
- Future work could add bond returns, money market yields, sector level stock returns, consumer sentiment, or global macroeconomic data.

## How to Run the Python Notebook

1. Open `final_project_analysis_v4.ipynb` in Jupyter Notebook or JupyterLab.
2. Run all cells from top to bottom.
3. Confirm that the charts, tables, model metrics, and final CSV export are produced.
4. The notebook exports `final_project_cleaned_data.csv` for SQL analysis and reproducibility.

If live data downloads do not work, use the included `final_project_cleaned_data.csv` as the final cleaned dataset.

## How to Use the SQL File in Snowflake

1. Upload `final_project_cleaned_data.csv` into Snowflake.
2. Name the main table `ECON_FINAL`.
3. Use the SQL file to create smaller tables such as `MACRO_DATA`, `MARKET_DATA`, and `RECESSION_DATA`.
4. Run the required SQL queries in `final_project_sql_queries.sql`.
5. Save the executed SQL worksheet or submit the SQL file as part of the final project.

## Suggested Snowflake Setup

```sql
CREATE DATABASE IF NOT EXISTS BUSN32120_FINAL;
CREATE SCHEMA IF NOT EXISTS BUSN32120_FINAL.MACRO_PROJECT;

USE DATABASE BUSN32120_FINAL;
USE SCHEMA MACRO_PROJECT;
```

After uploading the CSV, run:

```sql
SELECT COUNT(*) AS ROW_COUNT
FROM ECON_FINAL;

SELECT *
FROM ECON_FINAL
LIMIT 10;
```

These checks confirm that the table loaded correctly.

## Reproducibility Note

The notebook uses public data sources and exports a cleaned CSV. The cleaned CSV is included so the project can be reviewed without depending only on live online data downloads.

## Course Context

This project was created for BUSN 32120 Data Analysis with Python and SQL, Spring 2026.
