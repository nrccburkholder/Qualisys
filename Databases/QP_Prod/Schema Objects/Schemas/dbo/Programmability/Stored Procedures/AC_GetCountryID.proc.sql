CREATE PROCEDURE dbo.AC_GetCountryID
    @StudyID int

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Get the country id
SELECT Country_id 
FROM Study 
WHERE Study_id = @StudyID
  AND Country_id IS NOT NULL

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


