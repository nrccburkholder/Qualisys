/*
S68 RTP-1352 Break out RTPhoenix-ProcessStudyOwnedTables.sql

Chris Burkholder

2/14/2017

CREATE PROCEDURE RTPhoenix.ProcessStudyOwnedTables
--DROP PROCEDURE RTPhoenix.ProcessStudyOwnedTables
*/
Use [QP_Prod]
GO

CREATE PROCEDURE [RTPhoenix].[ProcessStudyOwnedTables]
	@TemplateJob_ID int
AS
begin
	  declare @TemplateLogEntryInfo int
	  declare @TemplateLogEntryWarning int
	  declare @TemplateLogEntryError int

	  select @TemplateLogEntryInfo = TemplateLogEntryType_ID 
	  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'INFORMATIONAL'

	  select @TemplateLogEntryWarning = TemplateLogEntryType_ID 
	  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'WARNING'

	  select @TemplateLogEntryError = TemplateLogEntryType_ID 
	  from RTPhoenix.TemplateLogEntryType where TemplateLogEntryTypeName = 'ERROR'

declare @user varchar(40) 
declare @TargetStudy_id int 
declare @Template_ID int

select @TargetStudy_id = TargetStudy_id, 
	@Template_id = Template_id, 
	@user = LoggedBy  
from RTPhoenix.TemplateJob 
where @TemplateJob_id = TemplateJob_id 

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID],[TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@TemplateJob_ID, @Template_ID, @TemplateLogEntryInfo,'Begin Study Owned Schema Table Process for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

declare @Study varchar(10) = 'S' + convert(varchar, @TargetStudy_id)

------------------For each of QP_Prod and QP_Load, create [study-owner]

--QP_Load (SQL Server 2000)

--select * from [QLoader].[QP_Load].dbo.sysusers where name = 'SSSSS' --schema exists

exec ('IF NOT EXISTS (SELECT * FROM Master.dbo.sysLogins WHERE name='''+@Study+
		''') exec sp_addlogin N'''+@Study+''', null, ''master'', ''us_english'' ') 
		at [QLoader];

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo,  convert(varchar,@@ROWCOUNT)+' Study Owned Schema added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

exec ('if not exists (select * from dbo.sysusers where name='''+@Study+
		''' and uid < 16382)	EXEC sp_grantdbaccess N'''+@Study+''' ') 
		at [QLoader];

--QP_Prod (SQL Server 2008)

exec ('IF NOT EXISTS (SELECT * FROM sys.schemas where name = '''+@Study+
		''') BEGIN EXEC sp_executesql N''Create Schema '+@Study+''' END');

INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
     VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, convert(varchar,@@ROWCOUNT)+' Study Owned Schema added on QP_Prod for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

------------------For each Table Name [Table] according to MetaTable: 
--	create QP_Load.[study-owner].[Table]_Load
--	create QP_Prod.[study-owner].[Table]_Load
--	create QP_Prod.[study-owner].[Table]
------------------For each Table instance [Instance]:
--	set up with <DataFile_id int NOT NULL>
--	set up with <DF_id int NOT NULL>

DECLARE @TableId int = 0
declare @Table varchar(20) 
WHILE(1 = 1) --TABLE LOOP
BEGIN
	SELECT @TableId = MIN(Table_ID)
		FROM dbo.MetaTable WHERE Table_ID > @TableId and Study_id = @TargetStudy_id
	IF @TableId IS NULL 
		BREAK
	SELECT @Table = strTable_Nm 
		FROM dbo.METATABLE where Table_ID = @TableId

--QP_Load (SQL Server 2000)
--select * from [QLoader].[QP_Load].dbo.sysobjects where uid = 4192 and name = 'Encounter' --table exists
--select * from [QLoader].[QP_Load].dbo.syscolumns where id = 1780931127 --field exists

	exec ('if not exists (select * from dbo.sysobjects o inner join dbo.sysusers u '+
			'on u.uid = o.uid where u.name = '''+@Study+''' and o.name = '''+@Table+
			'_LOAD'') create table qp_Load.'+@Study+'.'+@Table+
			'_LOAD (DataFile_id int NOT NULL, DF_id int NOT NULL)') 
			at [QLoader];

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, @Table+'_Load Study Owned Table added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

--QP_Prod

--select * from sys.schemas where name = 'S5839'
--select * from sys.tables where schema_id = 52

	exec ('if not exists (select * from sys.tables t inner join sys.schemas s '+
			'on t.schema_id = s.schema_id where s.name = '''+@Study+''' and t.name = '''+@Table+
			'_LOAD'') create table '+@Study+'.'+@Table+
			'_LOAD (DataFile_id int NOT NULL, DF_id int NOT NULL)') 

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, @Table+'_Load Study Owned Table added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	exec ('if not exists (select * from sys.tables t inner join sys.schemas s '+
			'on t.schema_id = s.schema_id where s.name = '''+@Study+''' and t.name = '''+@Table+
			''') create table '+@Study+'.'+@Table+
			' (DataFile_id int NOT NULL, DF_id int NOT NULL)') 

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, @Table+' Study Owned Table added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

--For each Table instance [Instance]:
--  add all fields mapped to Table according to MetaStructure

	DECLARE @FieldId int = 0
	declare @Field varchar(20), @FieldType char, @FieldLength int, @IsFieldKey bit
	WHILE(1 = 1) --FIELD LOOP
	BEGIN
		SELECT @FieldId = MIN(ms.Field_ID)
			FROM dbo.MetaField mf inner join 
				dbo.MetaStructure ms on mf.FIELD_ID = ms.FIELD_ID inner join
				dbo.MetaTable mt ON ms.TABLE_ID = mt.TABLE_ID
			WHERE ms.Field_ID > @FieldId and 
				ms.Table_ID = @TableId and 
				Study_id = @TargetStudy_id
		IF @FieldId IS NULL 
			BREAK
		SELECT @Field = strField_Nm, 
				@FieldType = mf.STRFIELDDATATYPE,
				@FieldLength = mf.INTFIELDLENGTH, 
				@IsFieldKey = ms.BITKEYFIELD_FLG
			FROM dbo.MetaField mf inner join 
				dbo.MetaStructure ms on mf.FIELD_ID = ms.FIELD_ID inner join
				dbo.MetaTable mt ON ms.TABLE_ID = mt.TABLE_ID
			WHERE ms.Field_ID = @FieldId 

		Declare @FieldTypeString varchar(20), @FieldLengthString varchar(10), @ConstraintString varchar(200)

		Select @FieldLengthString = Case When @FieldLength is not null and @FieldType = 'S'
			Then '(' + convert(varchar, @FieldLength) + ')' Else '' 
		End
		Select @FieldTypeString = Case When @FieldType = 'S' then 'Varchar'
			When @FieldType = 'D' then 'DateTime' 
			When @FieldType = 'I' then 'Int'
			Else 'Unknown'
		End
		Select @ConstraintString = Case When @IsFieldKey = 1 
			Then ' IDENTITY (1,1) NOT NULL CONSTRAINT PK_'+@Study+@Table+
			' PRIMARY KEY NONCLUSTERED'
			Else ''
		End

--QP_Prod

--select * from sys.schemas where name = 'S5839'
--select * from sys.tables where schema_id = 52
--select * from sys.columns where object_id = 569209228

		Exec('IF NOT EXISTS(select * from sys.columns c inner join'+
			' sys.tables t on t.object_id = c.object_id inner join'+
			' sys.schemas s on s.schema_id = t.schema_id'
			+' where s.name = '''+@Study+''' and t.name = '''+@Table+''' and c.name = '''+@Field+
			''') ALTER TABLE ' + @study + '.' + @Table+
			' ADD ' + @Field + ' ' + @FieldTypeString + @FieldLengthString+
			@ConstraintString)

			IF (@IsFieldKey = 1)	
				INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
						VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, @Table+'.'+@Field+' Key Field added on QP_Prod for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

		Select @ConstraintString = REPLACE(@ConstraintString, @Table, @Table+'_Load')
			
		Exec('IF NOT EXISTS(select * from sys.columns c inner join'+
			' sys.tables t on t.object_id = c.object_id inner join'+
			' sys.schemas s on s.schema_id = t.schema_id'
			+' where s.name = '''+@Study+''' and t.name = '''+@Table+'_Load'' and c.name = '''+@Field+
			''') ALTER TABLE ' + @study + '.' + @Table+'_Load'+
			' ADD ' + @Field + ' ' + @FieldTypeString + @FieldLengthString+
			@ConstraintString)

			IF (@IsFieldKey = 1)	
				INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
						VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, @Table+'_Load.'+@Field+' Key Field added on QP_Prod for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

--QP_Load (SQL Server 2000)
--select * from [QLoader].[QP_Load].dbo.sysusers where name = 'S5841' --schema exists
--select * from [QLoader].[QP_Load].dbo.sysobjects where uid = 4193 and name = 'Encounter_Load' --table exists
--select * from [QLoader].[QP_Load].dbo.syscolumns where id = 2052932096 --field exists

		Exec('IF NOT EXISTS(select * from syscolumns c inner join'+
			' sysobjects o on o.id = c.id inner join'+
			' sysusers u on u.uid = o.uid'
			+' where u.name = '''+@Study+''' and o.name = '''+@Table+'_Load'' and c.name = '''+@Field+
			''') ALTER TABLE ' + @study + '.' + @Table+'_Load'+
			' ADD ' + @Field + ' ' + @FieldTypeString + @FieldLengthString+
			@ConstraintString)
		At [QLoader]

			IF (@IsFieldKey = 1)	
				INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
						VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, @Table+'_Load.'+@Field+' Key Field added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	END --FIELD LOOP

		INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
				VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, @Field+' was last Field added on QPProd/QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

--For QP_Load
--	add [TABLE]_LOAD INDEXes

	EXEC('if exists(SELECT * FROM sysindexes WHERE name=''IDX_'+@study+@Table+'DataFile'')'+
		' DROP INDEX '+@study+'.'+@Table+'_Load.IDX_'+@study+@Table+'DataFile')
		At [QLoader]
	EXEC('CREATE NONCLUSTERED INDEX [IDX_'+@study+@Table+'DataFile] ON '+@study+'.'+@Table+'_Load'+
		' (	[DataFile_id] ASC,	[DF_id] ASC ) WITH FILLFACTOR = 90 ON [PRIMARY]')
		At [QLoader]

--For QP_Prod
--  add [TABLE]_LOAD INDEXes
--  add [TABLE] INDEXes

	if @Table = 'ENCOUNTER' 
	begin

		EXEC('if exists(select * from sys.indexes where name = ''ENCOUNTERpop_idI'' and object_id = OBJECT_ID('''+@study+'.Encounter''))'+
			' DROP INDEX ENCOUNTERpop_idI ON '+@study+'.ENCOUNTER')
		EXEC('CREATE NONCLUSTERED INDEX [ENCOUNTERpop_idI] ON ['+@study+'].[ENCOUNTER]'+
		'(	[pop_id] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]')

		EXEC('if exists(select * from sys.indexes where name = ''ENCOUNTERpop_idI'' and object_id = OBJECT_ID('''+@study+'.Encounter_load''))'+
			' DROP INDEX ENCOUNTERpop_idI ON '+@study+'.ENCOUNTER_load')
		EXEC('CREATE NONCLUSTERED INDEX [ENCOUNTERpop_idI] ON ['+@study+'].[ENCOUNTER_load]'+
		'(	[pop_id] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]')

		EXEC('if exists(select * from sys.indexes where name = '''+@study+'CDXENCOUNTER'' and object_id = OBJECT_ID('''+@study+'.Encounter''))'+
			' DROP INDEX '+@study+'CDXENCOUNTER ON '+@study+'.ENCOUNTER')
		EXEC('CREATE NONCLUSTERED INDEX ['+@study+'CDXENCOUNTER] ON ['+@study+'].[ENCOUNTER]'+
		'(	[Enc_Mtch] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]')

		EXEC('if exists(select * from sys.indexes where name = '''+@study+'_LOADCDXENCOUNTER'' and object_id = OBJECT_ID('''+@study+'.Encounter_load''))'+
			' DROP INDEX '+@study+'_LOADCDXENCOUNTER ON '+@study+'.ENCOUNTER_Load')
		EXEC('CREATE NONCLUSTERED INDEX ['+@study+'_LOADCDXENCOUNTER] ON ['+@study+'].[ENCOUNTER_load]'+
		'(	[Enc_Mtch] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]')

	end

	if @Table = 'POPULATION'
	begin

		EXEC('if exists(select * from sys.indexes where name = '''+@study+'CDXPOPULATION'' and object_id = OBJECT_ID('''+@study+'.Population''))'+
			' DROP INDEX '+@study+'CDXPOPULATION ON '+@study+'.POPULATION')
		EXEC('CREATE NONCLUSTERED INDEX ['+@study+'CDXPOPULATION] ON ['+@study+'].[POPULATION]'+
		'(	[Pop_Mtch] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]')

		EXEC('if exists(select * from sys.indexes where name = '''+@study+'_LOADCDXPOPULATION'' and object_id = OBJECT_ID('''+@study+'.Population_Load''))'+
			' DROP INDEX '+@study+'_LOADCDXPOPULATION ON '+@study+'.POPULATION_Load')
		EXEC('CREATE NONCLUSTERED INDEX ['+@study+'_LOADCDXPOPULATION] ON ['+@study+'].[POPULATION_load]'+
		'(	[Pop_Mtch] ASC)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]')

	end

	exec ('Select top 1 '''' as ''QP_Prod ' + @study + '.' + @table +''',* from '+@study+'.'+@table)
	exec ('Select top 1 '''' as ''QP_Prod ' + @study + '.' + @table +'_Load'',* from '+@study+'.'+@table+'_Load')
	exec ('Select top 1 '''' as ''QP_Load ' + @study + '.' + @table +'_Load'',* from '+@study+'.'+@table+'_Load')
	At [QLoader]

END --TABLE LOOP

--For QP_Prod
--	add BIG_VIEW all <TABLE><FIELD> combinations
--	add BIG_VIEW_LOAD all <TABLE><FIELD> combinations

if object_id(@study+'.BIG_VIEW', 'v') is not null
	exec ('drop view '+@study+'.BIG_VIEW')

exec ee_MakeBigView @TargetStudy_id, '', 1

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, ' Big_View added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

if object_id(@study+'.BIG_VIEW_LOAD', 'v') is not null
	exec ('drop view '+@study+'.BIG_VIEW_LOAD')

exec ee_MakeBigView @TargetStudy_id, '_LOAD', 1

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, ' Big_View_Load added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

--if object_id(@study+'.BIG_VIEW_WEB', 'v') is not null
--	exec ('drop view '+@study+'.BIG_VIEW_WEB')

exec ee_MakeBigView @TargetStudy_id, '_WEB', 0, 1 --this fails so I set this up not to execute, only to show --CJB 2/15/2017

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
			VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, ' Big_View_Web added on QP_Load for study_id '+convert(varchar,@TargetStudy_id), @user, GetDate())

	exec ('Select top 1 '''' as ''BIG_VIEW'',* from '+@study+'.BIG_VIEW')
	exec ('Select top 1 '''' as ''BIG_VIEW_LOAD'',* from '+@study+'.BIG_VIEW_LOAD')
--	exec ('Select top 1 '''' as ''BIG_VIEW_WEB'',* from '+@study+'.BIG_VIEW_WEB') --this fails so I set this up not to execute, only to show --CJB 2/15/2017

	declare @CompletedNotes varchar(255)
	SET @CompletedNotes = 'Completed Study Owned Tables for Study_id '+convert(varchar,@TargetStudy_ID)+
		' from Template_id '+convert(varchar,@Template_ID)+' via TemplateJob_id '+convert(varchar,@TemplateJob_Id)

	UPDATE [RTPhoenix].[TemplateJob]
	   SET [CompletedNotes] = @CompletedNotes
		  ,[CompletedAt] = GetDate()
	 WHERE TemplateJob_ID = @TemplateJob_ID

	INSERT INTO [RTPhoenix].[TemplateLog]([Template_ID], [TemplateJob_ID], [TemplateLogEntryType_ID], [Message] ,[LoggedBy] ,[LoggedAt])
		 VALUES (@Template_ID, @TemplateJob_ID, @TemplateLogEntryInfo, 'Completed Study Owned Tables for TemplateJob_id '+convert(varchar,@TemplateJob_ID)+
		 ', Study '+convert(varchar,@TargetStudy_id)+')', @user, GetDate())


	
end
