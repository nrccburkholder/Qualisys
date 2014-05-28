CREATE PROCEDURE dbo.SV_AddressToUnit_Count
@Survey_id INT
AS
IF EXISTS (SELECT * FROM SampleUnitSection WHERE SelQstnsSurvey_id=@Survey_id AND SelQstnsSection=-1)
	SELECT 1 bitError, 'Address Section is mapped to more than one Sample Unit' strMessage
	FROM SampleUnitSection
	WHERE SelQstnsSurvey_id=@Survey_id
	AND SelQstnsSection=-1
	GROUP BY SelQstnsSection
	HAVING COUNT(SelQstnsSection)<>1
ELSE
	SELECT 1 bitError, 'Address Section is not mapped to a Sample Unit' strMessage
IF @@ROWCOUNT=0
SELECT 0 bitError, 'Address section mapped to one sample unit' strMessage


