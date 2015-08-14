CREATE PROCEDURE [dbo].[csp_GetSampleSetExtractData] 
	@ExtractFileID int 
AS
-- =============================================
-- Procedure Name: csp_GetSampleSetExtractData
-- History: 1.0  Original as of 2015.01.06
--			2.0  Tim Butler - S14.2 US11 Add StandardMethodologyID column to SampleSetTemp
-- =============================================
BEGIN
	SET NOCOUNT ON 
	
	declare @EntityTypeID int
	set @EntityTypeID = 8 -- SampleSet
--    	
--	declare @ExtractFileID int
--	set @ExtractFileID = 2 

	---------------------------------------------------------------------------------------
	-- Load records to Insert/Update/Delete into a temp table
	---------------------------------------------------------------------------------------

	DECLARE @oExtractRunLogID INT;
	DECLARE @currDateTime1 DATETIME = GETDATE();
	DECLARE @currDateTime2 DATETIME;
	DECLARE @TaskName VARCHAR(200) =  OBJECT_NAME(@@PROCID);
	EXEC [InsertExtractRunLog] @ExtractFileID, @TaskName, @currDateTime1, @ExtractRunLogID = @oExtractRunLogID OUTPUT

	delete SampleSetTemp where ExtractFileID = @ExtractFileID

	insert SampleSetTemp 
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted, StandardMethodologyID )
		select distinct @ExtractFileID,eh.PKey1,study.client_id,study.study_id, survey.survey_id, ss.DATSAMPLECREATE_DT,eh.IsDeleted,
			mm.StandardMethodologyID -- S14.2 US11
		 from (select distinct PKey1 ,PKey2,IsDeleted
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID ) eh		  
		  left join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on ss.sampleset_id = eh.PKey1
          left join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on eh.PKey2 = survey.survey_id
          left join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id
		  left join QP_Prod.dbo.MAILINGMETHODOLOGY mm with (NOLOCK) on mm.SURVEY_ID = survey.SURVEY_ID and mm.BITACTIVEMETHODOLOGY = 1-- S14.2 US11

	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
END
