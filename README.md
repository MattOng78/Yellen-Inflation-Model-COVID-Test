# Yellen-Inflation-Model-COVID-Test
# Replication and Extension of Yellen (2015) Inflation Model to the COVID Period

## Overview

This project replicates and extends the 2015 inflation model associated with Janet Yellen by evaluating its performance during the COVID-era inflation period (2020–2023).

The primary objective is to test whether measures of import pressure and supply chain congestion significantly contributed to U.S. inflation during the pandemic period.

In addition to replicating the original specification, I compare alternative supply chain indices and introduce direct port congestion data I obtained via request from the U.S. Department of Transportation.

---

## Research Question

Did import pressure and supply chain congestion significantly contribute to U.S. inflation during the COVID period?

Specifically:

- Does the Global Supply Chain Pressure Index (GSCPI) outperform the Import Price Index (IPI) as a predictor of inflation?
- Do observed port wait times and cargo volume provide additional explanatory power beyond aggregate supply chain indices?

---

## Data

All data are converted to quarterly percent changes.

**Dependent Variable**
- Consumer Price Index (CPI), U.S. Bureau of Labor Statistics

**Independent Variables**
- Lagged CPI (2 lags)
- 1-year inflation expectations (Cleveland Federal Reserve)
- Labor market tightness (Unemployment-to-Vacancy ratio, U/V)
- Import Price Index (IPI), BLS
- Global Supply Chain Pressure Index (GSCPI), Federal Reserve Bank of New York
- Port wait time and cargo volume data, U.S. Department of Transportation

**Sample Periods**
- Baseline replication: 1983–2023 (quarterly)
- Port congestion extension: 2018–2022 (limited by data availability)

Note: Models including port-level variables have limited observations (as low as 12–15), reducing statistical power.

---

## Model Specification

### Baseline Model (Yellen 2015 Specification)

\[
CPI_t = \beta_0 + \beta_1 CPI_{t-1} + \beta_2 CPI_{t-2} + \beta_3 EI_t + \beta_4 (U/V)_t + \beta_5 IPI_t + \epsilon_t
\]

### Alternative Specification (CEA-style modification)

\[
CPI_t = \beta_0 + \beta_1 CPI_{t-1} + \beta_2 CPI_{t-2} + \beta_3 EI_t + \beta_4 (U/V)_t + \beta_5 GSCPI_t + \epsilon_t
\]

### Extended Models with Port Data

\[
CPI_t = ... + \beta_6 WaitTime_t
\]

\[
CPI_t = ... + \beta_6 Volume_t
\]

Estimation Method:
- OLS time-series regression
- Quarterly data
- Lag structure included to address autocorrelation

---

## Key Findings

- The Global Supply Chain Pressure Index (GSCPI) is statistically significant and economically meaningful in predicting inflation.
- The Import Price Index (IPI) shows weaker explanatory power relative to GSCPI.
- Port wait time and cargo volume were not statistically significant in extended models; however, these regressions suffer from low statistical power due to limited observations.
- Coefficient signs are directionally consistent with supply-side inflation theory.

---

## Limitations

- Limited sample size in port-level regressions (12–15 observations).
- Potential endogeneity between supply pressure and inflation.
- Structural break during COVID may affect coefficient stability.
- Results should be interpreted as exploratory rather than causal.

---

## Tools Used

- R
- lm()
- tidyverse
- stargazer (for regression tables)

