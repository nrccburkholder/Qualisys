/****** Object:  StoredProcedure [dbo].[update_UserGroupPrivledges]    Script Date: 08/09/2006 08:54:37 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_UserGroupPrivledges]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_UserGroupPrivledges]
GO
/****** Object:  StoredProcedure [dbo].[update_UserGroupPrivledges]    Script Date: 08/09/2006 08:54:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_UserGroupPrivledges]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [update_UserGroupPrivledges]
	(@GroupPrivledgeID 	[int],
	 @GroupID 	[int],
	 @EventID 	[int])

AS UPDATE [QMS].[dbo].[UserGroupPrivledges] 

SET  	 [GroupID]	 = @GroupID,
	 [EventID]	 = @EventID 

WHERE 
	( [GroupPrivledgeID]	 = @GroupPrivledgeID)



' 
END
GO
