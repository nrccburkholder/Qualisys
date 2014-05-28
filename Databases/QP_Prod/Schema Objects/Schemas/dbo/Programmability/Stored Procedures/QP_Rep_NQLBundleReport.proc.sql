CREATE PROCEDURE [dbo].[QP_Rep_NQLBundleReport]
    @Associate varchar(50),    
    @BeginDate datetime,
    @EndDate datetime
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @ProcedureBegin datetime

--Save the start time
SET @ProcedureBegin = GETDATE()

--Fix the EndDate
SET @EndDate = Convert(varchar, @EndDate, 101) + ' 23:59:59'

--Create the temp table
CREATE TABLE #Bundles (ClientName varchar(40), 
                       ClientID int, 
                       StudyName varchar(10), 
                       StudyID int, 
                       SurveyName varchar(10), 
                       SurveyID int, 
                       BundleName varchar(10), 
                       BundledDate datetime, 
                       PaperConfig varchar(40), 
                       MinLitho varchar(10), 
                       MaxLitho varchar(10), 
                       Quantity int)

--Populate the temp table
INSERT INTO #Bundles (ClientName, ClientID, StudyName, StudyID, SurveyName, SurveyID, BundleName, BundledDate, PaperConfig, MinLitho, MaxLitho, Quantity)
SELECT cl.strClient_Nm, cl.Client_ID, st.strStudy_Nm, st.Study_ID, sd.strSurvey_Nm, sd.Survey_ID, sm.strPostalBundle, sm.datBundled, pc.strPaperConfig_Nm, MIN(sm.strLithoCode), MAX(sm.strLithoCode), Count(*)
FROM Client cl, Study st, Survey_Def sd, QuestionForm qf, SentMailing sm, PaperConfig pc
WHERE cl.Client_ID = st.Client_ID
  and st.Study_ID = sd.Study_ID
  and sd.Survey_ID = qf.Survey_ID
  and qf.SentMail_ID = sm.SentMail_ID
  and sm.PaperConfig_ID = pc.PaperConfig_ID
  and sm.strPostalBundle = 'FOR'
  and sm.datBundled > @BeginDate
  and sm.datBundled <= @EndDate
GROUP BY cl.strClient_Nm, cl.Client_ID, st.strStudy_Nm, st.Study_ID, sd.strSurvey_Nm, sd.Survey_ID, sm.strPostalBundle, sm.datBundled, pc.strPaperConfig_Nm

--Get the return dataset
SELECT RTrim(ClientName) + ' (' + Convert(varchar, ClientID) + ')' AS Client, 
       RTrim(StudyName) + ' (' + Convert(varchar, StudyID) + ')' AS Study,
       RTrim(SurveyName) + ' (' + Convert(varchar, SurveyID) + ')' AS Survey,
       RTrim(BundleName) AS Bundle, BundledDate AS [Date Bundled],
       MinLitho + ' - ' + MaxLitho AS [Litho Range], Quantity, PaperConfig AS [Paper Config]
FROM #Bundles
ORDER BY BundledDate

--Cleanup the temp tables
DROP TABLE #Bundles

--Log the report run
INSERT INTO DashBoardLog (Report, Associate, StartDate, EndDate, ProcedureBegin, ProcedureEnd) 
VALUES ('NQL Bundle Report', @Associate, @BeginDate, @EndDate, @ProcedureBegin, GETDATE())

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


