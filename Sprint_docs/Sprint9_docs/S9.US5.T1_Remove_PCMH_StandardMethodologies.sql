use QP_Prod

/*
S8.US5 - Remove PCMH Data from Stage and Test
As a ALLCAHPS team, we want to remove PMCH changes from Test and Stage so that the environments are in sync.
Tim Butler
*/

begin tran
go

declare @StandardMethodologyID int, @StandardMailingStepID int, @SurveyTypeid int, @Subtype_Id int
																												
select @SurveyTypeid = surveytype_id from surveytype where SurveyType_dsc='CGCAHPS'	

select @subtype_id = st.subtype_id 
from surveytypesubtype stst
inner join subtype st on st.subtype_id = stst.subtype_id
where st.Subtype_nm = 'PCMH'

if exists (select * from survey_def where surveytype_id = @Surveytypeid and survey_id in (select survey_id from surveysubtype where subtype_id=@Subtype_id))
	print 'There are still surveys that use the PCMH subtype. Aborting'
else
begin

	select @StandardMethodologyID = StandardMethodologyID
	from StandardMethodology
	WHERE strStandardMethodology_nm = 'PCMH Mixed Mail-Phone'

	if @StandardMethodologyID is null 
	begin
		print '"PCMH Mixed Mail-Phone" already doesn''t exist'
	end
	else	
	begin	
		if exists (select * from mailingmethodology where StandardMethodologyID = @StandardMethodologyID)
		begin
			print 'There are one or more surveys that use "PCMH Mixed Mail-Phone" standard methodology. Not deleting.'
		end
		else
		begin
			delete [dbo].[StandardMailingStep]
			WHERE StandardMethodologyID = @StandardMethodologyID

			delete  [dbo].[StandardMethodologyBySurveyType]
			where StandardMethodologyID = @StandardMethodologyID
				
			delete [dbo].[StandardMethodology]
			where StandardMethodologyID = @StandardMethodologyID
		end
	end


	set @StandardMethodologyID=NULL
	select @StandardMethodologyID = StandardMethodologyID
	from StandardMethodology
	WHERE strStandardMethodology_nm = 'PCMH Mail Only'
		
	if @StandardMethodologyID is null 
	begin
		print '"PCMH Mail Only" already doesn''t exist'
	end
	else	
	begin	
		if exists (select * from mailingmethodology where StandardMethodologyID = @StandardMethodologyID)
		begin
			print 'There are one or more surveys that use "PCMH Mail Only" standard methodology. Not deleting.'
		end
		else
		begin
			delete [dbo].[StandardMailingStep]
			WHERE StandardMethodologyID = @StandardMethodologyID

			delete  [dbo].[StandardMethodologyBySurveyType]
			where StandardMethodologyID = @StandardMethodologyID
				
			delete [dbo].[StandardMethodology]
			where StandardMethodologyID = @StandardMethodologyID
		end
	end

	set @StandardMethodologyID=NULL
	select @StandardMethodologyID = StandardMethodologyID
	from StandardMethodology
	WHERE strStandardMethodology_nm = 'PCMH Phone Only'
		
	if @StandardMethodologyID is not null
	begin	
	if @StandardMethodologyID is null 
	begin
		print '"PCMH Phone Only" already doesn''t exist'
	end
	else	
	begin	
		if exists (select * from mailingmethodology where StandardMethodologyID = @StandardMethodologyID)
		begin
			print 'There are one or more surveys that use "PCMH Phone Only" standard methodology. Not deleting.'
		end
		else
		begin
			delete [dbo].[StandardMailingStep]
			WHERE StandardMethodologyID = @StandardMethodologyID

			delete  [dbo].[StandardMethodologyBySurveyType]
			where StandardMethodologyID = @StandardMethodologyID
				
			delete [dbo].[StandardMethodology]
			where StandardMethodologyID = @StandardMethodologyID
		end
	end
end

/*

  go
  commit tran

  rollback tran

*/

select *
from StandardMethodology where strStandardMethodology_nm like 'PCMH%'

select *
from StandardMailingStep where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'PCMH%'
)

select *
from StandardMethodologyBySurveyType where StandardMethodologyID in (
	select StandardMethodologyID
	from StandardMethodology where strStandardMethodology_nm like 'PCMH%'
)


	


