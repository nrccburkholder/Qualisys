-- =======================================================================  
-- Author:   Hui Holay  
-- Create date: 02-23-2007  
-- Description:    
-- =======================================================================  
-- Revision:  
-- =======================================================================  
CREATE PROCEDURE [dbo].[QP_Rep_ResponseRateByClientByDateTitle]
 @Associate VARCHAR(42),  
 @Client VARCHAR(42),  
 @FirstDay DATETIME,  
 @LastDay DATETIME  
AS    
BEGIN  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
 SET NOCOUNT ON;  
  
 SELECT @Client AS Client,   
  CONVERT(VARCHAR(11),@FirstDay, 109)+' to '+CONVERT(VARCHAR(11),@LastDay,109) AS 'Sample Created Date'  
END


