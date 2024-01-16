# Bellabeat Data Analysis Case Study

## Overview
Welcome to the Bellabeat Data Analysis Case Study! This repository contains all the resources and information I need to dive into the world of data analysis for Bellabeat, a wellness technology company focusing on health products for women. This case study is part of the Google Data Analytics Capstone Project, where, as a junior data analyst, I'll follow a series of real-world tasks, meeting various characters and team members along the way.

## Case Study Objectives
The primary goal of this case study is to provide a hands-on experience in addressing key business questions through the data analysis process: ask, prepare, process, analyze, share, and act. By the end, I'll have a portfolio-ready case study that showcases my skills and knowledge.

## Case Study Roadmap
You can navigate through the analysis using the Case Study Roadmap provided. It includes guiding questions and key tasks at each stage, ensuring a structured and focused approach. Refer to the roadmap regularly to track your progress.

## Tools Used For Analysis
1. **Microsoft Excel**
2. **Microsoft SQL Server Management Studio**

## Instructions for Use
1. **Download the Google Data Analytics Project guidance file**: Start by downloading the file, which includes all the details essential for the analysis ([INSTRUCTIONS.pdf](https://github.com/AshishLakkapatri/BellaBeat---Google-Data-Analytics-Capstone-Project/files/13941449/INSTRUCTIONS.pdf)).
2. **Download Official Datasets**: https://www.kaggle.com/datasets/arashnic/fitbit

3. **Reference Details**: Understand the business context, key stakeholders, and the nature of the provided data by reviewing the specifics of the case study.

4. **Follow the Case Study Roadmap**: Utilize the roadmap as your guide, answering guiding questions and completing key tasks at each stage to build a comprehensive case study.
     
5. **Google Data Analytics Capstone Project**:
   - `capstone_project_report.pdf`: A comprehensive report detailing the Google Data Analytics Capstone Project, including methodologies, analysis, and conclusions has been included in this repo.

## Key Sections

### Introduction
- Briefly introduce the Bellabeat case study.
- Provide an overview of the wellness technology industry.

### Ask
- Identify key business questions.
- Understand the objectives of the analysis.

### Prepare
- Collect and explore data.
- Clean and organize data for analysis.

### Process
- Transform and manipulate data.
- Prepare data for in-depth analysis.

### Analyze
- Utilize statistical and data analysis techniques.
- Draw meaningful insights from the data.

### Share
- Communicate findings effectively.
- Create visualizations and reports.

### Act
- Make data-driven recommendations.
- Provide actionable insights for the business.

## Conclusion
Active engagement with the Bellabeat Data Analysis Case Study, as part of the Google Data Analytics Capstone Project, not only hones your skills but also creates a valuable asset for your professional portfolio. Enjoy the journey and good luck!

# My Analysis
# Bellabeat Data Analysis

## Overview
This repository contains SQL queries and scripts for analyzing and cleaning Bellabeat's health and fitness data. The data is organized into various tables, such as `daily_activity_cleaned`, `heartrate_seconds`, `sleep_day`, and `weight_cleaned`. The queries aim to calculate key metrics related to user activities, heart rate, sleep patterns, and weight tracking.

## Queries

### Data Cleaning
#### Cleaning Daily_Activity
```
-- Create the cleaned table
CREATE TABLE bellabeat.dbo.daily_activity_cleaned
(
    Id FLOAT,
    ActivityDate DATETIME2(7),
    TotalSteps INT,
    TotalDistance FLOAT,
    VeryActiveDistance FLOAT,
    ModeratelyActiveDistance FLOAT,  
    LightActiveDistance FLOAT,
    SedentaryActiveDistance FLOAT,
    VeryActiveMinutes INT,
    FairlyActiveMinutes INT,
    LightlyActiveMinutes INT,
    SedentaryMinutes INT,
    Calories FLOAT
);

-- Insert cleaned data into the new table
INSERT INTO bellabeat.dbo.daily_activity_cleaned (Id, ActivityDate, TotalSteps, TotalDistance, VeryActiveDistance, ModeratelyActiveDistance, LightActiveDistance, SedentaryActiveDistance, VeryActiveMinutes, FairlyActiveMinutes, LightlyActiveMinutes, SedentaryMinutes, Calories)
SELECT 
    Id,
    ActivityDate,
    TotalSteps,
    CAST(TotalDistance AS FLOAT) AS TotalDistance,
    CAST(VeryActiveDistance AS FLOAT) AS VeryActiveDistance,
    CAST(ModeratelyActiveDistance AS FLOAT) AS ModeratelyActiveDistance,
    CAST(LightActiveDistance AS FLOAT) AS LightActiveDistance,
    CAST(SedentaryActiveDistance AS FLOAT) AS SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
FROM 
    bellabeat.dbo.daily_Activity;
```
#### Cleaning WeightLog_Info
```
-- Create the cleaned table
CREATE TABLE bellabeat.dbo.weight_cleaned
(
    Id FLOAT,
    Date DATETIME2(7),
    WeightKg FLOAT
);

-- Insert cleaned data into the new table
INSERT INTO bellabeat.dbo.weight_cleaned (Id, Date, WeightKg)
SELECT
    Id,
    Date,
    WeightKg
FROM bellabeat.dbo.weightLogInfo;
```

### Calculating Number of Users and Averages

#### Tracking Physical Activities
```sql
SELECT 
    COUNT(DISTINCT ID) AS users_tracking_activity,
    AVG(TotalSteps) AS average_steps,
    AVG(TotalDistance) AS average_distance,
    AVG(Calories) AS average_calories
FROM bellabeat.dbo.daily_activity_cleaned;
```
#### Tracking Heart Rate
```
SELECT 
    COUNT(DISTINCT Id) AS users_tracking_heartRate,
    AVG(Value) AS average_heartRate,
    MIN(Value) AS minimum_heartRate,
    MAX(Value) AS maximum_heartRate
FROM bellabeat.dbo.heartrate_seconds;
```

#### Tracking Sleep
```
SELECT
    COUNT(DISTINCT Id) AS users_tracking_sleep,
    AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
    MIN(TotalMinutesAsleep)/60.0 AS minimum_hours_asleep,
    MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
    AVG(TotalMinutesAsleep)/60.0 AS average_hours_inBed
FROM bellabeat.dbo.sleep_day;
```
#### Tracking Weight
```
SELECT
    COUNT(DISTINCT Id) AS users_tracking_Weight,
    AVG(WeightKg) AS average_weight,
    MIN(WeightKg) AS minimum_weight,
    MAX(WeightKg) AS maximum_weight
FROM bellabeat.dbo.weight_cleaned;
```
## Additional Analysis

#### Number of Days Each User Tracked Physical Activity
```
SELECT
    DISTINCT Id,
    COUNT(ActivityDate) OVER (PARTITION BY Id) AS days_activity_recorded
FROM bellabeat.dbo.daily_activity_cleaned
ORDER BY days_activity_recorded DESC;
```

#### Average Minutes for Each Activity

```
SELECT
    AVG(VeryActiveMinutes) AS AverageVeryActiveMinutes,
    AVG(FairlyActiveMinutes) AS AverageFairlyActiveMinutes,
    ROUND(AVG(LightlyActiveMinutes)/60.0, 2) AS AverageLightlyActiveMinutes,
    ROUND(AVG(SedentaryMinutes)/60.0, 2) AS AverageSedentaryMinutes
FROM bellabeat.dbo.daily_activity_cleaned;
```

#### Determine Time When Users Were Mostly Active
```
SELECT 
    DISTINCT(CAST(ActivityHour AS TIME)) AS activity_time,
    AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_intensity,
    AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR, ActivityHour)) AS average_METs
FROM bellabeat.dbo.hourly_activity AS hourly_activity
JOIN bellabeat.dbo.minuteMETs_Narrow AS METs
ON hourly_activity.Id = METs.Id
AND hourly_activity.ActivityHour = METs.ActivityMinute
ORDER BY average_intensity DESC;
```




