
use [IlluminateScrub_ca]

select *
FROM [IlluminateScrub_ca].[dbo].[Questions]
order by Questionid

select q.*, rq.ReportingQuestionText
FROM [IlluminateScrub_ca].[dbo].[Questions] q
inner join [IlluminateScrub_ca].[dbo].[ReportingQuestions] rq on rq.ReportingQuestionID = q.ReportingQuestionID
order by rq.ReportingQuestionText, q.QuestionID


select distinct ReportingQuestionID
FROM [IlluminateScrub_ca].[dbo].[Questions]
GROUP BY ReportingQuestionID
having count(*) > 1


select q.*, rq.ReportingQuestionText
FROM [IlluminateScrub_ca].[dbo].[Questions] q
inner join [IlluminateScrub_ca].[dbo].[ReportingQuestions] rq on rq.ReportingQuestionID = q.ReportingQuestionID
where q.ReportingQuestionID in (
	select distinct ReportingQuestionID
	FROM [IlluminateScrub_ca].[dbo].[Questions]
	GROUP BY ReportingQuestionID
	having count(*) > 1
)
order by q.ReportingQuestionID, q.Questionid

SELECT [ReportingQuestionID]
      ,[ReportingQuestionText]
  FROM [IlluminateScrub_ca].[dbo].[ReportingQuestions]

/*

delete FROM [IlluminateScrub_ca].[dbo].[ReportingQuestions]
where reportingquestionid > 100001

*/


select distinct q.* , qd.DomainName, qt.QuestionTypeDescription, rq.ReportingQuestionText, s.QuestionID,s.ApplicationName, s.SurveyName
FROM [IlluminateScrub_ca].[dbo].[Questions] q
inner join [IlluminateScrub_ca].[dbo].[ReportingQuestions] rq on rq.ReportingQuestionID = q.ReportingQuestionID
inner join [IlluminateScrub_ca].[dbo].[QuestionDomains] qd on qd.QuestionDomainID = q.QuestionDomainID
inner join [IlluminateScrub_ca].[dbo].[QuestionTypes] qt on qt.QuestionTypeID = q.QuestionTypeID
left join (
	SELECT sq.QuestionID, st.SurveyName, a.ApplicationName 
	FROM [IlluminateScrub_ca].[dbo].[SurveyQuestions] sq 
	inner join [IlluminateScrub_ca].[dbo].[SurveyTypes] st on st.SurveyTypeID = sq.SurveyTypeID
	inner join [IlluminateScrub_ca].[dbo].[Applications] a on a.ApplicationID = st.ApplicationID ) s on s.QuestionID = q.QuestionID
order by q.QuestionID , s.SurveyName, s.ApplicationName



select distinct q.*, qd.DomainName, qt.QuestionTypeDescription, rq.ReportingQuestionText, s.QuestionID,s.ApplicationName, s.SurveyName
FROM [IlluminateScrub_ca].[dbo].[Questions] q
inner join [IlluminateScrub_ca].[dbo].[ReportingQuestions] rq on rq.ReportingQuestionID = q.ReportingQuestionID
inner join [IlluminateScrub_ca].[dbo].[QuestionDomains] qd on qd.QuestionDomainID = q.QuestionDomainID
inner join [IlluminateScrub_ca].[dbo].[QuestionTypes] qt on qt.QuestionTypeID = q.QuestionTypeID
left join (
	SELECT sq.QuestionID, st.SurveyName, a.ApplicationName 
	FROM [IlluminateScrub_ca].[dbo].[SurveyTypeQuestionsConfig] sq 
	inner join [IlluminateScrub_ca].[dbo].[SurveyTypes] st on st.SurveyTypeID = sq.SurveyTypeID
	inner join [IlluminateScrub_ca].[dbo].[Applications] a on a.ApplicationID = st.ApplicationID ) s on s.QuestionID = q.QuestionID
order by q.QuestionID, s.SurveyName, s.ApplicationName



select csq.*
from [IlluminateScrub_ca].[dbo].[ClientSurveyQuestions] csq
where csq.questionid in (
	select distinct q.questionid
	FROM [IlluminateScrub_ca].[dbo].[Questions] q
	inner join [IlluminateScrub_ca].[dbo].[ReportingQuestions] rq on rq.ReportingQuestionID = q.ReportingQuestionID
	inner join [IlluminateScrub_ca].[dbo].[QuestionDomains] qd on qd.QuestionDomainID = q.QuestionDomainID
	inner join [IlluminateScrub_ca].[dbo].[QuestionTypes] qt on qt.QuestionTypeID = q.QuestionTypeID
	left join (
		SELECT sq.QuestionID, st.SurveyName, a.ApplicationName 
		FROM [IlluminateScrub_ca].[dbo].[SurveyQuestions] sq 
		inner join [IlluminateScrub_ca].[dbo].[SurveyTypes] st on st.SurveyTypeID = sq.SurveyTypeID
		inner join [IlluminateScrub_ca].[dbo].[Applications] a on a.ApplicationID = st.ApplicationID ) s on s.QuestionID = q.QuestionID
	where s.QuestionID is null
)

select s.*, st.*, sq.*
from [dbo].[Surveys] s
inner join [dbo].[SurveyTypes] st on st.SurveyTypeID = s.SurveyTypeID
left join [dbo].[SurveyQuestions] sq on sq.SurveyTypeID = s.SurveyTypeID
where surveyid = 2100

select *
from [dbo].[SurveyTypeQuestionsConfig] sq
where sq.questionid = 142