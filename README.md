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
