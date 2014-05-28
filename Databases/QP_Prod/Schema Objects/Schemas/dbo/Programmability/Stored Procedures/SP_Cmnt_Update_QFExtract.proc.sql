CREATE PROCEDURE SP_Cmnt_Update_QFExtract @study int
AS
UPDATE questionform_extract 
SET datextracted_dt = GETDATE() 
WHERE study_id = @study
AND tiextracted = 0 
AND datextracted_dt is null


