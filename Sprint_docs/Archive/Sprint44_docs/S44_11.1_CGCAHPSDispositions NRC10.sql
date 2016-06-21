
/*

	S44 US11 CG-CAHPS Dispositions 
	As a CG-CAHPS vendor, we need to update the disposition hierarchy to match the new specs, so that we can submit accurate data.

	Task 1 - Update SurveyTypeDisposition on NRC10 & Medusa

	Tim Butler
*/

USE [QP_Prod]
GO


-- Create a table for holding Old SurveyTypeDispositions records
if not exists (	SELECT 1 
				FROM   sys.tables st 
					   INNER JOIN sys.columns sc ON st.object_id = sc.object_id 
				WHERE  st.schema_id = 1 
					   AND st.NAME = 'SurveyTypeDispositions_Old')
begin

	CREATE TABLE [dbo].[SurveyTypeDispositions_Old](
		[SurveyTypeDispositionID] [int] NULL,
		[Disposition_ID] [int] NULL,
		[Value] [varchar](5) NULL,
		[Hierarchy] [int] NULL,
		[Desc] [varchar](100) NULL,
		[ExportReportResponses] [bit] NULL DEFAULT ((0)),
		[ReceiptType_ID] [int] NULL,
		[SurveyType_ID] [int] NULL,
		[ModifiedDate] DateTime NULL,
		[Comment] varchar(100) NULL)
 
end


DECLARE @disposition_id int

if not exists (select 1 from dbo.Disposition where strDispositionLabel = 'Incomplete Survey (no measure question answered)' and strReportLabel = 'Incomplete Survey')
begin


	INSERT INTO [dbo].[Disposition]
			   ([strDispositionLabel]
			   ,[Action_id]
			   ,[strReportLabel]
			   ,[MustHaveResults])
		 VALUES
			   ('Incomplete Survey (no measure question answered)'
			   ,0
			   ,'Incomplete Survey'
			   ,1)

end

SET @disposition_id = SCOPE_IDENTITY()


-- Store off the current CGCAHPS SurveyType
if not exists (select 1 from dbo.SurveyTypeDispositions_Old where [Comment] = 'S44 US11')
	insert into dbo.SurveyTypeDispositions_Old
	select *,GETDATE(),'S44 US11'
	from dbo.SurveyTypeDispositions std
	where std.SurveyType_ID = 4

-- remove current records for CGCAHPS
delete dbo.SurveyTypeDispositions 
where SurveyType_ID = 4


-- now add the new dispositions
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(3,6,1,'Deceased',0,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(4,7,2,'Ineligible; mentally or physically incapacitated',0,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(23,4,3,'Survey returned - No to Question 1',1,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(13,1,4,'Complete',1,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(11,2,5,'Partial Complete',1,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(@disposition_id,3,6,'Incomplete',1,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(2,5,7,'Refused to complete survey',0,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(10,8,8,'Unable to contact (bad addr/phone, language barrier)',0,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(14,8,9,'Unable to contact (bad addr/phone, language barrier)',0,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(16,8,10,'Unable to contact (bad addr/phone, language barrier)',0,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(5,8,11,'Unable to contact (bad addr/phone, language barrier)',0,NULL,4)
INSERT INTO [dbo].[SurveyTypeDispositions]([Disposition_ID],[Value],[Hierarchy],[Desc],[ExportReportResponses],[ReceiptType_ID],[SurveyType_ID])VALUES(12,9,12,'Did not respond after maximum attempts',0,NULL,4)



select *
from dbo.Disposition
where Disposition_id = @disposition_id


select *
from dbo.SurveyTypeDispositions std
where SurveyType_ID = 4