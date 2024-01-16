---Calculating number of users and averages


---1) Tracking their physical activities

SELECT 
COUNT(DISTINCT ID) AS users_tracking_activity,
AVG(TotalSteps) AS average_steps,
AVG(TotalDistance) AS average_Distance,
AVG(Calories) AS average_calories
FROM bellabeat.dbo.daily_activity_cleaned

---2) Tracking heart rate

SELECT 
COUNT(DISTINCT Id) AS users_tracking_heartRate,
AVG(Value) AS average_heartRate,
MIN(Value) AS minimum_heartRate,
MAX(Value) AS maximum_heartRate
FROM bellabeat.dbo.heartrate_seconds


---3) Tracking Sleep

SELECT
COUNT(DISTINCT Id) AS users_tracking_sleep,
AVG(TotalMinutesAsleep)/60.0 AS average_hours_asleep,
MIN(TotalMinutesAsleep)/60.0 AS minimum_hours_asleep,
MAX(TotalMinutesAsleep)/60.0 AS maximum_hours_asleep,
AVG(TotalMinutesAsleep)/60.0 AS average_hours_InBed
FROM
bellabeat.dbo.sleep_day

---4) Tracking Weight

SELECT
COUNT(DISTINCT Id) AS users_tracking_Weight,
AVG(WeightKg) AS average_weight,
MIN(WeightKg) AS minimum_weight,
MAX(WeightKg) AS maximum_weight
FROM
bellabeat.dbo.weight_cleaned
