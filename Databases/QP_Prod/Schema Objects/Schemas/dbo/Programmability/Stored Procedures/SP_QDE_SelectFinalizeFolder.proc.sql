﻿CREATE PROCEDURE DBO.SP_QDE_SelectFinalizeFolder
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED      
SET NOCOUNT ON    

SELECT strParam_value
FROM QualPro_Params 
WHERE strParam_nm = 'ScanImportUnProcRet'


