/****** Object:  StoredProcedure [dbo].[update_ScriptedTriggers]    Script Date: 08/09/2006 09:17:59 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScriptedTriggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_ScriptedTriggers]
GO
/****** Object:  StoredProcedure [dbo].[update_ScriptedTriggers]    Script Date: 08/09/2006 09:17:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_ScriptedTriggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [update_ScriptedTriggers]
	(@ScriptedTriggerID 	[int],
	 @TriggerID 	[int],
	 @TriggerIDValue1 	[int],
	 @TriggerIDValue2 	[int],
	 @TriggerIDValue3 	[int],
	 @TriggerIDValue4 	[int],
	 @TriggerName varchar(100) output,
	 @ItemOrder [int] output,
	 @ScreenTitle varchar(100) output)

AS
BEGIN

UPDATE [QMS].[dbo].[ScriptedTriggers] 

SET  	 [TriggerID]	 = @TriggerID,
	 [TriggerIDValue1]	 = @TriggerIDValue1,
	 [TriggerIDValue2]	 = @TriggerIDValue2,
	 [TriggerIDValue3]	 = @TriggerIDValue3,
	 [TriggerIDValue4]	 = @TriggerIDValue4 

WHERE 
	( [ScriptedTriggerID]	 = @ScriptedTriggerID)


SET 	SELECT @TriggerName = TriggerName, @ItemOrder = ItemOrder, @ScreenTitle = ScreenTitle 
	FROM vw_ScriptTriggers 
	WHERE ScriptedTriggerID = @ScriptedTriggerID

END

' 
END
GO
