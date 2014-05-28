-- DFCT0010957
CREATE PROCEDURE [dbo].[QP_Rep_Phone_Extract]  
   @Associate VARCHAR(50),  
   @Client VARCHAR(50),  
   @Study VARCHAR(50),  
   @Survey VARCHAR(50),  
   @SampleSet VARCHAR(50)  
AS  

-- Modified 11/09/06 GN: Added WAC

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
DECLARE @intSurvey_id INT, @intStudy_id INT, @intSampleSet_id INT  
DECLARE @strsql VARCHAR(8000), @AdditionalFields VARCHAR(1000)  
  
SELECT @intSurvey_id=sd.Survey_id   
FROM Survey_def sd, Study s, Client c  
WHERE c.strClient_nm=@Client  
  AND s.strStudy_nm=@Study  
  AND sd.strSurvey_nm=@Survey  
  AND c.Client_id=s.Client_id  
  AND s.Study_id=sd.Study_id  
  
SELECT @intStudy_id=s.Study_id   
FROM Study s, Client c  
WHERE c.strClient_nm=@Client  
  AND s.strStudy_nm=@Study  
  AND c.Client_id=s.Client_id  
  
SELECT @intSampleSet_id=SampleSet_id  
FROM SampleSet  
WHERE Survey_id=@intSurvey_id  
  AND ABS(DATEDIFF(SECOND,datSampleCreate_Dt,CONVERT(DATETIME,@SampleSet)))<=1  
  
SELECT @AdditionalFields=''  
SELECT @AdditionalFields=@AdditionalFields+','+strTable_nm+strField_nm  
FROM MetaData_View   
WHERE Study_id=@intStudy_id  
AND strTable_nm IN ('Population','ENCOUNTER','Provider','MilitaryRank','MTF','Clinic','MEPRS3','RANK')  
AND strField_nm IN ('ServiceDate','DrLastName','DrTitle','RankName','FacilityName','ClinicName','UnitNum','ServiceInd_10','RegionCustom','ServiceInd_9','DischargeDate','Middle')  

IF EXISTS (SELECT * FROM MetaTable WHERE Study_id=@intStudy_id AND strTable_nm='Encounter')  
SET @strsql='SELECT DISTINCT strLithoCode, DBO.LITHOTOWAC (STRLITHOCODE) WAC, ISNULL(LTRIM(RTRIM(LEFT(PopulationAreaCode,3))),'''')+LTRIM(RTRIM(PopulationPhone)) as Phone, PopulationFName FName, /*PopulationMiddle Middle,*/ '+CHAR(10)+  
 ' PopulationLName LName, PopulationAge Age, PopulationSex Sex, PopulationAddr Addr, PopulationCity City, PopulationSt St, PopulationZip5 Zip5, PopulationZip4 Zip4, '+CHAR(10)+  
 ' sm.LangID, PopulationPop_id Pop_id'+@AdditionalFields+CHAR(10)+  
 ' FROM s'+CONVERT(VARCHAR,@intStudy_id)+'.Big_View bv,'+CHAR(10)+  
 ' SelectedSample ss, SamplePop sp, ScheduledMailing schm, SentMailing sm '+CHAR(10)+  
 ' WHERE ss.SampleSet_id='+CONVERT(VARCHAR,@intSampleSet_id)+CHAR(10)+  
 ' AND ss.SampleSet_id=sp.SampleSet_id'+CHAR(10)+  
 ' AND ss.Pop_id=sp.Pop_id'+CHAR(10)+  
 ' AND sp.SamplePop_id=schm.SamplePop_id'+CHAR(10)+  
 ' AND schm.SentMail_id=sm.SentMail_id'+CHAR(10)+  
 ' AND ss.Enc_id=EncounterEnc_id'+CHAR(10)+  
 ' AND PopulationPop_id NOT IN ('+CHAR(10)+  
 '   SELECT Pop_id FROM TOCL WHERE Study_id='+CONVERT(VARCHAR,@intStudy_id)+')'+CHAR(10)+  
 ' ORDER BY PopulationPop_id'  
ELSE  
SET @strsql='SELECT DISTINCT strLithoCode, DBO.LITHOTOWAC (STRLITHOCODE) WAC, ISNULL(LTRIM(RTRIM(LEFT(PopulationAreaCode,3))),'''')+LTRIM(RTRIM(PopulationPhone)) as Phone, PopulationFName FName, /*PopulationMiddle Middle,*/ '+CHAR(10)+
 ' PopulationLName LName, PopulationAge Age, PopulationSex Sex, PopulationAddr Addr, PopulationCity City, PopulationSt St, PopulationZip5 Zip5, PopulationZip4 Zip4, '+CHAR(10)+  
 ' sm.LangID, PopulationPop_id Pop_id'+@AdditionalFields+CHAR(10)+  
 ' FROM s'+CONVERT(VARCHAR,@intStudy_id)+'.Big_View bv,'+CHAR(10)+  
 ' SelectedSample ss, SamplePop sp, ScheduledMailing schm, SentMailing sm '+CHAR(10)+  
 ' WHERE ss.SampleSet_id='+CONVERT(VARCHAR,@intSampleSet_id)+CHAR(10)+  
 ' AND ss.SampleSet_id=sp.SampleSet_id'+CHAR(10)+  
 ' AND ss.Pop_id=sp.Pop_id'+CHAR(10)+  
 ' AND sp.SamplePop_id=schm.SamplePop_id'+CHAR(10)+  
 ' AND schm.SentMail_id=sm.SentMail_id'+CHAR(10)+  
 ' AND ss.Pop_id=PopulationPop_id'+CHAR(10)+  
 ' AND PopulationPop_id NOT IN ('+CHAR(10)+  
 '   SELECT Pop_id FROM TOCL WHERE Study_id='+CONVERT(VARCHAR,@intStudy_id)+')'+CHAR(10)+  
 ' ORDER BY PopulationPop_id'  
  
-- SET @strsql='SELECT DISTINCT strLithoCode, ISNULL(LTRIM(RTRIM(LEFT(AreaCode,3))),'''')+LTRIM(RTRIM(Phone)) as Phone, FName, LName, Age, Sex, Addr, City, St, Zip5, Zip4, '+CHAR(10)+  
--  ' sm.LangID, e.Pop_id'+@AdditionalFields+CHAR(10)+  
--  ' FROM s'+CONVERT(VARCHAR,@intStudy_id)+'.Population p,'+CHAR(10)+ 
--  ' SelectedSample ss, s'+CONVERT(VARCHAR,@intStudy_id)+'.Encounter e, SamplePop sp, ScheduledMailing schm, SentMailing sm '+CHAR(10)+  
--  ' WHERE ss.SampleSet_id='+CONVERT(VARCHAR,@intSampleSet_id)+CHAR(10)+  
--  ' AND ss.SampleSet_id=sp.SampleSet_id'+CHAR(10)+  
--  ' AND ss.Pop_id=sp.Pop_id'+CHAR(10)+  
--  ' AND sp.SamplePop_id=schm.SamplePop_id'+CHAR(10)+  
--  ' AND schm.SentMail_id=sm.SentMail_id'+CHAR(10)+  
--  ' AND ss.Enc_id=e.Enc_id'+CHAR(10)+  
--  ' AND e.Pop_id=p.Pop_id '+CHAR(10)+  
--  ' AND p.Pop_id NOT IN ('+CHAR(10)+  
--  '   SELECT Pop_id FROM TOCL WHERE Study_id='+CONVERT(VARCHAR,@intStudy_id)+')'+CHAR(10)+  
--  ' ORDER BY e.Pop_id'  
-- ELSE  
-- SET @strsql='SELECT DISTINCT strLithoCode, ISNULL(LTRIM(RTRIM(LEFT(AreaCode,3))),'''')+LTRIM(RTRIM(Phone)) as Phone, FName, LName, Age, Sex, Addr, City, St, Zip5, Zip4, '+CHAR(10)+  
--  ' sm.LangID, p.Pop_id FROM s' + CONVERT(VARCHAR,@intStudy_id) + '.Population p,'+CHAR(10)+  
--  ' SelectedSample ss, SamplePop sp, ScheduledMailing schm, SentMailing sm'+CHAR(10)+  
--  ' WHERE ss.SampleSet_id='+CONVERT(VARCHAR,@intSampleSet_id)+CHAR(10)+  
--  ' AND ss.SampleSet_id=sp.SampleSet_id'+CHAR(10)+  
--  ' AND ss.Pop_id=sp.Pop_id'+CHAR(10)+  
--  ' AND sp.SamplePop_id=schm.SamplePop_id'+CHAR(10)+  
--  ' AND schm.SentMail_id=sm.SentMail_id'+CHAR(10)+  
--  ' AND ss.Pop_id=p.Pop_id '+CHAR(10)+  
--  ' AND p.Pop_id NOT IN ('+CHAR(10)+  
--  '   SELECT Pop_id FROM TOCL WHERE Study_id='+CONVERT(VARCHAR,@intStudy_id)+')'+CHAR(10)+  
--  ' ORDER BY p.Pop_id'  

EXEC(@strsql)  
  
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


