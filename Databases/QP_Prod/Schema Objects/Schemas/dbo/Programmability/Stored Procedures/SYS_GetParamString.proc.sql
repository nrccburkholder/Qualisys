CREATE PROCEDURE dbo.SYS_GetParamString
    @paramName varchar(20)

AS

SELECT strParam_value 
FROM QualPro_Params 
WHERE strParam_nm = @paramName


