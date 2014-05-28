/*********************************************************************************************************************************        
  ** Copyright (c) National Research Corporation               
  ** Stored Procedure:  dbo.QCL_InsertDefaultDQRules        
  ** Description:  Called by ConfigManagerUI.vbp, this SP calls dbo.QCL_InsertCriteriaStmt,         
  **  dbo.QCL_InsertBusinessRule, and dbo.QCL_InsertDefaultCriteriaClause to add the standard disqualification         
  **  criteria to a Survey.        
  **        
  ** Modified: 9/7/1999 - Daniel Vansteenburg - Added check to make sure the Field exists         
  **  before adding DQ rule.        
  ** Modified: 4/23/2001 - Brian Dohmen - Added null langid DQ rule.        
  **    Modified: 9/09/2002 - Ron Niewohner - Added null MRN DQ rule.        
  **    Modified: 7/14/2003 - Brian Dohmen - Added additional address DQ rules        
  **    Modified: 5/06/2004 - Dan Christensen - Added strcriteriastring         
  **    Modified: 6/03/2005 - Brian Dohmen - Added Address Error 420 rule        
  **    Modified: 9/14/2005 - Brian Dohmen - Added Province and Postal_Code errors for Canada        
  **    Modified: 7/31/2007 - Steve Spicka - Added Addl. DQ Rules (E505, E601)      
  ** Modified: 1/13/2010 - Michael Beltz - modified CriteriaStmt code to change (( to ( and )) to ) b/c it was not     
  **       consistant with how where clasue generation box was creating sql statment    
  ** Modified: 1/19/2010 - Michael Beltz - Added new DQ_QASAE and DQ_QASFA rules   
  **       and removed old DQ_AE420 and DQ_AddEr rules  
  ** Modified: 8/10/2010 - Michael Beltz - Added new DQ_MDAE rule for MelissaData address cleaning errors
  ** Modified 10/21/2010 - Dana Petersen - Modified foreign address rule to use AddrErr instead of addrstat
  ** Modified 07/18/2013 - Dave Hansen - changed hardcoded QCL_InsertCriteriaStmt parameter from POPULATIONZIPostal_Code IS NULL to POPULATIONPostal_Code IS NULL
  ** Modified 09/11/2013 - Dave Hansen - changed default AddrErr DQ, adding new NRC Canada survey type ID (=7) so that it receives the same AddrErr DQ as the NRC Picker survery type ID (=1)
  **									and changed Sex DQ to only insert Sex <> "M" and <> "F" for US only
  ** Modified 10/10/2013 - Don Mayhew - Added 'FO' to default values for CriteriaStmt for AddrErr Rule, Operator 7 - INC0021806
  ** Modified 01/07/2014 - Dave Hansen - Added 'NU' to default values for CriteriaStmt for AddrErr DQ_MDAE Rule - INC0028553
**********************************************************************************************************************************/        
CREATE PROCEDURE [dbo].[QCL_InsertDefaultDQRules]        
 @Survey_id INT        
AS        
 DECLARE @Study_id INT        
 DECLARE @Table_id INT        
 DECLARE @Country_id INT        
 DECLARE @CriteriaStmt_id INT         
 DECLARE @CriteriaClause_id INT        
 DECLARE @Owner VARCHAR(32)    
 DECLARE @SurveyType_ID int       
        
/*Get the Study_id for this Survey*/        
 SELECT @Study_id=Study_id        
 FROM dbo.Survey_def        
 WHERE Survey_id=@Survey_id        
 IF @Study_id IS NULL        
  RETURN        
              
 SELECT @SurveyType_ID = surveytype_id from SURVEY_DEF where SURVEY_ID = @Survey_id  
        
/*Get the Country_id from the QualPro_Params*/        
 SELECT @Country_id=numParam_Value         
 FROM QualPro_Params        
 WHERE strParam_nm='Country'        
        
/*Get POPULATION's Table_id*/        
 SELECT @Table_id=mt.Table_id         
 FROM dbo.MetaTable mt        
 WHERE mt.strTable_nm='POPULATION'        
 AND mt.Study_id=@Study_id        
 IF @Table_id IS NULL        
 BEGIN        
  RAISERROR ('No Population Table defined for Survey %s', 16, 1, @Survey_id)        
  RETURN        
 END        
        
/*Add LName Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='LNAME')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_L Nm', '(POPULATIONLName IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'LNAME', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        
        
/*Add FName Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='FNAME')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_F Nm', '(POPULATIONFName IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'FNAME', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        
        
/*Add Addr Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='ADDR')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Addr', '(POPULATIONADDR IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ADDR', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        
        
/*Add City Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='CITY')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_City', '(POPULATIONCITY IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'CITY', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        
        
 /*American Address Rules*/        
 IF @Country_id=1        
 BEGIN        
         
 /*Add ST Rule, Operator 9 */        
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
    AND Study_id=@Study_id        
    AND strField_nm='ST')        
  BEGIN        
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_ST', '(POPULATIONST IS NULL)', @CriteriaStmt_id OUTPUT        
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ST', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
  END        
         
 /*Add Zip5 Rule, Operator 9 */        
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
    AND Study_id=@Study_id        
    AND strField_nm='ZIP5')        
  BEGIN        
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Zip5', '(POPULATIONZIP5 IS NULL)', @CriteriaStmt_id OUTPUT        
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ZIP5', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
  END        
         
 END        
         
 /*Canadian Address Rules*/        
 IF @Country_id=2        
 BEGIN        
         
 /*Add Province Rule, Operator 9 */        
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
    AND Study_id=@Study_id        
    AND strField_nm='Province')        
  BEGIN        
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PROV', '(POPULATIONProvince IS NULL)', @CriteriaStmt_id OUTPUT        
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'Province', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
  END        
         
 /*Add Postal_Code Rule, Operator 9 */        
  IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
    AND Study_id=@Study_id        
    AND strField_nm='Postal_Code')        
  BEGIN        
   --EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PstCd', '(POPULATIONZIPostal_Code IS NULL)', @CriteriaStmt_id OUTPUT        
   EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PstCd', '(POPULATIONPostal_Code IS NULL)', @CriteriaStmt_id OUTPUT        
   EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
   EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'Postal_Code', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
  END        
         
 END        
        
/*Add DOB Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='DOB')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_DOB', '(POPULATIONDOB IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'DOB', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        
        
/*Add AGE Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='AGE')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_AGE', '(POPULATIONAge IS NULL) OR (POPULATIONAGE < 0)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'AGE', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @Table_id, 'AGE', '<', '0', '', @CriteriaClause_id OUTPUT        
 END        
        
/*Add SEX Rule, Operator 2 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='SEX')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_SEX','(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q' 
--** Modified 09/11/2013 - Dave Hansen - changed Sex DQ to only insert Sex <> "M" and <> "F" for US only
  IF @Country_id = 1
	BEGIN       
	  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'SEX', '<>', 'M', '', @CriteriaClause_id OUTPUT        
	  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'SEX', '<>', 'F', '', @CriteriaClause_id OUTPUT        
	END
  EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @Table_id, 'SEX', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        


/*Add AddrErr Rule, Operator 7 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='ADDRERR')        
 BEGIN        
	 
--** Modified 09/11/2013 - Dave Hansen - changed default AddrErr DQ, adding new NRC Canada survey type ID (=7) so that it receives the same AddrErr DQ as the NRC Picker survery type ID (=1)
	 --NRC Picker surveys or NRC Canada surveys
	 if @SurveyType_ID = 1 or @SurveyType_ID = 7
	 BEGIN

--** Modified 01/07/2014 - Dave Hansen - Added 'NU' to default values for CriteriaStmt for AddrErr DQ_MDAE Rule - INC0028553
		  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_MDAE','(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))', @CriteriaStmt_id OUTPUT         
		  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
		  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ADDRERR', 'IN', '', '', @CriteriaClause_id OUTPUT        
		  
		  EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'NC'  
		  EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'TL'  
		  EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'FO'
--** Modified 01/07/2014 - Dave Hansen - Added 'NU' to default values for CriteriaStmt for AddrErr DQ_MDAE Rule - INC0028553
  		  EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, 'NU'
		  
	 END  
END

-- HCAHPS or HH CAHPS
/* Updated Address Error Rule. Field is AddrErr, not AddrStat
	10/21/2010 dmp */
if @SurveyType_ID = 2 or @SurveyType_ID = 3  
BEGIN
	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
	   AND Study_id=@Study_id        
	   AND strField_nm='ADDRERR')        
	BEGIN        
	  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_MDFA','(ADDRERR="FO")', @CriteriaStmt_id OUTPUT         
	  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
	  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ADDRERR', '=', 'FO', '', @CriteriaClause_id OUTPUT        
	END 
END


        
/*Add PhonStat Rule, Operator 2 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='PHONSTAT')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_PHONSTAT','(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'PHONSTAT', '<>', '0', '', @CriteriaClause_id OUTPUT        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'PHONSTAT', 'IS NOT', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        
        
/*Add LangID Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='LangID')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_LangID','(POPULATIONLangID IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'LangID', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END        
        
/*Add MRN IS NULL Rule, Operator 9 */        
 IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@Table_id         
   AND Study_id=@Study_id        
   AND strField_nm='MRN')        
 BEGIN        
  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_MRN','(POPULATIONMRN IS NULL)', @CriteriaStmt_id OUTPUT        
  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @Table_id, 'MRN', 'IS', 'NULL', '', @CriteriaClause_id OUTPUT        
 END


