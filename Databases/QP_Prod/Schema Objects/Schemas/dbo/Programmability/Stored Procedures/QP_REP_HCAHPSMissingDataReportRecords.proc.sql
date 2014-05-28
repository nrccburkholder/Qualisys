/*
Business Purpose: 
This procedure is used to calculate the number of missing values in
HCAHPS standard fields.

Created:  07/6/2006 by DC

Modified   8/21/07 - SJS - Modification of HServiceType case statement to include "X"
Modified   1/18/2008 - DJK - Added MSDRG to the fields to be pulled.

*/  
CREATE PROCEDURE [dbo].[QP_REP_HCAHPSMissingDataReportRecords]
	@Associate varchar(50),
	@Client varchar(50),
	@Study varchar(50),
	@Survey varchar(50),
    @encounterStart DATETIME, 
    @encounterEnd DATETIME
AS 

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


DECLARE @Survey_id int, @Study_id INT, @shortName varchar(50),@FieldName varchar(50),
		@Sel VARCHAR(8000),
		@fields varchar(5000), 
		@TotalCount int

select @study_id=s.study_id, @Survey_id=sd.survey_id 
from survey_def sd, study s, client c
where c.strclient_nm=@Client
  and s.strstudy_nm=@Study
  and sd.strsurvey_nm=@survey
  and c.client_id=s.client_id
  and s.study_id=sd.study_id

--get the list of Fields needed for evaluating DQ rules
DECLARE @tbl TABLE (Fieldname VARCHAR(50), DataType VARCHAR(20), Length INT, Field_id INT, OrderName varchar(51))

INSERT INTO @tbl 
SELECT DISTINCT strTable_nm+strField_nm, STRFIELDDATATYPE, INTFIELDLENGTH, Field_id, 
	case
			when strfield_nm in ('DRG','MSDRG','hadmissionsource','hservicetype','hvisittype','hdischargestatus',
									'hadmitage','hcatage','sex', 'DOB', 'AdmitDate') then ' ' + right('000000000' + convert(varchar,field_id),8)
			else right('000000000' + convert(varchar,field_id),9)
	end as OrderName
FROM MetaData_View 
WHERE Study_id=@Study_id

CREATE TABLE #BVUK (DummyField INT)

SET @sel='ALTER TABLE #BVUK ADD ,'

SELECT @sel=@sel+
	','+
	FieldName+' '+
	CASE DataType WHEN 'I' THEN 'INT ' WHEN 'D' THEN 'DATETIME ' ELSE 'VARCHAR('+CONVERT(VARCHAR,Length)+')' END
FROM @tbl
ORDER BY OrderName

Set @sel=replace(@sel,',,','')

EXEC (@Sel)

ALTER TABLE #BVUK 
	DROP COLUMN DummyField

INSERT INTO #BVUK
EXEC DBO.QP_REP_HCAHPSAllEligibleRecords @Survey_ID, @encounterStart, @encounterEnd


--Find Records With Atleast One Bad Value
SET @sel=''
DECLARE @HCAHPStbl TABLE (Fieldname VARCHAR(50), shortName varchar(51))

INSERT INTO @HCAHPStbl 
SELECT strTable_nm+strField_nm, strField_nm
FROM MetaData_View
WHERE Study_id=@Study_id
	AND strfield_nm in ('DRG','MSDRG','hadmissionsource','hservicetype','hvisittype','hdischargestatus',
									'hadmitage','hcatage','sex', 'DOB', 'AdmitDate')

SELECT TOP 1 @shortName=ShortName, @FieldName=FieldName
FROM @HCAHPStbl
ORDER BY shortName

WHILE @@rowcount>0
BEGIN

	IF @shortName in ('DOB','AdmitDate')
		SET @sel=@sel + ' or ('+@FieldName +' is null or '+ @FieldName +'>getdate() or datediff(yy,'+ @FieldName +',getdate())>120 or year('+ @FieldName +')=0)'
	ELSE IF @shortName in ('hdischargestatus','hcatage')
		SET @sel=@sel + ' or ( '+ @FieldName +' is null or  '+ @FieldName +'=''M'')'
	ELSE IF @shortName ='hvisittype'
		SET @sel=@sel + ' or ( '+ @FieldName +' is null)'
	ELSE IF @shortName ='hservicetype'
		SET @sel=@sel + ' or ( '+ @FieldName +' is null or  '+ @FieldName +' IN (''9'',''X''))'
	ELSE IF @shortName ='DRG'
		SET @sel=@sel + ' or ( '+ @FieldName +'  is null or  '+ @FieldName +' in (''0'',''000''))'
	ELSE IF @shortName ='MSDRG'
		SET @sel=@sel + ' or ( '+ @FieldName +'  is null or  '+ @FieldName +' in (''0'',''000''))'
	ELSE IF @shortName ='sex'
		SET @sel=@sel + ' or ( '+ @FieldName +'  is null or  '+ @FieldName +' not in (''M'',''F''))'
	ELSE IF @shortName ='hadmissionsource'
		SET @sel=@sel + ' or ( '+ @FieldName +'  is null or  '+ @FieldName +' =''9'')'
	ELSE IF @shortName ='hadmitage'
		SET @sel=@sel + ' or ( '+ @FieldName +'  is null or  '+ @FieldName +' in (0,-1,9999))'

	DELETE 
	FROM @HCAHPStbl
	WHERE @shortName=ShortName

	SELECT TOP 1 @shortName=ShortName, @FieldName=FieldName
	FROM @HCAHPStbl
	ORDER BY shortName
END

SET @sel='SELECT * INTO #Temp FROM #BVUK 
			WHERE' + @sel + '
			
			IF @@ROWCOUNT >0
				SELECT * FROM #TEMP
			ELSE
				SELECT '''' as [ ]'
SET @sel=replace(@sel, 'WHERE or ', 'WHERE ')

exec(@sel)

DROP TABLE #BVUK


