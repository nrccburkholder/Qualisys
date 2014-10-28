/***********************************************************************
************************************************************************
***************************  QP_PROD CHANGES  **************************
************************************************************************
***********************************************************************/
USE [QP_Prod]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------
-- QuestionForm table
------------------------------------------------------------------------
ALTER TABLE dbo.QUESTIONFORM ADD
	strScanBatch varchar(100) NULL
GO
------------------------------------------------------------------------
-- sp_SI_CDFSetUndeliverableDateNDL
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFSetUndeliverableDateNDL]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFSetUndeliverableDateNDL]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure sets the UndeliverableDate and ScanBatch 
--              for a non-del survey.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFSetUndeliverableDateNDL] 
	-- Add the parameters for the stored procedure here
	@SentMailID int, 
	@UndeliverableDate datetime, 
	@ScanBatch varchar(100)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Update the undeliverable date
UPDATE SentMailing 
SET datUndeliverable = @UndeliverableDate
WHERE SentMail_id = @SentMailID

--Update the scan batch
UPDATE QuestionForm 
SET strScanBatch = @ScanBatch
WHERE SentMail_id = @SentMailID
    
--Remove respondant from Scheduled Mailing
DELETE sm 
FROM ScheduledMailing sm, MailingStep ms 
WHERE sm.MailingStep_id = ms.MailingStep_id 
  AND SamplePop_Id IN 
      (SELECT SamplePop_Id 
       FROM ScheduledMailing 
       WHERE SentMail_Id = @SentMailID
      ) 
  AND SentMail_Id IS NULL 
  AND ms.MailingStepMethod_id <> 1

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetAddInfoNDL
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetAddInfoNDL]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetAddInfoNDL]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the additional information required 
--              to process a non-deliverable survey
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetAddInfoNDL] 
    @LithoInList varchar(7000)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @Sql varchar(8000)

--Build the select statement
SET @Sql = 'SELECT sm.strLithoCode, sm.SentMail_id, qf.QuestionForm_id, qf.datReturned ' +
           'FROM SentMailing sm LEFT JOIN QuestionForm qf ON sm.SentMail_id = qf.SentMail_id ' +
           'WHERE sm.strLithoCode IN (' + @LithoInList + ')'
--PRINT @Sql
EXEC (@Sql)

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFSetDateReturnedDLV
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFSetDateReturnedDLV]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFSetDateReturnedDLV]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure sets the date returned and scan batch for
--              the specified survey.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFSetDateReturnedDLV] 
    @QuestionFormID int, 
	@ScanBatch varchar(100)

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Update the date returned
UPDATE QuestionForm 
SET datReturned = GetDate(), 
    strScanBatch = @ScanBatch 
WHERE QuestionForm_id = @QuestionFormID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetCommentCopyType
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetCommentCopyType]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetCommentCopyType]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the comment copy type
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetCommentCopyType] 
    @QuestionFormID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT sd.strCmntCopyType 
FROM Survey_Def sd, QuestionForm qf 
WHERE qf.Survey_id = sd.Survey_Id 
  AND qf.QuestionForm_Id = @QuestionFormID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetBarCodeLines
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetBarCodeLines]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetBarCodeLines]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the barcode lines
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetBarCodeLines] 
    @SentMailID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT intPA, strBarCodeA, intPB, strBarCodeB, 
       intPC, strBarCodeC, intPD, strBarCodeD 
FROM si_Barcode_view 
WHERE SentMail_Id = @SentMailID 
ORDER BY intPA 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetRegString
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetRegString]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetRegString]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the registration points string
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetRegString] 
    @SentMailID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT intSheet_Num, strRegPoints 
FROM si_RegistrationPoints_view 
WHERE SentMail_ID = @SentMailID
ORDER BY intSheet_Num

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetTemplateLine
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetTemplateLine]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetTemplateLine]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the template line
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetTemplateLine] 
    @SentMailID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT TOP 1 qf.Survey_id, ps.strTemplateCode, sd.strSurvey_nm, 
             cl.strClient_nm, sm.LangID 
FROM SentMailing sm, QuestionForm qf, PaperConfigSheet pcs, 
     PaperSize ps, Survey_def sd, Study st, Client cl 
WHERE sm.SentMail_id = qf.SentMail_id 
  AND sm.PaperConfig_id = pcs.PaperConfig_id 
  AND pcs.PaperSize_id = ps.PaperSize_id 
  AND qf.Survey_id = sd.Survey_id 
  AND sd.Study_id = st.Study_id 
  AND st.Client_id = cl.Client_id 
  AND sm.SentMail_id = @SentMailID
ORDER BY pcs.intSheet_num DESC 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetResponseShape
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetResponseShape]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetResponseShape]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the response shape
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetResponseShape] 
    @SentMailID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT intResponseShape 
FROM SentMailing 
WHERE SentMail_id = @SentMailID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetQtyOtherStepsReturned
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetQtyOtherStepsReturned]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetQtyOtherStepsReturned]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets a count of the other steps that may
--              have been returned
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetQtyOtherStepsReturned] 
    @QuestionFormID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT Count(QF2.datReturned) AS QtyRec 
FROM QuestionForm QF, QuestionForm QF2 
WHERE QF.QuestionForm_id = @QuestionFormID
  AND QF2.QuestionForm_id <> QF.QuestionForm_id 
  AND QF2.SamplePop_id = QF.SamplePop_id 
  AND QF2.datReturned IS NOT NULL 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_INTGetCount
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_INTGetCount]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_INTGetCount]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets a count of the surveys that have 
--              been marked returned but have not been transferred.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetCount] 

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT Count(*) AS QtyRec 
FROM QuestionForm 
WHERE datReturned > '1/1/1900' 
  AND datResultsImported IS NULL 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_INTGetLithoCodes
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_INTGetLithoCodes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_INTGetLithoCodes]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets all of the surveys that have been 
--              marked returned but have not been transferred.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetLithoCodes] 

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT strLithoCode, strClient_Nm, strSurvey_Nm, datUndeliverable, 
       datReturned, UnusedReturn_id, datUnusedReturn, datResultsImported, 
       strSTRBatchNumber, intSTRLineNumber, strScanBatch, SentMail_id, 
       QuestionForm_id, Convert(varchar, Survey_id) + strTemplateCode + 
       Right('00' + Convert(varchar, LangID), 2) AS Survey_id 
FROM (SELECT sm.strLithoCode, cl.strClient_nm, sd.strSurvey_nm, 
             sm.datUndeliverable, qf.datReturned, qf.UnusedReturn_id, 
             qf.datUnusedReturn, qf.datResultsImported, qf.strSTRBatchNumber, 
             qf.intSTRLineNumber, qf.strScanBatch, sm.SentMail_id, 
             qf.QuestionForm_id, qf.Survey_id, sm.PaperConfig_id, sm.LangID, 
             Max(pcs.intSheet_Num) AS intSheet_Num 
      FROM SentMailing sm (NOLOCK), Survey_def sd (NOLOCK), Study st (NOLOCK), 
           Client cl (NOLOCK), QuestionForm qf (NOLOCK), 
           PaperConfigSheet pcs (NOLOCK) 
      WHERE sm.SentMail_id = qf.SentMail_id 
        AND qf.Survey_id = sd.Survey_id 
        AND sd.Study_id = st.Study_id 
        AND st.Client_id = cl.Client_id 
        AND qf.datReturned > '1/1/1900' 
        AND qf.datResultsImported IS NULL 
        AND sm.PaperConfig_id = pcs.PaperConfig_id 
      GROUP BY sm.strLithoCode, cl.strClient_nm, sd.strSurvey_nm, 
               sm.datUndeliverable, qf.datReturned, qf.UnusedReturn_id, 
               qf.datUnusedReturn, qf.datResultsImported, qf.strSTRBatchNumber, 
               qf.intSTRLineNumber, qf.strScanBatch, sm.SentMail_id, 
               qf.QuestionForm_id, qf.Survey_id, sm.PaperConfig_id, sm.LangID 
     ) qry, PaperConfigSheet pcs (NOLOCK), PaperSize ps (NOLOCK) 
WHERE qry.PaperConfig_id = pcs.PaperConfig_id 
  AND qry.intSheet_num = pcs.intSheet_Num 
  AND pcs.PaperSize_id = ps.PaperSize_id 
ORDER BY strLithoCode 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_INTGetSpecificLithoCodes
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_INTGetSpecificLithoCodes]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_INTGetSpecificLithoCodes]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the specified surveys.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetSpecificLithoCodes] 
    @LithoInList varchar(6240)
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @Sql varchar(8000)

--Build the select statement
SET @Sql = 'SELECT strLithoCode, strClient_Nm, strSurvey_Nm, datUndeliverable, ' +
           '       datReturned, UnusedReturn_id, datUnusedReturn, datResultsImported, ' +
           '       strSTRBatchNumber, intSTRLineNumber, strScanBatch, SentMail_id, ' +
           '       QuestionForm_id, Convert(varchar, Survey_id) + strTemplateCode + ' +
           '       Right(''00'' + Convert(varchar, LangID), 2) AS Survey_id ' +
           'FROM (SELECT sm.strLithoCode, cl.strClient_nm, sd.strSurvey_nm, ' +
           '             sm.datUndeliverable, qf.datReturned, qf.UnusedReturn_id, ' +
           '             qf.datUnusedReturn, qf.datResultsImported, qf.strSTRBatchNumber, ' +
           '             qf.intSTRLineNumber, qf.strScanBatch, sm.SentMail_id, ' +
           '             qf.QuestionForm_id, qf.Survey_id, sm.PaperConfig_id, sm.LangID, ' +
           '             Max(pcs.intSheet_Num) AS intSheet_Num ' +
           '      FROM SentMailing sm (NOLOCK), Survey_def sd (NOLOCK), Study st (NOLOCK), ' +
           '           Client cl (NOLOCK), QuestionForm qf (NOLOCK), ' +
           '           PaperConfigSheet pcs (NOLOCK) ' +
           '      WHERE sm.SentMail_id = qf.SentMail_id ' +
           '        AND qf.Survey_id = sd.Survey_id ' +
           '        AND sd.Study_id = st.Study_id ' +
           '        AND st.Client_id = cl.Client_id ' +
           '        AND SM.strLithoCode IN (' + @LithoInList + ') ' +
           '        AND sm.PaperConfig_id = pcs.PaperConfig_id ' +
           '      GROUP BY sm.strLithoCode, cl.strClient_nm, sd.strSurvey_nm, ' +
           '               sm.datUndeliverable, qf.datReturned, qf.UnusedReturn_id, ' +
           '               qf.datUnusedReturn, qf.datResultsImported, qf.strSTRBatchNumber, ' +
           '               qf.intSTRLineNumber, qf.strScanBatch, sm.SentMail_id, ' +
           '               qf.QuestionForm_id, qf.Survey_id, sm.PaperConfig_id, sm.LangID ' +
           '     ) qry, PaperConfigSheet pcs (NOLOCK), PaperSize ps (NOLOCK) ' +
           'WHERE qry.PaperConfig_id = pcs.PaperConfig_id ' +
           '  AND qry.intSheet_num = pcs.intSheet_Num ' +
           '  AND pcs.PaperSize_id = ps.PaperSize_id ' +
           'ORDER BY strLithoCode '
--PRINT @Sql
EXEC (@Sql)

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_INTGetSurveys
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_INTGetSurveys]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_INTGetSurveys]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets all of the surveys that have been 
--              marked returned but have not been transferred by survey ID.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetSurveys] 

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT strClient_Nm, strSurvey_Nm, Convert(varchar, Survey_id) + strTemplateCode + 
       Right('00' + Convert(varchar, LangID), 2) AS Survey_id, Count(*) AS QtySurveys 
FROM (SELECT SM.strLithoCode, CL.strClient_nm, SD.strSurvey_nm, QF.Survey_id, 
             SM.PaperConfig_id, SM.LangID, Max(PCS.intSheet_Num) AS intSheet_Num 
      FROM SentMailing SM (NOLOCK), Survey_def SD (NOLOCK), Study ST (NOLOCK), 
           Client CL (NOLOCK), QuestionForm QF (NOLOCK), PaperConfigSheet PCS (NOLOCK) 
      WHERE SM.SentMail_id = QF.SentMail_id 
        AND QF.Survey_id = SD.Survey_id 
        AND SD.Study_id = ST.Study_id 
        AND ST.Client_id = CL.Client_id 
        AND QF.datReturned > '1/1/1900' 
        AND QF.datResultsImported IS NULL 
        AND SM.PaperConfig_id = PCS.PaperConfig_id 
      GROUP BY SM.strLithoCode, CL.strClient_nm, SD.strSurvey_nm, QF.Survey_id, 
               SM.PaperConfig_id, SM.LangID 
     ) QRY, PaperConfigSheet PCS (NOLOCK), PaperSize PS (NOLOCK) 
WHERE QRY.PaperConfig_id = PCS.PaperConfig_id 
  AND QRY.intSheet_num = PCS.intSheet_Num 
  AND PCS.PaperSize_id = PS.PaperSize_id 
GROUP BY strClient_Nm, strSurvey_Nm, Convert(varchar, Survey_id) + strTemplateCode + 
         Right('00' + Convert(varchar, LangID), 2) 
ORDER BY QtySurveys DESC 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_INTGetSurveyDates
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_INTGetSurveyDates]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_INTGetSurveyDates]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets all of the surveys that have been 
--              marked returned but have not been transferred by survey
--              ID and Date Returned.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_INTGetSurveyDates] 

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT strClient_Nm, strSurvey_Nm, Convert(varchar, Survey_id) + strTemplateCode + 
       Right('00' + Convert(varchar, LangID), 2) AS Survey_id, DateReturned, 
       Count(*) AS QtySurveys 
FROM (SELECT SM.strLithoCode, CL.strClient_nm, SD.strSurvey_nm, QF.Survey_id, SM.PaperConfig_id, 
             SM.LangID, Convert(char(10), QF.datReturned, 101) as DateReturned, 
             Max(PCS.intSheet_Num) AS intSheet_Num 
      FROM SentMailing SM (NOLOCK), Survey_def SD (NOLOCK), Study ST (NOLOCK), 
           Client CL (NOLOCK), QuestionForm QF (NOLOCK), PaperConfigSheet PCS (NOLOCK) 
      WHERE SM.SentMail_id = QF.SentMail_id 
        AND QF.Survey_id = SD.Survey_id 
        AND SD.Study_id = ST.Study_id 
        AND ST.Client_id = CL.Client_id 
        AND QF.datReturned > '1/1/1900' 
        AND QF.datResultsImported IS NULL 
        AND SM.PaperConfig_id = PCS.PaperConfig_id 
      GROUP BY SM.strLithoCode, CL.strClient_nm, SD.strSurvey_nm, QF.Survey_id, 
               SM.PaperConfig_id, SM.LangID , Convert(Char(10), QF.datReturned, 101) 
     ) QRY, PaperConfigSheet PCS (NOLOCK), PaperSize PS (NOLOCK) 
WHERE QRY.PaperConfig_id = PCS.PaperConfig_id 
  AND QRY.intSheet_num = PCS.intSheet_Num 
  AND PCS.PaperSize_id = PS.PaperSize_id 
GROUP BY strClient_Nm, strSurvey_Nm, Convert(varchar, Survey_id) + strTemplateCode + 
         Right('00' + Convert(varchar, LangID), 2), DateReturned 
ORDER BY Survey_id, DateReturned 

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_INTGetSurveyDates
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[QCL_ResetLitho]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[QCL_ResetLitho]
GO
-- =====================================================================
-- Author:		Steve Spicka
-- Create date: 09/19/2006
-- Description:	This procedure resets all scanning related data for the
--              specified litho codes from the QualiSys database and
--              also from the datamart if it has been moved there
--              already.  When finished the database looks like the 
--              surveys were never returned.
-- =====================================================================
CREATE PROCEDURE [dbo].[QCL_ResetLitho] 
	@strNTLogin_nm VARCHAR(50), 
	@strWorkstation VARCHAR(50), 
	@Litho VARCHAR(1100), 
	@bitNonDel BIT = 0
AS

-- Testing variables
-- DECLARE @strNTLogin_nm VARCHAR(50), @strWorkstation VARCHAR(50), @Litho VARCHAR(905)
-- SET @strNTLogin_nm = 'sspicka' 
-- set @strWorkstation  = 'wssspicka'
-- 	set @Litho = '10015797,10007294,10007295,10007296,10007297'

-- Declare needed variables
DECLARE @InLitho VARCHAR(1500), @SQL VARCHAR(8000), @SERVER VARCHAR(50), @NonDel_dt DATETIME, @TimeStamp DATETIME

SET @TimeStamp = GETDATE()

IF @bitNonDel = 1
	SET @NonDel_dt = @TimeStamp 

-- Get the Qualysis server      
SELECT @Server=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'    

-- Create needed temporary table
CREATE TABLE #Lithos (strlithocode VARCHAR(10), questionform_id INT, sentmail_id INT, datUndeliverable DATETIME, datReturned DATETIME, datResultsImported DATETIME, datUnusedReturn DATETIME, UnusedReturn_id INT, 
		strSTRBatchNumber VARCHAR(40), intSTRLineNumber INT, strNTLogin_nm VARCHAR(50), strWorkstation VARCHAR(50), datReset DATETIME)

-- Pad the litho list with quotes 
SELECT @InLitho = '''' + REPLACE(@litho,',',''',''') + ''''

SET @SQL = 'INSERT INTO #Lithos (strlithocode, questionform_id, sentmail_id, datUndeliverable, datReturned, datResultsImported, datUnusedReturn, UnusedReturn_id, ' + CHAR(10) 
	+ ' strSTRBatchNumber, intSTRLineNumber, strNTLogin_nm, strWorkstation, datReset) ' + CHAR(10) 
	+ ' SELECT sm.strlithocode, qf.questionform_id, qf.sentmail_id, sm.datUndeliverable, qf.datReturned, qf.datResultsImported, qf.datUnusedReturn, qf.UnusedReturn_id, qf.strSTRBatchNumber, ' + CHAR(10)
	+ ' qf.intSTRLineNumber, ''' + @strNTLogin_NM + ''' AS strNTLogin_nm, ''' + @strWorkstation + ''' AS strWorkstation, ''' + CONVERT(VARCHAR,@TimeStamp,109) + ''' AS datReset' + CHAR(10) 
	+ ' FROM QUESTIONFORM QF INNER JOIN SENTMAILING SM ON qf.sentmail_id = sm.sentmail_id ' + CHAR(10) 
	+ ' WHERE sm.strLithocode IN (' + @InLitho + ')'

--PRINT @SQL
EXEC (@SQL)

-- Log the lithos being reset
--------------------------------------------------------------------------------------------
INSERT INTO ScanningResets (strlithocode, datUndeliverable, datReturned, datResultsImported, datUnusedReturn, UnusedReturn_id, strSTRBatchNumber, intSTRLineNumber, strNTLogin_nm, strWorkstation, datReset) 
	SELECT strlithocode, datUndeliverable, datReturned, datResultsImported, datUnusedReturn, UnusedReturn_id, strSTRBatchNumber, intSTRLineNumber, strNTLogin_nm, strWorkstation, datReset 
	FROM #Lithos

-- Clear Out DataMart
--------------------------------------------------------------------------------------------
-- Find the lithos that are being reset after being extracted to the datamart
SELECT strLithocode INTO #dmlithos FROM #Lithos WHERE CONVERT(VARCHAR,datResultsImported,101) <> CONVERT(VARCHAR,datReset,101)

IF @@ROWCOUNT > 0
BEGIN

	SET @SQL = 'DECLARE @DMLitho VARCHAR(1500) ' + CHAR(10) +
		   ' SET @DMLitho = '''' ' + CHAR(10) + 
		   ' SELECT @DMLitho = @DMLItho + '','' + strLithocode FROM #DMLithos ' + CHAR(10) +
		   ' SELECT @DMLitho = SUBSTRING(@DMLitho,2,2000) ' + CHAR(10) +
		   ' EXEC ' +  @Server + '.QP_Comments.dbo.DCL_ResetLitho @DMLitho'

	--PRINT @SQL
	EXEC (@SQL)
END
DROP TABLE #dmlithos

-- Clear Out Qualysis
--------------------------------------------------------------------------------------------
	--Update the questionform table
	UPDATE qf
	SET datReturned = null, UnusedReturn_id = null, datUnusedReturn = null, 
	    datResultsImported = null, strSTRBatchNumber = null, 
	    intSTRLineNumber = null, bitComplete = null, ReceiptType_id = null
	FROM QuestionForm qf, #Lithos lt
	WHERE qf.QuestionForm_id = lt.QuestionForm_id
--------------------------------------------------------------------------------------------	
	--Update the Sentmailing datUndeliverable
	UPDATE sm 
	SET sm.datUndeliverable = @NonDel_dt 
	FROM SentMailing sm, #Lithos l 
        WHERE sm.SentMail_id = l.SentMail_id
--------------------------------------------------------------------------------------------	
	--Update the QuestionResult table
	DELETE qr
	FROM QuestionResult qr, #Lithos lt
	WHERE qr.QuestionForm_id = lt.QuestionForm_id
--------------------------------------------------------------------------------------------	
	--Update the QuestionResult2 table
	DELETE qr
	FROM QuestionResult2 qr, #Lithos lt
	WHERE qr.QuestionForm_id = lt.QuestionForm_id
--------------------------------------------------------------------------------------------	
	--Update the DispositionLog table
	DELETE d 
	FROM dispositionlog d, #Lithos lt
	WHERE d.sentmail_id = lt.sentmail_id
--------------------------------------------------------------------------------------------	
	--Update the CommentSelCodes table
	DELETE cs
	FROM CommentSelCodes cs, Comments cm, #Lithos lt
	WHERE cs.Cmnt_id = cm.Cmnt_id
	  AND cm.QuestionForm_id = lt.QuestionForm_id
--------------------------------------------------------------------------------------------	
	--Update the Comments table
	DELETE cm
	FROM Comments cm, #Lithos lt
	WHERE cm.QuestionForm_id = lt.QuestionForm_id
--------------------------------------------------------------------------------------------	
	--Drop the temp tables
	DROP TABLE #Lithos
--------------------------------------------------------------------------------------------	
GO
------------------------------------------------------------------------
-- QualPro_Params Updates
------------------------------------------------------------------------
IF EXISTS (SELECT * FROM QualPro_Params WHERE strParam_Nm = 'ImpNotTranResetQS')
	UPDATE QualPro_Params SET strParam_Value = 'KIDIETZ,JZULKOSKI,GSANTOS' WHERE strParam_Nm = 'ImpNotTranResetQS'
ELSE
	INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, Comments)
	VALUES ('ImpNotTranResetQS', 'S', 'Scanner', 'KIDIETZ,JZULKOSKI,GSANTOS', 'Comma seperated list of UserNames that can do a same day QualiSys reset')
GO
IF EXISTS (SELECT * FROM QualPro_Params WHERE strParam_Nm = 'ImpNotTranResetDM')
	UPDATE QualPro_Params SET strParam_Value = 'JFLEMING,JVONFELDT,JMURRAY,AKASARLA' WHERE strParam_Nm = 'ImpNotTranResetDM'
ELSE
	INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, Comments)
	VALUES ('ImpNotTranResetDM', 'S', 'Scanner', 'JFLEMING,JVONFELDT,JMURRAY,AKASARLA', 'Comma seperated list of UserNames that can do an any day QualiSys/DataMart reset')
GO
IF EXISTS (SELECT * FROM QualPro_Params WHERE strParam_Nm = 'ImpNotTranMaxResetQS')
	UPDATE QualPro_Params SET strParam_Value = '100' WHERE strParam_Nm = 'ImpNotTranMaxResetQS'
ELSE
	INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, Comments)
	VALUES ('ImpNotTranMaxResetQS', 'S', 'Scanner', '100', 'Quantity of LithoCodes that can be reset in QualiSys in one operation (ABSOLUTE MAX = 100)')
GO
IF EXISTS (SELECT * FROM QualPro_Params WHERE strParam_Nm = 'ImpNotTranMaxResetDM')
	UPDATE QualPro_Params SET strParam_Value = '25' WHERE strParam_Nm = 'ImpNotTranMaxResetDM'
ELSE
	INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, Comments)
	VALUES ('ImpNotTranMaxResetDM', 'S', 'Scanner', '25', 'Quantity of LithoCodes that can be reset in DataMart in one operation (ABSOLUTE MAX = 100)')
GO
IF EXISTS (SELECT * FROM QualPro_Params WHERE strParam_Nm = 'ImpNotTranVersion')
	UPDATE QualPro_Params SET strParam_Value = 'v1.08.0034' WHERE strParam_Nm = 'ImpNotTranVersion'
ELSE
	INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, Comments)
	VALUES ('ImpNotTranVersion', 'S', 'Scanner', 'v1.08.0034', 'Formatted version string (using GetAppVersion function) of the required version of this program.')
GO
IF EXISTS (SELECT * FROM QualPro_Params WHERE strParam_Nm = 'CreateDefVersion')
	UPDATE QualPro_Params SET strParam_Value = 'v2.14.0052' WHERE strParam_Nm = 'CreateDefVersion'
ELSE
	INSERT INTO QualPro_Params (strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, Comments)
	VALUES ('CreateDefVersion', 'S', 'Scanner', 'v2.14.0052', 'Formatted version string (using GetAppVersion function) of the required version of this program.')
GO



/***************************************************************************************
****************************************************************************************
***********************************  QP_SCAN CHANGES  **********************************
****************************************************************************************
***************************************************************************************/
USE [QP_Scan]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetQuestions
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetQuestions]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetQuestions]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the questions for the specified 
--              survey
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetQuestions] 
    @QuestionFormID int, 
	@QuestionType int
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
IF (@QuestionType = 0)
BEGIN
	--Return all questions
    SELECT QuestionForm_Id, intPage_Num, QstnCore, ReadMethod_Id, 
           intBegColumn, intRespCol, sampleUnit_id, NumberOfBubbles 
    FROM si_Bubble_View 
    WHERE QuestionForm_Id = @QuestionFormID 
    ORDER BY QuestionForm_Id, intPage_Num, intBegColumn
END
ELSE IF (@QuestionType = 1)
BEGIN
	--Return multiple response questions only
    SELECT QuestionForm_Id, intPage_Num, QstnCore, ReadMethod_Id, 
           intBegColumn, intRespCol, sampleUnit_id, NumberOfBubbles 
    FROM si_Bubble_View 
    WHERE QuestionForm_Id = @QuestionFormID 
	  AND ReadMethod_id = 1 
    ORDER BY QuestionForm_Id, intPage_Num, intBegColumn
END
ELSE
BEGIN
	--Return single response questions only
    SELECT QuestionForm_Id, intPage_Num, QstnCore, ReadMethod_Id, 
           intBegColumn, intRespCol, sampleUnit_id, NumberOfBubbles 
    FROM si_Bubble_View 
    WHERE QuestionForm_Id = @QuestionFormID 
	  AND ReadMethod_id <> 1 
    ORDER BY QuestionForm_Id, intPage_Num, intBegColumn
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
------------------------------------------------------------------------
-- sp_SI_CDFGetResponses
------------------------------------------------------------------------
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[sp_SI_CDFGetResponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[sp_SI_CDFGetResponses]
GO
-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the responses for the specified 
--              survey
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetResponses] 
    @QuestionFormID int, 
	@PageNo int, 
    @SampleUnitID int, 
    @QstnCore int
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT QuestionForm_Id, intPage_Num, SampleUnit_id, 
       QstnCore, x_pos, y_pos, Val, Item 
FROM si_BubbleItem_view 
WHERE QuestionForm_Id = @QuestionFormID 
  AND intPage_num = @PageNo 
  AND sampleunit_id = @SampleUnitID 
  AND qstncore = @QstnCore 
ORDER BY intBegColumn, Item

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
