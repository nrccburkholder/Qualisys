CREATE PROCEDURE [dbo].[QCL_InsertStudy]
@STRSTUDY_NM char(10),
@STRSTUDY_DSC varchar(255),
@CLIENT_ID int,
@ADEMPLOYEE_ID int,
@DATCREATE_DT datetime,
@BITCLEANADDR bit,
@bitProperCase bit,
@Active bit
AS

DECLARE @StudyID int
DECLARE @SQL varchar(5000)
DECLARE @SchemaName varchar(10)

SET NOCOUNT ON

INSERT INTO [dbo].STUDY (STRSTUDY_NM, STRSTUDY_DSC, CLIENT_ID, ADEMPLOYEE_ID,
	DATCREATE_DT, DATCLOSE_DT, BITCLEANADDR, bitProperCase, INTPOPULATIONTABLEID,
	INTENCOUNTERTABLEID, INTPROVIDERTABLEID, BITSTUDYONGOING, BITCHECKPHON, BITMULTADDR, bitNCOA, Active)
VALUES (@STRSTUDY_NM, @STRSTUDY_DSC, @CLIENT_ID, @ADEMPLOYEE_ID,
	@DATCREATE_DT, @DATCREATE_DT, @BITCLEANADDR, @bitProperCase, -1, -1, -1, 1, 0, 0, 0, @Active)

SELECT @StudyID = SCOPE_IDENTITY()

--Create Database Schema
SET @SchemaName = 'S' + cast(@StudyID as varchar)
SET @SQL = 'CREATE SCHEMA ' + @SchemaName
EXEC(@SQL)

/*
--Create Universe Table
SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '].[Universe]'') IS NOT NULL 
	DROP TABLE ''[' + @SchemaName + '].[Universe]''
GO
CREATE TABLE ''[' + @SchemaName + '].[Universe]''(
	[Pop_id] [int] NOT NULL,
	[DQRule_id] [int] NOT NULL,
	[numRandom] [numeric](18, 0) NULL,
 CONSTRAINT [PK_UNIVERSE] PRIMARY KEY CLUSTERED 
(
	[Pop_id] ASC
)
) ON [PRIMARY]
GO'
    
EXEC(@SQL)

--Create PopFlags Table
SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '][.PopFlags]'') IS NOT NULL 
	DROP TABLE ''[' + @SchemaName + '].[PopFlags]''
GO
CREATE TABLE ''[' + @SchemaName + '].[PopFlags]''(
	[Pop_id] [int] NOT NULL,
	[Adult] [char](1) NOT NULL,
	[Sex] [char](1) NOT NULL,
	[Doc] [char](1) NOT NULL,
 CONSTRAINT [PK_POPFLAGS] PRIMARY KEY CLUSTERED 
(
	[Pop_id] ASC
)
) ON [PRIMARY]
GO'

EXEC(@SQL)

--Create UnitMembership Table
SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '][.UnitMembership]'') IS NOT NULL 
	DROP TABLE ''[' + @SchemaName + '].[UnitMembership]''
GO
CREATE TABLE ''[' + @SchemaName + '].[UnitMembership]''(
	[Pop_id] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[SelectType_cd] [char](1) NULL,
 CONSTRAINT [PK_UNITMEMBERSHIP] PRIMARY KEY CLUSTERED 
(
	[Pop_id] ASC,
	[SampleUnit_id] ASC
)
) ON [PRIMARY]
GO'

EXEC(@SQL)

--Create UniKeys Table
SET @SQL = 'IF OBJECT_ID(N''[' + @SchemaName + '][.UniKeys]'') IS NOT NULL 
	DROP TABLE ''[' + @SchemaName + '].[UniKeys]''
GO
CREATE TABLE ''[' + @SchemaName + '].[UniKeys]''(
	[SampleSet_id] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[Pop_id] [int] NOT NULL,
	[Table_id] [int] NOT NULL,
	[KeyValue] [int] NOT NULL,
 CONSTRAINT [PK_UNIKEYS] PRIMARY KEY CLUSTERED 
(
	[SampleSet_id] ASC,
	[SampleUnit_id] ASC,
	[Pop_id] ASC,
	[Table_id] ASC
)
) ON [PRIMARY]
GO'

EXEC(@SQL)

--Add additional indexes to UniKeys table
SET @SQL = 'CREATE NONCLUSTERED INDEX [IDX_Unikeys_KeyValue] ON [' + @SchemaName + '].[UniKeys]
(
	[KeyValue] ASC
)
GO
CREATE NONCLUSTERED INDEX [IDX_Unikeys_SampleSet_Table] ON [' + @SchemaName + '].[UniKeys] 
(
	[SampleSet_id] ASC,
	[Table_id] ASC
)
GO'

EXEC(@SQL)
*/

DECLARE @TableID int = 0
--Add MetaData
EXEC dbo.SDS_SaveMetaTable 0, @TableID OUTPUT, @StudyID, 'POPULATION', '', 0

DECLARE @isPII bit, @isAllowUS bit, @FieldID int, @ResultMsg varchar(100)

--Add Key Field
SET @FieldID = 0
SET @isPII = 0
SET @isAllowUS = 1
SET @ResultMsg = ''
EXEC dbo.SDS_SaveMetaStructure 0, 1, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg

--Add New Record Date Field
SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldNewRecordDate')) 
SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)
IF @isPII = 0
	SET @isAllowUS = 1
ELSE
	SET @isAllowUS = 0

SET @ResultMsg = ''
EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg

--Add New Language Code Field
SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldLanguageCode')) 
SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)
IF @isPII = 0
	SET @isAllowUS = 1
ELSE
	SET @isAllowUS = 0

SET @ResultMsg = ''
EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg

--Add New Age Field
SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldAge')) 
SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)
IF @isPII = 0
	SET @isAllowUS = 1
ELSE
	SET @isAllowUS = 0

SET @ResultMsg = ''
EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg

--Add New Gender Field
SET @FieldID = (SELECT field_id FROM MetaField WHERE INTSPECIALFIELD_CD = (SELECT numParam_Value FROM QualPro_Params WHERE strParam_Nm = 'FieldGender')) 
SET @isPII = (SELECT bitPII FROM MetaField WHERE Field_id = @FieldID)
IF @isPII = 0
	SET @isAllowUS = 1
ELSE
	SET @isAllowUS = 0

SET @ResultMsg = ''
EXEC dbo.SDS_SaveMetaStructure 0, 0, 0, 0, 0, @isPII, @isAllowUS, @TableID, @FieldID, -1, -1, '', @ResultMsg


--Update Population Table ID in Study Table
UPDATE dbo.STUDY
SET INTPOPULATIONTABLEID = @TableID
WHERE STUDY_ID = @StudyID

SELECT @StudyID

SET NOCOUNT OFF


