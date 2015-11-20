/*

S38.US1.T2 backpopulate CGCAHPS group and site tool - Rollback.sql

Task 2 - Move CGCHAPS sites and groups from datamart tables into stage for Rachel and 
	flip the QualPro param to turn this on See note on this task..

From Rachel, " I know as a part of this release, any current facility assignments to 
CG CAHPS sample units will be wiped out in order to be associated with the new sites. 
My email is two-fold. One, I understand this this release will need to be put into a 
user story in order to plan the release. Second, is it possible to make a copy of the 
existing facility table prior to the release to have as a backup just in case something 
would happen down the line and we would need this information?"

Chris Burkholder 

UPDATE SampleUnit

UPDATE QualPro_Params

*/

use [qp_prod]
go


begin tran

/**********************************************************
Now restore sufacility_id assignments from backup table
**********************************************************/

update sampleunit set sufacility_id = cgcfar.SUFacility_id
--select distinct su.SampleUnit_id, su.StrSampleUnit_nm, cgcfar.SUFacility_id, cgcfar.strfacility_nm
from sampleunit su 
inner join CGCAHPS2015FacilityAssignmentsReplaced cgcfar on su.SAMPLEUNIT_ID = cgcfar.sampleunit_id
GO

update Qualpro_params set strparam_value = 0 --turn it back off for Rollback
--select * from QualPro_Params
where strparam_nm = 'SurveyRule: FacilitiesArePracticeSites - CGCAHPS'

--rollback tran

commit tran