CREATE PROCEDURE QP_Rep_SurveyConfig06  
 @Associate varchar(50),  
 @Client varchar(50),  
 @Study varchar(50),  
 @Survey varchar(50)  
AS  
set transaction isolation level read uncommitted  
Declare @intSurvey_id int, @intStudy_id int  
select @intSurvey_id=sd.survey_id, @intStudy_id=sd.study_id  
from survey_def sd, study s, client c  
where c.strclient_nm=@Client  
  and s.strstudy_nm=@Study  
  and sd.strsurvey_nm=@survey  
  and c.client_id=s.client_id  
  and s.study_id=sd.study_id  
  
-- If dataset is empty need at least one record with valid SheetNameDummy field
IF EXISTS (
	select 'Survey Configuration' AS SheetNameDummy, cc.strContactName as [Contact Name], CT.strContactType_cd as [Type], cc.STRCONTACTPHONE as Phone, cc.STRCONTACTEMAIL as Email  
	from survey_contact sc, client_contact cc, contactType CT  
	where sc.survey_id=@intsurvey_id  
	  and sc.contact_id=cc.contact_id  
	  and sc.contacttype_id=ct.contacttype_id
		)

	select 'Survey Configuration' AS SheetNameDummy, cc.strContactName as [Contact Name], CT.strContactType_cd as [Type], cc.STRCONTACTPHONE as Phone, cc.STRCONTACTEMAIL as Email  
	from survey_contact sc, client_contact cc, contactType CT  
	where sc.survey_id=@intsurvey_id  
	  and sc.contact_id=cc.contact_id  
	  and sc.contacttype_id=ct.contacttype_id  
ELSE
	select 'Survey Configuration' AS SheetNameDummy, '' as [Contact Name], '' as [Type], '' as Phone, '' as Email  
  
set transaction isolation level read committed


