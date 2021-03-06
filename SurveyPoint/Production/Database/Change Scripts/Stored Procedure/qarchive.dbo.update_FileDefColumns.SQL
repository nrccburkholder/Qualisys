/****** Object:  StoredProcedure [dbo].[update_FileDefColumns]    Script Date: 08/09/2006 12:54:20 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_FileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_FileDefColumns]
GO
/****** Object:  StoredProcedure [dbo].[update_FileDefColumns]    Script Date: 08/09/2006 12:54:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_FileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_FileDefColumns]
	(@FileDefColumnID 	[int],
	 @FileDefID 	[int],
	 @ColumnName 	[varchar](250),
	 @DisplayOrder 	[int],
	 @Width 	[int],
	 @FormatString 	[varchar](50))

AS UPDATE [QMS].[dbo].[FileDefColumns] 

SET  	 [FileDefID]	 = @FileDefID,
	 [ColumnName]	 = @ColumnName,
	 [DisplayOrder]	 = @DisplayOrder,
	 [Width]	 = @Width,
	 [FormatString]	 = @FormatString 

WHERE 
	( [FileDefColumnID]	 = @FileDefColumnID)



' 
END
GO
