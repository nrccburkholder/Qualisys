/****** Object:  StoredProcedure [dbo].[update_Users]    Script Date: 08/09/2006 08:53:22 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Users]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_Users]
GO
/****** Object:  StoredProcedure [dbo].[update_Users]    Script Date: 08/09/2006 08:53:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_Users]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  Stored Procedure dbo.update_Users    Script Date: 10/3/2004 8:34:41 PM ******/




CREATE PROCEDURE [update_Users]
	(@UserID 	[int],
	 @Username 	[varchar](50),
	 @FirstName 	[varchar](100),
	 @LastName 	[varchar](100),
	 @Password 	[varchar](100),
	 @Email 	[varchar](100),
	 @GroupID 	[int],
	 @Active 	[tinyint],
	 @VerificationRate [int] = null,
	 @KeyMonitorRate [int] = null)

AS UPDATE [Users] 

SET  [Username]	 = @Username,
	 [FirstName]	 = @FirstName,
	 [LastName]	 = @LastName,
	 [Password]	 = @Password,
	 [Email]	 = @Email,
	 [GroupID]	 = @GroupID,
	 [Active]	 = @Active ,
	 [VerificationRate] = @VerificationRate, 
	 [KeyMonitorRate] = @KeyMonitorRate
	

WHERE 
	( [UserID]	 = @UserID)

' 
END
GO
