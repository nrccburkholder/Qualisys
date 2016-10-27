CREATE PROCEDURE [QualisysStudy].[GetQuestionsByStudy]
 @Study_ID varchar(10)

AS
 SET NOCOUNT ON
 BEGIN  
       
		SELECT DISTINCT ClientName,vcss.Survey_ID AS Survey_ID,SurveyName,SurveyType,rt.Label AS QuestionType
						,sq.MasterQuestionCore
						,IsNull(CAST(lt.Value AS VARCHAR(300)),CAST(q.Label AS VARCHAR(300))) AS GenericQuestionText
						,vsq.ResponseValue,CAST(vsq.Scale AS VARCHAR(100)) AS Scale
						,CAST((CASE WHEN psd.isproblem is null THEN 'NULL' WHEN psd.isproblem = 0 THEN 'TRUE' ELSE 'FALSE' END) AS VARCHAR(10)) Positive
						,rr.TopNRank
		FROM [Catalyst].NRC_DataMart_CA.dbo.v_ClientStudySurvey vcss
		INNER JOIN [QualisysStudy].IncludeSurveyType st ON vcss.SurveyTypeID = st.SurveyTypeID AND st.InactivatedBy IS NULL
		INNER JOIN [Catalyst].NRC_DataMart_CA.dbo.SurveyQuestion sq   ON vcss.surveyID = sq.SurveyID--sq.SurveyQuestionID = sq.SurveyQuestionID
		INNER JOIN [Catalyst].NRC_DataMart_CA.dbo.v_ScaleItem vsq  ON sq.SurveyQuestionID = vsq.SurveyQuestionID
		INNER JOIN [Catalyst].NRC_DataMart_CA.dbo.Question q  ON sq.OriginalQuestionCore = q.QuestionCore
		LEFT JOIN [Catalyst].NRC_DataMart_CA.dbo.ResponseType rt  ON sq.ResponseTypeID = rt.ResponseTypeID
		LEFT JOIN [Catalyst].NRC_DataMart_CA.dbo.LocalizedText lt  ON sq.MasterQuestionCore = lt.EntityID  AND lt.LanguageID = 1 
		LEFT JOIN [Catalyst].NRC_DataMart_CA.dbo.ResponseRank rr  ON  lt.EntityTypeID = 13 AND sq.MasterQuestionCore = rr.MasterQuestionCore AND vsq.ResponseValue = rr.ResponseValue
		LEFT JOIN [Catalyst].NRC_DataMart_CA.dbo.ProblemScoreDefinition psd ON psd.MasterQuestionCore = sq.MasterQuestionCore AND psd.ResponseValue = vsq.ResponseValue
		LEFT JOIN [QualisysStudy].ExcludedSurvey exclude  ON vcss.Survey_ID = exclude.Survey_ID
		WHERE vcss.Study_ID  = @Study_ID 
			AND exclude.Survey_ID IS NULL	 


   
END
