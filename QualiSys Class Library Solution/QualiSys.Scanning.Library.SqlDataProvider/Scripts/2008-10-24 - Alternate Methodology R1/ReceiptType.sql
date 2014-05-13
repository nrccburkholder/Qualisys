---------------------------------------------------------------------------------------
--QCL_SelectAllReceiptTypes
---------------------------------------------------------------------------------------
IF OBJECT_ID(N'[dbo].[QCL_SelectAllReceiptTypes]') IS NOT NULL 
	DROP PROCEDURE [dbo].[QCL_SelectAllReceiptTypes]
GO
CREATE PROCEDURE [dbo].[QCL_SelectAllReceiptTypes]
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT ReceiptType_id, ReceiptType_nm, ReceiptType_dsc, bitUIDisplay, TranslationCode
FROM [dbo].ReceiptType
ORDER BY ReceiptType_nm

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
GO
