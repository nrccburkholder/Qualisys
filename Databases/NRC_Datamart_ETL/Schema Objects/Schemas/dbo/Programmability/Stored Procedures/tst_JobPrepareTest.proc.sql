CREATE PROCEDURE [dbo].[tst_JobPrepareTest]
@isDeleted BIT
AS
delete ExtractHistory
	delete ExtractQueue
	delete ExtractFile

    DBCC CHECKIDENT ('ExtractFile', reseed, 0)
    DBCC CHECKIDENT ('ExtractQueue', reseed, 0)

	
	--exec tst_JobPrepareTest2 1214, @isDeleted
	exec tst_JobPrepareTest2 28, @isDeleted
	exec tst_JobPrepareTest2 30, @isDeleted

	RETURN
	
	declare @id int
	exec @id = csp_PrepareForExtract 1, 0, null -- '90' or '325'

	--exec csp_GetSUFacilityExtractData @id
	
	
	select * from ExtractFile
	select EntityTypeID, count(*) from ExtractHistory group by EntityTypeID
	select EntityTypeID, count(*) from ExtractQueue group by EntityTypeID


