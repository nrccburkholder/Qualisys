CREATE PROCEDURE [dbo].[QSL_InsertQSIDataResult]
    @Form_ID       INT,
    @QstnCore      INT,
    @ResponseValue INT
AS

--Setup the environment
SET NOCOUNT ON

--Insert the new result
INSERT INTO [dbo].QSIDataResults (Form_ID, QstnCore, ResponseValue)
VALUES (@Form_ID, @QstnCore, @ResponseValue)

--Return the result_id
SELECT SCOPE_IDENTITY()

--Reset the environment
SET NOCOUNT OFF


