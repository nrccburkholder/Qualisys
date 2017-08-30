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

;with PossibleSamplePops as
(
	select distinct sp.SAMPLEPOP_ID
	from SUFacility sf
	inner join SAMPLEUNIT su
		on su.SUFacility_ID = sf.SuFacility_ID
	inner join SAMPLESETUNITTARGET ssut
		ON su.SAMPLEUNIT_ID = ssut.SAMPLEUNIT_ID
	inner join SAMPLESET sset
		ON sset.SAMPLESET_ID = ssut.SAMPLESET_ID 
	inner join SAMPLEPOP sp
		on sp.SAMPLESET_ID = sset.SAMPLESET_ID
	where sf.MedicareNumber = @MedicareNumber
		and su.CAHPSType_id = @SurveyType_id
		and sset.datDateRange_FromDate >= @EncDateStart 
		and sset.datDateRange_ToDate <= @EncDateEnd
),
EligibleSamplePops as
(
	select distinct sp.SAMPLEPOP_ID
	from PossibleSamplePops sp
	left join DispositionLog dl
		on dl.SamplePop_id = sp.SAMPLEPOP_ID
		and dl.Disposition_id in (3, 4, 8, 10)
	where dl.SamplePop_id is null
),
QfSamplePops as
(
	select sp.SAMPLEPOP_ID, isnull(max(cast(qf.bitComplete as int)), 0) as IsQfCompleted
	from EligibleSamplePops sp
	left join QUESTIONFORM qf
		on qf.SAMPLEPOP_ID = sp.SAMPLEPOP_ID
	group by sp.SAMPLEPOP_ID
),
SamplePops as
(
	select distinct sp.SAMPLEPOP_ID, 
		case when sp.IsQfCompleted = 1 
			or dl.SamplePop_id is not null then 1 else 0 end as IsCompleted
	from QfSamplePops sp
	left join DispositionLog dl
		on dl.SamplePop_id = sp.SAMPLEPOP_ID
		and dl.Disposition_id in (19, 20)
)
select 100.0 * isnull(sum(IsCompleted), 0) / 
	case when count(*) = 0 then 1 else count(*) end as RespRate
from SamplePops

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF
GO