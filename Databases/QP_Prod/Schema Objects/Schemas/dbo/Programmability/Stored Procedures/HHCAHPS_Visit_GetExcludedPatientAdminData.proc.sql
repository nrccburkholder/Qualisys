-- =============================================
-- Author:		Dana Petersen
-- Create date: 04/30/2013
-- Description:	For on-site HH visit data digging. Returns background data & exclusion data for 
--				excluded patients by sampleset
-- =============================================
CREATE PROCEDURE HHCAHPS_Visit_GetExcludedPatientAdminData 
@sampleset_id int,
@study_id int,
@indebug bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @sql varchar(8000)

set @sql = '
select sel.pop_id, sel.enc_id, sey.samplingexclusiontype_nm, cs.strcriteriastmt_nm
into #excl
from sampling_exclusionlog sel
inner join samplingexclusiontypes sey
on sel.samplingexclusiontype_id = sey.samplingexclusiontype_id
inner join sampleunit su
on sel.sampleunit_id = su.sampleunit_id
left outer join criteriastmt cs
on cs.criteriastmt_id = sel.dq_busrule_id
where su.bithhcahps = 1
and sel.sampleset_id = ' + ltrim(cast(@sampleset_id as varchar)) + '

select ex.*, p.FName, p.LName, convert(date,p.dob,101) as "DOB", e.hhEOMAge, 
e.CCN, e.HHSampleMonth, e.HHSampleYear, e.HHCatAge, p.sex, 
e.hhVisitCnt, e.HHLookbackCnt, 
e.hhadm_hosp, e.hhadm_rehab, e.hhadm_snf, e.hhadm_OthLTC, e.hhadm_OthIP, e.hhadm_Comm,
e.hhpay_Mcare, e.hhpay_mcaid, e.hhpay_ins, e.hhpay_other,
e.HHHMO, e.HHdual, 
e.ICD9, e.ICD9_2, e.ICD9_3, e.ICD9_4, e.ICD9_5, e.ICD9_6,
e.HHSurg, e.hhESRD,
e.hhadl_deficit, hhadl_dressup, hhadl_dresslow, hhadl_bath, hhadl_toilet, hhadl_transfer, p.langid 
from #excl ex,
s' + ltrim(cast(@study_id as varchar)) + '.population p, s' + ltrim(cast(@study_id as varchar)) + '.encounter e
where ex.pop_id = p.pop_id
and ex.enc_id = e.enc_id
and e.pop_id = p.pop_id'

if @indebug = 1 print @sql


exec (@sql)


END


