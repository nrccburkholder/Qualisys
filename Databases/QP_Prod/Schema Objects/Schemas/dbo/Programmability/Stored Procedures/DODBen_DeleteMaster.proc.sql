create Procedure [dbo].[DODBen_DeleteMaster]
	@study_id int
AS
declare @message varchar(8000), @FilePath varchar(255), @startSize int, @SizeChange int
set @FilePath='c:\temp\DeletionLog.txt'

set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''Begin Data Deletion'''
exec dbo.uspWriteToFile @FilePath, @message

--Calculate disk space usage so we can determine how much space is saved
CREATE TABLE #diskSpace (a INT, b INT, c INT, usedextents INT, d VARCHAR(50), e VARCHAR(1000)) 
INSERT INTO #diskSpace EXEC ('DBCC showfilestats') 

select @startSize=SUM(usedextents*64/1024)
from #diskSpace

--Build Master Table Containing All Tables to Be Worked On
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''Begin Creating Table List'''
	exec dbo.uspWriteToFile @FilePath, @message
	create table #TablesToDeleteFrom (id int PRIMARY KEY, table_name varchar(100), column_name varchar(100), hierarchyOrder int,
						indexExists bit, CompositeIndex bit, systemTable bit, ExistsinContraintBoundDelete bit,
						constraintBound bit, Exclude bit)

	INSERT INTO #TablesToDeleteFrom
	exec DODBen_CreateListOfTablesToDelete
	IF @@error<>0
	BEGIN
		RAISERROR ('Error Populating #TablesToDeleteFrom.',16,1)
		return	
	END
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''End Creating Table List'''
	exec dbo.uspWriteToFile @FilePath, @message

--Build Master Key Table that has Id values for all join columns
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''Begin Populating Key Column IDs'''
	exec dbo.uspWriteToFile @FilePath, @message
	declare @rc int
	EXEC @rc=DODBen_PopulateDeleteKeysMasterTable @study_id
	IF @RC<>0 or @@error<>0
	BEGIN
		RAISERROR ('Error Populating DeleteKeysMasterTable.',16,1)
		return	
	END
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''End Populating Key Column IDs'''
	exec dbo.uspWriteToFile @FilePath, @message

BEGIN TRANSACTION
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''Begin Deleting Constraint Bound Columns'''
	exec dbo.uspWriteToFile @FilePath, @message
	--Delete constraint bound tables (Note that a few non-Contraint bound tables are deleted in this SP)
		EXEC @rc=DODBen_DeleteConstraintBoundTables @study_id
		IF @RC<>0 or @@error<>0  
		BEGIN
			RAISERROR ('Error Deleting Constraint Bound Tables.',16,1)
			return	
		END
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''End Deleting Constraint Bound Columns'''
	exec dbo.uspWriteToFile @FilePath, @message

	--Delete all other Tables
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''Begin Deleting Non-Constraint Bound Columns'''
	exec dbo.uspWriteToFile @FilePath, @message
		declare @id int, @KeyColumnName varchar(42), @TableName varchar(42)

		SELECT TOP 1 @id=id, @KeyColumnName=column_name, @TableName=table_name
		FROM #TablesToDeleteFrom
		WHERE ExistsinContraintBoundDelete=0
			and exclude=0

		WHILE @@rowcount>0
		BEGIN
			EXEC @rc=DODBen_DeleteTable @study_id, @KeyColumnName, @TableName
			IF @RC<>0 or @@error<>0  
			BEGIN
				RAISERROR ('Error Deleting Non Constraint Bound Tables.',16,1)
				return	
			END

			Delete
			FROM #TablesToDeleteFrom
			where id=@id

			SELECT TOP 1 @id=id, @KeyColumnName=column_name, @TableName=table_name
			FROM #TablesToDeleteFrom
			WHERE ExistsinContraintBoundDelete=0
				and exclude=0
		END
	set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''End Deleting Non-Constraint Bound Columns'''
	exec dbo.uspWriteToFile @FilePath, @message
COMMIT TRANSACTION

--Drop the study Owned objects
set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''Begin Dropping Study Owned Tables'''
exec dbo.uspWriteToFile @FilePath, @message

exec DODBen_DropStudyOwnedObjects @study_id
set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''End Dropping Study Owned Tables'''
exec dbo.uspWriteToFile @FilePath, @message

DELETE
FROM DeleteKeysMasterTable
WHERE study_id=@study_id

truncate table #diskSpace
INSERT INTO #diskSpace EXEC ('DBCC showfilestats') 

select @SizeChange=@startSize -(SUM(usedextents*64/1024))
from #diskSpace

set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,'' Deletion reduced DB size by ' + convert(varchar,@SizeChange) + ' MBs'''
exec dbo.uspWriteToFile @FilePath, @message

set @message=convert(varchar,@study_id) +','+convert(varchar,getdate())+',null,null,null,null,''End Data Deletion'''
exec dbo.uspWriteToFile @FilePath, @message


