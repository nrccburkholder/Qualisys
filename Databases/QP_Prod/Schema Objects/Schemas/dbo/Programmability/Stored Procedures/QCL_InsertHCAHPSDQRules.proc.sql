/*********************************************************************************************************************************      
** Copyright (c) National Research Corporation             
** Stored Procedure:  dbo.QCL_InsertHCAHPSDQRules      
** Description:  Called by Configuration Manager, this SP calls dbo.QCL_InsertCriteriaStmt,       
**  dbo.QCL_InsertBusinessRule, and dbo.QCL_InsertDefaultCriteriaClause to add the standard disqualification       
**  criteria for HCAHPS to a Survey.      
**      
** Modified: 11/16/2006 - Jeffrey J. Fleming - Initial Release.      
** 5/20/2011 - Amir Aliabadi - HCAHPS 2011 changes added the HDischargeStatus and DischargeDate (B-01313)
**********************************************************************************************************************************/      
CREATE PROCEDURE [dbo].[QCL_InsertHCAHPSDQRules]      
 @Survey_id INT      
AS      
      
DECLARE @Study_id INT      
DECLARE @PopTable_ID INT      
DECLARE @EncTable_ID INT    
DECLARE @CriteriaStmt_id INT       
DECLARE @CriteriaClause_id INT      
      
/*Get the Study_id for this Survey*/      
SELECT @Study_id = Study_id      
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
      
IF @PopTable_ID IS NULL      
BEGIN      
 RAISERROR ('No Population Table defined for Survey %s', 16, 1, @Survey_id)      
 RETURN      
END      
      
/*Add AddrErr Rule, Operator 1 */      
IF EXISTS (SELECT Field_id       
           FROM dbo.MetaData_View       
           WHERE Table_id = @PopTable_ID       
       AND Study_id = @Study_id      
       AND strField_nm = 'ADDRERR')      
BEGIN      
	EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_AE501', '((POPULATIONAddrErr = "E501"))', @CriteriaStmt_id OUTPUT      
	EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'      
	EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_ID, 'ADDRERR', '=', 'E501', '', @CriteriaClause_id OUTPUT      
END      
      
set @CriteriaStmt_id = 0    
set @CriteriaClause_id = 0    
    
/*Add Don't Survey Dead people Rule, Operator 1 */      
IF EXISTS (SELECT Field_id       
           FROM dbo.MetaData_View       
           WHERE Table_id = @EncTable_ID       
       AND Study_id = @Study_id      
       AND strField_nm = 'HDischargeStatus')      
BEGIN      
	EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Dead', '(ENCOUNTERHDischargeStatus IN (''20'',''41''))', @CriteriaStmt_id OUTPUT      
	EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'      
	EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HDischargeStatus', 'IN', '', '', @CriteriaClause_id OUTPUT      
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '20'    
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '41'    
END       
      
set @CriteriaStmt_id = 0    
set @CriteriaClause_id = 0    
    
/*Add Don't survey Hospise People, Operator 1 */      
IF EXISTS (SELECT Field_id       
           FROM dbo.MetaData_View       
           WHERE Table_id = @EncTable_ID       
       AND Study_id = @Study_id      
       AND strField_nm = 'HDischargeStatus')      
BEGIN      
	EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Hospc', '(ENCOUNTERHDischargeStatus IN (''50'',''51''))', @CriteriaStmt_id OUTPUT      
	EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'      
	EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HDischargeStatus', 'IN', '', '', @CriteriaClause_id OUTPUT      
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '50'    
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '51'    
END         
    
set @CriteriaStmt_id = 0    
set @CriteriaClause_id = 0    
    
/*Add Don't survey people coming from or going to jail */      
IF EXISTS (SELECT Field_id       
           FROM dbo.MetaData_View       
           WHERE Table_id = @EncTable_ID       
	AND Study_id = @Study_id      
	AND strField_nm = 'HADmissionSource')      
AND EXISTS (SELECT Field_id       
           FROM dbo.MetaData_View       
           WHERE Table_id = @EncTable_ID       
	AND Study_id = @Study_id      
	AND strField_nm = 'HDischargeStatus')    
BEGIN      
	EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Law', '(ENCOUNTERHAdmissionSource = ''8'' OR ENCOUNTERHDischargeStatus = ''21'')', @CriteriaStmt_id OUTPUT      
	EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'      
	EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HAdmissionSource', '=', '8', '', @CriteriaClause_id OUTPUT      
	EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @EncTable_ID, 'HDischargeStatus', '=', '21', '', @CriteriaClause_id OUTPUT      


	--/* Updated Address Error Rule. Field is AddrErr, not AddrStat
	--	10/21/2010 dmp */

	IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id         
	   AND Study_id=@Study_id        
	   AND strField_nm='AddrErr')        
	BEGIN        
	  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_MDFA','(POPULATIONAddrErr=''FO'')', @CriteriaStmt_id OUTPUT         
	  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
	  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'AddrErr', '=', 'FO', '', @CriteriaClause_id OUTPUT        
	END 

END 

-- B-01313 ---------
set @CriteriaStmt_id = 0    
set @CriteriaClause_id = 0    

IF EXISTS ( 
	(SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@EncTable_ID         
	AND Study_id=@Study_id        
	AND strField_nm='HDischargeStatus') ) 
AND	EXISTS ( 
	(SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@EncTable_ID         
	AND Study_id=@Study_id        
	AND strField_nm='DischargeDate') ) 
BEGIN        

	EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_SNF','(ENCOUNTERHDischargeStatus IN (''3'',''03'',''61'',''64'')) AND (ENCOUNTERDischargeDate >= ''2011-07-01'')', @CriteriaStmt_id OUTPUT         
	EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'        

	EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HDischargeStatus', 'IN', '', '', @CriteriaClause_id OUTPUT        
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '3'  
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '03'  
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '61'  
	EXEC dbo.QCL_InsertCriteriaInValue @CriteriaClause_id, '64'
	  
	EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'DischargeDate', '>=', '2011-07-01', '', @CriteriaClause_id OUTPUT
		  
END
-- B-01313 ---------


