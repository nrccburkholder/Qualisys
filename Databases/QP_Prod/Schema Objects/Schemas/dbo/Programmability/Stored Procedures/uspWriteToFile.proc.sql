CREATE PROCEDURE dbo.uspWriteToFile
@FilePath as VARCHAR(255),
@DataToWrite as varchar(8000)
AS
SET NOCOUNT ON
DECLARE @RetCode int , @FileSystem int , @FileHandle int

EXECUTE @RetCode = sp_OACreate 'Scripting.FileSystemObject' , @FileSystem OUTPUT
IF (@@ERROR|@RetCode <> 0 Or @FileSystem < 0)
begin
	RAISERROR ('could not create FileSystemObject',16,1)
	goto ErrorHandler
end

EXECUTE @RetCode = sp_OAMethod @FileSystem , 'OpenTextFile' , @FileHandle OUTPUT , @FilePath, 8, 1
IF (@@ERROR|@RetCode <> 0 Or @FileHandle < 0)
begin
	print @RetCode
	RAISERROR ('Could not open File.',16,1)
	goto ErrorHandler
end

EXECUTE @RetCode = sp_OAMethod @FileHandle , 'WriteLine' , NULL , @DataToWrite
IF (@@ERROR|@RetCode <> 0)
begin
	RAISERROR ('Could not write to file ',16,1)
	goto ErrorHandler
end

EXECUTE @RetCode = sp_OAMethod @FileHandle , 'Close' , NULL
IF (@@ERROR|@RetCode <> 0)
begin
	RAISERROR ('Could not close file',16,1)
	goto ErrorHandler
end
EXEC sp_OADestroy @FileSystem
EXEC sp_OADestroy @FileHandle

ErrorHandler:
EXEC sp_OADestroy @FileSystem
EXEC sp_OADestroy @FileHandle
RETURN(-1)


