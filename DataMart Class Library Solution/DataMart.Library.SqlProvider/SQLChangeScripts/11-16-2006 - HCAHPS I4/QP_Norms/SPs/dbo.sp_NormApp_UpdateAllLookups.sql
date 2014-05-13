set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO







/********************************************************************************
	sp_NormAPP_UpdateAllLookups

	Description:
		This SP will update all non survey results tables with the latest info
	input: 
		none

	output:
		none
	
	History:
		April 13, 2005 DC Created
		June 30, 2005 DC Changed to remove client_id from suFacility and
					  removed hard coded server names
		Nov. 15, 2006 DC Made changes for scale order enhancements

********************************************************************************/
ALTER     procedure [dbo].[sp_NormAPP_UpdateAllLookups]
as

declare @sql varchar(5000), @server varchar(100)

SELECT @Server=substring(strParam_Value,1,len(strParam_Value)-1) FROM qp_comments.dbo.DataMart_Params WHERE strParam_nm='QualPro Server'

truncate table [SUFacility]

set @sql='
INSERT INTO [QP_Norms].[dbo].[SUFacility]([suFacility_ID], [strFacility_nm], [City], [State], [Country], [Region_id], [AdmitNumber], [BedSize], [bitPeds], [bitTeaching], [bitTrauma], [bitReligious], [bitgovernment], [bitRural], [bitForProfit], [bitRehab], [bitCancerCenter], [bitPicker], [bitFreeStanding], [AHA_id])
SELECT [SUFacility_id], [strFacility_nm], [City], [State], [Country], [Region_id], [AdmitNumber], [BedSize], [bitPeds], [bitTeaching], [bitTrauma], [bitReligious], [bitgovernment], [bitRural], [bitForProfit], [bitRehab], [bitCancerCenter], [bitPicker], [bitFreeStanding], [AHA_id]
FROM openquery(' + @Server +',''select * from qp_prod.dbo.suFacility'')'

exec (@sql)

truncate table [SampleUnitService]


set @sql='INSERT INTO SampleUnitService (SampleUnitService_id,SampleUnit_id,Service_id,strAltService_nm)
SELECT SampleUnitService_id,SampleUnit_id,Service_id,strAltService_nm
FROM openquery(' + @Server +',''select * from qp_prod.dbo.SampleUnitService'')'

exec (@sql)


truncate table [Service]


set @sql='INSERT INTO [QP_Norms].[dbo].[Service]([Service_id], [ParentService_id], [strService_nm])
SELECT [Service_id], [ParentService_id], [strService_nm]
FROM openquery(' + @Server +',''select * from qp_prod.dbo.Service'')'

exec (@sql)


truncate table [SampleUnit]

set @sql='INSERT INTO [QP_Norms].[dbo].[SampleUnit]([SampleUnit_ID], [ParentSampleUnit_ID], [strSampleUnit_NM], [Survey_id], [study_id], [suFacility_ID],
		[bitHCAHPS])
SELECT s.SampleUnit_ID, s.ParentSampleUnit_ID, s.strSampleUnit_NM, s.Survey_id, s.study_id, su.suFacility_ID, su.bitHCAHPS
FROM qp_comments.dbo.sampleunit s left join openquery(' + @Server +',''select * from qp_prod.dbo.sampleunit'') su
on s.sampleunit_id=su.sampleunit_id'

exec (@sql)

update sampleunit
set sufacility_id=null
where sufacility_id=0

update sampleunit
set bitHCAHPS=0
where bitHCAHPS is null

select distinct client_id, country_id
into #countries
from [QP_Norms].[dbo].[ClientStudySurvey]

truncate table [ClientStudySurvey]

INSERT INTO [QP_Norms].[dbo].[ClientStudySurvey]([strClient_NM], [strStudy_NM], [strSurvey_NM], [Client_ID], [Study_ID], [Survey_ID], [bitHasResults], [bitPicker], [AD])
SELECT [strClient_NM], [strStudy_NM], [strSurvey_NM], [Client_ID], [Study_ID], [Survey_ID], [bitHasResults], [bitPicker], [AD]
FROM qp_comments.dbo.clientstudysurvey (nolock)

update css
set country_id= c.country_id
from [QP_Norms].[dbo].[ClientStudySurvey] css (nolock), #countries c
where css.client_id=c.client_id


--Picker flag
	update clientstudysurvey
	set bitPicker=0
	
	--Questions with core numbers lower than 8000 are legacy questions
	select distinct qstncore
	into #pScorequestions
	from qp_comments.dbo.lu_problem_score
	where qstncore >8000 and
		problem_score_flag in (0,1)
	
	create index qstncore on #pScorequestions (qstncore)
	
	select survey_id, count(distinct q2.qstncore) as questioncount
	into #pickerSurveys
	from #pScorequestions q1, qp_comments.dbo.questions q2
	where q1.qstncore=q2.qstncore
	group by survey_id
	having count(distinct q2.qstncore) >=10
		
	update css 
	set bitPicker=1
	from clientstudysurvey css (nolock), #pickerSurveys ps
	where css.survey_id=ps.survey_Id



truncate table [questions]


INSERT INTO [QP_Norms].[dbo].[questions]([survey_id], [scaleid], [label], [qstncore], [numMarkCount], [bitMeanable])
SELECT [survey_id], [scaleid], [strquestionlabel], [qstncore], [numMarkCount], [bitMeanable]
FROM qp_comments.dbo.questions (nolock)
WHERE strfullquestion is not null


truncate table [scales]


INSERT INTO [QP_Norms].[dbo].[scales]([survey_id], [scaleid], [val], [label], [bitMissing])
SELECT [survey_id], [scaleid], [val], [strscalelabel], [bitMissing]
FROM qp_comments.dbo.scales (nolock)
where strscalelabel is not null

truncate table [QuestionVals]

INSERT INTO [QP_Norms].[dbo].[QuestionVals]([qstncore], [Report_Text], [val], [Response_Label], [max_ScaleOrder], [ScaleOrder],[bitMeanable])
SELECT q.qstncore, q.label as Report_Text, sc.val, sc.label, isnull(max.max_scaleorder,-9), isnull(rro.rankorder,-1), q.bitMeanable
FROM (SELECT qstncore, max(survey_id) as survey_id
		 FROM questions (nolock) 
		 GROUP BY qstncore) qs join questions q (nolock)
	 on qs.survey_id=q.survey_id and
		qs.qstncore=q.qstncore
	join scales sc (nolock)
	on 	q.survey_id=sc.survey_id and
		q.scaleid=sc.scaleid and
		sc.label is not null and
		sc.val <>-10 and 
		sc.bitmissing=0
	left join qp_comments.dbo.responserankorder rro
	on q.qstncore=rro.qstncore 
		and sc.val=rro.val
	left join (select qstncore, max(rankorder) as max_scaleorder from qp_comments.dbo.responserankorder group by qstncore having max(rankorder)>0) max
	on q.qstncore=max.qstncore
ORDER BY q.qstncore, sc.val

	select n.qstncore
	into #multiuserquestions
	from unitcores n (nolock), sampleunit s (nolock), clientstudysurvey css (nolock)
	where n.sampleunit_id=s.sampleunit_id and
		s.survey_id=css.survey_id
	group by n.qstncore
	having count(distinct client_id)>1
union
	select qstncore
	from questiongroupmembers (nolock)

update qv
set bitMultipleClientUse=1
from QuestionVals qv (nolock), #multiuserquestions m
where qv.qstncore=m.qstncore

update QuestionVals
set bitProbScore=1
from QuestionVals q (nolock), lu_problem_score ps (nolock)
where q.qstncore=ps.qstncore and
	ps.problem_score_flag <>9

truncate table [QuestionScaleCombos]

INSERT INTO [QP_Norms].[dbo].[QuestionScaleCombos]([qstncore], [scaleid], [val], [max_ScaleOrder], [ScaleOrder])
SELECT q.qstncore, q.scaleid, sc.val, isnull(max.max_scaleorder,-9), isnull(rankorder,-1)
FROM  (SELECT qstncore, max(survey_id) as survey_id
	 FROM questions (nolock) 
	 GROUP BY qstncore) qs join questions q (nolock)
	 on qs.survey_id=q.survey_id and
		qs.qstncore=q.qstncore
	join scales sc (nolock)
	on 	q.survey_id=sc.survey_id and
		q.scaleid=sc.scaleid and
		sc.label is not null and
		sc.val <>-10 and 
		sc.bitmissing=0
	left join qp_comments.dbo.responserankorder rro
	on q.qstncore=rro.qstncore 
		and sc.val=rro.val
	left join (select qstncore, max(rankorder) as max_scaleorder from qp_comments.dbo.responserankorder group by qstncore having max(rankorder)>0) max
	on q.qstncore=max.qstncore

truncate table [Region]

set @sql='INSERT INTO [QP_Norms].[dbo].[Region]([Region_id], [strRegion_nm])
SELECT [Region_id], [strRegion_nm]
FROM openquery(' + @Server +',''select * from qp_prod.dbo.region'')'

exec (@sql)


truncate table [lu_problem_score]


INSERT INTO lu_problem_score (qstncore, val, problem_score_flag)
SELECT qstncore, val, problem_score_flag
FROM qp_comments.dbo.lu_problem_score



--Create a table for services that has each column as a service
if exists (select * from dbo.sysobjects where id = object_id(N'[unitservices]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
truncate table [unitservices]

insert into unitservices (sampleunit_id)
select sampleunit_id
from sampleunit (nolock)

declare @service_id int, @column varchar(100)

select s1.service_id, s2.strservice_nm + ' - ' + s1.strservice_nm as strservice_nm, 'bit'+ replace(s2.strservice_nm,'/','') + replace(s1.strservice_nm,'/','') as column_name
into #services
from service s1, service s2
where s1.parentservice_id=s2.service_id
union
select service_id, strservice_nm + ' - Overall', 'bit'+ replace(strservice_nm,'/','') + 'Overall'
from service
where parentservice_id is null and
	service_id <> 0
union
select service_id, strservice_nm, 'bit'+replace(strservice_nm,'/','') 
from service
where service_id = 0

update #services
set column_name=replace(column_name, ' ','')

select column_name
into #Columns
from #services
where service_id not in 
	(select service_id
		from serviceIDLookup)

insert into serviceIDLookup
select *
from #services
where service_id not in 
	(select service_id
		from serviceIDLookup)

select top 1 @column=column_name
from #columns

while @@rowcount >0
Begin

	set @sql='alter table unitservices
				add ' + @column +' bit Not Null default 0'

	--print @sql
	exec (@sql)

	delete 
	from #columns
	where column_name=@column

	select top 1 @column=column_name
	from #columns

End

select top 1 @service_id=service_id, @column=column_name
from #services

While @@rowcount >0
Begin
	
	set @sql='update u 
				set ' + @column +'=1
				from unitservices u (nolock), sampleunitservice ss (nolock)
				where u.sampleunit_id=ss.sampleunit_Id and
					ss.service_id=' + convert(varchar,@service_id) 

	exec (@sql)

	delete 
	from #services
	where service_id=@service_id

	select top 1 @service_id=service_id, @column=column_name
	from #services

End

drop table #Columns
drop table #services


















