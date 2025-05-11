library(dplyr)
library(ggplot2)
library(corrplot)
library(RColorBrewer)
library(car)
library(leaps)



#import the data
ames<-read.csv("AmesHousing.csv")


#step 2
#Exploratory data analysis for the dataset
#summary information fo the data
summary(ames)
head(ames)
str(ames)
dim(ames)

#Descriptive statistics for sale price
summary(ames$SalePrice)

#histograms of Sale price
hist(ames$SalePrice, main = "Distribution of SalePrice", xlab = "SalePrice", col = "skyblue", breaks = 30)

#Boxplot of sale price
boxplot(ames$SalePrice, main = "Boxplot of SalePrice", col = "skyblue")


#View scatter plots of Ground living area and sale price
scatterplot(SalePrice ~ Gr.Liv.Area, data = ames,
            main = "Scatterplot: SalePrice vs GrLivArea",
            col = "skyblue", pch = 19)

#View scatter plots of total basement square feet area and sale price
scatterplot(SalePrice ~ Total.Bsmt.SF, data = ames,
            main = "Scatterplot: SalePrice vs TotalBsmtSF",
            col = "green", pch = 19)


#View scatter plots of garage area and sale price
scatterplot(SalePrice ~ Garage.Area, data = ames,
            main = "Scatterplot: SalePrice vs GarageArea",
            col = "purple", pch = 19)

#counting missing values
missing_counts <- colSums(is.na(ames))
missing_counts[missing_counts > 0]

#percentage of missing values inside their column
missing_percent <- colMeans(is.na(ames)) * 100
missing_percent[missing_percent > 0]

#analyzing histogram form to validate which is the best input to use(mean, median, mode or zero)
#histogram of Lot. Frontage
hist(ames$Lot.Frontage, main = "Distribution of Lot.Frontage",
     xlab = "Lot.Frontage", col = "skyblue", breaks = 30) #imputing the mmedian becasue it is right skewed distributed and it is 16% of missing valuesso we need to be carefull by selecting the best selection in this case is median , because choosing mean will be to simplistic


# Garage.Yr.Blt
hist(ames$Garage.Yr.Blt, main = "Distribution of Garage.Yr.Blt",
     xlab = "Garage.Yr.Blt", col = "lightgreen", breaks = 30) #imputing the median becasue it is normally  distributed and it is 5.4% of missing values

summary(ames$Garage.Yr.Blt)
boxplot(ames$Garage.Yr.Blt, main = "Boxplot of Garage.Yr.Blt", col = "lightblue")


# Mas.Vnr.Area
hist(ames$Mas.Vnr.Area, main = "Distribution of Mas.Vnr.Area",
     xlab = "Mas.Vnr.Area", col = "salmon", breaks = 30) #even though it is right extremely right skewed, its missing values is less than 1% this make safe to input with zero

# Scatterplot Matrix for selected variables
scatterplotMatrix(~ Gr.Liv.Area + Total.Bsmt.SF + Garage.Area + SalePrice,
                  data = ames,
                  spread = FALSE,
                  smoother.args = list(lty = 2),
                  main = "Scatterplot Matrix: Ames Housing Variables")

#step 3 - imputing missing values

#removing observations greater than 4000 based on the documentation
ames <- ames[ames$Gr.Liv.Area <= 4000, ]

#filtering to exclude foreclosures and family sales based on the documentation
ames <- ames[ames$Sale.Condition %in% c("Normal", "Alloca", "AdjLand"), ]


# Impute Lot.Frontage using median because it's right-skewed and has 16.7% missing values.
# Mean would be too sensitive to outliers.
ames$Lot.Frontage[is.na(ames$Lot.Frontage)] <- median(ames$Lot.Frontage, na.rm = TRUE)


# Impute Garage.Yr.Blt using median.
ames$Garage.Yr.Blt[is.na(ames$Garage.Yr.Blt)] <- median(ames$Garage.Yr.Blt, na.rm = TRUE)


# Impute Mas.Vnr.Area using 0.
# This variable is extremely right-skewed and most values are already 0 (indicating no veneer).
# Since missingness is <1%, it's safe to impute with 0.
ames$Mas.Vnr.Area[is.na(ames$Mas.Vnr.Area)] <- 0



#impute the other numerical variables
ames$BsmtFin.SF.1[is.na(ames$BsmtFin.SF.1)] <- median(ames$BsmtFin.SF.1, na.rm = TRUE)
ames$BsmtFin.SF.2[is.na(ames$BsmtFin.SF.2)] <- median(ames$BsmtFin.SF.2, na.rm = TRUE)
ames$Bsmt.Unf.SF[is.na(ames$Bsmt.Unf.SF)]   <- median(ames$Bsmt.Unf.SF, na.rm = TRUE)
ames$Total.Bsmt.SF[is.na(ames$Total.Bsmt.SF)] <- median(ames$Total.Bsmt.SF, na.rm = TRUE)

ames$Bsmt.Full.Bath[is.na(ames$Bsmt.Full.Bath)] <- median(ames$Bsmt.Full.Bath, na.rm = TRUE)
ames$Bsmt.Half.Bath[is.na(ames$Bsmt.Half.Bath)] <- median(ames$Bsmt.Half.Bath, na.rm = TRUE)

ames$Garage.Cars[is.na(ames$Garage.Cars)] <- median(ames$Garage.Cars, na.rm = TRUE)
ames$Garage.Area[is.na(ames$Garage.Area)] <- median(ames$Garage.Area, na.rm = TRUE)




#step 4 and step 5
cor_vars <- ames_numeric[, c("SalePrice", "Overall.Qual", "Gr.Liv.Area", "Garage.Area", "Total.Bsmt.SF", 
                             "X1st.Flr.SF", "Garage.Cars", "Year.Built", "Lot.Area", "Full.Bath")]

# Create cleaner correlation matrix
cor_subset <- cor(cor_vars, use = "complete.obs")

#correlation matrix
corrplot(cor_subset,
         type = "upper",
         col = brewer.pal(n = 8, name = "RdYlBu"),
         addCoef.col = "black",
         tl.cex = 0.8,
         number.cex = 0.7,
         tl.col = "black",
         mar = c(0,0,1,0),
         title = "Focused Correlation Matrix")


#step 6

# Highest correlation
scatterplot(SalePrice ~ Overall.Qual, data = ames,
            main = "SalePrice vs Overall Quality",
            col = "steelblue", pch = 19)


# Lowest correlation
scatterplot(SalePrice ~ Lot.Area, data = ames,
            main = "SalePrice vs Lot Area",
            col = "tomato", pch = 19)

# Correlation closest to 0.5
scatterplot(SalePrice ~ Full.Bath, data = ames,
            main = "SalePrice vs Full Bathrooms",
            col = "darkgreen", pch = 19)


#step 7 and step 8
# Fit the multiple linear regression model
model <- lm(SalePrice ~ Gr.Liv.Area + Total.Bsmt.SF + Garage.Area, data = ames)
summary(model)


#step 9 - Plot the regression model
# Step 9
par(mfrow = c(2, 2))  
plot(model)
dev.off()

# Q-Q Plot for normality of residuals
qqPlot(model, labels = row.names(ames), simulate = TRUE, main = "Q-Q Plot of Residuals")

# Component + Residual (Partial Residual) Plots to assess linearity
crPlots(model, main = "Component + Residual Plots")

# Spread-Level Plot to check constant variance (homoscedasticity)
spreadLevelPlot(model, main = "Spread-Level Plot")

#step 10 -  Check VIF for multicollinearity
vif(model)


#step 11
# 1. Outliers (Extreme residuals)
outlierTest(model)


# 2. High Leverage Observations
hat.plot <- function(fit) {
  p <- length(coefficients(fit))
  n <- length(fitted(fit))
  plot(hatvalues(fit), main = "Index Plot of Hat Values")
  abline(h = c(2, 3) * p / n, col = "red", lty = 2)
  identify(1:n, hatvalues(fit), names(hatvalues(fit)))
}

hat.plot(model)

# 3. Influential Observations using Cook's Distance
cutoff <- 4 / (nrow(ames) - length(model$coefficients) - 2)
plot(model, which = 4, cook.levels = cutoff)
abline(h = cutoff, lty = 2, col = "red")



# Step 12: Remove influential observations
ames_cleaned <- ames[-c(433, 1064, 2446), ]

# Refit the model
model_cleaned <- lm(SalePrice ~ Gr.Liv.Area + Total.Bsmt.SF + Garage.Area, data = ames_cleaned)

# Compare with original model
summary(model)
summary(model_cleaned)


#step 13 


# Run all-subsets regression
leaps <- regsubsets(SalePrice ~ Gr.Liv.Area + Total.Bsmt.SF + Garage.Area + 
                      Overall.Qual + Year.Built + X1st.Flr.SF + Full.Bath + Garage.Cars,
                    data = ames_cleaned)

# Visualize the performance of subsets using Adjusted R²
plot(leaps, scale = "adjr2")

#step 14
#linear regression model with the 7 predictors
model7 <- lm(SalePrice ~ Gr.Liv.Area + Total.Bsmt.SF + Garage.Area + 
               Overall.Qual + Year.Built + X1st.Flr.SF + Full.Bath,
             data = ames_cleaned)
summary(model7)
summary(model_cleaned)



# Compare AIC and BIC
AIC(model_cleaned)
BIC(model_cleaned)

AIC(model7)
BIC(model7)



