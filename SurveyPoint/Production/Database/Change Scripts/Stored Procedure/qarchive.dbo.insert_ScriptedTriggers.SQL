/****** Object:  StoredProcedure [dbo].[insert_ScriptedTriggers]    Script Date: 08/09/2006 16:38:52 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ScriptedTriggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[insert_ScriptedTriggers]
GO
/****** Object:  StoredProcedure [dbo].[insert_ScriptedTriggers]    Script Date: 08/09/2006 16:38:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[insert_ScriptedTriggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


CREATE PROCEDURE [insert_ScriptedTriggers]
	(@ScriptedTriggerID 	[int] output,
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

INSERT INTO [QMS].[dbo].[ScriptedTriggers] 
	 ( [TriggerID],
	 [TriggerIDValue1],
	 [TriggerIDValue2],
	 [TriggerIDValue3],
	 [TriggerIDValue4]) 
 
VALUES 
	( @TriggerID,
	 @TriggerIDValue1,
	 @TriggerIDValue2,
	 @TriggerIDValue3,
	 @TriggerIDValue4)

SET @ScriptedTriggerID = @@IDENTITY

SET SELECT @TriggerName = TriggerName, @ItemOrder = ItemOrder, @ScreenTitle = ScreenTitle 
	FROM vw_ScriptTriggers 
	WHERE ScriptedTriggerID = @ScriptedTriggerID

END

' 
END
GO
