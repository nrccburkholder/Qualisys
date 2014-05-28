CREATE PROCEDURE QP_Rep_SurveyConfig02  
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50)  
AS  
set transaction isolation level read uncommitted  
Declare @intStudy_id int, @str varchar(1000)  
select @intStudy_id=s.study_id  
from study s, client c  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and c.client_id=s.client_id  
  
select @str=STROBJECTIVES_TXT from study where study_id=@intstudy_id  
  
while charindex(char(13),@str)>0  
begin  
  select @str = left(@str,charindex(char(13),@str)-1) + substring(@str,charindex(char(13),@str)+1,1000)  
end  

-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (select 'Survey Configuration' AS SheetNameDummy, @str as [Study Objective])
	select 'Survey Configuration' AS SheetNameDummy, @str as [Study Objective]
ELSE  
	select 'Survey Configuration' AS SheetNameDummy, '' AS [Study Objective]

set transaction isolation level read committed


