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
	@MedicareNumber varchar(20), 
	@PeriodDate datetime, 
	@SurveyType_id int, 
	@indebug tinyint = 0
AS
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

declare @EncDateStart datetime, @EncDateEnd datetime
exec QCL_CreateCAHPSRollingYear @PeriodDate, @SurveyType_id, @EncDateStart OUTPUT, @EncDateEnd OUTPUT;

;with SamplePops as
(
	select case when 
			( exists (select * from DispositionLog dl
				where dl.Disposition_id in (19, 20)
				and dl.SamplePop_id = sp.SAMPLEPOP_ID ) 
			or exists (select * from QUESTIONFORM qf
				where qf.bitComplete = 1
				and qf.SAMPLEPOP_ID = sp.SAMPLEPOP_ID ) )
			and not exists (select * from DispositionLog dl
				where dl.Disposition_id in (3, 4, 8, 10)
				and dl.SamplePop_id = sp.SAMPLEPOP_ID ) 
		then 1 else 0 end as IsCompleted,
		case when 
			not exists (select * from DispositionLog dl
				where dl.Disposition_id in (3, 4, 8, 10)
				and dl.SamplePop_id = sp.SAMPLEPOP_ID ) 
		then 1 else 0 end as IsEligible
	from SUFacility sf
	inner join SAMPLEUNIT su
		on su.SUFacility_ID = sf.SuFacility_ID
	inner join SAMPLESETUNITTARGET ssut
		ON su.SAMPLEUNIT_ID = ssut.SAMPLEUNIT_ID
	inner join SAMPLESET sset
		ON sset.SAMPLESET_ID = ssut.SAMPLESET_ID 
	inner join PeriodDates pdates
		on pdates.SAMPLESET_ID = sset.SAMPLESET_ID 
	inner join PeriodDef pdef
		ON pdef.PeriodDef_ID = pdates.PeriodDef_ID
	inner join SAMPLEPOP sp
		on sp.SAMPLESET_ID = sset.SAMPLESET_ID
	where sf.MedicareNumber = @MedicareNumber
		and su.CAHPSType_id = @SurveyType_id
		and pdef.datExpectedEncStart >= @EncDateStart 
		and pdef.datExpectedEncEnd <= @EncDateEnd
	group by sp.SAMPLEPOP_ID
)
select 100.0 * isnull(sum(IsCompleted), 0) / isnull(sum(IsEligible), 0) as RespRate
from SamplePops

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO