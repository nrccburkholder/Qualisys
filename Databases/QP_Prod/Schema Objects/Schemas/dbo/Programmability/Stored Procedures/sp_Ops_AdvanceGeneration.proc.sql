CREATE Procedure sp_Ops_AdvanceGeneration @intSurvey_id int, @strMailingStep_nm varchar(20) = null, @datGenerate datetime = null, @datNewGenerate datetime = null
as
if @datGenerate is null or @strMailingStep_nm is null or @datNewGenerate is null
 begin
	select datgenerate, sd.survey_id, priority_flg, strmailingstep_nm, count(*) Items 
	from scheduledmailing schm (nolock), mailingstep ms (nolock), survey_def sd (nolock)
	where schm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = sd.survey_id
	and schm.sentmail_id is null
	and bitformgenrelease = 1
	and sd.survey_id = @intSurvey_id
	group by datgenerate, sd.survey_id, priority_flg, strmailingstep_nm
	order by datgenerate, sd.survey_id, priority_flg, strmailingstep_nm
   end
Else 
   begin
	Update schm
	set datgenerate = @datNewGenerate
	from scheduledmailing schm (nolock), mailingstep ms (nolock), survey_def sd (nolock)
	where schm.mailingstep_id = ms.mailingstep_id
	and ms.survey_id = sd.survey_id
	and ms.strMailingStep_nm = @strMailingStep_nm
	and schm.sentmail_id is null
	and bitformgenrelease = 1
	and sd.survey_id = @intSurvey_id
	and datgenerate = @datGenerate
   end


