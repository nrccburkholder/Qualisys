/****** Object:  StoredProcedure [dbo].[dxv_MakeViewFromSurvey]    Script Date: 08/09/2006 14:41:41 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[dxv_MakeViewFromSurvey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[dxv_MakeViewFromSurvey]
GO
/****** Object:  StoredProcedure [dbo].[dxv_MakeViewFromSurvey]    Script Date: 08/09/2006 14:41:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[dxv_MakeViewFromSurvey]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'


create procedure dxv_MakeViewFromSurvey (@SurveyID  int)
/*This procedure will make a view form a survey; provided that the text of the view
is less than 8000 characters.

If the view exists already,  it will be dropped prior to being created.


If the text is more than 8000 characters,  you have to do this an alternate way:

1. Call dxv_GetDropView(@surveyID)
2. Take each line of the result set and concatenate the lines together
to create the drop view statement.
3. Dynamically execute the statement.

1. Call dxv_GetCreateView(@surveyID)
2. Take each line of the result set and concatenate the lines together
to create the drop view statement.
3. Dynamically execute the statement.



*/
as
begin
declare @the_command varchar(8000)

select @the_command = dbo.dxv_DropViewDefinition(@SurveyID)
exec (@the_command)
select @the_command = dbo.dxv_CreateViewDefinition(@SurveyID)
exec (@the_command)
end


' 
END
GO
GRANT EXECUTE ON [dbo].[dxv_MakeViewFromSurvey] TO [reporter]
GO
