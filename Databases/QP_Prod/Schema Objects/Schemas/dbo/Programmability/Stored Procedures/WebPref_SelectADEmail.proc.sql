CREATE PROCEDURE WebPref_SelectADEmail @Litho VARCHAR(20) 
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

SELECT strEmail
FROM Employee e, Study s, Survey_def sd, MailingMethodology mm, SentMailing sm
WHERE sm.strLithoCode=@Litho
AND sm.Methodology_id=mm.Methodology_id
AND mm.Survey_id=sd.Survey_id
AND sd.Study_id=s.Study_id
AND s.ADEmployee_id=e.Employee_id

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


