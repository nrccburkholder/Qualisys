/*********************************************************************************************************************************        
** Copyright (c) National Research Corporation               
** Stored Procedure:  dbo.QCL_InsertHCAHPSDQRules        
** Description:  Called by Configuration Manager, this SP calls dbo.QCL_InsertCriteriaStmt,         
**  dbo.QCL_InsertBusinessRule, and dbo.QCL_InsertDefaultCriteriaClause to add the standard disqualification         
**  criteria for HHCAHPS (Home Health CAHPS) to a Survey.        
**        
** Modified: 10/08/2009 - Michael Beltz - Initial Release.      
** 2011.06.02  Amir Aliabadi   B-01376 remvoed the FO DQ rule   
** 2011.08.04  Don Mayhew      B-01410 Changed DQ_Payer rule
** 2014.06.26  Dave Gilsdorf   Depreciated and dropped during AllCAHPS Sprint 1
**********************************************************************************************************************************/        
/*
CREATE PROCEDURE [dbo].[QCL_InsertHHCAHPSDQRules]        
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
      
        
--IF @PopTable_ID IS NULL        
--BEGIN        
-- RAISERROR ('No Population Table defined for Survey %s', 16, 1, @Survey_id)        
-- RETURN        
--END        
      
      
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0        
        
/*Add Visited more then once, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHVisitCnt')        
BEGIN        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_VisMo', '(ENCOUNTERHHVisitCnt < 1)', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHVisitCnt', '<', '1', '', @CriteriaClause_id OUTPUT        
END        
        
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0      
      
/*Add lookback count less than 2, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHLookBackCnt')        
BEGIN        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_VisLk', '(ENCOUNTERHHLookbackCnt < 2)', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHLookBackCnt', '<', '2', '', @CriteriaClause_id OUTPUT        
END        
        
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0      
      
/*Add lookback count less than 2, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHPay_Mcare')        
and exists (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHPay_Mcaid')        
BEGIN
-- DRM B-01410
-- EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Payer', 'ENCOUNTERHHPay_Mcare <> ''1'' AND ENCOUNTERHHPay_Mcaid <> ''1''', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Payer', '(ENCOUNTERHHPay_Mcare <> ''1'' AND ENCOUNTERHHPay_Mcaid <> ''1'' AND ENCOUNTERHHPay_Ins = ''1'') OR (ENCOUNTERHHPay_Mcare <> ''1'' AND ENCOUNTERHHPay_Mcaid <> ''1'' AND ENCOUNTERHHPay_Other = ''1'')', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHPay_Mcare', '<>', '1', '', @CriteriaClause_id OUTPUT        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHPay_Mcaid', '<>', '1', '', @CriteriaClause_id OUTPUT        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHPay_Ins', '=', '1', '', @CriteriaClause_id OUTPUT        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @EncTable_ID, 'HHPay_Mcare', '<>', '1', '', @CriteriaClause_id OUTPUT        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @EncTable_ID, 'HHPay_Mcaid', '<>', '1', '', @CriteriaClause_id OUTPUT        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 2, @CriteriaStmt_id, @EncTable_ID, 'HHPay_Other', '=', '1', '', @CriteriaClause_id OUTPUT        
END        


set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0      


/*Add ENCOUNTERHHEOMAge < 18, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHEOMAge')        
BEGIN        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Age', '(ENCOUNTERHHEOMAge < 18)', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHEOMAge', '<', '18', '', @CriteriaClause_id OUTPUT        
END        
        
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0      
      
      
/*Add Hospice, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHHospice')        
BEGIN        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Hospc', '(ENCOUNTERHHHospice = ''Y'')', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHHospice', '=', 'Y', '', @CriteriaClause_id OUTPUT        
END        
        
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0      
      
/*Add HHMaternity, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHMaternity')        
BEGIN        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Mat', '(ENCOUNTERHHMaternity = ''Y'')', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHMaternity', '=', 'Y', '', @CriteriaClause_id OUTPUT        
END        
        
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0      
      
      
/*Add Deceased, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHDeceased')        
BEGIN        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_Dead', '(ENCOUNTERHHDeceased = ''Y'')', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHDeceased', '=', 'Y', '', @CriteriaClause_id OUTPUT        
END        
        
set @CriteriaStmt_id = 0      
set @CriteriaClause_id = 0      
      
      
/*Add no Publicity, Operator 1 */        
IF EXISTS (SELECT Field_id         
           FROM dbo.MetaData_View         
           WHERE Table_id = @EncTable_ID         
       AND Study_id = @Study_id        
       AND strField_nm = 'HHNoPub')        
BEGIN        
 EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_NoPub', '(ENCOUNTERHHNoPub = ''Y'')', @CriteriaStmt_id OUTPUT        
 EXEC dbo.QCL_InsertBusinessRule @Study_id, @Survey_id, @CriteriaStmt_id, 'Q'        
 EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @EncTable_ID, 'HHNoPub', '=', 'Y', '', @CriteriaClause_id OUTPUT        
END        
  
  
-- AA B-01376 --  
-- AA for HH CAHPS do not DQ due to foreign address  
/* Updated Address Error Rule. Field is AddrErr, not AddrStat  
 10/21/2010 dmp */  
  
--IF EXISTS (SELECT Field_id FROM dbo.MetaData_View WHERE Table_id=@PopTable_id           
--   AND Study_id=@Study_id     
--   AND strField_nm='AddrErr')          
--BEGIN          
--  EXEC dbo.QCL_InsertCriteriaStmt @Study_id, 'DQ_MDFA','(POPULATIONAddrErr=''FO'')', @CriteriaStmt_id OUTPUT           
--  EXEC dbo.QCL_InsertbusinessRule @study_id, @Survey_id, @CriteriaStmt_id, 'Q'          
--  EXEC dbo.QCL_InsertDefaultCriteriaClause 1, @CriteriaStmt_id, @PopTable_id, 'AddrErr', '=', 'FO', '', @CriteriaClause_id OUTPUT          
--END   
-- AA B-01376 --


*/