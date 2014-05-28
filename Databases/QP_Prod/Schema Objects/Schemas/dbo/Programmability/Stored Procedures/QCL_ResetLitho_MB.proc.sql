-- =====================================================================          
-- Author:  Michael Beltz        
-- Create date: 04/10/2009          
--This proc copies proc def below except it calls DCL_ResetLitho_MB      
--which does not update the HDisposition field.  This was done b/c      
--we didn't want to change the manual update process when rolling back      
--a large amount of phone surveys that had already had there manual      
--hDispostion set.  This is a one-off Hack that should not be used under      
--normal situations.      
      
-- Name: QCL_ResetLitho      
-- Author:  Steve Spicka          
-- Create date: 09/19/2006          
-- Description: This procedure resets all scanning related data for the          
--              specified litho codes from the QualiSys database and          
--              also from the datamart if it has been moved there          
--              already.  When finished the database looks like the           
--              surveys were never returned.          
--        
-- MODIFIED: MB 3/4/09        
--  Added update to DL_LithoCode table to reset bitSubmitted field        
--  Records cannot be reloaded via Qualisys Scanner Interface         
--  with flag set        
-- =====================================================================          
CREATE PROCEDURE [dbo].[QCL_ResetLitho_MB]           
 @strNTLogin_nm VARCHAR(50),           
 @strWorkstation VARCHAR(50),           
 @Litho VARCHAR(7000),           
 @bitNonDel BIT = 0          
AS          
          
-- Testing variables          
-- DECLARE @strNTLogin_nm VARCHAR(50), @strWorkstation VARCHAR(50), @Litho VARCHAR(905)          
-- SET @strNTLogin_nm = 'sspicka'           
-- set @strWorkstation  = 'wssspicka'          
--  set @Litho = '10015797,10007294,10007295,10007296,10007297'          
--  QCL_ResetLitho 'mbeltz', 'wsmbeltz', '87290375,87290499,87290539,87290557,86940043,86940179,87150712,87150721,87150785,87150778,86940175,87290527,87290555'        
      
print 'Entering QCL_ResetLitho_MB'       
          
-- Declare needed variables          
DECLARE @InLitho VARCHAR(7800), @SQL VARCHAR(8000), @SERVER VARCHAR(50), @NonDel_dt DATETIME, @TimeStamp DATETIME          
          
SET @TimeStamp = GETDATE()          
          
IF @bitNonDel = 1          
 SET @NonDel_dt = @TimeStamp           
          
-- Get the Qualysis server           
print 'Get the Qualysis server'        
SELECT @Server=strParam_Value FROM QualPro_Params WHERE strParam_nm='DataMart'              
          
-- Create needed temporary table          
CREATE TABLE #Lithos (strlithocode VARCHAR(10), questionform_id INT, sentmail_id INT, datUndeliverable DATETIME, datReturned DATETIME, datResultsImported DATETIME, datUnusedReturn DATETIME, UnusedReturn_id INT,           
  strSTRBatchNumber VARCHAR(40), intSTRLineNumber INT, strNTLogin_nm VARCHAR(50), strWorkstation VARCHAR(50), datReset DATETIME)          

print '#lithos Table created'
          
-- Pad the litho list with quotes           
print 'Pad the litho list with quotes'        
SELECT @InLitho = '''' + REPLACE(@litho,',',''',''') + ''''          
          
SET @SQL = 'INSERT INTO #Lithos (strlithocode, questionform_id, sentmail_id, datUndeliverable, datReturned, datResultsImported, datUnusedReturn, UnusedReturn_id, ' + CHAR(10)           
 + ' strSTRBatchNumber, intSTRLineNumber, strNTLogin_nm, strWorkstation, datReset) ' + CHAR(10)           
 + ' SELECT sm.strlithocode, qf.questionform_id, qf.sentmail_id, sm.datUndeliverable, qf.datReturned, qf.datResultsImported, qf.datUnusedReturn, qf.UnusedReturn_id, qf.strSTRBatchNumber, ' + CHAR(10)          
 + ' qf.intSTRLineNumber, ''' + @strNTLogin_NM + ''' AS strNTLogin_nm, ''' + @strWorkstation + ''' AS strWorkstation, ''' + CONVERT(VARCHAR,@TimeStamp,109) + ''' AS datReset' + CHAR(10)           
 + ' FROM QUESTIONFORM QF INNER JOIN SENTMAILING SM ON qf.sentmail_id = sm.sentmail_id ' + CHAR(10)           
 + ' WHERE sm.strLithocode IN (' + @InLitho + ')'          
          
PRINT @SQL          
EXEC (@SQL)          
          
-- Log the lithos being reset          
--------------------------------------------------------------------------------------------          
print 'Log the lithos being reset'        
INSERT INTO ScanningResets (strlithocode, datUndeliverable, datReturned, datResultsImported, datUnusedReturn, UnusedReturn_id, strSTRBatchNumber, intSTRLineNumber, strNTLogin_nm, strWorkstation, datReset)           
 SELECT strlithocode, datUndeliverable, datReturned, datResultsImported, datUnusedReturn, UnusedReturn_id, strSTRBatchNumber, intSTRLineNumber, strNTLogin_nm, strWorkstation, datReset           
 FROM #Lithos          
          
-- Clear Out DataMart          
print 'Clear Out DataMart'        
--------------------------------------------------------------------------------------------          
-- Find the lithos that are being reset after being extracted to the datamart          
SELECT strLithocode INTO #dmlithos FROM #Lithos WHERE CONVERT(VARCHAR,datResultsImported,101) <> CONVERT(VARCHAR,datReset,101)          
          
IF @@ROWCOUNT > 0          
BEGIN          
          
 SET @SQL = 'DECLARE @DMLitho VARCHAR(1500) ' + CHAR(10) +          
     ' SET @DMLitho = '''' ' + CHAR(10) +           
     ' SELECT @DMLitho = @DMLItho + '','' + strLithocode FROM #DMLithos ' + CHAR(10) +          
     ' SELECT @DMLitho = SUBSTRING(@DMLitho,2,6000) ' + CHAR(10) +          
     ' EXEC ' +  @Server + '.QP_Comments.dbo.DCL_ResetLitho_MB @DMLitho'          
          
 --PRINT @SQL          
 --EXEC (@SQL)          
END          
DROP TABLE #dmlithos          
          
-- Clear Out Qualysis          
print 'Clear Out Qualysis'        
--------------------------------------------------------------------------------------------          
 --Update the questionform table          
 UPDATE qf          
 SET datReturned = null, UnusedReturn_id = null, datUnusedReturn = null,           
  datResultsImported = null, strSTRBatchNumber = null,           
  intSTRLineNumber = null, bitComplete = null, ReceiptType_id = null          
 FROM QuestionForm qf, #Lithos lt          
 WHERE qf.QuestionForm_id = lt.QuestionForm_id          
--------------------------------------------------------------------------------------------           
        
--Update the DL_LithoCode table so that records can be reloaded if needed        
print 'Update the DL_LithoCode table so that records can be reloaded if needed'        
UPDATE dl        
SET  bitIgnore = 0, BitSubmitted = 0, bitExtracted = 0, bitSkipDuplicate = 0         
FROM DL_LithoCodes dl, #Lithos lt        
WHERE dl.strLithoCode = lt.StrLithoCode        
        
--------------------------------------------------------------------------------------------           
        
 --Update the Sentmailing datUndeliverable          
print 'Update the Sentmailing datUndeliverable'          
 UPDATE sm           
 SET sm.datUndeliverable = @NonDel_dt           
 FROM SentMailing sm, #Lithos l           
 WHERE sm.SentMail_id = l.SentMail_id          
--------------------------------------------------------------------------------------------           
 --Update the QuestionResult table          
print 'Update the QuestionResult table'        
 DELETE qr          
 FROM QuestionResult qr, #Lithos lt          
 WHERE qr.QuestionForm_id = lt.QuestionForm_id          
--------------------------------------------------------------------------------------------           
 --Update the QuestionResult2 table          
print 'Update the QuestionResult2 table'        
 DELETE qr          
 FROM QuestionResult2 qr, #Lithos lt          
 WHERE qr.QuestionForm_id = lt.QuestionForm_id          
--------------------------------------------------------------------------------------------           
 --Update the DispositionLog table         
print 'Update the DispositionLog table'         
 DELETE d           
 FROM dispositionlog d, #Lithos lt          
 WHERE d.sentmail_id = lt.sentmail_id          
--------------------------------------------------------------------------------------------           
 --Update the CommentSelCodes table          
print 'Update the CommentSelCodes table'        
 DELETE cs          
 FROM CommentSelCodes cs, Comments cm, #Lithos lt          
 WHERE cs.Cmnt_id = cm.Cmnt_id          
   AND cm.QuestionForm_id = lt.QuestionForm_id          
--------------------------------------------------------------------------------------------           
 --Update the Comments table          
print 'Update the Comments table'        
 DELETE cm          
 FROM Comments cm, #Lithos lt          
 WHERE cm.QuestionForm_id = lt.QuestionForm_id          
--------------------------------------------------------------------------------------------           
 --Drop the temp tables          
print 'Drop the temp tables'        
 DROP TABLE #Lithos          
--------------------------------------------------------------------------------------------


