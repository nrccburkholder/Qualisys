/****** Object:  StoredProcedure [dbo].[delete_Criteria]    Script Date: 08/09/2006 13:39:11 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Criteria]
GO
/****** Object:  StoredProcedure [dbo].[delete_Criteria]    Script Date: 08/09/2006 13:39:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [delete_Criteria]
	(@CriteriaID 	[int])

AS DELETE [QMS].[dbo].[Criteria] 

WHERE 
	( [CriteriaID]	 = @CriteriaID)


' 
END
GO
