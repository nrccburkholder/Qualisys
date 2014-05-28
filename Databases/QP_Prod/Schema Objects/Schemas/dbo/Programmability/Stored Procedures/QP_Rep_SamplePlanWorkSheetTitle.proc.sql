CREATE            procedure [dbo].[QP_Rep_SamplePlanWorkSheetTitle]
 @Associate varchar(50),
 @Client varchar(50),
 @Study varchar(50),
 @Survey varchar(50),
 @SampleSet varchar(50)
AS
set transaction isolation level read uncommitted
declare @procedurebegin datetime,@SamplesInPeriod int, @SamplesRun int, 
		@SamplesLeft int, @intSampleset_id int, @intsurvey_id int,
		@periodDateRange varchar(50), @sampledDateRange varchar(50),
		@SelectedDateRange varchar(50), @EncounterDateField varchar(50),
		@sql varchar(8000), @intstudy_id int, @SamplingAlgorithm varchar(50),
		@SamplingType varchar(100), @period int
set @procedurebegin = getdate()

insert into dashboardlog (report, associate, client, study, survey, sampleset, procedurebegin) select 'Sample Plan Worksheet', @associate, @client, @study, @survey, @sampleset, @procedurebegin


select @intSurvey_id=sd.survey_id,
	   @intStudy_id=s.study_id
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

select @intSampleSet_id=SampleSet_id
from SampleSet
where Survey_id=@intSurvey_id
  and abs(datediff(second,datSampleCreate_Dt,convert(datetime,@sampleset)))<=1

create table #title (SampleSet varchar(250), SAP int, SIP int, SLP int)
/*
insert into #title (SamplePlanWorkSheet) values ('Client: ' + @Client)
insert into #title (SamplePlanWorkSheet) values ('Study: ' + @Study)
insert into #title (SamplePlanWorkSheet) values ('Survey: ' + @Survey)
*/
insert into #title (SampleSet) values (convert(varchar,@SampleSet) +' ('+convert(varchar,@intsampleset_id)+')')
	
Select @period=perioddef_id
FROM PERIODDates
WHERE sampleset_id=@intsampleset_id

IF EXISTS (SELECT sampleset_id from sampleplanworksheet WHERE sampleset_id=@intsampleset_id)
BEGIN
	SELECT @SamplesRun=intSamplesAlreadyPulled,
			@samplesinPeriod=intSamplesInPeriod,
			@samplesLeft=intSamplesLeftInPeriod
	FROM sampleplanworksheet
	WHERE sampleset_id=@intsampleset_id
END
ELSE
BEGIN
 DECLARE @datPeriodStart datetime, @datSampleCreate_dt datetime
 SELECT @datSampleCreate_dt=datSampleCreate_dt
  FROM dbo.SampleSet 
  WHERE SampleSet_id = @intSampleSet_id


 select @datPeriodStart = datSampleCreate_dt
 from PeriodDates 
 where perioddef_id=@period and
		samplenumber=1

 SELECT @SamplesRun=COUNT(*)
  FROM dbo.SampleSet S
  WHERE S.survey_id = @intSurvey_id
   AND S.datSampleCreate_dt between @datPeriodStart and @datSampleCreate_dt

 SELECT @SamplesInPeriod = intSamplesInPeriod
  FROM dbo.Survey_def
  WHERE Survey_id = @intSurvey_id

 SELECT @SamplesLeft = @SamplesInPeriod - @SamplesRun
END

CREATE TABLE #DATEFIELD (DATEFIELD VARCHAR(42))

SET @SQL = 'INSERT INTO #DATEFIELD' +
   ' SELECT mt.strTable_nm + ''.'' + mf.strField_nm' +
   ' FROM Sampleset ss, survey_def sd, MetaStructure ms, MetaTable mt, MetaField mf' +
   ' WHERE ss.sampleset_id= ' + convert(varchar,@intSampleSet_id) + 
   ' AND ss.Survey_id = sd.survey_id' +
   ' AND sd.Study_id = mt.Study_id' +
   ' AND ms.Table_id = mt.Table_id' +
   ' AND ms.Field_id = mf.Field_id' +
   ' AND ms.table_id=sd.sampleencountertable_id' +
   ' AND ms.field_id=sd.sampleencounterfield_id' +
   ' AND mf.strFieldDataType = ''D''' 

Execute (@sql)

SELECT @EncounterDateField=DATEFIELD
FROM #DATEFIELD

DECLARE	@EncTable bit


IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@intstudy_id AND strTable_nm='Encounter')>0
SELECT @EncTable=1
ELSE 
SELECT @EncTable=0

IF @EncounterDateField is null and @encTable=0 Set @EncounterDateField='populationNewRecordDate'
	ELSE IF @EncounterDateField is null and @encTable=1 Set @EncounterDateField='encounterNewRecordDate'


DROP TABLE #DATEFIELD


 SELECT @SampledDateRange=
	case
		when minEnc_dt is not null then 
			@EncounterDateField + ' ' + 
			convert(varchar,minEnc_dt,101) + ' - ' + 
			convert(varchar,maxEnc_dt,101)
		else 'Sampled Date Range Unknown'
	end
 FROM sampleplanworksheet
 WHERE sampleset_id=@intsampleset_id and
	parentsampleunit_id is null
 order by minEnc_dt 

IF @SampledDateRange is null SET @SampledDateRange='Sampled Date Range is Not Available'

 SELECT Distinct @PeriodDateRange=
		case 
		  when datexpectedencstart is not null then 
			'Period Date Range ' + 
			convert(varchar,datexpectedencstart,101) + ' - ' + 
			convert(varchar,datexpectedencend,101)
		  else 'Period Date Range not specified'
		end
 FROM PeriodDef p, perioddates pd
 WHERE pd.sampleset_id=@intsampleset_id and
		p.perioddef_id=pd.perioddef_id

 SELECT @SelectedDateRange=
		case 
		  when datdaterange_fromdate is not null then 
			'Selected Date Range ' + 
			convert(varchar,datdaterange_fromdate,101) + ' - ' + 
			convert(varchar,datdaterange_todate,101)
		  else 'Selected Date Range not specified'
		end
 FROM SAMPLESET
 WHERE sampleset_id=@intsampleset_id

UPDATE #Title
SET SAP=@samplesrun,
	SIP=@SamplesinPeriod,
	SLP=@Samplesleft	

--Get A list of datasets used
Declare @datasets varchar(200), @tempDataset varchar(20)
SET @datasets=''

SELECT dataset_id
INTO #Datasets
FROM sampledataset
WHERE sampleset_id=@intsampleset_id

IF @@Rowcount > 0
Begin
	SELECT TOP 1 @tempDataset=convert(varchar,dataset_id)
	FROM #Datasets

	While @@rowcount>0
	BEGIN

		IF @datasets='' SET @datasets= @tempDataset
		ELSE SET @datasets=@datasets + ', ' + @tempDataset

		DELETE FROM #DATASETS WHERE dataset_id=@tempDataset

		SELECT TOP 1 @tempDataset=convert(varchar,dataset_id)
		FROM #Datasets
	END
End

SELECT @SamplingAlgorithm=AlgorithmName  
	FROM dbo.SampleSet s left join samplingalgorithm sa
	on s.samplingalgorithmid=sa.samplingalgorithmid
	WHERE SampleSet_id = @intSampleSet_id

select @SamplingType= strsamplingmethod_nm
	from perioddef pd, samplingmethod sm
	where perioddef_id=@period and
		pd.samplingmethod_id=sm.samplingmethod_id

INSERT INTO #Title (sampleset)
	values (@PeriodDateRange)
INSERT INTO #Title (sampleset)
	values (@SelectedDateRange)
INSERT INTO #Title (sampleset)
	values (@SampledDateRange)
INSERT INTO #Title (sampleset)
	values ('Dataset(s) Used: '+ @datasets)
INSERT INTO #Title (sampleset)
	values ('Sampling Type: ' + @SamplingType)
INSERT INTO #Title (sampleset)
	values ('Sampling Algorithm: ' + @SamplingAlgorithm)


select * from #title
drop table #title
drop table #datasets

set transaction isolation level read committed


