-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure gets the registration points string
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFGetRegString] 
    @SentMailID int 
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Build the select statement
SELECT intSheet_Num, strRegPoints 
FROM si_RegistrationPoints_view 
WHERE SentMail_ID = @SentMailID
ORDER BY intSheet_Num

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


