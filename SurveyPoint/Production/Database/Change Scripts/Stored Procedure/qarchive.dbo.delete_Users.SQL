/****** Object:  StoredProcedure [dbo].[delete_Users]    Script Date: 08/09/2006 14:31:43 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Users]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Users]
GO
/****** Object:  StoredProcedure [dbo].[delete_Users]    Script Date: 08/09/2006 14:31:43 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Users]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_Users]
	(@UserID 	[int])

AS DELETE [QMS].[dbo].[Users] 

WHERE 
	( [UserID]	 = @UserID)



' 
END
GO
