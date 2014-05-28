CREATE PROCEDURE [dbo].[TR_SetUserActivity] 
    @UserName   varchar(50),
    @WorkstationName    varchar(50),
    @Activity  smallint,
	@isSTRchecked bit,
	@isVSTRChecked bit
AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @ID int

IF @Activity = 1 -- Login
BEGIN
    
	SELECT @ID = [TransferResultLoginActivity_id]
	FROM [dbo].[TransferResultLoginActivity]
	WHERE [UserName] = @UserName
	AND [WorkStationName] = @WorkstationName

	IF @@ROWCOUNT > 0
	BEGIN
		UPDATE [dbo].[TransferResultLoginActivity]
			SET [Login_dt] = GETDATE(),
				[Logout_dt] =NULL,
				[STRChecked] = @isSTRchecked,
				[VSTRChecked] = @isVSTRChecked
		WHERE [TransferResultLoginActivity_id] = @ID
	END
	ELSE
	BEGIN
		INSERT INTO [dbo].[TransferResultLoginActivity]
				   ([UserName]
				   ,[WorkStationName]
				   ,[Login_dt]
				   ,[Logout_dt]
				   ,[STRChecked]
				   ,[VSTRChecked])
			 VALUES
				   (@UserName
				   ,@WorkstationName
				   ,GETDATE()
				   ,NULL
				   ,@isSTRchecked
				   ,@isVSTRChecked)
	END

END
ELSE IF @Activity = 2 -- Logout
BEGIN 

	UPDATE [dbo].[TransferResultLoginActivity]
		SET [Logout_dt] = GETDATE()
	WHERE [UserName] = @UserName
	AND [WorkStationName] = @WorkstationName
	
END
ELSE
BEGIN
	UPDATE [dbo].[TransferResultLoginActivity]
		SET [STRChecked] = @isSTRchecked
		,[VSTRChecked] = @isVSTRChecked
	WHERE [UserName] = @UserName
	AND [WorkStationName] = @WorkstationName
END

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


