CREATE procedure QP_Rep_HS_Encounter_Compare
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50)
AS
set transaction isolation level read uncommitted
declare @study_id int, @strsql varchar(8000)

select @Study_id=s.study_id 
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id

create table #time (mindate datetime)

create table #f1 (facilitynum int, visittype char(5), cnt1 int)

create table #f2 (facilitynum int, visittype char(5), cnt2 int)

create table #f11 (facilitynum int, cnt1 int)

create table #f22 (facilitynum int, cnt2 int)

if @study_id in (190,207,255)

  begin

set @strsql = 'insert into #time ' +
	' select dateadd(second,-1,min(newrecorddate)) ' +
	' from s' + convert(varchar,@study_id) + '.encounter_load ' 

exec (@strsql)

set @strsql = 'insert into #f1 ' +
	' select facilitynum, visittype, count(*) ' +
	' from s' + convert(varchar,@study_id) + '.encounter_load ' +
	' group by facilitynum, visittype '

exec (@strsql)

set @strsql = 'insert into #f2 ' +
	' select facilitynum, visittype, count(*) ' +
	' from s' + convert(varchar,@study_id) + '.encounter ' +
	' where newrecorddate >= (select mindate from #time) ' +
	' group by facilitynum, visittype '

exec (@strsql)

select f1.facilitynum, f1.visittype, cnt1 as loadcount, cnt2 as livecount, (cnt1 - cnt2) as notapplied
from #f1 f1 left outer join #f2 f2
on f1.facilitynum = f2.facilitynum
and f1.visittype = f2.visittype
order by cnt1 - cnt2 desc

  end

if @study_id not in (190,207,255)

  begin

set @strsql = 'insert into #time ' +
	' select dateadd(second,-1,min(newrecorddate)) ' +
	' from s' + convert(varchar,@study_id) + '.encounter_load ' 

exec (@strsql)

set @strsql = 'insert into #f11 ' +
	' select facilitynum, count(*) ' +
	' from s' + convert(varchar,@study_id) + '.encounter_load ' +
	' group by facilitynum '

exec (@strsql)

set @strsql = 'insert into #f22 ' +
	' select facilitynum, count(*) ' +
	' from s' + convert(varchar,@study_id) + '.encounter ' +
	' where newrecorddate >= (select mindate from #time) ' +
	' group by facilitynum '

exec (@strsql)

select f1.facilitynum, cnt1 as loadcount, cnt2 as livecount, (cnt1 - cnt2) as notapplied
from #f11 f1 left outer join #f22 f2
on f1.facilitynum = f2.facilitynum
order by cnt1 - cnt2 desc

  end


drop table #f1
drop table #f2
drop table #time
drop table #f11
drop table #f22

set transaction isolation level read committed


