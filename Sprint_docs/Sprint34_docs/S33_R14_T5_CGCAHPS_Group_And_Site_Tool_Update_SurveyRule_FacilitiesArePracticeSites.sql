/*

-- =============================================
-- S33_R14_T5_CGCAHPS_Group_And_Site_Tool_QCL_SelectAllFacilities.sql
-- Create date: August, 2015
-- Description:	Update QUALPro_Param SurveyRule: FacilitiesArePracticeSites - CGCAHPS to turn feature ON


*/

begin tran

update Qualpro_params 
	SET STRPARAM_VALUE = 1
where strparam_nm = 'SurveyRule: FacilitiesArePracticeSites - CGCAHPS'

commit tran