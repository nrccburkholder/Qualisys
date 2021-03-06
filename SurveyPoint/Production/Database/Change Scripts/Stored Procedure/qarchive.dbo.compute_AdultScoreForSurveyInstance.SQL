/****** Object:  StoredProcedure [dbo].[compute_AdultScoreForSurveyInstance]    Script Date: 08/08/2006 15:58:22 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_AdultScoreForSurveyInstance]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[compute_AdultScoreForSurveyInstance]
GO
/****** Object:  StoredProcedure [dbo].[compute_AdultScoreForSurveyInstance]    Script Date: 08/08/2006 15:58:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[compute_AdultScoreForSurveyInstance]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE  procedure compute_AdultScoreForSurveyInstance(@surveyinstanceID int)
as
begin
declare @surveyinstancename varchar(100) -- name of the survey instance
declare @RespondentID int      -- respondent id we are working on

declare @a      int             -- some of the effective colums to be pulled from the respondents table
declare @b      int
declare @c      int
declare @d      int
declare @e      int
declare @f      int
declare @g      int
declare @h      int
declare @noncontrib     int
declare @other  int
declare @none   int
declare @predicted_expenditure  float(53)   -- the calculation






/* This cursor is just used for the whole shebang.  If this was a normal trigger,  the respondents query would be used -- and 
only as it implied towards one respondent */

declare getSurveyinstances cursor for
  select name
from surveyInstances
where surveyinstanceid = @surveyinstanceID
and surveyID in (11,15,16)






-- for each survey instance in this survey
open getsurveyinstances
fetch getsurveyinstances into @SurveyInstanceName
while @@FETCH_STATUS = 0
  begin

  
  print ''survey instance '' + convert(varchar(20),@surveyinstanceid) + '': '' + @Surveyinstancename





/* This cursor looks at each respondent uses the view v_GHS_RespondnetRiskFactors to determine the risk
factors possible.
*/
declare getrespondents cursor for
select respondentID,
    a,
    b,
    c,
    d,
    e,
    f,
    g,
    h,
    noncontrib,
    other,
    none,
    exp(5.057 +
        A * 0.370 +
        B * 0.380 + 
        c * 1.483 + 
        d * 0.456 + 
        e * 0.423 + 
        f * 1.087 - 
        g * 0.416 + 
        h * 1.048) predicted_expenditures
from (
  /* This query looks at the respondent id and any perspective risk factors and then denormalizes the information
  so that one column is specified for each risk factor */
  select r.respondentID,
    sum(case riskFactorTypeID when 1 then 1 else 0 end) a,
    sum(case riskFactorTypeID when 2 then 1 else 0 end) b,
    sum(case riskFactorTypeID when 3 then 1 else 0 end) c,
    sum(case riskFactorTypeID when 4 then 1 else 0 end) d,
    sum(case riskFactorTypeID when 5 then 1 else 0 end) e,
    sum(case riskFactorTypeID when 6 then 1 else 0 end) f,
    case sum(case riskFactorTypeID when 7 then 1 else 0 end) when 1 then 0 else 1 end g,
    sum(case riskFactorTypeID when 8 then 1 else 0 end) h,
    sum(case riskFactorTypeID when 9 then 1 else 0 end) noncontrib,
    sum(case riskFactorTypeID when 10 then 1 else 0 end) other,
    sum(case riskFactorTypeID when 11 then 1 else 0 end) none
  from respondents r
  left outer join v_GHS_RespondentRiskFactors risk
    on r.respondentid = risk.respondentid
  where
    r.surveyinstanceid=@SurveyInstanceID
   and EXISTS (SELECT ''x'' FROM EventLog WHERE EventLog.EventID IN (3002, 3012, 3022, 3032) and EventLog.RespondentID = r.RespondentID)
  group by r.respondentID
) a


  -- Go through each respondent
  open getrespondents
  fetch getrespondents into @RespondentID,@a,@b,@c,@d,@e,@f,@g,@h,@noncontrib,@other,@none,@predicted_expenditure
  while @@fetch_status = 0
    begin
    print ''Respondent '' + convert(varchar(20),@respondentid)

        /* store risk score and risk percentile as respondent properties */
        DECLARE  @property_value varchar(100)
        SET @property_value = CAST(CAST(@predicted_expenditure AS decimal(9,0)) AS varchar(100))
        EXEC dbo.spSetRespondentProperty @RespondentID, ''RISK_SCORE'', @property_value
        SET @property_value = CAST(CAST(dbo.fnGetRiskPercentile(@predicted_expenditure) AS decimal(9,0)) AS varchar(100))
        EXEC dbo.spSetRespondentProperty @RespondentID, ''RISK_PERCENTILE'', @property_value 

        /* store results in RespondentRiskScores table */
    if exists (select 1 from respondentRiskScores where RespondentID=@RespondentID)
      begin
      update respondentRiskScores set
         a=@a,b=@b,c=@c,d=@d,e=@e,f=@f,g=@g,h=@h,
         noncontrib=@noncontrib,other=@other,none=@none,
         predicted_expenditure=@predicted_expenditure
      where respondentID=@respondentID
      end
    else
      begin
      insert into respondentRiskScores(RespondentID,a,b,c,d,e,f,g,h,
                  noncontrib,other,none,
                  predicted_expenditure)
      values (@RespondentID,@a,@b,@c,@d,@e,@f,@g,@h,
                  @noncontrib,@other,@none,
                  @predicted_expenditure)
      end
    

    /* done with the respondent */
    fetch getrespondents into @RespondentID,@a,@b,@c,@d,@e,@f,@g,@h,@noncontrib,@other,@none,@predicted_expenditure
    end
  close getrespondents
  deallocate getrespondents



  /* done with survey instance */
  
  fetch getsurveyinstances into @SurveyInstanceName
  end
close getsurveyinstances
deallocate getsurveyinstances
end;
' 
END
GO
