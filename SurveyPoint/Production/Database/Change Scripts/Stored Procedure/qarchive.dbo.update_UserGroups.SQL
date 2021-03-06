/****** Object:  StoredProcedure [dbo].[update_UserGroups]    Script Date: 08/09/2006 08:54:25 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_UserGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_UserGroups]
GO
/****** Object:  StoredProcedure [dbo].[update_UserGroups]    Script Date: 08/09/2006 08:54:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_UserGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  Stored Procedure dbo.update_UserGroups    Script Date: 10/3/2004 8:34:41 PM ******/




CREATE PROCEDURE [update_UserGroups]
	(@GroupID 	[int],
	 @Name 	[varchar](100),
	 @Description 	[varchar](500),
	 @VerificationRate [int] = 100,
	 @KeyMonitorRate [int] = 0)

AS UPDATE [UserGroups] 

SET  	 [Name]	 = @Name,
	 [Description]	 = @Description,
	 [VerificationRate] = @VerificationRate,
	 [KeyMonitorRate] = @KeyMonitorRate

WHERE 
	( [GroupID]	 = @GroupID)

' 
END
GO
