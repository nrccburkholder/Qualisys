/****** Object:  StoredProcedure [dbo].[update_SeniorHealthUniverseMetrics]    Script Date: 08/09/2006 09:10:29 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SeniorHealthUniverseMetrics]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[update_SeniorHealthUniverseMetrics]
GO
/****** Object:  StoredProcedure [dbo].[update_SeniorHealthUniverseMetrics]    Script Date: 08/09/2006 09:10:29 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[update_SeniorHealthUniverseMetrics]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'

CREATE  PROCEDURE [dbo].[update_SeniorHealthUniverseMetrics] AS
BEGIN

DECLARE @total int
DECLARE @total_deceased int
DECLARE @total_received int
DECLARE @total_gender int
DECLARE @males int
DECLARE @females int

-- calculate total surveys sent
set select @total = count(distinct a11.RespondentID) 
from Respondents a11
	join vr_RespondentEventLog a12
	on  (a11.RespondentID = a12.RespondentID)
	join vr_SurveyInstances a13
	on  (a11.SurveyInstanceID = a13.SurveyInstanceID)
where (a12.RespondentEventID in (4000)
and a13.SurveyID in (24, 8, 31)) 

UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@total as varchar(100))
	WHERE metric_name = ''SURVEYS_SENT''

-- calculate total disenrolled and deceased
set select @total_deceased = count(distinct a11.RespondentID) 
from Respondents a11
	join vr_RespondentEventLog a12
	on  (a11.RespondentID = a12.RespondentID)
	join vr_SurveyInstances a13
	on  (a11.SurveyInstanceID = a13.SurveyInstanceID)
where (a12.RespondentEventID in (4004,4005,4011,5014,5015,5021)
and a13.SurveyID in (24, 8, 31)) 

UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@total_deceased as varchar(100))
	WHERE metric_name = ''DECEASED_DISENROLLED''

-- calculate total responses received
set select @total_received = count(distinct a11.RespondentID) 
from Respondents a11
	join vr_RespondentEventLog a12
	on  (a11.RespondentID = a12.RespondentID)
	join vr_SurveyInstances a13
	on  (a11.SurveyInstanceID = a13.SurveyInstanceID)
where (a12.RespondentEventID in (3012, 3022, 3032, 3035)
and a13.SurveyID in (24, 8, 31)) 

UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@total_received as varchar(100))
	WHERE metric_name = ''RESPONSES_RECEIVED''

DECLARE @pct_received decimal (9,1)
SET @pct_received = (@total_received*1.0 / ((@total - @total_deceased)*1.0))  * 100.0
UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@pct_received as varchar(100))
	WHERE metric_name = ''PERCENT_RESPONSES_RECEIVED''

set select @total_gender = count(distinct a11.RespondentID) 
from Respondents a11
	join vr_RespondentEventLog a12
	on  (a11.RespondentID = a12.RespondentID)
	join vr_SurveyInstances a13
	on  (a11.SurveyInstanceID = a13.SurveyInstanceID)
where (a11.Gender in (''F'',''M'')
and a12.RespondentEventID in (4000)
and a13.SurveyID in (24, 8, 31)) 

-- calculate percent male responses
set select @males = count(distinct a11.RespondentID) 
from Respondents a11
	join vr_RespondentEventLog a12
	on  (a11.RespondentID = a12.RespondentID)
	join vr_SurveyInstances a13
	on  (a11.SurveyInstanceID = a13.SurveyInstanceID)
where (a11.Gender in (''M'')
and a12.RespondentEventID in (4000)
and a13.SurveyID in (24, 8, 31)) 

DECLARE @pct_males decimal(9,1)
SET @pct_males = ((@males * 1.0) / (@total_gender * 1.0)) * 100.0
UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@pct_males as varchar(100))
	WHERE metric_name = ''PERCENT_MALES''

-- calculate percent females
set select @females = count(distinct a11.RespondentID) 
from Respondents a11
	join vr_RespondentEventLog a12
	on  (a11.RespondentID = a12.RespondentID)
	join vr_SurveyInstances a13
	on  (a11.SurveyInstanceID = a13.SurveyInstanceID)
where (a11.Gender in (''F'')
and a12.RespondentEventID in (4000)
and a13.SurveyID in (24, 8, 31)) 

DECLARE @pct_females decimal(9,1)
SET @pct_females = ((@females * 1.0) / (@total_gender * 1.0)) * 100.0
UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@pct_females as varchar(100))
	WHERE metric_name = ''PERCENT_FEMALES''

-- calculate average age
DECLARE @avg_age decimal(9,1)
SET select @avg_age = avg(dbo.CompletionAge(a11.RespondentID))
from Respondents a11
	join vr_SurveyInstances a12
	  on  (a11.SurveyInstanceID = a12.SurveyInstanceID)
where a12.SurveyID in (24, 8, 31) 

UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@avg_age as varchar(100))
	WHERE metric_name = ''AVERAGE_AGE''

-- calculate average pra score
DECLARE @pra decimal(9,3)
SET select @pra = avg(a11.PraScore) 
from v_GHS_Senior_PraScore a11
	join vr_RespondentEventLog a12
	  on  (a11.RespondentID = a12.RespondentID)
	join Respondents a13
	  on  (a11.RespondentID = a13.RespondentID)
	join vr_SurveyInstances a14
	  on  (a13.SurveyInstanceID = a14.SurveyInstanceID)
where (a12.RespondentEventID in (3012, 3022, 3032, 3035)
 and a14.SurveyID in (24, 8, 31)) 

UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@pra as varchar(100))
	WHERE metric_name = ''AVERAGE_PRA''

-- calculate average frailty score
DECLARE @frailty decimal(9,3)
SET select @frailty = avg(a11.FrailtyScore) 
from v_GHS_Senior_FrailtyScore a11
	join vr_RespondentEventLog a12
	  on  (a11.RespondentID = a12.RespondentID)
	join Respondents a13
	  on  (a11.RespondentID = a13.RespondentID)
	join vr_SurveyInstances a14
	  on  (a13.SurveyInstanceID = a14.SurveyInstanceID)
where (a12.RespondentEventID in (3012, 3022, 3032, 3035)
 and a14.SurveyID in (24, 8, 31)) 

UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@frailty as varchar(100))
	WHERE metric_name = ''AVERAGE_FRAILTY''

-- calculate average depression score
DECLARE @depression decimal(9,3)
SET select @depression = avg((a11.DepressionScore * 1.0)) 
from v_GHS_Senior_DepressionScore a11
	join vr_RespondentEventLog a12
	  on  (a11.RespondentID = a12.RespondentID)
	join Respondents a13
	  on  (a11.RespondentID = a13.RespondentID)
	join vr_SurveyInstances a14
	  on  (a13.SurveyInstanceID = a14.SurveyInstanceID)
where (a12.RespondentEventID in (3012, 3022, 3032, 3035)
 and a14.SurveyID in (24, 8, 31)) 

UPDATE ghs_SeniorHealthUniverseMetrics 
	SET metric_value = CAST(@depression as varchar(100))
	WHERE metric_name = ''AVERAGE_DEPRESSION''

END
' 
END
GO
