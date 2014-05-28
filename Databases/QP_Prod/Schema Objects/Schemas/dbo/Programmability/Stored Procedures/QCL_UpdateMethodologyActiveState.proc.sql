CREATE PROCEDURE QCL_UpdateMethodologyActiveState 
@MethodologyId INT,
@IsActive BIT -- 0 => inActive 1=> Active
AS

UPDATE MailingMethodology 
SET bitActiveMethodology=@IsActive 
WHERE Methodology_id=@MethodologyID


