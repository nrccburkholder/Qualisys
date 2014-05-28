CREATE PROCEDURE [dbo].[FRM_SelectAllParameters]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Param_ID, strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, numParam_Value, datParam_Value, Comments
FROM [dbo].QualPro_Params

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


