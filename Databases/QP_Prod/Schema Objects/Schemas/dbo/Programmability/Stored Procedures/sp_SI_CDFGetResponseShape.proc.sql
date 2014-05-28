-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the response shape
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetResponseShape] 
    @SentMailID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT intResponseShape 
FROM SentMailing 
WHERE SentMail_id = @SentMailID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


