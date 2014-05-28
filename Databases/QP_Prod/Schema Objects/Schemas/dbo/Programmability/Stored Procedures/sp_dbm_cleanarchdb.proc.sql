/* This procedure will drop the database we created */
/* 10/12/1999 - We don't autoclose the archive db anymore */
create procedure sp_dbm_cleanarchdb
as
	declare @tblnm varchar(65)
	declare cln cursor for
		select su.name + '.' + so.name 
		from qp_archive.dbo.sysobjects so, qp_archive.dbo.sysusers su
		where so.uid = su.uid
		and so.type = 'U' 
		and so.name not in ('archstructure')
	declare ucln cursor for
		select name
		from qp_archive.dbo.sysusers
		where name not in
			(select name from model.dbo.sysusers)

/* Drop all the existing user tables, except the archstructure table */
	open cln
	fetch cln into @tblnm
	while @@fetch_status = 0
	begin
		execute ('DROP TABLE qp_archive.' + @tblnm)
		fetch cln into @tblnm
	end
	close cln
	deallocate cln

/* Remove all users except the ones listed in MODEL */
	open ucln
	fetch ucln into @tblnm
	while @@fetch_status = 0
	begin
		exec qp_archive.dbo.sp_dropuser @tblnm
		fetch ucln into @tblnm
	end
	close ucln
	deallocate ucln

/* Truncate the archstructure table */
	truncate table qp_archive.dbo.archstructure

/* Reset the database options back to where we want them. */
	exec sp_dboption QP_ARCHIVE, 'SINGLE USER', 'FALSE'
	exec sp_dboption QP_ARCHIVE, 'SELECT INTO/BULKCOPY', 'TRUE'
	exec sp_dboption QP_ARCHIVE, 'TRUNC. LOG ON CHKPT.', 'TRUE'
	exec sp_dboption QP_ARCHIVE, 'AUTOSHRINK', 'TRUE'
	exec sp_dboption QP_ARCHIVE, 'AUTOCLOSE', 'FALSE'

/* Shrink down the database, leaving only a small amount of free space */
	dbcc shrinkdatabase (QP_ARCHIVE, 10)
	return 0


