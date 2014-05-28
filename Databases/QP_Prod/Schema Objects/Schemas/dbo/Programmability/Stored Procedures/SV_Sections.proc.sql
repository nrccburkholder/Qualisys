CREATE PROCEDURE dbo.SV_Sections
@Survey_id INT
AS
SELECT 1 bitError, 'Section ' + convert(varchar,Section_ID)+' (' + Label + ') NOT mapped to a Sample Unit' strMessage
FROM Sel_Qstns SQ
Where SQ.Survey_id=@Survey_id
AND  SQ.Subtype=3
AND  NOT EXISTS
(SELECT * FROM SampleUnitSection SUS
WHERE SUS.SelQstnsSection = SQ.Section_ID)
GROUP BY Section_ID, Label
IF @@ROWCOUNT=0
SELECT 0 bitError, 'Sections validation' strMessage


