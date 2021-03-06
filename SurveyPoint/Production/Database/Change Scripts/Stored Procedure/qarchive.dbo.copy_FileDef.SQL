/****** Object:  StoredProcedure [dbo].[copy_FileDef]    Script Date: 08/09/2006 13:33:11 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[copy_FileDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[copy_FileDef]
GO
/****** Object:  StoredProcedure [dbo].[copy_FileDef]    Script Date: 08/09/2006 13:33:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[copy_FileDef]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.copy_FileDef
(
	@FileDefID int
)
 AS
BEGIN

-- use to store new id
DECLARE @NewFileDefID int

-- copy file def row
INSERT INTO FileDefs(FileDefName, FileDefDescription, ClientID, SurveyID, FileDefTypeID, FileTypeID, FileDefDelimiter)
SELECT FileDefName, FileDefDescription, ClientID, SurveyID, FileDefTypeID, FileTypeID, FileDefDelimiter
FROM FileDefs 
WHERE FileDefID = @FileDefID

-- get id of copied file def row
SET @NewFileDefID = @@IDENTITY

-- append new id to file def name
UPDATE FileDefs SET FileDefName = FileDefName + '' ('' + CAST(@NewFileDefID AS varchar) + '')''
WHERE FileDefID = @NewFileDefID

-- copy file def columns for new file def
INSERT INTO FileDefColumns(FileDefID, ColumnName, DisplayOrder, Width, FormatString)
SELECT @NewFileDefID, ColumnName, DisplayOrder, Width, FormatString
FROM FileDefColumns
WHERE FileDefID = @FileDefID

-- return new id
SELECT @NewFileDefID

END

' 
END
GO
