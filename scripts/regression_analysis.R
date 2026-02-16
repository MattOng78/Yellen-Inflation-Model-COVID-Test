# ============================================================
# Replication and Extension of Yellen (2015) Inflation Model
# COVID Period Analysis
# ============================================================

# -----------------------------
# Load Packages
# -----------------------------
library(readxl)
library(dynlm)
library(stargazer)
library(lmtest)
library(sandwich)

# -----------------------------
# Load Data
# -----------------------------
# Data are quarterly percent changes unless otherwise noted.
# Excel file should be located in /data folder.

df1 <- read_excel("data/inflation_data.xlsx", sheet = "M1")
df2 <- read_excel("data/inflation_data.xlsx", sheet = "M2")
df3 <- read_excel("data/inflation_data.xlsx", sheet = "M3")

# -----------------------------
# Convert to Time Series
# -----------------------------
# Quarterly frequency = 4

ts.df1 <- ts(df1, start = c(1983, 1), end = c(2023, 4), frequency = 4)
ts.df2 <- ts(df2, start = c(1998, 2), end = c(2023, 4), frequency = 4)
ts.df3 <- ts(df3, start = c(2019, 1), end = c(2022, 2), frequency = 4)

# ============================================================
# PART 1: Replication of Yellen (2015)
# ============================================================

# Baseline Yellen specification (with IPI)
m1 <- dynlm(CPI ~ L(CPI, 1:2) + EI1 + UV + IPI, data = ts.df1)

# Alternative specification using GSCPI
m2 <- dynlm(CPI ~ L(CPI, 1:2) + EI1 + UV + GSCPI, data = ts.df2)

# Blank model (formatting comparison)
m0 <- dynlm(CPI ~ CPI, data = ts.df1)

# -----------------------------
# Model Summaries
# -----------------------------
summary(m1)
summary(m2)

# -----------------------------
# Export Regression Tables
# -----------------------------
stargazer(m1, m2,
          type = "text",
          dep.var.labels = c("CPI"),
          title = "CPI: Measures of Supply Chain Pressure",
          digits = 2,
          covariate.labels = c("CPI (t-1)",
                               "CPI (t-2)",
                               "One-Year Expected Inflation",
                               "Unemployment-to-Vacancy Ratio",
                               "Import Price Index",
                               "Global Supply Chain Pressure Index"),
          out = "output/models_part1.txt")

# With blank column for formatting
stargazer(m0, m1, m2,
          type = "text",
          dep.var.labels = c("CPI"),
          title = "CPI: Measures of Supply Chain Pressure",
          digits = 2,
          covariate.labels = c("CPI (t-1)",
                               "CPI (t-2)",
                               "One-Year Expected Inflation",
                               "Unemployment-to-Vacancy Ratio",
                               "Import Price Index",
                               "Global Supply Chain Pressure Index"),
          out = "output/models_part1_with_blank.txt")

# ============================================================
# PART 2: Extension with Port Congestion Data
# ============================================================

# Baseline with GSCPI
mod1 <- dynlm(CPI ~ L(CPI, 1:2) + EI1 + UV + GSCPI, data = ts.df2)

# Add wait time
mod2 <- dynlm(CPI ~ L(CPI, 1:2) + EI1 + UV + GSCPI + deltawait, data = ts.df3)

# Add import volume
mod3 <- dynlm(CPI ~ L(CPI, 1:2) + EI1 + UV + GSCPI + deltaimpt, data = ts.df3)

# Add both
mod4 <- dynlm(CPI ~ L(CPI, 1:2) + EI1 + UV + GSCPI + deltawait + deltaimpt,
              data = ts.df3)

# Interaction term
mod5 <- dynlm(CPI ~ L(CPI, 1:2) + EI1 + UV + GSCPI +
                deltawait + deltaimpt + deltawait * deltaimpt,
              data = ts.df3)

# -----------------------------
# Model Summaries
# -----------------------------
summary(mod1)
summary(mod2)
summary(mod3)
summary(mod4)
summary(mod5)

# -----------------------------
# Export Regression Tables
# -----------------------------

# Without interaction
stargazer(mod1, mod2, mod3, mod4,
          type = "text",
          dep.var.labels = c("CPI"),
          title = "Wait Time and Import Volume Effects on CPI",
          digits = 2,
          covariate.labels = c("CPI (t-1)",
                               "CPI (t-2)",
                               "One-Year Expected Inflation",
                               "Unemployment-to-Vacancy Ratio",
                               "Global Supply Chain Pressure Index",
                               "Wait Time",
                               "Import Volume"),
          out = "output/models_part2.txt")

# With interaction
stargazer(mod1, mod2, mod3, mod4, mod5,
          type = "text",
          dep.var.labels = c("CPI"),
          title = "Wait Time and Volume Interaction Effects on CPI",
          digits = 2,
          covariate.labels = c("CPI (t-1)",
                               "CPI (t-2)",
                               "One-Year Expected Inflation",
                               "Unemployment-to-Vacancy Ratio",
                               "Global Supply Chain Pressure Index",
                               "Wait Time",
                               "Import Volume",
                               "Wait Time × Import Volume"),
          out = "output/models_part2_with_interaction.txt")

# ============================================================
# Robustness Check: Heteroskedasticity Test (Breusch-Pagan)
# ============================================================

bptest(m1)
bptest(mod1)

# ============================================================
# End of Script
# ============================================================
