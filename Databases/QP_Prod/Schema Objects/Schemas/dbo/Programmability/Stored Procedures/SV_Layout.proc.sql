CREATE PROCEDURE dbo.SV_Layout
@Survey_id INT
AS

SELECT 1 bitError, 'Form Layout has NOT been validated' strMessage
FROM Survey_def SV 
WHERE SV.Survey_id=@Survey_id
AND SV.bitLayoutValid=0
IF @@ROWCOUNT=0
SELECT 0 bitError, 'Form Layout HAS been validated' strMessage


