/****** Object:  StoredProcedure [dbo].[insert_UserGroupPrivledges]    Script Date: 08/09/2006 16:47:30 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_UserGroupPrivledges]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_UserGroupPrivledges]
GO
/****** Object:  StoredProcedure [dbo].[insert_UserGroupPrivledges]    Script Date: 08/09/2006 16:47:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_UserGroupPrivledges]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_UserGroupPrivledges]
	(@GroupPrivledgeID 	[int] OUTPUT,
	 @GroupID 	[int],
	 @EventID 	[int])

AS 
BEGIN

INSERT INTO [QMS].[dbo].[UserGroupPrivledges] 
	 ( [GroupID],
	 [EventID]) 
 
VALUES 
	( @GroupID,
	 @EventID)

SET @GroupPrivledgeID = @@IDENTITY

END




' 
END
GO
