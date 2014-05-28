--This proc creates rows in selectedsample, samplepop, population, and encounter for people to receive seeded mailings.
--It also uses the seedmailingreceiver (holds list of people to receive seeded mailings) and seedmailingsamplepop (log).
--
--The process is to identify a random person from the passed in sampleset and copy his/her data into a temp table.  Then we 
--update the name/address/etc from a seed person in our seedmailingreceiver table, but with negative pop_id and enc_id.  
--Then that updated data is copied into appropriate tables.  The end result is a seed person gets tacked onto the end of
--the sampleset as if they were originally sampled.  The seed person will then receive a mailing, but won't be included 
--in the extract or response statistics, etc.
--
--Don Mayhew 09/20/2011 - Create date.
--Don Mayhew 11/10/2011 - Added modification to match field so that seed data in population won't get overwritten by re-applies.
--
CREATE proc QCL_PopulateSeedMailingInfo
	@sampleset_id int
as

declare @survey_id int
declare @sampleplan_id int
declare @study_id int
declare @study varchar(10)
declare @sampleunit_id int
declare @seedunitfield varchar(42)
declare @mailingreceiver_id int
declare @receiverpop_id int
declare @receiversamplepop_id int
declare @randomsampledpop_id int
declare @randomsampledenc_id int
declare @sql varchar(8000)
declare @sql2 varchar(8000)
declare @matchfield varchar(100)


--Drop temp tables if they exist.
if exists (select 1 from information_schema.tables where table_name = 'tmp_seededpopulationinfo' and table_schema = 'dbo')
	drop table dbo.tmp_seededpopulationinfo

if exists (select 1 from information_schema.tables where table_name = 'tmp_seededencounterinfo' and table_schema = 'dbo')
	drop table dbo.tmp_seededencounterinfo

if exists (select 1 from information_schema.tables where table_name = 'tmp_seedpopfound' and table_schema = 'dbo')
	drop table dbo.tmp_seedpopfound

if exists (select 1 from information_schema.tables where table_name = 'tmp_seededsampleunit' and table_schema = 'dbo')
	drop table dbo.tmp_seededsampleunit

if exists (select 1 from information_schema.tables where table_name = 'tmp_person' and table_schema = 'dbo')
	drop table dbo.tmp_person



--****************************************************************************************
--**  Randomly select a person to copy data from for our seed person
--****************************************************************************************

select @survey_id = survey_id 
from sampleset 
where sampleset_id = @sampleset_id

select @sampleplan_id = sampleplan_id
from sampleplan
where survey_id = @survey_id

select @seedunitfield = seedunitfield
from surveytype st inner join survey_def sd
 on st.surveytype_id = sd.surveytype_id
where sd.survey_id = @survey_id


--If seed unit field exists, then find an appropriate sampleunit_id to copy data from
if @seedunitfield is not null
begin

	select @sql = 'select top 1 sampleunit_id into tmp_seededsampleunit from sampleunit where sampleplan_id = ' + cast(@sampleplan_id as varchar) + ' and ' + @seedunitfield + ' = 1'
	exec (@sql)

	--Used below to filter sampleunit, if one is found
	select @sql2 = ' and sampleunit_id = (select sampleunit_id from tmp_seededsampleunit)'

end
else
begin
	--print 'Survey_id (' + cast(@survey_id as varchar) + ') does not have a Seed Unit Field.  Exiting proc.'
	--return -1

	select @sql2 = ''
end


--Pick a random person from the sampleset (and from the sampleunit, if one is found)
select @sql = 'select top 1 pop_id, enc_id 
	into tmp_person
	from selectedsample
	where sampleset_id = ' + cast(@sampleset_id as varchar) + '
	and strunitselecttype = ''D'''
	+ @sql2

exec (@sql)

select @randomsampledpop_id = pop_id, @randomsampledenc_id = enc_id 
from tmp_person


--Get all selectedsample rows for the randomly selected person in the passed in sampleset
select sampleset_id, study_id, pop_id, sampleunit_id, strunitselecttype, intextracted_flg, enc_id, reportdate, sampleencounterdate 
into #tmp_selectedsample
from selectedsample
where sampleset_id = @sampleset_id
and pop_id = @randomsampledpop_id
and enc_id = @randomsampledenc_id


--Make sure the passed in sampleset exists.
if @@rowcount = 0
begin
	print 'Sampleset (' + cast(@sampleset_id as varchar) + ') does not exist.  Exiting proc.'
	return -2
end

select @study_id = study_id from #tmp_selectedsample
select @study = cast(@study_id as varchar)


--****************************************************************************************
--**  Get the next active person who should receive a seeded mailing.
--**  Each time this is run, we go to the next active row in seedmailingreceiver.
--****************************************************************************************

--Find last person who received a seeded mailing.
select top 1 @mailingreceiver_id = mailingreceiver_id 
from seedmailingsamplepop
order by datused desc

--Find next active seed receiver.
select @mailingreceiver_id = min(mailingreceiver_id)
from seedmailingreceiver
where mailingreceiver_id > @mailingreceiver_id
and active = 1

--If none found, we're probably at end of list and can start again at the beginning.
if @mailingreceiver_id is null
	select @mailingreceiver_id = min(mailingreceiver_id)
	from seedmailingreceiver
	where active = 1

--If we're still not finding anything then there's a problem, i.e. table is empty or nobody is marked active.
if @mailingreceiver_id is null
begin
	print 'No active rows found in seedmailingreceiver table.  Exiting proc.'
	return -3
end


--Get the pop_id of the seed receiver.
select @receiverpop_id = pop_id
from seedmailingreceiver
where mailingreceiver_id = @mailingreceiver_id

--****************************************************************************************
--**  Populate selectedsample and samplepop.
--****************************************************************************************

--Use our receiver's pop_id for both pop_id and enc_id.
update #tmp_selectedsample set
	pop_id = @receiverpop_id,
	enc_id = @receiverpop_id

insert into selectedsample (sampleset_id, study_id, pop_id, sampleunit_id, strunitselecttype, intextracted_flg, enc_id, reportdate, sampleencounterdate)
select sampleset_id, study_id, pop_id, sampleunit_id, strunitselecttype, intextracted_flg, enc_id, reportdate, sampleencounterdate
from #tmp_selectedsample

insert into samplepop (sampleset_id, study_id, pop_id, bitbadaddress, bitbadphone)
select distinct sampleset_id, study_id, pop_id, 0, 0
from #tmp_selectedsample

select @receiversamplepop_id = scope_identity()

--****************************************************************************************
--**  Populate population, encounter, and log table.
--****************************************************************************************

--See if our seed person already exists in the study owned population table.
select @sql = 'select pop_id into dbo.tmp_seedpopfound from s' + @study + '.population where pop_id = ' + cast(@receiverpop_id as varchar)
exec(@sql)

--If a row isn't found, get the row from our randomly selected person and copy/update it for our seed person.  Then insert that seed person data
--back into population and encounter.
if @@rowcount = 0
begin
	--population
	select @sql = 'select top 1 * into tmp_seededpopulationinfo from s' + @study + '.population where pop_id = ' + cast(@randomsampledpop_id as varchar)
	exec(@sql)

	update tmp_seededpopulationinfo set 
		pop_id = @receiverpop_id

	update t set
		LName = smr.LName,
		FName = smr.FName,
		Addr = smr.Addr,
		Addr2 = smr.Addr2,
		City = smr.City,
		ST = smr.ST,
		ZIP5 = smr.ZIP5,
		Zip4 = smr.Zip4,
		Del_Pt = smr.Del_Pt,
		sex = smr.sex
	from tmp_seededpopulationinfo t inner join seedmailingreceiver smr
	 on t.pop_id = smr.pop_id


	--Find match field for this study (in the case of multiple match fields, just pick one).
	select @matchfield = strfield_nm from metadata_view where study_id = @study_id and bitmatchfield_flg = 1 and strtable_nm = 'population'
	if @matchfield is null select @matchfield = 'pop_mtch'

	--Modify the value in the match field so that this row won't later be overwritten if a file is re-applied.
	select @sql = 'update tmp_seededpopulationinfo set ' + @matchfield + ' = ''SM_'' + ' + @matchfield
	exec (@sql)

	--Insert our seed row into the population table.
	select @sql = 'insert into s' + @study + '.population select * from tmp_seededpopulationinfo'
	exec (@sql)



	--encounter
	select @sql = 'select top 1 * into tmp_seededencounterinfo from s' + @study + '.encounter where enc_id = ' + cast(@randomsampledenc_id as varchar)
	exec(@sql)

	update tmp_seededencounterinfo set 
		pop_id = @receiverpop_id,
		enc_id = @receiverpop_id
	 
	----Find match field for this study (in the case of multiple match fields, just pick one).
	--select @matchfield = strfield_nm from metadata_view where study_id = @study_id and bitmatchfield_flg = 1 and strtable_nm = 'encounter'
	--if @matchfield is null select @matchfield = 'enc_mtch'

	----Modify the value in the match field so that this row won't later be overwritten in a load to live.
	--select @sql = 'update tmp_seededencounterinfo set ' + @matchfield + ' = ''SM_'' + ' + @matchfield
	--exec (@sql)

	select @sql = 'insert into s' + @study + '.encounter select * from tmp_seededencounterinfo'
	exec (@sql)
end

--Log tables
insert into seedmailingsamplepop 
select @receiversamplepop_id, @mailingreceiver_id, getdate()

update tobeseeded set
	isseeded = 1,
	datseeded = getdate()
where survey_id = @survey_id
and yearqtr = (select replace(dbo.yearqtr(isnull(datdaterange_fromdate,getdate())),'_','Q') from sampleset where sampleset_id = @sampleset_id)
and isseeded = 0



--****************************************************************************************
--**  Clean up
--****************************************************************************************

drop table #tmp_selectedsample

if exists (select 1 from information_schema.tables where table_name = 'tmp_seededpopulationinfo' and table_schema = 'dbo')
	drop table dbo.tmp_seededpopulationinfo

if exists (select 1 from information_schema.tables where table_name = 'tmp_seededencounterinfo' and table_schema = 'dbo')
	drop table dbo.tmp_seededencounterinfo

if exists (select 1 from information_schema.tables where table_name = 'tmp_seedpopfound' and table_schema = 'dbo')
	drop table dbo.tmp_seedpopfound

if exists (select 1 from information_schema.tables where table_name = 'tmp_seededsampleunit' and table_schema = 'dbo')
	drop table dbo.tmp_seededsampleunit

if exists (select 1 from information_schema.tables where table_name = 'tmp_person' and table_schema = 'dbo')
	drop table dbo.tmp_person


