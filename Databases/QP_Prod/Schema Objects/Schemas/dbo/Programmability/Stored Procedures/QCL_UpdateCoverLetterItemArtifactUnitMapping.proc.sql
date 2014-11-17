CREATE PROCEDURE [dbo].[QCL_UpdateCoverLetterItemArtifactUnitMapping]
	  @CoverLetterItemArtifactUnitMapping_id int
	, @SampleUnit_id int
	, @CoverLetterItemType_id tinyint
	, @CoverLetter_dsc varchar(60)
	, @CoverLetterItem_label varchar(60) 
	, @Artifact_dsc varchar(60)
	, @ArtifactItem_label varchar(60) 
as

SET NOCOUNT ON

UPDATE dbo.CoverLetterItemArtifactUnitMapping 
SET   SampleUnit_id = @Sampleunit_id
	, CoverLetterItemType_id = @CoverLetterItemType_id
	, CoverLetter_dsc = @CoverLetter_dsc
	, CoverLetterItem_label = @CoverLetterItem_label
	, Artifact_dsc = @Artifact_dsc
	, ArtifactItem_label = @ArtifactItem_label
WHERE CoverLetterItemArtifactUnitMapping_id = @CoverLetterItemArtifactUnitMapping_id 

SET NOCOUNT OFF