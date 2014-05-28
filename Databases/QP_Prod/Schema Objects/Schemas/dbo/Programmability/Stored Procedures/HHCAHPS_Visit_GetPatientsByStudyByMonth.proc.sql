-- =============================================
-- Author:		Dana Petersen
-- Create date: 04/30/2013
-- Description:	For HH on-site visit
--				Get HH-related fields from study tables for specific month
-- =============================================
CREATE PROCEDURE HHCAHPS_Visit_GetPatientsByStudyByMonth 
	@study_id int, 
	@servicedate varchar(10),
	@indebug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
declare @sql varchar(8000)

set @sql = 
'select p.FName, p.LName, convert(date,p.dob,101) as "DOB", e.hhEOMAge, 
e.CCN, e.HHSampleMonth, e.HHSampleYear, e.HHCatAge, p.sex, 
e.hhVisitCnt, e.HHLookbackCnt, 
e.hhadm_hosp, e.hhadm_rehab, e.hhadm_snf, e.hhadm_OthLTC, e.hhadm_OthIP, e.hhadm_Comm,
e.hhpay_Mcare, e.hhpay_mcaid, e.hhpay_ins, e.hhpay_other,
e.HHHMO, e.HHdual, 
e.ICD9, e.ICD9_2, e.ICD9_3, e.ICD9_4, e.ICD9_5, e.ICD9_6,
e.HHSurg, e.hhESRD,
e.hhadl_deficit, hhadl_dressup, hhadl_dresslow, hhadl_bath, hhadl_toilet, hhadl_transfer, p.langid 
from s' + ltrim(cast(@study_id as varchar)) + '.population p, s' + ltrim(cast(@study_id as varchar)) +
'.encounter e
where e.pop_id = p.pop_id
and e.servicedate = ''' + @servicedate + ''''

if @indebug = 1 print @sql

exec (@sql)

END


