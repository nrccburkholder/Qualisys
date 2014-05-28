CREATE procedure QP_Rep_ContactRequest
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50)
as
--If this procedure is to be used, we need to get rid of the unikeys linkages.
RETURN

set transaction isolation level read uncommitted
declare @study_id int, @survey_id int, @cutofftype char(1)

select @study_id = sd.study_id, @survey_id = sd.survey_id, @cutofftype = strcutoffresponse_cd
from survey_def sd, study s, client c
where c.strclient_nm = @client
and c.client_id = s.client_id
and s.strstudy_nm = @study
and s.study_id = sd.study_id
and sd.strsurvey_nm = @survey

create table #mf (
strtable_nm varchar(20), strfield_nm varchar(20), strfielddatatype varchar(10), intfieldlength varchar(10), datatype varchar(20))

create table #mf2 (counter int identity, rank int, 
strtable_nm varchar(20), strfield_nm varchar(20), strfielddatatype varchar(10), intfieldlength varchar(10), datatype varchar(20))

create table #results (
qf_id int, su_id int, sampledate datetime, returned datetime, pop_id int)

create table #select (
field varchar(60), rank tinyint)

insert into #select 
select 'Comment', 1

insert into #select 
select 'qf_id', 20

insert into #select 
select 'su_id', 21

insert into #select 
select 'SampleDate', 10

insert into #select 
select 'Returned', 11

insert into #select 
select 'pop_id', 22

insert into #mf2 (strtable_nm, strfield_nm, strfielddatatype, intfieldlength)
select strtable_nm, strfield_nm, strfielddatatype, intfieldlength
from metadata_view
where study_id = @study_id
and strtable_nm in ('population','encounter')
and strfield_nm in ('areacode','phone','fname','lname','mrn','visitnum','visittype','dischargeunit')
union
select strtable_nm, strfield_nm, strfielddatatype, intfieldlength
from metadata_view
where study_id = @study_id
and strtable_nm in ('population','encounter')
and bitmatchfield_flg = 1

select strfield_nm, min(counter) as keep
into #dedup
from #mf2
group by strfield_nm

insert into #mf
select strtable_nm, m.strfield_nm, strfielddatatype, intfieldlength, datatype
from #dedup d, #mf2 m
where d.keep = m.counter

begin

  if @cutofftype = 0
   insert into #mf
   select 'sampleset', 'datsamplecreate_dt', 'D', null , 'Datetime'

  else if @cutofftype = 1
   insert into #mf
   select 'questionform', 'datreturned', 'D', null, 'Datetime'

  else 
   insert into #mf
   select strtable_nm, strField_nm, 'D', null, 'Datetime'
      from survey_def sd, metatable mt, metafield mf
      where cutofftable_id=mt.table_id
        and cutofffield_id=mf.field_id
        and survey_id=@survey_id

end

insert into #select (field)
select strfield_nm from #mf

update #select 
set rank = case field when 'LName' then 2 when 'FName' then 3 when 'AreaCode' then 4 when 'Phone' then 5 when 'MRN' then 6
when 'VisitType' then 7 when 'DischargeUnit' then 8 when 'VisitNum' then 9 when 'datsamplecreate_dt' then 16
when 'datreturned' then 17 else rank end

update #select 
set rank = 18 where rank is null

update #mf 
set datatype = case strfielddatatype when 'S' then 'Varchar' when 'I' then 'Int' when 'D' then 'Datetime' else datatype end

declare @strsql varchar(8000), @fieldname varchar(20), @strfielddatatype varchar(10), @intfieldlength varchar(10), @datatype varchar(20)
declare @strtable_nm varchar(20)

declare createtable cursor for
select strfield_nm, intfieldlength, datatype 
from #mf
where datatype <> 'datetime'
and datatype <> 'Int'

set @strsql = 'alter table #results add '

open createtable

fetch next from createtable into @fieldname, @intfieldlength, @datatype
while @@fetch_status = 0

begin

set @strsql = @strsql + @fieldname + ' ' + @datatype + '(' + @intfieldlength + '), ' 

fetch next from createtable into @fieldname, @intfieldlength, @datatype

end

close createtable
deallocate createtable

declare createtable2 cursor for
select strfield_nm, intfieldlength, datatype 
from #mf
where datatype in ('datetime','Int')

open createtable2

fetch next from createtable2 into @fieldname, @intfieldlength, @datatype
while @@fetch_status = 0

begin

set @strsql = @strsql + @fieldname + ' ' + @datatype + ', ' 

fetch next from createtable2 into @fieldname, @intfieldlength, @datatype

end

close createtable2
deallocate createtable2

set @strsql = @strsql + 'Comment varchar(60) '
--print @strsql
exec (@strsql)

set @strsql = 'insert into #results (qf_id, su_id, pop_id, Comment) ' +
	' select qf.questionform_id, sampleunit_id, pop_id, intresponseval ' +
	' from questionresult qr, questionform qf, samplepop sp ' +
	' where qstncore = 9586 ' +
	' and intresponseval > -9 ' +
	' and survey_id = ' + convert(varchar(10),@survey_id) +
	' and qr.questionform_id = qf.questionform_id ' +
	' and qf.samplepop_id = sp.samplepop_id ' +
	' and qf.datresultsimported > (select isnull(max(datDateAutoExported),''1/1/1900'' ) ' +
	'			from commentautoexportlog ' +
	'			where survey_id = ' + convert(varchar(10),@survey_id) +
	'			and commenttype_id = 4) '

exec (@strsql)

declare updatetable cursor for
	select strtable_nm, strfield_nm from #mf where strtable_nm in ('population','encounter') and strfield_nm <> 'pop_id'

set @strsql = 'update r set r.sampledate = ss.datsamplecreate_dt, r.returned = qf.datreturned, ' 

open updatetable

fetch next from updatetable into @strtable_nm, @fieldname
while @@fetch_status = 0

begin

set @strsql = @strsql + @fieldname + ' = bv.' + @strtable_nm + @fieldname + ', '

fetch next from updatetable into @strtable_nm, @fieldname

end

close updatetable
deallocate updatetable

set @strsql = left(@strsql,(len(@strsql) - 1))

if (select count(*) from #mf where strtable_nm = 'encounter') > 0
begin

declare @table_id int
set @table_id = (select table_id from metatable
where study_id = @study_id
and strtable_nm = 'encounter')

set @strsql = @strsql + ' from s' + convert(varchar(10),@study_id) + '.big_view bv, samplepop sp, sampleset ss, ' +
	' questionform qf, #results r, s' + convert(varchar(10),@study_id) + '.unikeys u ' +
	' where r.qf_id = qf.questionform_id ' +
	' and qf.samplepop_id = sp.samplepop_id ' +
	' and sp.sampleset_id = u.sampleset_id ' +
	' and sp.pop_id = u.pop_id ' +
	' and sp.sampleset_id = ss.sampleset_id ' +
	' and u.sampleunit_id = r.su_id ' +
	' and u.table_id = ' + convert(varchar(10),@table_id) +
	' and u.keyvalue = bv.encounterenc_id '

end

else

begin

set @strsql = @strsql + ' from s' + convert(varchar(10),@study_id) + '.big_view bv, samplepop sp, sampleset ss, ' +
	' questionform qf, #results r ' +
	' where r.qf_id = qf.questionform_id ' +
	' and qf.samplepop_id = sp.samplepop_id ' +
	' and sp.sampleset_id = ss.sampleset_id ' +
	' and sp.pop_id = bv.populationpop_id '

end

exec (@strsql)

set @strsql = 'update r ' +
	' set r.Comment = ss.label ' +
	' from #results r, questionform qf, sel_qstns sq, sel_scls ss ' +
	' where r.qf_id = qf.questionform_id ' +
	' and qf.survey_id = sq.survey_id ' +
	' and sq.qstncore = 9586 ' +
	' and sq.scaleid = ss.qpc_id ' +
	' and sq.survey_id = ss.survey_id ' +
	' and r.Comment = ss.val ' 

exec (@strsql)

set @strsql = ' update #results ' +
	' set Comment = "Multiple Responses Chosen" ' +
	' where Comment like "-%" ' 

exec (@strsql)
if @cutofftype = 0
set @strsql = 'alter table #results drop column returned'

else if @cutofftype = 1 
set @strsql = 'alter table #results drop column sampledate'

else
begin
set @strsql = 'alter table #results drop column returned ' +
	' alter table #results drop column sampledate ' +
	' delete #select where field in ("sampledate","returned")'
end

exec (@strsql)

set @strsql = 'if (select count(*) from #results) = 0 ' +
	' insert into #results (qf_id) ' +
	' select null'

exec (@strsql)

declare @sel varchar(200), @sel2 varchar(50)

select @sel = 'select '

declare sel cursor for 
select field from #select order by rank

open sel

fetch next from sel into @sel2
while @@fetch_status = 0

begin

set @sel = @sel + @sel2 + ','

fetch next from sel into @sel2

end

close sel
deallocate sel

set @sel = left(@sel,(len(@sel) - 1))

set @strsql = @sel + ' from #results order by comment'

exec (@strsql)

drop table #mf
drop table #mf2
drop table #results
drop table #dedup
drop table #select 

insert into commentautoexportlog (survey_id, datdateautoexported, commenttype_id)
select @survey_id, getdate(), 4

set transaction isolation level read committed


