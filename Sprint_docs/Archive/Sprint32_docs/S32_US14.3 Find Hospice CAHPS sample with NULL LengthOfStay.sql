/*
	S32 US14	Hospice LOS DQ Rule Update
				Story: As a certified Hospice CAHPS vendor, we want to refrain from sampling decedents that don’t have an admission date, so that we can administer and submit the survey properly.

	14.3		find any Hospice CAHPS patients that were sampled that should have been DQ'd
				refer to James and Ruta on found names

Dave Gilsdorf

QP_Prod:
select from s#.encounter, SELECTEDSAMPLE, sampleset 

*/
use qp_prod

declare @SQL varchar(max)='!'

select @sql=@SQL + 'union 
select sel.study_id, ss.survey_id, ss.sampleset_id, ss.datSampleCreate_dt, e.pop_id, e.enc_id, e.admitDate, e.LengthOfStay
from s'+convert(varchar,sd.study_id)+'.encounter e
inner join SELECTEDSAMPLE sel on e.pop_id=sel.pop_id and sel.study_id='+convert(varchar,sd.study_id)+' and sel.enc_id=e.enc_id
inner join sampleset ss on sel.sampleset_id=ss.sampleset_id
where ss.survey_id='+convert(varchar,SD.survey_ID)+'
and isnull(e.LengthOfStay,0)<2'
from survey_def sd
inner join surveytype st on sd.surveytype_id=st.surveytype_id
where surveytype_dsc='Hospice CAHPS'
and sd.study_id in (select study_id from metadata_view where strTable_nm='encounter' and strField_nm='LengthOfStay')
and sd.study_id in (select study_id from metadata_view where strTable_nm='encounter' and strField_nm='admitDate')

set @SQL = replace(@SQL,'!union','')

exec (@SQL)

