/*
   This stored PROCEDURE has been modified to allow multiple MailingSteps for a single person
   to be generated ON the same night.
   MODIFIED 3/20/2 BD added SampleSet join between #FG_MailingWork AND unikeys to
                                     populate #BVUK
   MODIFIED 5/22/2  BD set Langid=1 if current Langid is not valid for the Survey
   MODIFIED 1/13/3  BD Enclosed the criteria stmt by Parentheses within the minor exception rule processing.
   MODIFIED 11/17/3 BD Remove unikeys entries.  SelectedSample has everything we need.
   MODIFIED 1/21/04 SS Mods to accomodate TestPrints (bitTP added, BVUK update for de-personalization of TP, #FG_MailingWork changed to #FG_MailingWork)
   MODIFIED 2/5/04  BD Added tracking for skip patterns.  These will be used for the extract to the datamart.
   MODIFIED 5/21/04 BD Added tracking for skip patterns.  These will be used for the extract to the datamart.
   MODIFIED 5/24/04 BD If this is the first test print since a survey has been validated, clear the PCL_XXX_TP tables so the new form will load.
   MODIFIED 6/1/04  BD The query to populate #BVUK would occassionaly fill tempdb.  So I broke the single query into 3 smaller queries.
   MODIFIED 7/20/04 SS Tightened the "Address Information" criteria for the mockup recode.
   MODIFIED 7/21/04 SS Error trap for TP was using FormGenError instead of FormGenError_TP.  Changed to use FormGenError_TP
   MODIFIED 8/27/04 BD/SS FIX for Minor Exception Rule -- Added suvey_id = mw.survey_id in dynamic sql statement (approx Ln 416)
   MODIFIED 9/13/04 BD Save off the zip5, zip4, and postalcode values for bundling.
   MODIFIED 01/4/05 BD Only run 'update statistics SentMailing' if the last pass thru the sub routine has @survey%10=0(@survey is evenly divisible by 10).
   MODIFIED 6/17/05 SS Specified that @AgeCol / @SexCol will be sourced from the Population table. (Previous code allowed any table with valid field to be source.)
   MODIFIED 10/19/05 BD Now a section can only appear once on a form.  Taking personalization from the encounter tied to MAX(SampleUnit_id)
   MODIFIED 11/19/09 MB Added new tables to update (DL_SEL_QSTNS_BySampleSet and DL_SEL_SCLS_BySampleSet).  They will be used in the new Import Results application(s)
   MODIFIED 3/02/09 MB Added new tables to update (DL_SampleUnitSection_BySampleset).  It will also be used in the new Import Results application(s)
   MODIFIED 3/03/09 MB Added @SQL2, @SQL3, @SQL4 variables to the "INSERT INTO #bvuk" section (Line 230).  Dynamic SQL string grew larger than 8000 char.  Split the string into 4 variables
   then executed the string as EXEC( @sql + @sql2 + @sql3 + @sql4)
   MODIFIED 9/19/13 DG Added call to CalcCAHPSSupplemental
*/
CREATE PROCEDURE SP_FG_FormGen_Sub
@Study INT, @Survey INT, @bitTP BIT
AS

 /*---------------*/
 --TESTING VARIABLES
 -- DECLARE @study INT, @survey INT, @bitTP BIT
 -- SET @study = 459
 -- SET @survey = 1520
 -- SET @bitTP = 0

 /*---------------*/

SET QUOTED_IDENTIFIER OFF

--Need to check and see if a newer version of the form exists
DECLARE @ValidationDate DATETIME, @LastValidationDate DATETIME, @ResetForm BIT
DECLARE @Sampleset int, @MaxQF int


SELECT @ResetForm=0
IF @bitTP=1
 BEGIN
  SELECT @ValidationDate=ISNULL(datValidated,'1/1/2010') FROM Survey_def WHERE Survey_id=@Survey

  SELECT @LastValidationDate=max(datValidated) FROM PCL_Cover_TP WHERE Survey_id=@Survey

  SELECT @LastValidationDate=ISNULL(@LastValidationDate,'1/1/1900')

  IF @ValidationDate>@LastValidationDate
   SELECT @ResetForm=1
  ELSE
   SELECT @ResetForm=0
 END

CREATE TABLE #criters (CriteriaStmt_id INT, strCriteriaStmt VARCHAR(2550), dummy_line INT)

-- Who needs a Survey?
--SELECT * FROM #FG_MailingWork

-- What Sections do they need?
-- Changed to not allow a section on a form more than once.
--  SELECT mw.ScheduledMailing_id, mw.SamplePop_id, mw.Survey_id, ss.SampleUnit_id,
--      sus.SelQstnsSection AS Section_id, 0 AS Langid, mw.bitMockup
--  INTO #PopSection
--  FROM #FG_MailingWork mw, dbo.SelectedSample ss, SampleUnitSection sus
--  WHERE mw.SampleSet_id=ss.SampleSet_id
--     AND mw.Study_id=ss.Study_id
--     AND mw.Pop_id=ss.Pop_id
--     AND ss.SampleUnit_id=sus.SampleUnit_id
--     AND mw.Survey_id=sus.SelQstnsSurvey_id
--     AND (mw.bitSendSurvey=1 OR sus.SelQstnsSection=-1)

 SELECT mw.ScheduledMailing_id, mw.SamplePop_id, mw.Survey_id, MAX(ss.SampleUnit_id) SampleUnit_id,
     sus.SelQstnsSection AS Section_id, 0 AS Langid, mw.bitMockup
 INTO #PopSection
 FROM #FG_MailingWork mw, dbo.SelectedSample ss, SampleUnitSection sus
 WHERE mw.SampleSet_id=ss.SampleSet_id
    AND mw.Study_id=ss.Study_id
    AND mw.Pop_id=ss.Pop_id
    AND ss.SampleUnit_id=sus.SampleUnit_id
    AND mw.Survey_id=sus.SelQstnsSurvey_id
    AND (mw.bitSendSurvey=1 OR sus.SelQstnsSection=-1)
 GROUP BY mw.ScheduledMailing_id, mw.SamplePop_id, mw.Survey_id,
     sus.SelQstnsSection, mw.bitMockup

CREATE INDEX ndx_tempPopSection ON #PopSection (SamplePop_id, SampleUnit_id)

-- Which Cover letter do they need?
 SELECT mw.ScheduledMailing_id, mw.SamplePop_id, mw.Survey_id, mw.SelCover_id, 0 AS Langid
 INTO #PopCover
 FROM #FG_MailingWork mw

DECLARE @BVJoin VARCHAR(255), @SQL VARCHAR(8000), @AllBVFields VARCHAR(8000)
DECLARE @SQL2 VARCHAR(8000), @SQL3 VARCHAR(8000), @SQL4 VARCHAR(8000)
DECLARE @SexCol VARCHAR(50), @AgeCol VARCHAR(50), @Group_IndvCol VARCHAR(50)

-- Added 1/22/04 SS (Get todays date to substitute for actual date when generating a mockup test print)
DECLARE @MockDate CHAR(8)
SET @MockDate = CONVERT(VARCHAR,GETDATE(),112)

-- get data FROM Big_View & Unikeys
--SELECT @BVJoin='uk.Table_id='+CONVERT(VARCHAR,Table_id)+' AND uk.KeyValue=bv.Encounterenc_id'
SELECT @BVJoin='ss.Enc_id=bv.EncounterEnc_id'
FROM MetaTable
WHERE Study_id=@Study
AND strTable_nm='Encounter'

if @BVJoin IS NULL
-- SELECT @BVJoin='uk.Table_id='+CONVERT(VARCHAR,Table_id)+' AND uk.KeyValue=bv.PopulationPop_id'
 SELECT @BVJoin='ss.Pop_id=bv.PopulationPop_id'
 FROM MetaTable
 WHERE Study_id=@Study
 AND strTable_nm='Population'

--CREATE TABLE #BVUK (SampleSet_id INT, SampleUnit_id INT, Pop_id INT, Table_id INT, keyvalue int)
CREATE TABLE #BVUK (SampleSet_id INT, SampleUnit_id INT, Pop_id INT)
SET @AllBVFields=''
DECLARE curBVFields CURSOR FOR
SELECT DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, COLUMN_NAME
FROM	INFORMATION_SCHEMA.COLUMNS
WHERE	TABLE_SCHEMA = 's'+CONVERT(VARCHAR,@Study) and
		TABLE_NAME = 'Big_view'

DECLARE @type Varchar(15), @fld_nm VARCHAR(100), @len INT
OPEN curBVFields
FETCH NEXT FROM curBVFields INTO @type, @len, @fld_nm
WHILE @@FETCH_STATUS=0
BEGIN
 SET @SQL='ALTER TABLE #BVUK ADD '+@fld_nm
 IF @type='INT'
   SET @SQL=@SQL+' INTEGER'
 ELSE IF @type= 'DATETIME'
   SET @SQL=@SQL+' DATETIME'
 ELSE
   SET @SQL=@SQL+' VARCHAR('+CONVERT(VARCHAR,@len)+')'
 EXEC (@SQL)

 SET @AllBVFields=@AllBVFields+', '+@fld_nm
 FETCH NEXT FROM curBVFields INTO @type, @len, @fld_nm
END
CLOSE curBVFields
DEALLOCATE curBVFields

SELECT @SexCol=strTable_nm+strField_nm
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id= ms.Table_id
  AND ms.Field_id=mf.Field_Id
  AND mt.Study_id= @Study
  AND mf.strField_nm='Sex'
  AND mt.strTable_nm = 'Population'

SELECT @AgeCol=strTable_nm+strField_nm
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id= ms.Table_id
  AND ms.Field_id=mf.Field_Id
  AND mt.Study_id= @Study
  AND mf.strField_nm='Age'
  AND mt.strTable_nm = 'Population'

SELECT @Group_IndvCol=strTable_nm+strField_nm
FROM MetaTable mt, MetaStructure ms, MetaField mf
WHERE mt.Table_id= ms.Table_id
  AND ms.Field_id=mf.Field_Id
  AND mt.Study_id= @Study
  AND mf.strField_nm ='Group_Indv'


IF @SexCol IS NULL
BEGIN
 ALTER TABLE #BVUK ADD Sex__ CHAR(1) DEFAULT 'M'
 SET @SexCol='Sex__'
END

IF @AgeCol IS NULL
BEGIN
 ALTER TABLE #BVUK ADD Age__ CHAR(1) DEFAULT 30
 SET @AgeCol='Age__'
END

IF @Group_IndvCol IS NULL
BEGIN
 ALTER TABLE #BVUK ADD Group_Indv__ CHAR(1) DEFAULT 'G'
 SET @Group_IndvCol='Group_Indv__'
END

--3/20/2 BD added SampleSet join between #FG_MailingWork AND unikeys
--print 'INSERT INTO #bvuk'

/* --Old code.
IF 0 = 0
BEGIN
SET @SQL=
'INSERT INTO #BVUK (SampleSet_id, SampleUnit_id, Pop_id'+@AllBVFields+')
SELECT ss.SampleSet_id, ss.SampleUnit_id, ss.Pop_id'+@AllBVFields+'
FROM #FG_MailingWork mw, #PopSection ps, s'+CONVERT(VARCHAR,@Study)+'.Big_View bv, SelectedSample ss
WHERE mw.SamplePop_id=ps.SamplePop_id
AND mw.Pop_id=bv.PopulationPop_id
AND mw.Pop_id=ss.Pop_id
AND ss.Study_id='+CONVERT(VARCHAR,@Study)+'
AND ps.SampleUnit_id=ss.SampleUnit_id
AND mw.SampleSet_id=ss.SampleSet_id
AND '+@BVJoin
END

IF 0 = 1
BEGIN
SET @SQL=
'INSERT INTO #BVUK (SampleSet_id, SampleUnit_id, Pop_id'+@AllBVFields+')
SELECT ss.SampleSet_id, ss.SampleUnit_id, ss.Pop_id'+@AllBVFields+'
FROM #FG_MailingWork mw, #PopSection ps, s'+CONVERT(VARCHAR,@Study)+'.Big_View bv, SelectedSample ss
WHERE mw.SamplePop_id=ps.SamplePop_id
AND mw.bitMockup=ps.bitMockup
AND mw.Pop_id=bv.PopulationPop_id
AND mw.Pop_id=ss.Pop_id
AND ss.Study_id='+CONVERT(VARCHAR,@Study)+'
AND ps.SampleUnit_id=ss.SampleUnit_id
AND mw.SampleSet_id=ss.SampleSet_id
AND '+@BVJoin
END

*/

--Start of Modification 6/1/4 BD
IF @bitTP = 0
BEGIN
SET @SQL=
'SELECT mw.SampleSet_id, ps.SampleUnit_id, mw.Pop_id
INTO #abc
FROM #FG_MailingWork mw, #PopSection ps
WHERE mw.SamplePop_id=ps.SamplePop_id
SELECT t.SampleSet_id, t.SampleUnit_id, t.Pop_id, ss.Enc_id
INTO #abcd
FROM #abc t, SelectedSample ss
WHERE t.SampleSet_id=ss.SampleSet_id
AND t.Pop_id=ss.Pop_id
AND t.SampleUnit_id=ss.SampleUnit_id '
SET @SQL2 = 'INSERT INTO #BVUK (SampleSet_id, SampleUnit_id, Pop_id'+@AllBVFields+') '
SET @SQL3 = 'SELECT ss.SampleSet_id, ss.SampleUnit_id, ss.Pop_id'+@AllBVFields+' '
SET @SQL4 = 'FROM #abcd ss, s'+CONVERT(VARCHAR,@Study)+'.Big_View bv
WHERE '+@BVJoin+'
DROP TABLE #abc
DROP TABLE #abcd'
END

IF @bitTP = 1
BEGIN
SET @SQL=
'SELECT mw.SampleSet_id, ps.SampleUnit_id, mw.Pop_id
INTO #abc
FROM #FG_MailingWork mw, #PopSection ps
WHERE mw.SamplePop_id=ps.SamplePop_id
AND mw.bitMockup=ps.bitMockup
SELECT t.SampleSet_id, t.SampleUnit_id, t.Pop_id, ss.Enc_id
INTO #abcd
FROM #abc t, SelectedSample ss
WHERE t.SampleSet_id=ss.SampleSet_id
AND t.Pop_id=ss.Pop_id
AND t.SampleUnit_id=ss.SampleUnit_id '
SET @SQL2 = 'INSERT INTO #BVUK (SampleSet_id, SampleUnit_id, Pop_id'+@AllBVFields+') '
SET @SQL3 = 'SELECT ss.SampleSet_id, ss.SampleUnit_id, ss.Pop_id'+@AllBVFields+' '
SET @SQL4 = 'FROM #abcd ss, s'+CONVERT(VARCHAR,@Study)+'.Big_View bv
WHERE '+@BVJoin+'
DROP TABLE #abc
DROP TABLE #abcd'
END
--End of Modification 6/1/4 BD

EXEC (@SQL + @SQL2 + @SQL3 + @SQL4)

IF CHARINDEX('Enc_id',@BVJoin)>0
 CREATE INDEX ndx_tempBigView ON #BVUK (PopulationPop_id, Encounterenc_id, SampleUnit_id)
ELSE
 CREATE INDEX ndx_tempBigView ON #BVUK (PopulationPop_id, SampleUnit_id)

-- UPDATE Langid in #FG_MailingWork, #popSection AND #popCover
-- modified 7/18/02 JC use MailingStep.override_Langid if it has been set
-- modified 2/2/04 SS - Skip UPDATE mw section when processing a testprint (want to use specified language NOT BV.LANGID)

IF @bitTP = 0
BEGIN
 UPDATE mw
 SET Langid=bv.PopulationLangid
 FROM #FG_MailingWork mw, #BVUK bv
 WHERE mw.Pop_id=bv.Pop_id
 AND mw.SampleSet_id=bv.SampleSet_id
                UPDATE mw
 SET Langid=ms.OverRide_Langid
 FROM #FG_MailingWork mw, MailingStep ms
 WHERE mw.MailingStep_id=ms.MailingStep_id
 AND ms.OverRide_Langid IS NOT NULL

 UPDATE mw
 SET Langid=1
 FROM #FG_MailingWork mw LEFT OUTER JOIN SurveyLanguage sl
 on mw.Langid=sl.Langid
 AND mw.Survey_id=sl.Survey_id
 WHERE sl.Langid IS NULL
END

 UPDATE ps
 SET Langid=mw.Langid
 FROM #popSection ps, #FG_MailingWork mw
 WHERE mw.ScheduledMailing_id=ps.ScheduledMailing_id
 --AND mw.Survey_id=@Survey

 UPDATE pc
 SET Langid=mw.Langid
 FROM #popCover pc, #FG_MailingWork mw
 WHERE mw.ScheduledMailing_id=pc.ScheduledMailing_id
 --AND mw.Survey_id=@Survey


CREATE INDEX ndx_tempPopSection2 ON #PopSection (Survey_id, Section_id, Langid)

-- What are the Code values needed?
CREATE TABLE #PopCode (ScheduledMailing_id INT, SamplePop_id INT, Survey_id INT, SampleUnit_id INT, Language INT,
     Code INT, Age CHAR(1), sex CHAR(1), doctor CHAR(1), Codetext_id INT, Codetext VARCHAR(255), bitUseNurse BIT, bitMockup BIT)
INSERT INTO #PopCode
SELECT DISTINCT ps.ScheduledMailing_id, ps.SamplePop_id, ps.Survey_id, ps.SampleUnit_id, sq.Language, cq.Code, NULL, NULL, NULL, NULL, NULL, 0, ps.bitMockup
FROM #PopSection ps, Sel_Qstns sq, CodeQstns cq
WHERE ps.Survey_id=sq.Survey_id
  AND ps.Section_id=sq.Section_id
  AND ps.Langid=sq.Language
  AND sq.SelQstns_id=cq.SelQstns_id
  AND sq.Survey_id=cq.Survey_id
  AND sq.Language=cq.Language
UNION
SELECT DISTINCT ps.ScheduledMailing_id, ps.SamplePop_id, ps.Survey_id, ps.SampleUnit_id, sq.Language, cs.Code, NULL, NULL, NULL, NULL, NULL, 0, ps.bitMockup
FROM #PopSection ps, Sel_Qstns sq, CodeScls cs
WHERE ps.Survey_id=sq.Survey_id
  AND ps.Section_id=sq.Section_id
  AND ps.Langid=sq.Language
  AND sq.Scaleid=cs.QPC_id
  AND sq.Survey_id=cs.Survey_id
  AND sq.Language=cs.Language
  AND sq.SubType=1
UNION
-- Modified 2/26/2 BD added UNION to eliminate duplicate Codes between Cover letter AND questionaire
--INSERT INTO #PopCode
SELECT DISTINCT mw.ScheduledMailing_id, mw.SamplePop_id, mw.Survey_id, su.SampleUnit_id, mw.Langid, ctb.Code, NULL, NULL, NULL, NULL, NULL, 0, mw.bitMockup
FROM #FG_MailingWork mw, Sel_TextBox st, CodeTxtBox ctb, SamplePlan sp, SampleUnit su
WHERE mw.Survey_id=st.Survey_id
AND mw.Langid=st.Language
AND mw.SelCover_id=st.Coverid
AND st.QPC_id=ctb.QPC_id
AND st.Survey_id=ctb.Survey_id
AND st.Language=ctb.Language
AND st.Survey_id=sp.Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.ParentSampleUnit_id IS NULL
--AND mw.Survey_id=@Survey


CREATE INDEX ndx_temppopCode ON #PopCode (SamplePop_id,SampleUnit_id)

-- Remove people who do not have entries in Unikeys.
SELECT DISTINCT ps.SamplePop_id
INTO #sp
FROM #popSection ps LEFT OUTER JOIN (SELECT SamplePop_id, SampleUnit_id
  FROM #bvuk b, SamplePop sp
  WHERE b.SampleSet_id=sp.SampleSet_id
 AND b.Pop_id=sp.Pop_id) b2
ON ps.SamplePop_id=b2.SamplePop_id
AND ps.SampleUnit_id=b2.SampleUnit_id
WHERE b2.SampleUnit_id IS NULL

-- Mod 1/20/04 SS (Log TestPrints to different FormGenError Log)
IF @bitTP = 0
 BEGIN
 INSERT INTO FormGenError (ScheduledMailing_id, datGenerated, FGErrorType_id)
 SELECT DISTINCT ScheduledMailing_id, GETDATE(), 36
 FROM #popSection ps, #sp sp
 WHERE sp.SamplePop_id=ps.SamplePop_id
 END
IF @bitTP = 1
 BEGIN
 INSERT INTO FormGenError_TP (TP_id, datGenerated, FGErrorType_id)
 SELECT DISTINCT ScheduledMailing_id, GETDATE(), 36
 FROM #popSection ps, #sp sp
 WHERE sp.SamplePop_id=ps.SamplePop_id
 END


DELETE ps
FROM #popSection ps, #sp sp
WHERE sp.SamplePop_id=ps.SamplePop_id

DELETE pc
FROM #popCover pc, #sp sp
WHERE sp.SamplePop_id=pc.SamplePop_id

DELETE pc
FROM #popCode pc, #sp sp
WHERE sp.SamplePop_id=pc.SamplePop_id

DELETE fm
FROM #FG_MailingWork fm, #sp sp
WHERE fm.SamplePop_id=sp.SamplePop_id
-- End of Addition


SET @SQL=
'UPDATE pc
SET Age=case WHEN bvuk.'+@AgeCol+'<18 THEN ''M'' ELSE ''A'' END,
Sex=CASE WHEN bvuk.'+@SexCol+'=''M'' THEN ''M'' ELSE ''F'' END,
Doctor=CASE WHEN bvuk.'+@Group_IndvCol+'=''G'' THEN ''G'' ELSE ''D'' END
FROM #PopCode pc, #FG_MailingWork mw, #BVUK bvuk
WHERE pc.SamplePop_id=mw.SamplePop_id
AND mw.Pop_id=bvuk.PopulationPop_id
AND pc.SampleUnit_id=bvuk.SampleUnit_id'
EXEC (@SQL)

-- minor exception rule
SELECT DISTINCT sd.Survey_id
INTO #S
FROM Survey_def sd, BusinessRule br
WHERE sd.Study_id=@Study
AND sd.Survey_id=br.Survey_id
AND sd.bitMinor_Except_flg=1
AND br.BusRule_cd='M'

SELECT TOP 1 @Survey=Survey_id FROM #S

--  MODIFIED 8/27/04 BD/SS FIX for Minor Exception Rule -- Added suvey_id = mw.survey_id in dynamic sql statement (approx Ln 416)
--IF @@ROWCOUNT >0
WHILE @@ROWCOUNT >0
  BEGIN
  INSERT INTO #criters (CriteriaStmt_id) SELECT CriteriaStmt_id FROM  BusinessRule WHERE BusRule_cd='M' AND Survey_id=@Survey
  EXEC sp_CriteriaStatements2 1
  SELECT @SQL=strCriteriaStmt FROM #criters
  SET @SQL=
  'UPDATE pc
  SET Age=''A''
  FROM #PopCode pc, #FG_MailingWork mw, #BVUK bv
  WHERE pc.SamplePop_id=mw.SamplePop_id
  AND mw.Pop_id=bv.PopulationPop_id
  AND pc.SampleUnit_id=bv.SampleUnit_id
  AND mw.survey_id = ' + CONVERT(VARCHAR,@Survey) + '
  AND ('+@SQL+')'
 --Modified 1/13/3 BD Enclosed the criteria stmt by Parentheses.
 -- AND '+@SQL
  EXEC (@SQL)
  TRUNCATE TABLE #criters

 DELETE #S WHERE Survey_id=@Survey

 SELECT TOP 1 @Survey=Survey_id FROM #S

  END

UPDATE pc
SET CodeText=ct.QPC_Text, Codetext_id=ct.Codetext_id
FROM #PopCode pc, Codestext ct
WHERE pc.Code=ct.Code
AND pc.age=ISNULL(ct.age,pc.age)
AND pc.sex=ISNULL(ct.sex,pc.sex)
AND pc.doctor=ISNULL(ct.doctor,pc.doctor)

/*------------------------------------------*/

-- Proposed changes: 1/22/04 SS
/*
Select cursor curtag inpput dat into #curtag table first
Then update #curtag PerInfo source data field with tagfield.tag_dsc when bitmockup = 1
Last Create cursor curtag from #curtag temporary table
Proceed as previously coded.
*/

SELECT DISTINCT ctt.CodeText_id, ctt.intStartPos, ctt.intLength,
'bvuk.'+mt.strTable_nm+mf.strField_nm strFieldInfo, mf.strField_nm,
CASE WHEN @bitTP = 0 THEN NULL ELSE pc.bitMockup END AS bitMockup
INTO #CurTag
FROM #PopCode pc, CodeTextTag ctt, TagField tf, MetaTable mt, MetaField mf
WHERE pc.Codetext_id=ctt.Codetext_id
AND ctt.Tag_id=tf.Tag_id
AND tf.Study_id= @Study
AND tf.Table_id=mt.Table_id
AND tf.Field_id=mf.Field_id
AND mf.strFieldDataType='S'
UNION
SELECT DISTINCT ctt.CodeText_id, ctt.intStartPos, ctt.intLength,
'CONVERT(VARCHAR,bvuk.'+mt.strTable_nm+mf.strField_nm+')' strFieldInfo, mf.strField_nm, pc.bitMockup
FROM #PopCode pc, CodeTextTag ctt, TagField tf, MetaTable mt, MetaField mf
WHERE pc.Codetext_id=ctt.Codetext_id
AND ctt.Tag_id=tf.Tag_id
AND tf.Study_id=@Study
AND tf.Table_id=mt.Table_id
AND tf.Field_id=mf.Field_id
AND mf.strFieldDataType='I'
UNION
SELECT DISTINCT ctt.CodeText_id, ctt.intStartPos, ctt.intLength,
 -- ADD Case When for @bitMockup = 1 (true)then use Getdate() rather than bvuk source date data. 1/22/04 ss
 CASE  WHEN pc.bitMockup = 1 THEN
  'datename(month,'+''''+@MockDate+''''+')+'' ''+CONVERT(VARCHAR,day('+''''+@MockDate+''''+'))+'', ''++CONVERT(VARCHAR,year('+''''+@MockDate+''''+'))'
 ELSE
  'datename(month,bvuk.'+mt.strTable_nm+mf.strField_nm+')+'' ''+CONVERT(VARCHAR,day(bvuk.'+mt.strTable_nm+mf.strField_nm+'))+'', ''+CONVERT(VARCHAR,year(bvuk.'+mt.strTable_nm+mf.strField_nm+'))'
 END strFieldInfo, mf.strField_nm, pc.bitMockup
FROM #PopCode pc, CodeTextTag ctt, TagField tf, MetaTable mt, MetaField mf
WHERE pc.Codetext_id=ctt.Codetext_id
AND ctt.Tag_id=tf.Tag_id
AND tf.Study_id=@Study
AND tf.Table_id=mt.Table_id
AND tf.Field_id=mf.Field_id
AND mf.strFieldDataType='D'
UNION
SELECT DISTINCT ctt.CodeText_id, ctt.intStartPos, ctt.intLength, '"'+tf.strreplaceliteral+'"', NULL, pc.bitMockup
FROM #PopCode pc, CodeTextTag ctt, TagField tf
WHERE pc.Codetext_id=ctt.Codetext_id
AND ctt.Tag_id=tf.Tag_id
AND tf.Study_id=@Study
AND tf.Table_id IS NULL
ORDER BY ctt.codetext_id, intStartPos DESC

-- Added 1/22/04 SS (Updates the curtag data with mockup fieldnm
 -- Modified address information criteria [7/20/04 SJS]
 UPDATE #curTag SET strFieldInfo = + '''' + t2.tag_dsc + ''''
 FROM #curTag, (
 SELECT DISTINCT mf.strfield_nm, t.tag_dsc
 FROM codeqstns cq, sel_qstns sq, survey_def sd, codes c, codestext ct, codetexttag ctt, tag t, tagfield tf, metafield mf
 WHERE cq.selqstns_id=sq.selqstns_id and cq.survey_id=sq.survey_id and sd.study_id=@study and cq.survey_id=sd.survey_id and cq.language=sq.language
 and sq.language=1
 and sq.section_id=-1 and sq.subsection=1 and sq.subtype=6 -- and sq.label='Address information'
 and cq.code=c.code  and c.code=ct.code and ct.codetext_id=ctt.codetext_id and ctt.tag_id=t.tag_id and ctt.tag_id=tf.tag_id and tf.study_id=sd.study_id and tf.field_id=mf.field_id
 ) t2 WHERE #curTag.strField_nm = t2.strField_nm AND bitMockup = 1

/*------------------------------------------*/

DECLARE @CT_id INT, @Start INT, @Length INT, @Field_nm VARCHAR(255), @bitMockup BIT
                    IF @bitTP = 0
  BEGIN


 DECLARE curTag CURSOR FOR
 SELECT CodeText_id, intStartPos, intLength, strFieldInfo FROM #curTag

 OPEN curTag
 FETCH NEXT FROM curTag INTO @CT_id, @Start, @Length, @Field_nm
 WHILE @@FETCH_STATUS=0

     BEGIN

   SET @SQL=
   'SET QUOTED_IDENTIFIER OFF
   UPDATE pc
   SET Codetext=LEFT(pc.CodeText,'+CONVERT(VARCHAR,@Start-1)+')+ISNULL('+@Field_nm+','''')+SUBSTRING(pc.CodeText,'+CONVERT(VARCHAR,@Start+@Length)+',255)
   FROM #PopCode pc, #FG_MailingWork mw, #BVUK bvuk
   WHERE pc.SamplePop_id=mw.SamplePop_id
   AND mw.Pop_id=bvuk.PopulationPop_id
   AND mw.SampleSet_ID = bvuk.SampleSet_ID
   AND pc.SampleUnit_id=bvuk.SampleUnit_id '+
   'AND pc.CodeText_id='+CONVERT(VARCHAR,@CT_id)

   EXEC (@SQL)
   FETCH NEXT FROM curTag INTO @CT_id, @Start, @Length, @Field_nm
   END

  CLOSE curTag
  DEALLOCATE curTag
  END

IF @bitTP = 1
  BEGIN

 DECLARE curTag CURSOR FOR
 SELECT CodeText_id, intStartPos, intLength, strFieldInfo, bitMockup FROM #curTag

 OPEN curTag
 FETCH NEXT FROM curTag INTO @CT_id, @Start, @Length, @Field_nm, @bitMockup
 WHILE @@FETCH_STATUS=0

 BEGIN

  SET @SQL=
  'SET QUOTED_IDENTIFIER OFF
  UPDATE pc
  SET Codetext=LEFT(pc.CodeText,'+CONVERT(VARCHAR,@Start-1)+')+ISNULL('+@Field_nm+','''')+SUBSTRING(pc.CodeText,'+CONVERT(VARCHAR,@Start+@Length)+',255)
  FROM #PopCode pc, #FG_MailingWork mw, #BVUK bvuk
  WHERE pc.SamplePop_id=mw.SamplePop_id
  AND mw.Pop_id=bvuk.PopulationPop_id
  AND mw.SampleSet_ID = bvuk.SampleSet_ID
  AND pc.SampleUnit_id=bvuk.SampleUnit_id '+
  'AND pc.CodeText_id='+CONVERT(VARCHAR,@CT_id) + CHAR(10) +
  'AND pc.bitMockup = mw.bitMockup ' +
  'AND pc.bitMockup = ' + STR(@bitMockup,1,0)

  EXEC (@SQL)
       FETCH NEXT FROM curTag INTO @CT_id, @Start, @Length, @Field_nm, @bitMockup

   END

  CLOSE curTag
  DEALLOCATE curTag
  END

/*------------------------------------------*/

--Modified 2/29/2 BD This will remove the dash FROM the address line if Zip4 IS NULL
UPDATE #PopCode
set CodeText=case when PatIndex('%-',CodeText)=Len(CodeText) then Left(CodeText,(Len(CodeText)-1)) else CodeText end
WHERE Code=30

-- Modified 3/29/04 SS - Replaces Male fname with femanle fname for mockups (bitMockup = 1) and sex = 'F'
UPDATE #PopCode SET codetext = REPLACE(codetext,'Christopher','Christina') WHERE bitMockup = 1 AND sex = 'F'

--  INSERT INTO SS_POPCODE SELECT *  FROM #POPCODE

/*------------------------------------------*/      /*------------------------------------------*/      /*------------------------------------------*/
/*------------------------------------------*/      /*------------------------------------------*/      /*------------------------------------------*/


BEGIN TRANSACTION
DECLARE @GetDate DATETIME
SELECT @GetDate=GETDATE()

-- MOD 1/20/04 SS (Flow Logic for Production = 0 / Ttest prints = 1)
IF @bitTP = 0

  BEGIN
 -- Add to SentMailing
 INSERT INTO SentMailing(datGenerated, Methodology_id, ScheduledMailing_id, Langid)
 SELECT @GetDate, Methodology_id, ScheduledMailing_id, Langid
 FROM #FG_MailingWork
 --WHERE #FG_MailingWork.Survey_id=@Survey

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
   SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END

 SELECT DISTINCT Survey_id INTO #TT FROM #FG_MailingWork

 SELECT TOP 1 @Survey=Survey_id FROM #TT
 WHILE @@ROWCOUNT>0
 BEGIN

  --We will generate the skip pattern information for all outgo, even postcards because of Canada.
  EXEC SP_FG_PopulateSkipPatterns @Survey, @GetDate

  DELETE #TT WHERE Survey_id=@Survey
  SELECT TOP 1 @Survey=Survey_id FROM #TT

 END

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
     SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END

 -- UPDATE ScheduledMailing with new SentMail_id's
 UPDATE ScheduledMailing
 SET SentMail_id=SM.SentMail_id
 FROM SentMailing SM, ScheduledMailing SC
 WHERE SM.ScheduledMailing_id=SC.ScheduledMailing_id AND
       SC.SentMail_id IS NULL

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END

 --Start of Modification BD 9/13/4
 --Save off the bundling code fields
 CREATE TABLE #BundlingCodeColumns (NeedColumn VARCHAR(60), HasColumn BIT)

 INSERT INTO #BundlingCodeColumns (NeedColumn, HasColumn)
 SELECT 'POPULATION'+strField_nm,0
 FROM MetaField
 WHERE strField_nm IN ('Zip5','Zip4','Postal_Code')

 --What columns do we have?
 UPDATE t
 SET t.HasColumn=1
 FROM #BundlingCodeColumns t, TempDB.dbo.SysColumns sc
 WHERE sc.id=OBJECT_ID('TempDB.dbo.#BVUK')
 AND t.NeedColumn=sc.Name

 SELECT @SQL='schm.SentMail_id'
 SELECT @SQL=@SQL+CASE HasColumn WHEN 1 THEN ','+NeedColumn ELSE ',NULL' END
 FROM #BundlingCodeColumns
 ORDER BY NeedColumn DESC

 SELECT @SQL='INSERT INTO BundlingCodes
 SELECT DISTINCT '+@SQL+'
 FROM #BVUK b, #FG_MailingWork f, ScheduledMailing schm
 WHERE f.SampleSet_id=b.SampleSet_id
 AND f.Pop_id=b.PopulationPop_id
 AND f.ScheduledMailing_id=schm.ScheduledMailing_id'
--  SELECT * FROM #BVUK
--  PRINT @SQL
 EXEC (@SQL)

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
   SELECT ScheduledMailing_id, GETDATE(), 38 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END
 --End of Modification BD 9/13/4

 select @MaxQF = max(questionform_id)
 from dbo.QuestionForm

 -- Add to QuestionForm
 INSERT INTO QuestionForm(SentMail_id, SamplePop_id, Survey_id)
 SELECT SC.SentMail_id, SC.SamplePop_id, MW.Survey_id
 FROM ScheduledMailing SC, #FG_MailingWork MW
 WHERE SC.ScheduledMailing_id=MW.ScheduledMailing_id AND MW.bitSendSurvey=1 --AND MW.Survey_id=@Survey

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END

 exec dbo.CalcCAHPSSupplemental @MaxQF

	 -- Only want to schedule the next ungenerated record
	INSERT INTO ScheduledMailing (MailingStep_id, SamplePop_id, Methodology_id, datGenerate)
	 SELECT mw.NextMailingStep_id, mw.SamplePop_id, mw.Methodology_id, convert(datetime,'12/31/4172') 
	 FROM   #FG_MailingWork mw 
		LEFT OUTER JOIN #FG_MailingWork mw2	ON     mw.NextMailingStep_id=mw2.MailingStep_id 
													AND mw.SamplePop_id=mw2.SamplePop_id
	 WHERE  mw.NextMailingStep_id IS NOT NULL 
			AND mw.OverrideItem_id IS NULL 
			AND mw2.MailingStep_id IS NULL
	
	IF @@ERROR <> 0
	   BEGIN
		  ROLLBACK TRANSACTION
		  INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
		  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
		  TRUNCATE TABLE #FG_MailingWork
		  RETURN
	   END


INSERT INTO FGPopSection (SentMail_id, Survey_id, SampleUnit_id, Section_id, Langid)
     SELECT SentMail_id, Survey_id, SampleUnit_id, Section_id, Langid
  FROM #PopSection p, ScheduledMailing schm
  WHERE p.ScheduledMailing_id=schm.ScheduledMailing_id


 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
  RETURN
   END

 INSERT INTO FGPopCover (SentMail_id, Survey_id, SelCover_id, Langid)
     SELECT SentMail_id, Survey_id, SelCover_id, Langid
  FROM #PopCover p, ScheduledMailing schm
  WHERE p.ScheduledMailing_id=schm.ScheduledMailing_id


 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END

 INSERT INTO FGPopCode (SentMail_id, Survey_id, SampleUnit_id, Language, Code, Codetext)
     SELECT SentMail_id, Survey_id, SampleUnit_id, Language, Code, Codetext
  FROM #PopCode p, ScheduledMailing schm
  WHERE p.ScheduledMailing_id=schm.ScheduledMailing_id

 IF @@ERROR <> 0                           BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError (ScheduledMailing_id,datGenerated,FGErrorType_id)
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END
  END

IF @bitTP = 1
  BEGIN

  -- UPDATE Scheduled_TP with bitDone = 1
   UPDATE SC
   SET sc.bitDone = 1
   FROM #FG_MailingWork mw,  Scheduled_TP SC
   WHERE mw.ScheduledMailing_id=SC.TP_id AND
       SC.bitDone = 0

 IF @@ERROR <> 0
   BEGIN
     ROLLBACK TRANSACTION
      INSERT INTO FormGenError_TP (TP_id,datGenerated,FGErrorType_id)          -- Changed the log file to FormGenError_TP from FormGenError / SJS 7/21/04
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
      RETURN
   END

 INSERT INTO FGPopSection_TP (TP_id, Survey_id, SampleUnit_id, Section_id, Langid)
     SELECT ScheduledMailing_id, Survey_id, SampleUnit_id, Section_id, Langid
  FROM #PopSection

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError_TP (TP_id,datGenerated,FGErrorType_id)
SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
  RETURN
   END

INSERT INTO FGPopCover_TP (TP_id, Survey_id, SelCover_id, Langid)
     SELECT ScheduledMailing_id, Survey_id, SelCover_id, Langid
  FROM #PopCover

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError_TP (TP_id,datGenerated,FGErrorType_id)
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
  RETURN
   END

 INSERT INTO FGPopCode_TP (TP_id, Survey_id, SampleUnit_id, Language, Code, Codetext)
     SELECT ScheduledMailing_id, Survey_id, SampleUnit_id, Language, Code, Codetext
  FROM #PopCode

 IF @@ERROR <> 0
   BEGIN
      ROLLBACK TRANSACTION
      INSERT INTO FormGenError_TP (TP_id,datGenerated,FGErrorType_id)
  SELECT ScheduledMailing_id, GETDATE(), 3 FROM #FG_MailingWork
      TRUNCATE TABLE #FG_MailingWork
  RETURN
   END
  END

COMMIT TRANSACTION

/*---------------------------------*/
/*  Update PCL Tables     */
/*---------------------------------*/

SELECT DISTINCT Survey_id
INTO #Survey
FROM #FG_MailingWork

SELECT TOP 1 @Survey=Survey_id FROM #Survey
WHILE @@ROWCOUNT>0
BEGIN

IF @bitTP = 0
BEGIN
 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Cover WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Cover (SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead)
         SELECT SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead
          FROM Sel_Cover
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Logo WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Logo (QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE)
         SELECT QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE
          FROM Sel_Logo
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_PCL WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_PCL (QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS)
         SELECT QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS
          FROM Sel_PCL
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Qstns WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Qstns (SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
             RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW)
         SELECT SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
             RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW
          FROM Sel_Qstns
  WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Scls WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Scls (Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE)
         SELECT Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE
          FROM Sel_Scls
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Skip WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Skip (Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE)
         SELECT Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE
          FROM Sel_Skip
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_textbox WHERE Survey_id=@Survey)
   BEGIN
 INSERT INTO PCL_textbox (QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW)
         SELECT QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW
    FROM Sel_TextBox
          WHERE Survey_id=@Survey
   END
END

IF @bitTP = 1 -- ADDED 1/20/04 SS (test prints) -- start
  BEGIN

 IF @ResetForm=1
  BEGIN
   DELETE PCL_Cover_TP WHERE Survey_id=@Survey
   DELETE PCL_Logo_TP WHERE Survey_id=@Survey
   DELETE PCL_PCL_TP WHERE Survey_id=@Survey
   DELETE PCL_Qstns_TP WHERE Survey_id=@Survey
   DELETE PCL_Scls_TP WHERE Survey_id=@Survey
   DELETE PCL_Skip_TP WHERE Survey_id=@Survey
   DELETE PCL_TextBox_TP WHERE Survey_id=@Survey
  END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Cover_TP WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Cover_TP (SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead,datValidated)
         SELECT SelCover_id,Survey_id,PageType,Description,Integrated,bitLetterHead,@ValidationDate
         FROM Sel_Cover
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Logo_TP WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Logo_TP (QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE)
         SELECT QPC_ID,CoverID,Survey_ID,DESCRIPTION,X,Y,WIDTH,HEIGHT,SCALING,BITMAP,VISIBLE
          FROM Sel_Logo
WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_PCL_TP WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_PCL_TP (QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS)
         SELECT QPC_ID,Survey_ID,Language,CoverID,DESCRIPTION,X,Y,WIDTH,HEIGHT,PCLSTREAM,KNOWNDIMENSIONS
          FROM Sel_PCL
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Qstns_TP WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Qstns_TP (SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
             RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW)
         SELECT SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
             RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW
          FROM Sel_Qstns
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Scls_TP WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Scls_TP (Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE)
         SELECT Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE
          FROM Sel_Scls
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_Skip_TP WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_Skip_TP (Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE)
         SELECT Survey_ID,SelQstns_ID,SELScls_ID,ScaleITEM,NUMSkip,NUMSkipTYPE
          FROM Sel_Skip
          WHERE Survey_id=@Survey
   END

 IF NOT EXISTS (SELECT TOP 1 * FROM PCL_textbox_TP WHERE Survey_id=@Survey)
   BEGIN
      INSERT INTO PCL_textbox_TP (QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW)
         SELECT QPC_ID,Survey_ID,Language,CoverID,X,Y,WIDTH,HEIGHT,RICHTEXT,BORDER,SHADING,BITLANGREVIEW
    FROM Sel_TextBox
          WHERE Survey_id=@Survey
   END
END -- ADDED 1/20/04 SS (test prints) -- end


 DELETE #Survey WHERE Survey_id=@Survey

 SELECT TOP 1 @Survey=Survey_id FROM #Survey

END


--MB 11/19/08
--Update Dataload tables for validation.
--these tables hold a snapshot of what sel_qstns and sel_scles looks like when the survey is generated
IF @bitTP=0
BEGIN
 SELECT DISTINCT Survey_id, Sampleset_ID
 INTO #SurveySSet
 FROM #FG_MailingWork

 SELECT TOP 1 @Survey=Survey_id, @SampleSet=SampleSet_ID FROM #SurveySSet

 WHILE @@ROWCOUNT>0
 BEGIN


  IF NOT EXISTS (SELECT TOP 1 * FROM DL_SEL_QSTNS_BySampleSet WHERE Survey_id=@Survey and SampleSet_ID=@Sampleset)
    BEGIN
    INSERT INTO DL_SEL_QSTNS_BySampleSet (Sampleset_ID, SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
     RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW,STRFULLQUESTION)
     SELECT @Sampleset as Sampleset_ID, SelQstns_ID,Survey_ID,Language,ScaleID,Section_ID,LABEL,PLUSMINUS,SUBSection,ITEM,SubType,WIDTH,HEIGHT,
     RICHTEXT,ScalePOS,ScaleFLIPPED,NUMMARKCOUNT,BITMEANABLE,NUMBUBBLECOUNT,QSTNCORE,BITLANGREVIEW,STRFULLQUESTION
     FROM Sel_Qstns
  WHERE Survey_id=@Survey
    END


  IF NOT EXISTS (SELECT TOP 1 * FROM DL_SEL_SCLS_BySampleSet WHERE Survey_id=@Survey and SampleSet_ID=@Sampleset)
    BEGIN
    INSERT INTO DL_SEL_SCLS_BySampleSet (Sampleset_ID, Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE)
     SELECT @Sampleset as Sampleset_ID, Survey_ID,QPC_ID,ITEM,Language,VAL,LABEL,RICHTEXT,MISSING,CHARSET,ScaleORDER,INTRESPTYPE
     FROM Sel_Scls
     WHERE Survey_id=@Survey
    END

  IF NOT EXISTS (SELECT TOP 1 * FROM DL_SampleUnitSection_BySampleset WHERE SELQSTNSSURVEY_ID=@Survey and SampleSet_ID=@Sampleset)
    BEGIN
    INSERT INTO DL_SampleUnitSection_BySampleset (SampleSet_ID, SAMPLEUNITSECTION_ID , SAMPLEUNIT_ID , SELQSTNSSECTION , SELQSTNSSURVEY_ID)
     SELECT @Sampleset as Sampleset_ID,  SAMPLEUNITSECTION_ID , SAMPLEUNIT_ID , SELQSTNSSECTION , SELQSTNSSURVEY_ID
     FROM SampleUnitSection
     WHERE SELQSTNSSURVEY_ID=@Survey
    END


   DELETE #SurveySSet WHERE Survey_id=@Survey and SampleSet_ID=@Sampleset

   SELECT TOP 1 @Survey=Survey_id, @SampleSet=SampleSet_ID FROM #SurveySSet

 END
  END --@bitTP=0


IF @bitTP=0 AND @Survey%10=0
UPDATE STATISTICS SentMailing

DROP TABLE #PopSection
DROP TABLE #PopCover
DROP TABLE #PopCode
DROP TABLE #criters
DROP TABLE #BVUK
DROP TABLE #Survey
DROP TABLE #S
DROP TABLE #sp
DROP TABLE #curtag
IF (SELECT OBJECT_ID('TempDB.dbo.#BundlingCodeColumns')) IS NOT NULL DROP TABLE #BundlingCodeColumns

SET QUOTED_IDENTIFIER ON


