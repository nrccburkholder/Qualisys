/*
	ATL-1228 Procedure to move data from QA to Final

		ATL-1237 Organization submission procedure

		Tim Butler
*/
use qp_prod
go
if exists (select * from sys.procedures where schema_name(schema_id)='CIHI' and name = 'PullSubmissionData_OrgData')
	drop procedure CIHI.PullSubmissionData_OrgData
go

create procedure CIHI.PullSubmissionData_OrgData
@submissionID int
as
BEGIN
    

	begin tran

if not exists (SELECT 1 FROM [CIHI].[Final_Metadata] WHERE SubmissionID = @submissionid)
BEGIN

	INSERT INTO [CIHI].[Final_Metadata]
			   ([submissionID]
			   ,[creationTime_value]
			   ,[sender.device.manufacturer.id.value]
			   ,[sender.organization.id.value]
			   ,[versionCode_code]
			   ,[versionCode_codeSystem]
			   ,[purpose_code]
			   ,[purpose_codeSystem])
	SELECT 	s.[SubmissionID],
			REPLACE(LEFT(CONVERT(VARCHAR, GETDATE(), 120), 10),'-',''),
			s.[DeviceManufacturer],
			s.[DeviceManufacturer], --s.[OrganizationCD],
			s.[CPESVersionCD],
			r1.CodeSystem, 
			s.[PurposeCD],  
			r2.CodeSystem 
	FROM [CIHI].[Submission] s
	LEFT JOIN [CIHI].[Recode] r1 on r1.QaTable = 'Submission' and r1.QaField = 'CPESVersionCD'
	LEFT JOIN [CIHI].[Recode] r2 on r2.QaTable = 'Submission' and r2.QaField = 'PurposeCD'
	WHERE s.SubmissionID = @submissionid

END

DECLARE @Final_MetadataID int
SELECT @Final_MetadataID = Final_MetadataID FROM [CIHI].[Final_Metadata] WHERE SubmissionID = @submissionid


INSERT INTO [CIHI].[Final_OrgProfile]
           (SubmissionID
		   ,[Final_MetadataID]
           ,[organizationProfile.organization.id.value]
           ,[organizationProfile.surveyingFrequency_code]
           ,[organizationProfile.surveyingFrequency_codeSystem]
           ,[organizationProfile.device.manufacturer.id.value])
SELECT distinct @submissionID,
	   @Final_MetaDataID,
	   op.[OrganizationCD],
	   op.[SurveyingFrequency],
	   r1.CodeSystem,
	   op.[DeviceManufacturer]
FROM [CIHI].[OrgProfile] op
LEFT JOIN [CIHI].[Recode] r1 on r1.QaTable = 'OrgProfile' and r1.QaField = 'SurveyingFrequency'


INSERT INTO [CIHI].[Final_Role]
           (SubmissionID
		   ,[Final_OrgProfileID]
           ,[organizationProfile.role_code]
           ,[organizationProfile.role_codeSystem])
SELECT @submissionID,
	   fop.Final_OrgProfileID,
	   op.[RoleCD],
	   r1.CodeSystem
FROM [CIHI].[OrgProfile] op
INNER JOIN [CIHI].[Final_OrgProfile] fop on fop.[organizationProfile.organization.id.value] = op.OrganizationCD
LEFT JOIN [CIHI].[Recode] r1 on r1.QaTable = 'OrgProfile' and r1.QaField = 'RoleCD'


INSERT INTO [CIHI].[Final_Contact]
           (SubmissionID
		   ,[Final_OrgProfileID]
           ,[organizationProfile.organization.contact.code_code]
           ,[organizationProfile.organization.contact.code_codeSystem]
           ,[organizationProfile.organization.contact.email]
           ,[organizationProfile.organization.contact.name]
           ,[organizationProfile.organization.contact.phone_extension]
           ,[organizationProfile.organization.contact.phone_number])
SELECT @submissionID,
		fop.Final_OrgProfileID,
		op.[ContactCD],
		r1.CodeSystem,
		op.[ContactEmail],
		op.[ContactName],
		op.[ContactPhoneExtension],
		op.[ContactPhone]
FROM [CIHI].[OrgProfile] op
INNER JOIN [CIHI].[Final_OrgProfile] fop on fop.[organizationProfile.organization.id.value] = op.OrganizationCD
LEFT JOIN [CIHI].[Recode] r1 on r1.QaTable = 'OrgProfile' and r1.QaField = 'ContactCD'


commit tran


END


GO


