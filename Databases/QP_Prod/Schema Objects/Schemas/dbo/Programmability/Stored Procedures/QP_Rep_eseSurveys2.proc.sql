-- Modified 1/31/2005 SJS - Added SurveyID to the output
-- Modified 11/27/2012 JJF - Added extra columns for working with TeleForm
CREATE PROCEDURE [dbo].[QP_Rep_eseSurveys2]  
    @Associate VARCHAR(50),  
    @Client    VARCHAR(50),  
    @Study     VARCHAR(50),  
    @Survey    VARCHAR(50),  
    @BeginDate DATETIME,  
    @EndDate   DATETIME  
AS  

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

DECLARE @intSurvey_id INT, @intStudy_id INT, @strsql VARCHAR(2000), @Field VARCHAR(50), @Field_id INT, @selsql VARCHAR(1000)  

SELECT @intSurvey_id = sd.Survey_id, @intStudy_id = s.Study_id   
FROM Survey_def sd, Study s, Client c  
WHERE c.strClient_nm = @Client  
  AND s.strStudy_nm = @Study  
  AND sd.strSurvey_nm = @Survey  
  AND c.Client_id = s.Client_id  
  AND s.Study_id = sd.Study_id  
  
CREATE TABLE #sp (strLithoCode VARCHAR(15), SurveyID INT, MailingStep VARCHAR(20), SamplePop_id INT, Pop_id INT, strSampleUnit_nm VARCHAR(42), Enc_id INT)  
  
INSERT INTO #sp  
SELECT strLithoCode, survey_id, strMailingStep_nm, SamplePop_id, NULL, NULL, NULL  
FROM SentMailing sm(NOLOCK), scheduledMailing schm(NOLOCK), MailingStep ms(NOLOCK)  
WHERE ms.Survey_id = @intSurvey_id  
  AND ms.MailingStep_id = schm.MailingStep_id  
  AND schm.SentMail_id = sm.SentMail_id  
  AND sm.datgenerated BETWEEN @BeginDate AND @EndDate + '23:59:59:000'  
  
UPDATE t  
SET t.Pop_id = sp.Pop_id, t.strSampleUnit_nm = su.strSampleUnit_nm  
FROM #sp t, SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK), SampleUnit su(NOLOCK)  
WHERE t.SamplePop_id = sp.SamplePop_id  
  AND sp.Sampleset_id = ss.Sampleset_id  
  AND sp.Pop_id = ss.Pop_id  
--AND ss.intExtracted_flg=1  
  AND ss.strUnitSelectType = 'D'  
  AND ss.SampleUnit_id = su.SampleUnit_id  
  
--Determine the personalization used in the cover letter  
CREATE TABLE #Codes (Table_id INT, TableName VARCHAR(50), Field_id INT, strField_nm VARCHAR(42), strreplaceliteral VARCHAR(40))  
  
INSERT INTO #Codes  
SELECT DISTINCT Table_id, NULL, Field_id, NULL, strreplaceliteral  
FROM CodeTxtBox ctb(NOLOCK), CodesText ct(NOLOCK), CodeTextTag ctt(NOLOCK), TagField tg(NOLOCK)  
WHERE ctb.Survey_id = @intSurvey_id  
  AND ctb.Code = ct.Code  
  AND ct.CodeText_id = ctt.CodeText_id  
  AND ctt.Tag_id = tg.Tag_id  
  AND tg.Study_id = @intStudy_id  
  AND Field_id NOT IN (9, 10, 7, 6, 11, 23, 1105)  
UNION  
SELECT DISTINCT Table_id, NULL, Field_id, NULL, strreplaceliteral  
FROM CodeQstns cq(NOLOCK), CodesText ct(NOLOCK), CodeTextTag ctt(NOLOCK), TagField tg(NOLOCK)  
WHERE cq.Survey_id  =@intSurvey_id  
  AND cq.Code = ct.Code  
  AND ct.CodeText_id = ctt.CodeText_id  
  AND ctt.Tag_id = tg.Tag_id  
  AND tg.Study_id = @intStudy_id  
  AND Field_id NOT IN (9, 10, 7, 6, 11, 23, 1105)  
  
UPDATE t  
SET t.strField_nm = mf.strField_nm  
FROM #Codes t, MetaField mf(NOLOCK)  
WHERE t.Field_id = mf.Field_id  
  
UPDATE t  
SET TableName = strTable_nm  
FROM #Codes t, MetaTable mt(NOLOCK)  
WHERE t.Table_id = mt.Table_id  
  
SELECT strField_nm  
INTO #sel  
FROM MetaData_View(NOLOCK)  
WHERE Study_id = @intStudy_id  
  AND strField_nm IN ('FName', 'LName', 'Addr', 'City', 'St', 'Zip5_Foreign', 'Zip4', 'Zip5', 'Postal_Code', 'Province')  
  
SET @selsql = ''  
  
SELECT @selsql = @selsql + 'Population' + strField_nm + ' ' + strField_nm + ','  
FROM #sel  
  
SET @selsql = LEFT(@selsql, LEN(@selsql) - 1)  
  
--Does the Study have an encounter Table?  
IF EXISTS (SELECT * FROM MetaData_View WHERE Study_id = @intStudy_id AND strTable_nm = 'ENCOUNTER')  
BEGIN  
    SET @strsql='UPDATE t ' +
                'SET t.Enc_id = ss.Enc_id ' +
                'FROM #sp t, SamplePop sp(NOLOCK), SelectedSample ss(NOLOCK), SampleUnit su(NOLOCK) ' +
                'WHERE t.SamplePop_id = sp.SamplePop_id ' +
                '  AND sp.Sampleset_id = ss.Sampleset_id ' +
                '  AND sp.Pop_id = ss.Pop_id ' +
                '  AND su.ParentSampleUnit_id IS NULL ' +
                '  AND ss.SampleUnit_id = su.SampleUnit_id'  
    EXEC (@strsql)  
  
    SET @strsql = 'SELECT strLithoCode, dbo.LithotoBarCode(strLithoCode, 1) AS BarCode, '''' AS MatchBarCode, t.SurveyID, MailingStep, strSampleUnit_nm, ' + @selsql  
    --SET @strsql = 'SELECT strLithoCode, t.SurveyID, MailingStep, strSampleUnit_nm, ' + @selsql  
    --SET @strsql = 'SELECT strLithoCode, MailingStep, strSampleUnit_nm, FName, LName, Addr, City, St, Zip5_Foreign, Zip4 '  
  
    WHILE (SELECT COUNT(*) FROM #Codes) > 0  
    BEGIN  
        SET @Field_id = (SELECT TOP 1 Field_id FROM #Codes)  
  
        SELECT @Field = TableName + strField_nm + ' ' + strField_nm FROM #Codes WHERE Field_id = @Field_id  
  
        SET @strsql = @strsql + ', ' + @Field  
  
        DELETE #Codes WHERE Field_id = @Field_id  
    END  

    SET @strsql = @strsql + ', '''' AS ContactName, '''' AS ContactPhone, '''' AS SignerName, '''' AS SignaturePath, '''' AS LogoPath '

    SET @strsql = @strsql + 'FROM #sp t, s' + CONVERT(VARCHAR, @intStudy_id) + '.Big_View bv ' +
                            'WHERE t.Enc_id = bv.EncounterEnc_id ' +
                            '  AND bv.PopulationLangid = 99999 ' +
                            'ORDER BY strLithoCode'  
    EXEC (@strsql)  
END  
ELSE   
BEGIN  
    SET @strsql = 'SELECT strLithoCode, dbo.LithotoBarCode(strLithoCode, 1) AS BarCode, '''' AS MatchBarCode, t.SurveyID, MailingStep, strSampleUnit_nm, ' + @selsql  
    --SET @strsql = 'SELECT strLithoCode, t.SurveyID, MailingStep, strSampleUnit_nm, ' + @selsql  
    --SET @strsql = 'SELECT strLithoCode, MailingStep, strSampleUnit_nm, FName, LName, Addr, City, St, Zip5_Foreign, Zip4 '  
  
    WHILE (SELECT COUNT(*) FROM #Codes) > 0  
    BEGIN  
        SET @Field_id = (SELECT TOP 1 Field_id FROM #Codes)  
  
        SELECT @Field = TableName + strField_nm + ' ' + strField_nm FROM #Codes WHERE Field_id = @Field_id  
  
        SET @strsql = @strsql + ', ' + @Field  
  
        DELETE #Codes WHERE Field_id = @Field_id  
    END  

    SET @strsql = @strsql + ', '''' AS ContactName, '''' AS ContactPhone, '''' AS SignerName, '''' AS SignaturePath, '''' AS LogoPath '

    SET @strsql = @strsql + 'FROM #sp t, s' + CONVERT(VARCHAR, @intStudy_id) + '.Big_View bv ' +
                            'WHERE t.Pop_id = bv.PopulationPop_id ' +
                            '  AND bv.PopulationLangid = 99999 ' +
                            'ORDER BY strLithoCode'  
    EXEC (@strsql)  
END  
  
DROP TABLE #sp  
DROP TABLE #Codes 
DROP TABLE #sel 
  
SET NOCOUNT OFF


