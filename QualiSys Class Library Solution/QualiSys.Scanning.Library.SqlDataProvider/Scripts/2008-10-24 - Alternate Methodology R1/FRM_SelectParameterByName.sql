---------------------------------------------------------------------------------------
--FRM_SelectParameterByName
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[FRM_SelectParameterByName]') IS NOT NULL 
	DROP PROCEDURE [dbo].[FRM_SelectParameterByName]
GO
CREATE PROCEDURE [dbo].[FRM_SelectParameterByName]
    @strParam_Nm varchar(20)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT Param_ID, strParam_Nm, strParam_Type, strParam_Grp, strParam_Value, numParam_Value, datParam_Value, Comments
FROM [dbo].QualPro_Params
WHERE strParam_Nm = @strParam_Nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
