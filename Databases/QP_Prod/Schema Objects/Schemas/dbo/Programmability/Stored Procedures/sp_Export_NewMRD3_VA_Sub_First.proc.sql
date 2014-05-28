CREATE PROCEDURE sp_Export_NewMRD3_VA_Sub_First
@CutOff_id INTEGER, @ReturnsOnly BIT=0, @DirectOnly BIT=0
AS
DECLARE @start_dt DATETIME, @stop_dt DATETIME, @Survey_id INTEGER, @Study_id INTEGER, @CutOffType CHAR(1)
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
      SELECT @Sel=strtable_nm + strField_nm
      FROM Survey_def sd, metatable mt, metafield mf
      WHERE CutOfftable_id=mt.table_id
        AND CutOfffield_id=mf.field_id
        AND Survey_id=@Survey_id

      CREATE TABLE #daterange (mn DATETIME, mx DATETIME)
      SELECT @SQL=
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
      '  AND uk.Pop_id=bv.PopulationPop_id'

      IF @DirectOnly=1
         SELECT @sql=@SQL+'  AND ss.strUnitSelectType=''D'''

      SELECT @tbl=table_id FROM metatable WHERE Study_id=@Study_id AND strTable_nm='ENCOUNTER'
      IF @@ROWCOUNT=0 
        BEGIN
          SELECT @tbl=table_id FROM metatable WHERE Study_id=@Study_id AND strTable_nm='Population'
          SELECT @SQL=@SQL + ' AND UK.table_id='+CONVERT(VARCHAR,@tbl)
        END
      ELSE
        SELECT @SQL=@SQL + ' AND UK.table_id='+CONVERT(VARCHAR,@tbl) + ' AND UK.KeyValue=bv.encounterenc_id'

      EXEC (@SQL)
      SELECT @start_dt=mn, @stop_dt=mx FROM #daterange

      DROP TABLE #daterange

    END
END

SELECT DISTINCT ISNULL(strfieldshort_nm,LEFT(mf.strfield_nm,8)) AS shrt, CONVERT(VARCHAR(60),'') AS fldnm
INTO #SelClause
FROM metatable mt, metastructure ms, metafield mf
WHERE mt.table_id=ms.table_id
  AND ms.field_id=mf.field_id
  AND mt.Study_id=@Study_id

UPDATE #SelClause
  SET fldnm=
    CASE 
      WHEN strFieldDataType='D' AND strField_nm<>'NewRecordDate' 
      THEN 'CONVERT(VARCHAR,'+mt.strtable_nm+'.'+mf.strfield_nm+',101)' 
      ELSE mt.strtable_nm+'.'+mf.strfield_nm 
    END
FROM metatable mt, metastructure ms, metafield mf
WHERE mt.table_id=ms.table_id
  AND ms.field_id=mf.field_id
  AND mt.Study_id=@Study_id
  AND #SelClause.shrt=ISNULL(strfieldshort_nm,LEFT(mf.strfield_nm,8))

SELECT DISTINCT ISNULL(strfieldshort_nm,LEFT(mf.strfield_nm,8)) +' '+
CASE strFieldDataType
  WHEN 'S' THEN 'VARCHAR('+CONVERT(VARCHAR,intfieldlength)+')'
  WHEN 'D' THEN CASE WHEN strField_nm='NewRecordDate' THEN 'DATETIME' ELSE 'VARCHAR(10)' end
  WHEN 'I' THEN 'INTEGER'
end AS strdef, mf.field_id 
INTO #FldDef
FROM metatable mt, metastructure ms, metafield mf
WHERE mt.table_id=ms.table_id
  AND ms.field_id=mf.field_id
  AND mt.Study_id=@Study_id

INSERT INTO #FldDef (strDef,field_id)
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,qstncore),6) + ' INTEGER', sq.section_id * 100000 + sq.subsection * 100 + sq.item
  FROM sel_qstns sq
  WHERE Survey_id=@Survey_id
    AND subtype=1  
    AND numMarkCount=1
  UNION 
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,sq.qstncore),6) + CASE WHEN ss.val between 1 AND 26 THEN CHAR(96+ss.val) ELSE '' end +' INTEGER', sq.section_id * 100000 + sq.subsection * 100 + sq.item
  FROM sel_qstns sq, Sel_Scls ss
  WHERE sq.Survey_id=ss.Survey_id
    AND sq.scaleid=ss.qpc_id
    AND sq.Survey_id=@Survey_id
    AND sq.subtype=1  
    AND sq.numMarkCount=2

DECLARE curDef cursor for
  SELECT strDef FROM #flddef order by field_id

SELECT @SQL='ALTER TABLE s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' ADD '
open curDef
fetch next FROM curDef INTO @fld
while @@Fetch_status=0
BEGIN
  SELECT @SQL=@SQL + @fld + ' ,'
  fetch next FROM curDef INTO @fld
end close curDef
deallocate curDef
drop table #FldDef
SELECT @SQL=LEFT(@SQL,len(@SQL)-1) 
Exec (@SQL)

DECLARE curIns cursor for
  SELECT shrt,fldnm FROM #SelClause order by shrt

SELECT @SQL='INSERT INTO s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' (sampset, samp_dt, sampunit, unit_nm, samptype, samppop, mailstep'
SELECT @Sel='SELECT uk.SampleSet_id, s.datSampleCreate_dt, uk.SampleUnit_id, su.strSampleUnit_nm, ss.strUnitSelectType, sp.SamplePop_id, schm.mailingstep_id'
open curIns
fetch next FROM curIns INTO @shrt,@fld
while @@Fetch_status=0
BEGIN
  SELECT @SQL=@SQL + ','+@shrt
  SELECT @sel=@sel + ','+@fld 
  fetch next FROM curIns INTO @shrt,@fld
end
close curIns
deallocate curIns
drop table #SelClause

SELECT @SQL=@SQL + ') ' + @Sel + ' FROM s'+CONVERT(VARCHAR,@Study_id)+'.UniKeys UK, SampleSet s, SelectedSample SS, SamplePop SP, SampleUnit SU, scheduledmailing schm '
if @ReturnsOnly=1
  SELECT @SQL=@SQL + ', QuestionForm QF '

DECLARE curFROM cursor for
  SELECT 's'+CONVERT(VARCHAR,@Study_id)+'.'+strtable_nm+' '+strtable_nm AS FRM FROM metatable WHERE Study_id=@Study_id
open curFrom
fetch next FROM curFROM INTO @shrt
while @@Fetch_status=0
BEGIN
  SELECT @SQL=@SQL + ',' + @shrt
  fetch next FROM curFROM INTO @shrt
end
close curFrom
deallocate curFrom

SELECT @SQL=@SQL + ' WHERE UK.SampleSet_id=ss.SampleSet_id AND ss.SampleSet_id=s.SampleSet_id AND uk.Pop_id=ss.Pop_id AND uk.SampleUnit_id=ss.SampleUnit_id AND ss.SampleUnit_id=su.SampleUnit_id AND UK.SampleSet_id=sp.SampleSet_id AND uk.Pop_id=sp.Pop_id



 AND UK.Pop_id=Population.Pop_id AND sp.SamplePop_id=schm.SamplePop_id '
if @DirectOnly=1
  SELECT @SQL=@SQL + ' AND ss.strUnitSelectType=''D'''
if @ReturnsOnly=1
  SELECT @SQL=@SQL + ' AND sp.SamplePop_id=qf.SamplePop_id AND qf.CutOff_id='+CONVERT(VARCHAR,@CutOff_id)+' AND qf.sentmail_id=schm.sentmail_id '

DECLARE curWHERE cursor for
  SELECT strtable_nm+'.'+strfield_nm+'='+lookuptablename+'.'+lookupfieldname AS condtn
  FROM metalookup_view 
  WHERE Study_id=@Study_id
open curWhere
fetch next FROM curWHERE INTO @shrt
while @@fetch_status=0
BEGIN
  SELECT @SQL=@SQL + ' AND ' + @shrt
  fetch next FROM curWHERE INTO @shrt
end
close curWhere
deallocate curWhere

SELECT @tbl=table_id FROM metatable WHERE Study_id=@Study_id AND strTable_nm='ENCOUNTER'

if @@rowcount=0 
  BEGIN
    SELECT @tbl=table_id FROM metatable WHERE Study_id=@Study_id AND strTable_nm='Population'
    SELECT @SQL=@SQL + ' AND UK.table_id='+CONVERT(VARCHAR,@tbl)
  end
else
  SELECT @SQL=@SQL + ' AND UK.table_id='+CONVERT(VARCHAR,@tbl) + ' AND UK.KeyValue=encounter.enc_id'

if @CutOfftype='0'
  SELECT @SQL=@SQL + ' AND S.datSampleCreate_dt >= '''+CONVERT(VARCHAR,@start_dt,100)+''' AND S.datSampleCreate_dt < dateadd(day,1,'''+CONVERT(VARCHAR,@stop_dt,100)+''')'
else
  if @CutOfftype='2' 
    BEGIN
      SELECT @Sel=strtable_nm+ '.' + strField_nm
      FROM Survey_def sd, metatable mt, metafield mf
      WHERE CutOfftable_id=mt.table_id
        AND CutOfffield_id=mf.field_id
        AND Survey_id=@Survey_id
     SELECT @SQL=@SQL + ' AND ' + @sel + ' between '''+CONVERT(VARCHAR,@start_dt,100)+''' AND '''+CONVERT(VARCHAR,@stop_dt,100)+''''
    end
Exec (@SQL)

SELECT @sql='UPDATE MRD '+
'set qstnform=QuestionForm_id, rtrn_dt=datReturned, lithocd=sm.strlithocode '+
'FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' MRD, QuestionForm qf, sentmailing sm, scheduledmailing schm '+
'WHERE MRD.samppop=qf.SamplePop_id '+
'  AND qf.CutOff_id='+CONVERT(VARCHAR,@CutOff_id) +
'  AND qf.sentmail_id=sm.sentmail_id '+
'  AND qf.sentmail_id=schm.sentmail_id '+
'  AND schm.mailingstep_id=mrd.mailstep '
Exec (@SQL)

SELECT @sql='delete s'+CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' WHERE lithocd is null'
EXEC (@sql)

/* added datundeliverable to MRD table */
SELECT @sql='UPDATE MRD '+
'set undel_dt=datundeliverable '+
'FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' MRD, QuestionForm qf, sentmailing sm '+
'WHERE MRD.samppop=qf.SamplePop_id '+
'  AND qf.sentmail_id=sm.sentmail_id '+
'  AND qf.datReturned is null' 
Exec (@SQL)

if @CutOfftype='1'
  SELECT @sql='delete s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' WHERE qstnform is null or rtrn_dt is null'
else
  SELECT @sql='UPDATE mrd '+
  'set qstnform=QuestionForm_id '+
  'FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' mrd, QuestionForm qf '+
  'WHERE mrd.samppop=qf.SamplePop_id '+
  '  AND mrd.qstnform is null '+
  '  AND ISNULL(qf.CutOff_id,-1) <> '+CONVERT(VARCHAR,@CutOff_id)
exec(@sql)

/*Added 4/24/1 Brian Dohmen
Creation of the temp results table used in the following UPDATEs*/
SELECT qr.QuestionForm_id, qstncore, intresponseval, SampleUnit_id
INTO #QuestionResult 
FROM QuestionResult qr, QuestionForm qf
WHERE CutOff_id=@CutOff_id
AND qf.QuestionForm_id=qr.QuestionForm_id

create index tmpindex on #questionresult (questionform_id, sampleunit_id, qstncore)

set @sql='CREATE INDEX tempindex on s'+convert(varchar,@study_id)+'.MRD1_'+convert(varchar,@cutoff_id)+' (qstnform, sampunit)'
EXEC (@sql)


/* Single Response questions */
DECLARE @core INTEGER

DECLARE curQstn cursor for
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,qstncore),6),qstncore 
  FROM sel_qstns 
  WHERE Survey_id=@Survey_id AND subtype=1 AND numMarkcount=1

open curQstn
fetch next FROM curQstn INTO @fld, @core
while @@Fetch_status=0
BEGIN
  SELECT @SQL=
      'UPDATE MRD'+
      '  set '+@fld+'=intresponseval '+
/*Modified 4/24/1 Brian Dohmen  -- Changed QuestionResult to be #QuestionResult*/
      'FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' MRD, #QuestionResult qr '+
      'WHERE mrd.rtrn_dt is not null'+
      '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.sampunit=qr.SampleUnit_id'+
      '  AND qr.qstncore='+CONVERT(VARCHAR,@core)
  Exec (@SQL)
  SELECT @SQL=
      'UPDATE MRD'+
      '  set '+@fld+'=intresponseval '+
/*Modified 4/24/1 Brian Dohmen  -- Changed QuestionResult to be #QuestionResult*/
      'FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' MRD, #QuestionResult qr '+
      'WHERE mrd.rtrn_dt is not null'+
      '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.'+@fld+' is null'+
      '  AND qr.qstncore='+CONVERT(VARCHAR,@core)
  Exec (@SQL)
  fetch next FROM curQstn INTO @fld, @core
end
close curQstn
deallocate curQstn

/* Multiple Response questions */
DECLARE curQstn cursor for
  SELECT 'q'+RIGHT('00000'+CONVERT(VARCHAR,qstncore),6)+CASE WHEN ss.val between 1 AND 26 THEN CHAR(96+ss.val) ELSE '' end,qstncore,ss.val
  FROM sel_qstns sq, sel_scls ss
  WHERE sq.Survey_id=ss.Survey_id AND sq.scaleid=ss.qpc_id
    AND sq.Survey_id=@Survey_id AND subtype=1 AND numMarkcount=2

DECLARE @val INTEGER

open curQstn
fetch next FROM curQstn INTO @fld, @core, @val
while @@Fetch_status=0
BEGIN
  SELECT @SQL=
      'UPDATE MRD'+
      '  set '+@fld+'='+CONVERT(VARCHAR,@val)+' '+
/*Modified 4/24/1 Brian Dohmen  -- Changed QuestionResult to be #QuestionResult*/
      'FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' MRD, #QuestionResult qr '+
      'WHERE mrd.rtrn_dt is not null'+
     '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.sampunit=qr.SampleUnit_id'+
      '  AND qr.qstncore='+CONVERT(VARCHAR,@core)+
      '  AND qr.intResponseval='+CONVERT(VARCHAR,@val)
  Exec (@SQL)
  SELECT @SQL=
      'UPDATE MRD'+
      '  set '+@fld+'='+CONVERT(VARCHAR,@val)+' '+
/*Modified 4/24/1 Brian Dohmen  -- Changed QuestionResult to be #QuestionResult*/
      'FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+' MRD, #QuestionResult qr '+
      'WHERE mrd.rtrn_dt is not null'+
      '  AND mrd.qstnform=qr.QuestionForm_id'+
      '  AND mrd.'+@fld+' is null'+

      '  AND qr.qstncore='+CONVERT(VARCHAR,@core)+
      '  AND qr.intResponseval='+CONVERT(VARCHAR,@val)
  Exec (@SQL)
  fetch next FROM curQstn INTO @fld, @core, @val
end
close curQstn
deallocate curQstn

--SELECT @sql='delete FROM s' + CONVERT(VARCHAR,@Study_id)+'.MRD1_'+CONVERT(VARCHAR,@CutOff_id)+
--' WHERE lithocd is null '
--Exec (@SQL)

drop table #QuestionResult


