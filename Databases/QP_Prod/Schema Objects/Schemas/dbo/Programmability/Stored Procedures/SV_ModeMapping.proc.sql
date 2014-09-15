USE [QP_Prod]
GO

/****** Object:  StoredProcedure [dbo].[SV_ModeMapping]    Script Date: 8/13/2014 1:47:42 PM ******/
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


