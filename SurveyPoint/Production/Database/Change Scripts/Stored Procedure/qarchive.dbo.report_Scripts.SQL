/****** Object:  StoredProcedure [dbo].[report_Scripts]    Script Date: 08/10/2006 16:40:01 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[report_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[report_Scripts]
GO
/****** Object:  StoredProcedure [dbo].[report_Scripts]    Script Date: 08/10/2006 16:40:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[report_Scripts]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE PROCEDURE [dbo].[report_Scripts] 
(
	@ScriptID int
)
AS
SELECT * FROM vw_ScriptReport WHERE ScriptID = @ScriptID

' 
END
GO
