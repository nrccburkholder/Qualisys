/*
Business Purpose: 
This procedure is used to support the Qualisys Class Library.  It inserts a record
for each unit and DQ that represents the count of occurences of that combination.

Created:  02/27/2006 by DC

Modified:
*/  
CREATE PROCEDURE [dbo].[QCL_InsertDQRuleIntoSPWDQCOUNTS] 
	@sampleset_Id int, 
	@sampleunit_id int,
	@DQRuleId int,
	@count int
as
DECLARE @DQName as varchar(8)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON


SELECT @DQName=strCriteriaStmt_nm
  FROM CriteriaStmt
  WHERE CriteriaStmt_id=@DQRuleId

INSERT INTO SPWDQCounts (sampleset_id, sampleunit_Id, DQ, N)
VALUES (@sampleset_Id, @sampleunit_id, @DQName, @count)

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


