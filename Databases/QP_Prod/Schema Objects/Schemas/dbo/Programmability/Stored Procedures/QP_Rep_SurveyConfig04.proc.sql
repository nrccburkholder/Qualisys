CREATE PROCEDURE QP_Rep_SurveyConfig04  
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
	select 'Survey Configuration' AS SheetNameDummy, ct.strcomparisontype_cd as Comparisions  
	from studycomparison sc, comparisontype ct  
	where sc.COMPARISONTYPE_ID=ct.COMPARISONTYPE_ID  
	  and sc.study_id=@intstudy_id
		)

	select 'Survey Configuration' AS SheetNameDummy, ct.strcomparisontype_cd as Comparisions  
	from studycomparison sc, comparisontype ct  
	where sc.COMPARISONTYPE_ID=ct.COMPARISONTYPE_ID  
	  and sc.study_id=@intstudy_id

ELSE
	select 'Survey Configuration' AS SheetNameDummy, '' as Comparisions  

  
set transaction isolation level read committed


