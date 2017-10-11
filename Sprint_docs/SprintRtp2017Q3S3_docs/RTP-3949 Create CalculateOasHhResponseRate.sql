/*
	RTP-3949 Create CalculateOasHhResponseRate

	Lanny Boswell

	CREATE PROCEDURE [dbo].[CalculateOasHhResponseRate]

*/
use qp_prod
go

IF OBJECT_ID('[dbo].[CalculateOasHhResponseRate]') IS NOT NULL
	DROP PROCEDURE [dbo].[CalculateOasHhResponseRate]
GO

CREATE PROCEDURE [dbo].[CalculateOasHhResponseRate]
	@MedicareNumber VARCHAR(20), 
	@PeriodDate				DATETIME, 
	@SurveyType_id		INT, 
	@indebug					TINYINT = 0
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON

	DECLARE @EncDateStart DATETIME, @EncDateEnd DATETIME
	EXEC QCL_CreateCAHPSRollingYear @PeriodDate, @SurveyType_id, @EncDateStart OUTPUT, @EncDateEnd OUTPUT;

	;WITH PossibleSamplePops AS
	(
		SELECT DISTINCT sp.SAMPLEPOP_ID
		FROM SUFacility sf
		INNER JOIN SAMPLEUNIT su ON su.SUFacility_ID = sf.SuFacility_ID
		INNER JOIN SAMPLESETUNITTARGET ssut ON su.SAMPLEUNIT_ID = ssut.SAMPLEUNIT_ID
		INNER JOIN SAMPLESET sset ON sset.SAMPLESET_ID = ssut.SAMPLESET_ID 
		INNER JOIN SAMPLEPOP sp ON sp.SAMPLESET_ID = sset.SAMPLESET_ID
		WHERE sf.MedicareNumber = @MedicareNumber
			AND su.CAHPSType_id = @SurveyType_id
			AND sset.datDateRange_FromDate >= @EncDateStart 
			AND sset.datDateRange_ToDate <= @EncDateEnd
	),
	EligibleSamplePops AS
	(
		SELECT DISTINCT sp.SAMPLEPOP_ID
		FROM PossibleSamplePops sp
		LEFT JOIN DispositionLog dl ON dl.SamplePop_id = sp.SAMPLEPOP_ID AND dl.Disposition_id IN (3, 4, 8, 10)
		WHERE dl.SamplePop_id IS NULL
	),
	SamplePops AS
	(	
		SELECT DISTINCT EligibleSamplePops.SamplePop_id, (CASE WHEN DispositionLog.SamplePop_id IS NULL THEN 0 ELSE 1 END) AS isCompleted
		FROM EligibleSamplePops 
		LEFT OUTER JOIN DispositionLog ON EligibleSamplePops.SAMPLEPOP_ID=DispositionLog.SamplePop_id  AND DispositionLog.Disposition_id IN (19,20)
	)

	SELECT 100.0 * ISNULL(SUM(IsCompleted*1.0), 0) /
		CASE WHEN COUNT(*) = 0 THEN 1 ELSE COUNT(*) END AS RespRate
	FROM SamplePops

	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF
END
GO