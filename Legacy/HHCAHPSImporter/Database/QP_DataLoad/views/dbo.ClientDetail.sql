CREATE VIEW dbo.ClientDetail
AS
select distinct 
   c.client_id as Client_id, 
   c.STRCLIENT_NM as ClientName, 
   suf.medicarenumber as CCN, 
   s.STUDY_ID as Study_id, 
   sd.SURVEY_ID as Survey_id,
   sd.ContractedLanguages as Languages 
from 
	Qualisys.QP_Prod.dbo.CLIENT c with(nolock) 
	INNER JOIN Qualisys.QP_Prod.dbo.CLIENTGroups cg with(nolock) ON c.ClientGroup_ID=cg.ClientGroup_ID and cg.ClientGroup_nm in ('OCS')	
	INNER JOIN Qualisys.QP_Prod.dbo.STUDY s with(nolock) ON c.CLIENT_ID = s.CLIENT_ID
	INNER JOIN Qualisys.QP_Prod.dbo.SURVEY_DEF sd with(nolock) ON s.STUDY_ID = sd.STUDY_ID AND sd.SurveyType_id = 3
	INNER JOIN Qualisys.QP_Prod.dbo.SAMPLEPLAN spl with(nolock) ON sd.SURVEY_ID = spl.SURVEY_ID
	INNER JOIN Qualisys.QP_Prod.dbo.SAMPLEUNIT su with(nolock) ON spl.SAMPLEPLAN_ID = su.SAMPLEPLAN_ID
	INNER JOIN Qualisys.QP_Prod.dbo.SUFacility suf with(nolock) ON su.SUFacility_id = suf.SUFacility_id
--Added where clause to limit results to only active clients, studies, surveys, and sampleunits. 08/16/2012 dmp
where su.DontSampleUnit = 0
and sd.Active = 1
and s.Active = 1
and c.Active = 1