/****** Object:  StoredProcedure [dbo].[delete_RespondentProperties]    Script Date: 08/09/2006 13:58:28 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_RespondentProperties]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_RespondentProperties]
GO
/****** Object:  StoredProcedure [dbo].[delete_RespondentProperties]    Script Date: 08/09/2006 13:58:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_RespondentProperties]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_RespondentProperties]
	(@RespondentPropertyID 	[int])

AS DELETE [QMS].[dbo].[RespondentProperties] 

WHERE 
	( [RespondentPropertyID]	 = @RespondentPropertyID)



' 
END
GO
