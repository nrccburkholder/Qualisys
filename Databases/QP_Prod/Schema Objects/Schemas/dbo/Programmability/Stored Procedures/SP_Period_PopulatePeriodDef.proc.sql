/***********************************************************************************************
*	Procedure Name:
		dbo.SP_Period_PopulatePeriodDef
*
*	Description:
		This will update or add a period in PeriodDef.
*
*	Parameters:
		@perioddef_id
			This is the period ID.
		@Survey_id
			This is the survey_id.
		@employee_id
			This is the ID of the Employee who created the period
		@datAdded
			This is the date that the period was created on.
		@strPeriodDef_nm
			This is the name of the Period
		@intExpectedSamples
			This is the expected number of samples
		@DaystoSample
			This is the number of days prior to sampling that a datafile should arrive at NRC
		@datExpectedEncStart
			This is the start of the encounter date range for this period.
		@datExpectedEncEnd
			This is the end of the encounter date range for this period.
		@strDayOrder
			This is the value that indicates which occurrance of a day we want to sample on 
			(i.e. first, second, third, fourth, last Monday of the month)
		@Recurrence
			This is the integer portion of how often we want to sample 
			(i.e. every 1 week, 2 weeks, etc.)
		@MonthWeek
			This indicates whether recurrence is on a weekly or Monthly basis.
		@samplingmethod_id
			This indicates what sampling method should be used.
		@intDayofMonth
			This is the day of month they used in the Wizard.
*
*	Return:
		@newPeriodID
			This is the Period ID assigned when a new period is added
*
*	History:
		release 1.0  Jan 28, 2004 by Dan Christensen
			Initial Release
************************************************************************************************/

CREATE      PROCEDURE dbo.SP_Period_PopulatePeriodDef
		@Survey_id int,
		@employee_id int,
		@datAdded datetime,
		@strPeriodDef_nm varchar(42),
		@intExpectedSamples int,
		@DaystoSample int, 
		@datExpectedEncStart datetime,
		@datExpectedEncEnd datetime,
		@strDayOrder char(6),
		@Recurrence int,
		@MonthWeek char(1),
		@strsamplingmethod_nm varchar(42),
		@perioddef_id int,
		@intDayofMonth int
AS
Declare @newPeriodID int, @Samplingmethod_id int
set @newPeriodID=@perioddef_id

IF @intDayofMonth=0 Set @intDayofMonth = null

IF @datExpectedEncStart='01jan1900 00:00:000' SET @datExpectedEncStart=null
IF @datExpectedEncEnd='01jan1900 00:00:000' SET @datExpectedEncEnd=null

select @Samplingmethod_id=Samplingmethod_id
from samplingmethod
where strsamplingmethod_nm=@strsamplingmethod_nm

IF @perioddef_id =0
Begin
	insert into PeriodDef (survey_id, employee_id, datAdded, strPeriodDef_nm,
						intExpectedSamples, DaystoSample, datExpectedEncStart,
						datExpectedEncEnd, strDayOrder, MonthWeek,
						samplingMethod_id)
	values (@survey_id, @employee_id, @datAdded, @strPeriodDef_nm,
						@intExpectedSamples, @DaystoSample, @datExpectedEncStart,
						@datExpectedEncEnd, @strDayOrder, @Recurrence, @MonthWeek,
						@samplingMethod_id)

	select @newPeriodID=scope_identity()
End
Else
Begin
	update PeriodDef 
	set strPeriodDef_nm=@strPeriodDef_nm,
		intExpectedSamples=@intExpectedSamples, 
		DaystoSample=@DaystoSample, 
		datExpectedEncStart=@datExpectedEncStart,					
		datExpectedEncEnd=@datExpectedEncEnd, 
		strDayOrder=@strDayOrder, 
		MonthWeek=@MonthWeek,
		samplingMethod_id=@samplingMethod_id
	where periodDef_id=@periodDef_id
End

Select @newPeriodID


