/****** Object:  StoredProcedure [dbo].[insert_FileDefColumns]    Script Date: 08/09/2006 16:30:34 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_FileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_FileDefColumns]
GO
/****** Object:  StoredProcedure [dbo].[insert_FileDefColumns]    Script Date: 08/09/2006 16:30:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_FileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_FileDefColumns]
	(@FileDefColumnID 	[int] OUTPUT,
	 @FileDefID 	[int],
	 @ColumnName 	[varchar](250),
	 @DisplayOrder 	[int],
	 @Width 	[int],
	 @FormatString 	[varchar](50))

AS
BEGIN

INSERT INTO [QMS].[dbo].[FileDefColumns] 
	 ( [FileDefID],
	 [ColumnName],
	 [DisplayOrder],
	 [Width],
	 [FormatString]) 
 
VALUES 
	( @FileDefID,
	 @ColumnName,
	 @DisplayOrder,
	 @Width,
	 @FormatString)

SET @FileDefColumnID= @@IDENTITY

END




' 
END
GO
