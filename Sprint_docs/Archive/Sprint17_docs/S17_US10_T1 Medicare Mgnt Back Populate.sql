/*
CJB 1/26/2015

Medicare Mgnt. 75%	
When a calculated proportion for a CCN changes from one quarter to the next from a value >75% to a value <75%, 
our system SHOULD take that CCN off census sampling. Currently this does NOT happen, as the CCN continues 
census sampling, even if the proportion is <75%. (As a reminder, 75% is the threshold for census sampling.)	

for the sake of more accurately performing HCAHPS proportional sampling each quarter. This enhancement is 
needed for the Medicare Management tab/section within Configuration Manager. 

10.1	We designed this in Sprint 15 - Implement the design

*/

--------------------START HERE TO RUN CURSOR
declare @MedicareNumber varchar(20), @ForceCensusSamplePercentage decimal(8,4)
declare @EarliestDatePropCalcPctExceeds75Pct datetime
select @ForceCensusSamplePercentage = ForceCensusSamplePercentage from MedicareGlobalCalcDefaults

DECLARE db_cursor CURSOR FOR  
SELECT distinct MedicareNumber
FROM MedicareREcalc_History
order by MedicareNumber

OPEN db_cursor  
FETCH NEXT FROM db_cursor INTO @MedicareNumber

WHILE @@FETCH_STATUS = 0  
BEGIN  
	select @EarliestDatePropCalcPctExceeds75Pct = '12/31/2999'
	select @EarliestDatePropCalcPctExceeds75Pct = min(DateCalculated) 
				from MedicareRecalc_History 
				where ProportionCalcPct >= @ForceCensusSamplePercentage and MedicareNumber = @MedicareNumber 
				group by MedicareNumber
	if 
---------------- THIS EXISTS FINDS CASES WHERE THE USER MUST HAVE TURNED ON CensusForced
		exists( select CensusForced, DateCalculated, @EarliestDatePropCalcPctExceeds75Pct from MedicareRecalc_History 
			where (@EarliestDatePropCalcPctExceeds75Pct is null or
					DateCalculated < @EarliestDatePropCalcPctExceeds75Pct)
				and ProportionCalcPct < @ForceCensusSamplePercentage 
				and CensusForced = 1 
				and MedicareNumber = @MedicareNumber)
/*	   or
---------------- THIS EXISTS FINDS CASES WHERE THE USER MUST HAVE TURNED OFF CensusForced (Don't care about this; the system will do this going forward)
	   exists( select CensusForced, DateCalculated, @EarliestDatePropCalcPctExceeds75Pct from MedicareRecalc_History
			where(DateCalculated > @EarliestDatePropCalcPctExceeds75Pct)
				and CensusForced = 0
				and MedicareNumber = @MedicareNumber) */
	begin
		update MedicareRecalc_History set UserCensusForced = Member_ID
			where MedicareNumber = @MedicareNumber
			and ProportionCalcPct < @ForceCensusSamplePercentage 
			and CensusForced = 1

		print 'User Modified: '+@MedicareNumber+'  '+Convert(varchar, @EarliestDatePropCalcPctExceeds75Pct)
	end
	FETCH NEXT FROM db_cursor INTO @MedicareNumber
END  

CLOSE db_cursor  
DEALLOCATE db_cursor 

--------------------END HERE TO RUN CURSOR
