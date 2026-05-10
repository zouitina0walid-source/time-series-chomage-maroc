# Forecasting Moroccan Unemployment Rate (Higher Education Graduates)

## Project Overview

[cite_start]This project focuses on the modeling and forecasting of the quarterly unemployment rate among higher education graduates in Morocco, covering the period from **2006 Q1 to 2025 Q4**[cite: 454]. [cite_start]The study utilizes data provided by the **Haut-Commissariat au Plan (HCP)**[cite: 455].

The primary objective was to apply the **Box-Jenkins methodology** to identify a robust stochastic model capable of generating reliable short-term forecasts for national labor market monitoring.

## Methodology

### 1. Data Processing and Partitioning

[cite_start]The dataset consists of **80 quarterly observations**[cite: 454]. To ensure rigorous out-of-sample validation, the data was partitioned as follows:

- [cite_start]**Training Set:** 64 observations (2006 Q1 – 2021 Q4), representing 80% of the series[cite: 460].
- [cite_start]**Test Set:** 16 observations (2022 Q1 – 2025 Q4), representing 20% of the series[cite: 461].

### 2. Stationarity Analysis

[cite_start]Initial diagnostics through visual inspection (ACF) and formal statistical tests confirmed the non-stationarity of the raw series[cite: 497, 499]:

- [cite_start]**Augmented Dickey-Fuller (ADF) Test:** p-value = 0.9139 (Failed to reject the null hypothesis of a unit root)[cite: 506, 507].
- [cite_start]**KPSS Test:** p-value = 0.01 (Rejected the null hypothesis of stationarity)[cite: 511, 513].

[cite_start]Stationarity was achieved through a **first-order differentiation** ($d=1$)[cite: 536, 548].

### 3. Model Identification and Estimation

[cite_start]Based on the analysis of Autocorrelation (ACF) and Partial Autocorrelation (PACF) functions of the differenced series, several ARIMA candidates were tested[cite: 552, 588]. [cite_start]A systematic grid search was performed to optimize parameters $p$ and $q$[cite: 588].

[cite_start]The **ARIMA(3, 1, 3)** model was selected as the final specification based on[cite: 610]:

- [cite_start]Statistical significance of all coefficients ($|z| > 1.96$)[cite: 591].
- [cite_start]Residual independence (Box-Pierce test: p-value > 0.05)[cite: 603, 608].
- [cite_start]Minimization of the **Akaike Information Criterion (AIC = 215.42)**[cite: 608, 610].

## Performance and Results

### Forecasting Accuracy

The model was evaluated against the test set (16 quarters). [cite_start]The results demonstrate high predictive precision[cite: 633, 646]:

- [cite_start]**Root Mean Square Error (RMSE):** 0.91%[cite: 647].
- [cite_start]**Mean Absolute Percentage Error (MAPE):** 2.95%[cite: 648].

### Residual Diagnostics

[cite_start]The validity of the model was further confirmed by verifying the normality of the residuals[cite: 653]:

- [cite_start]**Shapiro-Wilk Test:** p-value = 0.5769 (Confirmed normality)[cite: 653, 654].

## Technical Stack

- **Language:** R
- **Key Libraries:** `forecast`, `tseries`, `ggplot2`

## Authors

- [cite_start]**Hicham Kaboui** - Data Science [cite: 446]
- **Walid Zouitina** - Data and Software Engineering

---

_Developed as part of the Time Series Analysis module at the **Institut National de Statistique et d'Économie Appliquée (INSEA)** (Academic Year: 2025-2026)._
