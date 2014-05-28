CREATE procedure QP_Rep_hsnonsurveyed 
   @Associate varchar(50),
   @Client varchar(50),
   @Study varchar(50),
   @dataset varchar(50)
as
set transaction isolation level read uncommitted
declare @procedurebegin datetime
set @procedurebegin = getdate()

declare @study_id int, @dataset_id int
declare @strsql varchar(8000)

select @Study_id=s.study_id 
from study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and c.client_id=s.client_id

select @dataset_id = dataset_id 
from data_set
where datload_dt = @dataset

if @study_id in (255)
   begin

set @strsql = 'select bv.encounteradmitdate as admitdate, bv.encounteradmitsource as admitsource, bv.encounterdrid as drid, ' +
	' bv.encounterdrlastname as drlastname, bv.encounterfacilitynum as facilitynum, bv.encountericd9 as icd9, ' +
	' bv.populationaddr as addr, bv.populationage as age, bv.populationcity as city, bv.populationst as st, ' +
	' bv.populationzip5 as zip5, bv.populationdob as dob, bv.populationfname as fname, bv.populationmiddle as middle, ' +
	' bv.populationlname as lname, bv.populationlangid as langid, bv.populationmarital as marital, bv.populationsex as sex, ' +
	' bv.populationssn as ssn, bv.facilityclinicnum as clinicnum, 	bv.encountervisittype as visittype, ' +
	' bv.encountervisitnum as visitnum, bv.encounterdischargedate as dischargedate ' +
	' from  datasetmember dsm, s' + convert(varchar,@study_id) + '.big_view bv left outer join samplepop sp ' +
	' on bv.populationpop_id = sp.pop_id ' + 
	' and sp.study_id = ' + convert(varchar,@study_id) +
	' where sp.pop_id is null ' +
	' and dsm.pop_id = bv.populationpop_id ' +
	' and dsm.enc_id = bv.encounterenc_id ' +
	' and dsm.dataset_id = ' + convert(varchar,@dataset_id) +
	' and bv.populationpop_id not in (select pop_id from tocl where study_id = ' + convert(varchar,@study_id) + ')'

exec(@strsql)

   end 

if @study_id in (189)
   begin

set @strsql = 'select bv.encounteradmitdate as admitdate, bv.encounteradmitsource as admitsource, bv.encounterdrid as drid, ' +
	' bv.encounterdrlastname as drlastname, bv.encounterfacilitynum as facilitynum, bv.encountericd9 as icd9, ' +
	' bv.populationaddr as addr, bv.populationage as age, bv.populationcity as city, bv.populationst as st, ' +
	' bv.populationzip5 as zip5, bv.populationdob as dob, bv.populationfname as fname, bv.populationmiddle as middle, ' +
	' bv.populationlname as lname, bv.populationlangid as langid, bv.populationmarital as marital, bv.populationsex as sex, ' +
	' bv.populationssn as ssn, bv.encounterclinicnum as clinicnum, bv.encountervisitnum as visitnum, ' +
	' bv.encounterdischargedate as dischargedate ' +
	' from  datasetmember dsm, s' + convert(varchar,@study_id) + '.big_view bv left outer join samplepop sp ' +
	' on bv.populationpop_id = sp.pop_id ' + 
	' and sp.study_id = ' + convert(varchar,@study_id) +
	' where sp.pop_id is null ' +
	' and dsm.pop_id = bv.populationpop_id ' +
	' and dsm.enc_id = bv.encounterenc_id ' +
	' and dsm.dataset_id = ' + convert(varchar,@dataset_id) +
	' and bv.populationpop_id not in (select pop_id from tocl where study_id = ' + convert(varchar,@study_id) + ')'

exec(@strsql)

   end 

if @study_id in (207)
   begin

set @strsql = 'select bv.encounteradmitdate as admitdate, bv.encounteradmitsource as admitsource, bv.encounterdrid as drid, ' +
	' bv.encounterfacilitynum as facilitynum, bv.encountericd9 as icd9, bv.populationaddr as addr, bv.populationage as age, ' +
	' bv.populationcity as city, bv.populationst as st, bv.populationzip5 as zip5, bv.populationdob as dob, ' +
	' bv.populationfname as fname, bv.populationmiddle as middle, bv.populationlname as lname, bv.populationlangid as langid, ' + 
	' bv.populationmarital as marital, bv.populationsex as sex, bv.populationssn as ssn, bv.encounterclinicnum as clinicnum, ' +
	' bv.encountervisittype as visittype, bv.encountervisitnum as visitnum, bv.encounterdischargedate as dischargedate ' +
	' from  datasetmember dsm, s' + convert(varchar,@study_id) + '.big_view bv left outer join samplepop sp ' +
	' on bv.populationpop_id = sp.pop_id ' + 
	' and sp.study_id = ' + convert(varchar,@study_id) +
	' where sp.pop_id is null ' +
	' and dsm.pop_id = bv.populationpop_id ' +
	' and dsm.enc_id = bv.encounterenc_id ' +
	' and dsm.dataset_id = ' + convert(varchar,@dataset_id) +
	' and bv.populationpop_id not in (select pop_id from tocl where study_id = ' + convert(varchar,@study_id) + ')'

exec(@strsql)

   end 

if @study_id in (187)
   begin

set @strsql = 'select bv.encounteradmitdate as admitdate, bv.encounteradmitsource as admitsource, bv.encounterdrid as drid, ' +
	' bv.encountercpt4 as cpt4, bv.encounterfacilitynum as facilitynum, bv.encountericd9 as icd9, bv.populationaddr as addr, ' +
	' bv.populationage as age, bv.populationcity as city, bv.populationst as st, bv.populationzip5 as zip5, ' +
	' bv.populationdob as dob, bv.populationfname as fname, bv.populationmiddle as middle, bv.populationlname as lname, ' +
	' bv.populationlangid as langid, bv.populationmarital as marital, bv.populationsex as sex, bv.populationssn as ssn, ' +
	' bv.encountervisittype as visittype, bv.encountervisitnum as visitnum, bv.encounterdischargedate as dischargedate ' +
	' from  datasetmember dsm, s' + convert(varchar,@study_id) + '.big_view bv left outer join samplepop sp ' +
	' on bv.populationpop_id = sp.pop_id ' + 
	' and sp.study_id = ' + convert(varchar,@study_id) +
	' where sp.pop_id is null ' +
	' and dsm.pop_id = bv.populationpop_id ' +
	' and dsm.enc_id = bv.encounterenc_id ' +
	' and dsm.dataset_id = ' + convert(varchar,@dataset_id) +
	' and populationpop_id not in (select pop_id from tocl where study_id = ' + convert(varchar,@study_id) + ')'

exec(@strsql)

   end

if @study_id in (190)
   begin

set @strsql = 'select bv.encounteradmitdate as admitdate, bv.encounteradmitsource as admitsource, bv.encounterdrid as drid, ' +
	' bv.encountercpt4 as cpt4, bv.encounterfacilitynum as facilitynum, bv.encountericd9 as icd9, bv.populationaddr as addr, ' +
	' bv.populationage as age, bv.populationcity as city, bv.populationst as st, bv.populationzip5 as zip5, ' +
	' bv.populationdob as dob, bv.populationfname as fname, bv.populationmiddle as middle, bv.populationlname as lname, ' +
	' bv.populationlangid as langid, bv.populationmarital as marital, bv.populationsex as sex, bv.populationssn as ssn, ' +
	' bv.encountervisittype as visittype, bv.encountervisitnum as visitnum, bv.encounterdischargedate as dischargedate ' +
	' from  datasetmember dsm, s' + convert(varchar,@study_id) + '.big_view bv left outer join samplepop sp ' +
	' on bv.populationpop_id = sp.pop_id ' + 
	' and sp.study_id = ' + convert(varchar,@study_id) +
	' where sp.pop_id is null ' +
	' and dsm.pop_id = bv.populationpop_id ' +
	' and dsm.enc_id = bv.encounterenc_id ' +
	' and dsm.dataset_id = ' + convert(varchar,@dataset_id) +
	' and populationpop_id not in (select pop_id from tocl where study_id = ' + convert(varchar,@study_id) + ')'

exec(@strsql)

   end

if @study_id in (202)
   begin

set @strsql = 'select bv.encounteradmitdate as admitdate, bv.encounteradmitsource as admitsource, bv.encounterdrid as drid, ' +
	' bv.encountercpt4 as cpt4, bv.encounterfacilitynum as facilitynum, bv.encountericd9 as icd9, bv.populationaddr as addr, ' +
	' bv.populationage as age, bv.populationcity as city, bv.populationst as st, bv.populationzip5 as zip5, ' +
	' bv.populationdob as dob, bv.populationfname as fname, bv.populationmiddle as middle, bv.populationlname as lname, ' +
	' bv.populationlangid as langid, bv.populationmarital as marital, bv.populationsex as sex, bv.populationssn as ssn, ' +
	' bv.encountervisittype as visittype, bv.encountervisitnum as visitnum, bv.encounterdischargedate as dischargedate ' +
	' from  datasetmember dsm, s' + convert(varchar,@study_id) + '.big_view bv left outer join samplepop sp ' +
	' on bv.populationpop_id = sp.pop_id ' + 
	' and sp.study_id = ' + convert(varchar,@study_id) +
	' where sp.pop_id is null ' +
	' and dsm.pop_id = bv.populationpop_id ' +
	' and dsm.enc_id = bv.encounterenc_id ' +
	' and dsm.dataset_id = ' + convert(varchar,@dataset_id) +
	' and populationpop_id not in (select pop_id from tocl where study_id = ' + convert(varchar,@study_id) + ')'

exec(@strsql)

   end

if @study_id in (235)
   begin

set @strsql = 'select bv.encounteradmitdate as admitdate, bv.encounteradmitsource as admitsource, bv.encounterdrid as drid, ' +
	' bv.encountercpt4 as cpt4, bv.encounterfacilitynum as facilitynum, bv.encountericd9 as icd9, bv.populationaddr as addr, ' +
	' bv.populationage as age, bv.populationcity as city, bv.populationst as st, bv.populationzip5 as zip5, ' +
	' bv.populationdob as dob, bv.populationfname as fname, bv.populationmiddle as middle, bv.populationlname as lname, ' +
	' bv.populationlangid as langid, bv.populationmarital as marital, bv.populationsex as sex, bv.populationssn as ssn ' +
	' from  datasetmember dsm, s' + convert(varchar,@study_id) + '.big_view bv left outer join samplepop sp ' +
	' on bv.populationpop_id = sp.pop_id ' + 
	' and sp.study_id = ' + convert(varchar,@study_id) +
	' where sp.pop_id is null ' +
	' and dsm.pop_id = bv.populationpop_id ' +
	' and dsm.enc_id = bv.encounterenc_id ' +
	' and dsm.dataset_id = ' + convert(varchar,@dataset_id) +
	' and populationpop_id not in (select pop_id from tocl where study_id = ' + convert(varchar,@study_id) + ')'

exec(@strsql)

   end

insert into dashboardlog (report, associate, client, study, procedurebegin, procedureend) select 'HealthSouth NonSurveyed', @associate, @client, @study, @procedurebegin, getdate()

set transaction isolation level read committed


