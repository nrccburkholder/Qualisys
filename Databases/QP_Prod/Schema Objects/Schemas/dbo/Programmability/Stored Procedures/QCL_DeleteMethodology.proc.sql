CREATE PROCEDURE dbo.QCL_DeleteMethodology
@MethodologyId INT
AS
 
IF EXISTS (SELECT ScheduledMailing_id FROM ScheduledMailing WHERE Methodology_id = @MethodologyId)
BEGIN
            RAISERROR ('The methodology cannot be deleted because it has already been used to schedule survey generation.', 18, 1)
END
ELSE
BEGIN
	DELETE MailingStep
	WHERE Methodology_id=@MethodologyId

	DELETE MailingMethodology
	WHERE Methodology_id=@MethodologyId
END


