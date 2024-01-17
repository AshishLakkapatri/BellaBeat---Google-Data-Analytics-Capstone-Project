-- Cleaning daily_Activity

-- Create a new table 'daily_activity_cleaned' in the 'bellabeat.dbo' schema with appropriate data types
CREATE TABLE bellabeat.dbo.daily_activity_cleaned (
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
)

-- Insert cleaned data into the 'daily_activity_cleaned' table
INSERT INTO bellabeat.dbo.daily_activity_cleaned (
    Id,
    ActivityDate,
    TotalSteps,
    TotalDistance,
    VeryActiveDistance,
    ModeratelyActiveDistance,
    LightActiveDistance,
    SedentaryActiveDistance,
    VeryActiveMinutes,
    FairlyActiveMinutes,
    LightlyActiveMinutes,
    SedentaryMinutes,
    Calories
)
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
    bellabeat.dbo.daily_Activity

-- Calculate the number of days each user tracked physical activity
SELECT
    DISTINCT Id,
    COUNT(ActivityDate) OVER (PARTITION BY Id) AS days_activity_recorded
FROM
    bellabeat.dbo.daily_activity_cleaned
ORDER BY
    days_activity_recorded DESC

-- Calculate Average minutes for each activity
SELECT
    AVG(VeryActiveMinutes) AS AverageVeryActiveMinutes,
    AVG(FairlyActiveMinutes) AS AverageFairlyActiveMinutes,
    ROUND(AVG(LightlyActiveMinutes)/60.0,2) AS AverageLightlyActiveMinutes,
    ROUND(AVG(SedentaryMinutes)/60.0,2) AS AverageSedentaryMinutes
FROM
    bellabeat.dbo.daily_activity_cleaned

-- Cleaning weightlog

-- Create a new table 'weight_cleaned' in the 'bellabeat.dbo' schema with appropriate data types
CREATE TABLE bellabeat.dbo.weight_cleaned (
    Id FLOAT,
    Date DATETIME2(7),
    WeightKg FLOAT
)

-- Insert cleaned data into the 'weight_cleaned' table
INSERT INTO bellabeat.dbo.weight_cleaned
SELECT
    Id,
    Date,
    WeightKg
FROM 
    bellabeat.dbo.weightLogInfo

-- Calculating number of users and averages

-- 1) Tracking their physical activities
SELECT 
    COUNT(DISTINCT ID) AS users_tracking_activity,
    AVG(TotalSteps) AS average_steps,
    AVG(TotalDistance) AS average_Distance,
    AVG(Calories) AS average_calories
FROM 
    bellabeat.dbo.daily_activity_cleaned

-- 2) Tracking heart rate
SELECT 
    COUNT(DISTINCT Id) AS users_tracking_heartRate,
    AVG(Value) AS average_heartRate,
    MIN(Value) AS minimum_heartRate,
    MAX(Value) AS maximum_heartRate
FROM 
    bellabeat.dbo.heartrate_seconds

-- 3) Tracking Sleep
SELECT
    COUNT(DISTINCT Id) AS users_tracking_sleep,
    AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
    MIN(TotalMinutesAsleep)/60.0 AS minimum_hours_asleep,
    MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
    AVG(TotalMinutesAsleep)/60.0 AS average_hours_InBed
FROM
    bellabeat.dbo.sleep_day

-- 4) Tracking Weight
SELECT
    COUNT(DISTINCT Id) AS users_tracking_Weight,
    AVG(WeightKg) AS average_weight,
    MIN(WeightKg) AS minimum_weight,
    MAX(WeightKg) AS maximum_weight
FROM
    bellabeat.dbo.weight_cleaned

-- 5) Determine time when users were mostly active

SELECT 
    DISTINCT(CAST(ActivityHour AS TIME)) AS activity_time,
    AVG(TotalIntensity) OVER (PARTITION BY DATEPART(HOUR,ActivityHour)) AS average_intensity,
    AVG(METs/10.0) OVER (PARTITION BY DATEPART(HOUR,ActivityHour)) AS average_METs
FROM 
    bellabeat.dbo.hourly_activity AS hourly_activity
JOIN 
    bellabeat.dbo.minuteMETs_Narrow AS METs
ON
    hourly_activity.Id = METs.Id
AND
    hourly_activity.ActivityHour = METs.ActivityMinute
ORDER BY 
    average_intensity DESC
