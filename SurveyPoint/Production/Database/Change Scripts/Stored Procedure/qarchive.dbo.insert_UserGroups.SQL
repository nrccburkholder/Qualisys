/****** Object:  StoredProcedure [dbo].[insert_UserGroups]    Script Date: 08/09/2006 16:47:57 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_UserGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_UserGroups]
GO
/****** Object:  StoredProcedure [dbo].[insert_UserGroups]    Script Date: 08/09/2006 16:47:57 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_UserGroups]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  Stored Procedure dbo.insert_UserGroups    Script Date: 10/3/2004 8:34:41 PM ******/




CREATE PROCEDURE [insert_UserGroups]
	(@GroupID 	[int] OUTPUT,
	 @Name 	[varchar](100),
	 @Description 	[varchar](500), 
	 @VerificationRate [int] = 100,
	 @KeyMonitorRate [int] = 0)
AS
BEGIN

INSERT INTO [UserGroups] 
	 ( [Name],
	 [Description],
	 [VerificationRate],
	 [KeyMonitorRate]) 
 
VALUES 
	( @Name,
	 @Description,
	 @VerificationRate,
	 @KeyMonitorRate)

SET @GroupID = @@IDENTITY

END

' 
END
GO
