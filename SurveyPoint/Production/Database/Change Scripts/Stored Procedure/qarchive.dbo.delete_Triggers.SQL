/****** Object:  StoredProcedure [dbo].[delete_Triggers]    Script Date: 08/09/2006 14:30:44 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Triggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[delete_Triggers]
GO
/****** Object:  StoredProcedure [dbo].[delete_Triggers]    Script Date: 08/09/2006 14:30:44 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[delete_Triggers]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [delete_Triggers]
	(@TriggerID 	[int])

AS
BEGIN
SET NOCOUNT ON

DECLARE @CriteriaID int
DECLARE @TriggerCount int
SET @TriggerCount = 0

-- get information about criteria to delete later
SET SELECT @CriteriaID = CriteriaID FROM Triggers WHERE TriggerID = @TriggerID
IF @CriteriaID IS NOT NULL
	SET SELECT @TriggerCount = COUNT(TriggerID) FROM Triggers WHERE CriteriaID = @CriteriaID
	
-- clear trigger log
DELETE [TriggerLog]
WHERE 
 	( [TriggerID]	 = @TriggerID)

-- delete trigger
DELETE [Triggers] 
WHERE 
	( [TriggerID]	 = @TriggerID)

-- delete criteria if trigger was only reference
IF @TriggerCount = 1 
	EXEC delete_Criteria @CriteriaID

SET NOCOUNT OFF
END
' 
END
GO
