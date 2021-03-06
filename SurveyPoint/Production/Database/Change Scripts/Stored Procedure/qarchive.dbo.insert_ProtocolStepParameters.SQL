/****** Object:  StoredProcedure [dbo].[insert_ProtocolStepParameters]    Script Date: 08/09/2006 16:31:51 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_ProtocolStepParameters]
GO
/****** Object:  StoredProcedure [dbo].[insert_ProtocolStepParameters]    Script Date: 08/09/2006 16:31:51 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'




CREATE PROCEDURE insert_ProtocolStepParameters
	(@ProtocolStepParamID 	[int] OUTPUT,
	 @ProtocolStepID 	[int],
	 @ProtocolStepTypeParamID 	[int],
	 @ProtocolStepParamValue 	[varchar](100))

AS
BEGIN

INSERT INTO [QMS].[dbo].[ProtocolStepParameters] 
	 ( [ProtocolStepID],
	 [ProtocolStepTypeParamID],
	 [ProtocolStepParamValue]) 
 
VALUES 
	( @ProtocolStepID,
	 @ProtocolStepTypeParamID,
	 @ProtocolStepParamValue)

SET @ProtocolStepParamID = @@IDENTITY

END




' 
END
GO
