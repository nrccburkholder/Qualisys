CREATE PROCEDURE dbo.SP_Apply_PopulateDataSetMember 
                @Study_ID INT, @DataSet_id INT
AS

DECLARE @sql VARCHAR(8000)

CREATE TABLE #MatchFields (strField_nm VARCHAR(42))

IF (SELECT COUNT(*) FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='Encounter')=0
BEGIN

INSERT INTO #MatchFields
SELECT strField_nm
FROM MetaData_View
WHERE Study_id=@Study_id
AND bitMatchField_flg=1
AND strTable_nm='Population'

SELECT @sql='INSERT INTO DataSetMember (DataSet_id, Pop_id)
	SELECT '+LTRIM(STR(@DataSet_id))+',pl.Pop_id
	FROM S'+LTRIM(STR(@Study_id))+'.Population p, S'+LTRIM(STR(@Study_id))+'.Population_Load pl
	WHERE'

SELECT @sql=@sql+' p.'+strField_nm+'=pl.'+strField_nm+' AND'
FROM #MatchFields

SELECT @sql=@sql+' p.Pop_id=pl.Pop_id'

EXEC (@sql)

END
ELSE 
BEGIN

INSERT INTO #MatchFields
SELECT strField_nm
FROM MetaData_View
WHERE Study_id=@Study_id
AND bitMatchField_flg=1
AND strTable_nm='Encounter'

SELECT @sql='INSERT INTO DataSetMember (DataSet_id, Pop_id, Enc_id)
	SELECT '+LTRIM(STR(@DataSet_id))+',el.Pop_id, el.Enc_id
	FROM S'+LTRIM(STR(@Study_id))+'.Encounter e, S'+LTRIM(STR(@Study_id))+'.Encounter_Load el
	WHERE'

SELECT @sql=@sql+' e.'+strField_nm+'=el.'+strField_nm+' AND'
FROM #MatchFields

SELECT @sql=@sql+' e.Enc_id=el.Enc_id'

EXEC (@sql)

END

UPDATE ds
SET RecordCount=cnt
FROM Data_Set ds, (SELECT COUNT(*) cnt FROM DataSetMember WHERE DataSet_id=@DataSet_id) a
WHERE ds.DataSet_id=@DataSet_id

EXEC QCL_Samp_PopulateDataSetDates @DataSet_id


