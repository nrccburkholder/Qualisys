USE [QP_Comments]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[DCL_ExportCreateFile]
		@ExportSets = N'1329',
		@ReturnsOnly = 1,
		@DirectsOnly = 0,
		@ExportFileGUID = 'd04da6b7-4f45-47ef-bc80-832cba556aba',
		@IncludeDispositionRecords = 0,
		@SaveData = 1,
		@ReturnData = 1,
		@indebug = 1

SELECT	'Return Value' = @return_value

GO
