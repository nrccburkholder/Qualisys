/* This procedure will copy the required data to an Archive Database and back it up the
** entire database to disk.  This assumes that the study data structures have already been
** recreated.
*/

/********************************************************************************************************************
*********************************************************************************************************************
MAKE SURE ALL INDEXES EXIST ON THE STUDY SPECIFIC TABLES.
*********************************************************************************************************************
********************************************************************************************************************/
CREATE procedure sp_dbm_unarchive
 @study_id int,
 @tabtype varchar(5),
 @copytoprod tinyint=1
AS
 declare @strstudy_id varchar(10),
  @studyuser_nm varchar(32),
  @tblnm varchar(32),
  @backupdir varchar(300),
  @strsql varchar(8000)
 set @strstudy_id = convert(varchar(10),@study_id)
 set @studyuser_nm = 'S' + @strstudy_id
 declare rebuild cursor for
  select strSQL from qp_archive.dbo.archstructure
  where strType = @tabtype
 declare rebuildcont cursor for
  select strSQL from qp_archive.dbo.archstructure
  where strType <> @tabtype
  and strsql not like '%PK_%'
 declare styobjs cursor for
  select name from dbo.sysobjects
  where uid = user_id (@studyuser_nm)
  and type = 'U'
  and name not like '%_LOAD'
 select @backupdir = strparam_value
 from dbo.qualpro_params
 where strparam_nm = 'ArchivePath'
 and strparam_grp = 'DBManager'
 set @backupdir = @backupdir + 'S' + @strstudy_id + '\QP_ARCHIVE_' + @strstudy_id + '.BAK'
/* First, restore the archive. */
 RESTORE DATABASE QP_ARCHIVE
 FROM DISK = @backupdir
 WITH NOUNLOAD, REPLACE
 if @@error <> 0
  goto errexit
/* Next, rebuild the structure listed in archstructure, starting with the tables */
 open rebuild
 fetch rebuild into @strsql
 while @@fetch_status = 0
 begin
  execute (@strsql)
  if @@error <> 0
   goto errexit
  fetch rebuild into @strsql
 end
 close rebuild
/* Copy the base-table data for our study over first */
 if @copytoprod = 1
 begin
/* Add the study user to the database, if it isn't already there */
  if not exists (select name from dbo.sysusers where sid = (
    select sid from master.dbo.syslogins where name = @studyuser_nm))
  begin
   exec dbo.sp_adduser @studyuser_nm
   if @@error <> 0
    goto errexit
  end
  BEGIN TRANSACTION
  set identity_insert dbo.datasetmember on
  insert into dbo.datasetmember (
   datasetmember_id, dataset_id, pop_id, enc_id
  ) select datasetmember_id, dataset_id, pop_id, enc_id
   from qp_archive.dbo.datasetmember
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.datasetmember off
  set identity_insert dbo.samplepop on
  insert into dbo.samplepop (
   samplepop_id, sampleset_id, study_id, pop_id
  ) select samplepop_id, sampleset_id, study_id, pop_id
  from qp_archive.dbo.samplepop
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.samplepop off
  set identity_insert dbo.selectedsample on
  insert into dbo.selectedsample (
   selectedsample_id, sampleset_id, study_id, pop_id, sampleunit_id, strunitselecttype
  ) select selectedsample_id, sampleset_id, study_id, pop_id, sampleunit_id, strunitselecttype
  from qp_archive.dbo.selectedsample
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.selectedsample off
/* First, we recover everything but the sentmail_id */
  set identity_insert dbo.scheduledmailing on
  insert into dbo.scheduledmailing (
   scheduledmailing_id, mailingstep_id, samplepop_id, overrideitem_id,
   methodology_id, datgenerate)
  select scheduledmailing_id, mailingstep_id, samplepop_id, overrideitem_id,
   methodology_id, datgenerate 
  from qp_archive.dbo.scheduledmailing
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.scheduledmailing off
/* After we insert the data into sentmailing... */
  set identity_insert dbo.sentmailing on
  insert into dbo.sentmailing (
   sentmail_id, scheduledmailing_id, datgenerated, datprinted,
   datmailed, methodology_id, paperconfig_id, strlithocode,
   strpostalbundle, intpages, datundeliverable, intresponseshape,
   strgroupdest, datdeleted
  ) select sentmail_id, scheduledmailing_id, datgenerated, datprinted,
   datmailed, methodology_id, paperconfig_id, strlithocode,
   strpostalbundle, intpages, datundeliverable, intresponseshape,
   strgroupdest, datdeleted
  from qp_archive.dbo.sentmailing
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.sentmailing off 
/* We update the data in ScheduledMailing */
  update dbo.scheduledmailing
  set sentmail_id = sm.sentmail_id
  from dbo.sentmailing sm, qp_archive.dbo.scheduledmailing qascm
  where sm.scheduledmailing_id = dbo.scheduledmailing.scheduledmailing_id
  and qascm.scheduledmailing_id = dbo.scheduledmailing.scheduledmailing_id
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.questionform on
  insert into dbo.questionform (
   questionform_id, sentmail_id, samplepop_id, cutoff_id, datreturned, survey_id
  ) select questionform_id, sentmail_id, samplepop_id, cutoff_id, datreturned, survey_id
  from qp_archive.dbo.questionform
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.questionform off
  set identity_insert dbo.pclgenlog on
  insert into dbo.pclgenlog (
   pclgenlog_id, pclgenrun_id, survey_id, sentmail_id, logentry, datlogged
  ) select pclgenlog_id, pclgenrun_id, survey_id, sentmail_id, logentry, datlogged
  from qp_archive.dbo.pclgenlog
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.pclgenlog off
  set identity_insert dbo.questionresult on
  insert into dbo.questionresult (
   questionresult_id, questionform_id, sampleunit_id, qstncore, intresponseval
  ) select questionresult_id, questionform_id, sampleunit_id, qstncore, intresponseval
  from qp_archive.dbo.questionresult
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.questionresult off
  set identity_insert dbo.recurringencounter on
  insert into dbo.recurringencounter (
   recurringenc_id, study_id, startenc_id, endenc_id, pop_id
  ) select recurringenc_id, study_id, startenc_id, endenc_id, pop_id
  from qp_archive.dbo.recurringencounter
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.recurringencounter off
  set identity_insert dbo.tocl on
  insert into dbo.tocl (tocl_id, study_id, pop_id, dattocl_dat)
  select tocl_id, study_id, pop_id, dattocl_dat 
  from qp_archive.dbo.tocl
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  set identity_insert dbo.tocl off
/* Don't need identity insert on unitdq, no identity column, but there is a timestamp column */
  insert into dbo.unitdq (
   study_id, survey_id, sampleunit_id, sampleset_id, pop_id, dqrule_id, enc_id
  ) select study_id, survey_id, sampleunit_id, sampleset_id, pop_id, dqrule_id, enc_id
  from qp_archive.dbo.unitdq
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
/* Copy the study specific data, we are assuming that we have we will not be transferring
** back the _LOAD data, since it has an identity column that would make this part very
** difficult and lengthy.
*/
  open styobjs
  fetch styobjs into @tblnm
  while @@fetch_status = 0
  begin
   execute ('insert into ' + @studyuser_nm + '.' + @tblnm + 
     ' select * from qp_archive.' + @studyuser_nm + '.' + @tblnm)
   if @@error <> 0
   begin
    ROLLBACK TRANSACTION
    goto errexit
   end
   fetch styobjs into @tblnm
  end
  close styobjs
/* Reset the datArchived back to NULL, since we have restored it. */
  UPDATE Study 
  SET datArchived = NULL 
  WHERE Study_id = @study_id
  if @@error <> 0
  begin
   ROLLBACK TRANSACTION
   goto errexit
  end
  COMMIT TRANSACTION
 end /* If we are restoring back to production */
/* Finally, rebuild the remaining items, views, keys, indexes, etc. */
 open rebuildcont
 fetch rebuildcont into @strsql
 while @@fetch_status = 0
 begin
  execute (@strsql)
  if @@error <> 0
   goto errexit
  fetch rebuildcont into @strsql
 end
 close rebuildcont
 exec dbo.sp_dbm_cleanarchdb
errexit:
 deallocate styobjs
 deallocate rebuild
 deallocate rebuildcont


