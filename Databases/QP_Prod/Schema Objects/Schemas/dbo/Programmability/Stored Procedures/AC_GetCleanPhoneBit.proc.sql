CREATE PROCEDURE dbo.AC_GetCleanPhoneBit
    @StudyID int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the phone cleaning bit
SELECT bitCheckPhon 
FROM Study 
WHERE Study_id = @StudyID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


