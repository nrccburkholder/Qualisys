CREATE PROCEDURE [dbo].[QSL_UpdateQSIDataResult]
    @Result_ID     INT,
    @Form_ID       INT,
    @QstnCore      INT,
    @ResponseValue INT
AS

--Setup the environment
SET NOCOUNT ON

--Update the form
UPDATE [dbo].QSIDataResults 
SET	Form_ID = @Form_ID,
	QstnCore = @QstnCore,
	ResponseValue = @ResponseValue
WHERE Result_ID = @Result_ID

--Reset the environment
SET NOCOUNT OFF


