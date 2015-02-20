set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SV_HCAHPS]          
@Survey_id INT      
AS      
      
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
SET NOCOUNT ON      
      
--If this is not an HCAHPS Survey, end the procedure      
IF (SELECT SurveyType_id FROM Survey_def WHERE Survey_id=@Survey_id)<>2      
BEGIN      
   RETURN      
END      
      
--Need a temp table to store the messages.  We will select them at the end.           
--0=Passed,1=Error,2=Warning           
CREATE TABLE #M (Error TINYINT, strMessage VARCHAR(100))        
      
--Make sure the 6 "H" fields are a part of the study    
INSERT INTO #M (Error, strMessage)    
SELECT 1,a.strField_nm+' is not a in the data structure.'    
FROM (SELECT Field_id, strField_nm     
      FROM MetaField    
      WHERE strField_nm IN ('HServiceType','HVisitType','HAdmissionSource',    
                            'HDischargeStatus','HAdmitAge','HCatAge')) a    
      LEFT JOIN (SELECT strField_nm FROM MetaData_View m, Survey_def sd     
                 WHERE sd.Survey_id=@Survey_id     
                 AND sd.Study_id=m.Study_id
		 AND m.strTable_nm = 'ENCOUNTER') b    
ON a.strField_nm=b.strField_nm    
WHERE b.strField_nm IS NULL    
IF @@ROWCOUNT=0    
INSERT INTO #M (Error, strMessage)    
SELECT 0,'All HCHAPS fields are in the data structure'    
    
    
--Make sure skip patterns are enforced.      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'Skip Patterns are not enforced.'      
FROM Survey_def       
WHERE Survey_id=@Survey_id      
AND bitEnforceSkip=0          
IF @@ROWCOUNT=0          
INSERT INTO #M (Error, strMessage)          
SELECT 0,'Skip Patterns are enforced'        
      
--Check the ReSurvey Method      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'Resurvey Method is not set to Calendar Month.'      
FROM Survey_def      
WHERE Survey_id=@Survey_id      
AND ReSurveyMethod_id<>2      
      
--Make sure datHCAHPSReportable is populated      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'No HCAHPS Compliance date defined'      
FROM Survey_def      
WHERE Survey_id=@Survey_id      
AND datHCAHPSReportable IS NULL      
      
--Check for HouseHolding      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'Householding is not defined.'      
FROM Survey_def sd LEFT JOIN HouseHoldRule hhr      
ON sd.Survey_id=hhr.Survey_id      
WHERE sd.Survey_id=@Survey_id      
AND hhr.Survey_id IS NULL      
      
--Check to make sure Addr, Addr2, City, St, Zip5 are householding columns          
INSERT INTO #M (Error, strMessage)          
SELECT 1,strField_nm+' is not a householding column.'          
FROM (Select strField_nm, Field_id FROM MetaField WHERE strField_nm IN ('Addr','Addr2','City','ST','Zip5')) a          
  LEFT JOIN HouseHoldRule hhr          
ON a.Field_id=hhr.Field_id          
AND hhr.Survey_id=@Survey_id          
WHERE hhr.Field_id IS NULL          
          
--Make sure the Medicare number is populated.      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'Medicare number is not populated.'      
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf    
ON su.SUFacility_id=suf.SUFacility_id    
WHERE sp.Survey_id=@Survey_id    
AND sp.SamplePlan_id=su.SamplePlan_id    
AND su.bitHCAHPS=1    
AND (suf.MedicareNumber IS NULL      
OR LTRIM(RTRIM(suf.MedicareNumber))='')      
IF @@ROWCOUNT=0          
INSERT INTO #M (Error, strMessage)          
SELECT 0,'Medicare number is populated'           
      
--Make sure we have at least one HCAHPS sampleunit      
IF (SELECT COUNT(*)       
    FROM SampleUnit su, SamplePlan sp       
    WHERE sp.Survey_id=@Survey_id       
    AND sp.SamplePlan_id=su.SamplePlan_id      
    AND bitHCAHPS=1)<1      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'Survey must have at least one HCAHPS Sampleunit.'      
ELSE      
INSERT INTO #M (Error, strMessage)      
SELECT 0,'Survey has one HCAHPS Sampleunit.'      
      
--Check that FacilityState is populated for the HCAHPS units.          
INSERT INTO #M (Error, strMessage)          
SELECT 2,'SampleUnit '+strSampleUnit_nm+' does not have a state designated.'    
FROM SamplePlan sp, SampleUnit su LEFT JOIN SUFacility suf    
ON su.SUFacility_id=suf.SUFacility_id    
WHERE sp.Survey_id=@Survey_id    
AND sp.SamplePlan_id=su.SamplePlan_id    
AND su.bitHCAHPS=1    
AND suf.State IS NULL    
    
--Is AHA_id populated?      
IF EXISTS (SELECT *       
     FROM (SELECT SampleUnit_id, SUFacility_id       
     FROM SamplePlan sp, SampleUnit su       
     WHERE sp.Survey_id=@Survey_id       
     AND sp.SamplePlan_id=su.SamplePlan_id       
     AND bitHCAHPS=1) a       
     LEFT JOIN SUFacility f       
     ON a.SUFacility_id=f.SUFacility_id       
     WHERE f.AHA_id IS NULL)      
INSERT INTO #M (Error, strMessage)      
SELECT 2,'At least one HCAHPS Sampleunit does not have an AHA value.'      
      
--What is the sampling algorithm      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'Your sampling algorithm is not StaticPlus.'      
FROM Survey_def      
WHERE Survey_id=@Survey_id      
AND SamplingAlgorithmID<>3      
          
--Make sure the reporting date is either ServiceDate or DischargeDate      
IF (SELECT sampleEncounterfield_id FROM Survey_Def WHERE survey_id = @survey_id) IS NULL  
 INSERT INTO #M (Error, strMessage)      
 SELECT 1,'Sample Encounter Date Field has to be either Service or Discharge Date from the Encounter table.'      
ELSE  
  
 INSERT INTO #M (Error, strMessage)      
 SELECT 1,'Sample Encounter Date Field has to be either Service or Discharge Date from the Encounter table.'      
 FROM Survey_def sd, MetaTable mt      
 WHERE sd.sampleEncounterTable_id=mt.Table_id      
 AND  sd.Survey_id=@Survey_id      
 AND sd.sampleEncounterField_id NOT IN (54,117)      
  
IF @@ROWCOUNT=0      
INSERT INTO #M (Error, strMessage)      
SELECT 0,'Sample Encounter Date Field is set to either Service or Discharge Date.'    
      
--Make sure all of the HCAHPS questions are on the form and in the correct location.      
CREATE TABLE #CurrentForm (      
    Order_id INT IDENTITY(1,1),      
    QstnCore INT,      
    Section_id INT,       
    Subsection INT,      
    Item INT      
)      
      
--Get the questions currently on the form      
INSERT INTO #CurrentForm (QstnCore, Section_id, Subsection, Item)      
SELECT QstnCore, Section_id, Subsection, Item      
FROM Sel_Qstns      
WHERE Survey_id=@Survey_id      
AND SubType in (1,4)          
AND Language=1      
AND (Height>0 OR Height IS NULL)        
ORDER BY Section_id, Subsection, Item        
      
--Look for questions missing from the form.      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is missing from the form.'      
FROM SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t      
ON s.QstnCore=t.QstnCore      
WHERE s.SurveyType_id=2      
AND t.QstnCore IS NULL      
      
--Look for questions that are out of order.      
--First the questions that have to be at the beginning of the form.      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'QstnCore '+LTRIM(STR(s.QstnCore))+' is out of order on the form.'      
FROM SurveyTypeQuestionMappings s LEFT JOIN #CurrentForm t      
ON s.QstnCore=t.QstnCore      
AND s.intOrder=t.Order_id      
AND s.SurveyType_id=2      
WHERE bitFirstOnForm=1      
AND t.QstnCore IS NULL      
      
--Now the questions that are at the end of the form.      
SELECT IDENTITY(INT,1,1) OverAllOrder, qm.qstncore, intorder TemplateOrder, Order_id FormOrder, intOrder-Order_id OrderDiff      
INTO #OrderCheck      
from SurveyTypeQuestionMappings qm, #CurrentForm t      
WHERE qm.SurveyType_id=2      
AND bitFirstOnForm=0      
AND qm.QstnCore=t.QstnCore      
      
DECLARE @OrderDifference INT      
      
SELECT @OrderDifference=OrderDiff      
FROM #OrderCheck      
WHERE OverAllOrder=1      
      
INSERT INTO #M (Error, strMessage)      
SELECT 1,'QstnCore '+LTRIM(STR(QstnCore))+' is out of order on the form.'      
FROM #OrderCheck      
WHERE OrderDiff<>@OrderDifference      
      
DROP TABLE #OrderCheck     
  
       
IF (SELECT COUNT(*) FROM #M WHERE strMessage LIKE '%QstnCore%')=0         
BEGIN   
 INSERT INTO #M (Error, strMessage)          
 SELECT 0,'All HCAHPS Questions are on the form in the correct order.'     
  
 --IF all 27 cores or on the survey, then check that the 27 questions are mapped   
 --in a manner that ensures someone sampled at the HCAHP units will get all of them  
 SELECT sampleunit_id  
 into #HCAHPSUnits       
 FROM SampleUnit su, SamplePlan sp       
 WHERE sp.Survey_id=@Survey_id       
 AND sp.SamplePlan_id=su.SamplePlan_id      
 AND bitHCAHPS=1  
  
 DECLARE @sampleunit_id int  
  
 SELECT TOP 1 @sampleunit_id=sampleunit_id  
 FROM #HCAHPSUnits  
  
 WHILE @@rowcount>0  
 BEGIN  
  
  INSERT INTO #M (Error, strMessage)      
  SELECT 1,'QstnCore '+LTRIM(STR(stqm.QSTNCORE))+' is not mapped to Sampleunit ' + convert(varchar,@sampleunit_id) +' or one of its ancestor units.'      
  FROM ( SELECT sq.Qstncore  
    FROM SAMPLEUNITTREEINDEX si JOIN sampleunitsection su  
     ON si.sampleunit_id=@sampleunit_id  
      AND si.ancestorunit_id=su.sampleunit_id  
     JOIN sel_qstns sq  
     ON sq.Survey_id=@Survey_id      
      AND SubType in (1,4)          
      AND Language=1      
      AND (Height>0 OR Height IS NULL)   
      AND su.selqstnssection=sq.section_id  
      AND sq.survey_id=su.selqstnssurvey_id  
   union  
    SELECT sq.Qstncore  
    FROM sampleunitsection su JOIN sel_qstns sq  
     ON su.sampleunit_id=@sampleunit_id  
      AND sq.Survey_id=@Survey_id      
      AND SubType in (1,4)          
      AND Language=1      
      AND (Height>0 OR Height IS NULL)   
      AND su.selqstnssection=sq.section_id  
      AND sq.survey_id=su.selqstnssurvey_id) Q  
   RIGHT JOIN SurveyTypeQuestionMappings stqm  
   ON Q.QstnCore=stqm.QstnCore   
  WHERE stqm.SurveyType_id=2      
     AND Q.QstnCore IS NULL   
  
  IF @@ROWCOUNT=0         
   INSERT INTO #M (Error, strMessage)          
   SELECT 0,'All HCAHPS Questions are mapped properly for Samplunit ' + convert(varchar,@sampleunit_id)     
  
  DELETE  
  FROM #HCAHPSUnits  
  WHERE sampleunit_Id=@sampleunit_id  
  
  SELECT TOP 1 @sampleunit_id=sampleunit_id  
  FROM #HCAHPSUnits  
 END  
END  
       
--End of Question checking      
     
--Now to check the active methodology      
CREATE TABLE #ActiveMethodology (standardmethodologyid INT)    
    
INSERT INTO #ActiveMethodology    
SELECT standardmethodologyid    
FROM MailingMethodology (NOLOCK)          
WHERE Survey_id=@Survey_id          
AND bitActiveMethodology=1       
    
IF @@ROWCOUNT<>1      
 INSERT INTO #M (Error, strMessage)      
 SELECT 1,'There must be exactly 1 active methodology.'    
ELSE    
BEGIN    
 IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid in (1,2,3,4))    
  INSERT INTO #M (Error, strMessage)      
  SELECT 0,'Survey uses a standard HCAHPS methodology.'    
 ELSE IF EXISTS(SELECT * FROM #ActiveMethodology WHERE standardmethodologyid =5)    
  INSERT INTO #M (Error, strMessage)      
  SELECT 2,'Survey uses a custom methodology.'    
 ELSE    
  INSERT INTO #M (Error, strMessage)      
  SELECT 1,'Survey does not use a standard HCAHPS methodology.'    
END     
    
DROP TABLE #ActiveMethodology          
      
SELECT * FROM #M      
      
DROP TABLE #M      
      
SET NOCOUNT OFF      
SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
   


