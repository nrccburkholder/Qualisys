-- ================================================================================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_GetStudyExtractData
-- Create date: 3/01/2009 
-- Description:	Extracts study data from QP_Prod tables
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 3/22/2011 kmn modifed logic to extact study owner data 
-- =================================================================================================
CREATE PROCEDURE [dbo].[csp_GetStudyExtractData] 
	@ExtractFileID int
--exec csp_GetStudyExtractData 2017
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 15 -- Study Entity
	  
    select  distinct 1  as Tag
	,NULL  as Parent
	,study.STUDY_ID as [study!1!id]
	,rtrim(study.strstudy_nm) as [study!1!studyName] 		
	,study.CLIENT_ID as [study!1!clientid]
	,study.ADEMPLOYEE_ID as [study!1!assignedEmployeeID]
	,e.STREMPLOYEE_FIRST_NM as [study!1!assignedEmployeeFirstName]
	,e.STREMPLOYEE_Last_NM as [study!1!assignedEmployeeLastName]
	,e.strEmail as [study!1!assignedEmployeeEmail]
	,study.Active as [study!1!activeFlag]
	,'false' as [study!1!deleteEntity]
	from QP_PROD.dbo.STUDY study with (NOLOCK) 
	 inner join (select distinct PKey1 
                from ExtractHistory  with (NOLOCK) 
                where ExtractFileID = @ExtractFileID
	            and EntityTypeID = @EntityTypeID
	            and IsDeleted = 0 ) eh on study.Study_ID = eh.PKey1		
	 left join QP_Prod.dbo.EMPLOYEE e with (NOLOCK) on  study.ADEMPLOYEE_ID = e.EMPLOYEE_ID     
	for XML EXPLICIT


