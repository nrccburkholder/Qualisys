/****** Object:  StoredProcedure [dbo].[delete_Events]    Script Date: 08/08/2006 16:47:06 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Events]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Events]
GO
/****** Object:  StoredProcedure [dbo].[delete_Events]    Script Date: 08/08/2006 16:47:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Events]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_Events]
	(@EventID 	[int])

AS DELETE [QMS].[dbo].[Events] 

WHERE 
	( [EventID]	 = @EventID)



' 
END
GO
