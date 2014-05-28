CREATE PROCEDURE [dbo].[QCL_DeleteMethodologyStepsByMethodologyId]
@MethodologyId INT
AS

BEGIN

DELETE VendorFile_VoviciDetails
WHERE MailingStep_ID IN
	(SELECT MailingStep_ID
	FROM MailingStep
	WHERE Methodology_id=@MethodologyId)

DELETE MM_EmailBlast
WHERE MailingStep_ID IN
	(SELECT MailingStep_ID
	FROM MailingStep
	WHERE Methodology_id=@MethodologyId)

DELETE MailingStep
WHERE Methodology_id=@MethodologyId

END


