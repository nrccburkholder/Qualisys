CREATE PROCEDURE [dbo].[QCL_DeleteCoverLetterItemArtifactUnitMapping]
	@CoverLetterItemArtifactUnitMapping_id int
as

SET NOCOUNT ON

DELETE [dbo].[CoverLetterItemArtifactUnitMapping]
WHERE CoverLetterItemArtifactUnitMapping_id=@CoverLetterItemArtifactUnitMapping_id

SET NOCOUNT OFF