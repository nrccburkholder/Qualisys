-- =============================================
-- Author:		<Dana Petersen>
-- Create date: <08/10/2012>
-- Description:	<Data source for the OCS HH File Status SSRS report>

--03/21/2013 dmp Changed to limit to HH-CAHPS survey types.
-- =============================================
CREATE PROCEDURE [dbo].[SSRS_OCSHHSampleFileStatus] 
	@month varchar(2),
	@year varchar(4),
	@inDebug bit = 0
AS
BEGIN
	SET NOCOUNT ON;
	
	declare @LoadBegDate varchar(10), @LoadEndDate varchar(10)
	set @LoadBegDate = @month + '/01/' + @year
	set @LoadEndDate = convert(varchar(10),DATEADD("M",1,@LoadBegDate),101)
	
	if @inDebug = 1 print @month
	if @inDebug = 1 print @year
	if @inDebug = 1 print @LoadBegDate
	if @inDebug = 1 print @LoadEndDate
	
--Get the list of surveys for OCS clients
create table #tmpOCSSurveys (clientname varchar(100), client_id int, studyname varchar(20), study_id int, surveyname varchar(20), survey_id int)

insert into #tmpOCSSurveys
select c.STRCLIENT_NM, c.CLIENT_ID, s.STRSTUDY_NM, s.STUDY_ID, sd.STRSURVEY_NM, sd.SURVEY_ID 
from CLIENT c, study s, SURVEY_DEF sd
where sd.STUDY_ID = s.STUDY_ID
and s.CLIENT_ID = c.CLIENT_ID
and c.ClientGroup_ID = 5
and c.active = 1 and s.active = 1 and sd.active = 1
and sd.surveytype_id = 3  --only HH-CAHPS surveys
order by c.STRCLIENT_NM, s.STRSTUDY_NM, sd.STRSURVEY_NM

if @inDebug = 1 print 'got survey list'
if @inDebug = 1 select '#tmpOCSSurveys', * from #tmpOCSSurveys

--Get the facility info
create table #tmpOCSFacilities (clientname varchar(100), client_id int, studyname varchar(20), 
study_id int, surveyname varchar(20), survey_id int, MedicareNumber varchar(10))

insert into  #tmpOCSFacilities
select distinct tos.*, suf.MedicareNumber from #tmpOCSSurveys tos left outer join SAMPLEPLAN sp
on sp.SURVEY_ID = tos.survey_id
left outer join SAMPLEUNIT su
on sp.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
left outer join SUFacility suf
on su.SUFacility_id = suf.SUFacility_id
where su.bitHHCAHPS = 1

if @inDebug = 1 print 'got facilities'
if @inDebug = 1 select '#tmpOCSFacilities', * from #tmpOCSFacilities

--Create a table to hold the status of the file; will be updated at several stages of gathering data
create table #Status (CCN varchar(6), survey_id int, CurrentStatus varchar(50))

insert into #Status (CCN, survey_id)
select medicarenumber, survey_id from #tmpOCSFacilities

----Default status is that nothing has come in
update #Status
set currentstatus = 'No File'

if @inDebug = 1 print 'created status table'
if @inDebug = 1 select '#Status1', * from #Status

--Get the upload file and data file info for each CCN, from Minerva
create table #tmpDataFiles (CCN varchar(6), OrigFile_nm varchar(100), UploadState varchar(50),
UploadDatOccurred datetime, DataFile_id int, intRecords int, intLoaded int, datEnd datetime, 
DataFileDatOccurred datetime, MaxEncDate datetime, DataSet_id int, DataFileState varchar(50), survey_id int)

insert into #tmpDataFiles 
exec Pervasive.QP_DataLoad.dbo.GetOCSHHFileStatus @LoadBegDate, @LoadEndDate

if @inDebug = 1 print 'got data file info'
if @inDebug = 1 select '#tmpDataFiles', * from #tmpDataFiles

--Update the status with upload file and data file state info
update #Status
set currentstatus =  uploadstate from #tmpDataFiles 
where #Status.ccn = #tmpDataFiles.ccn
and #Status.survey_id = #tmpDataFiles.survey_id
and #tmpDataFiles.origfile_nm is not null

update #Status
set currentstatus =  DataFileState from #tmpDataFiles 
where #Status.ccn = #tmpDataFiles.ccn
and #Status.survey_id = #tmpDataFiles.survey_id
and #tmpDataFiles.origfile_nm is not null
and #tmpDataFiles.datafilestate is not null

if @inDebug = 1 print 'updated file status'
if @inDebug = 1 select '#Status2', * from #Status

--Get the dataset and sampleset info for the selected date range
create table #tmpOCSSamples (survey_id int, MedicareNumber varchar(10), 
dataset_id int, datApplied datetime, sampleset_id int, datSampled datetime, datscheduled datetime)

insert into #tmpOCSSamples
select tof.survey_id, tof.medicarenumber, ds.DATASET_ID, ds.DATLOAD_DT, sst.SAMPLESET_ID, sst.DATSAMPLECREATE_DT, sst.datscheduled
from #tmpOCSFacilities tof 
left outer join DATA_SET ds
on tof.study_id = ds.STUDY_ID
left outer join SAMPLEDATASET sds
on ds.DATASET_ID = sds.DATASET_ID
left outer join SAMPLESET sst
on sds.SAMPLESET_ID = sst.SAMPLESET_ID
where ds.DATLOAD_DT is null or ds.DATLOAD_DT between @LoadBegDate and @LoadEndDate

if @inDebug = 1 print 'got sample set info'
if @inDebug = 1 select '#tmpOCSSamples', * from #tmpOCSSamples

--Update the status with the sample set status info
update #Status
set currentstatus = 'Sampled'
from #tmpOCSSamples
where #Status.CCN = #tmpOCSSamples.MedicareNumber
and #Status.survey_id = #tmpOCSSamples.survey_id
and #tmpOCSSamples.sampleset_id is not null

update #Status
set currentstatus = 'Scheduled'
from #tmpOCSSamples
where #Status.CCN = #tmpOCSSamples.MedicareNumber
and #Status.survey_id = #tmpOCSSamples.survey_id
and #tmpOCSSamples.datscheduled is not null

if @inDebug = 1 print 'updated sample status'
if @inDebug = 1 select '#Status3', * from #Status

--Get a list of the HHCAHPS sample units
create table #tmpOCSSampleUnits (survey_id int, sampleunit_id int)

insert into #tmpOCSSampleUnits
select tos.survey_id, su.SAMPLEUNIT_ID
from #tmpOCSSamples tos, SAMPLEPLAN spl, SAMPLEUNIT su
where tos.survey_id = spl.SURVEY_ID
and spl.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
and su.bitHHCAHPS = 1

if @inDebug = 1 print 'got sample unit info'
if @inDebug = 1 select '#tmpOCSSampleUnits', * from #tmpOCSSampleUnits

--Get the count of how many sampled at each HH unit
create table #tmpSampleCounts (survey_id int, sampleunit_id int, sampleset_id int, CountSampled int)

insert into #tmpSampleCounts
select tosu.*, tos.sampleset_id, spw.intsamplednow
from #tmpOCSSamples tos, #tmpOCSSampleUnits tosu, SamplePlanWorksheet spw
where tos.survey_id = tosu.survey_id
and tos.sampleset_id = spw.Sampleset_id
and tosu.sampleunit_id = spw.SampleUnit_id

if @inDebug = 1 print 'got sample counts'
if @inDebug = 1 select '#tmpSampleCounts', * from #tmpSampleCounts

--Put it all together... result set for the report
select distinct tof.medicarenumber, tof.clientname, tof.client_id, tof.study_id, tof.survey_id, 
tdf.intloaded, tsc.countsampled, 
CurrentStatus = 
case s.currentstatus
	when 'applied' then 'Not Sampled'
	when 'awaitingfirstapproval' then 'Pervasive Viewer'
	when 'sampled' then 'Not Scheduled'
	else s.currentstatus
 end
from #tmpOCSFacilities tof
join #status s
on tof.medicarenumber = s.ccn
and tof.survey_id = s.survey_id
left outer join #tmpDataFiles tdf
on tof.medicarenumber = tdf.ccn
and tof.survey_id = tdf.survey_id
left outer join #tmpOCSSamples tos
on tdf.CCN = tos.medicarenumber
and tdf.survey_id = tos.survey_id
and tdf.dataset_id = tos.dataset_id
left outer join #tmpSampleCounts tsc
on tsc.survey_id = tos.survey_id
and tsc.sampleset_id = tos.sampleset_id
order by tof.medicarenumber

/***************CLEANUP*****************/
If @inDebug = 0 begin
	drop table #tmpOCSSurveys
	drop table #tmpOCSFacilities
	drop table #Status
	drop table #tmpDataFiles
	drop table #tmpOCSSamples
	drop table #tmpOCSSampleUnits
	drop table #tmpSampleCounts
end
/**************************************/


END


