CREATE PROCEDURE [dbo].[QP_Rep_NQLBundleReportTitle]
    @Associate varchar(50),    
    @BeginDate datetime,
    @EndDate datetime
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Select the title data
SELECT Convert(varchar, @BeginDate, 101) AS [From], Convert(varchar, @EndDate, 101) AS [To]

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


