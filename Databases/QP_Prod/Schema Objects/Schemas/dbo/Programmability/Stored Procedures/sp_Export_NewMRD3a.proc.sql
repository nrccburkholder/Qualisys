--6/1/1 BD modified procedure to allow user to name the output table
CREATE procedure sp_Export_NewMRD3a
@cutoff_id INTEGER, @ReturnsOnly BIT = 0, @DirectOnly BIT = 1, @tablename VARCHAR(50) = NULL
AS
DECLARE @Study_id INT, @Survey_id INT, @sql VARCHAR(1000), @datStartProc DATETIME, @tableexists VARCHAR(50)

SELECT @Study_id=sd.Study_id, @Survey_id=sd.Survey_id, @datStartProc=GETDATE()
FROM cutoff co, Survey_def sd
WHERE co.cutoff_id=@cutoff_id
  AND co.Survey_id=sd.Survey_id

UPDATE cutoff
 SET bitExecutingCutoff = CASE cutoff_id WHEN @Cutoff_id THEN 1 ELSE 0 END
WHERE Survey_id = @Survey_id

SELECT cutoff_id, COUNT(*) cnt
INTO #count
FROM questionform
WHERE cutoff_id = @cutoff_id
GROUP BY cutoff_id

UPDATE c
 SET ExportCount = cnt
FROM #count t, cutoff c
WHERE t.cutoff_id = c.cutoff_id

DROP TABLE #count

IF @tablename IS NULL
BEGIN
SET @tablename = 's'+CONVERT(VARCHAR,@Study_id)+'.MRD_'+CONVERT(VARCHAR,@cutoff_id)
SET @tableexists = '[s'+CONVERT(VARCHAR,@Study_id)+'].[MRD_'+CONVERT(VARCHAR,@cutoff_id)+']'
END
ELSE
BEGIN
SET @tableexists = '[s'+CONVERT(VARCHAR,@Study_id)+'].['+@tablename+']'
SET @tablename = 's'+CONVERT(VARCHAR,@Study_id)+'.'+@tablename
END
/*
SELECT @sql = 
'if exists (SELECT * FROM sysobjects WHERE id = object_id(N''[S'+CONVERT(VARCHAR,@Study_id)+'].[MRD_'+CONVERT(VARCHAR,@cutoff_id)+']'') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1) '+
'drop table [S'+CONVERT(VARCHAR,@Study_id)+'].[MRD_'+CONVERT(VARCHAR,@cutoff_id)+']'
EXEC (@SQL)

SELECT @sql = 
'create table s' + CONVERT(VARCHAR,@Study_id)+'.MRD_'+CONVERT(VARCHAR,@cutoff_id)+
'  (SampSet INTEGER,'+
'   Samp_dt DATETIME,'+
'   SampUnit INTEGER,'+
'   Unit_nm char(42),'+
'   SampType char(1),'+
'   SampPop INTEGER,'+
'   QstnForm INTEGER,'+
'   lithocd char(10),'+
'   Rtrn_dt DATETIME,'+
'   Undel_dt DATETIME)'
EXEC (@sql)

EXEC sp_Export_NewMRD3_sub @cutoff_id, @ReturnsOnly, @DirectOnly
*/
SELECT @sql = 
'IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'''+@tableexists+''') AND OBJECTPROPERTY(id, N''IsUserTable'') = 1) 
BEGIN
CREATE TABLE '+@tablename+
'  (SampSet INTEGER,'+
'   Samp_dt DATETIME,'+
'   SampUnit INTEGER,'+
'   Unit_nm char(42),'+
'   SampType char(1),'+
'   SampPop INTEGER,'+
'   QstnForm INTEGER,'+
'   lithocd char(10),'+
'   Rtrn_dt DATETIME,'+
'   Undel_dt DATETIME)
EXEC sp_Export_NewMRD3_suba '+CONVERT(VARCHAR,@cutoff_id)+', '+CONVERT(VARCHAR,@ReturnsOnly)+', '+CONVERT(VARCHAR,@DirectOnly)+', '''+@tablename+'''
END'

EXEC (@SQL)

INSERT INTO DashboardLog (Report, Client, Study, Survey, Days, Status, ProcedureBegin, ProcedureEnd)
  SELECT 'Export - get data', C.strClient_nm, S.strStudy_nm, SD.strSurvey_nm, @cutoff_id, CASE WHEN @returnsOnly=1 THEN 'Rtrns only' ELSE 'Everything' END, @datStartProc, GETDATE()
  FROM client c, Study s, Survey_def sd, cutoff co
  WHERE c.client_id=s.client_id
  AND s.Study_id = sd.Study_id
  AND sd.Survey_id=co.Survey_id
  AND co.cutoff_id=@cutoff_id


