﻿CREATE PROCEDURE [dbo].[QCL_InsertMM_EmailBlast_Option]
@Value VARCHAR(42)
AS

SET NOCOUNT ON

INSERT INTO [dbo].MM_EmailBlast_Options (Value)
VALUES (@Value)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


