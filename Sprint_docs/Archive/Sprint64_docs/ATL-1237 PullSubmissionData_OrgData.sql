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
    DECLARE @CurrentPullDate datetime = GETDATE()
	DECLARE @LastPullDate datetime

	select @LastPullDate = Pulldate from [CIHI].[Submission] WHERE SubmissionID < @submissionid and submissionsubject = 'ORG'

	IF @LastPullDate IS NULL 
		SET @LastPullDate = '1/1/2000'

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
		select distinct @submissionID
			, NULL as creationTime_value
			, NULL as [sender.device.manufacturer.id.value]
			, op.OrganizationCD as [sender.organization.id.value]
			, NULL as versionCode_code
			, NULL
			, NULL as purpose_code
			, NULL
		from cihi.orgprofile op
		where op.ModifiedOn > @LastPullDate
		and op.IsContracted = 1
	

		UPDATE fm
			SET [creationTime_value] = replace(convert(varchar,@CurrentPullDate,102),'.',''),
				[sender.device.manufacturer.id.value] = s.[DeviceManufacturer],
				[versionCode_code] = s.[CPESVersionCD],
				[purpose_code] = [PurposeCD]
		FROM [CIHI].[Final_Metadata] fm
		INNER JOIN [CIHI].[Submission] s ON s.SubmissionID = fm.SubmissionID
		and fm.SubmissionID = @submissionid

		update f 
			set f.[versionCode_code] = r.CIHIValue,f.[versionCode_codeSystem]=r.codesystem
		from cihi.[Final_Metadata] f
		join cihi.recode r on f.[versionCode_code]=r.nrcValue
		where r.finalTable='Final_Metadata' and r.finalField = 'versionCode_code' 
		and f.SubmissionID = @submissionid

		update f 
			set f.[purpose_code] = r.CIHIValue,f.[purpose_codeSystem]=r.codesystem
		from cihi.[Final_Metadata] f
		join cihi.recode r on f.[purpose_code]=r.nrcValue
		where r.finalTable='Final_Metadata' and r.finalField = 'purpose_code' 
		and f.SubmissionID = @submissionid

	END

	if not exists (SELECT 1 FROM [CIHI].[Final_OrgProfile] WHERE SubmissionID = @submissionid)
	BEGIN
		INSERT INTO [CIHI].[Final_OrgProfile]
				   (SubmissionID
				   ,[Final_MetadataID]
				   ,[organizationProfile.organization.id.value]
				   ,[organizationProfile.surveyingFrequency_code]
				   ,[organizationProfile.surveyingFrequency_codeSystem]
				   ,[organizationProfile.device.manufacturer.id.value])
		SELECT distinct @submissionID,
			   fm.Final_MetaDataID,
			   op.[OrganizationCD],
			   op.[SurveyingFrequency],
			   NULL,
			   op.[DeviceManufacturer]
		FROM [CIHI].[OrgProfile] op
		INNER JOIN [CIHI].[Final_Metadata] fm on fm.[sender.organization.id.value] = [OrganizationCD]
		where op.ModifiedOn > @LastPullDate
		and op.IsContracted = 1
		and fm.SubmissionID = @submissionid

		update f 
			set f.[organizationProfile.surveyingFrequency_code] = r.CIHIValue,f.[organizationProfile.surveyingFrequency_codeSystem]=r.codesystem
		from cihi.[Final_OrgProfile] f
		join cihi.recode r on f.[organizationProfile.surveyingFrequency_code]=r.nrcValue
		where r.finalTable='Final_OrgProfile' and r.finalField = 'organizationProfile.surveyingFrequency_code' 
		and f.SubmissionID = @submissionid

	END
 
	if not exists (SELECT 1 FROM [CIHI].[Final_Role] WHERE SubmissionID = @submissionid)
	BEGIN
		INSERT INTO [CIHI].[Final_Role]
				   (SubmissionID
				   ,[Final_OrgProfileID]
				   ,[organizationProfile.role_code]
				   ,[organizationProfile.role_codeSystem])
		SELECT distinct @submissionID,
			   fop.Final_OrgProfileID,
			   op.[RoleCD],
			   NULL
		FROM [CIHI].[OrgProfile] op
		INNER JOIN [CIHI].[Final_OrgProfile] fop on fop.[organizationProfile.organization.id.value] = op.OrganizationCD
		where op.ModifiedOn > @LastPullDate
		and op.IsContracted = 1
		and fop.submissionid = @submissionID

		update f 
			set f.[organizationProfile.role_code] = r.CIHIValue,f.[organizationProfile.role_codeSystem]=r.codesystem
		from cihi.[Final_Role] f
		join cihi.recode r on f.[organizationProfile.role_code]=r.nrcValue
		where r.finalTable='Final_Role' and r.finalField = 'organizationProfile.role_code'
		and f.SubmissionID = @submissionid

	END

	if not exists (SELECT 1 FROM [CIHI].[Final_Contact] WHERE SubmissionID = @submissionid)
	BEGIN
		INSERT INTO [CIHI].[Final_Contact]
				   (SubmissionID
				   ,[Final_OrgProfileID]
				   ,[organizationProfile.organization.contact.code_code]
				   ,[organizationProfile.organization.contact.code_codeSystem]
				   ,[organizationProfile.organization.contact.email]
				   ,[organizationProfile.organization.contact.name]
				   ,[organizationProfile.organization.contact.phone_extension]
				   ,[organizationProfile.organization.contact.phone_number])
		SELECT distinct @submissionID,
				fop.Final_OrgProfileID,
				op.[ContactCD],
				NULL,
				op.[ContactEmail],
				op.[ContactName],
				op.[ContactPhoneExtension],
				op.[ContactPhone]
		FROM [CIHI].[OrgProfile] op
		INNER JOIN [CIHI].[Final_OrgProfile] fop on fop.[organizationProfile.organization.id.value] = op.OrganizationCD
		where op.ModifiedOn > @LastPullDate
		and op.IsContracted = 1
		and fop.submissionid = @submissionID

		update f 
			set f.[organizationProfile.organization.contact.code_code] = r.CIHIValue,f.[organizationProfile.organization.contact.code_codeSystem]=r.codesystem
		from cihi.[Final_Contact] f
		join cihi.recode r on f.[organizationProfile.organization.contact.code_code]=r.nrcValue
		where r.finalTable='Final_Contact' and r.finalField = 'organizationProfile.organization.contact.code_code'
		and f.SubmissionID = @submissionid
	END


	update CIHI.Submission
		SET PullDate = @CurrentPullDate
	WHERE SubmissionID = @SubmissionID

	commit tran


END


GO


