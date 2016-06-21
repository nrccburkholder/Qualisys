/*

	ROLLBACK!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	S44 US11 CG-CAHPS Dispositions 
	As a CG-CAHPS vendor, we need to update the disposition hierarchy to match the new specs, so that we can submit accurate data.

	Task 1 - Update SurveyTypeDisposition on NRC10 & Medusa

	Tim Butler
*/

USE [QP_Prod]
GO


-- remove current records for CGCAHPS
delete dbo.SurveyTypeDispositions 
where SurveyType_ID = 4

declare @surveytypedispositionid int

select @surveytypedispositionid = max([SurveyTypeDispositionID]) from dbo.SurveyTypeDispositions

DBCC CHECKIDENT ('dbo.SurveyTypeDispositions', RESEED, @surveytypedispositionid)


-- re-populate SurveyTypeDispositions with the old records we removed as part of this story
insert into dbo.SurveyTypeDispositions
select Disposition_id, Value, Hierarchy, [Desc],[ExportReportResponses] ,ReceiptType_id, SurveyType_id
from dbo.SurveyTypeDispositions_Old
where surveytype_id = 4
and [Comment] = 'S44 US11'


delete from dbo.Disposition where strDispositionLabel = 'Incomplete Survey (no measure question answered)' and strReportLabel = 'Incomplete Survey'

declare @disposition_id int

select @disposition_id = max(disposition_id) from dbo.Disposition

DBCC CHECKIDENT ('dbo.Disposition', RESEED, @disposition_id)


select *
from dbo.Disposition
order by Disposition_id


select * 
from dbo.SurveyTypeDispositions
where SurveyType_ID = 4
order by Hierarchy