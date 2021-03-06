/****** Object:  StoredProcedure [dbo].[get_CurrentCallAttempts]    Script Date: 08/09/2006 15:23:09 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_CurrentCallAttempts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_CurrentCallAttempts]
GO
/****** Object:  StoredProcedure [dbo].[get_CurrentCallAttempts]    Script Date: 08/09/2006 15:23:09 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_CurrentCallAttempts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE dbo.get_CurrentCallAttempts
(
	@ProtocolStepID int
)
AS
SELECT     COUNT(b.ProtocolStepID) AS CallAttempts
FROM         dbo.ProtocolSteps a INNER JOIN
                      dbo.ProtocolSteps b 
ON a.ProtocolID = b.ProtocolID AND a.StartDay > b.StartDay
WHERE     (a.ProtocolStepID = @ProtocolStepID) 
AND (b.ProtocolStepTypeID IN (5, 6))

' 
END
GO
GRANT EXECUTE ON [dbo].[get_CurrentCallAttempts] TO [reporter]
GO
