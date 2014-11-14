CREATE PROCEDURE [dbo].[QCL_InsertCoverLetterItemArtifactUnitMapping]
	  @Survey_id int
	, @SampleUnit_id int
	, @CoverLetterItemType_id tinyint
	, @CoverLetter_dsc varchar(60)
	, @CoverLetterItem_label varchar(60) 
	, @Artifact_dsc varchar(60)
	, @ArtifactItem_label varchar(60) 
as

SET NOCOUNT ON

INSERT INTO dbo.CoverLetterItemArtifactUnitMapping (Survey_id, SampleUnit_id, CoverLetterItemType_id, CoverLetter_dsc, CoverLetterItem_label, Artifact_dsc, ArtifactItem_label)
VALUES (@Survey_id, @SampleUnit_id, @CoverLetterItemType_id, @CoverLetter_dsc, @CoverLetterItem_label, @Artifact_dsc, @ArtifactItem_label)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF