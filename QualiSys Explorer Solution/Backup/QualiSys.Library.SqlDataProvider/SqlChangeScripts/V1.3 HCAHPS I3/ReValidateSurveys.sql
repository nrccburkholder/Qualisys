if object_id('tempdb..#Surveymessages') is not null Drop Table #Surveymessages
create table #Surveymessages (survey_id int, error int, strmessage varchar(200))

if object_id('tempdb..#HCAHPSSurveys') is not null Drop Table #HCAHPSSurveys 

declare @survey int, @startdate datetime

set @startdate=getdate()

select survey_id
into #HCAHPSSurveys
from survey_def
where surveytype_id=2

--Unvalidate all HCAHPS surveys
update survey_def
set bitvalidated_flg=0
where survey_id in 
	(select survey_id
		from #HCAHPSSurveys)

select top 1 @survey=survey_id
from #HCAHPSSurveys

while @@rowcount>0
begin
	exec QCL_ValidateSurvey @survey

	delete
	from #HCAHPSSurveys
	where survey_id=@survey

	select top 1 @survey=survey_id
	from #HCAHPSSurveys
	
end

insert #surveyMessages 
select Survey_id, Error, strMessage
from SurveyValidationResults
where datran >=@startdate 
	and	survey_id in (select survey_id  
					from survey_def
					where surveytype_id=2)
	and error >0

--Validate all HCAHPS surveys that had no errors
update survey_def
set bitvalidated_flg=1,
	datValidated=getdate()
where survey_id not in 
	(select survey_id
		from #surveyMessages
		where error=1)
	and surveytype_id=2


--Report of Valid surveys
select c.strclient_nm, st.strstudy_nm, sd.strsurvey_nm, 
	sm.survey_id, 
	case error
		when 1 then 'Error'
		when 2 then 'Warning'
	end as MessageType,
	strmessage
from #surveyMessages sm, survey_def sd, study st, client c
where sm.survey_id not in 
	(select survey_id
		from #surveyMessages
		where error=1)
	and sm.survey_id=sd.survey_id
	and sd.study_id=st.study_id
	and st.client_id=c.client_id
	and sd.surveytype_id=2


--Report of InValid surveys
select c.strclient_nm, st.strstudy_nm, sd.strsurvey_nm, 
	sm.survey_id, 
	case error
		when 1 then 'Error'
		when 2 then 'Warning'
	end as MessageType,
	strmessage
from #surveyMessages sm, survey_def sd, study st, client c
where sm.survey_id in 
	(select survey_id
		from #surveyMessages
		where error=1)
	and sm.survey_id=sd.survey_id
	and sd.study_id=st.study_id
	and st.client_id=c.client_id
	and sd.surveytype_id=2




