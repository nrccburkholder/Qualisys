/*
	S72 ATL-1430 Update DTS Packages to Use OASEligibleSurg.sql

	Chris Burkholder

	4/7/2017

	UPDATE dbo.DESTINATION SET FORMULA...

*/
USE [QP_LOAD]
GO

begin tran

--First add G_CODE_1 or any other in use (total to account for is 135, not counting 4 blank) in STAGE

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("G_CODE_1"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"G_CODE_1"%'
--117

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("G_CODE"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula NOT like '%"G_CODE_1"%'
and d2.formula like '%"G_CODE"%' --"G_Code", "G Code", "HCPS 1", "HCPCS Level ll", "GCode1", "CPTG1", "gcode_1", "G_ Code_1"
--9

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("G Code"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"G Code"%' -- "HCPS 1", "HCPCS Level ll", "GCode1", "CPTG1", "gcode_1", "G_ Code_1"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("HCPS 1"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"HCPS 1"%' -- "HCPCS Level ll", "GCode1", "CPTG1", "gcode_1", "G_ Code_1"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("HCPCS Level ll"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"HCPCS Level ll"%' -- "GCode1", "CPTG1", "gcode_1", "G_ Code_1"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("GCode1"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"GCode1"%' -- "CPTG1", "gcode_1", "G_ Code_1"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("CPTG1"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"CPTG1"%' -- "gcode_1", "G_ Code_1"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("gcode_1"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"gcode_1"%' -- , "G_ Code_1"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),DTSSource("G_ Code_1"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%"G_ Code_1"%' 
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(Replace(d.formula, 'OAScahpsCPTCodesValid', 'OASEligibleSurg'), '))', '),(dbnull))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d2.formula like '%dbnull%' 
--2

--Next add G_CODE_2 or any other in use (total to account for is 134, not counting 5 blank) in STAGE

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("G_CODE_2"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d3.formula like '%"G_CODE_2"%' 
--117

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("HCPS 2"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d3.formula like '%"HCPS 2"%' --"GCode2","CPTG2","gcode_2"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("GCode2"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d3.formula like '%"GCode2"%' --,"CPTG2","gcode_2"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("CPTG2"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d3.formula like '%"CPTG2"%' --,,"gcode_2"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("gcode_2"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d3.formula like '%"gcode_2"%' --,,"gcode_2"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),(dbnull))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d3.formula not like '%"G_CODE_2"%' 
and d3.formula not like '%"HCPS 2"%' --"GCode2","CPTG2","gcode_2"
and d3.formula not like '%"GCode2"%' --"CPTG2","gcode_2"
and d3.formula not like '%"CPTG2"%' --"gcode_2"
and d3.formula not like '%"gcode_2"%' --
and d3.formula <> ''
--13

--Next add G_CODE_3 or any other in use (total to account for is 134, not counting 5 blank) in STAGE

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("G_CODE_3"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d4.formula like '%"G_CODE_3"%' 
--117

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("G_CODE3"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d4.formula like '%"G_CODE3"%' 
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("HCPS 3"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d4.formula like '%"HCPS 3"%' 
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("GCode3"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d4.formula like '%"GCode3"%' --,"CPTG2","gcode_2"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("CPTG3"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d4.formula like '%"CPTG3"%' --,,"gcode_2"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),DTSSource("gcode_3"))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d4.formula like '%"gcode_3"%' --,,"gcode_2"
--1

update d set formula = 
--select d2.formula HCPCS1, d3.formula HCPCS2, d4.formula HCPCS3, d.formula, 
Replace(d.formula, '))', '),(dbnull))') 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770
and d4.formula not like '%"G_CODE_3"%' 
and d4.formula not like '%"G_CODE3"%' 
and d4.formula not like '%"HCPS 3"%' 
and d4.formula not like '%"GCODE3"%' 
and d4.formula not like '%"CPTG3"%' 
and d4.formula not like '%"gcode_3"%' 
and d4.formula <> ''
--12

select d.formula 
from destination d left join
	destination d2 on d.package_id = d2.package_id and d.table_id = d2.table_id and d.intversion = d2.intversion left join
	destination d3 on d.package_id = d3.package_id and d.table_id = d3.table_id and d.intversion = d3.intversion left join
	destination d4 on d.package_id = d4.package_id and d.table_id = d4.table_id and d.intversion = d4.intversion
where d.field_id = 1774 and d2.field_id = 1768 and d3.field_id = 1769 and d4.field_id = 1770

--rollback tran

commit tran

GO