CREATE PROCEDURE sp_BDUS_GetMetaFieldInfo
    @intSurveyID int

AS

SELECT mf.strField_Nm, mf.strFieldDataType, mf.intFieldLength, bd.strValidValues, bd.bitRequired
FROM BDUS_MetaFieldLookup bd, MetaField mf
WHERE bd.Field_id = mf.Field_id
  AND bd.Survey_id = @intSurveyID
ORDER BY bd.intOrder DESC


