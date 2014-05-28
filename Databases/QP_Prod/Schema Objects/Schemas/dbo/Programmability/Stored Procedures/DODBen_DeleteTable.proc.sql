create procedure DODBen_DeleteTable
	@study_id int,
	@KeyColumnName varchar(100),
	@TableName varchar(100)
AS
declare @sql nvarchar(4000), @expectedCount int,
		@myError int, @myRowCount int,
		@myErrorMessage varchar(255)

IF OBJECT_ID(@TableName, 'U') IS NOT NULL
  Begin
	BEGIN TRANSACTION
		--Get Count of expected rows to delete
		IF @KeyColumnName='StrLithoCode'
			set @sql='Select @RECORDCNT=count(*)
					  FROM ' + @TableName + ' t, DeleteKeysMasterTable dmt
					  WHERE dmt.id=convert(int,replace(t.' + @KeyColumnName + ',''NULL'',''-99''))
							and dmt.KeyColumnName=''' + @KeyColumnName + '''
							and dmt.study_id=' + convert(varchar,@study_id)
		ELSE
			set @sql='Select @RECORDCNT=count(*)
					  FROM ' + @TableName + ' t, DeleteKeysMasterTable dmt
					  WHERE dmt.id=t.' + @KeyColumnName + '
							and dmt.KeyColumnName=''' + @KeyColumnName + '''
							and dmt.study_id=' + convert(varchar,@study_id)

		exec sp_executesql @sql,
                   N'@RECORDCNT int out', 
                   @expectedCount out
		Select @myError=@@error

		exec DODBen_InsertDeletionLogRecord @study_id, @TableName, 'Select', @expectedCount, @myError 
	    if @myError <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			Return -1
		END
		--Delete from table
		IF @KeyColumnName='StrLithoCode'
			set @sql='Delete ' + @TableName +'
					  FROM ' + @TableName + ' t, DeleteKeysMasterTable dmt
					  WHERE dmt.id=convert(int,replace(t.' + @KeyColumnName + ',''NULL'',''-99''))
							and dmt.KeyColumnName='''+ @KeyColumnName +'''
							and dmt.study_id=' + convert(varchar,@study_id)
		ELSE
			set @sql='Delete ' + @TableName +'
					  FROM ' + @TableName + ' t, DeleteKeysMasterTable dmt
					  WHERE dmt.id=t.' + @KeyColumnName + '
							and dmt.KeyColumnName='''+ @KeyColumnName +'''
							and dmt.study_id=' + convert(varchar,@study_id)
		exec(@sql)
		SELECT @myError = @@Error, @myRowCount = @@RowCount

		exec DODBen_InsertDeletionLogRecord @study_id, @TableName, 'Delete', @myRowCount, @myError, @expectedCount
	    if @myError <> 0 
		BEGIN
			ROLLBACK TRANSACTION
			Return -1
		END
	Commit Tran
END


