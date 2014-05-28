/*********************************************************************************************************
QCL_IsHCAHPSSamplesetCensusForced
Created by Michael Beltz
Date:	4/1/2009
Purpose:	Checks all medicare numbers for the given sampleset(s) to see if any were set to forced census.
			It is called from DCL_ExportCreateFile and used to determine SampleType for the HCAHPS export

Modified:

*********************************************************************************************************/

Create Proc QCL_IsHCAHPSSamplesetCensusForced (@Samplesets varchar(2000))
as
begin
	
declare @SQL varchar(8000)

set @SQL = '
	select	isnull(max(isnull(mrh.censusforced,0)),0)
	from	sampleset ss, sampleplan sp, sampleunit su, suFacility suF, MedicareRecalc_History mrh, SampleSetMedicareCalcLookup ssmcl
	where	ss.sampleplan_ID = sp.sampleplan_ID and
			sp.sampleplan_Id = su.sampleplan_Id and
			su.suFacility_ID = suF.suFacility_ID and 
			suF.MedicareNumber = mrh.MedicareNumber and
			ssmcl.sampleset_ID = ss.sampleset_ID and
			ssmcl.sampleUnit_ID = su.sampleUnit_ID and
			ssmcl.MedicareReCalcLog_ID = mrh.MedicareReCalcLog_ID and
			ss.sampleset_ID in (' + @Samplesets + ')'

    --print @SQL
	exec (@SQL)		
end


