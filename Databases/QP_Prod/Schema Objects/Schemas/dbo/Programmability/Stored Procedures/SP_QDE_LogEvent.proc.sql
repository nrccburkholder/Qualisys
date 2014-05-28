CREATE PROCEDURE [dbo].[SP_QDE_LogEvent]  
@strUserName VARCHAR(50),  
@strLogType  VARCHAR(50),  
@strLogText Text
AS  
  
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED        
SET NOCOUNT ON      
  
INSERT INTO QDELog (datEntered, UserName, LogType, LogText)  
SELECT GETDATE(), @strUserName, @strLogType, @strLogtext


