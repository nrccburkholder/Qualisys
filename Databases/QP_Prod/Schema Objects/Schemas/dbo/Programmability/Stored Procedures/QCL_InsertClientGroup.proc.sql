CREATE PROCEDURE [dbo].[QCL_InsertClientGroup]
    @ClientGroupName VARCHAR(50),
    @ClientGroupReportingName VARCHAR(100),
    @Active BIT
AS

INSERT INTO ClientGroups (ClientGroup_nm, ClientGroupReporting_nm, Active, DateCreated)
VALUES(@ClientGroupName, @ClientGroupReportingName, @Active, GETDATE())

SELECT SCOPE_IDENTITY()


