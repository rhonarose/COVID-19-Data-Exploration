# COVID-19 Data Analysis Project

## Overview
This project focuses on exploring COVID-19 data related to deaths and vaccinations from **January 5, 2020, to August 4, 2024**. The original dataset was sourced from **Our World in Data** and has been split into two separate Excel files for easier access:

- **CovidDeaths**: Contains information about COVID-19 related deaths worldwide.
- **CovidVaccinations**: Includes details about vaccination counts across various locations.

## Datasets Location
The datasets used for this analysis are available on my [Kaggle](https://www.kaggle.com/datasets/rhonarosecortez/covid-19-dataset) account for public access.

## Datasets

### 1. CovidDeaths
- **File Name**: `CovidDeaths.xlsx`
- **Description**: This dataset contains the number of deaths attributed to COVID-19 across various countries and regions. Key columns include:
  - `Location`: The name of the country or region.
  - `Date`: The date when the data was recorded.
  - `Total_Cases`: The total number of confirmed COVID-19 cases.
  - `Total_Deaths`: The total number of confirmed COVID-19 related deaths.
  - `Population`: The population of the respective location.

### 2. CovidVaccinations
- **File Name**: `CovidVaccinations.xlsx`
- **Description**: This dataset contains information on vaccination counts. Key columns include:
  - `Location`: The name of the country or region.
  - `Date`: The date when the data was recorded.
  - `New_Vaccinations`: The number of new vaccinations administered on that date.
  - `Total_Vaccinations`: The cumulative number of vaccinations administered.

## Objectives
- Analyze the total COVID-19 cases and deaths over the specified timeframe.
- Compute the death percentage relative to confirmed cases.
- Evaluate the percentage of the population infected by COVID-19.
- Assess vaccination rates against the population across various regions.

## Methodology
The analysis utilizes two primary datasets: **CovidDeaths** and **CovidVaccinations**. Data manipulation and exploration are performed using SQL to extract meaningful insights from the raw data.

## Key Analysis Areas

### Total Cases vs Total Deaths
- Assess the death rate from COVID-19 in different regions.
- Investigate the correlation between total cases and total deaths.

### Total Cases vs Population
- Calculate the percentage of the population that contracted COVID-19 over time.
- Analyze trends in infection rates relative to population size.

### Vaccination Data
- Analyze vaccination rates and their relationship with population metrics.
- Examine the total number of vaccinations administered over time.

### Regional Insights
- Identify countries with the highest infection and death rates.
- Compare COVID-19 impacts across different continents.

## Insights and Findings
- The analysis provides insights into the trends and impacts of COVID-19 across various regions and populations.
- The findings highlight disparities in infection rates and vaccination coverage.
- This project aims to contribute to a better understanding of the pandemic’s trajectory and the effectiveness of public health responses.

## Requirements

### Software and Tools
- **SQL Server**: To run SQL queries and perform data manipulation.
- **Excel**: To open and view the datasets.
- **Kaggle Account**: To access the datasets.

## How to Use
1. **Access Datasets**: Visit my Kaggle account to download the datasets.
2. **Load Data**: Load the `CovidDeaths` and `CovidVaccinations` datasets into your SQL Server database.
3. **Run SQL Queries**: Execute the provided SQL queries to perform the analysis.

## Future Work
- Explore additional metrics such as hospitalization rates and demographics of the affected population.
- Implement data visualization techniques to better represent the findings.
- Consider comparing this data with other countries or regions to assess differences in responses to the pandemic.
