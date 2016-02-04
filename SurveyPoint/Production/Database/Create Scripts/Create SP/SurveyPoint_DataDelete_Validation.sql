
select top 50 respondentID 
into #tmpResp
from respondents 
where surveyInstanceID = 4016
order by respondentID

select 'Respondent', Resps.*, 'RespProperties', RP.*, 'Responses', R.*, 'EventLog', EL.*
from respondents Resps, Respondentproperties RP, Responses R, EventLog EL
where Resps.RespondentID = RP.RespondentID and
Resps.RespondentID = EL.RespondentID and
Resps.RespondentID = R.RespondentID and
Resps.RespondentID in (select respondentID from #tmpResp)
