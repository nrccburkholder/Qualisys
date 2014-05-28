CREATE PROCEDURE [dbo].[QCL_AllowDeleteClientGroup]  
    @ClientGroupID INT  
AS  
  
IF EXISTS (SELECT * FROM Client WHERE ClientGroup_ID = @ClientGroupID) OR @ClientGroupID = -1
    SELECT 0  
ELSE
    SELECT 1


