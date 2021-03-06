/****** Object:  StoredProcedure [dbo].[dxv_CreateView]    Script Date: 08/09/2006 14:32:35 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[dxv_CreateView]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[dxv_CreateView]
GO
/****** Object:  StoredProcedure [dbo].[dxv_CreateView]    Script Date: 08/09/2006 14:32:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[dxv_CreateView]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure dxv_CreateView (@SurveyID  int)
/*This procedure prints out a create view statement that can be used to create a view.
Later incarnations will probably create the view on the fly.*/
as
begin
declare @phase int
declare @itemorder int
declare @textorder varchar(1000)
declare @subphase int

declare abc cursor for
select 1 phase,1 itemorder,''x'' textorder,1 subphase,
        ''create view ''+ dbo.dxv_column_name (''xv_'' + name) + '' as
         select
          r.RespondentID,r.SurveyInstanceID,r.FirstName,r.MiddleInitial,
        r.LastName,r.Address1,r.Address2,r.City,r.State,r.PostalCode,
        r.TelephoneDay,r.TelephoneEvening,r.Email,
        r.dob,r.Gender,r.ClientRespondentID,
        r.SSN,r.BatchID,r.MailingSeedFlag,
si.name SurveyInstanceName,
si.InstanceDate SurveyInstanceDate,
si.StartDate SurveyInstanceStartDate,
c.name ClientName,
p.name ProtocolName
'' datext
 from surveys
where surveyID= @SurveyID
union all
select 2 phase, sq.itemOrder,'''', 1 subphase,
  '',dbo.dxv_response_value(r.RespondentID,''+ 
    convert(varchar(10),sq.SurveyquestionID) + 
  '')  as '' + dbo.dxv_column_name (''rv_'' + shortDesc) item
from surveyQuestions sq, questions q
left outer join AnswerCategories ac
on q.QuestionID = ac.QuestionID
where sq.surveyID = @SurveyID
and sq.questionID = q.QuestionID
and q.QuestionTypeID = 1
group by sq.SurveyquestionID,sq.itemOrder,shortdesc
having count(*) >1 -- so if there is one answer category,  skip the value,  and just show the text
union all
select 2 phase, sq.itemOrder,'''', 2 subphase,
  '',dbo.dxv_response_text(r.RespondentID,''+ 
    convert(varchar(10),sq.surveyquestionID) + 
  '')  as '' + dbo.dxv_column_name (''rt_'' + shortDesc) item
from surveyQuestions sq, questions q
where sq.surveyID = @SurveyID
and sq.questionID = q.QuestionID
and q.QuestionTypeID = 1
union all
select 2 phase, sq.itemOrder,'''', 2 subphase,
  '',dbo.dxv_open_text(r.RespondentID,''+ 
    convert(varchar(10),sq.surveyquestionID) + 
  '')  as '' + dbo.dxv_column_name (''ro_'' + shortDesc) item
from surveyQuestions sq, questions q
where sq.surveyID = @SurveyID
and sq.questionID = q.QuestionID
and q.QuestionTypeID = 3
union all
select 2 phase, sq.itemOrder,'''',ac.answerValue subphase,
  '',dbo.dxv_is_selected(r.RespondentID,''+ 
   + convert(varchar(10),ac.answercategoryid) +
  '')  as '' + dbo.dxv_column_name (''rq_'' + substring(shortDesc,1,50) + ''_'' + ac.answerText)
 item
from surveyQuestions sq, questions q,answercategories ac
where sq.surveyID = @SurveyID
and sq.questionID = q.QuestionID
and q.QuestionTypeID = 2
and q.QuestionID = ac.QuestionID
union all
select DISTINCT 3,1,PropertyName,1,
'',dbo.dxv_Respondent_PropertyValue(r.RespondentID,'''''' + PropertyName + '''''')  '' +
    dbo.dxv_column_name (''p_'' + PropertyName)
from respondentProperties rp
where respondentID in (select r.RespondentID
  from
  surveyinstances si,Respondents r
  where si.SurveyID = @SurveyID
  and r.SurveyInstanceID = si.SurveyInstanceID
  )
union all
select 4,1,'''',1,
''from surveyInstances si,protocols p,Clients c,respondents r
where si.SurveyID='' + convert(varchar(10),@SurveyID) + '' 
and si.ProtocolID = p.protocolID
and si.ClientID = c.ClientID
and si.SurveyInstanceID = r.SurveyInstanceID
go''
order by 1,2,3,4

declare @atext varchar(2000)
open abc
fetch abc into @phase,@itemorder,@textorder,@Subphase,@atext
 while @@FETCH_STATUS = 0
   begin
   print @atext
   fetch abc into @phase,@itemorder,@textorder,@Subphase,@atext
   end
close abc
deallocate abc
end


' 
END
GO
GRANT EXECUTE ON [dbo].[dxv_CreateView] TO [reporter]
GO
