CREATE PROCEDURE [dbo].[PopulateAuditLog]	
	-- ============================================================================
	-- Author:		Kathi Nussrallah - MSI
	-- Create date: March 22, 2008
	-- Description:	PopulateAuditLog
	-- ==========================================================================
	@ReturnMessage As Nvarchar(500),	
    @MachineName As Nvarchar(100),
	@PackageName As Nvarchar(100),
	@Type As Nvarchar(50)
	
AS
	SET NOCOUNT ON 	
	
	INSERT INTO AuditLog
           ([LogDateTime]
           ,[MachineName]
           ,[Source]
           ,[Category]
           ,[Message]
           ,[ExceptionType]
           ,[StackTrace]
           ,[Data])
     Select GetDate(),@MachineName,@PackageName,'ETL-InitEvent - ' + @Type ,@ReturnMessage,NULL,Space(0),NULL


