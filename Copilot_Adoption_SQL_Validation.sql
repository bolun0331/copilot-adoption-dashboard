SELECT
    COUNT(*) AS TotalRows,
    COUNT(DISTINCT [UserKey]) AS TotalEmployees
FROM [dbo].[CopilotUsers];

SELECT COUNT(*) AS TotalRows
FROM [CopilotInteractions];

select
    weekstart,
    count(distinct ActivityDate) as ActiveDays,
    count(distinct UserKey) as WeeklyActiveUsers
from dbo.CopilotInteractions
group by weekstart
order by weekstart desc;

SELECT
    COLUMN_NAME,
    DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo'
  AND TABLE_NAME = 'CopilotInteractions'
ORDER BY ORDINAL_POSITION;

WITH WeeklyCoverage AS (
    SELECT
        WeekStart,
        COUNT(DISTINCT ActivityDate) AS ActiveDays
    FROM dbo.CopilotInteractions
    GROUP BY WeekStart
),
SelectedWeeks AS (
    SELECT
        MAX(WeekStart) AS LatestWeek,
        DATEADD(day, -7, MAX(WeekStart)) AS PreviousWeek
    FROM WeeklyCoverage
    WHERE ActiveDays = 7
),
LatestUsers AS (
    SELECT DISTINCT i.UserKey
    FROM dbo.CopilotInteractions AS i
    CROSS JOIN SelectedWeeks AS w
    WHERE i.WeekStart = w.LatestWeek
      AND i.Has_license = 1
      AND i.Environment = 'Licensed M365 Copilot'
),
PreviousUsers AS (
    SELECT DISTINCT i.UserKey
    FROM dbo.CopilotInteractions AS i
    CROSS JOIN SelectedWeeks AS w
    WHERE i.WeekStart = w.PreviousWeek
      AND i.Has_license = 1
      AND i.Environment = 'Licensed M365 Copilot'
),
RepeatUsers AS (
    SELECT UserKey FROM PreviousUsers
    INTERSECT
    SELECT UserKey FROM LatestUsers
)
SELECT
    (SELECT COUNT(*) FROM PreviousUsers) AS PreviousWeekActive,
    (SELECT COUNT(*) FROM LatestUsers) AS LatestWeekActive,
    (SELECT COUNT(*) FROM RepeatUsers) AS TwoWeekRepeatUsers;