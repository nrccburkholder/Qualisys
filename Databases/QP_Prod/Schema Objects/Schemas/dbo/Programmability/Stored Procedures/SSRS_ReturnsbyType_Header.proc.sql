Create Proc SSRS_ReturnsbyType_Header (@samplesets varchar(5000))
as
begin

declare @SQL varchar(8000)

Create table #Results (
client_Id int, 
strClient_nm varchar(500), 
Study_Id int, 
strStudy_nm varchar(500),
Survey_ID int,
strSurvey_Nm varchar(500),
SampleCount int
)

set @SQL = '
Select	css.client_ID, css.strClient_nm, css.Study_ID, css.strStudy_nm, 
		css.survey_Id, css.strSurvey_nm, count(distinct sp.Samplepop_ID)
from	css_view css, sampleset ss, samplepop sp
where	ss.survey_Id = css.Survey_ID and
		ss.sampleset_ID = sp.sampleset_ID and
		ss.sampleset_ID in (' + @samplesets + ')
Group by css.client_ID, css.strClient_nm, css.Study_ID, css.strStudy_nm, 
		css.survey_Id, css.strSurvey_nm'	


	print @SQL
	exec (@SQL)

end


