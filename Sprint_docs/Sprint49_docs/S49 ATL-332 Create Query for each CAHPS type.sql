

use odsdb


IF OBJECT_ID('tempdb..#SurveyType') IS NOT NULL DROP TABLE #SurveyType


CREATE TABLE #SurveyType([SurveyType] [varchar](100) NOT NULL)


INSERT INTO #SurveyType([SurveyType])VALUES('ACOCAHPS')
--INSERT INTO #SurveyType([SurveyType])VALUES('CGCAHPS')
INSERT INTO #SurveyType([SurveyType])VALUES('HCAHPS')
INSERT INTO #SurveyType([SurveyType])VALUES('HHCAHPS')
INSERT INTO #SurveyType([SurveyType])VALUES('HOSPICE')
INSERT INTO #SurveyType([SurveyType])VALUES('ICHCAHPS')
INSERT INTO #SurveyType([SurveyType])VALUES('OAS')
INSERT INTO #SurveyType([SurveyType])VALUES('PQRS')


SELECT st.SurveyType, Event_Sampled_Count, Event_Generated_Count, Event_Returned_Count, Event_Returned_Count_Medusa, Event_Returned_Count_Catalyst
FROM #SurveyType st
LEFT JOIN (SELECT SurveyType, count(*) Event_Sampled_Count
			FROM [dbo].[Event_Sampled]
			GROUP BY SurveyType) s1 on s1.SurveyType = st.SurveyType
LEFT JOIN (SELECT SurveyType, count(*) Event_Generated_Count 
			FROM (SELECT distinct evg.CustomerID, evg.UniqueEncounterID, evg.SurveyType 
					FROM [dbo].[Event_Generated] evg
					INNER JOIN [dbo].[Event_Sampled] evs on evs.CustomerID = evg.CustomerID and evs.UniqueEncounterID = evg.UniqueEncounterID
			) eg
			GROUP BY SurveyType) s2 on s2.SurveyType = st.SurveyType
LEFT JOIN (SELECT SurveyType, count(*) Event_Returned_Count 
			FROM (SELECT distinct evr.CustomerID, evr.UniqueEncounterID, evr.SurveyType 
					FROM [dbo].[Event_Returned] evr
					INNER JOIN [dbo].[Event_Sampled] evs on evs.CustomerID = evr.CustomerID and evs.UniqueEncounterID = evr.UniqueEncounterID
			) er
			GROUP BY SurveyType) s3 on s3.SurveyType = st.SurveyType
LEFT JOIN (SELECT SurveyType, count(*) Event_Returned_Count_Medusa 
			FROM (SELECT distinct evr.CustomerID, evr.UniqueEncounterID, evr.SurveyType 
					FROM [dbo].[Event_Sample_Extracted_Medusa] evr
					INNER JOIN [dbo].[Event_Sampled] evs on evs.CustomerID = evr.CustomerID and evs.UniqueEncounterID = evr.UniqueEncounterID
			) er
			GROUP BY SurveyType) s4 on s4.SurveyType = st.SurveyType
LEFT JOIN (SELECT SurveyType, count(*) Event_Returned_Count_Catalyst 
			FROM (SELECT distinct evr.CustomerID, evr.UniqueEncounterID, evr.SurveyType 
					FROM [dbo].[Event_Responses_Extracted_Catalyst] evr
					INNER JOIN [dbo].[Event_Sampled] evs on evs.CustomerID = evr.CustomerID and evs.UniqueEncounterID = evr.UniqueEncounterID
			) er
			GROUP BY SurveyType) s5 on s5.SurveyType = st.SurveyType
ORDER BY st.SurveyType

