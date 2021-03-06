/*

	S19 US20 Add three ICH more methodologies.

	Tim Butler

	BACKOUT


20.1	alter table [dbo].[StandardMethodologybySurveyType] drop column bitExpired
20.3	ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
20.4	ALTER PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]

*/


use [QP_Prod]
go
begin tran
go
if exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'StandardMethodologybySurveyType' 
					   AND sc.NAME = 'bitExpired' )

	alter table [dbo].[StandardMethodologybySurveyType] drop column bitExpired
go

commit tran
go


USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]    Script Date: 2/24/2015 11:22:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
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

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[QCL_SelectStandardMethodology]    Script Date: 2/24/2015 2:56:52 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodology]
 @StandardMethodologyId INT  
AS  
  
SET NOCOUNT ON  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
  
SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom  
FROM StandardMethodology sm
WHERE sm.StandardMethodologyId=@StandardMethodologyId
  
SET NOCOUNT OFF  
SET TRANSACTION ISOLATION LEVEL READ 

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ActiveMethodology]    Script Date: 2/26/2015 9:13:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
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