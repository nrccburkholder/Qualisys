USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_ValidateSurvey]    Script Date: 9/17/2014 4:28:59 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO

ALTER PROCEDURE [dbo].[QCL_ValidateSurvey]
@SurveyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  
  
CREATE Table #Messages (  
     Message_id INT IDENTITY(1,1),   
     Error INT,   
     strMessage VARCHAR(200)  
)  
CREATE Table #Procs (  
     intOrder INT,   
     ProcedureName VARCHAR(100)  
)  
  
INSERT INTO #Procs   
SELECT SurveyValidationProcs_id, ProcedureName  
FROM SurveyValidationProcs  
  
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

