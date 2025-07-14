
# 📊 Shiny App – Descriptive Statistics Explorer

This Shiny application allows users to perform basic descriptive statistics on their own datasets.

## ✅ Features

- 📁 Upload your dataset (`.csv` or `.xlsx`)
- 🧮 For **quantitative variables**:
  - Display the median
  - Customize histogram (number of classes and color)
- 📊 For **categorical variables**:
  - Display frequency tables in **percentages**
- 📌 Select variables directly by **name**, not by number

## 🚀 How to Run the App

1. Make sure all required packages are installed:
   ```r
   install.packages(c("shiny", "readr", "readxl"))
   ```

2. Place the `app.R` file in a folder (e.g., `descriptive-app/`)

3. From R or RStudio, run:
   ```r
   shiny::runApp("descriptive-app")
   ```

   Or simply open `app.R` in RStudio and click **Run App**.

## 📂 Expected File Format

- Your data should be in `.csv` or `.xlsx` format
- Categorical variables will be recognized automatically if they are of type **character** or **factor**
- Make sure variable names are clean (no special characters)

## 🛠 Dependencies

- `shiny`
- `readr` (for `.csv` files)
- `readxl` (for `.xlsx` files)

## 👤 Author

Sèjro Toussaint BOCO – Data Scientist / Statistician
