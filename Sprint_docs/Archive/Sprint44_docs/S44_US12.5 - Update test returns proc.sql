/*
	S44 US 12 12 CG-CAHPS Completeness 
	As a CG-CAHPS vendor, we need to update completeness calculations for CG-CAHPS to match new guidelines, so that we can submit accurate data for state-level initiatives.

	12.5 - Update test returns proc

	ALTER PROC TestReturns
	ALTER PROC TestReturns_assembleSTR

	Dave Gilsdorf
*/
use dbadata
go
if exists (select * from qp_prod..qualpro_params where strparam_nm = 'EnvName' and strParam_Value='PRODUCTION')
begin
	print 'These procedures don''t belong in production, so they''re being dropped if they exist. The following ALTER PROCEDURE commands will then fail, as they should.'
	if exists (select * from sys.procedures where name = 'TestReturns')
		drop procedure dbo.TestReturns
	if exists (select * from sys.procedures where name = 'TestReturns_assembleSTR')
		drop procedure dbo.TestReturns_assembleSTR
end
go
alter procedure [dbo].[TestReturns]
@survey_id int=0, @Sampleset_id int=0, @numReturns int=0, @intSequence int=0, @testSkips bit=1, @testCompleteness bit=1
as

if exists (select * from qp_prod..qualpro_params where strparam_nm = 'EnvName' and strParam_Value='PRODUCTION')
begin
	print 'This procedure is intended for use in TEST and STAGING environments.'
	return
end

if @survey_id=0
begin
	print 'Msg 201, Level 16, State 4, Procedure TestReturns, Line 0'
	print 'Procedure or function ''TestReturns'' expects parameter ''@survey_id'', which was not supplied.'
	print ''
	print 'Use TestReturnsSurveys_view For a list of surveys that are available.'
	print ''
	print 'If you want to manipulate question answers before the STR file is returned, create the #QuestionResults table before you run TestReturns'
	print '	create table #QuestionResult (QuestionResult_id int identity(1,1)
		, fake_id int
		, QuestionForm_id int
		, SampleUnit_id int
		, QstnCore int
		, intBegColumn int
		, ReadMethod_id tinyint
		, intRespCol int
		, intResponseValue int
		, flag tinyint
		, testCase varchar(100))
		'
	print 'Run dbo.TestResults to populate this table, then change the values in #QuestionResults.intResponseValue to suit your test cases and run dbo.TestReturns_assembleSTR to display the DLV and STR files.'
	return
end

create table #svy (row_id int identity(1,1), selqstns_id int, surveytype_id int, subtype_id int, survey_id int, section_id int, subsection int, qstnitem int, qstncore int, qstn char(60), scaleid int, numMarkCount int
	, scaleitem int, val int, response char(60), numSkip int, numSkipType int, svyorder int)

insert into #svy (selqstns_id, surveytype_id, subtype_id, survey_id, section_id, subsection, qstnitem, qstncore, qstn, scaleid, numMarkCount, scaleitem, val, response, numSkip, numSkipType, svyorder)
select sq.selqstns_id, sd.surveytype_id, 0 as subtype_id, sq.survey_id, sq.section_id, sq.subsection, sq.item as qstnitem, sq.qstncore, sq.label as qstn, sq.scaleid, sq.numMarkCount, ss.item as scaleitem, ss.val, ss.label as response
	, sk.numSkip, sk.numSkipType, 0 as svyorder
from qp_prod..sel_qstns sq
	inner join qp_prod..sel_scls ss on sq.survey_id=ss.survey_id and sq.language=ss.language and sq.scaleid=ss.qpc_id
	inner join qp_prod..survey_def sd on sq.survey_id=sd.survey_id
	inner join qp_prod..SampleSet sp on sq.SURVEY_ID = sp.SURVEY_ID
	left outer join qp_prod..sel_skip sk on sq.survey_id=sk.survey_id and sq.selqstns_id=sk.selqstns_id and sq.scaleid=sk.selscls_id and ss.item=sk.scaleitem
where sq.language=1	
and sq.survey_id=@survey_id
and (@sampleset_id=0 or sp.SAMPLESET_ID = @Sampleset_id)
order by sq.section_id, sq.subsection, sq.item, ss.item

create table #Fake (dummy int, testCase varchar(100))
create table #FakeHorizontal (fake_id int identity(1,1), testCase varchar(100))
declare @sql varchar(max)='alter table #fake add ', @allfields varchar(max)=''
select @SQL=@SQL+'q'+right(convert(varchar,10000000+qstncore),7)+case when scaleitem=-1 then '' else char(64+scaleitem) end+' int,'
	, @allfields=@allfields + 'q'+right(convert(varchar,10000000+qstncore),7)+case when scaleitem=-1 then '' else char(64+scaleitem) end+','
from (select distinct qstncore, case when numMarkCount=2 then scaleitem else -1 end as scaleitem from #svy) s
set @SQL=left(@SQL,len(@SQL)-1) 
set @allfields=left(@allfields,len(@allfields)-1) 
exec (@SQL)
set @SQL= replace(@SQL,'#Fake','#FakeHorizontal')
exec (@SQL)

alter table #fake drop column dummy

if @testSkips=1
begin

	if exists (select survey_id, qstncore,val,count(distinct (numskip*10)+numskiptype) 
		from #svy 
		group by survey_id, qstncore,val
		having count(distinct (numskip*10)+numskiptype) >1)
	begin
		select 'skip setup errors. Individual response(s) have skip instructions to different destinations. Aborting' as [message]
		return
	end

	create table #svyorder (svyorder int identity(1,1), selqstns_id int, section_id int, subsection int, qstnitem int, qstncore int)
	insert into #svyOrder (selqstns_id, section_id, subsection, qstnitem, qstncore)
	select distinct selqstns_id, section_id, subsection, qstnitem, qstncore from #svy order by 2,3,4

	update s set svyorder=so.svyorder
	from #svy S
		inner join #svyorder so on s.selqstns_id=so.selqstns_id

		-- reorder all the sections/subsections/items so everything in sequential order 
		truncate table #svyorder
		insert into #svyorder (section_id) 
		select distinct section_id from #svy order by section_id

		update s set section_id=so.svyorder
		from #svy s, #svyorder so
		where s.section_id=so.section_id

		truncate table #svyorder
		insert into #svyorder (section_id, subsection)
		select distinct section_id,subsection from #svy order by 1,2

		update s set subsection=so.svyorder
		from #svy s, #svyorder so
		where s.section_id=so.section_id
		and s.subsection=so.subsection

		truncate table #svyorder
		insert into #svyorder (section_id, subsection,qstnitem)
		select distinct section_id,subsection,qstnitem from #svy order by 1,2,3

		update s set qstnitem=so.svyorder
		from #svy s, #svyorder so
		where s.section_id=so.section_id
		and s.subsection=so.subsection
		and s.qstnitem=so.qstnitem

		update s set subsection=s.subsection-firstsubsection+1
		from #svy s, (select section_id,min(subsection) as firstsubsection from #svy group by section_id) m
		where s.section_id=m.section_id

		update s set qstnitem=s.qstnitem-firstitem+1
		from #svy s, (select section_id,subsection,min(qstnitem) as firstitem from #svy group by section_id, subsection) m
		where s.section_id=m.section_id and s.subsection=m.subsection
		-- /reorder all the sections/subsections/items so everything in sequential order 
	
	select s.qstncore, min(val) as val, s.numSkip, s.numSkipType, s.numMarkCount, s.svyorder, convert(varchar(20),'gate response') as type
	into #gateway
	from #svy s, (	select distinct section_id, subsection, qstncore, numSkip, numSkipType
					from #svy 
					where numSkipType is not null) sub
	where s.qstncore=sub.qstncore and s.numSkip=sub.numSkip and s.numSkipType=sub.numSkipType
	group by s.qstncore, s.numSkip, s.numSkipType, s.numMarkCount, s.svyorder

	insert into #gateway (qstncore, val, numMarkCount, svyorder, type)
	select s.qstncore, min(val), min(s.numMarkCount), min(svyorder), 'non-gate response'
	from #svy S
	where qstncore in (select qstncore from #gateway) and numSkipType is null
	group by s.qstncore

	insert into #gateway (qstncore, val, numMarkCount, svyorder, type)
	select distinct qstncore,-9, numMarkCount,svyorder,'gate not answered' from #gateway order by 1

	insert into #gateway (qstncore, val, numMarkCount, svyorder,type)
	select qstncore,max(val), 1, min(svyorder), 'not a gate (SR)'
	from #svy
	where qstncore not in (select qstncore from #gateway)
	and numMarkCount=1
	group by qstncore

	insert into #gateway (qstncore, val, numMarkCount, svyorder,type)
	select qstncore, val, 2, min(svyorder), 'not a gate (MR)'
	from #svy
	where qstncore not in (select qstncore from #gateway)
	and numMarkCount=2
	group by qstncore, val


	select qstncore, svyorder, max(svyorder+numskip-1) as affects, 0 as pod, 0 as flag
	into #pod
	from #gateway 
	where numskiptype=1 
	group by qstncore,svyorder 
	order by 2

	insert into #pod 
	select distinct g.qstncore, g.svyorder, s2.firstqstn+g.numSkip-1 as affects, 0, 0
	from #gateway g 
		inner join #svy s on g.qstncore=s.qstncore
		inner join (select section_id, subsection, min(svyorder) as firstqstn from #svy group by section_id, subsection) s2
				on s.section_id=s2.section_id and s2.subsection=s.subsection+1 
	where g.numskiptype=2

	insert into #pod 
	select distinct g.qstncore, g.svyorder, s2.firstqstn as affects, 0, 0
	from #gateway g 
		inner join #svy s on g.qstncore=s.qstncore
		inner join (select section_id, min(svyorder) as firstqstn from #svy group by section_id) s2
				on s2.section_id=s.section_id+1 
	where g.numskiptype=3


	declare @i int, @p int, @a int
	set @p=1
	select @i=min(svyorder) from #pod where pod=0
	while @i is not null
	begin
		select @a=affects from #pod where svyorder=@i
	
		-- if there are 4 or more gateway questions nested within this gateway questions, we're not gonna screw with all the different permutations involving this outermost skip
		if (select count(*) from #pod where svyorder between @i+1 and @a)>4
		begin
			update #pod set pod=@p where svyorder=@i
		end 
		else
		begin
			update p set pod=@p
			from #pod p, (select svyorder, affects from #pod where svyorder=@i) sub
			where p.svyorder between sub.svyorder and sub.affects
		
			while @@rowcount>0
				update #pod
				set pod=@p
				where pod is null
				and svyorder <= (select max(affects) from #pod where pod=@p)
		end	
	
		set @p=@p+1
		select @i=min(svyorder) from #pod where pod=0
	end

	update #pod set flag=0

	-- declare @p int, @sql varchar(max)
	select @p = min(pod) from #pod where flag=0
	set @sql = 'insert into #fake (testCase, '+@allfields+') 
	select ''skip'
	select @sql=@sql+' Q'+convert(varchar,qstncore)+':''+q' + RIGHT(CONVERT(VARCHAR, 10000000+qstncore), 7) + '.type+''' 
			from #pod where pod=@p order by svyorder
	set @sql=left(@sql,len(@sql)-2) + ',' + @allfields+' from '

	while @p is not null
	begin
		SELECT @sql=@sql+ '
			(select '+case when p.pod is null then 'min' else '' end+'(val) as '+field_nm+
				case when p.pod is null then '' else ',type' end+
				' from #gateway where qstncore='+convert(varchar,s.qstncore)+
					   case when s.scaleitem=-1 then '' else ' and val in ('+convert(varchar,s.scaleitem)+',-9)' end+') '+field_nm+','	 
		FROM   (SELECT DISTINCT qstncore, 'q' 
								+ RIGHT(CONVERT(VARCHAR, 10000000+qstncore), 7) 
								+ CASE WHEN nummarkcount=1 THEN '' ELSE Char(64+scaleitem) END AS field_nm, 
								CASE WHEN nummarkcount = 2 THEN scaleitem ELSE -1 END AS scaleitem 
				FROM   #svy) s 
			   LEFT OUTER JOIN (SELECT DISTINCT pod, qstncore 
								FROM   #pod 
								WHERE  pod = @p) p 
							ON s.qstncore = p.qstncore 
		ORDER  BY s.qstncore 
	
		set @SQL=left(@SQL,len(@SQL)-1) 
		exec (@SQL)
	
		update #pod set flag=1 where pod=@p
		select @p = min(pod) from #pod where flag=0
		set @sql = 'insert into #fake (testCase, '+@allfields+') 
		select ''skip'
		select @sql=@sql+' Q'+convert(varchar,qstncore)+':''+q' + RIGHT(CONVERT(VARCHAR, 10000000+qstncore), 7) + '.type+''' 
				from #pod where pod=@p order by svyorder
		set @sql=left(@sql,len(@sql)-2) + ',' + @allfields+' from '
	end
end  --/@testSkips=1

if @testCompleteness=1
begin
	update s set subtype_id=st.Subtype_id
	from #svy s
	inner join qp_prod..surveysubtype sst on s.survey_id=sst.survey_id
	inner join qp_prod..subtype st on sst.Subtype_id=st.Subtype_id
	where st.SubtypeCategory_id=2 -- questionaire type

	select distinct s.qstncore, 1 as giveAnswer, convert(int,null) as Answer
		, 'q'+right(convert(varchar,10000000+s.qstncore),7)+case when numMarkCount=1 then '' else char(64+Scaleitem) end as field_nm
		, case when numMarkCount=1 then -1 else Scaleitem end as MRResponse
		, qm.isATA, qm.isMeasure
	into #ATA
	from #svy s
	left join qp_prod.dbo.SurveyTypeQuestionMappings qm on s.surveytype_id=qm.surveytype_id and s.subtype_id=qm.SubType_ID and s.qstncore=qm.qstncore and getdate() between qm.datEncounterStart_dt and qm.datEncounterEnd_dt;
	
	declare @testCase varchar(100), @rn int, @fieldlist varchar(max)
	declare @testcases table (testCase varchar(100), prepSQL varchar(1000))
	insert into @testCases values ('answer every question','update #ata set giveAnswer=1')
	insert into @testCases values ('answer no questions','update #ata set giveAnswer=0')
	insert into @testCases values ('answer 50%+1 ATAs, no measures','declare @c int, @half int
																	select @c=count(distinct qstncore) from #ata where isATA=1
																	update a set giveAnswer=case when isATA=1 or isMeasure=1 then 0 else intRandomNumber%2 end from #ata a inner join qp_prod..RandomNumber rn on a.qstncore+round(rand()*100000,0)=rn.RandomNumber_id
																	set @half=1+floor(@c/2.0)
																	set rowcount @half
																	update #ata set giveAnswer=1 where isATA=1 and isMeasure=0 and MRResponse in (-1,1)
																	set rowcount 0')
	insert into @testCases values ('answer 50%-1 ATAs, no measures','declare @c int, @half int
																	select @c=count(distinct qstncore) from #ata where isATA=1
																	update a set giveAnswer=case when isATA=1 or isMeasure=1 then 0 else intRandomNumber%2 end from #ata a inner join qp_prod..RandomNumber rn on a.qstncore+round(rand()*100000,0)=rn.RandomNumber_id
																	set @half=ceiling(@c/2.0)-1
																	while (select count(distinct qstncore) from #ata where giveanswer=1 and isATA=1 and isMeasure=0)<@half
																		update #ata set giveanswer=1 where qstncore in (select top 1 qstncore from #ata a inner join qp_prod..RandomNumber rn on a.qstncore+round(rand()*100000,0)=rn.RandomNumber_id where isATA=1 and isMeasure=0 order by intRandomNumber)
																	set rowcount 0')
	insert into @testCases values ('answer 50%+1 ATAs, one measure','declare @c int, @half int
																	select @c=count(distinct qstncore) from #ata where isATA=1
																	update a set giveAnswer=case when isATA=1 or isMeasure=1 then 0 else intRandomNumber%2 end from #ata a inner join qp_prod..RandomNumber rn on a.qstncore+round(rand()*100000,0)=rn.RandomNumber_id
																	set @half=1+floor(@c/2.0)
																	while (select count(distinct qstncore) from #ata where giveanswer=1 and isATA=1)<@half
																		update #ata set giveanswer=1 where qstncore in (select top 1 qstncore from #ata a inner join qp_prod..RandomNumber rn on a.qstncore+round(rand()*100000,0)=rn.RandomNumber_id where isATA=1 order by intRandomNumber)
																	set rowcount 1
																	if not exists (select * from #ata where giveanswer=1 and isMeasure=1)
																		update #ata set giveAnswer=1 where isATA=0 and isMeasure=1
																	set rowcount 0')
	insert into @testCases values ('answer 50%-1 ATAs, one measure','declare @c int, @half int
																	select @c=count(distinct qstncore) from #ata where isATA=1
																	update a set giveAnswer=case when isATA=1 or isMeasure=1 then 0 else intRandomNumber%2 end from #ata a inner join qp_prod..RandomNumber rn on a.qstncore+round(rand()*100000,0)=rn.RandomNumber_id
																	set @half=ceiling(@c/2.0)-1
																	while (select count(distinct qstncore) from #ata where giveanswer=1 and isATA=1)<@half
																		update #ata set giveanswer=1 where qstncore in (select top 1 qstncore from #ata a inner join qp_prod..RandomNumber rn on a.qstncore+round(rand()*100000,0)=rn.RandomNumber_id where isATA=1 order by intRandomNumber)
																	set rowcount 1
																	if not exists (select * from #ata where giveanswer=1 and isMeasure=1)
																		update #ata set giveAnswer=1 where isATA=0 and isMeasure=1
																	set rowcount 0')

	select top 1 @testCase=testCase, @sql=prepSQL from @testcases
	while @@rowcount>0
	begin
		update #ata set Answer= case when MRResponse>0 then null else -9 end
		exec (@SQL)

		set @rn=rand()*100000;

		with cte (qstncore, val, intRandomnumber)
		as (
			select a.qstncore, val, rn.intRandomnumber
			from #ata a
			inner join #svy s on a.qstncore=s.qstncore
			inner join qp_prod..RandomNumber rn on s.row_id+@rn=rn.RandomNumber_id
			where s.numMarkCount=1 
		)
		update a set Answer=c.val
		from cte c
		inner join (select qstncore, min(intRandomnumber) as minRand from cte group by qstncore) m on c.qstncore=m.qstncore and c.intRandomnumber=m.minRand
		inner join #ata a on c.qstncore=a.qstncore
		where a.giveAnswer=1;
			
		with cte (qstncore, val, intRandomnumber)
		as (
			select a.qstncore, val, rn.intRandomnumber
			from #ata a
			inner join #svy s on a.qstncore=s.qstncore
			inner join qp_prod..RandomNumber rn on s.row_id+@rn=rn.RandomNumber_id
			where s.numMarkCount=2 
		)
		update a set Answer=MRResponse
		from cte c
		inner join #ata a on c.qstncore=a.qstncore and c.val=a.MRResponse
		where intRandomNumber in (select min(intRandomnumber) from cte group by qstncore union select max(intRandomnumber) from cte group by qstncore)
		and a.giveAnswer=1

		set @sql=''
		set @fieldlist=''
		select @sql=@sql+'
		(select Answer as '+field_nm+' from #ata where field_nm='''+field_nm+''') '+field_nm+',' 
			, @fieldlist=@fieldlist+field_nm+','
		from #ata
	
		set @fieldlist=left(@fieldlist,len(@fieldlist)-1)
		set @sql=left(@sql,len(@sql)-1)
		set @sql = 'insert into #fake (testCase,'+@fieldlist+') 
		select '''+@testCase+''', '+@fieldlist+' from '+@sql

		Exec (@sql)

		delete from @testCases where testcase=@testCase
		select top 1 @testCase=testCase, @sql=prepSQL from @testcases
	end;
end

insert into #FakeHorizontal
select distinct *
from #fake

declare @fakecount int, @qfcount int
select @fakecount=count(*) from #FakeHorizontal

while @fakecount < @numReturns
begin	
	set @SQL = 'insert into #FakeHorizontal
				select top '+convert(varchar,@numReturns-@fakecount)+' *
				from #fake'
	exec (@SQL)
	select @fakecount=count(*) from #FakeHorizontal
end
print 'there are '+convert(varchar, @fakecount)+' records in #FakeHorizontal'


select @qfCount=count(*) 
from qp_prod..questionform qf
inner join qp_prod..sentmailing sm on qf.sentmail_id=sm.sentmail_id
inner join qp_prod..ScheduledMailing scm on sm.sentmail_id=scm.sentmail_id
inner join qp_prod..Samplepop sp on scm.samplepop_id=sp.samplepop_id
inner join qp_prod..mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
where qf.survey_id=@survey_id 
and qf.datreturned is null
and sm.datmailed is not null
and qf.questionform_id in (select questionform_id from qp_scan.dbo.bubblepos)
and (@sampleset_id=0 or sp.SAMPLESET_ID = @Sampleset_id)
and (ms.intSequence=@intSequence or @intSequence=0)

if @qfCount=0
begin
	select 'There are no mailed forms that have bubble data and have not already been returned, so we don''t have anywhere to put the '+convert(varchar,@FakeCount)+' fake returns. Aborting.' as [message]
	return
end

if @FakeCount>@qfCount
begin
	delete from #FakeHorizontal where fake_id>@qfCount
	--set @SQL = 'set rowcount ' + convert(varchar,@FakeCount-@qfCount)+'
	--delete from #FakeHorizontal
	--set rowcount 0'
	--exec (@SQL)
	select @fakecount=count(*) from #FakeHorizontal
	print 'there weren''t enough returns to handle it so there are now '+convert(varchar, @fakecount)+' records in #FakeHorizontal'
end

if @testSkips=1
begin
	alter table #fakehorizontal add intRandomNumber int

	declare @r int
	set @r= round(rand()*200000,0)

	update f set intRandomNumber=r.intRandomNumber
	from #fakehorizontal f
	inner join qp_prod..randomnumber r on r.randomnumber_id%200000=(f.fake_id+@r)%200000


	select g.qstncore, s.val 
	into #rdm
	from #gateway g
	inner join #svy s on g.qstncore=s.qstncore
	where g.type = 'not a gate (SR)'

	declare @q int, @v int 
	select top 1 @q=qstncore from #rdm
	while @@rowcount>0
	begin
		set @SQL = 'declare @c int, @r int
		declare @x table (x_id int identity(0,1), val int)
		insert into @x (val)
		select val 
		from #rdm 
		where qstncore='+convert(varchar,@q)+'
		set @c=@@rowcount 
		insert into @x (val) -- inserting the actual responses twice, so they have 2x more chance of getting selected than the -8 and -9
		select val 
		from #rdm 
		where qstncore='+convert(varchar,@q)+'
		set @c=@c*2
		insert into @x (val) values (-9)
		insert into @x (val) values (-8)
		set @c=@c+2
	
		set @r= round(rand()*200000,0)
	
		update f set q'+right(convert(varchar,@q+10000000),7)+'=x.val
		from @x x
		inner join qp_prod..randomnumber r on x_id=Randomnumber_id%@c
		inner join #fakehorizontal f on r.Randomnumber_id=(f.intRandomnumber+@r)%200000
		where f.testCase like ''skip%'''
		exec (@SQL)

		delete from #rdm where qstncore=@q 
		select top 1 @q=qstncore from #rdm
	end


	insert into #rdm
	select distinct g.qstncore, s.val 
	from #gateway g
	inner join #svy s on g.qstncore=s.qstncore
	where g.type = 'not a gate (MR)'

	select top 1 @q=qstncore, @v=val from #rdm
	while @@rowcount>0
	begin
		set @SQL = 'declare @r int set @r= round(rand()*200000,0)
		update #fakehorizontal set q'+right(convert(varchar,10000000+@q),7)+char(64+@v)+'=null where (intRandomNumber between @r and @r+100000 or intRandomNumber < @r-100000)
		and testCase like ''skip%'''
		exec (@SQL)
		delete from #rdm where qstncore=@q and val=@v
		select top 1 @q=qstncore, @v=val from #rdm
	end;
end  --/@testSkips=1

create table #FakeVertical (fake_id int, qstncore int, intResponseValue int, testCase varchar(100))
set @SQL=''
select @SQL=@SQL + 'insert into #FakeVertical select fake_id, '+convert(varchar,s.qstncore)+', '+field_nm+',testCase from #FakeHorizontal where '+field_nm+' is not null
'
from (select distinct qstncore, 'q'+right(convert(varchar,10000000+qstncore),7)+case when numMarkcount=1 then '' else char(64+scaleitem) end as field_nm, case when numMarkCount=2 then scaleitem else -1 end as scaleitem from #svy) s
exec (@SQL)

create table #barcodes (fake_id int, datReturned datetime, barcode varchar(10), questionform_id int, samplepop_id int, strLithocode varchar(10), datGenerated datetime, STRfile varchar(250))

set rowcount @FakeCount 
insert into #Barcodes (fake_id, datReturned, barcode, questionform_id, samplepop_id, strLithocode, datGenerated, STRfile)
select row_number() over(order by qf.questionform_id) as fake_id, getdate() as datReturned,qp_prod.dbo.lithotoBarCode(sm.strlithocode ,1) as barcode, qf.questionform_id, qf.samplepop_id, sm.strlithocode, sm.datgenerated
	, convert(varchar(250),'') as STRfile
from qp_prod..questionform qf
inner join qp_prod..sentmailing sm on qf.sentmail_id=sm.sentmail_id
inner join qp_prod..ScheduledMailing scm on sm.sentmail_id=scm.sentmail_id
inner join qp_prod..Samplepop sp on scm.samplepop_id=sp.samplepop_id
inner join qp_prod..mailingstep ms on scm.mailingstep_id=ms.mailingstep_id
where qf.survey_id=@survey_id 
and qf.datreturned is null
and sm.datmailed is not null
and qf.questionform_id in (select questionform_id from qp_scan.dbo.bubblepos)
and (@sampleset_id=0 or sp.SAMPLESET_ID = @Sampleset_id)
and (ms.intSequence=@intSequence or @intSequence=0)

set rowcount 0 

update #barcodes set STRfile=replace(convert(varchar,datReturned,102),'.','')+barcode

if object_id('tempdb..#QuestionResult') is null
	create table #QuestionResult (QuestionResult_id int identity(1,1), fake_id int, questionform_id int, sampleunit_id int, qstncore int, intBegColumn int, ReadMethod_id tinyint, intRespCol int, intResponseValue int, flag tinyint, testCase varchar(100))
else
	truncate table #QuestionResult

insert into #QuestionResult
select bc.fake_id, bp.questionform_id, bp.sampleunit_id, bp.qstncore, bp.intBegColumn, bp.ReadMethod_id, bp.intRespCol, fv.intResponseValue, 0, fv.testCase
-- select bc.fake_id, bp.qstncore
from #barcodes bc
inner join qp_scan.dbo.bubblepos bp on bc.questionform_id=bp.questionform_id
inner join #fakeVertical fv on bc.fake_id=fv.fake_id and bp.qstncore=fv.qstncore

alter table #barcodes add testCase varchar(100)
update bc
set testcase=qr.testCase
from #barcodes bc
inner join #questionresult qr on bc.fake_id=qr.fake_id

exec dbo.TestReturns_assembleSTR 

drop table #fake
drop table #fakevertical
drop table #fakehorizontal
drop table #svy
drop table #barcodes
if @testSkips=1
begin
	drop table #svyorder
	drop table #gateway
	drop table #pod
	drop table #rdm
end

if @testCompleteness=1
	drop table #ata
go
alter procedure dbo.TestReturns_assembleSTR 
as

declare @survey_id int
select top 1 @survey_id=qf.survey_id
from qp_prod..questionform qf
inner join #QuestionResult qr on qf.questionform_id=qr.questionform_id

if object_id('tempdb..#svy') is null
begin
	select sq.qstncore, ss.val
	into #svy
	from qp_prod..sel_qstns sq
		inner join qp_prod..sel_scls ss on sq.survey_id=ss.survey_id and sq.language=ss.language and sq.scaleid=ss.qpc_id
		left outer join qp_prod..sel_skip sk on sq.survey_id=sk.survey_id and sq.selqstns_id=sk.selqstns_id and sq.scaleid=sk.selscls_id and ss.item=sk.scaleitem
	where sq.language=1	
	and sq.survey_id=@survey_id
end

if object_id('tempdb..#barcodes') is null
begin
	create table #barcodes (fake_id int, datReturned datetime, barcode varchar(10), questionform_id int, samplepop_id int, strLithocode varchar(10), datGenerated datetime, STRfile varchar(250), testCase varchar(100))

	insert into #Barcodes (fake_id, datReturned, barcode, questionform_id, samplepop_id, strLithocode, datGenerated, testCase)
	select qr.fake_id,getdate() as datReturned, qp_prod.dbo.lithotoBarCode(sm.strlithocode ,1) as barcode, qr.questionform_id, qf.samplepop_id, sm.strlithocode, sm.datGenerated, qr.testCase 
	from (select distinct fake_id, questionform_id, testCase from #QuestionResult) qr
	inner join qp_prod..questionform qf on qr.questionform_id=qf.questionform_id
	inner join qp_prod..sentmailing sm on qf.sentmail_id=sm.sentmail_id

	update #barcodes set STRfile=replace(convert(varchar,datReturned,102),'.','')+barcode
end

update #QuestionResult set flag=0

declare @qr_id int, @qf_id int, @begCol int, @RespCol int, @RespValue int, @STRfile varchar(max), @q int
-- single response
select top 1 @qr_id=QuestionResult_id, @qf_id=Questionform_id, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #QuestionResult where ReadMethod_id=5 and flag=0
while @@rowcount>0
begin
	select @STRFile=isnull(STRFile,'')+space(@begCol+@respCol) from #barcodes where questionform_id=@qf_id  
	if @respValue=-9
	begin
		-- for single response, unanswered questions
		set @STRfile=stuff(@STRfile,@begCol,@RespCol,space(@RespCol)) 
	end else if @respValue=-8
	begin
		-- for single response, improperly answered questions
		set @STRfile=stuff(@STRfile,@begCol,@RespCol,left('*'+space(@RespCol), @RespCol)) 
	end else 
	begin
		-- for single response, answered questions
		set @STRfile=stuff(@STRfile,@begCol,@RespCol,left(convert(varchar,@respValue)+space(@RespCol), @RespCol)) 
	end
	
	update #barcodes set STRFile=rtrim(@STRfile) where questionform_id=@qf_id  
	update #QuestionResult set flag=1 where QuestionResult_id=@qr_id
	select top 1 @qr_id=QuestionResult_id, @qf_id=Questionform_id, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #QuestionResult where ReadMethod_id=5 and flag=0
end

select top 1 @qr_id=QuestionResult_id, @qf_id=Questionform_id, @q=qstncore, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #QuestionResult where ReadMethod_id=1 and flag=0
while @@rowcount>0
begin
	select @STRFile=isnull(STRFile,'')+space(@begCol+@respCol) from #barcodes where questionform_id=@qf_id  

	if (select max(val) from #svy where qstncore=@q)>9
		set @STRfile=stuff(@STRfile,@begCol+(@respValue*2)-2,2,right(' '+convert(varchar,@respValue),2)) -- responses are 2 characters each, because there are 10 or more responses
	else
		set @STRfile=stuff(@STRfile,@begCol+@respValue-1,1,@respValue) -- responses are 1 character each

	update #barcodes set STRFile=rtrim(@STRfile) where questionform_id=@qf_id  
	update #QuestionResult set flag=1 where QuestionResult_id=@qr_id
	select top 1 @qr_id=QuestionResult_id, @qf_id=Questionform_id, @q=qstncore, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #QuestionResult where ReadMethod_id=1 and flag=0
end

select distinct qp_prod.dbo.lithotoBarCode(bc.strlithocode ,bp.intPage_num) as DLVFile
from #barcodes bc
inner join qp_scan.dbo.bubblepos bp on bc.questionform_id=bp.questionform_id

select STRFile,testCase from #barcodes
