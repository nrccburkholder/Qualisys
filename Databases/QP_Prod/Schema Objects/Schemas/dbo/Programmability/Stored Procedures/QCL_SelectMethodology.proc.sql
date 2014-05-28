CREATE PROCEDURE dbo.QCL_SelectMethodology
@MethodologyId INT
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

IF EXISTS (SELECT * FROM ScheduledMailing WHERE Methodology_id=@MethodologyID)
BEGIN
  SELECT Methodology_id, Survey_id, strMethodology_nm, bitActiveMethodology, 
         sm.StandardMethodologyId, datCreate_dt, 0 bitAllowEdit, bitCustom
  FROM MailingMethodology mm, StandardMethodology sm
  WHERE Methodology_id=@MethodologyId
  AND mm.StandardMethodologyID=sm.StandardMethodologyID
END
ELSE
BEGIN
  SELECT Methodology_id, Survey_id, strMethodology_nm, bitActiveMethodology, 
         sm.StandardMethodologyId, datCreate_dt, 1 bitAllowEdit, bitCustom
  FROM MailingMethodology mm, StandardMethodology sm
  WHERE Methodology_id=@MethodologyId
  AND mm.StandardMethodologyID=sm.StandardMethodologyID
END


