CREATE PROCEDURE SYS_GetCountryParam
AS

SELECT numParam_value, strParam_value 
FROM QualPro_Params 
WHERE strParam_nm = 'Country'


