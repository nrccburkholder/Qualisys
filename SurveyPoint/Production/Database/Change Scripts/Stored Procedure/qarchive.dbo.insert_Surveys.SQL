/****** Object:  StoredProcedure [dbo].[insert_Surveys]    Script Date: 08/09/2006 16:45:59 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Surveys]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_Surveys]
GO
/****** Object:  StoredProcedure [dbo].[insert_Surveys]    Script Date: 08/09/2006 16:45:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_Surveys]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE insert_Surveys
	(@SurveyID 	[int] OUTPUT,
	 @Name 	[varchar](100),
	 @Description 	[varchar](1000),
	 @CreatedByUserID 	[int],
	 @Active 	[tinyint])

AS
BEGIN

INSERT INTO [QMS].[dbo].[Surveys] 
	 ( [Name],
	 [Description],
	 [CreatedByUserID],
	 [CreatedOnDate],
	 [Active]) 
 
VALUES 
	( @Name,
	 @Description,
	 @CreatedByUserID,
	 GETDATE(),
	 @Active)

SET @SurveyID = @@IDENTITY

END




' 
END
GO
