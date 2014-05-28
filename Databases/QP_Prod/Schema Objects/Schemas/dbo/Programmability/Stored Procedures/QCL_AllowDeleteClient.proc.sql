CREATE PROCEDURE QCL_AllowDeleteClient  
@ClientId INT  
AS  
  
IF EXISTS (SELECT * FROM Study WHERE Client_id=@ClientID)
SELECT 0  
ELSE
SELECT 1


