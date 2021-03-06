USE [NRC_DataMart_ETL]
GO
/****** Object:  StoredProcedure [dbo].[csp_GetSampleSetExtractData]    Script Date: 4/3/2015 9:39:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[csp_GetSampleSetExtractData] 
	@ExtractFileID int 
AS
-- =============================================
-- Procedure Name: csp_GetSampleSetExtractData
-- History: 1.0  Original as of 2015.01.06
--			2.0  Tim Butler - S14.2 US11 Add StandardMethodologyID column to SampleSetTemp
--			3.0  Tim Butler - S18 US16 Add IneligibleCount column to SampleSet
--			S20 US11 Add Patient In File Count  Tim Butler
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
			(ExtractFileID,SAMPLESET_ID, CLIENT_ID,STUDY_ID, SURVEY_ID, SAMPLEDATE,IsDeleted, StandardMethodologyID, IneligibleCount, NumPatInFile, SamplingMethodID )
		select distinct @ExtractFileID,eh.PKey1,study.client_id,study.study_id, survey.survey_id, ss.DATSAMPLECREATE_DT,eh.IsDeleted,
			mm.StandardMethodologyID, -- S15 US11
			ISNULL(ss.IneligibleCount,0), -- S18 US 16
			0, --ISNULL(pif.NumPatInFile,0), -- S20 US11
			pdef.SamplingMethod_id
		 from (select distinct PKey1 ,PKey2,IsDeleted
               from ExtractHistory  with (NOLOCK) 
               where ExtractFileID = @ExtractFileID
	           and EntityTypeID = @EntityTypeID ) eh		  
		  left join QP_Prod.dbo.SAMPLESET ss with (NOLOCK) on ss.sampleset_id = eh.PKey1
          left join QP_Prod.dbo.SURVEY_DEF survey with (NOLOCK) on eh.PKey2 = survey.survey_id
          left join QP_Prod.dbo.STUDY study with (NOLOCK) on survey.study_id = study.study_id
		  left join QP_Prod.dbo.MAILINGMETHODOLOGY mm with (NOLOCK) on mm.SURVEY_ID = survey.SURVEY_ID and mm.BITACTIVEMETHODOLOGY = 1-- S15 US11
		  --left join QP_Prod.dbo.CAHPS_PatInfileCount pif with (NOLOCK) on pif.Sampleset_ID = ss.SAMPLESET_ID -- S20 US11
		  left join QP_Prod.dbo.PeriodDates pdates with (NOLOCK) on pdates.SampleSet_id = ss.SAMPLESET_ID -- S20 US9
		  left join QP_Prod.dbo.PeriodDef pdef on pdef.PeriodDef_id = pdates.PeriodDef_id -- S20 US9
	SET @currDateTime2 = GETDATE();
	SELECT @oExtractRunLogID,@currDateTime2,@TaskName
	EXEC [UpdateExtractRunLog] @oExtractRunLogID, @currDateTime2
END
