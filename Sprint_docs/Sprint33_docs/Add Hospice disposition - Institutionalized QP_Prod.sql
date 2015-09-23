

use qp_prod




go


--select * 
--into #std
--from SurveyTypeDispositions

select * from SurveyTypeDispositions t, SurveyType st
where t.SurveyType_ID = st.surveytype_id
and st.SurveyType_dsc = 'Hospice CAHPS'
order by Hierarchy

begin tran
update t
set hierarchy = hierarchy + 1
from SurveyTypeDispositions t, SurveyType st
where t.SurveyType_ID = st.surveytype_id
and st.SurveyType_dsc = 'Hospice CAHPS'
and Hierarchy >= 10

commit tran

select *
from SurveyTypeDispositions
where surveytype_id = 11
order by Hierarchy


begin tran

insert into SurveyTypeDispositions (disposition_id, value, hierarchy, [desc], ExportReportResponses, surveytype_id)
values (24, 14, 10, 'Ineligible: Institutionalized', 0, 11)

commit tran



select *
from SurveyTypeDispositions
where surveytype_id = 11
order by Hierarchy


--select *
--from Disposition

--select *
--from SurveyTypeDispositions
--where surveytype_id = 11

--select *
--from SurveyTypeDispositions
--where SurveyType_ID = @hospiceId

GO
