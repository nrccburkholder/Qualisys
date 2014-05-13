---------------------------------------------------------
--Drop Existing Procedures
---------------------------------------------------------
IF OBJECT_ID(N'[dbo].[DCL_SelectOneClickDefinition]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_SelectOneClickDefinition]
IF OBJECT_ID(N'[dbo].[DCL_SelectAllOneClickDefinitions]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_SelectAllOneClickDefinitions]
IF OBJECT_ID(N'[dbo].[DCL_SelectOneClickDefinitionsByOneClickType]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_SelectOneClickDefinitionsByOneClickType]
IF OBJECT_ID(N'[dbo].[DCL_InsertOneClickDefinition]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_InsertOneClickDefinition]
IF OBJECT_ID(N'[dbo].[DCL_UpdateOneClickDefinition]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_UpdateOneClickDefinition]
IF OBJECT_ID(N'[dbo].[DCL_DeleteOneClickDefinition]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_DeleteOneClickDefinition]
IF OBJECT_ID(N'[dbo].[DCL_DeleteOneClickDefinitionsByOneClickType]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_DeleteOneClickDefinitionsByOneClickType]

IF OBJECT_ID(N'[dbo].[DCL_SelectOneClickReport]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_SelectOneClickReport]
IF OBJECT_ID(N'[dbo].[DCL_SelectAllOneClickReports]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_SelectAllOneClickReports]
IF OBJECT_ID(N'[dbo].[DCL_InsertOneClickReport]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_InsertOneClickReport]
IF OBJECT_ID(N'[dbo].[DCL_UpdateOneClickReport]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_UpdateOneClickReport]
IF OBJECT_ID(N'[dbo].[DCL_DeleteOneClickReport]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_DeleteOneClickReport]

IF OBJECT_ID(N'[dbo].[DCL_SelectOneClickType]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_SelectOneClickType]
IF OBJECT_ID(N'[dbo].[DCL_SelectAllOneClickTypes]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_SelectAllOneClickTypes]
IF OBJECT_ID(N'[dbo].[DCL_InsertOneClickType]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_InsertOneClickType]
IF OBJECT_ID(N'[dbo].[DCL_UpdateOneClickType]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_UpdateOneClickType]
IF OBJECT_ID(N'[dbo].[DCL_DeleteOneClickType]') IS NOT NULL DROP PROCEDURE [dbo].[DCL_DeleteOneClickType]

GO

---------------------------------------------------------------------------------------
--DCL_SelectOneClickDefinition
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectOneClickDefinition]
@OneClickDefinition_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickDefinition_id, OneClickType_id, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM [dbo].OneClickDefinitions
WHERE OneClickDefinition_id = @OneClickDefinition_id

GO
---------------------------------------------------------------------------------------
--DCL_SelectOneClickDefinitionsByOneClickType
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectOneClickDefinitionsByOneClickType]
@OneClickType_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickDefinition_id, OneClickType_id, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM [dbo].OneClickDefinitions
WHERE OneClickType_id = @OneClickType_id
ORDER BY intOrder

GO
---------------------------------------------------------------------------------------
--DCL_SelectAllOneClickDefinitions
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectAllOneClickDefinitions]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickDefinition_id, OneClickType_id, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder
FROM [dbo].OneClickDefinitions
ORDER BY OneClickType_id, intOrder

GO
---------------------------------------------------------------------------------------
--DCL_InsertOneClickDefinition
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_InsertOneClickDefinition]
@OneClickType_id INT,
@strCategory_Nm VARCHAR(100),
@strOneClickReport_Nm VARCHAR(100),
@strOneClickReport_Dsc VARCHAR(255),
@Report_id INT,
@intOrder INT
AS

SET NOCOUNT ON

INSERT INTO [dbo].OneClickDefinitions (OneClickType_id, strCategory_Nm, strOneClickReport_Nm, strOneClickReport_Dsc, Report_id, intOrder)
VALUES (@OneClickType_id, @strCategory_Nm, @strOneClickReport_Nm, @strOneClickReport_Dsc, @Report_id, @intOrder)

SELECT SCOPE_IDENTITY()
GO
---------------------------------------------------------------------------------------
--DCL_UpdateOneClickDefinition
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_UpdateOneClickDefinition]
@OneClickDefinition_id INT,
@OneClickType_id INT,
@strCategory_Nm VARCHAR(100),
@strOneClickReport_Nm VARCHAR(100),
@strOneClickReport_Dsc VARCHAR(255),
@Report_id INT,
@intOrder INT
AS

SET NOCOUNT ON

UPDATE [dbo].OneClickDefinitions SET
	OneClickType_id = @OneClickType_id,
	strCategory_Nm = @strCategory_Nm,
	strOneClickReport_Nm = @strOneClickReport_Nm,
	strOneClickReport_Dsc = @strOneClickReport_Dsc,
	Report_id = @Report_id,
	intOrder = @intOrder
WHERE OneClickDefinition_id = @OneClickDefinition_id

GO
---------------------------------------------------------------------------------------
--DCL_DeleteOneClickDefinition
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_DeleteOneClickDefinition]
@OneClickDefinition_id INT
AS

SET NOCOUNT ON

DELETE [dbo].OneClickDefinitions
WHERE OneClickDefinition_id = @OneClickDefinition_id

GO
---------------------------------------------------------------------------------------
--DCL_DeleteOneClickDefinitionsByOneClickType
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_DeleteOneClickDefinitionsByOneClickType]
@OneClickType_id INT
AS

SET NOCOUNT ON

DELETE [dbo].OneClickDefinitions
WHERE OneClickType_id = @OneClickType_id

GO
---------------------------------------------------------------------------------------
--DCL_SelectOneClickReport
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectOneClickReport]
@OneClickReport_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickReport_id, Clientuser_id, strCategory_nm, strOneClickReport_nm, strOneClickReport_dsc, Report_id, intOrder
FROM [dbo].OneClickReport
WHERE OneClickReport_id = @OneClickReport_id

GO
---------------------------------------------------------------------------------------
--DCL_SelectOneClickReportsByClientUserId
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectOneClickReportsByClientUserId]
@ClientUser_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickReport_id, Clientuser_id, strCategory_nm, strOneClickReport_nm, strOneClickReport_dsc, Report_id, intOrder
FROM [dbo].OneClickReport
WHERE Clientuser_id = @ClientUser_id

GO
---------------------------------------------------------------------------------------
--DCL_SelectAllOneClickReports
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectAllOneClickReports]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickReport_id, Clientuser_id, strCategory_nm, strOneClickReport_nm, strOneClickReport_dsc, Report_id, intOrder
FROM [dbo].OneClickReport

GO
---------------------------------------------------------------------------------------
--DCL_InsertOneClickReport
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_InsertOneClickReport]
@Clientuser_id INT,
@strCategory_nm VARCHAR(100),
@strOneClickReport_nm VARCHAR(100),
@strOneClickReport_dsc VARCHAR(255),
@Report_id INT,
@intOrder INT
AS

SET NOCOUNT ON

INSERT INTO [dbo].OneClickReport (Clientuser_id, strCategory_nm, strOneClickReport_nm, strOneClickReport_dsc, Report_id, intOrder)
VALUES (@Clientuser_id, @strCategory_nm, @strOneClickReport_nm, @strOneClickReport_dsc, @Report_id, @intOrder)

SELECT SCOPE_IDENTITY()
GO
---------------------------------------------------------------------------------------
--DCL_UpdateOneClickReport
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_UpdateOneClickReport]
@OneClickReport_id INT,
@Clientuser_id INT,
@strCategory_nm VARCHAR(100),
@strOneClickReport_nm VARCHAR(100),
@strOneClickReport_dsc VARCHAR(255),
@Report_id INT,
@intOrder INT
AS

SET NOCOUNT ON

UPDATE [dbo].OneClickReport SET
	Clientuser_id = @Clientuser_id,
	strCategory_nm = @strCategory_nm,
	strOneClickReport_nm = @strOneClickReport_nm,
	strOneClickReport_dsc = @strOneClickReport_dsc,
	Report_id = @Report_id,
	intOrder = @intOrder
WHERE OneClickReport_id = @OneClickReport_id

GO
---------------------------------------------------------------------------------------
--DCL_DeleteOneClickReport
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_DeleteOneClickReport]
@OneClickReport_id INT
AS

SET NOCOUNT ON

DELETE [dbo].OneClickReport
WHERE OneClickReport_id = @OneClickReport_id

GO
---------------------------------------------------------------------------------------
--DCL_SelectOneClickType
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectOneClickType]
@OneClickType_id INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickType_id, strOneClickType_Nm
FROM [dbo].OneClickTypes
WHERE OneClickType_id = @OneClickType_id

GO
---------------------------------------------------------------------------------------
--DCL_SelectAllOneClickTypes
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_SelectAllOneClickTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT OneClickType_id, strOneClickType_Nm
FROM [dbo].OneClickTypes

GO
---------------------------------------------------------------------------------------
--DCL_InsertOneClickType
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_InsertOneClickType]
@strOneClickType_Nm VARCHAR(100)
AS

SET NOCOUNT ON

INSERT INTO [dbo].OneClickTypes (strOneClickType_Nm)
VALUES (@strOneClickType_Nm)

SELECT SCOPE_IDENTITY()
GO
---------------------------------------------------------------------------------------
--DCL_UpdateOneClickType
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_UpdateOneClickType]
@OneClickType_id INT,
@strOneClickType_Nm VARCHAR(100)
AS

SET NOCOUNT ON

UPDATE [dbo].OneClickTypes SET
	strOneClickType_Nm = @strOneClickType_Nm
WHERE OneClickType_id = @OneClickType_id

GO
---------------------------------------------------------------------------------------
--DCL_DeleteOneClickType
---------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DCL_DeleteOneClickType]
@OneClickType_id INT
AS

SET NOCOUNT ON

DELETE [dbo].OneClickTypes
WHERE OneClickType_id = @OneClickType_id

GO
---------------------------------------------------------------------------------------
--[DCL_SelectAllStudyTables]
---------------------------------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     dataset representing all of the study data tables that exist for the study ID 	 */
/*                       										 */  
/* Date Created:  7/31/2006                  								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
create PROCEDURE [dbo].[DCL_SelectAllStudyTables]
@StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Table_id, strTable_nm, strTable_dsc, Study_id, 0 IsView
FROM MetaTable
WHERE Study_id = @StudyId
UNION
SELECT 0, Table_Name, 'Combined view of all study tables', @StudyId, 1
FROM Information_Schema.Tables
WHERE Table_Schema = 's' + CONVERT(VARCHAR, @StudyId)
AND Table_Name = 'Big_Table_View'
AND Table_Type = 'VIEW'
ORDER BY 2


SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  


set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

--------------------------------------------------------------------------------------
--[DCL_SelectStudyTable]
---------------------------------------------------------------------------------------


/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     dataset representing the study data tables for the tableId 	 */
/*                       										 */  
/* Date Created:  7/31/2006                 								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE [dbo].[DCL_SelectStudyTable]
@TableId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Table_id, strTable_nm, strTable_dsc, Study_id, 0 IsView
FROM MetaTable
WHERE Table_id = @TableId


SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF  
GO
---------------------------------------------------------------------------------------
--[DCL_SelectStudyTableColumn]
---------------------------------------------------------------------------------------

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


/*
Business Purpose: 

This procedure is used to support the Qualisys Class Library.  It returns a single
dataset representing field that exists for the specified table and field d

Created:  07/31/2006 by DC

Modified:
*/    
CREATE PROCEDURE [dbo].[DCL_SelectStudyTableColumn]  
@TableId INT,  
@FieldId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
 SELECT ms.Study_id, mt.Table_id, mf.Field_id, mf.strField_nm, mf.strFieldDataType, mf.strField_DSC, 
     mf.intFieldLength, ms.bitAvailableFilter, ms.strCustomFieldName,
	 ms.bitCalculated, ms.strFormula
 FROM metafield mf, metastructure ms, metatable mt
 WHERE mf.field_id = ms.field_id 
	AND ms.table_id=mt.table_id
	AND ms.Table_id=@TableId  
	AND ms.Field_id=@FieldID

   
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF   

set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO

---------------------------------------------------------------------------------------
--[DCL_SelectStudyTableColumns]
---------------------------------------------------------------------------------------


/*
Business Purpose: 

This procedure is used to support the Qualisys Class Library.  It returns a single
dataset representing fields that exist in the specifed study data table

Created:  7/31/2006 by DC

Modified:
*/    
CREATE PROCEDURE [dbo].[DCL_SelectStudyTableColumns]  
@StudyId INT,  
@TableId INT  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
SELECT ms.Study_id, mt.Table_id, mf.Field_id, mf.strField_nm, mf.strFieldDataType, mf.strField_DSC, 
 mf.intFieldLength, ms.bitAvailableFilter, ms.strCustomFieldName,
 ms.bitCalculated, ms.strFormula
FROM metafield mf, metastructure ms, metatable mt
WHERE mf.field_id = ms.field_id 
AND ms.table_id=mt.table_id
AND ms.Table_id=@TableId  
AND ms.Study_id=@StudyId
ORDER BY ms.bitKeyField_FLG DESC, strField_nm  
 
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF   

GO

---------------------------------------------------------------------------------------
--[DCL_UpdateStudyTableColumn]
---------------------------------------------------------------------------------------
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


/*
Business Purpose: 

This procedure is used to update the metastructure table.  It is used when adding eReports filters.

Created:  7/31/2006 by DC

Modified:
*/    
CREATE PROCEDURE [dbo].[DCL_UpdateStudyTableColumn]  
@StudyId INT,  
@TableId INT,
@FieldId INT,
@customName varchar(42),
@isAvailableFilter bit,
@isCalculated bit,
@formula varchar(5000)  
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED    
SET NOCOUNT ON    
  
IF @isCalculated <>1 
BEGIN
	Update metastructure
	SET bitAvailableFilter=@isAvailableFilter,
		strCustomFieldName=@customName
	 WHERE field_id = @fieldid 
		AND Table_id=@TableId  
		AND Study_id=@StudyId
END
--ELSE
--BEGIN
--	--CALL SP to Add Calculated Field
--END

  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED    
SET NOCOUNT OFF   
GO
/***************************************************************************/
GO
CREATE PROCEDURE DCL_SelectCommentFiltersByGroupId
@GroupId INT
AS

SELECT Field_id, [User_id], strFieldLabel, bitGeneral_Display, bitGeneral_Export, bitSA_Display, bitSA_Export, bitCommentFilter
FROM CommentFilters
WHERE [User_id]=@GroupId
GO
/***************************************************************************/
GO
CREATE PROCEDURE DCL_InsertCommentFilter
@FieldId INT,
@GroupId INT,
@Name VARCHAR(20),
@bitGeneralDisplay BIT,
@bitGeneralExport BIT,
@bitSADisplay BIT,
@bitSAExport BIT,
@bitCommentFilter BIT
AS

INSERT INTO CommentFilters(Field_id, [User_id], strFieldLabel, bitGeneral_Display, bitGeneral_Export, bitSA_Display, bitSA_Export, bitCommentFilter)
VALUES (@FieldId, @GroupId, @Name, @bitGeneralDisplay, @bitGeneralExport, @bitSADisplay, @bitSAExport, @bitCommentFilter)

GO
/***************************************************************************/
GO
CREATE PROCEDURE DCL_UpdateCommentFilter
@FieldId INT,
@GroupId INT,
@Name VARCHAR(20),
@bitGeneralDisplay BIT,
@bitGeneralExport BIT,
@bitSADisplay BIT,
@bitSAExport BIT,
@bitCommentFilter BIT
AS

UPDATE CommentFilters
SET strFieldLabel=@Name,
	bitGeneral_Display=@bitGeneralDisplay,
	bitGeneral_Export=@bitGeneralExport,
	bitSA_Display=@bitSADisplay,
	bitSA_Export=@bitSAExport,
	bitCommentFilter=@bitCommentFilter
WHERE Field_id=@FieldId
AND [User_id]=@GroupId
GO
/***************************************************************************/
GO
CREATE PROCEDURE DCL_DeleteCommentFilter
@FieldId INT,
@GroupId INT
AS

DELETE CommentFilters
WHERE Field_id=@FieldId
AND [User_id]=@GroupId

GO
/***************************************************************************/
GO
CREATE PROCEDURE dbo.DCL_ValidateStudyTableColumnFormula
  @Study_id int, @strFormula varchar(5000)
as
declare @SQL varchar(8000)

-- remove excess white-space from @strFormula
set @strFormula=replace(@strFormula,char( 9),' ')
set @strFormula=replace(@strFormula,char(10),' ')
set @strFormula=replace(@strFormula,char(13),' ')
set @strFormula=ltrim(rtrim(@strFormula))
while charindex('  ',@strFormula)>0
	set @strFormula = replace(@strFormula,'  ',' ')

-- check formula syntax
set @SQL = 'select top 0 '+@strFormula+' from s'+convert(varchar,@study_id)+'.big_table_view'
exec (@SQL)

GO
/***************************************************************************/
GO
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE dbo.DCL_NewCalculatedMetafield
  @Study_id int, @strField_nm varchar(20), @strDescription varchar(80), @strDisplay_nm varchar(42), @strFormula varchar(5000), @OverRideFlag bit
as
set nocount on
SET ARITHABORT ON  
declare @field_id int, @SQL varchar(8000), @study varchar(5), @Override varchar(10),
		@table_id int

select @study=convert(varchar,@study_id)
declare @warnings table(message varchar(1000))

If @OverRideFlag = 1 Set @override = 'Override'
else Set @override = 'x'

-- remove excess white-space from @strFormula
set @strFormula=replace(@strFormula,char( 9),' ')
set @strFormula=replace(@strFormula,char(10),' ')
set @strFormula=replace(@strFormula,char(13),' ')
set @strFormula=ltrim(rtrim(@strFormula))
while charindex('  ',@strFormula)>0
	set @strFormula = replace(@strFormula,'  ',' ')

-- check formula syntax
set @SQL = 'select top 0 '+@strFormula+' as test into #test from s'+@study+'.big_table_view'
PRINT @SQL
exec (@SQL)
if @@error > 0 
begin
	return
end

set nocount on 

select @field_id=Field_id
from metafield
where replace(strFormulaDefault,' ','')=replace(@strFormula,' ','')
and strField_nm=@strField_nm

if @field_id is null -- that field/formula combination doesn't already exist.
begin
	select @field_id=Field_id, @strField_nm=isnull(strField_nm,@strField_nm)
	from metafield
	where replace(strFormulaDefault,' ','')=replace(@strFormula,' ','')
	if @field_id is not null
		insert into @warnings (message) values ('That formula already exists.  Using field name "'+@strField_nm+'" instead.  The field will still display as "'+@strDisplay_nm+'"')
end

if @field_id is null -- the formula doesn't already exist, even under a different field name
begin
	-- if the field already exists, we must be dealing with a non-standard formula for that field
	select @field_id=Field_id
	from metafield
	where strField_nm=@strField_nm

	if @field_id is null -- this must really be a brand-new field
	begin
		-- find first unused metafield.field_id
		create table #FindFieldID (FF_id int identity(1,1), field_id int)
		insert into #FindFieldID (field_id) select field_id from metafield where field_id>0 order by field_id
		select @field_id=min(ff_id) from #findfieldid where ff_id <> field_id
		drop table #FindFieldID

		insert into Metafield (field_id, strField_nm, strField_dsc, strFieldDataType, intFieldLength, bitAvailableFilterDefault, bitCalculatedDefault, strFormulaDefault)
		values (@field_id, @strField_nm, @strDescription, 'S', 42, 0, 1, @strFormula)
	end

end

if exists (select * from metastructure where study_id=@study_id and field_id=@field_id and bitCalculated=0)
begin
	insert into @warnings (message) values ('Study ' + @study+ ' already uses '+@strField_nm+' and it''s not a computed field.  No changes made.')
	return
end

create table #tables1 (strTable_nm varchar(100))

if exists (select * from metastructure where study_id=@study_id and field_id=@field_id and bitCalculated=1)
begin
	if @override <> 'Override'
	begin
		insert into @warnings (message) values ('Study ' + @study+ ' already has a calculated "'+@strField_nm+'" field.  Use ''Override'' parameter to allow a change.')
		return
	end
	insert into @warnings (message) values ('Study ' + @study+ ' already has a calculated "'+@strField_nm+'" field, which is being overridden with the new formula.')

	update MetaStructure
	set strFormula=@strFormula, strCustomFieldName=@strDisplay_nm
	where study_id=@study_id and Field_id=@field_id

	SELECT @table_id=min(Table_id)
	FROM metastructure 
	where study_id=@study_id and Field_id=@field_id and bitCalculated=1
			
	exec ('drop view s'+@study+'.big_table_view')

	insert into #tables1
	select su.name+'.'+so.name+'.'+si.name as strTable_nm
	from sysobjects so, sysusers su, syscolumns sc, sysindexes si
	where su.uid=so.uid
	and so.id=sc.id
	and so.id=si.id
	and su.name = 's' + @study
	and so.xtype='u'
	and so.name like 'big_table%'
	and sc.name = @strField_nm
	and (si.name = 'idx'+@strField_nm OR si.name = 'ind'+@strField_nm)

	select top 1 @SQL=strTable_nm from #tables1
	while @@rowcount>0
	begin
		--PRINT 'drop index '+@SQL
		exec ('drop index '+@SQL)
		delete from #tables1 where strTable_nm=@SQL
		select top 1 @SQL=strTable_nm from #tables1
	end	

	delete ikc
	FROM indexkey ik, IndexKeyColumns ikc 
	WHERE ik.Study_id = @study AND 
	strTable_nm = 'big_table' AND 
	ik.IndexKey_id = ikc.IndexKey_id AND 
	strColumn_nm = @strField_nm

	insert into #tables1
	select su.name+'.'+so.name as strTable_nm
	from sysobjects so, sysusers su, syscolumns sc
	where su.uid=so.uid
	and so.id=sc.id
	and su.name = 's' + @study
	and so.xtype='u'
	and so.name like 'big_table%'
	and sc.name = @strField_nm

	select top 1 @SQL=strTable_nm from #tables1
	while @@rowcount>0
	begin
		--PRINT 'alter table '+@SQL+' drop column '+@strField_nm
		exec ('alter table '+@SQL+' drop column '+@strField_nm)
		delete from #tables1 where strTable_nm=@SQL
		select top 1 @SQL=strTable_nm from #tables1
	end	
end
else
BEGIN
	SELECT @table_id=min(Table_id)
	FROM metatable 
	where study_id=@study_id

	insert into metastructure (Study_id, Table_id, Field_id, bitKeyField_FLG, bitUserField_FLG, bitMatchField_FLG, bitPostedField_FLG, bitAvailableFilter, strCustomFieldName, bitCalculated, strFormula)
	values (@Study, @table_id, @field_id, 0, 1, 0, 1, 1, @strDisplay_nm, 1, @strFormula)
END

insert into #tables1
select su.name+'.'+so.name as strTable_nm
from sysobjects so, sysusers su
where su.uid=so.uid
and su.name = 's' + @study
and so.xtype='u'
and so.name like 'big_table%'

select top 1 @SQL=strTable_nm from #tables1
while @@rowcount>0
begin
	--PRINT 'alter table '+@SQL+' add '+@strField_nm+' as '+@strFormula
	exec ('alter table '+@SQL+' add '+@strField_nm+' as '+@strFormula)

	delete from #tables1 where strTable_nm=@SQL
	select top 1 @SQL=strTable_nm from #tables1
end

exec sp_ideas_checkforindex @study, 'big_table', @strField_nm

set @study='s'+@study

--SET @sql='exec sp_DBM_MakeView '''+@study+''', ''Big_Table'''
--
--EXEC (@sql)

Select @table_id table_id, @field_id field_id
Select message from @warnings 

set nocount off
SET ARITHABORT off 
GO
---------------------------------------------------------------------------------------
--[Auth_DeleteGroup]
---------------------------------------------------------------------------------------
GO
CREATE PROCEDURE [dbo].Auth_DeleteGroup
@GroupId INT
AS

DELETE UserAccess WHERE [User_id] = @GroupId
DELETE UserAccessWA WHERE [User_id] = @GroupId
DELETE CommentFilters WHERE [User_id] = @GroupId
GO