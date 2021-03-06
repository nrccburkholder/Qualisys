/****** Object:  StoredProcedure [dbo].[insert_ProtocolSteps]    Script Date: 08/09/2006 16:32:29 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ProtocolSteps]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_ProtocolSteps]
GO
/****** Object:  StoredProcedure [dbo].[insert_ProtocolSteps]    Script Date: 08/09/2006 16:32:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ProtocolSteps]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE [insert_ProtocolSteps]
	(@ProtocolStepID 	[int] OUTPUT,
	 @ProtocolID 	[int],
	 @Name 	[varchar](100),
	 @ProtocolStepTypeID 	[int],
	 @StartDay 	[int])

AS
BEGIN

INSERT INTO [QMS].[dbo].[ProtocolSteps] 
	 ( [ProtocolID],
	 [Name],
	 [ProtocolStepTypeID],
	 [StartDay]) 
 
VALUES 
	( @ProtocolID,
	 @Name,
	 @ProtocolStepTypeID,
	 @StartDay)

SET @ProtocolStepID = @@IDENTITY

END




' 
END
GO
