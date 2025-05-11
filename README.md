
# Regression Analysis - Ames Housing

This project is a comprehensive regression diagnostics and modeling analysis using the Ames Housing dataset. It was completed as part of the ALY6015 course at Northeastern University and follows a rigorous 14-step process to build and validate a multiple linear regression model in R.

## 📊 Project Summary

- **Dataset**: Ames Housing (2,930 observations, 82 variables)
- **Objective**: Predict `SalePrice` using statistically sound regression techniques
- **Tools**: R, ggplot2, car, leaps, corrplot, base R

## 🔍 Key Steps & Methods

1. **Exploratory Data Analysis (EDA)**: Histograms, boxplots, scatterplots, and summary statistics.
2. **Data Cleaning**: Imputation using median/zero based on distribution and documentation.
3. **Correlation Analysis**: Focused matrix using `corrplot` to guide feature selection.
4. **Modeling**: 
   - Built baseline regression model with 3 predictors.
   - Evaluated multicollinearity using VIF.
   - Assessed residual plots (linearity, normality, homoscedasticity).
   - Identified and removed outliers, high leverage, and influential points.
5. **Model Refinement**: 
   - Compared cleaned vs. original model.
   - Applied all-subsets regression to select best 7-variable model.
6. **Model Evaluation**: Compared models using Adjusted R², Residual Standard Error, AIC, and BIC.

## ✅ Final Model (7 Variables)

`SalePrice = -828900 + 58.78(Gr.Liv.Area) + 26.88(Total.Bsmt.SF) + 35.61(Garage.Area) + 18360(Overall.Qual) + 385.6(Year.Built) + 17.43(X1st.Flr.SF) - 10420(Full.Bath)`

- **Adjusted R²**: 0.8344
- **Residual Std. Error**: 28,510

## 📁 Structure

```
├── README.md
├── regression_ames_report.pdf
├── AmesHousing.csv
├── analysis_code.R
└── figures/
    ├── histogram_saleprice.png
    ├── scatterplot_matrix.png
    ├── corrplot_matrix.png
    └── model_diagnostics.png
```

## 📚 References

- De Cock, D. (2011). *Ames, Iowa: Alternative to the Boston Housing Data*. Journal of Statistics Education.
- Provost, J.-S. (2025). *Regression diagnostics with R*. Northeastern University.
- Module 1 PDF: *Correlation and Regression* - ALY6015, Northeastern CPS.

---
_Created by Jose De Leon — Last updated: May 11, 2025_
