---Calculate the number of days each user tracked physical activity

SELECT
DISTINCT Id,
COUNT(ActivityDate) OVER (PARTITION BY Id) AS days_activity_recorded

FROM
bellabeat.dbo.daily_activity_cleaned

ORDER BY
days_activity_recorded DESC

---Calculate Average mnutes for each activity

SELECT
AVG(VeryActiveMinutes) AS AverageVeryActiveMinutes,
AVG(FairlyActiveMinutes) AS AverageFairlyActiveMinutes,
ROUND(AVG(LightlyActiveMinutes)/60.0,2) AS AverageLightlyActiveMinutes,
ROUND(AVG(SedentaryMinutes)/60.0,2) AS AverageSedentaryMinutes
FROM
bellabeat.dbo.daily_activity_cleaned