CREATE PROCEDURE [dbo].[csp_GetSampleSetExtractData] 
	@ExtractFileID int 
AS
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 8 -- SampleSet
--    	
--	declare @ExtractFileID int
--	set @ExtractFileID = 2 

	---------------------------------------------------------------------------------------
	-- Load records to Insert/Update/Delete into a temp table
	---------------------------------------------------------------------------------------

	delete SampleSetTemp where ExtractFileID = @ExtractFileID

	insert SampleSetTemp 
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted )
		select distinct @ExtractFileID,eh.PKey1,study.client_id,study.study_id, survey.survey_id, ss.DATSAMPLECREATE_DT,eh.IsDeleted
		 from (select distinct PKey1 ,PKey2,IsDeleted
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID ) eh		  
		  left join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on ss.sampleset_id = eh.PKey1
          left join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on eh.PKey2 = survey.survey_id
          left join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id


