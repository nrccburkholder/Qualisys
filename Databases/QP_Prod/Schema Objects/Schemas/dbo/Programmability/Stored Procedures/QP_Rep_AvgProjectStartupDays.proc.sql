CREATE PROCEDURE QP_Rep_AvgProjectStartupDays

@FirstMailMonth datetime

AS

SELECT     AVG(Project_Startup_Days) AS Project_Start_Up_Days
FROM         dbo.TeamStatus_ProjectStartUp_View
WHERE     (Project_Startup_Days IS NOT NULL) AND (DATEPART(yy, FirstMail_dt) = DATEPART(yy, @FirstMailMonth)) AND (DATEPART(mm, FirstMail_dt) = DATEPART(mm,@FirstMailMonth))


