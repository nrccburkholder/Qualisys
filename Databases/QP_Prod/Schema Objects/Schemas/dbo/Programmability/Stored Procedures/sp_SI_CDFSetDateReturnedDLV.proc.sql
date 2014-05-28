-- =====================================================================
-- Author:		Jeffrey J. Fleming
-- Create date: 08/18/2006
-- Description:	This procedure sets the date returned and scan batch for
--              the specified survey.
-- =====================================================================
CREATE PROCEDURE [dbo].[sp_SI_CDFSetDateReturnedDLV] 
    @QuestionFormID int, 
	@ScanBatch varchar(100)

AS

--Setup the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Update the date returned
UPDATE QuestionForm 
SET datReturned = GetDate(), 
    strScanBatch = @ScanBatch 
WHERE QuestionForm_id = @QuestionFormID

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


