/****** Object:  StoredProcedure [dbo].[delete_UserGroups]    Script Date: 08/09/2006 14:31:34 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_UserGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_UserGroups]
GO
/****** Object:  StoredProcedure [dbo].[delete_UserGroups]    Script Date: 08/09/2006 14:31:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_UserGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE delete_UserGroups
	(@GroupID 	[int])

AS
BEGIN

DELETE [QMS].[dbo].[UserGroupPrivledges] 
WHERE 
	( [GroupID]	 = @GroupID)
	
DELETE [QMS].[dbo].[UserGroups] 
WHERE 
	( [GroupID]	 = @GroupID)

END


' 
END
GO
