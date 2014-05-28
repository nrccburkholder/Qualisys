-- Stored Procedure

CREATE PROCEDURE [dbo].[csp_ExtractCountsByExtractFileID]
as
	Select ExtractFile.ExtractFileID,Created,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID
	,study.STRSTUDY_NM,'SamplePop' As EntityType,Max(EndTime) As EndTime,COUNT(*) As Count
	From ( Select Distinct PKey1, EntityTypeID,ExtractFileID ,Convert(Varchar,Created,110)As Created
		   From ExtractHistory eh With (NOLOCK) 
		   Where EntityTypeID= 7 and ExtractFileID = 15) eh
	Inner Join QP_Prod.dbo.SAMPLEPOP sp With (NOLOCK) 
	 On sp.samplepop_id = eh.PKey1
	Inner Join QP_Prod.dbo.STUDY study With (NOLOCK) 
	 On sp.STUDY_ID = study.STUDY_ID
	Inner Join QP_Prod.dbo.CLIENT client With (NOLOCK) 
	 On study.CLIENT_ID = client.CLIENT_ID
	Inner Join dbo.ExtractFile ExtractFile
	 On eh.ExtractFileID = ExtractFile.ExtractFileID
	Group By ExtractFile.ExtractFileID,Created,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM
	--Order By ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM
	Union All
	Select ExtractFile.ExtractFileID,Created,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID
	,study.STRSTUDY_NM,'QuestionForm' As EntityType,Max(EndTime) As EndTime,COUNT(*) As Count
	From ( Select Distinct PKey1, EntityTypeID,ExtractFileID ,Convert(Varchar,Created,110)As Created
		   From ExtractHistory eh With (NOLOCK) 
		   Where EntityTypeID= 11 and ExtractFileID = 15) eh
	Inner Join QP_Prod.dbo.QUESTIONFORM qf With (NOLOCK) 
	 On qf.QUESTIONFORM_id = eh.PKey1
	Inner Join QP_Prod.dbo.SURVEY_DEF survey With (NOLOCK) 
	 On qf.SURVEY_ID = survey.SURVEY_ID
	Inner Join QP_Prod.dbo.STUDY study With (NOLOCK) 
	 On survey.STUDY_ID = study.STUDY_ID
	Inner Join QP_Prod.dbo.CLIENT client With (NOLOCK) 
	 On study.CLIENT_ID = client.CLIENT_ID
	Inner Join dbo.ExtractFile ExtractFile
	 On eh.ExtractFileID = ExtractFile.ExtractFileID
	Group By ExtractFile.ExtractFileID,Created,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM
	Order By ExtractFile.ExtractFileID,Created,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM



	Select ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID
	,'' As STUDY_ID,'' As STRSTUDY_NM
	 ,'' As SURVEY_ID,''  As STRSURVEY_NM
	,'1_Client' As EntityType,Max(EndTime) As EndTime,COUNT(*) As Count
	From ( Select Distinct PKey1, EntityTypeID,ExtractFileID 
		   From ExtractHistory eh With (NOLOCK) 
		   Where EntityTypeID= 1 ) eh
	Inner Join QP_Prod.dbo.CLIENT client With (NOLOCK) 
	 On eh.PKey1 = client.CLIENT_ID
	Inner Join dbo.ExtractFile ExtractFile
	 On eh.ExtractFileID = ExtractFile.ExtractFileID
	Group By ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID
	--Order By ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM
	Union All
	Select ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID
	 ,study.STUDY_ID As STUDY_ID,study.STRSTUDY_NM As STRSTUDY_NM
	 ,survey.SURVEY_ID As SURVEY_ID,survey.STRSURVEY_NM As STRSURVEY_NM
	 ,'3_Survey' As EntityType,Max(EndTime) As EndTime,COUNT(*) As Count
	From ( Select Distinct PKey1, ExtractFileID 
		   From ExtractHistory eh With (NOLOCK) 
		   Where EntityTypeID= 3 ) eh
	Inner Join QP_Prod.dbo.SURVEY_DEF survey With (NOLOCK) 
	 On eh.PKey1 = survey.SURVEY_ID
	Inner Join QP_Prod.dbo.STUDY study With (NOLOCK) 
	 On survey.STUDY_ID = study.STUDY_ID
	Inner Join QP_Prod.dbo.CLIENT client With (NOLOCK) 
	 On study.CLIENT_ID = client.CLIENT_ID
	Inner Join dbo.ExtractFile ExtractFile
	 On eh.ExtractFileID = ExtractFile.ExtractFileID
	Group By ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM,survey.SURVEY_ID,survey.STRSURVEY_NM
	Union All
	Select ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID As STUDY_ID
	,study.STRSTUDY_NM As STRSTUDY_NM
	,survey.SURVEY_ID As SURVEY_ID,survey.STRSURVEY_NM As STRSURVEY_NM
	,'4_SurveyQuestion' As EntityType,Max(EndTime) As EndTime,COUNT(*) As Count
	From ( Select Distinct PKey1,PKey2,ExtractFileID 
		   From ExtractHistory eh With (NOLOCK) 
		   Where EntityTypeID= 4 ) eh
	Inner Join QP_Prod.dbo.SURVEY_DEF survey With (NOLOCK) 
	 On eh.PKey2 = survey.SURVEY_ID
	Inner Join QP_Prod.dbo.STUDY study With (NOLOCK) 
	 On survey.STUDY_ID = study.STUDY_ID
	Inner Join QP_Prod.dbo.CLIENT client With (NOLOCK) 
	 On study.CLIENT_ID = client.CLIENT_ID
	Inner Join dbo.ExtractFile ExtractFile
	 On eh.ExtractFileID = ExtractFile.ExtractFileID
	Group By ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM,survey.SURVEY_ID,survey.STRSURVEY_NM
	Union All
	Select ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID As STUDY_ID
	,study.STRSTUDY_NM As STRSTUDY_NM
	,survey.SURVEY_ID As SURVEY_ID,survey.STRSURVEY_NM As STRSURVEY_NM
	,'6_SamplePlan' As EntityType,Max(EndTime) As EndTime,COUNT(*) As Count
	From ( Select Distinct PKey1, ExtractFileID 
		   From ExtractHistory eh With (NOLOCK) 
		   Where EntityTypeID= 6 ) eh
	Inner Join QP_PROD.dbo.SAMPLEUNIT sampleunit With (NOLOCK) 
	 On eh.PKey1 = sampleunit.SAMPLEUNIT_ID
	Inner Join QP_PROD.dbo.SAMPLEPLAN sampleplan With (NOLOCK) 
	 On sampleunit.SAMPLEPLAN_ID = sampleplan.SAMPLEPLAN_ID
	Inner Join QP_Prod.dbo.SURVEY_DEF survey With (NOLOCK) 
	 On sampleplan.SURVEY_ID = survey.SURVEY_ID
	Inner Join QP_Prod.dbo.STUDY study With (NOLOCK) 
	 On survey.STUDY_ID = study.STUDY_ID
	Inner Join QP_Prod.dbo.CLIENT client With (NOLOCK) 
	 On study.CLIENT_ID = client.CLIENT_ID
	Inner Join dbo.ExtractFile ExtractFile
	 On eh.ExtractFileID = ExtractFile.ExtractFileID
	Group By ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID,study.STUDY_ID,study.STRSTUDY_NM,survey.SURVEY_ID,survey.STRSURVEY_NM
	Order By ExtractFile.ExtractFileID,client.STRCLIENT_NM,client.CLIENT_ID--,study.STUDY_ID--,study.STRSTUDY_NM,EntityType,survey.SURVEY_ID,survey.STRSURVEY_NM


