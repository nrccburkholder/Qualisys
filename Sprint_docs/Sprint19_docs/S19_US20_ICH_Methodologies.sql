/*

S19 US20 Add three ICH more methodologies.

Tim Butler

20.1	alter table [dbo].[StandardMethodologybySurveyType] add expired (QP_PROD)
20.2	Insert new methodologies
20.3	ALTER PROCEDURE [dbo].[QCL_SelectStandardMethodologiesBySurveyTypeId]
20.4	ALTER PROCEDURE [dbo].[SV_CAHPS_ActiveMethodology]
*/



use [QP_Prod]
go
begin tran
go
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'StandardMethodologybySurveyType' 
					   AND sc.NAME = 'bitExpired' )

	alter table [dbo].[StandardMethodologybySurveyType] add bitExpired bit NOT NULL DEFAULT(0)
go

commit tran
go


use qp_prod
go

DECLARE @SurveyType_desc varchar(100)
DECLARE @SurveyType_ID int
DECLARE @SeededMailings bit
DECLARE @SeedSurveyPercent int
DECLARE @SeedUnitField varchar(42)
DECLARE @Country_id int


SET @SurveyType_desc = 'ICHCAHPS'
SET @SeededMailings = 0
SET @SeedSurveyPercent = NULL
SET @SeedUnitField = NULL

select @SurveyType_ID = SurveyType_Id from SurveyType where SurveyType_dsc = 'ICHCAHPS'

begin tran

/*
	Methodologies
*/


declare @SMid int, @SMSid int
declare @StandardMethodology_nm varchar(50)
declare @MethodologyType varchar(30)

SET @StandardMethodology_nm = 'ICH Mixed Mail-Phone'
SET @MethodologyType = 'Mixed Mail-Phone'

if exists (select 1 
			  from StandardMethodology 
			  WHERE StandardMethodologyID = (
					select top 1 StandardMethodologyID
						  from StandardMethodology 
						  where strStandardMethodology_nm = @StandardMethodology_nm
						  and MethodologyType = @MethodologyType
						  order by StandardMethodologyID
				))
begin
	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID = (
		select top 1 StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
			  order by StandardMethodologyID
	)	
end

																													
insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																													

set @SMid=scope_identity()	
insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_id)																												

insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'1'	,'Prenote'	,'0'	,'98'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
set @SMSid=scope_identity()																													
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'2'	,'1st Survey'	,'10'	,'98'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast	,	quota_id)
values (@SMid	,'3'	,'Phone'	,'26'	,'106'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'1'	,'56'	,'10'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL	, 1	)
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1		


SET @StandardMethodology_nm = 'ICH Mail Only'
SET @MethodologyType = 'Mail Only'

if exists (select 1 
			  from StandardMethodology 
			  WHERE StandardMethodologyID = (
					select top 1 StandardMethodologyID
						  from StandardMethodology 
						  where strStandardMethodology_nm = @StandardMethodology_nm
						  and MethodologyType = @MethodologyType
						  order by StandardMethodologyID
				))
begin
	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID = (
		select top 1 StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
			  order by StandardMethodologyID
	)	
end

insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																													

set @SMid=scope_identity()	
insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_id)																												

insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'1'	,'Prenote'	,'0'	,'98'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
set @SMSid=scope_identity()																													
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'2'	,'1st Survey'	,'10'	,'98'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'3'	,'2nd Survey'	,'23'	,'98'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'0'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1	



SET @StandardMethodology_nm = 'ICH Phone Only'
SET @MethodologyType = 'Phone Only'

if exists (select 1 
			  from StandardMethodology 
			  WHERE StandardMethodologyID = (
					select top 1 StandardMethodologyID
						  from StandardMethodology 
						  where strStandardMethodology_nm = @StandardMethodology_nm
						  and MethodologyType = @MethodologyType
						  order by StandardMethodologyID
				))
begin
	Update [dbo].[StandardMethodologyBySurveyType]
		SET bitExpired = 1
	WHERE StandardMethodologyID = (
		select top 1 StandardMethodologyID
			  from StandardMethodology 
			  where strStandardMethodology_nm = @StandardMethodology_nm
			  and MethodologyType = @MethodologyType
			  order by StandardMethodologyID
	)	
end

insert into StandardMethodology (strStandardMethodology_nm,bitCustom,MethodologyType) values (@StandardMethodology_nm,0,@MethodologyType)																												

set @SMid=scope_identity()	
insert into StandardMethodologyBySurveyType (StandardMethodologyID,SurveyType_id) values (@SMid, @SurveyType_id)																												

insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast		)
values (@SMid	,'1'	,'Prenote'	,'0'	,'98'	,'-1' /*prenote*/	,'0'	,'0'	,'0'	,'1'	,'10'	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL	,NULL			,NULL	,NULL		,NULL			,NULL		)
set @SMSid=scope_identity()																													
insert into StandardMailingStep (StandardMethodologyID	,intSequence	,strMailingStep_nm	,intIntervalDays	,ExpireInDays	,ExpireFromStep	,bitSurveyInLine	,bitSendSurvey	,bitThankYouItem	,bitFirstSurvey	,MailingStepMethod_id	,DaysInField	,NumberOfAttempts	,WeekDay_Day_Call	,WeekDay_Eve_Call	,Sat_Day_Call	,Sat_Eve_Call	,Sun_Day_Call	,Sun_Eve_Call			,CallBackOtherLang	,CallbackUsingTTY		,AcceptPartial			,SendEmailBlast	, Quota_ID	)
values (@SMid	,'2'	,'Phone'	,'13'	,'106'	,'-1' /*prenote*/	,'0'	,'1'	,'0'	,'0'	,'1'	,'84'	,'10'	,'1'	,'1'	,'1'	,'1'	,'1'	,'1'			,'1'	,'0'		,NULL			,NULL   ,1	)
update StandardMailingStep set ExpireFromStep=@SMSid where ExpireFromStep=-1	
	

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
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom, smst.bitExpired
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	ORDER BY smst.bitExpired, sm.strStandardMethodology_nm
ELSE
	SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom, smst.bitExpired
	FROM StandardMethodology sm 
	INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
	WHERE smst.SurveyType_id=@SurveyTypeID
	AND smst.SubType_ID = @SubType_Id
	ORDER BY smst.bitExpired, sm.strStandardMethodology_nm

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
  
SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom, smst.bitExpired
FROM StandardMethodology sm 
INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
WHERE sm.StandardMethodologyId=@StandardMethodologyId
  
SET NOCOUNT OFF  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

GO

USE [QP_Prod]
GO
/****** Object:  StoredProcedure [dbo].[SV_CAHPS_ActiveMethodology]    Script Date: 2/25/2015 4:11:50 PM ******/
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
SELECT @CGCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'CGCAHPS'

declare @HCAHPS int
SELECT @HCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'HCAHPS IP'

declare @HHCAHPS int
SELECT @HHCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Home Health CAHPS'

declare @ACOCAHPS int
SELECT @ACOCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'ACOCAHPS'

declare @ICHCAHPS int
SELECT @ICHCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'ICHCAHPS'

declare @hospiceCAHPS int
SELECT @hospiceCAHPS = SurveyType_Id from SurveyType where SurveyType_dsc = 'Hospice CAHPS'

declare @PCMHSubType int
SELECT @PCMHSubType = 9

declare @CIHI int
select @CIHI = SurveyType_Id from SurveyType where SurveyType_dsc = 'CIHI CPES-IC'

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
CREATE TABLE #ActiveMethodology (standardmethodologyid INT, bitExpired bit)

INSERT INTO #ActiveMethodology
SELECT mm.StandardMethodologyId, smst.bitExpired
FROM MailingMethodology mm (NOLOCK)
INNER JOIN StandardMethodology sm ON (sm.StandardMethodologyID = mm.StandardMethodologyID)
INNER JOIN StandardMethodologyBySurveyType smst ON smst.StandardMethodologyID=sm.StandardMethodologyID
WHERE mm.Survey_id=@Survey_id
AND mm.bitActiveMethodology=1
and smst.SurveyType_id = @surveyType_id

IF @@ROWCOUNT<>1
 INSERT INTO #M (Error, strMessage)
 SELECT 1,'Survey must have exactly one active methodology.'
ELSE
BEGIN

	 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid = 5 and bitExpired = 0) -- 5 is custom methodology
	  INSERT INTO #M (Error, strMessage)
	  SELECT 2,'Survey uses a custom methodology.'         -- a warning

	 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology WHERE bitExpired = 1) -- 
	  INSERT INTO #M (Error, strMessage)
	  SELECT 1,'Survey uses an expired methodology.'         -- an error

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