--S15_US6.1 Medicare Management Analysis Design
--for solution (see cursor below)

use [QP_Prod]

--926 total

-- % < 0.75 always; CF always 0
select medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History
group by medicareNumber
having max(proportioncalcpct) < 0.75
and max(CensusForced) = 0
--327

-- % < 0.75 always; CF always 1
select mrh.medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History mrh
group by mrh.medicareNumber
having max(proportioncalcpct) < 0.75
and min(CensusForced) = 1
-- 43

-- % < 0.75; CF sometimes 0, sometimes 1
select mrh.medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History mrh
group by mrh.medicareNumber
having max(proportioncalcpct) < 0.75
and min(CensusForced) = 0
and max(CensusForced) = 1
--19

-- % >= 0.75 always; CF always 0
select mrh.medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History mrh
group by mrh.medicareNumber
having min(proportioncalcpct) >= 0.75
and max(CensusForced) = 0
-- 0

-- % >= 0.75 always; CF always 1
select mrh.medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History mrh
group by mrh.medicareNumber
having min(proportioncalcpct) >= 0.75
and min(CensusForced) = 1
-- 381

-- % >= 0.75; CF sometimes 0, sometimes 1
select mrh.medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History mrh
group by mrh.medicareNumber
having min(proportioncalcpct) >= 0.75
and min(CensusForced) = 0
and max(CensusForced) = 1
--0

-- % max >= 0.75, %min < 0.75, CF only 0
select medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History
group by medicareNumber
having max(proportioncalcpct) >= 0.75
and min(proportioncalcpct) < 0.75
and max(CensusForced) = 0
--0

-- % max >= 0.75, %min < 0.75, CF only 1 
select medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History
group by medicareNumber
having max(proportioncalcpct) >= 0.75
and min(proportioncalcpct) < 0.75
and min(CensusForced) = 1
--10

-- % max >= 0.75, %min < 0.75, CF sometimes 0, sometimes 1
select mrh.medicareNumber, max(proportioncalcpct), min(proportioncalcpct) 
from MedicareRecalc_History mrh
group by mrh.medicareNumber
having (min(proportioncalcpct) < 0.75 and max(proportioncalcpct) >= 0.75)
and min(CensusForced) = 0
and max(CensusForced) = 1
--146

select top 1 * from medicarelookup
select top 1 * from MedicareRecalc_History

sp_helptext QCL_InsertMedicareNumber

select proportioncalcpct, CensusForced, * from MedicareRecalc_History where medicarenumber in (
select mrh.medicareNumber
from MedicareRecalc_History mrh
group by mrh.medicareNumber
having (min(proportioncalcpct) < 0.75 and max(proportioncalcpct) >= 0.75)
and min(CensusForced) = 0
and max(CensusForced) = 1
)
order by medicarenumber, datecalculated desc

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
		print 'User Modified: '+@MedicareNumber+'  '+Convert(varchar, @EarliestDatePropCalcPctExceeds75Pct)

	FETCH NEXT FROM db_cursor INTO @MedicareNumber
END  

CLOSE db_cursor  
DEALLOCATE db_cursor 

--------------------END HERE TO RUN CURSOR

/*

Select CensusForced, ProportionCalcPct, * from medicareRecalc_History where MedicareNumber in ('000007','050070','050071', -- these are 1 and done
																								'201315','330238','390184','390266') -- these are multiple
order by MedicareNumber, DateCalculated Desc

Here are the records indicating CensusForced must have been user selected from the above (ie: set to 1 prior to ProportionCalcPct exceeding 75%):

1	0.4436	2246	000007	Hualapai Mountain Medical Center 	2	NULL	0.4000	0.1700	3272	2010-11-03 08:00:22.907	400	0.4436	1	0.0500	1	179053	2009-11-03 08:02:41.843	0.0000	NULL	1	2009-10-01 00:00:00.000
1	0.5443	11662	050070	Kaiser Permanente South San Francisco Med Ctr	2	2	0.3200	0.1700	5000	2015-08-26 00:00:00.000	600	0.5443	1	0.0500	1	176627	2014-10-13 17:06:18.897	0.0000	0	0	2014-10-01 00:00:00.000
1	0.1432	11650	050071	Kaiser Permanente Santa Clara Medical Center	2	2	0.3200	0.1700	19000	2015-08-26 00:00:00.000	600	0.1432	1	0.0500	1	176627	2014-10-13 17:02:42.000	0.0000	0	0	2014-10-01 00:00:00.000
1	0.7239	5273	201315	Stephens Memorial Hospital	2	1	0.4000	0.1700	2300	2012-02-14 09:17:08.257	420	0.7239	0	0.0500	1	179053	2011-08-31 11:11:57.433	0.3973	1460	1	2011-07-01 00:00:00.000
1	0.6379	8193	330238	Nicholas H. Noyes Memorial Hospital	2	2	0.4000	0.1700	2389	2014-03-07 07:56:25.330	420	0.6379	0	0.0500	1	232362	2013-04-15 14:58:18.187	0.0000	0	1	2013-04-01 00:00:00.000
1	0.4536	3065	390184	Highlands Hospital	2	2	0.4000	0.1700	2800	2011-04-02 10:51:04.710	350	0.4536	0	0.0500	1	179053	2010-04-28 13:19:38.800	0.0000	0	1	2010-04-01 00:00:00.000
1	0.7340	8729	390266	Grove City Medical Center	2	1	0.4000	0.1700	2258	2012-01-10 09:40:15.053	420	0.7340	1	0.0500	1	232362	2013-07-11 13:50:10.093	0.3858	1483	1	2013-07-01 00:00:00.000

select MedicareNumber, min(DateCalculated) 
				from MedicareRecalc_History 
				where ProportionCalcPct >= 0.75 and MedicareNumber in ('000007','050070','050071', -- these are 1 and done
																		'201315','330238','390184','390266') -- these are multiple
				group by MedicareNumber

201315	2011-11-11 11:46:24.027
330238	2014-10-27 13:14:46.773
390184	2011-11-09 10:45:11.507
390266	2013-11-05 08:13:52.323

*/