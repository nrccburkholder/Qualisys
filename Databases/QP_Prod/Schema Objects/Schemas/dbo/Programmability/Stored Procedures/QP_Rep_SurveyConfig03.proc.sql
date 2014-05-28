CREATE PROCEDURE QP_Rep_SurveyConfig03  
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50)  
AS  
set transaction isolation level read uncommitted  
Declare @intStudy_id int  
select @intStudy_id=s.study_id  
from study s, client c  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and c.client_id=s.client_id  

-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (
	select 'Survey Configuration' AS SheetNameDummy, rt.strreporttype_cd as [Report Type], srt.strreportnote as [Report]  
	from studyreporttype srt, reporttype rt  
	where srt.reporttype_id=rt.reporttype_id  
	  and srt.study_id=@intstudy_id
		)

	select 'Survey Configuration' AS SheetNameDummy, rt.strreporttype_cd as [Report Type], srt.strreportnote as [Report]  
	from studyreporttype srt, reporttype rt  
	where srt.reporttype_id=rt.reporttype_id  
	  and srt.study_id=@intstudy_id  
ELSE
	select 'Survey Configuration' AS SheetNameDummy, '' as [Report Type], '' as [Report]  
  
set transaction isolation level read committed


