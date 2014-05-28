CREATE PROCEDURE sp_PCL_ApplicationErrorReset @Computer_nm VARCHAR(16)  
AS  
  
/* This procedure will use SQL to identify and reboot the PCLGen machine that are in an application error state*/  
/* Reason:   PCLGEN application in an error state can leave an open SQL transaction, thus causing blocking.*/  
/* Last Modified by:  Steve Spicka- 10/10/2007 */  
  
SET NOCOUNT ON   
  
 -- DECLARE @COMPUTER_NM VARCHAR(16)  
 -- SET @COMPUTER_NM = 'NRCPCLGEN11'  
DECLARE @cmd VARCHAR (100), @run INT, @batch_Id INT  
  
SELECT @run = rn.pclgenrun_id, @batch_id = SUBSTRING(LOGENTRY,11,CHARINDEX('-',LOGENTRY)-12)   
FROM PCLGENLOG LG, PCLGENRUN RN WHERE LG.PCLGENRUN_ID = RN.PCLGENRUN_ID   
AND logentry LIKE 'LOAD BATCH%'  
AND COMPUTER_NM = @COMPUTER_nm
AND END_DT IS NULL  
AND RN.PCLGENRUN_ID IN (  
 SELECT MAX(RN.PCLGENRUN_ID) pclgenrun_id FROM PCLGENLOG LG, PCLGENRUN RN WHERE LG.PCLGENRUN_ID = RN.PCLGENRUN_ID   
 AND logentry LIKE 'LOAD BATCH%'  
 AND COMPUTER_NM = @computer_nm
 GROUP BY computer_nm)  
  
SET @cmd = '\\NRC10\c$\restartpclgen.bat ' + @computer_nm  
PRINT @CMD  
EXEC master.dbo.XP_CMDSHELL @cmd, No_Output  
UPDATE pclneeded SET bitdone = 0 where batch_id = @batch_id  
UPDATE pclgenrun SET END_DT = START_DT WHERE pclgenrun_id = @run  
IF @run IS NOT NULL  
 INSERT INTO PCLGENLOG (pclgenrun_id, logentry, datlogged)   
 SELECT @run, @computer_nm + ' PCLGEN Application error - Restart initiated - Batch_id ' + CONVERT(VARCHAR,@batch_id) + ' reset', GETDATE()  
  
SET NOCOUNT OFF


