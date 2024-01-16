

CREATE TABLE bellabeat.dbo.weight_cleaned
(Id FLOAT, Date DATETIME2(7), WeightKg FLOAT)

INSERT INTO bellabeat.dbo.weight_cleaned

SELECT
Id,
Date,
WeightKg

FROM bellabeat.dbo.weightLogInfo
