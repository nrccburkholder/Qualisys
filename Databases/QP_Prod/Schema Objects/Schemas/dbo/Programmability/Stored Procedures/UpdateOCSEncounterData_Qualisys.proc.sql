CREATE proc UpdateOCSEncounterData_Qualisys
	@datafile_id int
as

declare @study_id int
declare @study varchar(10)			--string version of the id field
declare @datafile varchar(10)		--string version of the id field
declare @sql varchar(8000)
declare @table1 varchar(50)
declare @table2 varchar(50)
declare @batch_id int
declare @totalupdated_nrc10 int
declare @totalupdated_medusa int

select @study_id = study_id from pervasive.qp_dataload.dbo.datafile where datafile_id = @datafile_id
select @datafile = cast(@datafile_id as varchar)

if @study_id is null
begin
	print 'Datafile ID not found.'
	select -1 as ReturnCode
	return
end

select @study = 's' + cast(@study_id as varchar)
print 'Study: ' + @study


begin tran

select @table1 = @study + '.tmp_encounter_load'
select @table2 = @study + '.encounter'

--Copy one row of pervasive table into a temp table on local db for the column compare.
--The compare proc uses syscolumns so both tables have to be local, but this temp table doesn't have to have data in it.
if exists (select 1 from sysobjects where id = object_id(@table1)) 
	exec('drop table ' + @table1)
	
select @sql = 'select top 1 * into ' + @table1 + ' from pervasive.qp_dataload.' + @study + '.encounter_load'
exec (@sql)


if @@error <> 0
begin
 print 'Failed getting table info from Minerva.' 
 print 'error: ' + cast(@@error as varchar)
 rollback tran
 select -1 as ReturnCode
 return
end



--Check for duplicate keys.
create table #dupkeys (enc_mtch varchar(100))
exec('insert into #dupkeys select enc_mtch from pervasive.qp_dataload.' + @study + '.encounter_load where datafile_id = ' + @datafile + ' group by enc_mtch having count(*) > 1')


--Get list of pops that will be updated (don't include rows with duplicate keys).
--Also include fields that will be used later to evaluate dispositions
create table #pops (
	samplepop_id int,
	pop_id int, 
	enc_id int, 
	enc_mtch varchar(100),
	HHPay_MCare varchar(1),
	HHPay_MCaid varchar(1),
	HHVisitCnt int,
	HHLookbackCnt int,
	HHEOMAge int,
	HHMaternity varchar(1),
	HHHospice varchar(1),
	HHDeceased varchar(1)
)

select @sql = 'insert into #pops select 0, b.pop_id, b.enc_id, b.enc_mtch, a.HHPay_MCare, a.HHPay_MCaid, a.HHVisitCnt, a.HHLookbackCnt, a.HHEOMAge, a.HHMaternity, a.HHHospice, a.HHDeceased ' +
	' from pervasive.qp_dataload.' + @study + 
	'.encounter_load a inner join ' + @table2 + ' b on a.enc_mtch = b.enc_mtch where datafile_id = ' + @datafile +
	' and a.enc_mtch not in (select * from #dupkeys)'
print @sql
exec(@sql)


--Add samplepops for later matching.
update p set samplepop_id = sp.samplepop_id
from #pops p inner join samplepop sp
 on p.pop_id = sp.pop_id
where study_id = @study_id


--Get list of columns common between the load table and the live table.
--These are the columns that will be updated.
create table #columns (column_name varchar(100))

insert into #columns
exec GetCommonColumnsVertical @table1, @table2


--We don't to update the key fields.
delete #columns where column_name in ('enc_mtch', 'enc_id', 'pop_id', 'newrecorddate')

--Build string of columns to be updated.
select @sql = ''
select @sql = @sql + column_name + '=a.' + column_name + ',' from #columns

--Check length of string.  If len goes over 8000, then data could be truncated.
--So if we're within the margin, raise an error.
if len(@sql) >= 7950
begin
	print 'Column list too large.'
	rollback tran
	select -3 as ReturnCode
	return
end

--Get rid of trailing comma.
select @sql = left(@sql, len(@sql)-1)


--Build and execute update string.
print 'Performing update'
print @sql
print 'test'
print 'update b set ' + @sql + ' from pervasive.qp_dataload.' + @study + '.encounter_load a inner join ' + @table2 + ' b on a.enc_mtch = b.enc_mtch where datafile_id = ' + @datafile + ' and a.enc_mtch not in (select * from #dupkeys)'
print 'test2'
exec('update b set ' + @sql + ' from pervasive.qp_dataload.' + @study + '.encounter_load a inner join ' + @table2 + ' b on a.enc_mtch = b.enc_mtch where datafile_id = ' + @datafile + ' and a.enc_mtch not in (select * from #dupkeys)')


--Find out how many rows were updated.
select @totalupdated_nrc10 = @@rowcount


--Record updates in log files
select @batch_id = max(batch_id) from OCSLoadToLive_FilesUpdated_log
select @batch_id = isnull(@batch_id, 0) + 1


insert into OCSLoadToLive_DupKeysFound_log
select @batch_id, @datafile_id, @study_id, enc_mtch, getdate() from #dupkeys

insert into OCSLoadToLive_FilesUpdated_log
select @batch_id, @datafile_id, @study_id, @totalupdated_nrc10, getdate(), null, null, 0, null, null

update OCSLoadToLive_FilesUpdated_log
set dupkeysfound = (select count(*) from #dupkeys)
where batch_id = @batch_id

insert into OCSLoadToLive_PopsUpdated_log
select @batch_id, @datafile_id, @study_id, pop_id, enc_id, enc_mtch, getdate()
from #pops


commit tran


--Perform update on MEDUSA.

--Get quarter tables that will have to be updated.  This will perform better than working from the view.
--This assumes that data will never be updated from one file spanning more than two quarters.
print 'Updating datamart.'
declare @min_date datetime
declare @max_date datetime
declare @qtr1 varchar(50)
declare @qtr2 varchar(50)

--Get min and max dates of samples affected by this datafile.
select @min_date = min(datdaterange_fromdate), @max_date = max(datdaterange_todate)
from sampleset ss inner join selectedsample sam
 on ss.sampleset_id = sam.sampleset_id
inner join #pops d
 on sam.pop_id = d.pop_id
 and sam.enc_id = d.enc_id
where sam.study_id = @study_id 

if @min_date is null
begin
	select @totalupdated_medusa = 0
	print 'No records found to update on datamart.'
end
else
begin

	print '@min_date: ' + cast(@min_date as varchar)
	print '@max_date: ' + cast(@max_date as varchar)

	select @qtr1 = cast(datepart(yyyy, @min_date) as varchar) + '_' + cast(datepart(q, @min_date) as varchar)
	select @qtr2 = cast(datepart(yyyy, @max_date) as varchar) + '_' + cast(datepart(q, @max_date) as varchar)

	print '***datamart***'
	print '@datafile: ' + @datafile
	print '@study: ' + @study
	print '@batch_id: ' + cast(@batch_id as varchar)
	print '@qtr1: ' + @qtr1
	print '@qtr2: ' + @qtr2

	exec datamart.qp_comments.dbo.UpdateOCSEncounterData_Datamart @datafile_id, @study_id, @batch_id, @qtr1, @qtr2, @totalupdated_medusa output

	if @totalupdated_medusa is null select @totalupdated_medusa = 0
	if @totalupdated_medusa < 0 
	begin
		print 'Update on Datamart failed.'
		select @totalupdated_medusa as ReturnCode
		rollback tran
		return
	end
end

--Update counts
update OCSLoadToLive_FilesUpdated_log 
set totalupdated_medusa = @totalupdated_medusa, 
	datUpdated_medusa = getdate(),
	datMinEncounterDate = @min_date,
	datMaxEncounterDate = @max_date
where batch_id = @batch_id	



--Perform update on Catalyst.
insert NRC_DataMart_ETL.dbo.ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, source)  
select distinct 7 as EntityTypeID, sp.samplepop_ID as PKey1, NULL as PKey2, 0 as IsMetaData, 'OCS Load to live' as Source
from samplepop sp inner join #pops d
 on sp.pop_id = d.pop_id
where sp.study_id = @study_id


--Insert dispositions if necessary.
declare @receipttype_id int
declare @ltime datetime

select @receipttype_id = receipttype_id from receipttype where receipttype_nm = 'Update File'
if @receipttype_id is null select @receipttype_id = 0

SET @sql = 'SELECT datReceived from pervasive.QP_dataload.dbo.datafile WHERE DataFile_id = ' + @DataFile
CREATE TABLE #lt (ltime datetime)
INSERT INTO #LT (ltime) EXEC (@sql)                        
SELECT @ltime = ltime FROM #lt                         
DROP TABLE #lt   


select max(schm.sentmail_id) sentmail_id, schm.samplepop_id
into #tmp
from scheduledmailing schm inner join #pops p
 on schm.samplepop_id = p.samplepop_id
where schm.sentmail_id is not null 
and((hhpay_mcare <> '1' and hhpay_mcaid <> '1')
or hhvisitcnt < 1
or hhlookbackcnt < 2
or hheomage < 18
or hhmaternity = 'Y'
or hhhospice = 'Y')
group by schm.samplepop_id

insert into dispositionlog
select sentmail_id, samplepop_id, 8, @receipttype_id, @ltime, 'DBA', NULL, NULL
from #tmp

drop table #tmp


select max(schm.sentmail_id) sentmail_id, schm.samplepop_id
into #tmp2
from scheduledmailing schm inner join #pops p
 on schm.samplepop_id = p.samplepop_id
where schm.sentmail_id is not null
and hhdeceased = 'Y'
group by schm.samplepop_id

insert into dispositionlog
select sentmail_id, samplepop_id, 3, @receipttype_id, @ltime, 'DBA', NULL, NULL
from #tmp2

drop table #tmp2


UPDATE DL SET                         
  DaysFromFirst   =  dbo.fn_DispDaysFromFirst(dl.SentMail_ID,@LTime,8),                           
  DaysFromCurrent =  dbo.fn_DispDaysFromCurrent(dl.SentMail_ID,@LTime,8)                        
FROM DispositionLog DL inner join #pops p
 on dl.samplepop_id = p.samplepop_id
where dl.disposition_id in (3,8)
and receipttype_id = @receipttype_id
and datlogged = @ltime

/*
--Run code from ETL that evaluates the dispositions.
print 'Running disposition evaluation procs.'
EXEC datamart.qp_comments.dbo.SP_Extract_CheckDispositionLogDuplicates
EXEC datamart.qp_comments.dbo.SP_Extract_DispositionLog
EXEC datamart.qp_comments.dbo.SP_Extract_HCAHPSDispositionBigTable
EXEC datamart.qp_comments.dbo.SP_Extract_HHCAHPSDispositionBigTable
EXEC datamart.qp_comments.dbo.SP_Extract_MNCMDispositionBigTable
EXEC datamart.qp_comments.dbo.SP_Extract_VendorDispositionLog
*/

--Cleanup.
drop table #columns
drop table #pops
drop table #dupkeys
exec('drop table ' + @table1)

--Return code that means clean run.
select 0 as ReturnCode


