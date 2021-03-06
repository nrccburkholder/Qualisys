/****** Object:  StoredProcedure [dbo].[tmpfixresponses]    Script Date: 08/10/2006 09:24:03 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tmpfixresponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[tmpfixresponses]
GO
/****** Object:  StoredProcedure [dbo].[tmpfixresponses]    Script Date: 08/10/2006 09:24:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[tmpfixresponses]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'
create procedure tmpfixresponses(@a int, @l int)
as begin
insert into Responses_jn (
jn_operation,jn_user,jn_datetime,jn_endtime,
jn_notes,jn_appln,jn_session,
 [ResponseID]
,[RespondentID]
,[SurveyQuestionID]
,[AnswerCategoryID]
,[ResponseText]
)
select
''I'',current_user,''11-feb-1970'',CAST(''2500-12-27 12:00:00.000'' 
  AS datetime),null,null,@@SPID,
 [ResponseID]
,[RespondentID]
,[SurveyQuestionID]
,[AnswerCategoryID]
,[ResponseText]
from responses as I
where responseID >= @a
and responseID < @a+@l
end

' 
END
GO
