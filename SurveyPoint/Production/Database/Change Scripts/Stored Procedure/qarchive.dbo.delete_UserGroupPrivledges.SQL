/****** Object:  StoredProcedure [dbo].[delete_UserGroupPrivledges]    Script Date: 08/09/2006 14:31:25 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_UserGroupPrivledges]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_UserGroupPrivledges]
GO
/****** Object:  StoredProcedure [dbo].[delete_UserGroupPrivledges]    Script Date: 08/09/2006 14:31:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_UserGroupPrivledges]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_UserGroupPrivledges]
	(@GroupPrivledgeID 	[int])

AS DELETE [QMS].[dbo].[UserGroupPrivledges] 

WHERE 
	( [GroupPrivledgeID]	 = @GroupPrivledgeID)



' 
END
GO
