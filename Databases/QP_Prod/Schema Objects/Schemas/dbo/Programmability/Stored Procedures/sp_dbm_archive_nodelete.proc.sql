/* This procedure will copy the required data to an Archive Database and back it up the
** entire database to disk.
** Modified 6/12/1 BD corrected the query from QualProParams and creating the study 
**   specific folder for the backup.
** Modified 6/28/1 BD Added QuestionResult2 to the archive process.  Also removed PCLGenLog.
**   Added Study_Employee table to the archive process, leaving only IS and BA's with access.
*/ 
create procedure sp_dbm_archive_nodelete
 @study_id int,
 @delfromprod tinyint=1
AS
 declare @strstudy_id varchar(10),
  @studyuser_nm varchar(32),
  @tblnm varchar(32), @strsql varchar(20),
  @backupdir varchar(300),
  @rc int
 set @strstudy_id = convert(varchar(10),@study_id)
 set @studyuser_nm = 'S' + @strstudy_id
 declare styobjs cursor for
  select name from dbo.sysobjects
  where uid = user_id (@studyuser_nm)
  and type = 'U'
 declare stydrps cursor for
  select case type 
    when 'U' then 'DROP TABLE' 
    when 'V' then 'DROP VIEW'
   end, name
  from dbo.sysobjects
  where uid = user_id (@studyuser_nm)
  and type in ('U','V')

/*Modified 6/12/1 BD strparam_grp was not correct*/
 select @backupdir = strparam_value
 from dbo.qualpro_params
 where strparam_nm = 'ArchivePath'
 and strparam_grp = 'Address'

/*Added 6/12/1 BD will create the study specific folder for the archive*/
declare @fullpath varchar(200), @cmdshell varchar(300)
set @fullpath = '"MD ' + @backupdir + 'S' + @strstudy_id + '"'
set @cmdshell = 'master.dbo.xp_cmdshell ' + @fullpath
--print @cmdshell
exec (@cmdshell)

 set @backupdir = @backupdir + 'S' + @strstudy_id + '\QP_ARCHIVE_' + @strstudy_id + '.BAK'
/* Add the study user to the database, if it isn't already there */
 if not exists (select name from qp_archive.dbo.sysusers where sid = (
   select sid from master.dbo.syslogins where name = @studyuser_nm))
 begin
  exec qp_archive.dbo.sp_adduser @studyuser_nm
  if @@error <> 0
   goto errexit
 end
/* Copy the base-table data for our study over first */
 select distinct scm.* 
 into qp_archive.dbo.scheduledmailing 
 from dbo.scheduledmailing scm, dbo.mailingmethodology mm, dbo.survey_def s
 where s.survey_id = mm.survey_id and mm.methodology_id = scm.methodology_id
 and s.study_id = @strstudy_id
 if @@error <> 0
  goto errexit
 select distinct qf.* 
 into qp_archive.dbo.questionform 
 from dbo.questionform qf, dbo.survey_def s
 where s.survey_id = qf.survey_id
 and s.study_id = @strstudy_id
 if @@error <> 0
  goto errexit
 select * 
 into qp_archive.dbo.samplepop 
 from dbo.samplepop 
 where study_id = @strstudy_id
 if @@error <> 0
  goto errexit
/* Removed 6/28/1 BD No need to archive the PCL information*/
/* select pclgl.* 
 into qp_archive.dbo.pclgenlog 
 from dbo.pclgenlog pclgl,
  (select distinct pclgenrun_id from dbo.pclgenlog pclgl1, 
   dbo.survey_def s where pclgl1.survey_id = s.survey_id
   and s.study_id = @strstudy_id) pcl
 where pclgl.pclgenrun_id = pcl.pclgenrun_id
 if @@error <> 0
  goto errexit
*/
 select distinct sm.* 
 into qp_archive.dbo.sentmailing 
 from dbo.sentmailing sm, dbo.mailingmethodology mm, dbo.survey_def s
 where s.survey_id = mm.survey_id 
 and mm.methodology_id = sm.methodology_id
 and s.study_id =  @strstudy_id
 if @@error <> 0
  goto errexit
 select * 
 into qp_archive.dbo.selectedsample 
 from dbo.selectedsample 
 where study_id = @strstudy_id
 if @@error <> 0
  goto errexit
 select distinct qr.* 
 into qp_archive.dbo.questionresult 
 from dbo.questionresult qr, dbo.questionform qf, dbo.survey_def s
 where s.survey_id = qf.survey_id
 and qf.questionform_id = qr.questionform_id
 and s.study_id = @strstudy_id
 if @@error <> 0
  goto errexit
/* Added 6/28/1 BD to include questionresult2 */
 select distinct qr.* 
 into qp_archive.dbo.questionresult2 
 from dbo.questionresult2 qr, dbo.questionform qf, dbo.survey_def s
 where s.survey_id = qf.survey_id
 and qf.questionform_id = qr.questionform_id
 and s.study_id = @strstudy_id
 if @@error <> 0
  goto errexit
 select * 
 into qp_archive.dbo.recurringencounter 
 from dbo.recurringencounter 
 where study_id = @strstudy_id
 if @@error <> 0
  goto errexit
 select * 
 into qp_archive.dbo.tocl 
 from dbo.tocl 
 where study_id = @strstudy_id
 if @@error <> 0
  goto errexit
 select * 
 into qp_archive.dbo.unitdq 
 from dbo.unitdq 
 where study_id = @strstudy_id
 if @@error <> 0
  goto errexit
 select distinct dsm.* 
 into qp_archive.dbo.datasetmember 
 from dbo.datasetmember dsm, dbo.data_set ds
 where ds.dataset_id = dsm.dataset_id
 and ds.study_id =  @strstudy_id
 if @@error <> 0
  goto errexit
/* Added 6/28/1 BD Adding Study_Employee */
 select distinct se.* 
 into qp_archive.dbo.study_employee
 from dbo.study_employee se
 where se.study_id =  @strstudy_id
/*   delete se
   from dbo.study_employee se
   where se.study_id = @strstudy_id
   and se.employee_id not in (
     select employee_id 
     from dbo.usergroupemployee
     where usergroup_id = 3)
*/
 if @@error <> 0
  goto errexit
/* Copy the study specific data, we are assuming that the structure on the unarchive
** will be put back.  So, we will use SELECT * INTO to copy the data over.
*/
 open styobjs
 fetch styobjs into @tblnm
 while @@fetch_status = 0
 begin
  execute ('select * into qp_archive.' + @studyuser_nm + '.' + @tblnm +
    ' from ' + @studyuser_nm + '.' + @tblnm)
  if @@error <> 0
   goto errexit
  fetch styobjs into @tblnm
 end
 close styobjs
errexit:
 deallocate styobjs
 deallocate stydrps


