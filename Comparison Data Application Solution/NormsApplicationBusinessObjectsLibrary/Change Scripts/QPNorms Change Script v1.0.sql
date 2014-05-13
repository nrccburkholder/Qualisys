alter table [SUFacility]
	drop column client_id

go
--------------------------------------------------------------------------------------------------------------
go

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

********************************************************************************/
ALTER     procedure [dbo].[sp_NormAPP_UpdateAllLookups]
as

declare @sql varchar(5000), @server varchar(100)

SELECT @Server=strParam_Value FROM qp_comments.dbo.DataMart_Params WHERE strParam_nm='QualPro Server'


truncate table [SUFacility]

set @sql='
INSERT INTO [QP_Norms].[dbo].[SUFacility]([suFacility_ID], [strFacility_nm], [City], [State], [Country], [Region_id], [AdmitNumber], [BedSize], [bitPeds], [bitTeaching], [bitTrauma], [bitReligious], [bitgovernment], [bitRural], [bitForProfit], [bitRehab], [bitCancerCenter], [bitPicker], [bitFreeStanding], [AHA_id])
SELECT [SUFacility_id], [strFacility_nm], [City], [State], [Country], [Region_id], [AdmitNumber], [BedSize], [bitPeds], [bitTeaching], [bitTrauma], [bitReligious], [bitgovernment], [bitRural], [bitForProfit], [bitRehab], [bitCancerCenter], [bitPicker], [bitFreeStanding], [AHA_id]
FROM ' + @Server +'qp_prod.dbo.suFacility'

exec (@sql)

truncate table [SampleUnitService]


set @sql='INSERT INTO SampleUnitService (SampleUnitService_id,SampleUnit_id,Service_id,strAltService_nm)
SELECT SampleUnitService_id,SampleUnit_id,Service_id,strAltService_nm
FROM ' + @Server +'qp_prod.dbo.SampleUnitService'

exec (@sql)


truncate table [Service]


set @sql='INSERT INTO [QP_Norms].[dbo].[Service]([Service_id], [ParentService_id], [strService_nm])
SELECT [Service_id], [ParentService_id], [strService_nm]
FROM ' + @Server +'qp_prod.dbo.Service'

exec (@sql)


truncate table [SampleUnit]

set @sql='INSERT INTO [QP_Norms].[dbo].[SampleUnit]([SampleUnit_ID], [ParentSampleUnit_ID], [strSampleUnit_NM], [Survey_id], [study_id], [suFacility_ID],
		[bitHCAHPS])
SELECT s.SampleUnit_ID, s.ParentSampleUnit_ID, s.strSampleUnit_NM, s.Survey_id, s.study_id, su.suFacility_ID, su.bitHCAHPS
FROM qp_comments.dbo.sampleunit s left join ' + @Server +'qp_prod.dbo.sampleunit su
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


INSERT INTO [QP_Norms].[dbo].[scales]([survey_id], [scaleid], [val], [label], [bitMissing], [max_ScaleOrder], [ScaleOrder])
SELECT [survey_id], [scaleid], [val], [strscalelabel], [bitMissing], [max_ScaleOrder], [ScaleOrder]
FROM qp_comments.dbo.scales (nolock)
where strscalelabel is not null

--Reverse ScaleOrder for scales identified as needing to be reversed
update s
set scaleorder=max_scaleorder-scaleorder+1
from scales s (nolock), qp_comments.dbo.lu_reversescaleorder rsc (nolock)
where s.scaleid=rsc.scaleid

--Reverse ScaleOrder for some of the standard scales
update s
set scaleorder=max_scaleorder-scaleorder+1
from scales s (nolock), (select scaleid from scales (nolock) 
				where scaleorder=1 and (label ='Poor' or label='No') and
					scaleid not in (select scaleid 
							from qp_comments.dbo.lu_reversescaleorder (nolock))) sc
where s.scaleid=sc.scaleid

--Update bad scaleorder values
create table #reorder (id int identity(1,1), survey_id int, scaleid int, val int, scaleorder tinyint, max_scaleorder tinyint)

insert into #reorder (survey_id, scaleid, val, scaleorder, max_scaleorder)
select q.survey_id, q.scaleid, q.val, q.scaleorder, q.max_scaleorder
from scales q (nolock), (
	select distinct survey_id, scaleid
	from scales (nolock)
	where scaleorder>max_scaleorder) m
where q.survey_Id=m.survey_id and
		q.scaleid=m.scaleid 		
order by q.survey_Id, q.scaleid, q.scaleorder

update q
set scaleorder=ID-minID
from scales q (nolock),
	(select survey_id, scaleid, min(ID) as minID, max(ID) as maxID
	 	from #reorder
		group by survey_id, scaleid) m,
	#reorder r
where q.survey_Id=m.survey_id and
		q.scaleid=m.scaleid and
		q.val=r.val and
		m.survey_id=r.survey_id and
		m.scaleid=r.scaleid

update q
set q.scaleorder=q.scaleorder + 1
from scales q (nolock), (
	select distinct survey_id, scaleid
	from scales (nolock)
	where scaleorder=0) m
where q.survey_id=m.survey_id and
		q.scaleid=m.scaleid
drop table #reorder

truncate table [QuestionVals]


INSERT INTO [QP_Norms].[dbo].[QuestionVals]([qstncore], [Report_Text], [val], [Response_Label], [max_ScaleOrder], [ScaleOrder],[bitMeanable])
SELECT q.qstncore, q.label as Report_Text, sc.val, sc.label, max_scaleorder, scaleorder, q.bitMeanable
FROM (SELECT qstncore, max(survey_id) as survey_id
	 FROM questions (nolock) 
	 GROUP BY qstncore) qs, questions q (nolock), scales sc (nolock)
WHERE qs.survey_id=q.survey_id and
	qs.qstncore=q.qstncore and
	q.survey_id=sc.survey_id and
	q.scaleid=sc.scaleid and
	sc.label is not null and
	sc.val <>-10 and 
	sc.bitmissing=0
ORDER BY q.qstncore, val


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
SELECT q.qstncore, q.scaleid, sc.val, max_scaleorder, scaleorder
FROM (SELECT qstncore, scaleid, max(survey_id) as survey_id
	 FROM questions (nolock)
	 GROUP BY qstncore, scaleid) qr,
		questions q (nolock), scales sc (nolock)
WHERE qr.qstncore=q.qstncore and
	qr.scaleid=q.scaleid and
	qr.survey_id=q.survey_id and
	q.survey_id=sc.survey_id and
	q.scaleid=sc.scaleid and
	sc.Label is not null and
	sc.val <>-10



truncate table [Region]


set @sql='INSERT INTO [QP_Norms].[dbo].[Region]([Region_id], [strRegion_nm])
SELECT [Region_id], [strRegion_nm]
FROM ' + @Server +'qp_prod.dbo.region'

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


go
---------------------------------------------------------------------------------------
go
set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO


/*****************************************************************************
	SP_NormApp_Master

	Description:  This Stored Procedure will drive the norms application

	input: 
		@queue_id - This is the ID number for the request to be worked on



******************************************************************************/
ALTER                                             PROCEDURE [dbo].[SP_NormApp_Master] 
	@whereclause varchar(7500) = null,
	@mindate datetime = null,
	@maxdate datetime = null,
	@measuretype tinyint = null,
	@groupingtype smallint = null,
	@requestType tinyint = null,
	@bitFacility bit = 0,
	@bitMinimumClientCheck 	bit = 1,
	@qstncores varchar(1000) = null,
	@dimensions varchar(1000) = null,
	@norm_id int = null,
	@UserID int=null
as
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
declare @sql varchar(8000), @bitPercentilesType bit, 
		@bitunits bit, @bitQuestions bit, @bitDimensions bit,
		@startime datetime, @quarterend datetime

if @measuretype is null
	select @measuretype=measuretype_id
		from groupings
		where grouping_id=@groupingtype

exec sp_normApp_timer 1, 'Starting Norm Request'

select @quarterend=max(maxdate)
from quarterlytableslookup

if @requesttype in (2,3,4,5) and @qstncores is null and @dimensions is null and @whereclause is null
	begin
		RAISERROR ('If you do not specify a filter, then you must provide a list of questions or dimensions.', 16, 1)
		Return
	End

if (@mindate is not null and @maxdate is null) or (@mindate is null and @maxdate is not null)
	begin
		RAISERROR ('You must specify both a minimum and maximum date.', 16, 1)
		Return
	End
if @norm_id is not null
Begin
	set @requestType=6
	select @bitMinimumclientcheck=bitMinClientCheck,
			@whereclause=isnull(criteriastmt,'1=1')
	from dbo.normsettings_staging
	where norm_id=@norm_id

	if @mindate is null
		select @mindate=dateadd(mi,1,dateadd(mm,-1*monthspan, @quarterend)),
				@maxDate=@quarterend
		from dbo.normsettings_staging
		where norm_id=@norm_id

	--Special code for Memphis TLC norm
	if exists (select 1 from normsettings_staging where norm_id=@norm_id and normlabel = 'Memphis#TLC PHY')
	begin
		exec sp_NormAPP_MemphisTLC @mindate, @maxDate
	
		--Run finalize SP for each norm
		exec sp_normApp_timer 0, 'Starting finalize Norm'
		
		exec NRM_CM_FinalizeNorm @norm_ID
		
		exec sp_normApp_timer 0, 'Ending finalize Norm'
		
		insert into NormsUpdateLog (norm_id) values (@norm_id)
		exec sp_normApp_timer 0, 'Ending SP_NormApp_BuildNorm'
		
		update dbo.normsettings_staging
		set updatedate=getdate(),
			updatedby=@userID
		where norm_id=@norm_id
	
		return
	end

End

--Create all Temp Tables
	create table #questions (questiongroup_id int, qstncore int, bitSelected bit)
	create clustered index qsntcore on #questions (qstncore)	
	Create table #TempQuestions (questiongroup_id int, qstncore int, bitSelected bit)
	create clustered index qsntcore on #TempQuestions (qstncore)	
	create table #dimensions (dimension_id int, questiongroup_id int, qstncore int)
	create index qsntcore on #dimensions (qstncore)	
	create table #units (group_id int, sampleunit_id int)
	create clustered index sampleunit_id on #units (sampleunit_id)
	create table #Questionresults (group_id int, questiongroup_id int, qstncore int, val int, nsize int, bitdelete bit default 0)
	create table #Dimensionresults (group_id int, dimension_id int, questiongroup_id int, qstncore int, val int, nsize int, bitdelete bit default 0)
	Create table #Labels (qstncore int, [Report Text] varchar(60))
	create index qstncore on #Labels (qstncore)
	create table #PercentLabels (bitDimension bit, ID int, Label varchar(500))
	create index ID on #PercentLabels (ID)
	create table #UnitListScores (UniqueID int identity(1,1), group_id int, bitDimension bit, ID int, nsize int, score decimal(12,5))
	create index group_id on #UnitListScores (group_id) 

	create table #Percentiles1to100 (bitDimension bit, ID int, score decimal(12,5), percentile int)
	create table #PercentilesList (group_id int, bitDimension bit, ID int, nsize int, score decimal(12,5), percentile decimal(12,5))
	create index ID on #PercentilesList (ID)
	create table #Questiongroupmembers (questiongroup_id int)
	create table #Dimensiongroupmembers (dimension_Id int, questiongroup_id int)
	create table #questionvals (qstncore int, report_text varchar(60), bitmeanable bit, bitprobscore bit, bitmultipleclientuse bit)


	insert into #questionvals
	select distinct qstncore, report_text, bitmeanable, bitprobscore, bitmultipleclientuse
	from questionvals

	create clustered index qstncore on #questionvals (qstncore)

--Populate Questions and Dimensions tables
if @qstncores is not null --or (@dimensions is null and @qstncores is null)
Begin
	exec SP_NormApp_PopulateQuestionsTable @qstncores, @measuretype, @groupingtype, @bitMinimumClientCheck, @norm_id
	set @bitQuestions=1
END
Else set @bitQuestions=0
	
--Demographic count information
if @RequestType=1 
BEGIN
	exec SP_NormApp_DemographicCounts @whereclause, @qstncores, @mindate, @maxdate
	Return
END

if @dimensions is not null
Begin
	exec SP_NormApp_PopulateDimensionsTable @dimensions, @bitDimensions
	set @bitDimensions=1
END
Else set @bitDimensions=0

--Populate Units table if needed
if @whereclause is not null or @bitFacility=1
Begin
	set @bitunits=1
	if @bitunits=1 exec SP_NormApp_GatherUnits @whereclause, @bitFacility, @bitQuestions, @bitDimensions
End	
else set @bitunits=0

--Build a questions list if none supplied
if @bitQuestions=0 and @bitDimensions=0 and @bitUnits=1
Begin
	if @norm_id is null
		insert into #questions
		select distinct qgm.questiongroup_id, u.qstncore, 1
		from unitcores u join #units u2
		 	on u.sampleunit_id=u2.sampleunit_id 
			left join QuestionGroupMembers qgm
			on u.qstncore=qgm.qstncore
			left join QuestionGroups qg
			on qgm.questiongroup_id=qg.questiongroup_id
				and qg.norm_id is null
	else 
		insert into #questions
		select distinct qgm.questiongroup_id, u.qstncore, 1
		from unitcores u join #units u2
		 	on u.sampleunit_id=u2.sampleunit_id 
			left join (
				select qgm.*
				from QuestionGroupMembers qgm, QuestionGroups qg
				where qgm.questiongroup_id=qg.questiongroup_id and
				   (qg.norm_id is null or
					qg.norm_id=@norm_id)) qgm
				on u.qstncore=qgm.qstncore
		order by u.qstncore 

	--Add group members that weren't added above
	insert into #questions
	select distinct qg.questiongroup_id, qg.qstncore, 1
	from (select distinct qgm.questiongroup_id, qgm.qstncore
			from #questions q, QuestionGroupMembers qgm
			where q.questiongroup_id=qgm.questiongroup_id) qg
		left join #questions q
		on q.questiongroup_id=qg.questiongroup_id and
			q.qstncore=qg.qstncore
	where q.qstncore is null

	set @bitQuestions=1

End
Else if @bitQuestions=0 and @bitDimensions=0 and @bitunits=0
Begin
	if @norm_id is null
		insert into #questions
		select distinct qgm.questiongroup_id, qv.qstncore, 1
		from #questionvals qv left join QuestionGroupMembers qgm
			on qv.qstncore=qgm.qstncore
			left join Questiongroups qg
			on qgm.questiongroup_id=qg.questiongroup_id
				and qg.norm_id is null
	else 
		insert into #questions
		select distinct qgm.questiongroup_id, qv.qstncore, 1
		from #questionvals qv 
			left join (
				select qgm.*
				from QuestionGroupMembers qgm, QuestionGroups qg
				where qgm.questiongroup_id=qg.questiongroup_id and
				   (qg.norm_id is null or
					qg.norm_id=@norm_id)) qgm
				on qv.qstncore=qgm.qstncore
		order by qv.qstncore 

	--Add group members that weren't added above
	insert into #questions
	select distinct qg.questiongroup_id, qg.qstncore, 1
	from (select distinct qgm.questiongroup_id, qgm.qstncore
			from #questions q, QuestionGroupMembers qgm
			where q.questiongroup_id=qgm.questiongroup_id) qg
		left join #questions q
		on q.questiongroup_id=qg.questiongroup_id and
			q.qstncore=qg.qstncore
	where q.qstncore is null
	
	set @bitQuestions=1
End

--Check for any questions that are part of more than 1 questiongroup and assign
--all members of each group a common ID number
update tq
set questiongroup_id=keepergroup
from #questions tq, 
	(select q.questiongroup_id, k.keeperGroup
	from (select qstncore, min(questiongroup_id) as keeperGroup
		from #questions
		where questiongroup_id is not null
		group by qstncore
		having count(questiongroup_id)>1) k,
		#questions q
	where k.qstncore=q.qstncore) k
where tq.questiongroup_id=k.questiongroup_id

select distinct *
into #dedupquestions
from #questions

truncate table #questions

insert into #questions
select *
from #dedupQuestions

--Cleanup unneeded questions
if @bitMinimumClientCheck=1
	delete q
	from #questions q, #questionvals qv
	where q.qstncore=qv.qstncore and
		bitMultipleClientUse=0 and
		q.qstncore not in 
			(select qstncore
				from questiongroupmembers)

--Remove questions that aren't meanable if the grouping type is mean
if @groupingType=0
	delete q
	from #questions q, #questionvals qv
	where q.qstncore=qv.qstncore and
		bitmeanable=0
--Remove non-problem score questions if the grouping type is % problem or % positive
if @groupingType in (998,999)
	delete q
	from #questions q, #questionvals qv
	where q.qstncore=qv.qstncore and
		bitprobscore=0

--Loop Through the code several question as a time

--Create a master copy of the questions list

insert into #tempQuestions
select *
from #Questions

truncate table #questions

--Originally designed to loop through a specified number of questions at a time.  It no longer does that.
--It should not be written that way again.
insert into #questions
select *
from #tempQuestions

While @@rowcount >0 or @bitDimensions=1
Begin
	--Get Study Results data
	exec SP_NormApp_GatherStudyResults @mindate, @maxdate, @bitunits, @bitQuestions, @bitDimensions, @bitMinimumClientCheck

	--Perform MinimumClient Check if necessary.  This step also must be repeated in percentiles
	--After other business rules are enforced.
	--We previously have removed questions that are not multiuser questions.  However,
	--we still need to check again to see if the specific demographics of this query have
	--caused a multiuser question to only include one client's data
	IF @bitMinimumClientCheck=1
	BEGIN
		exec sp_normApp_timer 0, 'Starting Mimimum client check'

		--Initially only create indexes need for deleting
		Create index qstncore on #questionresults (qstncore)

		Create index dimension_id on #dimensionresults (dimension_id)
		Create index group_id on #questionresults (group_id)
		Create index group_id on #dimensionresults (group_id)
		IF @bitFacility=1
		BEGIN
			delete p
			from #questionresults p, 
				(select coalesce(1000000+questiongroup_id, qstncore) as IDNum
				 from #questionresults p, facilityservicesview sf
				 where p.group_id=sf.sufacility_id 
				 group by coalesce(1000000+questiongroup_id, qstncore) 
				 having count(distinct client_id) < 2) pl
			where coalesce(1000000+p.questiongroup_id, p.qstncore)=pl.IDNum
	
			delete p
			from #dimensionresults p, 
				(select dimension_id, coalesce(1000000+questiongroup_id, p.qstncore) as IDNum
				 from (select distinct group_id, dimension_Id, questiongroup_id, qstncore
						from #dimensionresults) p, facilityservicesview sf
				 where p.group_id=sf.sufacility_id
				 group by dimension_id, coalesce(1000000+questiongroup_id, p.qstncore)
				 having count(distinct client_id) < 2) pl
			where p.dimension_id=pl.dimension_id and
				 	coalesce(1000000+questiongroup_id, p.qstncore)=pl.IDNum
		END
		ELSE
		BEGIN 
			delete p
			from #questionresults p, 
				(select coalesce(1000000+questiongroup_id, qstncore) as IDNum
				 from #questionresults p, sampleunit s, clientstudysurvey css
				 where p.group_id=s.sampleunit_id and
						s.survey_id=css.survey_id
				 group by coalesce(1000000+questiongroup_id, qstncore)
				 having count(distinct client_id) < 2) pl
			where coalesce(1000000+p.questiongroup_id, p.qstncore)=pl.IDNum
	
			delete p
			from #dimensionresults p, 
				(select dimension_id, coalesce(1000000+questiongroup_id, p.qstncore) as IDNum
				 from (select distinct group_id, dimension_Id, questiongroup_id, qstncore
						from #dimensionresults) p, sampleunit s, clientstudysurvey css
				 where p.group_id=s.sampleunit_id and

						s.survey_id=css.survey_id
				 group by dimension_id, coalesce(1000000+questiongroup_id, p.qstncore)
				 having count(distinct client_id) < 2) pl
			where p.dimension_id=pl.dimension_id and
				 	coalesce(1000000+questiongroup_id, p.qstncore)=pl.IDNum
		END
		drop index #questionresults.group_id
		drop index #dimensionresults.group_id

		exec sp_normApp_timer 0, 'Ending Mimimum client check'
	END	
	--Create indexes after populating
	create index coreval on #questionresults (qstncore, val)
	create index coreval on #Dimensionresults (qstncore, val)

	--set the percentiles type variable 0=1 to 100 pcts, 1 = list
	if @requestType in (4,6) set @bitPercentilesType=0
		else if @requestType=5 set @bitPercentilesType=1
	
	--Get labels for Percent measure types
	if @measureType=2 exec SP_NormAPP_GetPercentLabels @GroupingType
	
	IF @RequestType in (3,4,5,6) 
		insert into #Labels (qstncore, [Report Text])
		select distinct q.qstncore, q.Report_Text
		from #questionvals q, #questions qs
		where q.qstncore=qs.qstncore

	--Breakout information
	if @RequestType=2 
		exec SP_NormApp_Breakouts
	--Average Scores
	Else IF @RequestType=3
		exec SP_NormApp_Averages @measuretype, @groupingType
	--Percentiles
	Else IF @RequestType in (4,5)
	Begin
		create index groupcore on #questionresults (group_id, qstncore)
		exec SP_NormApp_Percentiles @measuretype, @groupingType, @bitPercentilesType, @bitFacility, @bitMinimumClientCheck, @requestType
		drop index #questionresults.groupcore
	END

	--Creating Norms
	Else IF @RequestType=6 
	Begin
		create index groupcore on #questionresults (group_id, qstncore)
		exec SP_NormApp_BuildNorm @bitFacility, @bitMinimumClientCheck, @requestType, @norm_id, @UserID
		drop index #questionresults.groupcore
	End

	truncate table #questionResults
	truncate table #DimensionResults
	truncate table #Dimensions
	--truncate table #units
	truncate table #Labels
	truncate table #PercentLabels
	truncate table #UnitListScores
	truncate table #Percentiles1to100
	truncate table #PercentilesList
	drop index #questionresults.coreval
	drop index #Dimensionresults.coreval
	IF @bitMinimumClientCheck=1
	Begin
		drop index #questionresults.qstncore
		drop index #Dimensionresults.dimension_id
	End


	--All dimensions are run the first time through the loop
	set @bitDimensions=0

	delete t 
	from #tempQuestions t, #questions q
	where t.qstncore=q.qstncore

	truncate table #questions

	insert into #questions
	select *
	from #tempQuestions

End

exec sp_normApp_timer 0, 'Ending Norm Request'

--select *
--from normAPP_keeptiming


go
---------------------------------------------------------------------------------------
go

set ANSI_NULLS ON
set QUOTED_IDENTIFIER OFF
GO



























/*****************************************************************************
	SP_NormApp_Percentiles

	Description:  This Stored Procedure will produce percentiles 

	input: 
		@queue_id - This is the ID number for the request to be worked on



******************************************************************************/
ALTER                                                                PROCEDURE [dbo].[SP_NormApp_Percentiles] 
	@measuretype tinyint,
	@groupingType smallint, 
	@bitPercentilesType bit,
	@bitFacility bit,
	@bitMinimumClientCheck bit,
	@requestType tinyint
as
Declare @bitReversePercentileScores bit, @sql varchar(8000), @offset varchar(60), @Note varchar(100)
set @Note='Starting SP_NormApp_Percentiles measureType=' + convert(varchar,@measureType) + ', groupingType=' + 
			convert(varchar,@groupingType)

exec sp_normApp_timer 0, @Note

select @bitReversePercentileScores=bitReversePercentileScores,
		@offset=offset
from groupings
where grouping_id=@groupingType

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	create table #UnitListScorestemp (group_id int, bitDimension bit, ID int, nsize int, score decimal(12,5))
	create index group_id on #UnitListScorestemp (group_id) 

--If it is not a norm, 
if @requestType<>6
BEGIN
	--Questionval only includes responses that are not bitmissing so this join
	--will remove the bitmissing values
	if @GroupingType not in (998,999)
	BEGIN
		update n 
		set bitDelete=1
		from #questionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
			  n.val=qv.val
		where qv.val is null

		update n 
		set bitDelete=1
		from #dimensionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
			  n.val=qv.val
		where qv.val is null
	END
END
Else
BEGIN
	--Reduce the number of questions that need to be analyzed based on
	--the measure and grouping for norms
	if @GroupingType in (998,999)
	BEGIN
		select distinct qstncore
		into #probCores
		from questionvals
		where bitprobscore=1

		update n 
		set bitDelete=1
		from #questionresults n left join #probCores qv
			on n.qstncore=qv.qstncore
		where qv.qstncore is null

		update n 
		set bitDelete=1
		from #dimensionresults n left join #probCores qv
			on n.qstncore=qv.qstncore
		where qv.qstncore is null
	END
	ELSE if @groupingType=0
	BEGIN
		update n 
		set bitDelete=1
		from #questionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
				n.val=qv.val and
				qv.bitmeanable=1
		where qv.qstncore is null

		update n 
		set bitDelete=1
		from #dimensionresults n left join questionvals qv
			on n.qstncore=qv.qstncore and
				n.val=qv.val and
				qv.bitmeanable=1
		where qv.qstncore is null
	END

END

/*Minimum nsize check*/
if @GroupingType in (998,999)
BEGIN
		update q
		set bitDelete=1
		from #questionresults q,
			(select group_id, coalesce(1000000+questiongroup_id, q.qstncore) as IDNum
				from #questionresults q, qp_comments.dbo.lu_problem_score ps
				where q.qstncore=ps.qstncore and
					q.val=ps.val and
					ps.problem_score_flag in (0,1)
				group by group_id, coalesce(1000000+questiongroup_id, q.qstncore)
				having sum(nsize)<30) dr
		where q.group_id=dr.group_id and
				coalesce(1000000+questiongroup_id, q.qstncore)=dr.IDNum  

		--If any question fails nsize rule, delete entire dimension
		update d
		set bitDelete=1
		from #dimensionresults d,
			(select group_id, dimension_id, coalesce(1000000+questiongroup_id, q.qstncore) as IDNum
				from #dimensionresults q, qp_comments.dbo.lu_problem_score ps
				where q.qstncore=ps.qstncore and
					q.val=ps.val and
					ps.problem_score_flag in (0,1)
				group by group_id, dimension_id, coalesce(1000000+questiongroup_id, q.qstncore)
				having sum(nsize)<30) dr
		where d.group_id=dr.group_id and
				d.dimension_id=dr.dimension_id 
END
ELSE 
BEGIN
		update d
		set bitDelete=1
		from #questionresults d,

			(select group_id, coalesce(1000000+questiongroup_id, q.qstncore) as IDNum
				from #questionresults q, questionvals qv
				where q.qstncore=qv.qstncore and
						q.val=qv.val
				group by group_id, coalesce(1000000+questiongroup_id, q.qstncore)
				having sum(nsize)<30) dr
		where d.group_id=dr.group_id and
				coalesce(1000000+questiongroup_id, qstncore)=dr.IDNum  

		--If any question fails nsize rule, delete entire dimension
		update d
		set bitDelete=1
		from #dimensionresults d,
			(select group_id, dimension_id, coalesce(1000000+questiongroup_id, d.qstncore) as IDNum
				from #dimensionresults d, questionvals qv
				where d.qstncore=qv.qstncore and
						d.val=qv.val
				group by group_id, dimension_id, coalesce(1000000+questiongroup_id, d.qstncore)
				having sum(nsize)<30) dr
		where d.group_id=dr.group_id and
				d.dimension_id=dr.dimension_id 

END

/*Check that All dimension Questions are in use*/
update d
set bitDelete=1
from #dimensionresults d,
	(select group_id, dimension_id, count(distinct coalesce(1000000+questiongroup_id, qstncore)) as questioncount
		from #dimensionresults dr
		group by group_id, dimension_id) dr, 
		(select dimension_id, count(distinct coalesce(1000000+questiongroup_id, qstncore)) as questioncount
			from #dimensions
			group by dimension_id) qc
where d.group_id=dr.group_id and
		d.dimension_id=dr.dimension_id and
		dr.dimension_id=qc.dimension_id and
		dr.questioncount < qc.questioncount

/*Calculate scores for each unit or Facility*/
if @measureType=1
BEGIN
		insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select group_id, 
						0 as bitDimension,
						coalesce(1000000+questiongroup_id, qstncore) as IDNum, 
						sum(nsize) as nsize, 
						sum(val*nsize*1.0)/sum(nsize) as Score 
					from #questionresults 
					where bitDelete=0
					group by group_id, 
						coalesce(1000000+questiongroup_id, qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select group_id,
			1 as bitDimension, 
			dimension_id as ID, 
			sum(nsize) as nsize, 
			sum(val*nsize*1.0)/sum(nsize) as Score 
		from #dimensionresults
		where bitDelete=0
		group by group_id, 
			dimension_id) s
		order by bitDimension, ID, score		
END	
ELSE if @GroupingType=999
BEGIN
		insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select r.group_id, 
					0 as bitDimension,
					coalesce(1000000+r.questiongroup_id, r.qstncore) as IDNum, 
					sum(r.nsize) as nsize, 
					100 - (sum(ps.problem_score_flag*r.nsize*100.0)/sum(r.nsize)) as Score 
				from #questionresults r, qp_comments.dbo.lu_problem_score ps
				where r.qstncore=ps.qstncore and
					r.val=ps.val and
					ps.problem_score_flag in (0,1) and
					bitDelete=0
				group by r.group_id, 
					coalesce(1000000+r.questiongroup_id, r.qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select d.group_id, 
			1 as bitDimension,
			d.dimension_id as ID, 
			sum(d.nsize) as nsize, 
			100 - (sum(ps.problem_score_flag*d.nsize*100.0)/sum(d.nsize)) as Score 
		from #dimensionresults d, qp_comments.dbo.lu_problem_score ps
		where d.qstncore=ps.qstncore and
			d.val=ps.val and
			ps.problem_score_flag in (0,1) and
			bitDelete=0
		group by d.group_id, 
			d.dimension_id) s
		order by bitDimension, ID, score	
END
ELSE if @GroupingType=998
BEGIN
		insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select r.group_id, 
					0 as bitDimension,
					coalesce(1000000+r.questiongroup_id, r.qstncore) as IDNum, 
					sum(r.nsize) as nsize, 
					(sum(ps.problem_score_flag*r.nsize*100.0)/sum(r.nsize)) as Score 
				from #questionresults r, qp_comments.dbo.lu_problem_score ps
				where r.qstncore=ps.qstncore and
					r.val=ps.val and
					ps.problem_score_flag in (0,1) and
					bitDelete=0
				group by r.group_id, 
					coalesce(1000000+r.questiongroup_id, r.qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select d.group_id, 
			1 as bitDimension,
			d.dimension_id as ID, 
			sum(d.nsize) as nsize, 
			(sum(ps.problem_score_flag*d.nsize*100.0)/sum(d.nsize)) as Score 
		from #dimensionresults d, qp_comments.dbo.lu_problem_score ps
		where d.qstncore=ps.qstncore and
			d.val=ps.val and
			ps.problem_score_flag in (0,1) and
			bitDelete=0
		group by d.group_id, 
			d.dimension_id) s
		order by bitDimension, ID, score	
END
ELSE
BEGIN
	set @sql='insert into #UnitListScorestemp (group_id, bitDimension, ID, nsize, score)
		select *
		from 
			(select group_id,
					bitDimension,
					q.qstncore as ID,
					nsize,
					score
			from (select r.group_id, 
				0 as bitDimension,
				coalesce(1000000+r.questiongroup_id, r.qstncore) as IDNum, 
				sum(r.nsize) as nsize, 
				(sum(case
						when ' + @offset +' then 1
						else 0
					 end*r.nsize*1.0)/sum(r.nsize))*100 as Score
			from #questionresults r, questionvals q
			where r.qstncore=q.qstncore and
				r.val=q.val and
				bitDelete=0
			group by r.group_id, 
				coalesce(1000000+r.questiongroup_id, r.qstncore)) qr, #questions q
			where qr.IDNum=coalesce(1000000+q.questiongroup_id, q.qstncore) and
				bitSelected=1
	union all
		select d.group_id, 
			1 as bitDimension,
			d.dimension_id as ID, 
			sum(d.nsize) as nsize, 
			(sum(case
					when ' + @offset +' then 1
					else 0
				 end*d.nsize*1.0)/sum(d.nsize))*100 as Score 
		from #dimensionresults d, questionvals q
		where d.qstncore=q.qstncore and
			d.val=q.val and
			bitDelete=0
		group by d.group_id, 
			d.dimension_id) s
		order by bitDimension, ID, score'

	exec (@sql)	
END

/*Problem scores and Bottom box scores need to be recoded
  in order to get the right percentiles.  The scores will be changed back
  in a later step */
if @bitReversePercentileScores=1
	update #UnitListScorestemp
	set score=100-score

/*Check the Business Rules*/
	/*Minium # of Units or Facilities*/
if @bitPercentilesType<>1
begin
	delete p
	from #UnitListScorestemp p, 
		(select bitDimension, ID
		 from #UnitListScorestemp
		 group by bitDimension, ID
		 having count(distinct group_id)<10) pl
	where p.bitDimension=pl.bitDimension and
		  p.ID=pl.ID
end
	
	/*Minimum # of Clients*/
	IF @bitMinimumClientCheck=1
	BEGIN
		IF @bitFacility=1
			delete p
			from #UnitListScorestemp p, 
				(select distinct bitDimension, ID
				 from #UnitListScorestemp p, facilityservicesview sf
				 where p.group_id=sf.sufacility_id 
				 group by bitDimension, ID
				 having count(distinct client_id) < 2) pl
			where p.bitDimension=pl.bitDimension and
				  p.ID=pl.ID	
		ELSE 
			delete p
			from #UnitListScorestemp p, 
				(select distinct bitDimension, ID
				 from #UnitListScorestemp p, sampleunit s, clientstudysurvey css
				 where p.group_id=s.sampleunit_id and
						s.survey_id=css.survey_id
				 group by bitDimension, ID
				 having count(distinct client_id) < 2) pl
			where p.bitDimension=pl.bitDimension and
				  p.ID=pl.ID
	END

/*Add the unique ID for each record*/
insert into #UnitListScores (group_id, bitDimension, ID, nsize, score)
select group_id, bitDimension, ID, nsize, score
from #UnitListScorestemp
order by bitDimension, ID, score

/*Calculate the Percentile for each score*/
insert into #PercentilesList (group_id, bitDimension, ID, nsize, score, percentile)
select group_id,
		u.bitDimension,
		u.ID,
		nsize,
		score,
		(uniqueID-minUniqueID+1*1.0)/(maxUniqueID-minUniqueID+1)*100
from #UnitListScores U,
	(select bitDimension,
			ID,
			min(uniqueID) as minUniqueID,
			max(uniqueID) as maxUniqueID
	from #UnitListScores
	group by bitDimension, ID) m
where u.bitDimension=m.bitDimension and
	  u.ID=m.ID

/*Problem scores and Bottom box scores need to be recoded because they were calculated as 100 - score
  in order to get the right percentiles*/
if @bitReversePercentileScores=1
	update #PercentilesList set score=100-score

if @bitPercentilesType=1 /*list of scores and percentiles*/
BEGIN
	--Create a Lookup Table with unit/Facility Names
	create table #PercentileOwnerLabels (group_id int, Owner varchar(1000))
	IF @bitFacility=1
		insert into #PercentileOwnerLabels
		select distinct group_id, strclient_nm + ' - ' + strfacility_nm + ' (' + convert(varchar,sufacility_id) + ')' as Owner
		from (select distinct group_id
				from #PercentilesList) p, facilityservicesview fs, clientstudysurvey css
		where p.group_id=fs.sufacility_id and
				fs.client_id=css.client_id
	Else
		insert into #PercentileOwnerLabels
		select distinct group_id, 
			strclient_nm + ', ' + strstudy_nm + ', ' + strsurvey_nm  + ', ' + 
			strsampleunit_nm  + ' (' + convert(varchar,sampleunit_id) + ')' as Owner
		from (select distinct group_id
				from #PercentilesList) p, sampleunit s, clientstudysurvey css
		where p.group_id=s.sampleunit_id and
				s.survey_id=css.survey_id	

	--update percentiles so that anyone with the same score gets the same percentile
	update #PercentilesList
	set percentile=s.percentile
	from #PercentilesList pl, 
		(select bitDimension, ID, score, max(percentile) as percentile
			from #PercentilesList pl
			group by bitDimension, ID, score) s
	where pl.bitDimension=s.bitDimension and
		pl.ID=s.ID and
		pl.score=s.score

	/*update #PercentilesList
	set percentile=s.percentile
	from #PercentilesList pl, 
		(select ID, score, max(percentile) as percentile
			from #PercentilesList pl
			group by ID, score) s
	where bitDimension=1 and
		pl.ID=s.ID and
		pl.score=s.score*/

	IF @MeasureType=2
	BEGIN
		select  owner,
				'Question' as type,
				p.ID, 
				[Report Text],
				pl.label as Grouping,
				p.nsize,
				score,
				percentile
		from #PercentilesList p, #Labels q, #PercentLabels pl, #PercentileOwnerLabels pol
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=q.qstncore and
				pl.bitDimension=0 and
				p.group_id=pol.group_id
		union all
		select owner,
				'Dimension' as type,
				p.ID, 
				d.strdimension_nm,
				pl.label as Grouping,
				p.nsize,
				score,
				percentile
		from #PercentilesList p, dimensions d, #PercentLabels pl, #PercentileOwnerLabels pol
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=d.dimension_id and
				pl.bitDimension=1 and
				p.group_id=pol.group_id
		order by type, [Report Text], p.percentile
	END
	ELSE
	BEGIN
			select owner,
					'Question' as type,
					p.ID, 
					[Report Text],
					'Mean' as Grouping,
					p.nsize,
					score,
					percentile
			from #PercentilesList p, #Labels q, #PercentileOwnerLabels pol
			where p.ID=q.qstncore and
					p.bitDimension=0 and
					p.group_id=pol.group_id
		union all
			select owner,
					'Dimension' as type,
					p.ID, 
					d.strdimension_nm,
					'Mean' as Grouping,
					p.nsize,
					score,
					percentile
			from #PercentilesList p, dimensions d, #PercentileOwnerLabels pol
			where p.ID=d.dimension_ID and
				  p.bitDimension=1 and
					p.group_id=pol.group_id
		order by type, [Report Text], p.percentile
	END
END
ELSE /*1 to 100 percentiles*/
BEGIN
	if @bitReversePercentileScores=1
	Begin
		insert into #Percentiles1to100
		select p.bitDimension, p.ID, max(p.score) as score,
				pt.percentile
		from #PercentilesList p, percentilesTemp pt
		where p.percentile >=pt.percentile
		group by p.bitDimension, p.ID, pt.percentile

	End
	Else
	Begin
		insert into #Percentiles1to100
		select p.bitDimension, p.ID, min(p.score) as score,
				pt.percentile
		from #PercentilesList p, percentilesTemp pt
		where p.percentile >=pt.percentile
		group by p.bitDimension, p.ID, pt.percentile
	END

	--Fill in any gaps at the bottom of the percentiles
	insert into #Percentiles1to100
	select p.bitDimension, p.ID, p1.score,
			pt.percentile
	from (select bitDimension, ID, min(percentile) as percentile
			from #Percentiles1to100
			group by bitDimension, ID) p, #Percentiles1to100 p1, percentilesTemp pt
	where p.bitDimension=p1.bitDimension and
			p.ID=p1.ID and
			p.percentile=p1.percentile and

			p.percentile >pt.percentile

	IF @MeasureType=2 
	BEGIN
		select 'Question' as type,
				p.ID, 
				[Report Text],
				pl.label as Grouping,
				score,
				p.percentile
		from #Percentiles1to100 p, #Labels q, #PercentLabels pl
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=q.qstncore and
				pl.bitDimension=0
		union all
		select 'Dimension' as type,
				p.ID, 
				d.strdimension_nm,
				pl.label as Grouping,
				score,
				p.percentile
		from #Percentiles1to100 p, dimensions d, #PercentLabels pl
		where p.bitDimension=pl.bitDimension and
				p.ID=pl.ID and
				p.ID=d.dimension_id and
				pl.bitDimension=1
		order by type, [Report Text], p.percentile desc
	END
	ELSE
	BEGIN
			select 'Question' as type,
					p.ID, 
					[Report Text],
					'Mean' as Grouping,
					score,
					percentile
			from #Percentiles1to100 p, #Labels q
			where p.ID=q.qstncore and
					p.bitDimension=0
		union all
			select 'Dimension' as type,
					p.ID, 
					d.strdimension_nm,
					'Mean' as Grouping,
					score,
					percentile
			from #Percentiles1to100 p, dimensions d
			where p.ID=d.dimension_ID and
				  p.bitDimension=1		
		order by type, [Report Text], p.percentile desc
	END
END

set @Note='Ending SP_NormApp_Percentiles measureType=' + convert(varchar,@measureType) + ', groupingType=' + 
			convert(varchar,@groupingType)
exec sp_normApp_timer 0, @Note












