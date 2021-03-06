/****** Object:  StoredProcedure [dbo].[senior_CheckAudits]    Script Date: 08/10/2006 10:09:12 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[senior_CheckAudits]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[senior_CheckAudits]
GO
/****** Object:  StoredProcedure [dbo].[senior_CheckAudits]    Script Date: 08/10/2006 10:09:12 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[senior_CheckAudits]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[senior_CheckAudits] 
(
	@RespondentID int,
	@UserID int
)
AS
BEGIN
	DECLARE @error varchar(4000)
	DECLARE @EventID int	
	SET @error = ''''
	SET @EventID = 3040

	-- clear existing audit checks
	DELETE FROM EventLog WHERE RespondentID = @RespondentID AND EventID = @EventID

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditArthritisMedicine](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditChemotherapy](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditHasMobilityEquip](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditHeartMedicine](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditLastSurgeryDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditLastSurveyInpatient](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditLiveWithOtherDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditLiveWithRelative](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditLiveWithRelativeDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditNextSurgeryDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditNoMobilityEquip](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditNursingHome](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditOtherConditionDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditOtherEquipDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditOtherServicesDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditOtherTreatmentDesc](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditPrescriptions](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

	SET SELECT @error = [dbo].[TruncateStr]([dbo].[senior_AuditPrescriptionsMany](@RespondentID), 3000, 0)
	IF LEN(@error) > 0 
		EXEC [insert_EventLog] @EventLogID = NULL, @EventID = @EventID, @UserID = @UserID, @RespondentID = @RespondentID, @EventParameters = @error

END
' 
END
GO
GRANT EXECUTE ON [dbo].[senior_CheckAudits] TO [reporter]
GO
