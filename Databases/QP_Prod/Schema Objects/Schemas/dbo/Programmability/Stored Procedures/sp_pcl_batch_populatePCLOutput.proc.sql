CREATE procedure dbo.sp_pcl_batch_populatePCLOutput
as
DELETE a   --delete records that already exist in npsentmailing
from pcloutput2 a
join npSentMailing b
on a.sentmail_ID = b.sentmail_ID

-- We no longer user pcloutput in qp_prod
--insert into pcloutput
--select * from pcloutput2

--if @@error <> 0
--  begin 
--     rollback tran 
--     return
--  end

select distinct top 100 po.sentmail_id
into #sm
from pcloutput2 po
left outer join questionform qf on po.sentmail_id=qf.sentmail_id
left outer join PCLGenPosError pe on qf.questionform_id=pe.questionform_id
where pe.questionform_id is null

while @@rowcount>0 
begin

	begin tran
	
	INSERT INTO NPSentMailing (SENTMAIL_ID,SCHEDULEDMAILING_ID,DATGENERATED,DATPRINTED,DATMAILED,METHODOLOGY_ID,PAPERCONFIG_ID,
	   STRLITHOCODE,STRPOSTALBUNDLE,INTPAGES,DATUNDELIVERABLE,INTRESPONSESHAPE,STRGROUPDEST,datDeleted,datBundled,intReprinted,datReprinted)
	SELECT SM.SENTMAIL_ID,SM.SCHEDULEDMAILING_ID,DATGENERATED,'1/1/4000','1/1/4000',SM.METHODOLOGY_ID,PAPERCONFIG_ID,
	   STRLITHOCODE,STRPOSTALBUNDLE,INTPAGES,DATUNDELIVERABLE,INTRESPONSESHAPE,STRGROUPDEST,datDeleted,datBundled,intReprinted,datReprinted
	FROM SentMailing SM, #sm t
	WHERE SM.sentmail_id = t.sentmail_id

	if @@error <> 0
	  begin 
		 rollback tran 
		 return
	  end

	insert into qp_queue.dbo.pcloutput
	select p.* 
	from pcloutput2 p, #sm s
	where s.sentmail_id = p.sentmail_id

	if @@error <> 0
	  begin 
		 rollback tran 
		 return
	  end

	delete p
	from pcloutput2 p, #sm s
	where s.sentmail_id = p.sentmail_id

	if @@error <> 0
	  begin 
		 rollback tran 
		 return
	  end

	commit tran
	  
	truncate table #sm

	insert into #sm
	select distinct top 100 po.sentmail_id
	from pcloutput2 po
	left outer join questionform qf on po.sentmail_id=qf.sentmail_id
	left outer join PCLGenPosError pe on qf.questionform_id=pe.questionform_id
	where pe.questionform_id is null

end

drop table #sm

--update qualpro_params set numparam_value = 1 where param_id = 80
--update qualpro_params set numparam_value = 745 where param_id = 81
--update qualpro_params set numparam_value = 400 where param_id = 82
--exec master.dbo.xp_sendmail @recipients = 'lbreckner; bvaske; bdohmen', @subject = 'Bundle away.  Let me know when bundling is complete.  Brian'