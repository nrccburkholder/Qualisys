USE [QP_Prod]
GO


/****** Object:  Table [dbo].[SurveyValidationProcsBySurveyType]    Script Date: 8/15/2014 2:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[SurveyValidationProcsBySurveyType](
	[SurveyValidationProcsToSurveyType_id] [int] IDENTITY(1,1) NOT NULL,
	[SurveyValidationProcs_id] [int] NULL,
	[CAHPSType_ID] [int] NULL,
	[SubType_ID] [int] NULL
) ON [PRIMARY]

GO
/****** Object:  View [dbo].[SurveyValidationProcs_view]    Script Date: 8/15/2014 2:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

EXEC dbo.sp_executesql @statement = N'

CREATE VIEW [dbo].[SurveyValidationProcs_view]      
AS      
	SELECT svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	FROM SurveyValidationProcs svp
	LEFT JOIN SurveyValidationProcsBySurveyType svpst on (svpst.SurveyValidationProcs_id = svp.SurveyValidationProcs_id)
	WHERE svpst.CAHPSType_Id is null
	UNION
	select svp.SurveyValidationProcs_id, svp.ProcedureName, svp.intOrder, svpst.CAHPSType_ID, svpst.SubType_ID
	from SurveyValidationProcsBySurveyType svpst
	INNER JOIN SurveyValidationProcs svp ON (svp.SurveyValidationProcs_id = svpst.SurveyValidationProcs_id)
' 
GO


-- add SubType_ID to StandardMethodologyBySurveyType
ALTER TABLE [dbo].[StandardMethodologyBySurveyType]
ADD SubType_ID int NOT NULL DEFAULT(0)

GO


-- add SubType_ID to SurveyValidationFields
ALTER TABLE [dbo].[SurveyTypeQuestionMappings]
ADD SubType_ID int NULL

GO

-- add SubType_ID to SurveyValidationFields
ALTER TABLE SurveyValidationFields
ADD SubType_ID int NULL


GO

/****** Object:  StoredProcedure [dbo].[sp_FG_FormGen_Pop_PreMailingWork_TP]    Script Date: 8/15/2014 2:39:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_FG_FormGen_Pop_PreMailingWork_TP]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_FG_FormGen_Pop_PreMailingWork_TP]
GO
/****** Object:  StoredProcedure [dbo].[sp_FG_FormGen_Pop_PreMailingWork]    Script Date: 8/15/2014 2:39:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_FG_FormGen_Pop_PreMailingWork]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_FG_FormGen_Pop_PreMailingWork]
GO
/****** Object:  StoredProcedure [dbo].[QCL_ValidateSurvey]    Script Date: 8/15/2014 2:39:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_ValidateSurvey]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_ValidateSurvey]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]    Script Date: 8/15/2014 2:39:45 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
GO

/****** Object:  StoredProcedure [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]    Script Date: 8/15/2014 2:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
 @SurveyTypeID INT,
 @SubType_Id INT = NULL
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF @SubType_Id is NULL
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	ORDER BY sm.strStandardMethodology_nm
ELSE
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	AND smst.SubType_ID = @SubType_Id
	ORDER BY sm.strStandardMethodology_nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
' 
END
GO
/****** Object:  StoredProcedure [dbo].[QCL_ValidateSurvey]    Script Date: 8/15/2014 2:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[QCL_ValidateSurvey]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[QCL_ValidateSurvey]
@SurveyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Surveyid

-- only going to get subtypes where there is a bitOverride set, otherwise we''ll just use the SurveyType validation
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
  
SELECT @sql='' INSERT INTO #Messages EXEC dbo.''+@Proc+'' ''+LTRIM(STR(@SurveyId))
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
' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FG_FormGen_Pop_PreMailingWork]    Script Date: 8/15/2014 2:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_FG_FormGen_Pop_PreMailingWork]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*
Modified 5/23/2 BD  Adding 6 hours to GETDATE to automatically pick up Surveys that are set to generate after midnight.  
Modified 8/15/2 BD  Added the ability to generate multiple Mailingsteps in the same night.
Modified 7/3/3 BD  Remove duplicate Mailstep generations for the same person.  This can happen when the generation of
	firsts are rolled back, but the second Mailstep is not deleted. 
Modified 6/22/2014 TSB Added QuestionnaireType_ID to FG_PreMailingWork insert - AllCahps Sprint 2 R3.5
Modified 8/05/2014 TSB Modified QuestionnaireType_ID value to come from SurveySubType.Subtype_ID
*/
CREATE PROCEDURE [dbo].[sp_FG_FormGen_Pop_PreMailingWork]
AS
TRUNCATE TABLE FG_PreMailingWork

DECLARE @Study_id INT
DECLARE @sqlzip VARCHAR (250)
DECLARE ZipCursor CURSOR FOR SELECT DISTINCT Study_id FROM FG_PreMailingWork

-- Create a temp table for all Questionnaire Type SubTypes 8/5/2014 TSB
SELECT sst.Survey_id, sst.SubType_id
INTO #SurveyQuestionnaireSubtypes
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE st.SubtypeCategory_id = 2 -- 2 is QuestionnaireType category  

--Modified 8/5/2014 TSB - changed to use ANSI-compliant join and #SurveyQuestionnaireSubtypes
-- First insert the already Scheduled Surveys
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg, QuestionnaireType_ID)
SELECT SD.Study_id, SD.Survey_id, SP.SamplePop_id, SP.SampleSet_id, SP.Pop_id, SM.ScheduledMailing_id, SM.MailingStep_id, SM.Methodology_id, SM.OverRideItem_id, SD.Priority_Flg, SQSS.Subtype_id QuestionnaireType_ID
FROM   ScheduledMailing SM(NOLOCK)
INNER JOIN MailingMethodology MM(NOLOCK) ON MM.Methodology_id = SM.Methodology_id
INNER JOIN SamplePop SP(NOLOCK) ON SP.SamplePop_id = SM.SamplePop_id
INNER JOIN Survey_def SD(NOLOCK) ON MM.Survey_id = SD.Survey_id
LEFT JOIN #SurveyQuestionnaireSubtypes SQSS ON SQSS.Survey_id = sd.Survey_ID
WHERE  SM.SentMail_id IS NULL AND
       SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND
       SD.bitFormGenRelease = 1 AND
       SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError
	WHERE ScheduledMailing_id IS NOT NULL)

--Now to get rid of duplicated Mailsteps for people
SELECT SamplePop_id, MailingStep_id, MAX(ScheduledMailing_id) ScheduledMailing_id
INTO #keep
FROM fg_preMailingWork
GROUP BY SamplePop_id, MailingStep_id

--Get the list of scheduledmailing_ids to delete
SELECT f.ScheduledMailing_id 
INTO #del
FROM #keep t RIGHT OUTER JOIN fg_preMailingWork f
ON t.SamplePop_id = f.SamplePop_id
AND t.MailingStep_id = f.MailingStep_id
AND t.ScheduledMailing_id = f.ScheduledMailing_id
WHERE t.ScheduledMailing_id IS NULL

--Get rid of the fg_premailingwork records
DELETE f
FROM #del t, fg_preMailingWork f
where t.ScheduledMailing_id = f.ScheduledMailing_id

--Now to get rid of the scheduledmailing records
DELETE schm
FROM #del t, ScheduledMailing schm
where t.ScheduledMailing_id = schm.ScheduledMailing_id

--Clean up
DROP TABLE #del
DROP TABLE #keep
DROP TABLE #SurveyQuestionnaireSubtypes

--Determine additional Mailingsteps that need to generate
SELECT Study_id, f.Survey_id, SampleSet_id, Pop_id, Priority_flg, ms.MailingStep_id, SamplePop_id, f.Methodology_id, GETDATE() datgenerate, QuestionnaireType_ID
into #temp
FROM fg_preMailingWork f(NOLOCK), Mailingstep ms(NOLOCK)
WHERE f.MailingStep_id = ms.mmMailingStep_id
AND f.MailingStep_id <> ms.MailingStep_id

--Delete records already Scheduled
DELETE t
FROM #temp t, ScheduledMailing schm
WHERE t.MailingStep_id = schm.MailingStep_id
AND t.SamplePop_id = schm.SamplePop_id

--Schedule the additional Mailingsteps
INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, sentMail_id, Methodology_id, datgenerate)
SELECT MailingStep_id, SamplePop_id, NULL, NULL, Methodology_id, datgenerate
FROM #temp

--Insert the newly Scheduled Mailingsteps
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg, QuestionnaireType_ID)
SELECT Study_id, Survey_id, t.SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, t.MailingStep_id, t.Methodology_id, OverRideItem_id, Priority_Flg, t.QuestionnaireType_ID
FROM   #temp t, ScheduledMailing schm(NOLOCK)
WHERE  t.MailingStep_id = schm.MailingStep_id
AND t.SamplePop_id = schm.SamplePop_id
AND schm.OverRideItem_id is NULL

DROP TABLE #temp
--remove if blowup end
--Update the zip code fields
OPEN ZipCursor
FETCH NEXT FROM ZipCursor INTO @Study_id
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @SqlZip = ''UPDATE FG_PreMailingWork set zip5 =  p.zip5, zip4 = p.zip4 '' + CHAR(10) + 
	'' FROM s'' + CONVERT(VARCHAR(10),@Study_id) + ''.Population p, FG_PreMailingWork pm, SamplePop sp '' + CHAR(10) + 
	'' WHERE pm.Study_id = '' + CONVERT(VARCHAR(10),@Study_id) + CHAR(10) +
	'' AND pm.SamplePop_id=sp.SamplePop_id '' + CHAR(10) +
	'' AND sp.Pop_id = p.Pop_id''
 EXEC (@SqlZip)
 FETCH NEXT FROM ZipCursor INTO @Study_id
END
CLOSE ZipCursor
DEALLOCATE ZipCursor
' 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_FG_FormGen_Pop_PreMailingWork_TP]    Script Date: 8/15/2014 2:39:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_FG_FormGen_Pop_PreMailingWork_TP]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'/*    
Modified 5/23/2 BD  Adding 6 hours to GETDATE to automatically pick up Surveys that are set to generate after midnight.      
Modified 8/15/2 BD  Added the ability to generate multiple Mailingsteps in the same night.    
Modified 7/3/3 BD  Remove duplicate Mailstep generations for the same person.  This can happen when the generation of    
 firsts are rolled back, but the second Mailstep is not deleted.      
Modified 1/20/04 SS -Adapted sp_FG_FormGen_Pop_PreMailingWork   
Mofified 8/27/04 SS - Added workcount check to see if some of the scheduled records are falling out of the join.  IF so we will insert into formgenerror_tp for the missing records.
Modified 6/22/2014 TSB Added QuestionnaireType_ID to FG_PreMailingWork insert - AllCahps Sprint 2 R3.5
Modified 8/05/2014 TSB Modified QuestionnaireType_ID value to come from SurveySubType.Subtype_ID

*/    
CREATE  PROCEDURE [dbo].[sp_FG_FormGen_Pop_PreMailingWork_TP]  
AS    
  
TRUNCATE TABLE FG_PreMailingWork_TP  
  
DECLARE @Study_id INT, @WorkCnt INT
DECLARE @sqlzip VARCHAR (250)    
DECLARE ZipCursor CURSOR FOR SELECT DISTINCT Study_id FROM FG_PreMailingWork_TP  

-- Create a temp table for all Questionnaire Type SubTypes 8/5/2014 TSB
SELECT sst.Survey_id, sst.SubType_id
INTO #SurveyQuestionnaireSubtypes
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE st.SubtypeCategory_id = 2 -- 2 is QuestionnaireType category  

-- Count what there is to work on.
SELECT s.tp_id INTO #scheduledwork FROM scheduled_tp S LEFT JOIN FormGenError_TP F ON s.tp_id = f.tp_id WHERE S.bitDone = 0 and f.tp_id IS NULL
SELECT @WorkCnt = @@ROWCOUNT

------ This is what was here prior to 8/5/2014 modifications
---- First insert the already Scheduled Surveys    
--INSERT INTO FG_PreMailingWork_TP (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg, language, employee_id, bitMockup, strEmail, QuestionnaireType_ID )    
--SELECT SM.Study_id, SM.Survey_id, SP.SamplePop_id, SM.SampleSet_id, SM.Pop_id, SM.TP_id, SM.MailingStep_id, SM.Methodology_id, SM.OverRideItem_id, SD.Priority_Flg, [language], employee_id, bitMockup, strEmail, QuestionnaireType_ID 
--FROM   Survey_def SD(NOLOCK), Scheduled_TP SM(NOLOCK), MailingMethodology MM(NOLOCK), SamplePop SP(NOLOCK)    
--WHERE   SM.bitDone = 0 AND -- SM.SentMail_id IS NULL AND  -- (MOD 1/20/04 SS)    
----     SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND   --(MOD 1/20/04 SS)  
----     SD.bitFormGenRelease = 1 AND       --(MOD 1/20/04 SS)  
--	  SP.SampleSet_id=SM.Sampleset_id 
--	  AND SP.study_id=SM.study_id AND SP.pop_id=SM.pop_id 
--	  AND -- SP.SamplePop_id = SM.SamplePop_id AND         --(MOD 1/20/04 SS)  
--       MM.Methodology_id = SM.Methodology_id AND    
--       MM.Survey_id = SD.Survey_id AND
--	  NOT EXISTS (SELECT TP_id FROM FormGenError_TP F WHERE SM.TP_ID = F.TP_ID)  --(MOD 8/27/04 SS)  

--Modified 8/5/2014 TSB - changed to use ANSI-compliant join and #SurveyQuestionnaireSubtypes
INSERT INTO FG_PreMailingWork_TP (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg, language, employee_id, bitMockup, strEmail, QuestionnaireType_ID )    
SELECT SM.Study_id, SM.Survey_id, SP.SamplePop_id, SM.SampleSet_id, SM.Pop_id, SM.TP_id, SM.MailingStep_id, SM.Methodology_id, SM.OverRideItem_id, SD.Priority_Flg, [language], employee_id, bitMockup, strEmail, SQSS.Subtype_id QuestionnaireType_ID
FROM   Scheduled_TP SM(NOLOCK)
INNER JOIN MailingMethodology MM(NOLOCK) ON MM.Methodology_id = SM.Methodology_id
INNER JOIN SamplePop SP(NOLOCK) ON SP.Study_id = SM.study_id and SP.POP_ID = sm.pop_id
INNER JOIN Survey_def SD(NOLOCK) ON MM.Survey_id = SD.Survey_id
LEFT JOIN #SurveyQuestionnaireSubtypes SQSS ON SQSS.Survey_id = sd.Survey_ID
WHERE  SM.bitDone = 0 AND
       NOT EXISTS (SELECT TP_id FROM FormGenError_TP F WHERE SM.TP_ID = F.TP_ID)  --(MOD 8/27/04 SS) 

DROP TABLE #SurveyQuestionnaireSubtypes
-- If the inserted doesn''t match the workcnt then we have to error out some of the scheduled records because they failed the join (ie. rollback of sampleset)
IF @@ROWCOUNT <> @WorkCnt
	BEGIN
	INSERT INTO FormGenError_TP (TP_id, datGenerated, FGErrorType_id)
	SELECT w.tp_id, GETDATE(), 1 FROM #scheduledwork w LEFT JOIN FG_PreMailingWork_TP pw ON w.TP_ID = pw.ScheduledMailing_id WHERE pw.ScheduledMailing_id IS NULL
	DROP TABLE #scheduledwork
	END

-- 1/20/04 SS (NOT NEEDED)  
 --Now to get rid of duplicated Mailsteps for people    
 -- SELECT SamplePop_id, MailingStep_id, MAX(ScheduledMailing_id) ScheduledMailing_id    
 -- INTO #keep    
 -- FROM fg_preMailingWork    
 -- GROUP BY SamplePop_id, MailingStep_id    
    
 -- --Get the list of scheduledmailing_ids to delete    
 -- SELECT f.ScheduledMailing_id     
 -- INTO #del    
 -- FROM #keep t RIGHT OUTER JOIN fg_preMailingWork f    
 -- ON t.SamplePop_id = f.SamplePop_id    
 -- AND t.MailingStep_id = f.MailingStep_id    
 -- AND t.ScheduledMailing_id = f.ScheduledMailing_id    
 -- WHERE t.ScheduledMailing_id IS NULL    
 --     
 -- --Get rid of the fg_premailingwork records    
 -- DELETE f    
 -- FROM #del t, fg_preMailingWork f    
 -- where t.ScheduledMailing_id = f.ScheduledMailing_id    
 --     
 -- --Now to get rid of the scheduledmailing records    
 -- DELETE schm    
 -- FROM #del t, ScheduledMailing schm    
 -- where t.ScheduledMailing_id = schm.ScheduledMailing_id    
 --     
 -- --Clean up    
 -- DROP TABLE #del    
 -- DROP TABLE #keep    
    
  
-- 1/20/04 SS (NOT NEEDED)  
 -- --Determine additional Mailingsteps that need to generate    
 -- SELECT Study_id, f.Survey_id, SampleSet_id, Pop_id, Priority_flg, ms.MailingStep_id, SamplePop_id, f.Methodology_id, GETDATE() datgenerate    
 -- into #temp    
 -- FROM fg_preMailingWork f(NOLOCK), Mailingstep ms(NOLOCK)    
 -- WHERE f.MailingStep_id = ms.mmMailingStep_id    
 -- AND f.MailingStep_id <> ms.MailingStep_id    
 --     
 -- --Delete records already Scheduled    
 -- DELETE t    
 -- FROM #temp t, ScheduledMailing schm    
 -- WHERE t.MailingStep_id = schm.MailingStep_id    
 -- AND t.SamplePop_id = schm.SamplePop_id    
 --     
 -- --Schedule the additional Mailingsteps    
 -- INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, sentMail_id, Methodology_id, datgenerate)    
 -- SELECT MailingStep_id, SamplePop_id, NULL, NULL, Methodology_id, datgenerate    
 -- FROM #temp    
 --     
 -- --Insert the newly Scheduled Mailingsteps    
 -- INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg)    
 -- SELECT Study_id, Survey_id, t.SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, t.MailingStep_id, t.Methodology_id, OverRideItem_id, Priority_Flg    
 -- FROM   #temp t, ScheduledMailing schm(NOLOCK)    
 -- WHERE  t.MailingStep_id = schm.MailingStep_id    
 -- AND t.SamplePop_id = schm.SamplePop_id    
 -- AND schm.OverRideItem_id is NULL    
 --     
 -- DROP TABLE #temp    
  
  
--remove if blowup end    
--Update the zip code fields    
  
OPEN ZipCursor    
FETCH NEXT FROM ZipCursor INTO @Study_id    
WHILE @@FETCH_STATUS = 0    
 BEGIN    
  SET @SqlZip = ''UPDATE FG_PreMailingWork_TP set zip5 =  p.zip5, zip4 = p.zip4 '' + CHAR(10) +     
  '' FROM s'' + CONVERT(VARCHAR(10),@Study_id) + ''.Population p, FG_PreMailingWork_TP pm, SamplePop sp '' + CHAR(10) +     
  '' WHERE pm.Study_id = '' + CONVERT(VARCHAR(10),@Study_id) + CHAR(10) +    
  '' AND pm.SamplePop_id=sp.SamplePop_id '' + CHAR(10) +    
  '' AND sp.Pop_id = p.Pop_id''    
  EXEC (@SqlZip)    
  FETCH NEXT FROM ZipCursor INTO @Study_id    
 END    
CLOSE ZipCursor    
DEALLOCATE ZipCursor
' 
END
GO
/****** Object:  StoredProcedure [dbo].[SV_ModeMapping]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_ModeMapping]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Template]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_Template]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SkipPatterns]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_SkipPatterns]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingMethod]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_SamplingMethod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingEncounterDate]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_SamplingEncounterDate]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingAlgorithm]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_SamplingAlgorithm]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SampleUnitTarget]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_SampleUnitTarget]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SampleUnit]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_SampleUnit]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplePeriods]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_SamplePeriods]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Resurvey]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_Resurvey]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredPopulationFields]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_RequiredPopulationFields]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredEncounterFields]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_RequiredEncounterFields]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ReportingDate]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_ReportingDate]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_MedicareNumber]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_MedicareNumber]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Householding]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_Householding]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_HH_CAHPS_DQRules]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_HH_CAHPS_DQRules]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_HasDQRule]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_HasDQRule]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_H_CAHPS_DQrules]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_H_CAHPS_DQrules]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FormQuestions]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FacilityStatePopulated]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_FacilityStatePopulated]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_EnglishOrSpanish]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_AHA_Id]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_AHA_Id]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_AddrErrorDQ]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_AddrErrorDQ]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ActiveMethodology]    Script Date: 9/17/2014 3:46:20 PM ******/
DROP PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ActiveMethodology]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1



IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

IF @subtype_id is null
	SET @subtype_id = 0

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Check the active methodology  (ALL CAHPS)
CREATE TABLE #ActiveMethodology (standardmethodologyid INT)

INSERT INTO #ActiveMethodology
SELECT standardmethodologyid
FROM MailingMethodology (NOLOCK)
WHERE Survey_id=@Survey_id
AND bitActiveMethodology=1

IF @@ROWCOUNT<>1
 INSERT INTO #M (Error, strMessage)
 SELECT 1,'Survey must have exactly one active methodology.'
ELSE
BEGIN

	 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid = 5) -- 5 is custom methodology
	  INSERT INTO #M (Error, strMessage)
	  SELECT 2,'Survey uses a custom methodology.'         -- a warning

	 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology
	   WHERE standardmethodologyid in (select StandardMethodologyID
		 from StandardMethodologyBySurveyType where SurveyType_id = @surveyType_id and SubType_ID = @subtype_id
		)
	   )
	  INSERT INTO #M (Error, strMessage)
	  SELECT 0,'Survey uses a standard ' + @SurveyTypeDescription + ' methodology.'
	 ELSE
	  INSERT INTO #M (Error, strMessage)
	  SELECT 1,'Survey does not use a standard ' + @SurveyTypeDescription + ' methodology.'   -- a warning     

END

DROP TABLE #ActiveMethodology

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_AddrErrorDQ]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_AddrErrorDQ]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF @surveyType_id in (@HCAHPS)
	BEGIN

		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = '='
					 AND cc.strLowValue = 'FO'
					 AND br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ rule (AddrErr = "FO").'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ rule (AddrErr = "FO").'
	END

IF @surveyType_id in (@HHCAHPS)
	BEGIN

		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'AddrErr'
					 AND op.strOperator = '='
					 AND cc.strLowValue = 'FO'
					 AND br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has DQ rule (AddrErr = "FO").'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey does not have DQ rule (AddrErr = "FO").'
	END

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_AHA_Id]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_AHA_Id]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Is AHA_id populated?
		IF EXISTS (SELECT *
				   FROM (SELECT SampleUnit_id, SUFacility_id
						 FROM SamplePlan sp, SampleUnit su
						 WHERE sp.Survey_id=@Survey_id
						   AND sp.SamplePlan_id=su.SamplePlan_id
						   AND CAHPSType_id  = @surveyType_id) a
						LEFT JOIN SUFacility f
							   ON a.SUFacility_id=f.SUFacility_id
				   WHERE f.AHA_id IS NULL)
		INSERT INTO #M (Error, strMessage)
		SELECT 2,'At least one ' + @SurveyTypeDescription + ' Sampleunit does not have an AHA value.'


SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_EnglishOrSpanish]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_EnglishOrSpanish]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--check to make sure only english or hcahps spanish is used on HHACAHPS survey
		INSERT INTO #M (Error, strMessage)
		SELECT 1, l.Language + ' is not a valid Language for a HHCAHPS survey'
		FROM Languages l, SEL_QSTNS sq
		WHERE l.LangID = sq.LANGUAGE and
		  sq.SURVEY_ID = @Survey_id and
		  l.LangID not in (1,19)

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FacilityStatePopulated]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_FacilityStatePopulated]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

	--Check that FacilityState is populated for the HCAHPS & HHCAHPS units.
	INSERT INTO #M (Error, strMessage)
	SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a state designated.'
	FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
	ON su.SUFacility_id=suf.SUFacility_id
	WHERE sp.Survey_id=@Survey_id
	AND sp.SamplePlan_id=su.SamplePlan_id
	AND su.CAHPSType_id = @surveyType_id
	AND suf.State IS NULL

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_FormQuestions]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_FormQuestions]
    @Survey_id INT
AS
/*
	8/28/2014 -- CJB Introduced into "not mapped to sampleunit" where clause criteria to prevent errors about phone section questions if
				no phone maling step is present, and about mail section questions if no 1st survey mailing step is present, 
				and about dummy section questions
	9/15/2014 -- CJB accommodated for SubType_id to be NOT NULL in temp table here.  Also adjusted clumsy logic based on SurveyType so 
				ACOCAHPS follows a path closer to PCMH 
*/

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

DECLARE @questionnaireType_id int

-- get any associated subtype_id that is has questionnaire category type
select  @questionnaireType_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 2

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure all of the CAHPS questions are on the form and in the correct location.
	CREATE TABLE #CurrentForm (
		Order_id INT IDENTITY(1,1),
		QstnCore INT,
		Section_id INT,
		Subsection INT,
		Item INT
	)

	--Get the questions currently on the form
	INSERT INTO #CurrentForm (QstnCore, Section_id, Subsection, Item)
	SELECT QstnCore, Section_id, Subsection, Item
	FROM Sel_Qstns
	WHERE Survey_id=@Survey_id
	  AND SubType in (1,4)
	  AND Language=1
	  AND (Height>0 OR Height IS NULL)
	ORDER BY Section_id, Subsection, Item

	--Check for expanded questions
	--If they exist on survey, then pull question list that includes expanded questions (bitExpanded = 1)
	declare @bitExpanded int

	CREATE TABLE #CAHPS_SurveyTypeQuestionMappings(
	[SurveyType_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intOrder] [int] NULL,
	[bitFirstOnForm] [bit] NULL,
	[SubType_id] [INT] NOT NULL)

	IF @surveyType_id in (@HCAHPS)
	BEGIN

		select @bitExpanded = isnull((select top 1 1 from #currentform where qstncore in (46863,46864,46865,46866,46867)),0) 

	--If active sample period is after 1/1/2013, then the survey should be using expanded questions (bitExpanded = 1)
	--**************************************************
	--** Code from QCL_SelectActivePeriodbySurveyId
	--**************************************************
		create table #periods (perioddef_id int, activeperiod bit)

		--Get a list of all periods for this survey
		INSERT INTO #periods (periodDef_id)
		SELECT periodDef_id
		FROM perioddef
		WHERE survey_id=@survey_id

		--Get a list of all periods that have not completed sampling
		SELECT distinct pd.PeriodDef_id
		INTO #temp
		FROM perioddef p, perioddates pd
		WHERE p.perioddef_id=pd.perioddef_id AND
				survey_id=@survey_id AND
	  			datsampleCREATE_dt is null

		--Find the active Period.  It is either a period that hasn't completed sampling
		--or a period that hasn't started but has the most recent first scheduled date
		--If no unfinished periods exist, set active period to the period with the most
		--recently completed sample

		IF EXISTS (SELECT top 1 *
					FROM #temp)
		BEGIN

			DECLARE @UnfinishedPeriod int

			SELECT @UnfinishedPeriod=pd.perioddef_id
			FROM perioddates pd, #temp t
			WHERE pd.perioddef_id=t.perioddef_id AND
		  			pd.samplenumber=1 AND
					pd.datsampleCREATE_dt is not null

			IF @UnfinishedPeriod is not null
			BEGIN
				--There is a period that is partially finished, so set it to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id = @UnfinishedPeriod
			END
			ELSE
			BEGIN
				--There is no period that is partially finished, so set the unstarted period
				--with the earliest scheduled sample date to be active
				UPDATE #periods
				SET ActivePeriod=1
				WHERE perioddef_id =
					(SELECT top 1 pd.perioddef_id
					 FROM perioddates pd, #temp t
					 WHERE pd.perioddef_id=t.perioddef_id AND
				  			pd.samplenumber=1
					 ORDER BY datscheduledsample_dt)
			END
		END
		ELSE
		BEGIN
			--No unfinished periods exist, so we will set the active to be the most recently
			--finished
			UPDATE #periods
			SET ActivePeriod=1
			WHERE perioddef_id =
				(SELECT top 1 p.perioddef_id
				 FROM perioddates pd, perioddef p
				 WHERE p.survey_id=@survey_id AND
						pd.perioddef_id=p.perioddef_id
				 GROUP BY p.perioddef_id
				 ORDER BY Max(datsampleCREATE_dt) desc)
		END

		IF @surveyType_id in (@HCAHPS)
		BEGIN
			if (select datExpectedEncStart from perioddef where perioddef_id = (select top 1 perioddef_id from #periods where activeperiod = 1 order by 1 desc)) >= '1/1/2013'
				select @bitExpanded = 1 ---(HCAHPS specific)
		END

		drop table #periods
		drop table #temp

		--Create subset SurveyTypeQuestionMappings looking at only surveyType
		INSERT INTO #CAHPS_SurveyTypeQuestionMappings
		Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
		from SurveyTypeQuestionMappings
		where SurveyType_id = @surveyType_id 
		and bitExpanded = @bitExpanded

	END
	ELSE
	BEGIN

		IF @questionnaireType_id is null
		BEGIN

			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id

		END
		ELSE
		BEGIN
			INSERT INTO #CAHPS_SurveyTypeQuestionMappings
			Select surveytype_id, qstncore, intorder, bitfirstonform, SubType_ID
			from SurveyTypeQuestionMappings
			where SurveyType_id = @surveyType_id
			and SubType_ID = @questionnaireType_id

		END

	END

	--Look for questions missing from the form.
/*	IF @surveyType_id IN (@ACOCAHPS)
	BEGIN

		DECLARE @cnt50715 INT
		DECLARE @cnt50255 INT

		SELECT
		 @cnt50715 = SUM( CASE s.QstnCore WHEN 50715 THEN 1 ELSE 0 END),
		 @cnt50255 = SUM( CASE s.QstnCore WHEN 50255 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL and s.QstnCore NOT IN (50715,50255)

	END
*/
	IF @surveyType_id IN (@HCAHPS)
	BEGIN

		DECLARE @cnt43350 INT
		DECLARE @cnt50860 INT
		SELECT
		 @cnt43350 = SUM( CASE s.QstnCore WHEN 43350 THEN 1 ELSE 0 END),
		 @cnt50860 = SUM( CASE s.QstnCore WHEN 50860 THEN 1 ELSE 0 END)
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		   AND t.QstnCore IS NOT NULL

		IF @cnt43350 = 0 AND @cnt50860 = 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both missing.  You must have either 43350 or 50860, but not both.')
		END
		IF @cnt43350 > 0 AND @cnt50860 > 0
		BEGIN
		 INSERT INTO #M VALUES (1, 'QstnCore 43350 and 50860 are both assigned.  You must have either 43350 or 50860, but not both.')
		END

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t
		ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		AND t.QstnCore IS NULL and s.QstnCore NOT IN (43350,50860)

	END

	IF @surveyType_id = @HHCAHPS
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		  AND t.QstnCore IS NULL
	END

	--OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
	CREATE TABLE #OrderCheck(
		OverAllOrder INT IDENTITY(1,1),
		QstnCore INT,
		TemplateOrder INT,
		FormOrder INT,
		OrderDiff INT
	)

	IF (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType) OR (@SurveyType_id = @ACOCAHPS)
	BEGIN

		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		WHERE s.SurveyType_id = @surveyType_id
		and s.SubType_id = @questionnaireType_id
		AND t.QstnCore IS NULL

		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		and s.SubType_id = @questionnaireType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck 
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff
		from #CAHPS_SurveyTypeQuestionMappings qm 
		INNER JOIN #CurrentForm t ON qm.SurveyType_id = @surveyType_id
		WHERE qm.SubType_id = @questionnaireType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END
	ELSE
	BEGIN
		--Look for questions that are out of order.
		--First the questions that have to be at the beginning of the form.
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'
		FROM #CAHPS_SurveyTypeQuestionMappings s 
		LEFT JOIN #CurrentForm t ON s.QstnCore=t.QstnCore
		AND s.intOrder=t.Order_id
		AND s.SurveyType_id= @surveyType_id
		WHERE bitFirstOnForm=1
		AND t.QstnCore IS NULL

		--Now the questions that are at the end of the form.
		INSERT INTO #OrderCheck
		SELECT qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff

		from #CAHPS_SurveyTypeQuestionMappings qm, #CurrentForm t
		WHERE qm.SurveyType_id = @surveyType_id
		AND bitFirstOnForm=0
		AND qm.QstnCore=t.QstnCore
	END


	DECLARE @OrderDifference INT

	SELECT @OrderDifference=OrderDiff
	FROM #OrderCheck
	WHERE OverAllOrder=1

	INSERT INTO #M (Error, strMessage)
	SELECT 1,'QstnCore '+LTRIM(STR(QstnCore))+' is out of order on the form.'
	FROM #OrderCheck
	WHERE OrderDiff<>@OrderDifference

	DROP TABLE #OrderCheck
	
	DROP TABLE #CurrentForm

	IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0
	BEGIN
	 INSERT INTO #M (Error, strMessage)
	 SELECT 0,'All ' + @SurveyTypeDescription + ' Questions are on the form in the correct order.'

	 --IF all cores or on the survey, then check that the questions are mapped
	 --in a manner that ensures someone sampled at the units will get all of them
	 SELECT sampleunit_id
	 into #CAHPSUnits
	 FROM SampleUnit su, SamplePlan sp
	 WHERE sp.Survey_id=@Survey_id
	 AND sp.SamplePlan_id=su.SamplePlan_id
	 AND CAHPSType_id = @surveyType_id

	 DECLARE @sampleunit_id int

	 SELECT TOP 1 @sampleunit_id=sampleunit_id
	 FROM #CAHPSUnits

	 WHILE @@rowcount>0
	 BEGIN

		INSERT INTO #M (Error, strMessage)
		 SELECT 1,'QstnCore '+LTRIM(STR(a.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'
		 from
		 (
		  SELECT stqm.QstnCore, intOrder
		  FROM
		  (
		   SELECT sq.Qstncore
		   FROM SAMPLEUNITTREEINDEX si JOIN sampleunitsection su
			ON si.sampleunit_id=@sampleunit_id
			 AND si.ancestorunit_id=su.sampleunit_id
			JOIN sel_qstns sq
			ON sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		   union
		   SELECT sq.Qstncore
		   FROM sampleunitsection su JOIN sel_qstns sq
			ON su.sampleunit_id=@sampleunit_id
			 AND sq.Survey_id=@Survey_id
			 AND SubType in (1,4)
			 AND Language=1
			 AND (Height>0 OR Height IS NULL)
			 AND su.selqstnssection=sq.section_id
			 AND sq.survey_id=su.selqstnssurvey_id
		  ) as Q  RIGHT JOIN #CAHPS_SurveyTypeQuestionMappings stqm
		  ON Q.QstnCore=stqm.QstnCore
		  WHERE stqm.SurveyType_id=@surveyType_id AND Q.QstnCore IS NULL
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%phone%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Phone'))
		  AND (not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%mail%') 
			OR exists (select 1 from mailingstepmethod msm inner join mailingstep ms on ms.MailingStepMethod_id = msm.MailingStepMethod_id 
					where survey_id = @survey_id and msm.mailingstepmethod_nm = 'Mail'))
		  AND not exists (select 1 from sel_qstns s1 inner join sel_qstns s2 on s1.section_id = s2.section_id and s1.survey_id = s2.survey_id and s2.subtype = 3 
			where s1.qstncore = stqm.qstncore and s1.survey_id = @survey_id and s2.label like '%dummy%') 
		 ) AS a
		 LEFT JOIN AlternateQuestionMappings AS b ON a.QstnCore=b.QstnCore where b.QstnCore is null

		  IF @@ROWCOUNT=0
		   INSERT INTO #M (Error, strMessage)
		   SELECT 0,'All Questions are mapped properly for Sampleunit ' + convert(varchar,@sampleunit_id)

		  DELETE
		  FROM #CAHPSUnits
		  WHERE sampleunit_Id=@sampleunit_id

		  SELECT TOP 1 @sampleunit_id=sampleunit_id
		  FROM #CAHPSUnits

	 END

	 DROP TABLE #CAHPSUnits
	 

	END
	--End of Question checking

	DROP TABLE #CAHPS_SurveyTypeQuestionMappings

ENDOFPROC:

SELECT * FROM #M

DROP TABLE #M



GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_H_CAHPS_DQrules]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_H_CAHPS_DQrules]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--check for DQ_Law rule
		IF EXISTS (	select *
					from (SELECT BusinessRule_id, cc.CriteriaPhrase_id
						   FROM BusinessRule br
						   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
						   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
						   inner join MetaField mf on cc.Field_id = mf.Field_id
						   inner join Operator op on cc.intOperator = op.Operator_Num
						   WHERE mf.strField_Nm = 'HAdmissionSource'
							 AND op.strOperator = '='
							 AND cc.strLowValue = '8'
							 AND br.Survey_id = @Survey_id
							) admit
					inner join (SELECT BusinessRule_id, cc.criteriaphrase_id
							   FROM BusinessRule br
							   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
							   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
							   inner join MetaField mf on cc.Field_id = mf.Field_id
							   inner join Operator op on cc.intOperator = op.Operator_Num
							   inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
							   WHERE mf.strField_Nm = 'HDischargeStatus'
								 AND op.strOperator = 'IN'
								 AND br.Survey_id = @Survey_id
							   group by BusinessRule_id, cc.criteriaclause_id, cc.criteriaphrase_id
							   having count(*)=2 and min(strListValue) = '21' and max(strListValue)= '87'
							   ) dischg
					 on admit.BusinessRule_id=dischg.BusinessRule_id 
						and admit.CriteriaPhrase_id <> dischg.CriteriaPhrase_id --> different CriteriaPhrase_id's means they have an OR relationship.
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Law rule (ENCOUNTERHAdmissionSource = 8 OR ENCOUNTERHDischargeStatus in ("21", "87")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Law rule (ENCOUNTERHAdmissionSource = 8 OR ENCOUNTERHDischargeStatus in ("21", "87")).'


		--check for DQ_SNF rule
		IF EXISTS
		(
		 SELECT br.BUSINESSRULE_ID--, cs.strCriteriaStmt_nm, count(*), min(strListValue),max(strListValue),round(stdev(convert(int,strlistvalue)),6)
		  FROM BusinessRule br
		  inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
		  inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
		  inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
		  inner join MetaField mf on cc.Field_id = mf.Field_id
		  inner join Operator op on cc.intOperator = op.Operator_Num
		  WHERE mf.strField_Nm = 'HDischargeStatus'
		   AND op.strOperator = 'IN'
		   AND br.Survey_id = @Survey_id
		  GROUP BY br.BUSINESSRULE_ID
		  having count(*)=6 and min(strListValue) = '03' and max(strListValue)= '92' and round(stdev(convert(int,strlistvalue)),6)=38.940981
		  -- the STDEV of (3, 3, 61, 64, 83, 92) is 38.940981. Another combination of 6 integers with 3 as the min and 92 as the max would come up with a different STDEV
		)
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'


		--check for DQ_Hospc rule
		if exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.CriteriaClause_id = ci.CriteriaClause_id
					 AND cc.Field_id = mf.Field_id
			  AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND ci.strListValue = '50'
					 AND br.Survey_id = @Survey_id
		   )
		AND exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, CriteriaInList ci, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.CriteriaClause_id = ci.CriteriaClause_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND ci.strListValue = '51'
					 AND br.Survey_id = @Survey_id
		   )

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Hospc rule (ENCOUNTERHDischargeStatus in ("50", "51")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Hospc rule (ENCOUNTERHDischargeStatus in ("50", "51")).'


		--check for DQ_Dead rule
		if exists
			(SELECT BusinessRule_id
				   FROM BusinessRule br
				   inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
				   inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
				   inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
				   inner join MetaField mf on cc.Field_id = mf.Field_id
				   inner join Operator op on cc.intOperator = op.Operator_Num
				   WHERE mf.strField_Nm = 'HDischargeStatus'
					 AND op.strOperator = 'IN'
					 AND br.Survey_id = @Survey_id
				   group by BusinessRule_id, cc.criteriaclause_id
				   having count(*)=4 and min(strListValue) = '20' and max(strListValue)= '42' and round(stdev(convert(int,strlistvalue)),6)=10.531698
				   -- the STDEV of (20, 40, 41, 42) is 10.531698. Another combination of 4 integers that has 20 as the min and 40 as the max would come up with a different STDEV
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Dead rule (ENCOUNTERHDischargeStatus in ("20", "40", "41", "42")).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Dead rule (ENCOUNTERHDischargeStatus in ("20", "40", "41", "42")).'



SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_HasDQRule]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_HasDQRule]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

	IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br
					 WHERE br.Survey_id = @Survey_id
		   )
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey has a DQ or other Business Rule and should not.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey does not have DQ rule.'

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_HH_CAHPS_DQRules]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_CAHPS_HH_CAHPS_DQRules]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--get Encounter MetaTable_ID this is so we can check for field existance before we check for
		--DQ rules.  If the field is not in the data structure we do not want to check for the error.
		SELECT @EncTable_ID = mt.Table_id
		FROM dbo.MetaTable mt
		WHERE mt.strTable_nm = 'ENCOUNTER'
		  AND mt.Study_id = @Study_id


		--check for DQ_Payer Rule
		If exists  (select BusinessRule_id
		 from BUSINESSRULE br, CRITERIASTMT cs
		 where br.CRITERIASTMT_ID = cs.CRITERIASTMT_ID
		 and cs.STRCRITERIASTMT_NM = 'DQ_Payer'
		 and br.SURVEY_ID = @Survey_id)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Payer rule (HHPay_Mcare <> ''1'' AND HHPay_Mcaid <> ''1'').'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ_Payer rule (HHPay_Mcare <> ''1'' AND HHPay_Mcaid <> ''1'').'


		 --Check for DQ_visMo rules
		IF EXISTS (SELECT BusinessRule_id
			 FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			 WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			AND cc.Field_id = mf.Field_id
			AND cc.intOperator = op.Operator_Num
			AND mf.strField_Nm = 'HHVisitCnt'
			AND op.strOperator = '<'
			AND cc.strLowValue = '1'
			AND br.Survey_id = @Survey_id
		   )

		 INSERT INTO #M (Error, strMessage)
		 SELECT 0,'Survey has DQ_VisMo rule (HHVisitCnt < 1).'
		ELSE
		 INSERT INTO #M (Error, strMessage)
		 SELECT 1,'Survey does not have DQ_VisMo rule (HHVisitCnt < 1).'

		 --Check for DQ_Hospc rules
		 IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHHospice')
		BEGIN
		 IF EXISTS (SELECT BusinessRule_id
			  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			 AND cc.Field_id = mf.Field_id
			 AND cc.intOperator = op.Operator_Num
			 AND mf.strField_Nm = 'HHHospice'
			 AND op.strOperator = '='
			 AND cc.strLowValue = 'Y'
			 AND br.Survey_id = @Survey_id
			)

		  INSERT INTO #M (Error, strMessage)
		  SELECT 0,'Survey has DQ_Hospc rule (ENCOUNTERHHHospice = "Y").'
		 ELSE
		  INSERT INTO #M (Error, strMessage)
		  SELECT 1,'Survey does not have DQ_Hospc rule (ENCOUNTERHHHospice = "Y").'

		END

		 --Check for DQ_VisLk rules
		if exists ( SELECT BusinessRule_id
					FROM BusinessRule br
					inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
					inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
					inner join MetaField mf on cc.Field_id = mf.Field_id
					inner join Operator op on cc.intOperator = op.Operator_Num
					inner join CRITERIAINLIST ci on cc.criteriaclause_id=ci.criteriaclause_id
					WHERE mf.strField_Nm = 'HHLookBackCnt'
					AND op.strOperator = 'IN'
					AND br.Survey_id = @Survey_id
					group by BusinessRule_id
					having count(*)=2 and min(strListValue) = '0' and max(strListValue)= '1'
					)
		INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_VisLk rule (ENCOUNTERHHLookbackCnt IN (0,1) ).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_VisLk rule (ENCOUNTERHHLookbackCnt IN (0,1) ).'

		--Check for DQ_Age rules
		IF EXISTS (SELECT BusinessRule_id
				   FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				   WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
					 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
					 AND cc.Field_id = mf.Field_id
					 AND cc.intOperator = op.Operator_Num
					 AND mf.strField_Nm = 'HHEOMAge'
					 AND op.strOperator = '<'
					 AND cc.strLowValue = '18'
		   AND br.Survey_id = @Survey_id
		   )

			INSERT INTO #M (Error, strMessage)
		SELECT 0,'Survey has DQ_Age rule (ENCOUNTERHHEOMAge < 18).'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Age rule (ENCOUNTERHHEOMAge < 18).'


		--Check for DQ_Mat rules
		 IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHMaternity')
		BEGIN
			IF EXISTS (SELECT BusinessRule_id
				FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
				AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
				AND cc.Field_id = mf.Field_id
				AND cc.intOperator = op.Operator_Num
				AND mf.strField_Nm = 'HHMaternity'
				AND op.strOperator = '='
				AND cc.strLowValue = 'Y'
				AND br.Survey_id = @Survey_id
			)

			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_Mat rule (ENCOUNTERHHMaternity = "Y").'
			ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_Mat rule (ENCOUNTERHHMaternity = "Y").'
		END

		IF EXISTS (SELECT Field_id
           FROM dbo.MetaData_View
           WHERE Table_id = @EncTable_ID
			AND Study_id = @Study_id
			AND strField_nm = 'HHNoPub')
		BEGIN
		   --Check for DQ_NoPub rules
			 IF EXISTS (SELECT BusinessRule_id
				  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
				  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
				 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
				 AND cc.Field_id = mf.Field_id
				 AND cc.intOperator = op.Operator_Num
				 AND mf.strField_Nm = 'HHNoPub'
				 AND op.strOperator = '='
				 AND cc.strLowValue = 'Y'
				 AND br.Survey_id = @Survey_id
				)

			  INSERT INTO #M (Error, strMessage)
			  SELECT 0,'Survey has DQ_NoPub rule (ENCOUNTERHHNoPub = "Y").'
			 ELSE
			  INSERT INTO #M (Error, strMessage)
			  SELECT 1,'Survey does not have DQ_NoPub rule (ENCOUNTERHHNoPub = "Y").'

		END
		-- Check for DQ_Dead
		IF EXISTS (SELECT Field_id
			   FROM dbo.MetaData_View
			   WHERE Table_id = @EncTable_ID
		   AND Study_id = @Study_id
		   AND strField_nm = 'HHDeceased')
		BEGIN
		 IF EXISTS (SELECT BusinessRule_id
			  FROM BusinessRule br, CriteriaStmt cs, CriteriaClause cc, MetaField mf, Operator op
			  WHERE br.CriteriaStmt_id = cs.CriteriaStmt_id
			 AND cs.CriteriaStmt_id = cc.CriteriaStmt_id
			 AND cc.Field_id = mf.Field_id
			 AND cc.intOperator = op.Operator_Num
			 AND mf.strField_Nm = 'HHDeceased'
			 AND op.strOperator = '='
			 AND cc.strLowValue = 'Y'
			 AND br.Survey_id = @Survey_id
			)

		  INSERT INTO #M (Error, strMessage)
		  SELECT 0,'Survey has DQ_Dead rule (ENCOUNTERHHDeceased = "Y").'
		 ELSE
		  INSERT INTO #M (Error, strMessage)
		  SELECT 1,'Survey does not have DQ_Dead rule (ENCOUNTERHHDeceased = "Y").'
		END

SELECT * FROM #M

DROP TABLE #M

GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Householding]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_Householding]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF @surveyType_id in (@HCAHPS) or (@surveyType_id in (@CGCAHPS) and @subtype_id = @PCMHSubType)
	BEGIN
		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is not defined.'
		FROM Survey_def sd LEFT JOIN HouseHoldRule hhr
		ON sd.Survey_id=hhr.Survey_id
		WHERE sd.Survey_id=@Survey_id
		AND hhr.Survey_id IS NULL

		--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns
		INSERT INTO #M (Error, strMessage)
		SELECT 1,strField_nm+' is not a householding column.'
		FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a
		  LEFT JOIN HouseHoldRule hhr
		ON a.Field_id=hhr.Field_id
		AND hhr.Survey_id=@Survey_id
		WHERE hhr.Field_id IS NULL

END

IF @surveyType_id in (@ACOCAHPS, @ICHCAHPS)
	BEGIN

		-- Check for Householding
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Householding is defined and should not be.'
		FROM HouseHoldRule hhr
		WHERE hhr.Survey_id=@Survey_id
END

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_MedicareNumber]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_MedicareNumber]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure the Medicare number is populated.
INSERT INTO #M (Error, strMessage)
SELECT 1,'Medicare number is not populated.'
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf
ON su.SUFacility_id=suf.SUFacility_id
WHERE sp.Survey_id=@Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.CAHPSType_id = @surveyType_id
AND (suf.MedicareNumber IS NULL
OR LTRIM(RTRIM(suf.MedicareNumber))='')
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Medicare number is populated'

--make sure the Medicare number is active
INSERT INTO #M (Error, strMessage)
SELECT 1,'Medicare number is not Active'
FROM SamplePlan sp, SampleUnit su,SUFacility suf, MedicareLookup ml
WHERE sp.Survey_id=@Survey_id
AND su.SUFacility_id=suf.SUFacility_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND ml.MedicareNumber = suf.MedicareNumber
AND su.CAHPSType_id = @surveyType_id
AND ml.Active = 0
IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'Medicare number is Active'


SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ReportingDate]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_ReportingDate]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF @surveyType_id in (@ACOCAHPS)
	BEGIN
		--Make sure the reporting date is ACO_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ACO_FieldDate from the Encounter table.'
			FROM Survey_def sd, MetaTable mt
		 WHERE sd.sampleEncounterTable_id=mt.Table_id
			  AND  sd.Survey_id=@Survey_id
			  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ACO_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ACO_FieldDate.'
	END

	IF @surveyType_id in (@ICHCAHPS)
	BEGIN
		--Make sure the reporting date is ICH_FieldDate                                      
		IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
		ELSE
			INSERT INTO #M (Error, strMessage)
			SELECT 1,'Sample Encounter Date Field has to be ICH_FieldDate from the Encounter table.'
				 FROM Survey_def sd, MetaTable mt
				 WHERE sd.sampleEncounterTable_id=mt.Table_id
					  AND  sd.Survey_id=@Survey_id
					  AND sd.sampleEncounterField_id <> (select FIELD_ID from METAFIELD where STRFIELD_NM = 'ICH_FieldDate')
		IF @@ROWCOUNT=0
			INSERT INTO #M (Error, strMessage)
			SELECT 0,'Sample Encounter Date Field is set to ICH_FieldDate.'
	END

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredEncounterFields]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_RequiredEncounterFields]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))


--Make sure required fields are a part of the study (Encounter Fields)
	INSERT INTO #M (Error, strMessage)
	SELECT 1,a.strField_nm+' is not an Encounter field in the data structure.'
	FROM (SELECT Field_id, strField_nm
		  FROM MetaField
		  WHERE strField_nm IN (SELECT [ColumnName] 
								FROM SurveyValidationFields
								WHERE SurveyType_Id = @surveyType_id
								AND TableName = 'ENCOUNTER'
								AND bitActive = 1)) a
		  LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd
					 WHERE sd.Survey_id=@Survey_id
					 AND sd.Study_id=m.Study_id
	   AND m.strTable_nm = 'ENCOUNTER') b
	ON a.strField_nm=b.strField_nm
	WHERE b.strField_nm IS NULL
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'All Encounter ' + @SurveyTypeDescription + ' fields are in the data structure'

SELECT * FROM #M

DROP TABLE #M

GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_RequiredPopulationFields]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_RequiredPopulationFields]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure the required fields are a part of the study (Population Fields)
INSERT INTO #M (Error, strMessage)
SELECT 1,a.strField_nm+' is not a Population field in the data structure.'
FROM (SELECT Field_id, strField_nm
		FROM MetaField
		WHERE strField_nm IN (SELECT [ColumnName] 
							FROM SurveyValidationFields
							WHERE SurveyType_Id = @surveyType_id
							AND TableName = 'POPULATION'
							AND bitActive = 1)) a
LEFT JOIN ( SELECT strField_nm 
			FROM MetaData_View m, Survey_def sd
			WHERE sd.Survey_id=@Survey_id
			AND sd.Study_id=m.Study_id
			AND m.strTable_nm = 'POPULATION') b
ON a.strField_nm=b.strField_nm
WHERE b.strField_nm IS NULL

IF @@ROWCOUNT=0
INSERT INTO #M (Error, strMessage)
SELECT 0,'All Population ' + @SurveyTypeDescription + ' fields are in the data structure'


SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Resurvey]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_Resurvey]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

declare @ResurveyExclusionPeriod int
declare @ResurveyMethod_int int
declare @ResurveyMethodName varchar(50)

SET @ResurveyExclusionPeriod = dbo.SurveyProperty('ResurveyExclusionPeriodsNumericDefault', NUll, @Survey_id)
SET @ResurveyMethod_int = dbo.SurveyProperty('ResurveyMethodDefault', Null, @Survey_id)

SELECT @ResurveyMethodName = ReSurveyMethod.ReSurveyMethodName from ReSurveyMethod where ReSurveyMethod_id = @ResurveyMethod_int

	--Check the ReSurvey Method
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'Resurvey Method is not set to ' + @ResurveyMethodName +'.'
	FROM Survey_def
	WHERE Survey_id=@Survey_id
	AND ReSurveyMethod_id <> @ResurveyMethod_int


	IF (@surveyType_id in (@HHCAHPS, @ICHCAHPS)) or (@surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType)
	BEGIN

		--Check resurvey Exclusion months
		INSERT INTO #M (Error, strMessage)
		SELECT 1,
		CASE @ResurveyMethod_int 
			WHEN 1 THEN 'Resurvey Days is not '+ CAST(@ResurveyExclusionPeriod as varchar)+ '.'
			WHEN 2 THEN 'Your resurvey exclusion Month is not set to ' + CAST(@ResurveyExclusionPeriod as varchar) + ' months.'
		END
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND INTRESURVEY_PERIOD<>@ResurveyExclusionPeriod

	END

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplePeriods]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_SamplePeriods]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--check to make sure only one sample period on HHACAHPS survey
		INSERT INTO #M (Error, strMessage)
		select  1, p1.strPeriodDef_nm + ' has more than one Sample in one period.'
		from PeriodDef p1
		where p1.Survey_id = @Survey_id and
		  p1.intExpectedSamples <> 1

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SampleUnit]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_SampleUnit]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int


SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Make sure we have at least one sampleunit 
IF (SELECT COUNT(*)
    FROM SampleUnit su, SamplePlan sp
    WHERE sp.Survey_id=@Survey_id
    AND sp.SamplePlan_id=su.SamplePlan_id
    AND su.CAHPSType_id = @surveyType_id)<1
INSERT INTO #M (Error, strMessage)
SELECT 1,'Survey must have at least one ' + @SurveyTypeDescription + ' Sampleunit.'
ELSE
INSERT INTO #M (Error, strMessage)
SELECT 0,'Survey has one ' + @SurveyTypeDescription + ' Sampleunit.'


SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SampleUnitTarget]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_SampleUnitTarget]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--Check that all ampleunits have targets assigned.
		INSERT INTO #M (Error, strMessage)
		SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a target return specified.'
		FROM SamplePlan sp, SampleUnit su
		WHERE sp.Survey_id=@Survey_id
		AND sp.SamplePlan_id=su.SamplePlan_id
		AND su.CAHPSType_id = @surveyType_id and INTTARGETRETURN = 0

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingAlgorithm]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_SamplingAlgorithm]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END

declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

--What is the sampling algorithm
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your sampling algorithm is not StaticPlus.'
		FROM Survey_def
		WHERE Survey_id=@Survey_id
		AND SamplingAlgorithmID<>3

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingEncounterDate]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_SamplingEncounterDate]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

IF @surveyType_id in (@CGCAHPS) AND @subtype_id = @PCMHSubType
BEGIN

	DECLARE @Field_id int
	SELECT @Field_id = Field_ID
	FROM METAFIELD 
	WHERE STRFIELD_NM = 'MosRecVisDate'

	IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date field must be MosRecVisDate.'
	ELSE
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date field must be MosRecVisDate.'
		FROM Survey_def sd, MetaTable mt
		WHERE sd.sampleEncounterTable_id=mt.Table_id
			AND  sd.Survey_id=@Survey_id
			AND sd.sampleEncounterField_id NOT IN (@Field_id) 
	IF @@ROWCOUNT=0
		INSERT INTO #M (Error, strMessage)
		SELECT 0,'Sample Encounter Date field is MosRecVisDate.'
END
ELSE
BEGIN

	--Make sure the Sampling Encounter date is either ServiceDate or DischargeDate
	IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date Field has to be either Service or Discharge Date from the Encounter table.'
	ELSE
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Sample Encounter Date Field has to be either Service or Discharge Date from the Encounter table.'
		FROM Survey_def sd, MetaTable mt
		WHERE sd.sampleEncounterTable_id=mt.Table_id
			AND  sd.Survey_id=@Survey_id
			AND sd.sampleEncounterField_id NOT IN (54,117)
	IF @@ROWCOUNT=0
		INSERT INTO #M (Error, strMessage)
		SELECT 0,'Sample Encounter Date Field is set to either Service or Discharge Date.'
END

SELECT * FROM #M

DROP TABLE #M




GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SamplingMethod]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_SamplingMethod]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @PCMHSubType int
SET @PCMHSubType = 9

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

declare @SamplingMethod_id int
declare @SamplingMethodName varchar(50)

SET @SamplingMethod_id = dbo.SurveyProperty('SamplingMethodDefault', Null, @Survey_id)

SELECT @SamplingMethodName = strSamplingMethod_nm
FROM SamplingMethod
WHERE SamplingMethod_id = @SamplingMethod_id

	if exists(select 1 from PeriodDef where survey_id=@survey_id and SamplingMethod_id <> @SamplingMethod_id)
		INSERT INTO #M (Error, strMessage)
		SELECT 1,'Your sampling method is not ' + @SamplingMethodName + '.'

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_SkipPatterns]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_SkipPatterns]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

	--Make sure skip patterns are enforced.
	INSERT INTO #M (Error, strMessage)
	SELECT 1,'Skip Patterns are not enforced.'
	FROM Survey_def
	WHERE Survey_id=@Survey_id
	AND bitEnforceSkip=0
	IF @@ROWCOUNT=0
	INSERT INTO #M (Error, strMessage)
	SELECT 0,'Skip Patterns are enforced'

SELECT * FROM #M

DROP TABLE #M
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_Template]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SV_CAHPS_Template]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

/*
HCAHPS IP			2
Home Health CAHPS	3
CGCAHPS				4
ICHCAHPS			8
ACOCAHPS			10
*/

-- CAHPS surveyType_id 'constants'
declare @CGCAHPS int
SET @CGCAHPS = 4

declare @HCAHPS int
SET @HCAHPS = 2

declare @HHCAHPS int
SET @HHCAHPS = 3

declare @ACOCAHPS int
SET @ACOCAHPS = 10

declare @ICHCAHPS int
SET @ICHCAHPS = 8

declare @surveyType_id int
declare @subtype_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

-- only going to get subtypes where there is a bitOverride set, otherwise we'll just use the SurveyType validation
select @subtype_id = sst.subtype_id 
from SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
where survey_id = @Survey_id
and st.SubtypeCategory_id = 1
and st.bitRuleOverride = 1

IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)


if @SubType_id is null
BEGIN
	SELECT @SurveyTypeDescription = [SurveyType_dsc]
	FROM [dbo].[SurveyType] 
	WHERE SurveyType_ID = @surveyType_id
END
ELSE
BEGIN
	SELECT @SurveyTypeDescription = SubType_nm
	FROM [dbo].[Subtype]
	WHERE SubType_id = @subtype_id
END


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

/*


Validation code goes here

*/


SELECT * FROM #M

DROP TABLE #M
GO

/****** Object:  StoredProcedure [dbo].[SV_ModeMapping]    Script Date: 9/17/2014 3:46:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SV_ModeMapping]
    @Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @surveyType_id int

SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id


DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id


declare @study_ID int, @EncTable_ID int
Select @study_ID = study_ID from SURVEY_DEF where SURVEY_ID = @Survey_id

--Need a temp table to store the messages.  We will select them at the end.
--0=Passed,1=Error,2=Warning
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(200))

----Validate Mode Mapping
DECLARE @MappedCount INT

SELECT @MappedCount = Count(*)
FROM ModeSectionMapping
WHERE Survey_Id = @Survey_Id

IF @MappedCount > 0
BEGIN

	CREATE TABLE #MailingStepMethod (Survey_Id INT, MailingStepMethod_id INT, MailingStepMethod_nm varchar(60))

	INSERT INTO #MailingStepMethod
	select distinct mm.SURVEY_ID, msm.MailingStepMethod_id, msm.MailingStepMethod_nm
	from mailingstepmethod msm
	INNER JOIN mailingstep ms ON msm.mailingstepmethod_id = ms.mailingstepmethod_id
	INNER JOIN mailingmethodology mm ON ms.methodology_id = mm.methodology_id
	where mm.bitactivemethodology = 1
	and (ms.bitsendsurvey = 1 or msm.isnonmailgeneration = 1)
	and mm.survey_id =  @Survey_Id

	CREATE TABLE #MappedModes (ModeName varchar(60))

	INSERT INTO #MappedModes
	select distinct msm.MailingStepMethod_nm
	from #mailingstepmethod msm
	LEFT JOIN ModeSectionMapping mode on (msm.MailingStepMethod_id = mode.MailingStepMethod_Id and mode.Survey_Id = @Survey_Id)
	where mode.ID is null

	DECLARE @ModeName varchar(60)

	SELECT TOP 1 @ModeName = ModeName
	FROM #MappedModes

	WHILE @@rowcount>0
	BEGIN

		INSERT INTO #M (Error, strMessage)
			SELECT 2,'Mode Type "'+ LTRIM(RTRIM(@ModeName)) +'" exists and is not mapped to a Question section. '
		 
		DELETE
		FROM #MappedModes
		WHERE ModeName=@ModeName

		SELECT TOP 1 @ModeName = ModeName
		FROM #MappedModes

	END

	DROP TABLE #MailingStepMethod
	DROP TABLE #MappedModes

	---- check for Section_Id's in ModeSectionMapping that do not match Section_Id in SEL_QSTNS
	--SELECT distinct msm.SectionLabel, msm.Section_Id 'MappedSection_Id' , sq.SECTION_ID
	--INTO #Sections
	--FROM ModeSectionMapping msm
	--INNER JOIN SEL_QSTNS sq ON (sq.SURVEY_ID = msm.Survey_Id and sq.LABEL = msm.SectionLabel AND sq.SECTION_ID <> msm.Section_Id)
	--WHERE msm.Survey_Id = @Survey_Id

	--DECLARE @SectionName varchar(60)
	--DECLARE @Section_Id int
	--DECLARE @MappedSection_Id int

	--SELECT TOP 1 @SectionName = Sectionlabel,  @MappedSection_id = MappedSection_id, @Section_Id = Section_ID
	--FROM #Sections

	--WHILE @@rowcount>0
	--BEGIN
	--	INSERT INTO #M (Error, strMessage)
	--		SELECT 2,'Mode Mapping Section "'+ LTRIM(RTRIM(@SectionName)) +'" SECTION_ID does not match SEL_QSTNS. '
		 
	--	DELETE
	--	FROM #Sections
	--	WHERE SectionLabel = @SectionName and MappedSection_Id = @MappedSection_id and Section_Id = @Section_Id

	--	SELECT TOP 1 @SectionName = Sectionlabel,  @MappedSection_id = MappedSection_id, @Section_Id = Section_ID
	--	FROM #Sections
	--END

	--DROP TABLE #Sections

END

SELECT * FROM #M

DROP TABLE #M

GO