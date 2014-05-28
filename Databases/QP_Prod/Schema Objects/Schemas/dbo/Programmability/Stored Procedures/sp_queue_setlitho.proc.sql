/* DG 12/13/1999
   Added @datBundled as a parameter and added it to the WHERE clauses of the two queries on SentMailing
*/
CREATE procedure sp_queue_setlitho
 @survey_id int,
 @strpostalbundle_id varchar(10),
 @paperconfig_id int,
 @reprint tinyint,
 @datBundled datetime
as
 declare @rtnlitho int, @cnt int
 declare @study_id int, @sq varchar(1000)
 select @study_id=study_id from survey_def where survey_id=@survey_id
 create table #setlitho (
  litho_id int identity (1,1),
  sentmail_id int
 )
 if @reprint = 0
 begin
   /* DG 12/9/1999 */
   /* ORDER BY P.ZIP5 was added so the pieces within a bundle would be in zip code order */
   /* DG 8/10/2001 */
   /* ORDER BY changed to sm.strGroupDest, P.ZIP5 so the pieces within a bundle would be in the proper order for flats */
   /* RN 3/19/2003*/
   /* ORDER BY added P.Pop_id so double stuff would come out in the same order in the a bundle*/
   select @sq =
    'insert into #setlitho (sentmail_id)
     select sm.sentmail_id
     from sentmailing sm, mailingmethodology mm, scheduledmailing schm, samplepop sp, s'+convert(varchar,@study_id)+'.population p
     where sm.methodology_id = mm.methodology_id
     and schm.scheduledmailing_id=sm.scheduledmailing_id
     and schm.samplepop_id=sp.samplepop_id
     and sp.pop_id=p.pop_id
     and mm.survey_id = '+convert(varchar,@survey_id)+'
     and sm.strpostalbundle = "' + @strpostalbundle_id+'"
     and sm.paperconfig_id = '+convert(varchar,@paperconfig_id)+'
     and abs(datediff(second,SM.datBundled,"'+convert(varchar,@datBundled,120)+'"))<=1
     and sm.datprinted IS NULL
     and sm.strlithocode IS NULL
     order by isnull(sm.STRGROUPDEST,0), p.zip5, p.Pop_id'
   exec (@sq)
 end
 else
 begin
  insert into #setlitho (sentmail_id)
  select sentmail_id
  from sentmailing sm, mailingmethodology mm
  where sm.methodology_id = mm.methodology_id
  and mm.survey_id = @survey_id
  and sm.strpostalbundle = @strpostalbundle_id
  and sm.paperconfig_id = @paperconfig_id
  and abs(datediff(second,SM.datBundled,@datBundled))<=1
  and sm.datprinted IS NOT NULL
  and sm.strlithocode IS NULL
  /* DG 12/9/1999 */
  /* I can't understand why this is here.  if datPrinted is not null that implies the  */
  /* survey has been printed.  If the survey has been printed, the lithocode shouldn't */
  /* be null and so the WHERE clause will never cause any records to be selected.      */
 end
 select @cnt = count(*) from #setlitho
/* Get the last used litho number, if it doesn't exist, create it, else update it. */
/* We want to do this part in a transaction to prevent other people from updating */
/* this. */
 begin transaction
 select @rtnlitho = MAX(MAXLITHOUSED)
 from dbo.maxlitho (TABLOCKX)
 if @@error <> 0
 begin
  rollback transaction
  drop table #setlitho
  return
 end
 if @rtnlitho is null
 begin
  set @rtnlitho = 1
  insert into dbo.maxlitho (MAXLITHOUSED) values (1 + @cnt)
  if @@error <> 0
  begin
   rollback transaction
   drop table #setlitho
   return
  end
 end
 else
 begin
  update dbo.maxlitho
  set MAXLITHOUSED = MAXLITHOUSED + @cnt
  if @@error <> 0
  begin
   rollback transaction
   drop table #setlitho
   return
  end
 end
/* Set the strlithocode in sentmailing to the maxlitho + the identity field value */
 update dbo.sentmailing
 set strlithocode = convert(varchar(10),t.litho_id + @rtnlitho)
 from #setlitho t
 where t.sentmail_id = dbo.sentmailing.sentmail_id
 and dbo.sentmailing.strlithocode IS NULL
/* Set the strlithocode in NPsentmailing to the maxlitho + the identity field value */
 update dbo.NPsentmailing
 set strlithocode = convert(varchar(10),t.litho_id + @rtnlitho)
 from #setlitho t
 where t.sentmail_id = dbo.NPsentmailing.sentmail_id
 and dbo.NPsentmailing.strlithocode IS NULL
 if @@error <> 0
 begin
  rollback transaction
  drop table #setlitho
  return
 end
 commit transaction


