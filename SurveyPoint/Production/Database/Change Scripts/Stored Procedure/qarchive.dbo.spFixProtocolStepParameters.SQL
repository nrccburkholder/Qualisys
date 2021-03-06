/****** Object:  StoredProcedure [dbo].[spFixProtocolStepParameters]    Script Date: 08/09/2006 12:58:02 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spFixProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[spFixProtocolStepParameters]
GO
/****** Object:  StoredProcedure [dbo].[spFixProtocolStepParameters]    Script Date: 08/09/2006 12:58:02 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[spFixProtocolStepParameters]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.spFixProtocolStepParameters AS
/* Inserts new protocol step parameter types into the protocol step parameters that are missing*/
INSERT INTO ProtocolStepParameters
                      (ProtocolStepID, ProtocolStepTypeParamID, ProtocolStepParamValue)
SELECT     x.ProtocolStepID, x.ProtocolStepTypeParamID, x.Defaults
FROM         ProtocolStepParameters RIGHT OUTER JOIN
                          (SELECT     ProtocolSteps.ProtocolStepID, ProtocolStepTypeParameters.ProtocolStepTypeParamID, ProtocolStepTypeParameters.Defaults
                            FROM          ProtocolSteps INNER JOIN
                                                   ProtocolStepTypeParameters ON ProtocolSteps.ProtocolStepTypeID = ProtocolStepTypeParameters.ProtocolStepTypeID) x ON 
                      ProtocolStepParameters.ProtocolStepID = x.ProtocolStepID AND 
                      ProtocolStepParameters.ProtocolStepTypeParamID = x.ProtocolStepTypeParamID
WHERE     (ProtocolStepParameters.ProtocolStepParamID IS NULL)

' 
END
GO
