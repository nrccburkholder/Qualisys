/****** Object:  StoredProcedure [dbo].[delete_FileDefColumns]    Script Date: 08/09/2006 13:39:50 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_FileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_FileDefColumns]
GO
/****** Object:  StoredProcedure [dbo].[delete_FileDefColumns]    Script Date: 08/09/2006 13:39:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_FileDefColumns]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_FileDefColumns]
	(@FileDefColumnID 	[int])

AS DELETE [QMS].[dbo].[FileDefColumns] 

WHERE 
	( [FileDefColumnID]	 = @FileDefColumnID)



' 
END
GO
