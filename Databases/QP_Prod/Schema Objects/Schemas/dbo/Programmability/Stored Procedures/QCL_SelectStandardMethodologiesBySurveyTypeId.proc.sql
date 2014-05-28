CREATE PROCEDURE QCL_SelectStandardMethodologiesBySurveyTypeId
 @SurveyTypeID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT sm.StandardMethodologyId, sm.strStandardMethodology_nm, sm.bitCustom
FROM StandardMethodology sm, StandardMethodologyBySurveyType smst
WHERE smst.SurveyType_id=@SurveyTypeID
AND smst.StandardMethodologyID=sm.StandardMethodologyID
ORDER BY sm.strStandardMethodology_nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


