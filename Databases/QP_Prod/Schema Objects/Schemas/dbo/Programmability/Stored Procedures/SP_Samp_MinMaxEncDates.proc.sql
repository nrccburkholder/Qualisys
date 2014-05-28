CREATE  PROCEDURE SP_Samp_MinMaxEncDates 
	@DataSet_id INT,
	@survey_id INT,
	@minDate DATETIME output,
	@maxDate DATETIME output
AS

DECLARE @sql VARCHAR(8000), @DateField VARCHAR(100), @Study INT


SELECT @Study = Study_id FROM Survey_def WHERE Survey_id = @Survey_id

SELECT @DateField = strTable_nm+strField_nm
FROM Survey_def sd, MetaData_view m
WHERE sd.CutOffTable_id = m.Table_id
AND sd.CutOffField_id = m.Field_id
AND sd.Survey_id = @Survey_id

create table #dates (mindate datetime, maxdate datetime)


IF EXISTS (SELECT * FROM metaTable WHERE Study_id = @Study AND strTable_nm = 'Encounter')
BEGIN
SET @sql = 'insert into #dates
	SELECT MIN('+@DateField+'), MAX('+@DateField+')
	FROM DataSetMember dsm, S'+CONVERT(VARCHAR,@Study)+'.Big_View b
	WHERE dsm.dataset_id=' + CONVERT(VARCHAR,@dataset_Id) + ' and
		dsm.pop_id=b.populationpop_id and 
		dsm.Enc_id = b.EncounterEnc_id'
END
ELSE
BEGIN
SET @sql = 'insert into #dates
	SELECT MIN('+@DateField+'), MAX('+@DateField+')
	FROM DataSetMember dsm, S'+CONVERT(VARCHAR,@Study)+'.Big_View b
	WHERE dsm.dataset_id=' + CONVERT(VARCHAR,@dataset_Id) + ' and 
		dsm.Pop_id = b.PopulationPop_id'
END


EXEC (@sql)


select @mindate=mindate,
		@maxdate=maxdate
from #dates

drop table #dates


