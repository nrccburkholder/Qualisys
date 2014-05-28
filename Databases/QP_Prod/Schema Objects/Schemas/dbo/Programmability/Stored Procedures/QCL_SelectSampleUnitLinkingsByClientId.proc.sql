CREATE PROCEDURE QCL_SelectSampleUnitLinkingsByClientId
@ClientId INT

AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET NOCOUNT ON

CREATE TABLE #Display (
     FromStudyID INT,
     FromStudyName VARCHAR(42),
     FromSurveyID INT,
     FromSurveyName VARCHAR(42),
     FromSampleUnitName VARCHAR(42),
     FromSampleUnitID INT,
     ToStudyID INT,
     ToStudyName VARCHAR(42),
     ToSurveyID INT,
     ToSurveyName VARCHAR(42),
     ToSampleUnitName VARCHAR(42),
     ToSampleUnitID INT
)

INSERT INTO #Display (FromStudyID, FromStudyName, FromSurveyID, 
     FromSurveyName, FromSampleUnitName, FromSampleUnitID, 
     ToSampleUnitID)
SELECT s.Study_id, strStudy_nm, sd.Survey_id, strSurvey_nm, 
     strSampleUnit_nm, su.SampleUnit_id, LinkSampleUnit_id     
FROM Study s, Survey_def sd, SamplePlan sp, SampleUnit su, SampleUnitLinkage sul
WHERE s.Client_id=@ClientID
AND s.Study_id=sd.Study_id
AND sd.Survey_id=sp.Survey_id
AND sp.SamplePlan_id=su.SamplePlan_id
AND su.SampleUnit_id=sul.SampleUnit_id

UPDATE t
SET ToStudyID=s.Study_id, ToStudyName=s.strStudy_nm, 
     ToSurveyID=sd.Survey_id, ToSurveyName=sd.strSurvey_nm,
     ToSampleUnitName=su.strSampleUnit_nm
FROM #Display t, SampleUnit su, SamplePlan sp, Survey_def sd, Study s
WHERE t.ToSampleUnitID=su.SampleUnit_id
AND su.SamplePlan_id=sp.SamplePlan_id
AND sp.Survey_id=sd.Survey_id
AND sd.Study_id=s.Study_id

SELECT * FROM #Display

DROP TABLE #Display

/*
SELECT s1.Study_id FromStudyId, s1.strStudy_nm FromStudyName, 
	sd1.Survey_id FromSurveyId, sd1.strSurvey_nm FromSurveyName, 
	su1.strSampleUnit_nm FromSampleUnitName, sul.SampleUnit_id FromSampleUnitId, 
	s2.Study_id ToStudyId, s2.strStudy_nm ToStudyName,
	sd2.Survey_id ToSurveyId, sd2.strSurvey_nm ToSurveyName,
	su2.strSampleUnit_nm ToSampleUnitName, sul.LinkSampleUnit_id ToSampleUnitId
FROM SampleUnitLinkage sul, SampleUnit su1, SamplePlan sp1, Survey_Def sd1, Study s1, SampleUnit su2, SamplePlan sp2, Survey_Def sd2, Study s2
WHERE sul.SampleUnit_id = su1.SampleUnit_id
AND su1.SamplePlan_id = sp1.SamplePlan_id
AND sp1.Survey_id = sd1.Survey_id
AND sd1.Study_id = s1.Study_id
AND s1.Client_id = @ClientId
AND sul.LinkSampleUnit_id = su2.SampleUnit_id
AND su2.SamplePlan_id = sp2.SamplePlan_id
AND sp2.Survey_id = sd2.Survey_id
AND sd2.Study_id = s2.Study_id
*/

SET TRANSACTION ISOLATION LEVEL READ COMMITTED
SET NOCOUNT OFF


