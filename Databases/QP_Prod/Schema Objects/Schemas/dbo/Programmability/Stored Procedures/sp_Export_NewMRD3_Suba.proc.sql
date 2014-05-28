/*4/24/1  --Brian Dohmen
  Creating a temp TABLE of all results that are to be exported.  This causes a single query against questionresult instead of a query for each question to be exported.
*/
--6/1/1 BD modified procedure to allow user to name the output Table
--8/7/01 DG added   "AND MetaStructure.bitPostedField_flg=1" to queries that reference MetaStructure
--7/9/03 BD added execute in alter TABLE loop to execute IF length exceeded 700 AND THEN reset the @sql variable

CREATE PROCEDURE sp_Export_NewMRD3_Suba
@CutOff_id INTEGER, @ReturnsOnly BIT = 0, @DirectOnly BIT = 1, @Tablename VARCHAR(50)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @start_dt DATETIME, @stop_dt DATETIME, @Survey_id INTEGER, @Study_id INTEGER, @CutOffType char(1)
DECLARE @fld VARCHAR(100), @shrt VARCHAR(100), @SQL VARCHAR(8000), @Sel VARCHAR(8000)
DECLARE @tbl INTEGER

SELECT @Survey_id=Survey_id, @start_dt=ISNULL(datCutOffStart_dt,0), @stop_dt=ISNULL(datCutOffStop_dt,0)
FROM CutOff WHERE CutOff_id=@CutOff_id

SELECT @Study_id=Study_id, @CutOffType=strCutOffResponse_Cd
FROM Survey_def 
WHERE Survey_id=@Survey_id

IF @start_dt=0
BEGIN
  IF @CutOfftype='0'
    SELECT @start_dt=MIN(datSampleCreate_dt), @stop_dt=MAX(datSampleCreate_dt)
    FROM QuestionForm qf, SamplePop sp, SampleSet ss
    WHERE qf.CutOff_id=@CutOff_id
      AND qf.SamplePop_id=sp.SamplePop_id
      AND sp.SampleSet_id=ss.SampleSet_id    
  ELSE IF @CutOfftype='1'
    BEGIN
      SELECT @start_dt=MIN(datReturned), @stop_dt=MAX(datReturned)
      FROM QuestionForm
      WHERE CutOff_id=@CutOff_id
      SET @ReturnsOnly=1
    END
  ELSE 
    BEGIN
      SELECT @Sel = strTable_nm + strField_nm
      FROM Survey_def sd, MetaTable mt, MetaField mf
      WHERE CutOffTable_id=mt.Table_id
        AND CutOffField_id=mf.Field_id
        AND Survey_id=@Survey_id

      CREATE TABLE #daterange (mn DATETIME, mx DATETIME)
      SELECT @SQL = 
      'INSERT INTO #daterange (mn, mx) ' +
      'SELECT MIN('+@sel+'), MAX('+@sel+') '+
      'FROM QuestionForm qf, SamplePop sp, SelectedSample ss, s'+CONVERT(VARCHAR,@Study_id)+'.UniKeys uk, s'+CONVERT(VARCHAR,@Study_id)+'.Big_View bv '+
      'WHERE qf.CutOff_id='+CONVERT(VARCHAR,@CutOff_id)+
      '  AND qf.SamplePop_id=sp.SamplePop_id'+
      '  AND sp.SampleSet_id=ss.SampleSet_id'+
      '  AND sp.Pop_id=ss.Pop_id'+
      '  AND ss.SampleSet_id=uk.SampleSet_id'+
      '  AND ss.Pop_id=uk.Pop_id'+
      '  AND ss.SampleUnit_id=uk.SampleUnit_id'+
      '  AND uk.Pop_id=bv.POPULATIONPop_id'

      IF @DirectOnly=1
         SELECT @sql=@SQL+'  AND ss.strUnitSelectType=''D'''

      SELECT @tbl=Table_id FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='ENCOUNTER'
      IF @@ROWCOUNT=0 
        BEGIN
          SELECT @tbl=Table_id FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='POPULATION'
          SELECT @SQL = @SQL + ' AND UK.Table_id='+CONVERT(VARCHAR,@tbl)
        END
      ELSE
        SELECT @SQL = @SQL + ' AND UK.Table_id='+CONVERT(VARCHAR,@tbl) + ' AND UK.KeyValue=bv.encounterenc_id'

      EXEC (@SQL)
      SELECT @start_dt=mn, @stop_dt=mx FROM #daterange

      DROP TABLE #daterange

    END
END

SELECT DISTINCT ISNULL(strFieldshort_nm,LEFT(mf.strField_nm,8)) AS shrt, CONVERT(VARCHAR(60),'') AS fldnm
INTO #SelClause
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id=ms.Table_id
  AND ms.Field_id=mf.Field_id
  AND mt.Study_id=@Study_id
  AND ms.bitPostedField_flg=1

UPDATE #SelClause
  SET fldnm = 
    CASE 
      WHEN strFieldDataType='D' AND strField_nm<>'NewRecordDate' 
      THEN 'CONVERT(VARCHAR,'+mt.strTable_nm+'.'+mf.strField_nm+',101)' 
      ELSE mt.strTable_nm+'.'+mf.strField_nm 
    END
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id=ms.Table_id
  AND ms.Field_id=mf.Field_id
  AND mt.Study_id=@Study_id
  AND ms.bitPostedField_flg=1
  AND #SelClause.shrt=ISNULL(strFieldshort_nm,LEFT(mf.strField_nm,8))

SELECT DISTINCT ISNULL(strFieldshort_nm,LEFT(mf.strField_nm,8)) +' '+
CASE strFieldDataType
  WHEN 'S' THEN 'VARCHAR('+CONVERT(VARCHAR,intFieldlength)+')'
  WHEN 'D' THEN CASE WHEN strField_nm='NewRecordDate' THEN 'DATETIME' ELSE 'VARCHAR(10)' END
  WHEN 'I' THEN 'INTEGER'
END AS strdef, mf.Field_id 
INTO #FldDef
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id=ms.Table_id
  AND ms.Field_id=mf.Field_id
  AND mt.Study_id=@Study_id
  AND ms.bitPostedField_flg=1

INSERT INTO #FldDef (strDef,Field_id)
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,QstnCore),6) + ' INTEGER', sq.Section_id * 100000 + sq.subSection * 100 + sq.Item
  FROM Sel_Qstns sq
  WHERE Survey_id=@Survey_id
    AND subType=1  
    AND numMarkCount=1
  UNION 
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,sq.QstnCore),6) + CASE WHEN ss.val BETWEEN 1 AND 26 THEN CHAR(96+ss.val) ELSE '' END +' INTEGER', sq.Section_id * 100000 + sq.subSection * 100 + sq.Item
  FROM Sel_Qstns sq, Sel_Scls ss
  WHERE sq.Survey_id=ss.Survey_id
    AND sq.scaleid=ss.qpc_id
    AND sq.Survey_id=@Survey_id
    AND sq.subType=1  
    AND sq.numMarkCount=2

DECLARE curDef CURSOR FOR
  SELECT strDef FROM #flddef ORDER BY Field_id

SELECT @SQL = 'ALTER TABLE '+@Tablename+' ADD '
OPEN curDef
FETCH NEXT FROM curDef INTO @fld
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @SQL = @SQL + @fld + ' ,'
  IF LEN(@sql) > 7000
  BEGIN
	SET @SQL = LEFT(@SQL,LEN(@SQL)-1)
	EXEC (@SQL)
	SET @SQL = 'ALTER TABLE '+@Tablename+' ADD '
  END
  FETCH NEXT FROM curDef INTO @fld
END CLOSE curDef
DEALLOCATE curDef
DROP TABLE #FldDef
SELECT @SQL = LEFT(@SQL,LEN(@SQL)-1) 
EXEC (@SQL)

DECLARE curIns CURSOR FOR
  SELECT shrt,fldnm FROM #SelClause ORDER BY shrt

SELECT @SQL = 'INSERT INTO '+@Tablename+' (sampset, samp_dt, sampunit, unit_nm, samptype, sampPop'
SELECT @Sel = 'SELECT uk.SampleSet_id, s.datSampleCreate_dt, uk.SampleUnit_id, su.strSampleUnit_nm, ss.strUnitSelectType, sp.SamplePop_id'
OPEN curIns
FETCH NEXT FROM curIns INTO @shrt,@fld
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @SQL = @SQL + ','+@shrt
  SELECT @sel = @sel + ','+@fld 
  FETCH NEXT FROM curIns INTO @shrt,@fld
END
CLOSE curIns
DEALLOCATE curIns
DROP TABLE #SelClause

SELECT @SQL = @SQL + ') ' + @Sel + ' FROM s'+CONVERT(VARCHAR,@Study_id)+'.UniKeys UK, SampleSet s, SelectedSample SS, SamplePop SP, SampleUnit SU'
IF @ReturnsOnly=1
  SELECT @SQL = @SQL + ', QuestionForm QF'

DECLARE curFROM CURSOR FOR
  SELECT 's'+CONVERT(VARCHAR,@Study_id)+'.'+strTable_nm+' '+strTable_nm AS FRM FROM MetaTable WHERE Study_id=@Study_id
OPEN curFrom
FETCH NEXT FROM curFROM INTO @shrt
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @SQL = @SQL + ',' + @shrt
  FETCH NEXT FROM curFROM INTO @shrt
END
CLOSE curFrom
DEALLOCATE curFrom

SELECT @SQL = @SQL + ' WHERE UK.SampleSet_id=ss.SampleSet_id AND ss.SampleSet_id=s.SampleSet_id AND uk.Pop_id=ss.Pop_id AND uk.SampleUnit_id=ss.SampleUnit_id 
 AND ss.SampleUnit_id=su.SampleUnit_id AND UK.SampleSet_id=sp.SampleSet_id AND uk.Pop_id=sp.Pop_id AND UK.Pop_id=POPULATION.Pop_id'
IF @DirectOnly=1
  SELECT @SQL = @SQL + ' AND ss.strUnitSelectType=''D'''
IF @ReturnsOnly=1
  SELECT @SQL = @SQL + ' AND sp.SamplePop_id=qf.SamplePop_id AND qf.CutOff_id='+CONVERT(VARCHAR,@CutOff_id)

DECLARE curWHERE CURSOR FOR
  SELECT strTable_nm+'.'+strField_nm+' = '+lookupTablename+'.'+lookupFieldname AS condtn
  FROM Metalookup_view 
  WHERE Study_id=@Study_id
OPEN curWhere
FETCH NEXT FROM curWHERE INTO @shrt
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @SQL = @SQL + ' AND ' + @shrt
  FETCH NEXT FROM curWHERE INTO @shrt
END
CLOSE curWhere
DEALLOCATE curWhere

SELECT @tbl=Table_id FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='ENCOUNTER'

IF @@ROWCOUNT=0 
  BEGIN
    SELECT @tbl=Table_id FROM MetaTable WHERE Study_id=@Study_id AND strTable_nm='POPULATION'
    SELECT @SQL = @SQL + ' AND UK.Table_id='+CONVERT(VARCHAR,@tbl)
  END
ELSE
  SELECT @SQL = @SQL + ' AND UK.Table_id='+CONVERT(VARCHAR,@tbl) + ' AND UK.KeyValue=encounter.enc_id'

IF @CutOfftype = '0'
  SELECT @SQL = @SQL + ' AND S.datSampleCreate_dt >= '''+CONVERT(VARCHAR,@start_dt,100)+''' AND S.datSampleCreate_dt < DATEADD(DAY,1,'''+CONVERT(VARCHAR,@stop_dt,100)+''')'
ELSE
  IF @CutOfftype = '2' 
    BEGIN
      SELECT @Sel = strTable_nm+ '.' + strField_nm
      FROM Survey_def sd, MetaTable mt, MetaField mf
      WHERE CutOffTable_id=mt.Table_id
        AND CutOffField_id=mf.Field_id
        AND Survey_id=@Survey_id
        SELECT @SQL = @SQL + ' AND ' + @sel + ' between '''+CONVERT(VARCHAR,@start_dt,100)+''' AND '''+CONVERT(VARCHAR,@stop_dt,100)+''''
    END
EXEC (@SQL)

SELECT @SQL = 'UPDATE MRD '+
'SET qstnform=QuestionForm_id, rtrn_dt=datReturned, lithocd=sm.strlithocode '+
'FROM '+@Tablename+' MRD, QuestionForm qf, sentmailing sm '+
'WHERE MRD.sampPop=qf.SamplePop_id '+
'  AND qf.CutOff_id='+CONVERT(VARCHAR,@CutOff_id) +
'  AND qf.sentmail_id=sm.sentmail_id'
EXEC (@SQL)

/* added datundeliverable to MRD TABLE */
SELECT @SQL = 'UPDATE MRD '+
'SET undel_dt=datundeliverable '+
'FROM '+@Tablename+' MRD, QuestionForm qf, sentmailing sm '+
'WHERE MRD.sampPop=qf.SamplePop_id '+
'  AND qf.sentmail_id=sm.sentmail_id '+
'  AND qf.datReturned is null' 
EXEC (@SQL)

IF @CutOfftype = '1'
  SELECT @SQL = 'DELETE s' + CONVERT(VARCHAR,@Study_id)+'.MRD_'+CONVERT(VARCHAR,@CutOff_id)+' WHERE qstnform IS NULL OR rtrn_dt IS NULL'
ELSE
  SELECT @SQL = 'UPDATE mrd '+
  'SET qstnform=QuestionForm_id '+
  'FROM '+@Tablename+' mrd, QuestionForm qf '+
  'WHERE mrd.sampPop=qf.SamplePop_id '+
  '  AND mrd.qstnform is null '+
  '  AND ISNULL(qf.CutOff_id,-1) <> '+CONVERT(VARCHAR,@CutOff_id)
EXEC(@SQL)

/*Added 4/24/1 Brian Dohmen
Creation of the temp results TABLE used in the following updates*/
SELECT qr.QuestionForm_id, QstnCore, intresponseval, SampleUnit_id
INTO #questionresult 
FROM questionresult qr, QuestionForm qf
WHERE CutOff_id = @CutOff_id
AND qf.QuestionForm_id = qr.QuestionForm_id

/* Single Response questions */
DECLARE @core INTEGER

DECLARE curQstn CURSOR FOR
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,QstnCore),6),QstnCore 
  FROM Sel_Qstns 
  WHERE Survey_id=@Survey_id AND subType=1 AND numMarkcount=1

OPEN curQstn
FETCH NEXT FROM curQstn INTO @fld, @core
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @SQL = 
      'UPDATE MRD'+
      '  SET '+@fld+' = intresponseval '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'FROM '+@Tablename+' MRD, #questionresult qr '+
      'WHERE mrd.rtrn_dt IS NOT NULL'+
      '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.sampunit=qr.SampleUnit_id'+
      '  AND qr.QstnCore='+CONVERT(VARCHAR,@core)
  EXEC (@SQL)
  SELECT @SQL = 
      'UPDATE MRD'+
      '  SET '+@fld+' = intresponseval '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'FROM '+@Tablename+' MRD, #questionresult qr '+
      'WHERE mrd.rtrn_dt IS NOT NULL'+
      '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.'+@fld+' IS NULL'+
      '  AND qr.QstnCore='+CONVERT(VARCHAR,@core)
  EXEC (@SQL)
  FETCH NEXT FROM curQstn INTO @fld, @core
END
CLOSE curQstn
DEALLOCATE curQstn

/* Multiple Response questions */
DECLARE curQstn CURSOR FOR
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,QstnCore),6)+CASE WHEN ss.val between 1 AND 26 THEN CHAR(96+ss.val) ELSE '' END,QstnCore,ss.val
  FROM Sel_Qstns sq, sel_scls ss
  WHERE sq.Survey_id=ss.Survey_id AND sq.scaleid=ss.qpc_id
    AND sq.Survey_id=@Survey_id AND subType=1 AND numMarkcount=2

DECLARE @val INTEGER

OPEN curQstn
FETCH NEXT FROM curQstn INTO @fld, @core, @val
WHILE @@FETCH_STATUS=0
BEGIN
  SELECT @SQL = 
      'UPDATE MRD'+
      '  SET '+@fld+' = '+CONVERT(VARCHAR,@val)+' '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'FROM '+@Tablename+' MRD, #questionresult qr '+
      'WHERE mrd.rtrn_dt IS NOT NULL'+
      '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.sampunit=qr.SampleUnit_id'+
      '  AND qr.QstnCore='+CONVERT(VARCHAR,@core)+
      ' AND qr.intResponseval='+CONVERT(VARCHAR,@val)
  EXEC (@SQL)
  SELECT @SQL = 
      'UPDATE MRD'+
      '  SET '+@fld+' = '+CONVERT(VARCHAR,@val)+' '+
/*Modified 4/24/1 Brian Dohmen  -- Changed questionresult to be #questionresult*/
      'FROM '+@Tablename+' MRD, #questionresult qr '+
      'WHERE mrd.rtrn_dt IS NOT NULL'+
      '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.'+@fld+' IS NULL'+
      '  AND qr.QstnCore='+CONVERT(VARCHAR,@core)+
      '  AND qr.intResponseval='+CONVERT(VARCHAR,@val)
  EXEC (@SQL)
  FETCH NEXT FROM curQstn INTO @fld, @core, @val
END
CLOSE curQstn
DEALLOCATE curQstn

DROP TABLE #questionresult

SET TRANSACTION ISOLATION LEVEL READ COMMITTED


