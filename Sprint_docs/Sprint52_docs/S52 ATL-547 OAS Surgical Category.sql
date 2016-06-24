/*
S52 ATL-547 OAS Surgical Category assignment

As an accredited OAS CAHPS provider, we need to alter the way Surgical Category is assigned so that we can be compliant.

ATL-548 Alter OAS post-process

Dave Gilsdorf

NRC_DataMart_Extracts:
alter procedure CEM.ExportPostProcess00000014

*/
use NRC_DataMart_Extracts
go
alter procedure CEM.ExportPostProcess00000014
@ExportQueueID int
as
begin
	-- patientsserved Unknown/Missing=M
	update CEM.ExportDataset00000014 
	set [header.patientsserved] = 'M'
	where [header.patientsserved] = ''
	and ExportQueueID = @ExportQueueID
	
	-- if a patient's sex doesn't fall into the gender binary or is missing, isMale will equal '0' but the patient's sex isn't Female. 
	-- check qualisys's study-owned population tables to see if all isMale='0' have SEX='F'. If not, recode patientgender to out-of-range 
	create table #sexcheck (samplepopulationid int, patientgender char(1), isMale bit, SurveyID int, Survey_id int, Study_id int, Samplepop_id int, Pop_id int, sex varchar(42))

	insert into #sexcheck (samplepopulationid, patientgender, ismale, surveyid)
	select sp.samplepopulationid, eds.[administration.patientgender], sp.ismale, su.surveyID
	from CEM.ExportDataset00000014 eds
	inner join NRC_Datamart.dbo.samplepopulation sp on sp.samplepopulationid=eds.samplepopulationid
	inner join NRC_Datamart.dbo.sampleset ss on sp.SampleSetID=ss.SampleSetID
	inner join NRC_Datamart.dbo.selectedsample sel on sp.SamplePopulationID=sel.SamplePopulationID
	inner join NRC_Datamart.dbo.sampleunit su on sel.sampleunitid=su.sampleunitid
	where eds.ExportQueueID=@ExportQueueID
	order by 1

	update sc set survey_id=css.survey_id, study_id=css.study_id
	from #sexcheck sc
	inner join nrc_datamart.etl.DataSourceKey dsk on sc.surveyid=dsk.DataSourceKeyID
	inner join qualisys.qp_prod.dbo.clientstudysurvey_view css on dsk.DataSourceKey = css.survey_id

	update sc set samplepop_id=dsk.DataSourceKey, pop_id=sp.pop_id
	from #sexcheck sc
	inner join nrc_datamart.etl.DataSourceKey dsk on sc.samplepopulationid=dsk.DataSourceKeyID
	inner join qualisys.qp_prod.dbo.samplepop sp on dsk.DataSourceKey = sp.samplepop_id

	declare @sql varchar(max), @study varchar(10)
	select top 1 @study=study_id from #sexcheck where sex is null
	while @@rowcount>0
	begin
		set @sql = 'update sc set sex=p.sex from #sexcheck sc inner join qualisys.qp_prod.s'+@study+'.population p on sc.study_id='+@study+' and sc.pop_id=p.pop_id'
		exec (@sql)
		update #sexcheck set sex='?' where sex is null and study_id=@study
		select top 1 @study=study_id from #sexcheck where sex is null
	end

	update #sexcheck set patientgender=char(7) where isMale=0 and sex <> 'F'
	update #sexcheck set patientgender='X' where sex is null
	
	update eds
	set [administration.patientgender]=sc.patientgender
	from CEM.ExportDataset00000014 eds
	inner join #sexcheck sc on sc.samplepopulationid=eds.samplepopulationid
	where [administration.patientgender]<>sc.patientgender


	-- administration.SurgicalCat coding
	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = NULL 
	WHERE  exportqueueid = @ExportQueueID 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '1' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN '40000' AND '49999' 
				  OR [administration.cpt4_2] BETWEEN '40000' AND '49999' 
				  OR [administration.cpt4_3] BETWEEN '40000' AND '49999' 
				  OR [administration.hcpcslvl2cd] IN ( 'G0105', 'G0121', 'G0104' ) 
				  OR [administration.hcpcslvl2cd_2] IN ( 'G0105', 'G0121', 'G0104' ) 
				  OR [administration.hcpcslvl2cd_3] IN ( 'G0105', 'G0121', 'G0104' ) ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '2' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN '20000' AND '29999' 
				  OR [administration.cpt4_2] BETWEEN '20000' AND '29999' 
				  OR [administration.cpt4_3] BETWEEN '20000' AND '29999' 
				  OR [administration.hcpcslvl2cd] IN ( 'G0260' ) 
				  OR [administration.hcpcslvl2cd_2] IN ( 'G0260' ) 
				  OR [administration.hcpcslvl2cd_3] IN ( 'G0260' ) ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '3' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
		   AND ( [administration.cpt4] BETWEEN '65000' AND '68899' 
				  OR [administration.cpt4_2] BETWEEN '65000' AND '68899' 
				  OR [administration.cpt4_3] BETWEEN '65000' AND '68899' ) 

	UPDATE CEM.ExportDataset00000014 
	SET    [administration.surgicalcat] = '4' 
	WHERE  exportqueueid = @ExportQueueID 
		   AND [administration.surgicalcat] IS NULL 
	
	-- administration.LagTime
	-- The number of calendar days between the date of eligible surgery/procedure and the date when this patient’s survey was initiated.
	update eds 
	set [administration.firstmailed]=convert(varchar,firstmailed,112)
	from CEM.ExportDataset00000014 eds
	inner join (select sc.samplepopulationid, min(datMailed) as firstMailed 
				from #sexcheck sc
				inner join qualisys.qp_prod.dbo.scheduledmailing scm on sc.samplepop_id=scm.samplepop_id
				inner join qualisys.qp_prod.dbo.sentmailing sm on scm.sentmail_id=sm.sentmail_id
				group by sc.samplepopulationid) q
			on eds.samplepopulationid=q.samplepopulationid
	where datediff(day,firstmailed,[administration.firstmailed]) <> 0

	update CEM.ExportDataset00000014 
	set [administration.lagtime]=datediff(day,[administration.servicedate],[administration.firstmailed])
	WHERE exportqueueid = @ExportQueueID 

	-- change surveymode to out-of-range if its value doesn't square with finalstatus
	-- surveymode should be 1 (Mail) for finalstatus=Completed Mail
	update eds
	set [administration.surveymode]=char(7)
	from CEM.ExportDataset00000014 eds
	where [administration.finalstatus] = '110'
	and [administration.surveymode] <> '1'
	and ExportQueueID = @ExportQueueID 

	-- surveymode should be 2 (Phone) for finalstatus=Completed Phone
	update eds
	set [administration.surveymode]=char(7)
	from CEM.ExportDataset00000014 eds
	where [administration.finalstatus] = '120'
	and [administration.surveymode] <> '2'
	and ExportQueueID = @ExportQueueID 

	-- surveymode should be 1 or 2 for finalstatus=Breakoff
	update eds
	set [administration.surveymode]=char(7)
	from CEM.ExportDataset00000014 eds
	where [administration.finalstatus] = '310'
	and [administration.surveymode] not in ('1','2')
	and ExportQueueID = @ExportQueueID 
	
	/*
	--Skip Pattern Coding
	--•	Keep all responses to follow-up questions, even if they should have been skipped
	--•	If the response to the screener question invokes the skip, and a follow-up question is blank,			code the follow-up “X” (not applicable)
	--•	If the response to the screener question does not invoke the skip, and a follow-up question is blank,	code the follow-up “M” (missing)
	--•	If the screener question is blank and a follow-up question is also blank,								code the follow-up “M” (missing)
	*/
	--                               set this question                        to an X if the skip was invoked, otherwise to an M               if the question wasn't otherwise answered					  and the survey was returned in the applicable mode(s)
	update cem.ExportDataset00000014 set [patientresponse.anesthesiaexplain]= case when [patientresponse.anesthesia]='2' then 'X' else 'M' end where [patientresponse.anesthesiaexplain] not in ('1','2','3') and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.anesthesiaside]	= case when [patientresponse.anesthesia]='2' then 'X' else 'M' end where [patientresponse.anesthesiaside] not in ('1','2','3')	  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID
	
	update cem.ExportDataset00000014 set [patientresponse.group]			= case when [patientresponse.ethnicity]	='2' then 'X' else 'M' end where [patientresponse.group] not in ('1','2','3','4')		  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID
	
	update cem.ExportDataset00000014 set [patientresponse.raceasianindian-phone]			= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.raceasianindian-phone]			<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racechinese-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racechinese-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racefilipino-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racefilipino-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racejapanese-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racejapanese-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racekorean-phone]					= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racekorean-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racevietnamese-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racevietnamese-phone]			<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceotherasian-phone]				= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.raceotherasian-phone]			<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racenoneofaboveasianindian-phone]	= case when [patientresponse.raceasian-phone]='M' then 'X' else 'M' end where [patientresponse.racenoneofaboveasianindian-phone]<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.racenativehawaiian-phone]		 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.racenativehawaiian-phone]		<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceguamanianchamorro-phone]	 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.raceguamanianchamorro-phone]	<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racesamoan-phone]				 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.racesamoan-phone]				<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.raceotherpacificislander-phone]= case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.raceotherpacificislander-phone]	<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.racenoneofabovepacific-phone]	 = case when [patientresponse.racenativehawaiianpacificislander-phone]='M' then 'X' else 'M' end where [patientresponse.racenoneofabovepacific-phone]	<> '1' and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode]='2' and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.speakotherspecify]= case when [patientresponse.speakother]='2' then 'X' else 'M' end where [patientresponse.speakotherspecify] not in ('1','2')	  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] in ('1','2') and ExportQueueID=@ExportQueueID

	update cem.ExportDataset00000014 set [patientresponse.helpread]			= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpread] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpwrote]		= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpwrote] <>'1' 						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpanswer]		= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpanswer] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helptranslate]	= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helptranslate] <>'1'					  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpother]		= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpother] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID
	update cem.ExportDataset00000014 set [patientresponse.helpnone]			= case when [patientresponse.help]		='2' then 'X' else 'M' end where [patientresponse.helpnone] <>'1'						  and [administration.finalstatus] IN ('110','120','310') and [administration.surveymode] ='1' and ExportQueueID=@ExportQueueID

	
	-- some questions are only fielded on mail the survey. code them "Not Applicable" for phone returns
	update cem.ExportDataset00000014  
	set [patientresponse.racewhite-mail]='X',
		[patientresponse.raceafricanamer-mail]='X',
		[patientresponse.raceamerindian-mail]='X',
		[patientresponse.raceasianindian-mail]='X',
		[patientresponse.racechinese-mail]='X',
		[patientresponse.racefilipino-mail]='X',
		[patientresponse.racejapanese-mail]='X',
		[patientresponse.racekorean-mail]='X',
		[patientresponse.racevietnamese-mail]='X',
		[patientresponse.raceotherasian-mail]='X',
		[patientresponse.racenativehawaiian-mail]='X',
		[patientresponse.raceguamanianchamorro-mail]='X',
		[patientresponse.racesamoan-mail]='X',
		[patientresponse.raceotherpacificislander-mail]='X',
		[patientresponse.help]='X',
		[patientresponse.helpread]='X',
		[patientresponse.helpwrote]='X',
		[patientresponse.helpanswer]='X',
		[patientresponse.helptranslate]='X',
		[patientresponse.helpother]='X',
		[patientresponse.helpnone]='X'
	where [administration.finalstatus] IN ('110','120','310')
	and [administration.surveymode]='2'
	and ExportQueueID=@ExportQueueID

	-- some questions are only fielded on the phone survey. code them "Not Applicable" for mail returns
	update cem.ExportDataset00000014  
	set [patientresponse.racewhite-phone]='X',
		[patientresponse.raceafricanamer-phone]='X',
		[patientresponse.raceamerindian-phone]='X',
		[patientresponse.raceasian-phone]='X',
		[patientresponse.racenativehawaiianpacificislander-phone]='X',
		[patientresponse.racenoneofabove-phone]='X',
		[patientresponse.raceasianindian-phone]='X',
		[patientresponse.racechinese-phone]='X',
		[patientresponse.racefilipino-phone]='X',
		[patientresponse.racejapanese-phone]='X',
		[patientresponse.racekorean-phone]='X',
		[patientresponse.racevietnamese-phone]='X',
		[patientresponse.raceotherasian-phone]='X',
		[patientresponse.racenoneofaboveasianindian-phone]='X',
		[patientresponse.racenativehawaiian-phone]='X',
		[patientresponse.raceguamanianchamorro-phone]='X',
		[patientresponse.racesamoan-phone]='X',
		[patientresponse.raceotherpacificislander-phone]='X',
		[patientresponse.racenoneofabovepacific-phone]='X'
	where [administration.finalstatus] IN ('110','120','310')
	and [administration.surveymode]='1'
	and ExportQueueID=@ExportQueueID

	-- if a respondent returned the survey but didn't answer a multiple response question at all and all responses are still blank, code all responses to 'M'
	select distinct ExportTemplateColumnID, ExportTemplateSectionName, [ExportColumnName.MR], isnull(RawValue,'') as RawValue, RecodeValue, FixedWidthLength
	into #unansweredMR
	from cem.ExportTemplate_view
	where exportTemplateId=14
	and [ExportColumnName.MR] is not null 

	declare @sqlwhere varchar(max)	
	declare @etcID int
	select top 1 @etcID=ExportTemplateColumnID from #unansweredMR where RawValue=-9
	while @@rowcount>0
	begin
		set @sql='update CEM.ExportDataset00000014 set '
		set @SQLwhere = 'ExportQueueID='+convert(varchar,@ExportQueueID)+' and [administration.finalstatus] IN (''110'',''120'',''310'') and len('
		select @sql = @sql + '['+ExportTemplateSectionName+'.'+[ExportColumnName.MR]+']=''M'','
			, @sqlwhere=@sqlwhere + '['+ExportTemplateSectionName+'.'+[ExportColumnName.MR]+']+'
		from #unansweredMR
		where ExportTemplateColumnID = @etcID
		and [ExportColumnName.MR] <> 'unmarked'

		set @sqlwhere = left(@sqlwhere,len(@sqlwhere)-1) + ')=0'
		set @sql = left(@sql,len(@sql)-1) + ' where ' + @sqlwhere + char(10)
		
		print @SQL
		if len(@Sql)>8000 print '~'+substring(@sql,8001,7000)
		exec (@SQL)
		
		delete from #unansweredMR where ExportTemplateColumnID = @etcID
		select top 1 @etcID=ExportTemplateColumnID from #unansweredMR where RawValue=-9
	end

	drop table #unansweredMR
	
end
go