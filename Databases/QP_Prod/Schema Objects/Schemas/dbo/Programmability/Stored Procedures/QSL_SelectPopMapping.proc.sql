﻿CREATE PROCEDURE [dbo].[QSL_SelectPopMapping]
    @DL_PopMapping_ID INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT DL_PopMapping_ID, DL_LithoCode_ID, DL_Error_ID, QstnCore, PopMappingText
FROM [dbo].DL_PopMapping
WHERE DL_PopMapping_ID = @DL_PopMapping_ID

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


