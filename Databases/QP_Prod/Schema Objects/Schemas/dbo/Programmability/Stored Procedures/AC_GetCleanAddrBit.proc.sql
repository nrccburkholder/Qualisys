CREATE PROCEDURE dbo.AC_GetCleanAddrBit
    @StudyID int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the address cleaning bit
SELECT bitCleanAddr 
FROM Study 
WHERE Study_id = @StudyID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


