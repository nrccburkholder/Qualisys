CREATE PROCEDURE bd_ese
 @Study VARCHAR(50),
 @Survey VARCHAR(50),
 @BeginDate DATETIME,
 @EndDate DATETIME
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

DECLARE @intSurvey_id INT, @intStudy_id INT, @strsql VARCHAR(2000), @Field VARCHAR(50), @Field_id INT, @selsql VARCHAR(1000)

SELECT @intSurvey_id=sd.Survey_id, @intStudy_id=s.Study_id 
FROM Survey_def sd, Study s
WHERE s.strStudy_nm=@Study
  AND sd.strSurvey_nm=@Survey
  AND s.Client_id=1031
  AND s.Study_id=sd.Study_id

print @intSurvey_id

CREATE TABLE #sp (strLithoCode VARCHAR(15), MailingStep VARCHAR(20), SamplePop_id INT, Pop_id INT, strSampleUnit_nm VARCHAR(42), Enc_id INT)

INSERT INTO #sp
SELECT strLithoCode, strMailingStep_nm, SamplePop_id, NULL, NULL, NULL
FROM SentMailing sm(NOLOCK), scheduledMailing schm(NOLOCK), MailingStep ms(NOLOCK)
WHERE ms.Survey_id = @intSurvey_id
AND ms.MailingStep_id = schm.MailingStep_id
AND schm.SentMail_id = sm.SentMail_id
AND sm.datgenerated BETWEEN @BeginDate AND @EndDate + '23:59:59:000'

print 'update #sp'
UPDATE t
SET t.Pop_id = sp.Pop_id, t.strSampleUnit_nm = su.strSampleUnit_nm
FROM #sp t, SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK), SampleUnit su(NOLOCK)
WHERE t.SamplePop_id = sp.SamplePop_id
AND sp.Sampleset_id = ss.Sampleset_id
AND sp.Pop_id = ss.Pop_id
--AND ss.inTextracted_flg = 1
AND ss.strUnitSelectType='D'
AND ss.SampleUnit_id = su.SampleUnit_id

--Determine the personalization used in the cover letter
CREATE TABLE #Codes (Table_id INT, TableInitial CHAR(1), Field_id INT, strField_nm VARCHAR(42), strreplaceliteral VARCHAR(40))

print 'get the codes'
INSERT INTO #Codes
SELECT DISTINCT Table_id, NULL, Field_id, NULL, strreplaceliteral
FROM CodeTxtBox ctb(NOLOCK), CodesText ct(NOLOCK), CodeTextTag ctt(NOLOCK), TagField tg(NOLOCK)
WHERE ctb.Survey_id = @intSurvey_id
AND ctb.Code = ct.Code
AND ct.CodeText_id = ctt.CodeText_id
AND ctt.Tag_id = tg.Tag_id
AND tg.Study_id = @intStudy_id
AND Field_id NOT IN (9,10,7,6,11,23,1105)
UNION
SELECT DISTINCT Table_id, NULL, Field_id, NULL, strreplaceliteral
FROM CodeQstns cq(NOLOCK), CodesText ct(NOLOCK), CodeTextTag ctt(NOLOCK), TagField tg(NOLOCK)
WHERE cq.Survey_id = @intSurvey_id
AND cq.Code = ct.Code
AND ct.CodeText_id = ctt.CodeText_id
AND ctt.Tag_id = tg.Tag_id
AND tg.Study_id = @intStudy_id
AND Field_id NOT IN (9,10,7,6,11,23,1105)

UPDATE t
SET t.strField_nm = mf.strField_nm
FROM #Codes t, MetaField mf
WHERE t.Field_id = mf.Field_id

UPDATE t
SET TableInitial = LEFT(strTable_nm,1)
FROM #Codes t, MetaTable mt
WHERE t.Table_id = mt.Table_id

select * From #codes

SELECT strField_nm
INTO #sel
FROM MetaData_View
WHERE Study_id=@intStudy_id
AND strField_nm IN ('FName', 'LName', 'Addr', 'City', 'St', 'Zip5_Foreign', 'Zip4', 'Zip5','Postal_Code','Province')

SET @selsql=''

SELECT @selsql=@selsql+strField_nm+','
FROM #sel

SET @selsql=LEFT(@selsql,LEN(@selsql)-1)

--Does the Study have an encounter Table?
IF EXISTS (SELECT * FROM MetaData_View WHERE Study_id = @intStudy_id AND strTable_nm = 'ENCOUNTER')
BEGIN

SET @strsql = 'UPDATE t
SET t.Enc_id = ss.Enc_id
FROM #sp t, SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK), SampleUnit su(NOLOCK)
WHERE t.SamplePop_id = sp.SamplePop_id
AND sp.Sampleset_id = ss.Sampleset_id
AND sp.Pop_id = ss.Pop_id
AND su.ParentSampleUnit_id IS NULL
AND ss.SampleUnit_id = su.SampleUnit_id'

print @strsql
EXEC (@strsql)

SET @strsql = 'SELECT strLithoCode, MailingStep, strSampleUnit_nm, '+@selsql
--SET @strsql = 'SELECT strLithoCode, MailingStep, strSampleUnit_nm, FName, LName, Addr, City, St, Zip5_Foreign, Zip4 '

WHILE (SELECT COUNT(*) FROM #Codes) > 0
BEGIN

SET @Field_id = (SELECT TOP 1 Field_id FROM #Codes)

SELECT @Field = TableInitial + '.' + strField_nm FROM #Codes WHERE Field_id = @Field_id

SET @strsql = @strsql + ', ' + @Field

DELETE #Codes WHERE Field_id = @Field_id

END

SET @strsql = @strsql + ' FROM #sp t, s' + CONVERT(VARCHAR,@intStudy_id) + '.Population p, s' + CONVERT(VARCHAR,@intStudy_id) + '.Encounter e
WHERE t.Pop_id = p.Pop_id
AND t.Enc_id = e.Enc_id
AND Langid = 99999
ORDER BY strLithoCode'
print @strsql
EXEC (@strsql)

END

ELSE 
BEGIN

SET @strsql = 'SELECT strLithoCode, MailingStep, strSampleUnit_nm, '+@selsql
--SET @strsql = 'SELECT strLithoCode, MailingStep, strSampleUnit_nm, FName, LName, Addr, City, St, Zip5_Foreign, Zip4 '

WHILE (SELECT COUNT(*) FROM #Codes) > 0
BEGIN

SET @Field_id = (SELECT TOP 1 Field_id FROM #Codes)

SELECT @Field = TableInitial + '.' + strField_nm FROM #Codes WHERE Field_id = @Field_id

SET @strsql = @strsql + ', ' + @Field

DELETE #Codes WHERE Field_id = @Field_id

END

SET @strsql = @strsql + ' FROM #sp t, s' + CONVERT(VARCHAR,@intStudy_id) + '.Population p
WHERE t.Pop_id = p.Pop_id
AND langid = 99999
ORDER BY strLithoCode'

print @strsql
EXEC (@strsql)

END

DROP TABLE #sp
DROP TABLE #Codes

SET NOCOUNT OFF


