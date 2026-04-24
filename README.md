# Experimental Design and Statistical Analysis (STA305)

This repository contains a comprehensive statistical analysis project focused on Experimental Design methodologies. The project involves analyzing various experimental structures, assessing assumptions, and interpreting results for real-world datasets using R.

## Project Overview
The analysis is divided into four key statistical components:
1. **Two-Treatment Comparison:** Evaluating wheat yield differences between two fertilizer levels using t-tests and Empirical CDF plots.
2. **Power & Sample Size:** Calculating required sample sizes for 80% power and discussing the impact of variability on experimental reliability.
3. **Latin Square Design:** Analyzing serum calcium levels and weight loss data while controlling for two nuisance factors.
4. **$2^k$ Factorial Design:** Exploring interactions between food diaries, activity levels, and home visits on weight loss using interaction plots and Normal plots of effects.

## File Descriptions
* **`Experiment-Design.pdf`**: The final compiled report containing all visualizations, statistical tables, and written interpretations. **(Start here for a quick overview)**.
* **`Experiment Design.Rmd`**: The source RMarkdown file containing the code and documentation integrated into one document.
* **`Experiment_Design.R`**: A standalone R script for reproducing the statistical calculations and plots.

## Key Technical Skills
* **Statistical Methodology:** ANOVA, Latin Square Designs, $2^k$ Factorial Designs, Power Analysis.
* **Data Visualization:** Interaction plots, Q-Q plots, Side-by-side Boxplots, and Daniel Plots (Normal plots of effects).
* **Software:** R (scidesignR, FrF2, and base stats libraries), LaTeX (via RMarkdown).
* **Assumptions Testing:** Shapiro-Wilk tests for normality and residual analysis for constant variance.

## How to Run
1. Ensure you have R and the `scidesignR` and `FrF2` packages installed.
2. Open `Experiment Design.Rmd` in RStudio.
3. Knit the file to PDF to generate the full report.

---
