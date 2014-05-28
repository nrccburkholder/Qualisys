CREATE PROCEDURE [dbo].[QCL_UpdateClientGroup]
    @ClientGroupID INT,
    @ClientGroupName VARCHAR(50),
    @ClientGroupReportingName VARCHAR(100),
    @Active BIT
AS

UPDATE ClientGroups 
SET ClientGroup_nm = @ClientGroupName, 
    ClientGroupReporting_nm = @ClientGroupReportingName,
    Active = @Active 
WHERE ClientGroup_ID = @ClientGroupID


