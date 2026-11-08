/*
Copilot Adoption Dashboard - SQL Validation
Author: Bolun Zhang
Database: CopilotPortfolio
Platform: Microsoft SQL Server

Purpose:
Validate the principal KPIs displayed in the Power BI dashboard.

Expected portfolio results:
- Total employees: 10,050
- Licensed employees: 6,499
- Latest full-week AI active users: 7,705
- Latest full-week licensed Copilot active users: 4,824
- Previous full-week licensed Copilot active users: 5,226
- Two-week repeat users: 4,288
- New or returning users: 536
- Lapsed users: 938
*/

USE CopilotPortfolio;
GO

SET NOCOUNT ON;

DECLARE @LatestWeek date;
DECLARE @PreviousWeek date;

/* Identify the latest and previous complete seven-day weeks. */
SELECT @LatestWeek = MAX(WeekStart)
FROM (
    SELECT WeekStart
    FROM dbo.CopilotInteractions
    GROUP BY WeekStart
    HAVING COUNT(DISTINCT ActivityDate) = 7
) AS CompleteWeeks;

SELECT @PreviousWeek = MAX(WeekStart)
FROM (
    SELECT WeekStart
    FROM dbo.CopilotInteractions
    GROUP BY WeekStart
    HAVING COUNT(DISTINCT ActivityDate) = 7
) AS CompleteWeeks
WHERE WeekStart < @LatestWeek;

SELECT
    @PreviousWeek AS PreviousCompleteWeek,
    @LatestWeek AS LatestCompleteWeek;


/* 1. Workforce and licensing overview. */
SELECT
    COUNT(DISTINCT UserKey) AS TotalEmployees,
    COUNT(DISTINCT CASE
        WHEN TRY_CONVERT(bit, [Has license]) = 1 THEN UserKey
    END) AS LicensedEmployees
FROM dbo.CopilotUsers;


/* 2. Organization-wide AI reach in the latest complete week. */
SELECT
    COUNT(DISTINCT UserKey) AS LatestWeekActiveAIUsers
FROM dbo.CopilotInteractions
WHERE WeekStart = @LatestWeek;


/* 3. Copilot activity by week.
   The environment rule intentionally includes any category containing "Copilot". */
WITH LicensedCopilotActivity AS (
    SELECT DISTINCT
        UserKey,
        WeekStart
    FROM dbo.CopilotInteractions
    WHERE Has_license = 1
      AND LOWER(Environment) LIKE '%copilot%'
      AND WeekStart IN (@PreviousWeek, @LatestWeek)
)
SELECT
    WeekStart,
    COUNT(DISTINCT UserKey) AS ActiveLicensedCopilotUsers
FROM LicensedCopilotActivity
GROUP BY WeekStart
ORDER BY WeekStart;


/* 4. Retention and user movement between the two complete weeks. */
WITH PreviousUsers AS (
    SELECT DISTINCT UserKey
    FROM dbo.CopilotInteractions
    WHERE WeekStart = @PreviousWeek
      AND Has_license = 1
      AND LOWER(Environment) LIKE '%copilot%'
),
LatestUsers AS (
    SELECT DISTINCT UserKey
    FROM dbo.CopilotInteractions
    WHERE WeekStart = @LatestWeek
      AND Has_license = 1
      AND LOWER(Environment) LIKE '%copilot%'
)
SELECT
    (SELECT COUNT(*) FROM PreviousUsers) AS PreviousWeekActiveUsers,
    (SELECT COUNT(*) FROM LatestUsers) AS LatestWeekActiveUsers,
    (
        SELECT COUNT(*)
        FROM PreviousUsers AS p
        INNER JOIN LatestUsers AS l
            ON p.UserKey = l.UserKey
    ) AS RepeatUsers,
    (
        SELECT COUNT(*)
        FROM LatestUsers AS l
        LEFT JOIN PreviousUsers AS p
            ON l.UserKey = p.UserKey
        WHERE p.UserKey IS NULL
    ) AS NewOrReturningUsers,
    (
        SELECT COUNT(*)
        FROM PreviousUsers AS p
        LEFT JOIN LatestUsers AS l
            ON p.UserKey = l.UserKey
        WHERE l.UserKey IS NULL
    ) AS LapsedUsers,
    CAST(
        100.0 * (
            SELECT COUNT(*)
            FROM PreviousUsers AS p
            INNER JOIN LatestUsers AS l
                ON p.UserKey = l.UserKey
        ) / NULLIF((SELECT COUNT(*) FROM PreviousUsers), 0)
        AS decimal(5, 1)
    ) AS RepeatRatePercent;


/* 5. Department-level license utilization opportunities. */
WITH LatestActiveCopilotUsers AS (
    SELECT DISTINCT UserKey
    FROM dbo.CopilotInteractions
    WHERE WeekStart = @LatestWeek
      AND Has_license = 1
      AND LOWER(Environment) LIKE '%copilot%'
)
SELECT
    u.Organization,
    COUNT(DISTINCT u.UserKey) AS LicensedEmployees,
    COUNT(DISTINCT a.UserKey) AS ActiveLicensedCopilotUsers,
    COUNT(DISTINCT u.UserKey) - COUNT(DISTINCT a.UserKey)
        AS InactiveLicensedEmployees,
    CAST(
        100.0 * COUNT(DISTINCT a.UserKey)
        / NULLIF(COUNT(DISTINCT u.UserKey), 0)
        AS decimal(5, 1)
    ) AS LicenseUtilizationPercent
FROM dbo.CopilotUsers AS u
LEFT JOIN LatestActiveCopilotUsers AS a
    ON u.UserKey = a.UserKey
WHERE TRY_CONVERT(bit, u.[Has license]) = 1
GROUP BY u.Organization
ORDER BY InactiveLicensedEmployees DESC;
