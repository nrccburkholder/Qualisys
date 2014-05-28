CREATE PROCEDURE dbo.tst_JobPrepareTest2
	@ClientID int,
	@isDeleted bit
as
	insert ExtractQueue (EntityTypeID, PKey1, IsMetaData, IsDeleted) values (1, @ClientID, 1, @IsDeleted)
	
	insert ExtractQueue (EntityTypeID, PKey1, IsMetaData, IsDeleted)
		select 2, contact_id, 1, @IsDeleted
		from QP_PROD.dbo.client_contact
		where client_id = @ClientID

	insert ExtractQueue (EntityTypeID, PKey1, IsMetaData, IsDeleted)
		select 3, survey_id, 1, @IsDeleted
		from QP_PROD.dbo.survey_def sd
			inner join QP_PROD.dbo.Study st on st.study_id = sd.study_id
		where client_id = @ClientID
		 -- and survey_id < 1000

	insert ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, IsDeleted)	
		select 4, selqstns_id, q.survey_id, 1, @IsDeleted
		from QP_Prod.dbo.sel_qstns q
			inner join QP_PROD.dbo.survey_def sd on q.survey_id = sd.survey_id
			inner join QP_PROD.dbo.Study st on st.study_id = sd.study_id
		where client_id = @ClientID
		 -- and q.survey_id < 1000

	insert ExtractQueue (EntityTypeID, PKey1, IsMetaData, IsDeleted)
		select 6, sampleunit_id, 1, @IsDeleted
		from QP_Prod.dbo.SAMPLEUNIT su
			inner join QP_Prod.dbo.SAMPLEPLAN sp on su.SAMPLEPLAN_ID = sp.SAMPLEPLAN_ID
			inner join QP_PROD.dbo.survey_def sd on sd.SURVEY_ID = sp.SURVEY_ID
			inner join QP_PROD.dbo.Study st on st.study_id = sd.study_id
		where st.client_id = @ClientID
		 -- and sd.survey_id < 1000


