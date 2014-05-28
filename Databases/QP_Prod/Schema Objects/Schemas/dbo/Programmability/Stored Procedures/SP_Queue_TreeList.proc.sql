-- Created 9/10/2 BD This procedure is used to generate the initial client tree view.
CREATE PROCEDURE SP_Queue_TreeList 
@PCLOutput VARCHAR(200), @QueueType CHAR(1)
AS

declare @r int
exec @r=sp_Queue_CheckPCLOutputLocation 'SP_Queue_TreeList', @PCLOutput
if @r=-1 
begin
	SELECT '' as strclient_nm, '' as strsurvey_nm, 0 as survey_id, '' as strPaperConfig_nm, 0 as PaperConfig_id, 
		0 as intPages, 0 as Study_id, getdate() as datBundled, getdate() as datPrinted, getdate() as datMailed, 
		0 as numPrinted, 0 as numNotPrinted, 0 as numMailed, 0 as numNotMailed, 0 as numGroupedPrint, 0 as [count]
	return
end

declare @PrintOne datetime, @PrintTwo datetime, @MailOne datetime, @MailTwo datetime, @SQL varchar(8000)
if @QueueType = 'P'
begin
	set @PrintOne = '1/1/4000'
	set @PrintTwo = '1/1/4000'
	set @MailOne ='1/1/4000'
	set @MailTwo ='1/1/4000'
end
else
begin
	set @PrintOne = '1/1/1900'
	set @PrintTwo = '1/1/3999'
	select @MailOne = dateadd(day,-numParam_value,getdate())
	from qualpro_params
	where strparam_nm='MailedDaysInQ'
	set @MailTwo ='1/1/4000'
end

--print '@PrintOne = ' + convert(varchar,@printone)
--print '@PrintTwo = ' + convert(varchar,@printtwo)
--print '@MailOne = ' + convert(varchar,@mailone)
--print '@MailTwo = ' + convert(varchar,@mailtwo)

select c.strclient_nm, sd.strsurvey_nm, SD.survey_id, pc.strPaperConfig_nm, pc.PaperConfig_id, sm.intPages, s.Study_id, sm.datBundled, sm.datPrinted, sm.datMailed, 
	sum(case when sm.datPrinted='4000' then 0 else 1 end) as numPrinted,
	sum(case when sm.datPrinted='4000' then 1 else 0 end) as numNotPrinted,
	sum(case when sm.datmailed='4000' then 0 else 1 end) as numMailed,
	sum(case when sm.datmailed='4000' then 1 else 1 end) as numNotMailed,
	sum(case when gp.survey_id is null then 1 else 0 end) as numGroupedPrint,
	count(*) as [count]
from qp_queue..PCLOutput po, survey_def sd, study s, client c, paperconfig pc, 
	(select np.Sentmail_id, mm.survey_id, np.methodology_id, np.paperconfig_id, np.datBundled, np.datPrinted, np.datMailed, np.intPages
	from MailingMethodology MM, NPSentMailing NP
	where mm.methodology_id=np.methodology_id) sm left outer join GroupedPrint GP 
		on sm.survey_id=gp.survey_id 
		and sm.paperconfig_id=gp.paperconfig_id 
		and sm.datbundled=gp.datbundled 
		and sm.datprinted=isnull(gp.datprinted,'4000')
where sm.sentmail_id=po.sentmail_id
and sm.survey_id=sd.survey_id
and sd.study_id=s.study_id
and s.client_id=c.client_id
and sm.paperconfig_id=pc.paperconfig_id
and sm.datPrinted between @printone and @printtwo
and sm.datMailed between @mailone and @mailtwo
group by c.strclient_nm, sd.strsurvey_nm, SD.survey_id, pc.strPaperConfig_nm, pc.PaperConfig_id, sm.intPages, s.Study_id, sm.datBundled, sm.datPrinted, sm.datMailed
order by c.strclient_nm, sd.strsurvey_nm, SD.survey_id, pc.strPaperConfig_nm, pc.PaperConfig_id, sm.intPages, s.Study_id, sm.datBundled


