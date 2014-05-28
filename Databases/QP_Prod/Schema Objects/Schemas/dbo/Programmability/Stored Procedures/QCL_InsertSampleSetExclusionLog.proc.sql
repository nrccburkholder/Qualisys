CREATE PROCEDURE [dbo].[QCL_InsertSampleSetExclusionLog]
@Survey_ID INT,
@Sampleset_ID INT,
@Sampleunit_ID INT,
@Pop_ID INT,
@Enc_ID INT,
@SamplingExclusionType_ID INT,
@DQ_BusRule_ID INT,
@DateCreated DATETIME
AS

SET NOCOUNT ON

INSERT INTO [dbo].Sampling_ExclusionLog (Survey_ID, Sampleset_ID, Sampleunit_ID, Pop_ID,
	Enc_ID, SamplingExclusionType_ID, DQ_BusRule_ID, DateCreated)
VALUES (@Survey_ID, @Sampleset_ID, @Sampleunit_ID, @Pop_ID, @Enc_ID, @SamplingExclusionType_ID,
	@DQ_BusRule_ID, @DateCreated)

SELECT SCOPE_IDENTITY()

SET NOCOUNT OFF


