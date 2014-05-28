/****** Object:  Stored Procedure dbo.sp_rollback_import    Script Date: 1/21/2005 1:33:48 PM ******/

/* This procedure will rollback the imports of an entire study. */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
CREATE procedure sp_rollback_import
	@study_id int,
	@cascade tinyint=1
as
	declare @rc int
	declare @tablenm varchar(32), @sqlstr varchar(8000)
	declare metaTableCursor cursor for
		SELECT strTable_nm
        	FROM dbo.metaTable 
             	WHERE study_id = @study_id

	if @cascade = 1
	begin
		exec @rc=dbo.sp_rollback_sampling @study_id, NULL, @cascade
		if @@error <> 0 OR @rc <> 0
		begin
			DEALLOCATE metaTableCursor
			return -1
		end
	end

	print 'Beginning to rollback Import.'

	BEGIN TRANSACTION
	print 'Deleting study from dbo.DataSetMember'
	delete dbo.DataSetMember
	from dbo.datasetmember dsm, dbo.data_set ds
	where dsm.dataset_id = ds.dataset_id
	and ds.study_id = @study_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		DEALLOCATE metaTableCursor
		return -1
	end

	print 'Deleting study from dbo.Data_Set'
	delete from dbo.Data_Set
	where study_id = @study_id
	if @@error <> 0
	begin
		ROLLBACK TRANSACTION
		DEALLOCATE metaTableCursor
		return -1
	end
	COMMIT TRANSACTION

	print 'Truncating study from PopFlags'
	if exists (select name from dbo.sysobjects
		where uid = user_id('S' + convert(varchar(9),@study_id))
		and name = 'PopFlags')
	begin
		set @sqlstr='TRUNCATE TABLE S' + convert(varchar(9),@study_id) + '.popflags'
		EXEC (@sqlstr)
	end

	print 'Truncating study from UniKeys'
	if exists (select name from dbo.sysobjects
		where uid = user_id('S' + convert(varchar(9),@study_id))
		and name = 'UniKeys')
	begin
		set @sqlstr='TRUNCATE TABLE S' + convert(varchar(9),@study_id) + '.unikeys'
		EXEC (@sqlstr)
	end

	print 'Truncating study from Universe'
	if exists (select name from dbo.sysobjects
		where uid = user_id('S' + convert(varchar(9),@study_id))
		and name = 'Universe')
	begin
		set @sqlstr='TRUNCATE TABLE S' + convert(varchar(9),@study_id) + '.universe'
		EXEC (@sqlstr)
	end

	OPEN metaTableCursor
	FETCH metaTableCursor INTO @tablenm
	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		print 'Truncating study from ' + @tablenm + ' and load table.'
		if exists (select name from dbo.sysobjects
			where uid = user_id('S' + convert(varchar(9),@study_id))
			and name = ltrim(rtrim(@tablenm)))
		begin
			set @sqlstr = 'TRUNCATE TABLE S' + convert(varchar(9),@study_id) + '.' + ltrim(rtrim(@tablenm))
			EXEC (@sqlstr)
		end
		if exists (select name from dbo.sysobjects
			where uid = user_id('S' + convert(varchar(9),@study_id))
			and name = ltrim(rtrim(@tablenm)) + '_Load')
		begin
			set @sqlstr = 'TRUNCATE TABLE S' + convert(varchar(9),@study_id) + '.' + ltrim(rtrim(@tablenm)) + '_Load'
			EXEC (@sqlstr)
		end
		FETCH metaTableCursor INTO @tablenm
	END

	CLOSE metaTableCursor
	DEALLOCATE metaTableCursor

	print 'Finished rolling back import.'
	return 0


