/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It inserts a record
for each unit and Removed rule that represents the count of occurences of that combination.

Created:  02/27/2006 by DC

Modified:
*/  
CREATE PROCEDURE [dbo].[QCL_InsertRemovedRulesIntoSPWDQCOUNTS] 
	@sampleset_Id int, 
	@sampleunit_id int,
	@RuleName varchar(42),
	@count int
as

IF EXISTS (SELECT 1 FROM SPWDQCounts 
			WHERE sampleset_id=@sampleset_Id 
			AND sampleunit_Id=@sampleunit_id 
			AND DQ=@RuleName)
BEGIN
	UPDATE SPWDQCounts
	SET N=N+@count
	WHERE sampleset_id=@sampleset_Id 
		AND sampleunit_Id=@sampleunit_id 
		AND DQ=@RuleName
END
ELSE 
BEGIN
	INSERT INTO SPWDQCounts (sampleset_id, sampleunit_Id, DQ, N)
	VALUES (@sampleset_Id, @sampleunit_id, @RuleName, @count)
END


