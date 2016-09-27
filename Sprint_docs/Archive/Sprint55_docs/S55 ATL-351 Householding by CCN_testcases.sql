

if object_id('tempdb..#SampleUnit_Universe') is not null
	drop table #SampleUnit_Universe 

CREATE TABLE #SampleUnit_Universe (id_num INT IDENTITY ,
                                    SampleUnit_id INT ,
                                    Pop_id INT ,
                                    Enc_id INT ,
                                    Age INT ,
                                    DQ_Bus_Rule INT ,
                                    Removed_Rule INT DEFAULT 0 ,
                                    strUnitSelectType VARCHAR(1) ,
                                    EncDate DATETIME ,
                                    ReSurveyDate DATETIME ,
                                    HouseHold_id INT ,
                                    bitBadAddress BIT DEFAULT 0 ,
                                    bitBadPhone BIT DEFAULT 0 ,
                                    reportDate DATETIME ,
									POPULATIONAddr VARCHAR(60),
									POPULATIONCity VARCHAR(42),
									POPULATIONST VARCHAR(2),
									POPULATIONZIP5 VARCHAR(5),
									POPULATIONAddr2 VARCHAR(42))

CREATE INDEX idx_SUUniv_PopID ON #SampleUnit_Universe (Pop_ID)
CREATE INDEX idx_SUUniv_EncID ON #SampleUnit_Universe (Enc_ID)
	  
-- one household, eligible for two hcahps units
insert into #sampleunit_universe (SampleUnit_id, Pop_id, Enc_id, Age, DQ_Bus_Rule, Removed_Rule, strUnitSelectType, EncDate, bitBadAddress, bitBadPhone, reportDate, POPULATIONAddr, POPULATIONCity, POPULATIONST, POPULATIONZIP5, POPULATIONAddr2) 
values (170634, 74948,494669,64,0,0,'N','Mar 26 2016 12:00AM',0,0,'Mar 26 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) -- TMC Adult Inpatient
	 , (170649, 74948,494669,64,0,0,'N','Mar 26 2016 12:00AM',0,0,'Mar 26 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) --	Lakewood Inpatient
	 , (170653, 74948,494669,64,0,0,'N','Mar 26 2016 12:00AM',0,0,'Mar 26 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) --		Lakewood_ICU
	 , (170650, 74948,494669,64,0,0,'N','Mar 26 2016 12:00AM',0,0,'Mar 26 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) --		Lakewood_HCAHPS
	 , (170634,258584,495359,64,0,0,'N','Mar 29 2016 12:00AM',0,0,'Mar 29 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) -- TMC Adult Inpatient
	 , (170635,258584,495359,64,0,0,'N','Mar 29 2016 12:00AM',0,0,'Mar 29 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) --	Hospital Hill Inpatient
	 , (170636,258584,495359,64,0,0,'N','Mar 29 2016 12:00AM',0,0,'Mar 29 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) --		HH_HCAHPS
	 , (170641,258584,495359,64,0,0,'N','Mar 29 2016 12:00AM',0,0,'Mar 29 2016 12:00AM','2MbrHH, 2HCAHPS','INDEPENDENCE','MO','64050',null) --		HH_4 Gold

-- one household, eligible for one hcahps unit, but in two hospitals
insert into #sampleunit_universe (SampleUnit_id, Pop_id, Enc_id, Age, DQ_Bus_Rule, Removed_Rule, strUnitSelectType, EncDate, bitBadAddress, bitBadPhone, reportDate, POPULATIONAddr, POPULATIONCity, POPULATIONST, POPULATIONZIP5, POPULATIONAddr2) 
values (170634,167037,494212,60,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64139',null) -- TMC Adult Inpatient
	 , (170649,167037,494212,60,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64139',null) --		Lakewood Inpatient
	 , (170650,167037,494212,60,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64139',null) --			Lakewood_HCAHPS
	 , (170653,167037,494212,60,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64139',null) --			Lakewood_ICU
 	 , (170634,390238,496044,84,0,0,'N','Mar 26 2016 12:00AM',0,0,'Mar 26 2016 12:00AM','2MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64139',null) -- TMC Adult Inpatient
	 , (170635,390238,496044,84,0,0,'N','Mar 26 2016 12:00AM',0,0,'Mar 26 2016 12:00AM','2MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64139',null) --		Hospital Hill Inpatient
	 , (170643,390238,496044,84,0,0,'N','Mar 26 2016 12:00AM',0,0,'Mar 26 2016 12:00AM','2MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64139',null) --			HH_4 Red

-- one household, two members eligible for the same hcahps unit, twice
insert into #sampleunit_universe (SampleUnit_id, Pop_id, Enc_id, Age, DQ_Bus_Rule, Removed_Rule, strUnitSelectType, EncDate, bitBadAddress, bitBadPhone, reportDate, POPULATIONAddr, POPULATIONCity, POPULATIONST, POPULATIONZIP5, POPULATIONAddr2) 
values (170634,272720,494914,81,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) -- TMC Adult Inpatient
	 , (170635,272720,494914,81,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) --	Hospital Hill Inpatient
	 , (170636,272720,494914,81,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) --		HH_HCAHPS
	 , (170640,272720,494914,81,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) --		HH_4 Blue
	 , (170634,274287,494916,58,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) -- TMC Adult Inpatient
	 , (170635,274287,494916,58,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) --	Hospital Hill Inpatient
	 , (170636,274287,494916,58,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) --		HH_HCAHPS
	 , (170640,274287,494916,58,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','2MbrHH, 1Hosp, BothSameHCAHPS','KANSAS CITY','MO','64130',null) --		HH_4 Blue

-- one household, eligible for no hcahps units, and in two hospitals
insert into #sampleunit_universe (SampleUnit_id, Pop_id, Enc_id, Age, DQ_Bus_Rule, Removed_Rule, strUnitSelectType, EncDate, bitBadAddress, bitBadPhone, reportDate, POPULATIONAddr, POPULATIONCity, POPULATIONST, POPULATIONZIP5, POPULATIONAddr2) 
values (170634,495640,495642,83,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','2MbrHH, 2Hosps, 0HCAHPS','LEES SUMMIT','MO','64063',null) -- TMC Adult Inpatient
	 , (170635,495640,495642,83,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','2MbrHH, 2Hosps, 0HCAHPS','LEES SUMMIT','MO','64063',null) --	Hospital Hill Inpatient
	 , (170644,495640,495642,83,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','2MbrHH, 2Hosps, 0HCAHPS','LEES SUMMIT','MO','64063',null) --		HH_CCU
	 , (170634,420188,491937,83,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','2MbrHH, 2Hosps, 0HCAHPS','LEES SUMMIT','MO','64063',null) -- TMC Adult Inpatient
	 , (170649,420188,491937,83,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','2MbrHH, 2Hosps, 0HCAHPS','LEES SUMMIT','MO','64063',null) --	Lakewood Inpatient
	 , (170653,420188,491937,83,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','2MbrHH, 2Hosps, 0HCAHPS','LEES SUMMIT','MO','64063',null) --		Lakewood_ICU

-- one patient, 2 hospitals, 1 hcahps unit
insert into #sampleunit_universe (SampleUnit_id, Pop_id, Enc_id, Age, DQ_Bus_Rule, Removed_Rule, strUnitSelectType, EncDate, bitBadAddress, bitBadPhone, reportDate, POPULATIONAddr, POPULATIONCity, POPULATIONST, POPULATIONZIP5, POPULATIONAddr2) 
values (170634,470629,495618,52,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','1MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64133',null) -- TMC Adult Inpatient
	 , (170635,470629,495618,52,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','1MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64133',null) --	Hospital Hill Inpatient
	 , (170640,470629,495618,52,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','1MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64133',null) --		HH_4 Blue
	 , (170634,470629,495614,52,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','1MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64133',null) -- TMC Adult Inpatient
	 , (170649,470629,495614,52,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','1MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64133',null) --	Lakewood Inpatient
	 , (170650,470629,495614,52,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','1MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64133',null) --		Lakewood_HCAHPS
	 , (170656,470629,495614,52,0,0,'N','Mar 28 2016 12:00AM',0,0,'Mar 28 2016 12:00AM','1MbrHH, 2Hosps, 1HCAHPS','KANSAS CITY','MO','64133',null) --		Lakewood_MSS
	 
-- one patient, 2 hospitals, 2 hcahps unit
insert into #sampleunit_universe (SampleUnit_id, Pop_id, Enc_id, Age, DQ_Bus_Rule, Removed_Rule, strUnitSelectType, EncDate, bitBadAddress, bitBadPhone, reportDate, POPULATIONAddr, POPULATIONCity, POPULATIONST, POPULATIONZIP5, POPULATIONAddr2) 
values (170634,473995,494213,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) -- TMC Adult Inpatient
	 , (170635,473995,494213,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) --		Hospital Hill Inpatient
	 , (170636,473995,494213,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) --			HH_HCAHPS
	 , (170638,473995,494213,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) --			HH_3 Gold
	 , (170634,473995,494214,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) -- TMC Adult Inpatient
	 , (170649,473995,494214,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) --		Lakewood Inpatient
	 , (170650,473995,494214,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) --			Lakewood_HCAHPS
	 , (170655,473995,494214,49,0,0,'N','Mar 31 2016 12:00AM',0,0,'Mar 31 2016 12:00AM','1MbrHH, 2Hosps, 2HCAHPS','INDEPENDENCE','MO','64052',null) --			Lakewood_MSN
	 
-- one patient, 2 hospitals, 0 hcahps unit
insert into #sampleunit_universe (SampleUnit_id, Pop_id, Enc_id, Age, DQ_Bus_Rule, Removed_Rule, strUnitSelectType, EncDate, bitBadAddress, bitBadPhone, reportDate, POPULATIONAddr, POPULATIONCity, POPULATIONST, POPULATIONZIP5, POPULATIONAddr2) 
values (170634,475741,492479,24,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','1MbrHH, 2Hosps, 0HCAHPS','KANSAS CITY','MO','64106',null) -- TMC Adult Inpatient
	 , (170635,475741,492479,24,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','1MbrHH, 2Hosps, 0HCAHPS','KANSAS CITY','MO','64106',null) --		Hospital Hill Inpatient
	 , (170640,475741,492479,24,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','1MbrHH, 2Hosps, 0HCAHPS','KANSAS CITY','MO','64106',null) --			HH_4 Blue
	 , (170634,475741,492480,24,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','1MbrHH, 2Hosps, 0HCAHPS','KANSAS CITY','MO','64106',null) -- TMC Adult Inpatient
	 , (170649,475741,492480,24,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','1MbrHH, 2Hosps, 0HCAHPS','KANSAS CITY','MO','64106',null) --		Lakewood Inpatient
	 , (170654,475741,492480,24,0,0,'N','Mar 25 2016 12:00AM',0,0,'Mar 25 2016 12:00AM','1MbrHH, 2Hosps, 0HCAHPS','KANSAS CITY','MO','64106',null) --			Lakewood_MOM


Exec [QCL_SampleSetAssignHouseHold]
 @strHouseholdField_CreateTable='POPULATIONAddr VARCHAR(60),POPULATIONCity VARCHAR(42),POPULATIONST VARCHAR(2),POPULATIONZIP5 VARCHAR(5),POPULATIONAddr2 VARCHAR(42)',
 @strHouseholdField_Select	   =' X.POPULATIONAddr, X.POPULATIONCity, X.POPULATIONST, X.POPULATIONZIP5, X.POPULATIONAddr2',
 @strHousehold_Join    		   =' X.POPULATIONAddr=Y.POPULATIONAddr AND  X.POPULATIONCity=Y.POPULATIONCity AND  X.POPULATIONST=Y.POPULATIONST AND  X.POPULATIONZIP5=Y.POPULATIONZIP5 AND  X.POPULATIONAddr2=Y.POPULATIONAddr2',
 @HouseHoldingType='A'


if object_id('tempdb..#su') is not null
	drop table #su

select sampleunit_id, parentsampleunit_id, strSampleunit_nm, MedicareNumber, -1 as tier
into #su
from sampleunit su
left join sufacility suf on su.sufacility_id=suf.sufacility_id
where sampleplan_id=12607

update #su set tier=0 where PARENTSAMPLEUNIT_ID is null
update #su set tier=1 where parentsampleunit_id in (select sampleunit_id from #su where tier=0)
update #su set tier=2 where parentsampleunit_id in (select sampleunit_id from #su where tier=1)
update #su set strSampleunit_nm = replicate(' ', tier*4) + STRSAMPLEUNIT_NM

select ''''+su.STRSAMPLEUNIT_NM, su.MedicareNumber, suu.SampleUnit_id, suu.pop_id, suu.Enc_id, suu.Household_id, suu.populationaddr, suu.POPULATIONCity, suu.POPULATIONST, suu.POPULATIONZIP5
from #SampleUnit_Universe suu
inner join #su su on suu.SampleUnit_id=su.SAMPLEUNIT_ID
order by populationaddr, suu.enc_id, household_id, sampleunit_id
