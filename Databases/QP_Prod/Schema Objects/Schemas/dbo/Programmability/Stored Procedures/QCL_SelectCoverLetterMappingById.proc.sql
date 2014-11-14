CREATE PROCEDURE [dbo].[QCL_SelectCoverLetterMappingById]
	@id int
as

SET NOCOUNT ON

SELECT m.CoverLetterItemArtifactUnitMapping_id
    , m.Survey_id
	, m.SampleUnit_id
	, su.strSampleUnit_nm
	, m.CoverLetterItemType_id
	, m.CoverLetter_dsc
	, m.CoverLetterItem_label
	, m.Artifact_dsc
	, m.ArtifactItem_label
FROM dbo.CoverLetterItemArtifactUnitMapping m
inner join sampleunit su on m.SampleUnit_id=su.SampleUnit_id
WHERE CoverLetterItemArtifactUnitMapping_id=@id

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED
