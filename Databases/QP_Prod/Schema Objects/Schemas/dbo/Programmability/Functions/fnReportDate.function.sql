CREATE FUNCTION fnReportDate (@SurveyID INT)
RETURNS VARCHAR(50)
AS
BEGIN

DECLARE @cd INT, @ReportDate VARCHAR(50)
SELECT @cd=strCutOffResponse_cd
FROM Survey_def
WHERE Survey_id=@SurveyID

IF @cd=0
SELECT @ReportDate='SampleCreate'

ELSE IF @cd=1
SELECT @ReportDate='ReturnDate'

ELSE 
SELECT @ReportDate=strTable_nm+strField_nm
FROM Survey_def sd, MetaTable mt, MetaField mf
WHERE sd.Survey_id=@SurveyID
AND sd.CutOffTable_id=mt.Table_id
AND sd.CutOffField_id=mf.Field_id

RETURN @ReportDate
END


