use qp_prod
go
create procedure dbo.TestReturns
@survey_id int
as
-- declare @survey_id int set @survey_id=15678
select sq.selqstns_id, sq.survey_id, sq.section_id, sq.subsection, sq.item as qstnitem, sq.qstncore, sq.label as qstn, sq.scaleid, sq.numMarkCount, ss.item as scaleitem, ss.val, ss.label as response, sk.numSkip, sk.numSkipType, 0 as svyorder
into #svy
from sel_qstns sq
	inner join sel_scls ss on sq.survey_id=ss.survey_id and sq.language=ss.language and sq.scaleid=ss.qpc_id
	left outer join sel_skip sk on sq.survey_id=sk.survey_id and sq.selqstns_id=sk.selqstns_id and sq.scaleid=sk.selscls_id and ss.item=sk.scaleitem
where sq.language=1	
and sq.survey_id=@survey_id
order by sq.section_id, sq.subsection, sq.item, ss.item

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

create table #Fake (dummy int)
create table #FakeHorizontal (fake_id int identity(1,1))
declare @sql varchar(max)
set @SQL='alter table #fake add '
select @SQL=@SQL+'q'+right(convert(varchar,10000000+qstncore),7)+case when scaleitem=-1 then '' else char(64+scaleitem) end+' int,'
from (select distinct qstncore, case when numMarkCount=2 then scaleitem else -1 end as scaleitem from #svy) s
set @SQL=left(@SQL,len(@SQL)-1) 
print @SQL
exec (@SQL)
set @SQL= replace(@SQL,'#Fake','#FakeHorizontal')
exec (@SQL)

alter table #fake drop column dummy

select @p = min(pod), @sql='insert into #fake select * from ' from #pod where flag=0
while @p is not null
begin
	SELECT @sql=@sql+ '
		(select '+case when p.pod is null then 'min' else '' end+'(val) as '+field_nm+
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
	select @p = min(pod), @sql='insert into #fake select * from ' from #pod where flag=0
end

insert into #FakeHorizontal
select distinct *
from #fake

declare @fakecount int, @qfcount int
select @fakecount=count(*) from #FakeHorizontal
print 'there are '+convert(varchar, @fakecount)+' records in #FakeHorizontal'

select @qfCount=count(*) 
from questionform qf
inner join sentmailing sm on qf.sentmail_id=sm.sentmail_id
where qf.survey_id=@survey_id 
and qf.datreturned is null
and sm.datmailed is not null
and qf.questionform_id in (select questionform_id from qp_scan.dbo.bubblepos)

if @FakeCount>@qfCount
begin
	select 'There are '+convert(varchar,@qfCount)+' mailed forms that have bubble data and have not already been returned, which isn''t enough to handle the '+convert(varchar,@FakeCount)+' fake returns. Aborting.' as [message]
	return
end

alter table #fakehorizontal add intRandomNumber int

declare @r int
set @r= round(rand()*200000,0)

update f set intRandomNumber=r.intRandomNumber
from #fakehorizontal f
inner join randomnumber r on r.randomnumber_id%200000=(f.fake_id+@r)%200000


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
	inner join randomnumber r on x_id=Randomnumber_id%@c
	inner join #fakehorizontal f on r.Randomnumber_id=(f.intRandomnumber+@r)%200000'
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
	update #fakehorizontal set q'+right(convert(varchar,10000000+@q),7)+char(64+@v)+'=null where intRandomNumber between @r and @r+100000 or intRandomNumber < @r-100000'
	exec (@SQL)
	delete from #rdm where qstncore=@q and val=@v
	select top 1 @q=qstncore, @v=val from #rdm
end;

create table #FakeVertical (fake_id int, qstncore int, intResponseValue int)
set @SQL=''
select @SQL=@SQL + 'insert into #FakeVertical select fake_id, '+convert(varchar,s.qstncore)+', '+field_nm+' from #FakeHorizontal where '+field_nm+' is not null
'
from (select distinct qstncore, 'q'+right(convert(varchar,10000000+qstncore),7)+case when numMarkcount=1 then '' else char(64+scaleitem) end as field_nm, case when numMarkCount=2 then scaleitem else -1 end as scaleitem from #svy) s
exec (@SQL)

set rowcount @FakeCount 
select row_number() over(order by qf.questionform_id) as fake_id, getdate() as datReturned,dbo.lithotoBarCode(sm.strlithocode ,1) as barcode, qf.questionform_id, qf.samplepop_id, sm.strlithocode, sm.datgenerated, convert(varchar(250),'') as STRfile
into #Barcodes
from questionform qf
inner join sentmailing sm on qf.sentmail_id=sm.sentmail_id
where survey_id=@survey_id 
and datreturned is null
and sm.datmailed is not null
and qf.questionform_id in (select questionform_id from qp_scan.dbo.bubblepos)

set rowcount 0 


update #barcodes set STRfile=replace(convert(varchar,datReturned,102),'.','')+barcode

create table #stuffwork (stuffwork_id int identity(1,1), fake_id int, questionform_id int, sampleunit_id int, qstncore int, intBegColumn int, ReadMethod_id tinyint, intRespCol int, intResponseValue int)
insert into #stuffwork
select bc.fake_id, bp.questionform_id, bp.sampleunit_id, bp.qstncore, bp.intBegColumn, bp.ReadMethod_id, bp.intRespCol, fv.intResponseValue
from #barcodes bc
inner join qp_scan.dbo.bubblepos bp on bc.questionform_id=bp.questionform_id
inner join #fakeVertical fv on bc.fake_id=fv.fake_id and bp.qstncore=fv.qstncore

declare @sw_id int, @qf_id int, @begCol int, @RespCol int, @RespValue int, @STRfile varchar(max)
-- single response
select top 1 @sw_id=stuffwork_id, @qf_id=Questionform_id, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #stuffwork where ReadMethod_id=5
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
	delete from #stuffwork where stuffwork_id=@sw_id
	select top 1 @sw_id=stuffwork_id, @qf_id=Questionform_id, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #stuffwork where ReadMethod_id=5
end

select top 1 @sw_id=stuffwork_id, @qf_id=Questionform_id, @q=qstncore, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #stuffwork where ReadMethod_id=1
while @@rowcount>0
begin
	select @STRFile=isnull(STRFile,'')+space(@begCol+@respCol) from #barcodes where questionform_id=@qf_id  

	if (select max(val) from #svy where qstncore=@q)>9
		set @STRfile=stuff(@STRfile,@begCol+(@respValue*2)-2,2,right(' '+convert(varchar,@respValue),2)) -- responses are 2 characters each, because there are 10 or more responses
	else
		set @STRfile=stuff(@STRfile,@begCol+@respValue-1,1,@respValue) -- responses are 1 character each

	update #barcodes set STRFile=rtrim(@STRfile) where questionform_id=@qf_id  
	delete from #stuffwork where stuffwork_id=@sw_id
	select top 1 @sw_id=stuffwork_id, @qf_id=Questionform_id, @q=qstncore, @begCol=intBegColumn, @RespCol=intRespCol, @respValue=intResponseValue from #stuffwork where ReadMethod_id=1
end

select distinct dbo.lithotoBarCode(bc.strlithocode ,bp.intPage_num) as DLVFile
from #barcodes bc
inner join qp_scan.dbo.bubblepos bp on bc.questionform_id=bp.questionform_id

select STRFile from #barcodes


drop table #barcodes
drop table #fake
drop table #fakevertical
drop table #fakehorizontal
drop table #svy
drop table #svyorder
drop table #gateway
drop table #pod
drop table #rdm
drop table #stuffwork

go
