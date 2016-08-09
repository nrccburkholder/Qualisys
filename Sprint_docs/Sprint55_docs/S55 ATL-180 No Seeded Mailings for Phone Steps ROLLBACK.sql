/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S55 ATL-180 No Seeded Mailings for Phone Steps

	ATL-693 Change sampling so created seed records don't have a phone number
	ATL-694 Change FormGen so phone steps don't get scheduled for seeded mailings

	Tim Butler

	ALTER proc [dbo].[QCL_PopulateSeedMailingInfo]
	ALTER PROCEDURE [dbo].[sp_FG_FormGen_Pop_PreMailingWork]

*/

use QP_Prod

GO
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
--Dana Petersen 10/09/2014 - Changed query to select seed unit to look for seed unit field >0 instead of =1
--	This allows us to use the CAHPSType_id field in Sampleunit
ALTER proc [dbo].[QCL_PopulateSeedMailingInfo]
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

	--changed from "= 1" to "> 0" to accommodate CAHPSType_id field refactoring of SampleUnit - dmp 10/09/2014
	select @sql = 'select top 1 sampleunit_id into tmp_seededsampleunit from sampleunit where sampleplan_id = ' + cast(@sampleplan_id as varchar) + ' and ' + @seedunitfield + ' > 0'
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

GO


USE [QP_Prod]

GO
/*
Modified 5/23/2 BD  Adding 6 hours to GETDATE to automatically pick up Surveys that are set to generate after midnight.  
Modified 8/15/2 BD  Added the ability to generate multiple Mailingsteps in the same night.
Modified 7/3/3 BD  Remove duplicate Mailstep generations for the same person.  This can happen when the generation of
	firsts are rolled back, but the second Mailstep is not deleted. 
Modified 6/22/2014 TSB Added QuestionnaireType_ID to FG_PreMailingWork insert - AllCahps Sprint 2 R3.5
Modified 8/05/2014 TSB Modified QuestionnaireType_ID value to come from SurveySubType.Subtype_ID
*/
ALTER PROCEDURE [dbo].[sp_FG_FormGen_Pop_PreMailingWork]
AS
TRUNCATE TABLE FG_PreMailingWork

DECLARE @Study_id INT
DECLARE @sqlzip VARCHAR (250)
DECLARE ZipCursor CURSOR FOR SELECT DISTINCT Study_id FROM FG_PreMailingWork

-- Create a temp table for all Questionnaire Type SubTypes 8/5/2014 TSB
SELECT sst.Survey_id, sst.SubType_id
INTO #SurveyQuestionnaireSubtypes
FROM SurveySubtype sst
inner join Subtype st on st.Subtype_id = sst.Subtype_id
WHERE st.SubtypeCategory_id = 2 -- 2 is QuestionnaireType category  

--Modified 8/5/2014 TSB - changed to use ANSI-compliant join and #SurveyQuestionnaireSubtypes
-- First insert the already Scheduled Surveys
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg, QuestionnaireType_ID)
SELECT SD.Study_id, SD.Survey_id, SP.SamplePop_id, SP.SampleSet_id, SP.Pop_id, SM.ScheduledMailing_id, SM.MailingStep_id, SM.Methodology_id, SM.OverRideItem_id, SD.Priority_Flg, SQSS.Subtype_id QuestionnaireType_ID
FROM   ScheduledMailing SM(NOLOCK)
INNER JOIN MailingMethodology MM(NOLOCK) ON MM.Methodology_id = SM.Methodology_id
INNER JOIN SamplePop SP(NOLOCK) ON SP.SamplePop_id = SM.SamplePop_id
INNER JOIN Survey_def SD(NOLOCK) ON MM.Survey_id = SD.Survey_id
LEFT JOIN #SurveyQuestionnaireSubtypes SQSS ON SQSS.Survey_id = sd.Survey_ID
WHERE  SM.SentMail_id IS NULL AND
       SM.datGenerate <= DATEADD(HOUR,6,GETDATE()) AND
       SD.bitFormGenRelease = 1 AND
       SM.ScheduledMailing_id NOT IN (SELECT DISTINCT ScheduledMailing_id FROM FormGenError
	WHERE ScheduledMailing_id IS NOT NULL)

--Now to get rid of duplicated Mailsteps for people
SELECT SamplePop_id, MailingStep_id, MAX(ScheduledMailing_id) ScheduledMailing_id
INTO #keep
FROM fg_preMailingWork
GROUP BY SamplePop_id, MailingStep_id

--Get the list of scheduledmailing_ids to delete
SELECT f.ScheduledMailing_id 
INTO #del
FROM #keep t RIGHT OUTER JOIN fg_preMailingWork f
ON t.SamplePop_id = f.SamplePop_id
AND t.MailingStep_id = f.MailingStep_id
AND t.ScheduledMailing_id = f.ScheduledMailing_id
WHERE t.ScheduledMailing_id IS NULL

--Get rid of the fg_premailingwork records
DELETE f
FROM #del t, fg_preMailingWork f
where t.ScheduledMailing_id = f.ScheduledMailing_id

--Now to get rid of the scheduledmailing records
DELETE schm
FROM #del t, ScheduledMailing schm
where t.ScheduledMailing_id = schm.ScheduledMailing_id

--Clean up
DROP TABLE #del
DROP TABLE #keep
DROP TABLE #SurveyQuestionnaireSubtypes

--Determine additional Mailingsteps that need to generate
SELECT Study_id, f.Survey_id, SampleSet_id, Pop_id, Priority_flg, ms.MailingStep_id, SamplePop_id, f.Methodology_id, GETDATE() datgenerate, QuestionnaireType_ID, ms.MailingStepMethod_id
into #temp
FROM fg_preMailingWork f(NOLOCK), Mailingstep ms(NOLOCK)
WHERE f.MailingStep_id = ms.mmMailingStep_id
AND f.MailingStep_id <> ms.MailingStep_id

--Delete records already Scheduled
DELETE t
FROM #temp t, ScheduledMailing schm
WHERE t.MailingStep_id = schm.MailingStep_id
AND t.SamplePop_id = schm.SamplePop_id

--Schedule the additional Mailingsteps
INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, OverRideItem_id, sentMail_id, Methodology_id, datgenerate)
SELECT MailingStep_id, SamplePop_id, NULL, NULL, Methodology_id, datgenerate
FROM #temp


--Insert the newly Scheduled Mailingsteps
INSERT INTO FG_PreMailingWork (Study_id, Survey_id, SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, MailingStep_id, Methodology_id, OverRideItem_id, Priority_Flg, QuestionnaireType_ID)
SELECT Study_id, Survey_id, t.SamplePop_id, SampleSet_id, Pop_id, ScheduledMailing_id, t.MailingStep_id, t.Methodology_id, OverRideItem_id, Priority_Flg, t.QuestionnaireType_ID
FROM   #temp t, ScheduledMailing schm(NOLOCK)
WHERE  t.MailingStep_id = schm.MailingStep_id
AND t.SamplePop_id = schm.SamplePop_id
AND schm.OverRideItem_id is NULL

DROP TABLE #temp
--remove if blowup end
--Update the zip code fields
OPEN ZipCursor
FETCH NEXT FROM ZipCursor INTO @Study_id
WHILE @@FETCH_STATUS = 0
BEGIN
 SET @SqlZip = 'UPDATE FG_PreMailingWork set zip5 =  p.zip5, zip4 = p.zip4 ' + CHAR(10) + 
	' FROM s' + CONVERT(VARCHAR(10),@Study_id) + '.Population p, FG_PreMailingWork pm, SamplePop sp ' + CHAR(10) + 
	' WHERE pm.Study_id = ' + CONVERT(VARCHAR(10),@Study_id) + CHAR(10) +
	' AND pm.SamplePop_id=sp.SamplePop_id ' + CHAR(10) +
	' AND sp.Pop_id = p.Pop_id'
 EXEC (@SqlZip)
 FETCH NEXT FROM ZipCursor INTO @Study_id
END
CLOSE ZipCursor
DEALLOCATE ZipCursor
