/****** Object:  StoredProcedure [dbo].[delete_ScriptedTriggers]    Script Date: 08/09/2006 14:29:17 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ScriptedTriggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_ScriptedTriggers]
GO
/****** Object:  StoredProcedure [dbo].[delete_ScriptedTriggers]    Script Date: 08/09/2006 14:29:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_ScriptedTriggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [delete_ScriptedTriggers]
	(@ScriptedTriggerID 	[int])

AS 
BEGIN
SET NOCOUNT ON

DECLARE @TriggerID int
DECLARE @ScriptedTriggerCount int

-- get info about trigger used by script trigger to check for delete later
SET SELECT @TriggerID = TriggerID FROM ScriptedTriggers WHERE ScriptedTriggerID = @ScriptedTriggerID
SET SELECT @ScriptedTriggerCount = COUNT(ScriptedTriggerID) FROM ScriptedTriggers WHERE TriggerID = @TriggerID

-- delete scripted trigger
DELETE [QMS].[dbo].[ScriptedTriggers] 
WHERE  ( [ScriptedTriggerID]	 = @ScriptedTriggerID)

-- delete trigger if script trigger was only reference
IF @ScriptedTriggerCount = 1 EXEC delete_Triggers @TriggerID

SET NOCOUNT OFF
END


' 
END
GO
