CREATE PROCEDURE QCL_InsertChangeLog
@IDValue	INT,
@IDName		VARCHAR(50),
@Property	VARCHAR(50),
@OldValue	VARCHAR(3000),
@NewValue	VARCHAR(3000),
@ChangedBy	VARCHAR(100),
@ActionType	CHAR(1)

AS

INSERT INTO ChangeLog (IDValue, IDName, Property, OldValue, NewValue, datChanged, ChangedBy, ActionType)
SELECT @IDValue, @IDName, @Property, @OldValue, @NewValue, GETDATE(), @ChangedBy, @ActionType


