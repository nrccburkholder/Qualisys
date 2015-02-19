CREATE proc [dbo].[GetHcahpsModeExperimentData] 
	@samplesets varchar(1000)
as

declare @sql varchar(8000)
declare @study varchar(10)

select @samplesets = replace(@samplesets,' ', '')
if isnumeric(replace(@samplesets, ',', '')) = 0 
begin
	print 'Input string has non-numeric characters.  Exiting...'
	return
end


create table #samplesets (
	sampleset_id int,
	sampleunit_id int,
	study_id int,
	medicarenumber varchar(20),
	strfacility_nm varchar(100)
)

select @sql = 'insert into #Samplesets
select sst.SAMPLESET_ID, su.SAMPLEUNIT_ID, sd.STUDY_ID, suf.MedicareNumber, suf.strFacility_nm 
from SAMPLESET sst, SURVEY_DEF sd, SAMPLEPLAN spl, SAMPLEUNIT su, SUFacility suf
where sst.SURVEY_ID = sd.SURVEY_ID
and sd.SURVEY_ID = spl.SURVEY_ID
and spl.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
and su.SUFacility_id = suf.SUFacility_id
and su.bitHCAHPS = 1
and sst.SAMPLESET_ID in (' + @samplesets + ')'

exec(@sql)

if (select count(distinct study_id) from #samplesets) > 1
begin
	print 'Input string has samplesets from more than one study.  Exiting...'
	return
end

select top 1 @study = cast(study_id as varchar) from #samplesets

select heel.pop_id, heel.enc_id, heel.sampleset_id, heel.sampleunit_id
into #EligibleEncs 
from #Samplesets tss
join EligibleEncLog heel
on tss.sampleset_id = heel.sampleset_id
and tss.sampleunit_id = heel.sampleunit_id
left outer join SAMPLEPOP sp
on sp.SAMPLESET_ID = tss.sampleset_id
and sp.SAMPLESET_ID = heel.sampleset_id
and sp.POP_ID = heel.pop_id
where sp.SAMPLEPOP_ID is null


select @sql = 
'select	
	left(isnull(MedicareNumber,'''')+space(6),6) +
	left(isnull(tss.strfacility_nm,'''')+space(100),100) +
	left(isnull(MRN,'''')+space(42),42) +
	left(isnull(FName,'''')+space(42),42) +
	left(isnull(LName,'''')+space(42),42) +
	left(isnull(Addr,'''')+space(60),60) +
	left(isnull(Addr2,'''')+space(42),42) +
	left(isnull(City,'''')+space(42),42) +
	left(isnull(ST,'''')+space(2),2) +
	left(isnull(Zip5,'''')+space(5),5) +
	left(isnull(Zip4,'''')+space(4),4) +
	left(isnull(Del_Pt,'''')+space(3),3) +
	left(isnull(AreaCode,'''')+space(3),3) +
	left(isnull(Phone,'''')+space(10),10) +
	case when isdate(DOB) = 0
		then space(10)
		else left(convert(varchar, DOB, 120), 10) 
	end +
	left(isnull(cast(HAdmitAge as varchar(3)),'''')+space(3),3) +
	left(isnull(HCatAge,'''')+space(2),2) +
	left(isnull(Sex,'''')+space(1),1) +
	left(isnull(VisitNum,'''')+space(42),42) +
	case when isdate(AdmitDate) = 0
		then space(10)
		else left(convert(varchar, AdmitDate, 120), 10) 
	end +
	case when isdate(DischargeDate) = 0
		then space(10)
		else left(convert(varchar, DischargeDate, 120), 10) 
	end +
	left(isnull(cast(LOSCheck as varchar(4)),'''')+space(4),4) +
	left(isnull(HAdmissionSource,'''')+space(2),2) +
	left(isnull(HDischargeStatus,'''')+space(2),2) +
	left(isnull(HServiceType,'''')+space(1),1) +
	left(isnull(MSDRG,'''')+space(3),3) +
	left(isnull(HServiceDes,'''')+space(1),1) 
from S' + @study + '.POPULATION p, S' + @study + '.ENCOUNTER e, #EligibleEncs tee, #Samplesets tss
where p.pop_id = e.pop_id
and p.pop_id = tee.pop_id
and e.enc_id = tee.enc_id
and tss.sampleset_id = tee.sampleset_id
and tss.sampleunit_id = tee.sampleunit_id'

exec(@sql)

drop table #Samplesets
drop table #EligibleEncs

