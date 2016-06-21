/*

	S44 12 CG-CAHPS Completeness
	As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

	Task 1 - Add new subtypes for 3.0 questionnaire types; confirm all other types already in table
	Task 2 - Update SurveyTypeQuestionMappings table on QP_Prod
	Task 3 - Create new function CGCAHPSCompleteness, based on MNCMCompleteness on QP_Prod, use mappings table, add new subtypes, to check for complete/partial/incomplete using measures & ATAs
	Task 4 - Refactor Medusa ETL to use CGCAHPSCompleteness to set bitComplete & insert into DispositionLog, based on 3 possible states, not 2

	Tim Butler
*/

USE QP_PROD
GO

-- Task 1
begin

begin tran

	declare @subtype_id int

	INSERT INTO dbo.subtype VALUES ('6-month Adult 3.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Child 3.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Adult 2.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Child 2.0',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

	INSERT INTO dbo.subtype VALUES ('6-month Adult 2.0 w/ PCMH',2,0,0,1)
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id) 

	INSERT INTO dbo.subtype VALUES ('6-month Child 2.0 w/ PCMH',2,0,0,1) 
	set @subtype_id = scope_identity()
	INSERT INTO dbo.SurveyTypeSubtype VALUES (4,@subtype_id)

commit tran
end
go


-- Task 2
begin


DECLARE @Surveytype_id int
DECLARE @Subtype_id int


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'


-- Create a table for holding Old SurveyTypeQuestionMapping records
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SurveyTypeQuestionMappings_Old')
begin

CREATE TABLE [dbo].[SurveyTypeQuestionMappings_Old](
	[SurveyType_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[intOrder] [int] NULL,
	[bitFirstOnForm] [bit] NULL,
	[bitExpanded] [bit] NOT NULL DEFAULT ((0)),
	[datEncounterStart_dt] [datetime] NULL,
	[datEncounterEnd_dt] [datetime] NULL,
	[SubType_ID] [int] NOT NULL,
	[isATA] [bit] NULL,
	[isMeasure] [bit] NULL,
	[ModifiedDate] [datetime] NULL,
	[Comment] varchar(100))

end

-- Store off the current CGCAHPS SurveyType
if not exists (select 1 from dbo.SurveyTypeQuestionMappings_Old where [Comment] = 'S44 US12')
	INSERT INTO dbo.SurveyTypeQuestionMappings_Old
	SELECT *,GETDATE(),'S44 US12'
	FROM [dbo].[SurveyTypeQuestionMappings]
	WHERE  SurveyType_id = @Surveytype_id


begin tran

--1
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Adult 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50344,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50176,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50177,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50178,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50179,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50180,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50181,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50182,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50183,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50184,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50185,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50186,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50189,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50190,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50191,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50192,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50193,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50194,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50196,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50197,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50198,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50199,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50215,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50216,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50217,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50234,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50235,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50241,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50699,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50243,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50253,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50255,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50256,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50257,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


--2
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Adult 3.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50344,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50176,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50177,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50178,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50179,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50180,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50181,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50182,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50183,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50184,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50190,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50191,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50194,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50196,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50197,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50198,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50199,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50215,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50226,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,53426,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50216,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50217,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50234,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50235,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50241,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50699,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50243,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50253,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50255,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50256,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50257,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


--3
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Child 3.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50483,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50484,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50485,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50486,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50487,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50488,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50489,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50490,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50491,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50492,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50493,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50494,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50495,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50496,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50497,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50498,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50499,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50503,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50504,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50507,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50508,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50509,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50510,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50511,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50512,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50524,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50525,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50526,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50527,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50528,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50529,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50530,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50531,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,52325,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50532,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50533,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50534,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50535,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50536,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50537,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


--4
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Adult 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44121,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44122,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44123,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44124,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44125,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44126,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44129,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44130,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44139,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44140,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44141,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44142,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44148,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44150,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44152,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44155,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44157,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44158,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44161,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44162,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44168,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44169,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44181,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44201,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44202,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44203,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44204,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44226,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44227,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44228,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44229,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44230,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44234,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48664,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44235,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48665,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)



--5
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = 'Visit Adult 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39113,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39114,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39115,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39116,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39117,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39118,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39119,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39120,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39121,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39122,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39123,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39124,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39125,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39126,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39127,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39130,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39131,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39132,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39133,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39134,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39135,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39136,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39128,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39129,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39137,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39138,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39139,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39140,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39151,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46688,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39156,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39157,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39158,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39159,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39160,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,40716,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,39162,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


--6
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Adult 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50344,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50176,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50177,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50178,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50179,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50180,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50541,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50181,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50182,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50542,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50543,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50544,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50183,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50184,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50185,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50186,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50545,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50189,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50190,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50191,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50192,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50193,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50194,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50196,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50197,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50198,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50199,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50546,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50547,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50548,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50549,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50215,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50550,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50551,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50552,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50553,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50554,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50555,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50556,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50557,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50558,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50216,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50217,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50234,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50235,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50241,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50699,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50243,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50253,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50255,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50256,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50257,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


--7
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Adult 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44121,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44122,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44123,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44124,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44125,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44126,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44127,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44129,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44130,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44134,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44135,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44136,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44139,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44140,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44141,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44142,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44147,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44148,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44150,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44152,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44155,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44157,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44158,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44161,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44162,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44168,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44169,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44171,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44172,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44173,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44174,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44181,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44164,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44165,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44190,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44191,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44175,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44176,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44188,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44187,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44166,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44201,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44202,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44203,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44204,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44226,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44227,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44228,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44229,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44230,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44234,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48664,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,44235,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48665,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)



--8
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Child 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46265,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46266,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46267,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46268,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46269,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46270,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46271,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46272,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46273,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46274,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46275,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46276,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46277,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46278,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46279,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46280,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46281,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46282,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46283,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46284,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46285,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46286,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46287,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46288,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46289,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46290,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46291,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46292,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46293,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46294,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46295,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46296,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46297,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46298,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46299,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46300,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46301,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46302,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46303,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46304,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46305,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46306,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46307,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46308,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46309,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46310,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46311,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46312,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46313,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46314,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46315,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46316,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46317,53,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46318,54,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46319,55,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46320,56,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46321,57,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46322,58,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46323,59,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46324,60,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48856,61,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46326,62,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46327,63,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48666,64,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48667,65,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48668,66,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


--9
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Child 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50483,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50484,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50485,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50486,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50487,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50488,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50489,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50490,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50491,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50492,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50493,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50494,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50495,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50496,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50497,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50498,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50499,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50500,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50501,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50502,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50503,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50504,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50505,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50506,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50507,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50508,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50509,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50510,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50511,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50512,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50513,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50514,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50515,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50516,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50517,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50518,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50519,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50520,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50521,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50522,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50523,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50524,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50525,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50526,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50527,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50528,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50529,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50530,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50531,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,52325,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50532,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50533,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50534,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50535,53,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50536,54,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50537,55,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)




--10
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '6-month Child 2.0 w/ PCMH'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50483,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50484,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50485,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50486,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50487,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50488,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50489,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50490,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50491,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50492,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50493,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50494,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50495,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50629,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50496,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50497,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50630,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50631,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50632,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50498,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50499,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50500,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50501,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50633,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50502,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50503,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50504,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50505,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50506,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50507,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50508,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50509,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50510,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50511,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50512,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50634,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50635,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50513,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50514,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50515,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50516,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50517,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50518,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50519,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50520,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50521,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50522,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50523,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50636,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50637,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50638,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50639,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50524,53,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50525,54,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50526,55,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50527,56,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50528,57,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50529,58,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50530,59,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50531,60,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,52325,60,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50532,61,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50533,62,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50534,63,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50535,64,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50536,64,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,50537,65,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


--11
select @Subtype_id = Subtype_Id
from Subtype
where Subtype_nm = '12-month Child 2.0'

Delete from [dbo].[SurveyTypeQuestionMappings]
where [SurveyType_id] = @Surveytype_id
and [SubType_id] = @Subtype_id 

INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46265,1,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46266,2,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46267,3,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46268,4,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46269,5,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46270,6,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46271,7,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46272,8,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46273,9,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46274,10,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46275,11,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46276,12,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46277,13,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46279,14,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46280,15,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46284,16,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46285,17,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46286,18,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46287,19,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46289,20,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46290,21,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46291,22,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46292,23,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46293,24,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46294,25,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46295,26,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46296,27,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46297,28,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46298,29,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46299,30,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46302,31,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46303,32,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46304,33,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46305,34,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46306,35,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46307,36,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46308,37,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46309,38,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46310,39,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46311,40,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46312,41,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46317,42,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46318,43,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46319,44,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,1)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46320,45,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46321,46,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46322,47,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46323,48,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46324,49,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48856,50,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46326,51,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46327,52,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48666,53,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,48667,54,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,1,0)
INSERT INTO [dbo].[SurveyTypeQuestionMappings]([SurveyType_id],[QstnCore],[intOrder],[bitFirstOnForm],[bitExpanded],[datEncounterStart_dt],[datEncounterEnd_dt], [SubType_Id],[IsATA],[IsMeasure])VALUES(@SurveyType_ID,46330,55,1,0,'1900-01-01 00:00:00.000','2999-12-31 00:00:00.000',@Subtype_id,0,0)


commit tran

END
GO

-- Task 3

IF EXISTS (SELECT *
           FROM   dbo.sysobjects
           WHERE  [name] = 'fn_CGCAHPSCompleteness'
                  AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' )
				  )
		DROP FUNCTION [dbo].[fn_CGCAHPSCompleteness]

GO

CREATE FUNCTION [dbo].[fn_CGCAHPSCompleteness] (@QuestionForm_id INT)      
RETURNS INT      
AS      
BEGIN      

/*

Complete survey: 1
>= 50% of the ATA questions and >= 1 Measure Question.

Partial Survey: 2
< 50% of the ATA questions and >= 1 Measure Question

Incomplete Survey: 3
Any survey return where zero measure questions are answered regardless of the number of ATA questions answered.
>50% of the ATA questions and no Measure Question answered.
<50% of the ATA questions and no Measure Question answered.


*/
  

DECLARE @ATARespCnt INT = 0
DECLARE @MeasRespCnt INT = 0
DECLARE @ATACnt INT = 0

DECLARE @Complete INT 
DECLARE @Surveytype_id int
DECLARE @Subtype_id int = 0

SELECT @Complete=0


SELECT @Surveytype_id = SurveyType_id
from SurveyType
WHERE SurveyType_dsc = 'CGCAHPS'

-- Order of these is IMPORTANT
IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 39113)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = 'Visit Adult 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 44127)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Adult 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 44121)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Adult 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 46278)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Child 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 46265)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '12-month Child 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50226)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Adult 3.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50541)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Adult 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50344)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Adult 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50629)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Child 2.0 w/ PCMH'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50500)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Child 2.0'
 
END
ELSE IF exists (select 1 from QuestionResult where QuestionForm_id = @QuestionForm_id and Qstncore = 50483)
BEGIN

	select @Subtype_id = Subtype_Id
	from Subtype
	where Subtype_nm = '6-month Child 3.0'
 
END



IF @Subtype_id > 0
BEGIN

	SELECT @ATARespCnt=COUNT(distinct qr.QstnCore)      
	FROM QuestionResult qr
	INNER JOIN QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id
	INNER JOIN Sel_Qstns sq on qf.Survey_id=sq.Survey_id and qr.QstnCore=sq.QstnCore
	INNER JOIN Sel_Scls ss on sq.Scaleid=ss.Qpc_id and sq.Survey_id=ss.Survey_id and qr.intResponseVal=ss.Val
	WHERE qr.QuestionForm_id=@QuestionForm_id      
	AND qr.QstnCore IN   
		(SELECT QSTNCORE
		FROM SurveyTypeQuestionMappings
		WHERE SurveyType_id = @Surveytype_id
		and SubType_ID = @Subtype_id
		and isATA = 1)      
	AND sq.subType=1      
	AND sq.Language=1           
	AND ss.Language=1            


	SELECT @MeasRespCnt=COUNT(distinct qr.QstnCore)      
	FROM QuestionResult qr      
	INNER JOIN QuestionForm qf on qr.QuestionForm_id=qf.QuestionForm_id
	INNER JOIN Sel_Qstns sq on qf.Survey_id=sq.Survey_id and qr.QstnCore=sq.QstnCore
	INNER JOIN Sel_Scls ss on sq.Scaleid=ss.Qpc_id and sq.Survey_id=ss.Survey_id and qr.intResponseVal=ss.Val
	WHERE qr.QuestionForm_id=@QuestionForm_id      
	AND qr.QstnCore IN   
		(SELECT QSTNCORE
		FROM SurveyTypeQuestionMappings
		WHERE SurveyType_id = @Surveytype_id
		and SubType_ID = @Subtype_id
		and isMeasure = 1)            
	AND sq.subType=1      
	AND sq.Language=1           
	AND ss.Language=1 


	SELECT @ATACnt = count(distinct intOrder)
	FROM SurveyTypeQuestionMappings
	WHERE SurveyType_id = @Surveytype_id
	and SubType_ID = @Subtype_id
	and isATA = 1  

	If @ATACnt = 0 RETURN 0


	SELECT @Complete = case 
		when (cast(@ATARespCnt as float)/cast(@ATACnt as float)) * 100 >= 50 AND @MeasRespCnt >= 1 then 1 
		when (cast(@ATARespCnt as float)/cast(@ATACnt as float)) * 100 < 50 AND @MeasRespCnt >= 1 then 2
		else 3 end      

END

RETURN @Complete      
      
END

GO

-- Task 4

ALTER PROCEDURE [dbo].[sp_phase3_questionresult_for_extract] 
AS 
-- Modified 7/28/04 SJS (skip pattern recode) 
-- Modified 11/2/05 BGD Removed skip pattern enforcement. Now in the SP_Extract_BubbleData procedure 
-- Modified 11/16/05 BGD Calculate completeness for HCAHPS Surveys 
-- Modified 2/22/06 BGD Also enforce skip if question is left blank or has an invalid response. 
-- Modified 3/7/06 BGD Calculate the number of days since first and current mailing. 
-- Modified 3/16/06 BGD Add 10000 to answers that should have been skipped instead of recoding to -7 
-- Modified 5/2/06 BGD Populating the strUnitSelectType column in the Extract_Web_QuestionForm table 
-- Modified 5/22/06 BGD Bring over the langid from SentMailing to populate Big_Table_XXXX_X.LangID 
-- Modified 8/31/07 SJS Changed "INSERT INTO Extract_Web_QuestionForm" to use datReturned rather than datResultsImported data. 
-- Modified 9/19/09 MWB Added initial HHCAHPS Logic 
-- added #b (HHCAHPS completeness check) and final Disposition logic. 
-- added ReceiptType_ID to Extract_Web_QuestionForm insert 
-- Modified 11/2/09 added extra skip logic for qstncore 38694. 
-- HHCAHPS guidelines require all questions to be 
-- skipped if 38694 is not answered as 1 
-- Modified 4/5/2010 MWB Added SurveyType 4 (MNCM) Disposition logic. 
-- added #c (completeness check) and MNCM completeness check. 
-- Modified 5/27/10 MWB changed Disposition table insert from convert 110 to 120 to add time. 
-- this will avoid PK errors in the extract 
-- Modified 11/30/12 DRM Added changes to properly evaluate nested skip questions. 
-- i.e. when a gateway question is a skip question for a previous gateway question. 
-- Modified 12/28/2012 MWB added a bunch of debug writes to drm_tracktimes around skip patten  
-- logic to help identify why Survey's are taking so long    
-- Modified 01/03/2013 DRH changed @work to #work plus index
-- Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question
-- Modified 05/13/2013 DBG - added Survey_id in the link between cmnt_QuestionResult_work and skipidentifier in four places
-- Modified 05/14/2013 DBG - modifications to account for overlapping skips
-- Modified 01/14/2014 DBG - added check for ACO CAHPS usable partials and ACOCahps completeness check 
-- Modified 02/27/2014 CB - added -5 and -6 as non-response codes. Phone surveys can code -5 as "Refused" and -6 as "Don't Know"
-- Modified 06/18/2014 DBG - refactored ACOCAHPSCompleteness as a procedure instead of a function.
-- Modified 10/29/2014 DBG - added Subtype_nm to temp table because ACOCAHPSCompleteness now needs it
-- Modified 03/27/2015 TSB -- modified #HHQF to include STRMAILINGSTEP_NM
-- Modified 03/08/2015 TSB -- S44 US12 12 CG-CAHPS Completeness: As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

    SET TRANSACTION isolation level READ uncommitted 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Begin SP_Phase3_QuestionResult_For_Extract' 

    --The Cmnt_QuestionResult_work table should be able to be removed.  
    TRUNCATE TABLE cmnt_QuestionResult_work 
    TRUNCATE TABLE extract_web_QuestionForm 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H get hcahps records and index' 

    --Get the records that are HCAHPS so we can compute completeness  
    SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete 
    INTO   #a 
    FROM   QuestionForm_extract e, 
           QuestionForm qf, 
           Survey_def sd 
    WHERE  e.study_id IS NOT NULL 
           AND e.tiextracted = 0 
           AND datextracted_dt IS NULL 
           AND e.QuestionForm_id = qf.QuestionForm_id 
           AND qf.Survey_id = sd.Survey_id 
           AND Surveytype_id = 2 
    GROUP  BY e.QuestionForm_id 

    CREATE INDEX tmpindex ON #a (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H update tmp table with function call' 

    UPDATE #a 
	SET    complete = dbo.Hcahpscompleteness(QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'H update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, #a t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

    DROP TABLE #a 

    --END: Get the records that are HCAHPS so we can compute completeness  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH get hcahps records and index' 

    ----Get the records that are HHCAHPS so we can compute completeness  
    --SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1
    --INTO   #HHQF 
    --FROM   QuestionForm_extract e, 
    --       QuestionForm qf, 
    --       Survey_def sd
    --WHERE  e.study_id IS NOT NULL 
    --       AND e.tiextracted = 0 
    --       AND datextracted_dt IS NULL 
    --       AND e.QuestionForm_id = qf.QuestionForm_id 
    --       AND qf.Survey_id = sd.Survey_id 
    --       AND Surveytype_id = 3 
    --GROUP  BY e.QuestionForm_id 

	--Modified 03/27/2015 TSB
	select e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1, ms.STRMAILINGSTEP_NM
	into #HHQF
	from QuestionForm_extract e
	inner join QuestionForm qf on e.QuestionForm_id = qf.QuestionForm_id 
	inner join survey_def sd on qf.survey_id=sd.survey_id
	inner join SENTMAILING sm on sm.SENTMAIL_ID = qf.SENTMAIL_ID
	inner join SCHEDULEDMAILING scm on scm.scheduledmailing_id = sm.scheduledmailing_id
	inner join MAILINGSTEP ms on ms.MAILINGSTEP_ID = scm.mailingstep_id
	where e.study_id IS NOT NULL 
           AND e.tiextracted = 0
		   AND sd.surveytype_id=3
	GROUP  BY e.QuestionForm_id, ms.STRMAILINGSTEP_NM


    CREATE INDEX tmpindex ON #HHQF (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update tmp table with procedure call' 

--	UPDATE #HHQF
--	SET    complete = dbo.Hhcahpscompleteness(QuestionForm_id) 
	exec dbo.HHCAHPSCompleteness

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'HH update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = Complete 
    FROM   QuestionForm qf, #HHQF t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

--	DROP TABLE #HHQF --> we're using this later, so don't drop it yet.

    --END: Get the records that are HHCAHPS so we can compute completeness  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'CGCAHPS get hcahps records and index' 

    --Get the records that are CGCAHPS so we can compute completeness  
    SELECT e.QuestionForm_id, CONVERT(INT, NULL) Complete 
    INTO   #c 
    FROM   QuestionForm_extract e, 
           QuestionForm qf, 
           Survey_def sd 
    WHERE  e.study_id IS NOT NULL 
           AND e.tiextracted = 0 
           AND datextracted_dt IS NULL 
           AND e.QuestionForm_id = qf.QuestionForm_id 
           AND qf.Survey_id = sd.Survey_id 
           AND Surveytype_id = 4 
    GROUP  BY e.QuestionForm_id 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    --delete #c   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    CREATE INDEX tmpindex ON #c (QuestionForm_id) 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'CGCAHPS update tmp table with function call' 

    UPDATE #c 
	SET    complete = dbo.fn_CGCAHPSCompleteness(QuestionForm_id) --S44 US12

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'CGCAHPS update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = CASE WHEN complete = 1 THEN 1 ELSE 0 END -- S44 US12
    FROM   QuestionForm qf, 
           #c t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

    DROP TABLE #c 

	-------------------------------------------------------------------
	-- ccaouette 2014/04: Commented out and moved to Catalyst ETL
	-------------------------------------------------------------------
    --END: Get the records that are CGCAHPS so we can compute completeness  

 --   INSERT INTO drm_tracktimes 
 --   SELECT Getdate(), 'exec CheckForACOCAHPSUsablePartials' 

	--exec dbo.CheckForACOCAHPSUsablePartials

 --   INSERT INTO drm_tracktimes 
 --   SELECT Getdate(), 'exec CheckForACOCAHPSIncompletes' 

	--exec dbo.CheckForACOCAHPSIncompletes
 --   --END: Get the records that are ACO so we can compute completeness  

INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'populate Cmnt_QuestionResult_Work' 

    INSERT INTO cmnt_QuestionResult_work 
                (QuestionForm_id, 
                 strlithocode, 
                 SamplePop_id, 
                 val, 
                 sampleunit_id, 
                 qstncore, 
                 datmailed, 
                 datimported, 
                 study_id, 
                 datGenerated, 
                 qf.Survey_id, 
                 receipttype_id, 
                 Surveytype_id, 
                 bitcomplete) 
    SELECT qf.QuestionForm_id, 
           strlithocode, 
           qf.SamplePop_id, 
           intresponseval, 
           sampleunit_id, 
           qstncore, 
           datmailed, 
           datResultsImported, 
           qfe.study_id, 
           datGenerated, 
           qf.Survey_id, 
           Isnull(qf.receipttype_id, 17), 
           sd.Surveytype_id, 
           qf.bitcomplete 
    FROM   (SELECT DISTINCT QuestionForm_id, study_id 
            FROM   QuestionForm_extract 
            WHERE  study_id IS NOT NULL 
                   AND tiextracted = 0 
                   AND datextracted_dt IS NULL) qfe, 
           QuestionForm qf, 
           SentMailing sm, 
           QuestionResult qr, 
           Survey_def sd 
    WHERE  qfe.QuestionForm_id = qf.QuestionForm_id 
           AND qf.QuestionForm_id = qr.QuestionForm_id 
           AND qf.SentMail_id = sm.SentMail_id 
           AND qf.Survey_id = sd.Survey_id 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    --and sd.SurveyType_id=2   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'populate Extract_Web_QuestionForm' 

    --*******************************************************************   
    --**  DRM 12/30/2012  Temp hack to allow hcahps only   
    --*******************************************************************   
    INSERT INTO extract_web_QuestionForm 
                (study_id, 
                 Survey_id, 
                 QuestionForm_id, 
                 SamplePop_id, 
                 sampleunit_id, 
                 strlithocode, 
                 sampleset_id, 
                 datReturned, 
                 bitcomplete, 
                 strunitselecttype, 
                 langid, 
                 receipttype_id) 
    SELECT sp.study_id, 
           qf.Survey_id, 
           qf.QuestionForm_id, 
           qf.SamplePop_id, 
           sampleunit_id, 
           strlithocode, 
           sp.sampleset_id, 
           qf.datReturned, 
           qf.bitcomplete, 
           ss.strunitselecttype, 
           langid, 
           qf.receipttype_id 
    FROM   (SELECT DISTINCT QuestionForm_id, study_id 
            FROM   cmnt_QuestionResult_work) qfe, 
           QuestionForm qf, 
           SentMailing sm, 
           SamplePop sp, 
           selectedsample ss 
    WHERE  qfe.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = sm.SentMail_id 
           AND qf.SamplePop_id = sp.SamplePop_id 
           AND sp.sampleset_id = ss.sampleset_id 
           AND sp.pop_id = ss.pop_id 

    --INSERT INTO Extract_Web_QuestionForm (sp.Study_id, qf.Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id,                   
    -- strLithoCode, Sampleset_id, datReturned, bitComplete, strUnitSelectType, LangID, receiptType_ID)                  
    --SELECT sp.Study_id, qf.Survey_ID, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode,                   
    -- sp.SampleSet_id, qf.datReturned, qf.bitComplete, ss.strUnitSelectType, LangID, qf.ReceiptType_id                
    --FROM (SELECT DISTINCT QuestionForm_id, Study_id               
    --  FROM Cmnt_QuestionResult_work) qfe,                 
    -- QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss                   
    --, Survey_def sd   
    --WHERE qfe.QuestionForm_id=qf.QuestionForm_id                    
    --AND qf.SentMail_id=sm.SentMail_id               
    --AND qf.SamplePop_id=sp.SamplePop_id                   
    --AND sp.Sampleset_id=ss.Sampleset_id                   
    --AND sp.Pop_id=ss.Pop_id              
    --and qf.Survey_id = sd.Survey_id      
    --and sd.Surveytype_id = 2   
    --*******************************************************************   
    --**  end hack   
    --*******************************************************************   
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Calc days from first mailing' 

    -- Add code to determine days from first mailing as well as days from current mailing until the return 
    -- Get all of the maildates for the SamplePops were are extracting  
    SELECT e.SamplePop_id, 
           strlithocode, 
           MailingStep_id, 
           CONVERT(DATETIME, CONVERT(VARCHAR(10), Isnull(datmailed, datprinted), 120 )) 
           datMailed 
    INTO   #mail 
    FROM   (SELECT SamplePop_id 
            FROM   extract_web_QuestionForm 
            GROUP  BY SamplePop_id) e, 
           ScheduledMailing schm, 
           SentMailing sm 
    WHERE  e.SamplePop_id = schm.SamplePop_id 
           AND schm.SentMail_id = sm.SentMail_id 

    CREATE INDEX tempindex ON #mail (SamplePop_id, strlithocode) 

    -- Update the work table with the actual number of days  
    UPDATE ewq 
    SET    DaysFromFirstMailing = Datediff(day, firstmail, datReturned), 
           DaysFromCurrentMailing = Datediff(day, c.datmailed, datReturned) 
    FROM   extract_web_QuestionForm ewq, 
           (SELECT SamplePop_id, Min(datmailed) FirstMail 
            FROM   #mail 
            GROUP  BY SamplePop_id) t, 
           #mail c 
    WHERE  ewq.SamplePop_id = t.SamplePop_id 
           AND ewq.SamplePop_id = c.SamplePop_id 
           AND ewq.strlithocode = c.strlithocode 

    -- Make sure there are no negative days.  
    UPDATE extract_web_QuestionForm 
    SET    daysfromfirstmailing = 0 
    WHERE  daysfromfirstmailing < 0 

    UPDATE extract_web_QuestionForm 
    SET    daysfromcurrentmailing = 0 
    WHERE  daysfromcurrentmailing < 0 

    DROP TABLE #mail 

    -- Modification 7/28/04 SJS -- Replaced code for skip pattern recode so that nested skip patterns are handled correctly 
	-- Modified 8/27/2013 CBC -- Removed explicit Primary Key constraint name 
    --SET NOCOUNT ON  
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --DECLARE @work TABLE (QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)                
    --CREATE TABLE #work 
    --  (  workident       INT IDENTITY (1, 1) CONSTRAINT pk_work_workident_a PRIMARY KEY, 
    --     QuestionForm_id INT, 
    --     sampleunit_id   INT, 
    --     skip_id         INT, 
    --     Survey_id       INT 
    --  )
	 
	CREATE TABLE #work 
      (  workident       INT IDENTITY (1, 1) PRIMARY KEY, 
         QuestionForm_id INT, 
         sampleunit_id   INT, 
         skip_id         INT, 
         Survey_id       INT 
      ) 


    DECLARE @qf INT, @su INT, @sk INT, @svy INT, @bitUpdate BIT  

    SET @bitUpdate = 1 

    --Now to recode Skip pattern results  
    --If we have a valid answer, we will add 10000 to the responsevalue  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Skip patterns' 

    -- Identify the first skip pattern that needs to be enforced for a QuestionForm_id  
    DECLARE @rowcount INT 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --INSERT INTO @work (QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id)                 
    INSERT INTO #work (QuestionForm_id, sampleunit_id, skip_id, Survey_id) 
    SELECT QuestionForm_id, sampleunit_id, skip_id, si.Survey_id 
    FROM   cmnt_QuestionResult_work qr 
           INNER JOIN skipidentifier si  ON qr.Survey_id = si.Survey_id
                                           AND qr.datGenerated = si.datGenerated 
                                AND qr.qstncore = si.qstncore 
                                           AND qr.val = si.intresponseval 
           INNER JOIN Survey_def sd      ON si.Survey_id = sd.Survey_id 
    WHERE  sd.bitenforceskip <> 0 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, skip_id, si.Survey_id 
    FROM   cmnt_QuestionResult_work qr 
           INNER JOIN skipidentifier si ON qr.Survey_id = si.Survey_id
                                           AND qr.datGenerated = si.datGenerated 
                                           AND qr.qstncore = si.qstncore 
                                           AND qr.val IN ( -8, -9, -6, -5 ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
           INNER JOIN Survey_def sd     ON si.Survey_id = sd.Survey_id 
    WHERE  sd.bitenforceskip <> 0 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, -1 Skip_id, q.Survey_id 
    FROM   cmnt_QuestionResult_work q, Survey_def sd 
    WHERE  qstncore = 38694 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
    UNION 
    SELECT QuestionForm_id, sampleunit_id, -2 Skip_id, q.Survey_id 
    FROM   cmnt_QuestionResult_work q, Survey_def sd 
    WHERE  qstncore = 38726 
           AND val <> 1 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 3 
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    ORDER  BY 1, 2, 3, 4 

    CREATE INDEX tmpwork_index ON #work (QuestionForm_id, sampleunit_id, skip_id, Survey_id) 

    SELECT @rowcount = @@rowcount 

    PRINT 'After insert into #work: ' + Cast(@rowcount AS VARCHAR) 

/*************************************************************************************************/
    --Assign Final Dispositions for HCAHPS and HHCAHPS  
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Final Dispositions' 

    --HCAHPS DispositionS  
    UPDATE cqw 
    SET    FinalDisposition = '01' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 2 
           AND bitcomplete = 1 

    UPDATE cqw 
    SET    FinalDisposition = '06' 
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 2 
           AND bitcomplete = 0 

    --HHCAHPS DispositionS 
    -- if more than half of the ATA questions have been answered, bitComplete=1 and it's coded as a Complete
    UPDATE cqw 
    SET    FinalDisposition = '110' -- Completed Mail Survey
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 17 

    UPDATE cqw 
    SET    FinalDisposition = '120' -- Completed Phone Interview
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 3 
           AND bitcomplete = 1 
           AND ReceiptType_ID = 12 

    --SELECT q.QuestionForm_id 
    --INTO   #hhcahps_invalidDisposition 
    --FROM   cmnt_QuestionResult_work q, 
    --       Survey_def sd 
    --WHERE  qstncore = 38694 
    --       AND val <> 1 
    --       AND sd.Survey_id = q.Survey_id 
    --       AND sd.Surveytype_id = 3 
    --       AND bitcomplete = 0 

	-- if incomplete and Q1=No and they didn't answer any other questions, they're ineligible
    UPDATE cqw 
    SET    FinalDisposition = '220' -- Ineligible: Does not meet eligible Population criteria
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on  hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.Q1 = 2
           AND hh.complete = 0
           AND hh.numAnswersAfterQ1 = 0

    --SELECT q.QuestionForm_id 
    --INTO   #hhcahps_validDisposition 
    --FROM   cmnt_QuestionResult_work q, 
    --       Survey_def sd 
    --WHERE  qstncore = 38694 
    --       AND val = 1 
    --       AND sd.Survey_id = q.Survey_id 
    --       AND sd.Surveytype_id = 3 
    --       AND bitcomplete = 0 

	-- if incomplete and Q1=Yes or they answered questions after Q1, it's a breakoff
    UPDATE cqw 
    SET    FinalDisposition = '310' -- Breakoff
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND (hh.numAnswersAfterQ1 > 0 or hh.Q1=1)
           
	-- if incomplete and Q1 isn't answered and they didn't answer anything else either, it's just a blank survey.
	-- Modified 03/27/2015 TSB  to only look at 2ndSurvey
    UPDATE cqw 
    SET    FinalDisposition = '320' -- Refusal
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND hh.numAnswersAfterQ1=0 
           AND hh.Q1=-9
		   AND hh.STRMAILINGSTEP_NM = '2nd Survey'

    --CGCAHPS Dispositions  S44 US12
    UPDATE cqw 
    SET    FinalDisposition = dbo.fn_CGCAHPSCompleteness(cqw.questionform_id)
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 


    SELECT q.QuestionForm_id 
    INTO   #cgcahps_negrespscreenqstn 
    FROM   cmnt_QuestionResult_work q, 
           Survey_def sd 
    WHERE  qstncore in (39113,44121,46265,50344,50483)
           AND val = 2
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 4 

    UPDATE cqw 
    SET    FinalDisposition = '4' -- answered no to q1
    FROM   cmnt_QuestionResult_work cqw, 
           #cgcahps_negrespscreenqstn i 
    WHERE  i.QuestionForm_id = cqw.QuestionForm_id 


    --ACO CAHPS Dispositions
    select DISTINCT cqw.questionform_id, 0 as ATACnt, 0 as ATAComplete, 0 as MeasureCnt, 0 as MeasureComplete, 0 as Disposition, Subtype_nm, st.SurveyType_ID
    into #ACOQF
    FROM   cmnt_QuestionResult_work cqw 
    inner join Surveytype st on cqw.Surveytype_id=st.Surveytype_id
	left join (select sst.Survey_id, sst.Subtype_id, st.Subtype_nm 
				from [dbo].[SurveySubtype] sst 
				INNER JOIN [dbo].[Subtype] st on (st.Subtype_id = sst.Subtype_id)
				) sst on sst.Survey_id = cqw.SURVEY_ID 
    WHERE  st.SurveyType_dsc in ('ACOCAHPS','PQRS CAHPS')
    
    exec dbo.ACOCAHPSCompleteness
        
    UPDATE cqw 
    SET    FinalDisposition = qf.Disposition
    FROM   cmnt_QuestionResult_work cqw 
    inner join #ACOQF qf on cqw.questionform_id=qf.questionform_id
    WHERE  qf.disposition <> 255

	drop table #ACOQF

    /*************************************************************************************************/
    /************************************************************************************************/
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Find ineligible hcahps' 

    --round up all the HHCHAPS Surveys that were not eligible (qstncore 38694 <> 1) and set an inelig. Disposition. 
    DECLARE @InEligDispo INT, @SQL VARCHAR(8000) 

    SELECT @InEligDispo = d.Disposition_id 
    FROM   Disposition d, 
           hhcahpsDispositions hd 
    WHERE  d.Disposition_id = hd.Disposition_id 
           AND hd.hhcahpsvalue = '220' 

    --SELECT q.QuestionForm_id  
    --into #updateDisposition  
    --FROM Cmnt_QuestionResult_Work q, Survey_DEF sd  
    --WHERE qstncore = 38694 AND val <> 1 AND sd.Survey_ID = q.Survey_id AND sd.SurveyType_id = 3  
    CREATE TABLE #updatedispsql (a INT IDENTITY (1, 1), strsql VARCHAR(8000))  

    --HCHAPS  
    INSERT INTO #updatedispsql 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.hcahpsvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 2 

    --HHCAHPS  
    INSERT INTO #updatedispsql 
                (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.hhcahpsvalue = cqw.finalDisposition 
      AND cqw.Surveytype_id = 3 

    --CGCAHPS 
    INSERT INTO #updatedispsql (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.mncmvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = 4 

    --ACO
    INSERT INTO #updatedispsql (strsql) 
    SELECT DISTINCT 'Exec QCL_LogDisposition ' 
                    + Cast(scm.SentMail_id AS VARCHAR(100)) + ', ' 
                    + Cast(scm.SamplePop_id AS VARCHAR(100)) + ', ' 
                    + Cast(dv.Disposition_id AS VARCHAR(100)) + ', ' 
                    + Cast(qf.receipttype_id AS VARCHAR(100)) + ', ' 
                    + '''#nrcsql''' + ', ' 
                    + '''' + CONVERT(VARCHAR, Getdate(), 120) + '''' AS strSQL 
    FROM   cmnt_QuestionResult_work cqw, 
           QuestionForm qf, 
           ScheduledMailing scm, 
           Dispositions_view dv,
		   surveytype st 
    WHERE  cqw.QuestionForm_id = qf.QuestionForm_id 
           AND qf.SentMail_id = scm.SentMail_id 
           AND dv.acocahpsvalue = cqw.finalDisposition 
           AND cqw.Surveytype_id = st.SurveyType_ID
		   and st.SurveyType_dsc in ('ACOCAHPS','PQRS CAHPS')

    WHILE (SELECT Count(*) FROM #updatedispsql) > 0 
      BEGIN 
          SELECT TOP 1 @SQL = strsql FROM #updatedispsql 
          EXEC (@SQL) 

          DELETE FROM #updatedispsql WHERE strsql = @SQL 
      END 

    /************************************************************************************************/
    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'Update skip questions' 

    DECLARE @loopcnt INT 
    SET @loopcnt = 0 

    --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
    DECLARE @invskipcnt INT 
    SET @invskipcnt = 0 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    SELECT TOP 1 @qf = QuestionForm_id, 
                 @su = sampleunit_id, 
                 @sk = skip_id, 
                 @svy = Survey_id 
    --FROM @WORK              
    FROM   #work 
    ORDER  BY QuestionForm_id, 
              sampleunit_id, 
              skip_id 

    -- Update skipped qstncores while we have work to process  
    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    --WHILE (SELECT COUNT(*) FROM @work) > 0                 
    WHILE (SELECT Count(*) FROM #work) > 0 
      BEGIN 
          SET @loopcnt = @loopcnt + 1 

          --print 'QuestionForm_ID = ' + cast(@qf as varchar(10))  
          --print 'Sampleunit_ID = ' + cast(@su as varchar(10))  
          --print '@skip = ' + cast(@sk as varchar(10))  
          --print '@svy = ' + cast(@svy as varchar(10))  
          --print '@bitUpdate = ' + cast(@bitUpdate as varchar(10))  
          --SkipPatternWork:  
          IF @bitUpdate = 1 
            BEGIN 
                --print 'standard skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       skipqstns sq 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = Skip_id 
                       AND sq.qstncore = qr.qstncore 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'Start HHCAHPS qstncore 38694 skip update' 
                  END 

                --print 'HHCAHPS qstncore 38694 skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       Survey_def sd, 
                       (SELECT DISTINCT qstncore 
                        FROM   sel_qstns 
                        WHERE  Survey_id = @svy 
                               AND qstncore <> 38694 
                               AND nummarkcount > 0) a 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = -1 
                       AND a.qstncore = qr.qstncore 
                       AND sd.Survey_id = @svy 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 
                       AND sd.Surveytype_id = 3 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'End HHCAHPS qstncore 38694 skip update' 
                  END 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'Start HHCAHPS qstncore 38726 skip update' 
                  END 

                --print 'HHCAHPS qstncore 38726 skip update'  
                UPDATE qr 
                -- SET Val=-7  
                SET    Val = VAL + 10000 
                FROM   cmnt_QuestionResult_work qr, 
                       Survey_def sd 
                WHERE  @qf = qr.QuestionForm_id 
                       AND @su = qr.sampleunit_id 
                       AND @sk = -2 
                       AND qr.qstncore = 38727 
                       AND sd.Survey_id = @svy 
                       --dbg 5/14/13--AND Val NOT IN (-9,-8,-6,-5)  --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                       AND Val < 9000 
                       AND sd.Surveytype_id = 3 

                IF @loopcnt < 25 
                  BEGIN 
                      INSERT INTO drm_tracktimes 
                      SELECT Getdate(), 'End HHCAHPS qstncore 38726 skip update' 
                  END 
            END 

          -- Identify the NEXT skip pattern that needs to be enforced for a QuestionForm_id  
          -- Modified 01/03/2013 DRH changed @work to #work plus index 
          --DELETE FROM @work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id    
          DELETE FROM #work 
         WHERE  @qf = QuestionForm_id 
                 AND @su = sampleunit_id 
                 AND @sk = skip_id 
                 AND @svy = Survey_id 

          --SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM @WORK ORDER BY QuestionForm_id, sampleunit_id, skip_id     
          SELECT TOP 1 @qf = QuestionForm_id, 
                   @su = sampleunit_id, 
                       @sk = skip_id, 
                       @svy = Survey_id 
          FROM   #work 
          ORDER  BY QuestionForm_id, 
                    sampleunit_id, 
                    skip_id 

          IF @loopcnt < 25 
            BEGIN 
                INSERT INTO drm_tracktimes 
                SELECT Getdate(), 'Start Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'
            END 

          --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
          SELECT @invskipcnt = Count(*) 
          FROM   cmnt_QuestionResult_work qr 
                 INNER JOIN skipidentifier si  ON qr.Survey_id = si.Survey_id
                                                  AND qr.datGenerated = si.datGenerated 
                                                  AND qr.qstncore = si.qstncore 
                                                  AND ( qr.val = si.intresponseval OR qr.val IN ( -8, -9, -6, -5 ) ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                 INNER JOIN Survey_def sd      ON si.Survey_id = sd.Survey_id 
                 INNER JOIN skipqstns sq       ON si.skip_id = sq.skip_id 
                 INNER JOIN skipidentifier si2 ON sq.qstncore = si2.qstncore 
                                                  AND si2.skip_id = @sk 
          WHERE  sd.bitenforceskip <> 0 
                 AND qr.QuestionForm_id = @qf 

          -- Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop 
          IF (SELECT Count(*) 
              FROM   cmnt_QuestionResult_work qr 
                     INNER JOIN skipidentifier si ON qr.QuestionForm_id = @qf 
                                                     AND qr.sampleunit_id = @su  
                                                     AND qr.Survey_id = si.Survey_id
                                                     AND qr.datGenerated = si.datGenerated 
                                                     AND qr.qstncore = si.qstncore 
                                                     AND ( qr.val = si.intresponseval OR qr.val IN ( -8, -9, -6, -5 ) ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
                                     AND si.skip_id = @sk 
                                                     --Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
                                                     AND @invskipcnt = 0 
             -- 11/30/12 DRM -- Nested skip questions  
             -- If any previous gateway questions include the current gateway as a skip question,  
             --  and if the previous gateway was answered so as to skip the current gateway,  
             -- then don't enforce skip logic on the current gateway question.  
             --select count(*)  
             --FROM Cmnt_QuestionResult_Work qr  
             --INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND (qr.Val=si.intResponseVal OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
             --INNER JOIN Survey_def sd ON si.Survey_id = sd.Survey_id  
             --inner join SkipQstns sq on si.Skip_id = sq.Skip_id  
             --inner join skipidentifier si2 on sq.QstnCore = si2.QstnCore and si2.Skip_id = @sk  
             --WHERE sd.bitEnforceSkip <> 0  
             --and qr.QuestionForm_id = @qf  
             ) > 0 
              OR (SELECT count(*)
                  FROM   cmnt_QuestionResult_work qr, 
                         Survey_def sd 
                  WHERE  qr.QuestionForm_id = @qf 
                     AND qr.sampleunit_id = @su 
                         AND qstncore = 38694 
                         AND val <> 1 
                         AND @sk = -1 
                         AND sd.Survey_id = qr.Survey_id 
                         AND sd.Surveytype_id = 3) > 0 
              OR (SELECT count(*)
                  FROM   cmnt_QuestionResult_work qr, 
                         Survey_def sd 
                  WHERE  qr.QuestionForm_id = @qf 
                         AND qr.sampleunit_id = @su 
                         AND qstncore = 38726 
                         AND val <> 1 
                         AND @sk = -2 
                         AND sd.Survey_id = qr.Survey_id 
                         AND sd.Surveytype_id = 3) > 0 
            SET @bitUpdate = 1 
          ELSE 
            SET @bitUpdate = 0 

          IF @loopcnt < 25 
            BEGIN 
                INSERT INTO drm_tracktimes 
                SELECT Getdate(), 'End Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'
            END 
      END 

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'End SP_Phase3_QuestionResult_For_Extract' 

    -- Modified 01/03/2013 DRH changed @work to #work plus index 
    DROP TABLE #work 

	--dbg 5/14/13-- -8's and -9's are now being offset, but we don't really want them to be. So we're now offsetting them back.
    UPDATE cmnt_QuestionResult_work 
    SET    val = val - 10000 
    WHERE  val IN ( 9991, 9992, 9995, 9994 ) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know

    SET nocount OFF 
    SET TRANSACTION isolation level READ committed


GO


ALTER PROCEDURE [dbo].[SP_Phase3_QuestionResult_For_Extract_by_Samplepop]
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

-- Modified 03/08/2015 TSB -- S44 US12 12 CG-CAHPS Completeness: As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.


insert into drm_tracktimes select getdate(), 'Begin SP_Phase3_QuestionResult_For_Extract' 

--The Cmnt_QuestionResult_work table should be able to be removed. 
TRUNCATE TABLE Cmnt_QuestionResult_work 
TRUNCATE TABLE Extract_Web_QuestionForm 

insert into drm_tracktimes select getdate(), 'H get hcahps records and index' 

--Get the records that are HCAHPS so we can compute completeness 
SELECT e.QuestionForm_id, CONVERT(INT,NULL) Complete 
INTO #a 
FROM QuestionForm_Extract e, QuestionForm qf, Survey_def sd 
WHERE e.Study_id IS NOT NULL 
AND e.tiExtracted=0 
AND datExtracted_dt IS NULL 
AND e.QuestionForm_id=qf.Questionform_id 
AND qf.Survey_id=sd.Survey_id 
AND SurveyType_id=2 
GROUP BY e.QuestionForm_id 

CREATE INDEX tmpIndex ON #a (QuestionForm_id) 

insert into drm_tracktimes select getdate(), 'H update tmp table with function call' 

UPDATE #a SET Complete=dbo.HCAHPSCompleteness(QuestionForm_id) 


insert into drm_tracktimes select getdate(), 'H update questionform' 

UPDATE qf 
SET bitComplete=Complete 
FROM QuestionForm qf, #a t 
WHERE t.QuestionForm_id=qf.QuestionForm_id 


DROP TABLE #a 

--END: Get the records that are HCAHPS so we can compute completeness 

insert into drm_tracktimes select getdate(), 'HH get hcahps records and index' 

--Get the records that are HHCAHPS so we can compute completeness 
--SELECT e.QuestionForm_id, CONVERT(INT,NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1
--INTO #HHQF
--FROM QuestionForm_Extract e, QuestionForm qf, Survey_def sd 
--WHERE e.Study_id IS NOT NULL 
--AND e.tiExtracted=0 
--AND datExtracted_dt IS NULL 
--AND e.QuestionForm_id=qf.Questionform_id 
--AND qf.Survey_id=sd.Survey_id 
--AND SurveyType_id=3 
--GROUP BY e.QuestionForm_id 

select e.QuestionForm_id, CONVERT(INT, NULL) Complete, convert(int,null) ATACnt, convert(int,null) Q1, convert(int,null) numAnswersAfterQ1, ms.STRMAILINGSTEP_NM
	into #HHQF
	from QuestionForm_extract e
	inner join QuestionForm qf on e.QuestionForm_id = qf.QuestionForm_id 
	inner join survey_def sd on qf.survey_id=sd.survey_id
	inner join SENTMAILING sm on sm.SENTMAIL_ID = qf.SENTMAIL_ID
	inner join SCHEDULEDMAILING scm on scm.scheduledmailing_id = sm.scheduledmailing_id
	inner join MAILINGSTEP ms on ms.MAILINGSTEP_ID = scm.mailingstep_id
	where e.study_id IS NOT NULL 
           AND e.tiextracted = 0
		   AND sd.surveytype_id=3
	GROUP  BY e.QuestionForm_id, ms.STRMAILINGSTEP_NM

CREATE INDEX tmpIndex ON #HHQF (QuestionForm_id) 

insert into drm_tracktimes select getdate(), 'HH update tmp table with procedure call' 

--UPDATE #HHQF SET Complete=dbo.HHCAHPSCompleteness(QuestionForm_id) 
exec dbo.HHCAHPSCompleteness

insert into drm_tracktimes select getdate(), 'HH update questionform' 

UPDATE qf 
SET bitComplete=Complete 
FROM QuestionForm qf, #HHQF t 
WHERE t.QuestionForm_id=qf.QuestionForm_id 

--DROP TABLE #HHQF --> we're using this later, so don't drop it yet.
--END: Get the records that are HHCAHPS so we can compute completeness 

insert into drm_tracktimes select getdate(), 'CGCAHPS get hcahps records and index' 

--Get the records that are MNCM so we can compute completeness 
SELECT e.QuestionForm_id, CONVERT(INT,NULL) Complete 
INTO #c 
FROM QuestionForm_Extract e, QuestionForm qf, Survey_def sd 
WHERE e.Study_id IS NOT NULL 
AND e.tiExtracted=0 
AND datExtracted_dt IS NULL 
AND e.QuestionForm_id=qf.Questionform_id 
AND qf.Survey_id=sd.Survey_id 
AND SurveyType_id=4 
GROUP BY e.QuestionForm_id 

--*******************************************************************  
--**  DRM 12/30/2012  Temp hack to allow hcahps only  
--*******************************************************************  
--delete #c  
--*******************************************************************  
--**  end hack  
--*******************************************************************  


CREATE INDEX tmpIndex ON #c (QuestionForm_id) 

insert into drm_tracktimes select getdate(), 'CGCAHPS update tmp table with function call' 

UPDATE #c 
	SET    complete = dbo.fn_CGCAHPSCompleteness(QuestionForm_id) --S44 US12

    INSERT INTO drm_tracktimes 
    SELECT Getdate(), 'CGCAHPS update QuestionForm' 

    UPDATE qf 
    SET    bitComplete = CASE WHEN complete = 1 THEN 1 ELSE 0 END -- S44 US12
    FROM   QuestionForm qf, 
           #c t 
    WHERE  t.QuestionForm_id = qf.QuestionForm_id 

DROP TABLE #c 
--END: Get the records that are CGCAHPS so we can compute completeness 

insert into drm_tracktimes select getdate(), 'populate Cmnt_QuestionResult_Work' 

INSERT INTO Cmnt_QuestionResult_Work (QuestionForm_id, strLithoCode, SamplePop_id, Val, 
SampleUnit_id, QstnCore, datMailed, datImported, Study_id, datGenerated, qf.Survey_id, 
ReceiptType_ID, SurveyType_ID, bitComplete) 
SELECT qf.QuestionForm_id, strLithoCode, qf.SamplePop_id, intResponseVal, SampleUnit_id, 
QstnCore, datMailed, datResultsImported, qfe.Study_id, datGenerated, qf.Survey_id, 
isnull(qf.ReceiptType_ID, 17), sd.SurveyType_id, qf.bitComplete 
FROM (SELECT DISTINCT QuestionForm_id, Study_id 
FROM QuestionForm_Extract 
WHERE Study_id IS NOT NULL 
AND tiExtracted=0 
AND datExtracted_dt IS NULL) qfe, 
QuestionForm qf, SentMailing sm, QuestionResult qr, SURVEY_DEF sd 
WHERE qfe.QuestionForm_id=qf.QuestionForm_id 
AND qf.QuestionForm_id=qr.QuestionForm_id 
AND qf.SentMail_id=sm.SentMail_id 
AND qf.SURVEY_ID = sd.SURVEY_ID 
and SAMPLEPOP_ID in (select samplepop_id from samplepops_to_manually_extract)
--*******************************************************************  
--**  DRM 12/30/2012  Temp hack to allow hcahps only  
--*******************************************************************  
--and sd.SurveyType_id=2  
--*******************************************************************  
--**  end hack  
--*******************************************************************  

insert into drm_tracktimes select getdate(), 'populate Extract_Web_QuestionForm' 

--*******************************************************************  
--**  DRM 12/30/2012  Temp hack to allow hcahps only  
--*******************************************************************  

INSERT INTO Extract_Web_QuestionForm (Study_id, Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id, 
strLithoCode, Sampleset_id, datreturned, bitComplete, strUnitSelectType, LangID, receiptType_ID) 
SELECT sp.Study_id, qf.survey_ID, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode, 
sp.SampleSet_id, qf.datReturned, qf.bitComplete, ss.strUnitSelectType, LangID, qf.ReceiptType_id 
FROM (SELECT DISTINCT QuestionForm_id, Study_id 
FROM Cmnt_QuestionResult_work) qfe, 
QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss 
WHERE qfe.QuestionForm_id=qf.QuestionForm_id 
AND qf.SentMail_id=sm.SentMail_id 
AND qf.SamplePop_id=sp.SamplePop_id 
AND sp.Sampleset_id=ss.Sampleset_id 
AND sp.Pop_id=ss.Pop_id 
and qf.SAMPLEPOP_ID in (select samplepop_id from samplepops_to_manually_extract)
--INSERT INTO Extract_Web_QuestionForm (sp.Study_id, qf.Survey_ID, QuestionForm_id, SamplePop_id, SampleUnit_id,                   
-- strLithoCode, Sampleset_id, datreturned, bitComplete, strUnitSelectType, LangID, receiptType_ID)                  
--SELECT sp.Study_id, qf.survey_ID, qf.QuestionForm_id, qf.SamplePop_id, SampleUnit_id, strLithoCode,                   
-- sp.SampleSet_id, qf.datReturned, qf.bitComplete, ss.strUnitSelectType, LangID, qf.ReceiptType_id                
--FROM (SELECT DISTINCT QuestionForm_id, Study_id                
--  FROM Cmnt_QuestionResult_work) qfe,                
-- QuestionForm qf, SentMailing sm, SamplePop sp, selectedSample ss                  
--, survey_def sd  
--WHERE qfe.QuestionForm_id=qf.QuestionForm_id                   
--AND qf.SentMail_id=sm.SentMail_id                   
--AND qf.SamplePop_id=sp.SamplePop_id                  
--AND sp.Sampleset_id=ss.Sampleset_id                  
--AND sp.Pop_id=ss.Pop_id             
--and qf.survey_id = sd.survey_id     
--and sd.surveytype_id = 2  
--*******************************************************************  
--**  end hack  
--*******************************************************************  


insert into drm_tracktimes select getdate(), 'Calc days from first mailing' 

-- Add code to determine days from first mailing as well as days from current mailing until the return 
-- Get all of the maildates for the samplepops were are extracting 
SELECT e.SamplePop_id, strLithoCode, MailingStep_id, CONVERT(DATETIME,CONVERT(VARCHAR(10),ISNULL(datMailed,datPrinted),120)) datMailed 
INTO #Mail 
FROM (SELECT SamplePop_id FROM Extract_Web_QuestionForm GROUP BY SamplePop_id) e, ScheduledMailing schm, SentMailing sm 
WHERE e.SamplePop_id=schm.SamplePop_id 
AND schm.SentMail_id=sm.SentMail_id 

CREATE INDEX TempIndex ON #Mail (SamplePop_id, strLithoCode) 

-- Update the work table with the actual number of days 
UPDATE ewq 
SET DaysFromFirstMailing=DATEDIFF(DAY,FirstMail,datReturned), DaysFromCurrentMailing=DATEDIFF(DAY,c.datMailed,datReturned) 
FROM Extract_Web_QuestionForm ewq, 
(SELECT SamplePop_id, MIN(datMailed) FirstMail FROM #Mail GROUP BY SamplePop_id) t, #Mail c 
WHERE ewq.SamplePop_id=t.SamplePop_id 
AND ewq.SamplePop_id=c.SamplePop_id 
AND ewq.strLithoCode=c.strLithoCode 

-- Make sure there are no negative days. 
UPDATE Extract_Web_QuestionForm SET DaysFromFirstMailing=0 WHERE DaysFromFirstMailing<0 
UPDATE Extract_Web_QuestionForm SET DaysFromCurrentMailing=0 WHERE DaysFromCurrentMailing<0 

DROP TABLE #Mail 

-- Modification 7/28/04 SJS -- Replaced code for skip pattern recode so that nested skip patterns are handled correctly 
--SET NOCOUNT ON 

-- Modified 01/03/2013 DRH changed @work to #work plus index
--DECLARE @work TABLE (QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)                
CREATE TABLE #work (workident INT IDENTITY (1,1) CONSTRAINT PK_work_workident PRIMARY KEY, QuestionForm_id INT, SampleUnit_id INT, Skip_id INT, Survey_id INT)          

DECLARE @qf INT, @su INT, @sk INT, @svy INT, @bitUpdate BIT 
SET @bitUpdate = 1 

--Now to recode Skip pattern results 
--If we have a valid answer, we will add 10000 to the responsevalue 


insert into drm_tracktimes select getdate(), 'Skip patterns' 


-- Identify the first skip pattern that needs to be enforced for a questionform_id 
declare @rowcount int

-- Modified 01/03/2013 DRH changed @work to #work plus index
--INSERT INTO @work (QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id)                
INSERT INTO #work (QuestionForm_id, SampleUnit_id, Skip_id, Survey_id)                
SELECT QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id 
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND qr.Val=si.intResponseVal 
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
WHERE sd.bitEnforceSkip <> 0 
UNION 
SELECT QuestionForm_id, SampleUnit_id, Skip_id, si.Survey_id 
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si 
ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND qr.Val IN (-8,-9,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
WHERE sd.bitEnforceSkip <> 0 
UNION 
SELECT QuestionForm_id, SampleUnit_id, -1 Skip_id, q.Survey_id 
FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
WHERE qstncore = 38694 AND val <> 1 AND sd.SURVEY_ID = q.Survey_id AND sd.SurveyType_id = 3 
UNION 
SELECT QuestionForm_id, SampleUnit_id, -2 Skip_id, q.Survey_id 
FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
WHERE qstncore = 38726 AND val <> 1 AND sd.SURVEY_ID = q.Survey_id AND sd.SurveyType_id = 3 
-- Modified 01/03/2013 DRH changed @work to #work plus index
ORDER BY 1,2,3,4
CREATE INDEX tmpwork_index ON #work (QuestionForm_id, SampleUnit_id, Skip_id, Survey_id)                

select @rowcount = @@rowcount
print 'After insert into #work: '+cast(@rowcount as varchar)

/*************************************************************************************************/ 
--Assign Final dispositions for HCAHPS and HHCAHPS 

insert into drm_tracktimes select getdate(), 'Final dispositions' 

--HCAHPS DISPOSITIONS 
Update cqw 
set FinalDisposition = '01' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 2 and bitcomplete = 1 

Update cqw 
set FinalDisposition = '06' 
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 2 and bitcomplete = 0 

--HHCAHPS DISPOSITIONS 
-- if more than half of the ATA questions have been answered, bitComplete=1 and it's coded as a Complete
Update cqw 
set FinalDisposition = '110' -- Completed Mail Survey
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 3 and bitcomplete = 1 and ReceiptType_ID = 17 

Update cqw 
set FinalDisposition = '120' -- Completed Phone Interview
from Cmnt_QuestionResult_Work cqw 
where SurveyType_ID = 3 and bitcomplete = 1 and ReceiptType_ID = 12 


--SELECT q.questionform_id 
--into #HHCAHPS_InvalidDisposition 
--FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
--WHERE qstncore = 38694 AND 
--val <> 1 AND 
--sd.SURVEY_ID = q.Survey_id AND 
--sd.SurveyType_id = 3 and 
--bitcomplete = 0 

-- if incomplete and Q1=No and they didn't answer any other questions, they're ineligible
Update cqw 
set FinalDisposition = '220' -- Ineligible: Does not meet eligible Population criteria
from Cmnt_QuestionResult_Work cqw
inner join #HHQF hh on hh.questionform_Id = cqw.questionform_id 
where hh.q1 = 2
and hh.complete=0
and hh.numAnswersAfterQ1 = 0

--SELECT q.questionform_id 
--into #HHCAHPS_ValidDisposition 
--FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
--WHERE qstncore = 38694 AND 
--val = 1 AND 
--sd.SURVEY_ID = q.Survey_id AND 
--sd.SurveyType_id = 3 and 
--bitcomplete = 0 

-- if incomplete and Q1=Yes or they answered questions after Q1, it's a breakoff
Update cqw 
set FinalDisposition = '310' -- Breakoff
from Cmnt_QuestionResult_Work cqw
inner join #HHQF hh on hh.questionform_Id = cqw.questionform_id 
where hh.complete=0 
and (hh.numAnswersAfterQ1 > 0 or hh.Q1=1)

-- if incomplete and Q1 isn't answered and they didn't answer anything else either, it's just a blank survey.
--UPDATE cqw 
--SET FinalDisposition = '320' -- Refusal
--FROM cmnt_QuestionResult_work cqw 
--inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
--WHERE hh.complete=0
--AND hh.numAnswersAfterQ1=0 
--AND hh.Q1=-9
-- Modified 03/27/2015 TSB  to only look at 2ndSurvey
    UPDATE cqw 
    SET    FinalDisposition = '320' -- Refusal
    FROM   cmnt_QuestionResult_work cqw 
           inner join #HHQF hh on hh.QuestionForm_id = cqw.QuestionForm_id 
    WHERE  hh.complete=0
           AND hh.numAnswersAfterQ1=0 
           AND hh.Q1=-9
		   AND hh.STRMAILINGSTEP_NM = '2nd Survey'


--CGCAHPS DISPOSITIONS 

--CGCAHPS Dispositions  S44 US12
    UPDATE cqw 
    SET    FinalDisposition = dbo.fn_CGCAHPSCompleteness(cqw.questionform_id)
    FROM   cmnt_QuestionResult_work cqw 
    WHERE  SurveyType_ID = 4 


    SELECT q.QuestionForm_id 
    INTO   #cgcahps_negrespscreenqstn 
    FROM   cmnt_QuestionResult_work q, 
           Survey_def sd 
    WHERE  qstncore in (39113,44121,46265,50344,50483)
           AND val = 2 
           AND sd.Survey_id = q.Survey_id 
           AND sd.Surveytype_id = 4 

    UPDATE cqw 
    SET    FinalDisposition = '4' -- answered no to q1
    FROM   cmnt_QuestionResult_work cqw, 
           #cgcahps_negrespscreenqstn i 
    WHERE  i.QuestionForm_id = cqw.QuestionForm_id 


/*************************************************************************************************/ 

/************************************************************************************************/ 

insert into drm_tracktimes select getdate(), 'Find ineligible hcahps' 

--round up all the HHCHAPS Surveys that were not eligible (qstncore 38694 <> 1) and set an inelig. disposition. 
DECLARE @InEligDispo INT, @SQL varchar(8000) 
SELECT @InEligDispo = d.disposition_Id FROM DISPOSITION d, HHCAHPSDispositions hd WHERE d.disposition_ID = hd.disposition_ID and hd.HHCAHPSValue = '220' 

--SELECT q.questionform_id 
--into #updateDisposition 
--FROM Cmnt_QuestionResult_Work q, SURVEY_DEF sd 
--WHERE qstncore = 38694 AND val <> 1 AND sd.SURVEY_ID = q.Survey_id AND sd.SurveyType_id = 3 

Create Table #UpdateDispSQL (a int identity (1,1), strSQL varchar(8000)) 

--HCHAPS 
Insert into #UpdateDispSQL 
select distinct 'Exec QCL_LogDisposition ' + 
cast(scm.SENTMAIL_ID as varchar(100)) + ', ' + 
cast(scm.SAMPLEPOP_ID as varchar(100)) + ', ' + 
cast(dv.Disposition_id as varchar(100)) + ', ' + 
cast(qf.ReceiptType_id as varchar(100)) + ', ' + '''#nrcsql''' + ', ' + 
'''' + convert(varchar, GETDATE(), 120) + '''' as strSQL 
from cmnt_questionresult_work cqw, questionform qf, 
scheduledmailing scm, Dispositions_view dv 
where cqw.Questionform_ID = qf.QUESTIONFORM_ID and 
qf.SENTMAIL_ID = scm.SENTMAIL_ID and 
dv.HCAHPSValue = cqw.FinalDisposition and 
cqw.SurveyType_ID = 2 

--HHCAHPS 
Insert into #UpdateDispSQL (strSQL) 
select distinct 'Exec QCL_LogDisposition ' + 
cast(scm.SENTMAIL_ID as varchar(100)) + ', ' + 
cast(scm.SAMPLEPOP_ID as varchar(100)) + ', ' + 
cast(dv.Disposition_id as varchar(100)) + ', ' + 
cast(qf.ReceiptType_id as varchar(100)) + ', ' + '''#nrcsql''' + ', ' + 
'''' + convert(varchar, GETDATE(), 120) + '''' as strSQL 
from cmnt_questionresult_work cqw, questionform qf, 
scheduledmailing scm, Dispositions_view dv 
where cqw.Questionform_ID = qf.QUESTIONFORM_ID and 
qf.SENTMAIL_ID = scm.SENTMAIL_ID and 
dv.hHCAHPSValue = cqw.FinalDisposition and 
cqw.SurveyType_ID = 3 

--CGCAHPS 
Insert into #UpdateDispSQL (strSQL) 
select distinct 'Exec QCL_LogDisposition ' + 
cast(scm.SENTMAIL_ID as varchar(100)) + ', ' + 
cast(scm.SAMPLEPOP_ID as varchar(100)) + ', ' + 
cast(dv.Disposition_id as varchar(100)) + ', ' + 
cast(qf.ReceiptType_id as varchar(100)) + ', ' + '''#nrcsql''' + ', ' + 
'''' + convert(varchar, GETDATE(), 120) + '''' as strSQL 
from cmnt_questionresult_work cqw, questionform qf, 
scheduledmailing scm, Dispositions_view dv 
where cqw.Questionform_ID = qf.QUESTIONFORM_ID and 
qf.SENTMAIL_ID = scm.SENTMAIL_ID and 
dv.MNCMValue = cqw.FinalDisposition and 
cqw.SurveyType_ID = 4 


While (select COUNT(*) from #UpdateDispSQL) > 0 
begin 
select top 1 @SQL = strSQL from #UpdateDispSQL 
exec (@SQL) 
delete from #UpdateDispSQL where strsql = @SQL 

end 

/************************************************************************************************/ 

insert into drm_tracktimes select getdate(), 'Update skip questions' 

declare @loopcnt int  
set @loopcnt = 0  

--Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
declare @invskipcnt int  
set @invskipcnt = 0  

-- Modified 01/03/2013 DRH changed @work to #work plus index

SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id 
--FROM @WORK             
FROM #WORK   
ORDER BY questionform_id, sampleunit_id, skip_id 

-- Update skipped qstncores while we have work to process 

-- Modified 01/03/2013 DRH changed @work to #work plus index
--WHILE (SELECT COUNT(*) FROM @work) > 0                
WHILE (SELECT COUNT(*) FROM #WORK) > 0
BEGIN 

   set @loopcnt = @loopcnt + 1     

--print 'questionform_ID = ' + cast(@qf as varchar(10)) 
--print 'Sampleunit_ID = ' + cast(@su as varchar(10)) 
--print '@skip = ' + cast(@sk as varchar(10)) 
--print '@svy = ' + cast(@svy as varchar(10)) 
--print '@bitUpdate = ' + cast(@bitUpdate as varchar(10)) 

--SkipPatternWork: 
IF @bitUpdate = 1 
BEGIN 

--print 'standard skip update' 
UPDATE qr 
-- SET Val=-7 
SET Val=VAL+10000 
FROM Cmnt_QuestionResult_Work qr, Skipqstns sq 
WHERE @qf = qr.QuestionForm_id 
AND @su = qr.SampleUnit_id 
AND @sk = Skip_id 
AND sq.QstnCore = qr.QstnCore 
AND Val NOT IN (-9,-8,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
AND Val<9000 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'Start HHCAHPS qstncore 38694 skip update'     
 end       

--print 'HHCAHPS qstncore 38694 skip update' 
UPDATE qr 
-- SET Val=-7 
SET Val=VAL+10000 
FROM Cmnt_QuestionResult_Work qr, survey_def sd, 
(Select distinct qstncore from sel_qstns where SURVEY_ID = @svy and QSTNCORE <> 38694 and NUMMARKCOUNT > 0) a 
WHERE @qf = qr.QuestionForm_id 
AND @su = qr.SampleUnit_id 
AND @sk = -1 
AND a.QstnCore = qr.QstnCore 
AND sd.SURVEY_ID = @svy 
AND Val NOT IN (-9,-8,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
AND Val<9000 
AND sd.SurveyType_id = 3 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'End HHCAHPS qstncore 38694 skip update'     
 end       

 if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'Start HHCAHPS qstncore 38726 skip update'     
 end       

--print 'HHCAHPS qstncore 38726 skip update' 
UPDATE qr 
-- SET Val=-7 
SET Val=VAL+10000 
FROM Cmnt_QuestionResult_Work qr, survey_def sd 
WHERE @qf = qr.QuestionForm_id 
AND @su = qr.SampleUnit_id 
AND @sk = -2 
AND qr.QstnCore = 38727 
AND sd.SURVEY_ID = @svy 
AND Val NOT IN (-9,-8,-6,-5) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
AND Val<9000 
AND sd.SurveyType_id = 3 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'End HHCAHPS qstncore 38726 skip update'     


 end       

END 

-- Identify the NEXT skip pattern that needs to be enforced for a questionform_id 

-- Modified 01/03/2013 DRH changed @work to #work plus index
  --DELETE FROM @work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id    
  DELETE FROM #work WHERE @qf=QuestionForm_id AND  @su=SampleUnit_id AND  @sk=Skip_id AND  @svy=Survey_id            
  --SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM @WORK ORDER BY questionform_id, sampleunit_id, skip_id     
  SELECT TOP 1 @qf=QuestionForm_id, @su=SampleUnit_id, @sk=Skip_id, @svy=Survey_id  FROM #WORK ORDER BY questionform_id, sampleunit_id, skip_id             

  if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'Start Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'     
 end       

--Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
select @invskipcnt=count(*) 
FROM Cmnt_QuestionResult_Work qr 
INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND (qr.Val=si.intResponseVal OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
inner join SkipQstns sq on si.Skip_id = sq.Skip_id 
inner join skipidentifier si2 on sq.QstnCore = si2.QstnCore and si2.Skip_id = @sk 
WHERE sd.bitEnforceSkip <> 0 
and qr.questionform_id = @qf 

-- Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop 
IF ( 
SELECT COUNT(*) 
 FROM Cmnt_QuestionResult_Work qr 
 INNER JOIN SkipIdentifier si 
 ON qr.Questionform_id = @qf 
 AND qr.sampleunit_id = @su 
 AND qr.datGenerated=si.datGenerated 
 AND qr.QstnCore=si.QstnCore 
 AND (qr.Val = si.intResponseVal 
 OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
 AND si.skip_id = @sk 
--Modified 01/31/2013 DRH - correcting logic to check to see if the current gateway question was invalidated by being skipped by another gateway question ... 
AND @invskipcnt = 0

-- 11/30/12 DRM -- Nested skip questions 
-- If any previous gateway questions include the current gateway as a skip question, 
--	and if the previous gateway was answered so as to skip the current gateway, 
-- then don't enforce skip logic on the current gateway question. 
--select count(*) 
--FROM Cmnt_QuestionResult_Work qr 
--INNER JOIN SkipIdentifier si ON qr.datGenerated=si.datGenerated AND qr.QstnCore=si.QstnCore AND (qr.Val=si.intResponseVal OR qr.Val IN (-8,-9,-6,-5)) --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
--INNER JOIN survey_def sd ON si.survey_id = sd.survey_id 
--inner join SkipQstns sq on si.Skip_id = sq.Skip_id 
--inner join skipidentifier si2 on sq.QstnCore = si2.QstnCore and si2.Skip_id = @sk 
--WHERE sd.bitEnforceSkip <> 0 
--and qr.questionform_id = @qf 
) > 0 
OR 
(SELECT 1 
FROM Cmnt_QuestionResult_Work qr, SURVEY_DEF sd 
WHERE qr.Questionform_id = @qf 
AND qr.sampleunit_id = @su 
AND qstncore = 38694 
AND val <> 1 
AND @sk = -1 
AND sd.SURVEY_ID = qr.Survey_id 
AND sd.SurveyType_id = 3 
) > 0 
OR 
(SELECT 1 
FROM Cmnt_QuestionResult_Work qr, SURVEY_DEF sd 
WHERE qr.Questionform_id = @qf 
AND qr.sampleunit_id = @su 
AND qstncore = 38726 
AND val <> 1 
AND @sk = -2 
AND sd.SURVEY_ID = qr.Survey_id 
AND sd.SurveyType_id = 3 
) > 0 
SET @bitUpdate = 1 
ELSE 
SET @bitUpdate = 0 

if @loopcnt < 25  
 begin  
    insert into drm_tracktimes select getdate(), 'End Check to see if next skip pattern gateway is still qualifies as a valid skip pattern gateway after last Update loop'     


 end       

END 

insert into drm_tracktimes select getdate(), 'End SP_Phase3_QuestionResult_For_Extract' 

-- Modified 01/03/2013 DRH changed @work to #work plus index
DROP TABLE #work                

SET NOCOUNT OFF 
SET TRANSACTION ISOLATION LEVEL READ COMMITTED



GO
