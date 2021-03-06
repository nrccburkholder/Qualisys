USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_ValidateSurvey]    Script Date: 8/13/2014 10:56:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[QCL_ValidateSurvey]
@SurveyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Surveyid

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Surveyid
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1
  
CREATE Table #Messages (  
     Message_id INT IDENTITY(1,1),   
     Error INT,   
     strMessage VARCHAR(200)  
)  
CREATE Table #Procs (  
     intOrder INT,
	 SurveyValidationProcs_id INT,   
     ProcedureName VARCHAR(100)  
)  

-- using a view
INSERT INTO #Procs 
SELECT svp.intOrder, svp.SurveyValidationProcs_id, svp.ProcedureName
FROM SurveyValidationProcs_view svp
WHERE svp.CAHPSType_Id is null
UNION  
SELECT svp.intOrder, svp.SurveyValidationProcs_id, svp.ProcedureName
FROM SurveyValidationProcs_view svp
WHERE svp.CAHPSType_Id = @surveyType_id and svp.SubType_ID is NULL
UNION
SELECT svp.intOrder, svp.SurveyValidationProcs_id, svp.ProcedureName
FROM SurveyValidationProcs_view svp
WHERE svp.CAHPSType_Id = @surveyType_id and svp.SubType_ID = @subtype_id
  
DECLARE @Proc VARCHAR(100), @sql VARCHAR(8000)  
  
SELECT TOP 1 @Proc=ProcedureName  
FROM #Procs  
ORDER BY intOrder  
  
WHILE @@ROWCOUNT>0  
BEGIN  
  
SELECT @sql=' INSERT INTO #Messages EXEC dbo.'+@Proc+' '+LTRIM(STR(@SurveyId))
EXEC (@sql)  
  
DELETE #Procs   
WHERE ProcedureName=@Proc  
  
SELECT TOP 1 @Proc=ProcedureName  
FROM #Procs  
ORDER BY intOrder  
  
END  
  
--Now to log the messages  
INSERT INTO SurveyValidationResults (Survey_id, datRan, Error, strMessage)  
SELECT @SurveyId, GETDATE(), Error, strMessage  
FROM #Messages  
  
--Now to return the messages to the app.  
SELECT Error, strMessage  
FROM #Messages  
ORDER BY Error, Message_id  
  
DROP TABLE #Messages  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF
