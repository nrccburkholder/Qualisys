/****** Object:  StoredProcedure [dbo].[insert_Users]    Script Date: 08/09/2006 16:48:08 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Users]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Users]
GO
/****** Object:  StoredProcedure [dbo].[insert_Users]    Script Date: 08/09/2006 16:48:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Users]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

/****** Object:  Stored Procedure dbo.insert_Users    Script Date: 10/3/2004 8:34:41 PM ******/




CREATE PROCEDURE [insert_Users]
	(@UserID 	[int] OUTPUT,
	 @Username 	[varchar](50),
	 @FirstName 	[varchar](100),
	 @LastName 	[varchar](100),
	 @Password 	[varchar](100),
	 @Email 	[varchar](100),
	 @GroupID 	[int],
	 @Active 	[tinyint],
	 @VerificationRate [int] = null,
	 @KeyMonitorRate [int] = null)

AS 
BEGIN

INSERT INTO [Users] 
	 ( [Username],
	 [FirstName],
	 [LastName],
	 [Password],
	 [Email],
	 [GroupID],
	 [Active],
	 [VerificationRate],
	 [KeyMonitorRate]) 
 
VALUES 
	( @Username,
	 @FirstName,
	 @LastName,
	 @Password,
	 @Email,
	 @GroupID,
	 @Active,
	 @VerificationRate,
	 @KeyMonitorRate)

SET @UserID = @@IDENTITY

END

' 
END
GO
