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


		INSERT INTO [CIHI].[Final_Metadata]
					([submissionID]
					,[creationTime_value]
					,[sender.device.manufacturer.id.value]
					,[sender.organization.id.value]
					,[versionCode_code]
					,[versionCode_codeSystem]
					,[purpose_code]
					,[purpose_codeSystem])
		select distinct s.submissionID
			, replace(convert(varchar,s.pullDate,102),'.','') as creationTime_value
			, s.DeviceManufacturer as [sender.device.manufacturer.id.value]
			, qc.FacilityNum as [sender.organization.id.value]
			, s.CPESVersionCD as versionCode_code
			, rv.codeSystem as versionCode_codeSystem
			, s.PurposeCD as purpose_code
			, rp.codeSystem as purpose_codeSystem 
		from cihi.submission s	
		join CIHI.QA_QuestionnaireCycleAndStratum qc on s.SubmissionID - 1 = qc.submissionID 
		inner join [CIHI].[OrgProfile] op on op.[OrganizationCD] = qc.FacilityNum
		left join cihi.recode rv on rv.QAField='CPESVersionCD' and rv.FinalTable='Final_Metadata'
		left join cihi.recode rp on rp.QAField='PurposeCD' and rp.FinalTable='Final_Metadata'
		left join cihi.final_metadata fm on fm.submissionid = s.submissionid and fm.[sender.device.manufacturer.id.value] = s.DeviceManufacturer and fm.[sender.organization.id.value] = qc.FacilityNum
		where s.submissionsubject = 'ORG'
		and s.submissionid=@submissionID 
		and fm.Final_MetadataID is null



		INSERT INTO [CIHI].[Final_OrgProfile]
				   (SubmissionID
				   ,[Final_MetadataID]
				   ,[organizationProfile.organization.id.value]
				   ,[organizationProfile.surveyingFrequency_code]
				   ,[organizationProfile.surveyingFrequency_codeSystem]
				   ,[organizationProfile.device.manufacturer.id.value])
		SELECT distinct fm.submissionID,
			   fm.Final_MetaDataID,
			   op.[OrganizationCD],
			   op.[SurveyingFrequency],
			   r1.CodeSystem,
			   op.[DeviceManufacturer]
		FROM [CIHI].[OrgProfile] op
		INNER JOIN [CIHI].[Final_Metadata] fm on fm.[sender.organization.id.value] = [OrganizationCD]
		LEFT JOIN [CIHI].[Recode] r1 on r1.QaTable = 'OrgProfile' and r1.QaField = 'SurveyingFrequency'
		LEFT JOIN [CIHI].[Final_OrgProfile] fop on fop.SubmissionID = fm.submissionid and fop.Final_MetadataID = fm.Final_MetadataID
		WHERE fm.submissionid = @submissionID
		and fop.Final_MetadataID is null

 

		INSERT INTO [CIHI].[Final_Role]
				   (SubmissionID
				   ,[Final_OrgProfileID]
				   ,[organizationProfile.role_code]
				   ,[organizationProfile.role_codeSystem])
		SELECT fop.submissionID,
			   fop.Final_OrgProfileID,
			   op.[RoleCD],
			   r1.CodeSystem
		FROM [CIHI].[OrgProfile] op
		INNER JOIN [CIHI].[Final_OrgProfile] fop on fop.[organizationProfile.organization.id.value] = op.OrganizationCD
		LEFT JOIN [CIHI].[Recode] r1 on r1.QaTable = 'OrgProfile' and r1.QaField = 'RoleCD'
		LEFT JOIN [CIHI].[Final_Role] fr on fr.SubmissionID = fop.submissionid and fr.Final_OrgProfileID = fop.Final_OrgProfileID
		WHERE fop.submissionid = @submissionID
		and fr.Final_RoleID is null



		INSERT INTO [CIHI].[Final_Contact]
				   (SubmissionID
				   ,[Final_OrgProfileID]
				   ,[organizationProfile.organization.contact.code_code]
				   ,[organizationProfile.organization.contact.code_codeSystem]
				   ,[organizationProfile.organization.contact.email]
				   ,[organizationProfile.organization.contact.name]
				   ,[organizationProfile.organization.contact.phone_extension]
				   ,[organizationProfile.organization.contact.phone_number])
		SELECT fop.submissionID,
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
		LEFT JOIN [CIHI].[Final_Contact] fc on fc.SubmissionID = fop.submissionid and fc.Final_OrgProfileID = fop.Final_OrgProfileID
		WHERE fop.submissionid = @submissionID
		and fc.Final_ContactID is null


	commit tran


END


GO


