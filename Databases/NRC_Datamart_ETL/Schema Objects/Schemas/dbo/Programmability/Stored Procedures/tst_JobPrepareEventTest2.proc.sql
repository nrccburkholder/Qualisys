CREATE PROCEDURE [dbo].[tst_JobPrepareEventTest2]
@ClientID INT
AS
insert ExtractQueue (EntityTypeID, PKey1, IsMetaData, IsDeleted)
		select top 900 7, sp.samplepop_id, 0, 0
		from QP_PROD.dbo.survey_def sd with (NOLOCK)
			inner join QP_PROD.dbo.Study st with (NOLOCK) on st.study_id = sd.study_id
			inner join QP_Prod.dbo.SampleSet ss with (NOLOCK) on ss.Survey_id = sd.survey_id	
            inner join QP_Prod.dbo.SamplePop sp on ss.sampleset_id	 = sp.sampleset_id		
		where st.client_id = @ClientID
		  and sd.survey_id < 1000		
		  and sp.samplepop_id < 2537750
   
    --sample pop deletes
    insert ExtractQueue (EntityTypeID, PKey1, PKey2,IsMetaData, IsDeleted)
	  select top 3 7, sp.samplepop_id,sp.sampleset_id, 0, 1
	  from ExtractQueue eq
		inner join QP_Prod.dbo.SamplePop sp on eq.PKey1 = sp.sampleset_id
	  where eq.EntityTypeID = 8
	   and sp.samplepop_id < 2537750

    --question form inserts
	insert ExtractQueue (EntityTypeID, PKey1, IsMetaData, IsDeleted)
		select 11, qf.questionform_id, 0, 0
		from ExtractQueue eq
				inner join QP_Prod.dbo.QuestionForm qf on eq.PKey1 = qf.SamplePop_id
		where eq.EntityTypeID = 7

    --question form deletes
	insert ExtractQueue (EntityTypeID, PKey1, IsMetaData, IsDeleted)
		select top 3 11, qf.questionform_id, 0, 1
		from ExtractQueue eq
				inner join QP_Prod.dbo.QuestionForm qf on eq.PKey1 = qf.SamplePop_id
		where eq.EntityTypeID = 7

	--sample set deletes
    insert ExtractQueue (EntityTypeID, PKey1, PKey2, IsMetaData, IsDeleted)
		select top 1 8, ss.sampleset_id,ss.Survey_id, 0, 1
		from QP_PROD.dbo.survey_def sd with (NOLOCK)
			inner join QP_PROD.dbo.Study st with (NOLOCK) on st.study_id = sd.study_id
			inner join QP_Prod.dbo.SampleSet ss with (NOLOCK) on ss.Survey_id = sd.survey_id			
		where st.client_id = @ClientID
		  and sd.survey_id < 1000


