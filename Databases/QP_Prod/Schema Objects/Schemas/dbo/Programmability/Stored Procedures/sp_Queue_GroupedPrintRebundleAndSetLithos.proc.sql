CREATE procedure dbo.sp_Queue_GroupedPrintRebundleAndSetLithos
@PaperConfig_id int, @printdate datetime
as

update sm
set datbundled=@printdate
from sentmailing sm, npsentmailing np, groupedprint gp, mailingmethodology mm
where sm.sentmail_id=np.sentmail_id
and np.methodology_id=mm.methodology_id
and mm.survey_id=gp.survey_id
and np.paperconfig_id=gp.paperconfig_id
and np.datbundled<'4000'
and abs(datediff(second,np.datbundled,gp.datbundled))<=1
and np.paperconfig_id=@paperconfig_id
and np.datprinted='4000'
and gp.datprinted is null

update np
set datbundled=@printdate
from npsentmailing np, groupedprint gp, mailingmethodology mm
where np.methodology_id=mm.methodology_id
and mm.survey_id=gp.survey_id
and np.paperconfig_id=gp.paperconfig_id
and np.datbundled<'4000'
and abs(datediff(second,np.datbundled,gp.datbundled))<=1
and np.paperconfig_id=@paperconfig_id
and np.datprinted='4000'
and gp.datprinted is null

update groupedprint set datprinted=@printdate, datbundled=@printdate
where datprinted is null
and paperconfig_id=@paperconfig_id

exec sp_Queue_BundleUp @isGroupedPrint=1, @PaperConfig_id=@Paperconfig_id, @bundledate=@printdate

declare @rtnlitho int, @cnt int

create table #setlitho (litho_id int identity (1,1), sentmail_id int)

insert into #setlitho (sentmail_id)
select sm.sentmail_id
from sentmailing sm, mailingmethodology mm, groupedprint gp, bundlingcodes bc
where sm.methodology_id = mm.methodology_id
and mm.survey_id=gp.survey_id
and sm.paperconfig_id=gp.paperconfig_id
and sm.paperconfig_id=@paperconfig_id
and abs(datediff(second,SM.datBundled,gp.datbundled))<=1
and gp.datprinted = @printdate
and sm.sentmail_id=bc.sentmail_id
and sm.strLithoCode is null
order by sm.strPostalBundle, isnull(sm.strGroupDest,''), gp.survey_id, bc.zip5, bc.zip4, bc.postalcode

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


