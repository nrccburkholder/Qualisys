/*********************************************************************************************************************************        
** Copyright (c) National Research Corporation               
** Stored Procedure:  dbo.QCL_InsertPhysEmpDQRules        
** Description:  Called by Configuration Manager, this SP calls dbo.QCL_InsertCriteriaStmt,         
**  dbo.QCL_InsertBusinessRule, and dbo.QCL_InsertDefaultCriteriaClause to add the standard disqualification         
**  criteria for HH (Home Health) to a Survey.        
**        
** Modified: 10/26/2010 - Don Mayhew - Initial Release.      
** Modified 01/07/2014 - Dave Hansen - Added 'NU' to default values for CriteriaStmt for AddrErr DQ_MDAE Rule - INC0028553
**										NOTE: also added 'FO' which seemed to be mistakenly missing
**********************************************************************************************************************************/        
CREATE PROCEDURE [dbo].[QCL_InsertPhysEmpDQRules]        
 @Survey_id INT        
AS        
        
DECLARE @Study_id INT        
DECLARE @PopTable_ID INT        
DECLARE @EncTable_ID INT      
DECLARE @CriteriaStmt_id INT         
DECLARE @CriteriaClause_id INT        
DECLARE @Country_id INT
DECLARE @SurveyType_ID int
        
/*Get the Study_id for this Survey*/        
SELECT @Study_id = Study_id, @SurveyType_ID = SurveyType_ID       
FROM dbo.Survey_def        
WHERE Survey_id = @Survey_id        
IF @Study_id IS NULL        
 RETURN        
        
/*Get POPULATION's Table_id*/        
SELECT @PopTable_ID = mt.Table_id         
FROM dbo.MetaTable mt        
WHERE mt.strTable_nm = 'POPULATION'        
  AND mt.Study_id = @Study_id        
        
      
/*Get Encounter's Table_id*/        
SELECT @EncTable_ID = mt.Table_id         
FROM dbo.MetaTable mt        
WHERE mt.strTable_nm = 'ENCOUNTER'        
  AND mt.Study_id = @Study_id          
      
/*Get the Country_id from the QualPro_Params*/          
SELECT @Country_id=numParam_Value           
FROM QualPro_Params          
WHERE strParam_nm='Country'   


/*Get survey type IDs for Physician and Employee*/
select surveytype_id, surveytype_dsc into #PhysEmp from surveytype where surveytype_dsc in ('Physician', 'Employee')
        
      
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0        
        
/*Add LName Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='LNAME')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_L Nm', '(POPULATIONLName IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'LNAME', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END          
          
/*Add FName Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='FNAME')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_F Nm', '(POPULATIONFName IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'FNAME', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END   

          
 /*American Address Rules*/          
 IF @Country_id=1          
 BEGIN          
           
 /*Add ST Rule*/          
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
    AND Study_id=@Study_id          
    AND strField_nm='ST')          
  BEGIN          
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_ST', '(POPULATIONST IS NULL)', @CriteriaStmt_id OUTPUT          
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'ST', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
  END          
           
 /*Add Zip5 Rule*/          
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
    AND Study_id=@Study_id          
    AND strField_nm='ZIP5')          
  BEGIN          
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Zip5', '(POPULATIONZIP5 IS NULL)', @CriteriaStmt_id OUTPUT          
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'ZIP5', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
  END          
           
 END          
           
 /*Canadian Address Rules*/          
 IF @Country_id=2          
 BEGIN          
           
 /*Add Province Rule*/          
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
    AND Study_id=@Study_id          
    AND strField_nm='Province')          
  BEGIN          
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PROV', '(POPULATIONProvince IS NULL)', @CriteriaStmt_id OUTPUT          
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'Province', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
  END          
           
 /*Add Postal_Code Rule*/          
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
    AND Study_id=@Study_id          
    AND strField_nm='Postal_Code')          
  BEGIN          
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PstCd', '(POPULATIONZIPostal_Code IS NULL)', @CriteriaStmt_id OUTPUT          
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'Postal_Code', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
  END        
           
 END     


/*Add SEX Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='SEX')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_SEX','(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'SEX', '<>', 'M', '', @CriteriaClause_id OUTPUT          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'SEX', '<>', 'F', '', @CriteriaClause_id OUTPUT          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @PopTable_id, 'SEX', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END          


/*Add PhonStat Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='PHONSTAT')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PHONSTAT','(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'PHONSTAT', '<>', '0', '', @CriteriaClause_id OUTPUT          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'PHONSTAT', 'IS NOT', 'NULL', '', @CriteriaClause_id OUTPUT          
 END          
          
/*Add LangID Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='LangID')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_LangID','(POPULATIONLangID IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'LangID', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END          
          
/*Add Addr Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='ADDR')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Addr', '(POPULATIONADDR IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'ADDR', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END          
          
/*Add City Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='CITY')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_City', '(POPULATIONCITY IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'CITY', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END          
          

/*Add AddrErr Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='ADDRERR')          
 BEGIN          
    
  --NRC Picker surveys  
  if @SurveyType_ID = 1    
  BEGIN  
  
--** Modified 01/07/2014 - Dave Hansen - Added 'NU' to default values for CriteriaStmt for AddrErr DQ_MDAE Rule - INC0028553
--**										NOTE: also added 'FO' which seemed to be mistakenly missing
    EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_MDAE','(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))', @CriteriaStmt_id OUTPUT           
    EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
    EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'ADDRERR', 'IN', '', '', @CriteriaClause_id OUTPUT          
      
    EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'NC'    
    EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'TL'    
    EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'FO'  
--** Modified 01/07/2014 - Dave Hansen - Added 'NU' to default values for CriteriaStmt for AddrErr DQ_MDAE Rule - INC0028553
    EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'NU'  
      
  END    
END  


--Only include for Physician or Employee
if (@SurveyType_ID in (select surveytype_id from #PhysEmp))
/*Add Email Address IS NULL Rule*/          
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
   AND Study_id=@Study_id          
   AND strField_nm='email_address')          
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Email','(POPULATIONEMAIL_ADDRESS IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'Email_Address', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END    


--Only include for Physician 
if (@SurveyType_ID in (select surveytype_id from #PhysEmp where surveytype_dsc = 'Physician'))
/*Add Email Address IS NULL Rule*/          
 IF (SELECT count(*) FROM dbo.MetaData_View WHERE Table_id=@EncTable_ID           
   AND Study_id=@Study_id          
   AND strField_nm in ('drid','drnpi')) = 2
 BEGIN          
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_ID','(ENCOUNTERDrID IS NULL AND ENCOUNTERDrNPI IS NULL)', @CriteriaStmt_id OUTPUT          
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'DrID', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'DrNPI', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT          
 END       

drop table #PhysEmp


