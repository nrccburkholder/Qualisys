-- =============================================
-- Author:		Dana Petersen
-- Create date: 04/26/2013
-- Description:	For On-Site Visit data digging.
--				Get patient data for eligible patients from study-owned tables
--			1/14/2015 CJB: switched from HCAHPS specific table to new EligibleEncLog table    
-- =============================================
CREATE PROCEDURE [dbo].[HHCAHPS_Visit_GetEligiblePatientAdminData]

@visityear int,
@CCN varchar(6),
@sampmonth int,
@indebug bit = 0 

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @sql varchar(8000)

declare @study_id int, @sampleset_id int

--get the study_id and sampleset_id for the specified CCN & month
select @study_id = study_id,
@sampleset_id = sampleset_id
from temp_dmp_HH_OnSite_CCNs t, temp_dmp_HH_OnSite_Samplesets s
where t.survey_id = s.survey_id
and t.visityear = @visityear
and t.ccn = @ccn
and s.SampleMonth = @sampmonth

if @indebug = 1 print @study_id
if @indebug = 1 print @sampleset_id

set @sql = '
select p.FName, p.LName, convert(date,p.dob,101) as "DOB", e.hhEOMAge, 
e.CCN, e.HHSampleMonth, e.HHSampleYear, e.HHCatAge, p.sex, 
e.hhVisitCnt, e.HHLookbackCnt, 
e.hhadm_hosp, e.hhadm_rehab, e.hhadm_snf, e.hhadm_OthLTC, e.hhadm_OthIP, e.hhadm_Comm,
e.hhpay_Mcare, e.hhpay_mcaid, e.hhpay_ins, e.hhpay_other,
e.HHHMO, e.HHdual, 
e.ICD9, e.ICD9_2, e.ICD9_3, e.ICD9_4, e.ICD9_5, e.ICD9_6,
e.HHSurg, e.hhESRD,
e.hhadl_deficit, hhadl_dressup, hhadl_dresslow, hhadl_bath, hhadl_toilet, hhadl_transfer, p.langid 
from eligibleenclog heel, s' + ltrim(cast(@study_id as varchar)) +
'.population p, s' + ltrim(cast(@study_id as varchar)) + '.encounter e
where heel.pop_id = p.pop_id
and heel.enc_id = e.enc_id
and e.pop_id = p.pop_id
and heel.sampleset_id = ' + ltrim(cast(@sampleset_id as varchar))

if @indebug = 1 print @sql

exec (@sql)


END
