----------------------------
CREATE PROCEDURE [dbo].[QCL_AllowUnassignmentFacility]
@FacilityId INT,
@ClientId INT,
@IsPracticeSite bit = false
AS

--Return 1 if facility can be unassigned, otherwise return 0
IF ((@IsPracticeSite is null) or (@IsPracticeSite = 0)) and EXISTS (SELECT * 
			FROM SampleUnit su, sampleplan sp, survey_def sd, study s, SUFacility suf
			WHERE su.SUFacility_id = @FacilityId
					and su.sampleplan_Id=sp.sampleplan_Id
					and sp.survey_id=sd.survey_id
					and sd.study_id=s.study_id
					and s.client_id=@clientId
					and suf.SUFacility_id = su.SUFacility_id)
BEGIN
	SELECT 0
END
ELSE
BEGIN
	IF (@IsPracticeSite = 1) AND EXISTS (SELECT * 
			FROM SampleUnit su, sampleplan sp, survey_def sd, study s, PracticeSite ps
			WHERE su.SUFacility_id = @FacilityId
					and su.sampleplan_Id=sp.sampleplan_Id
					and sp.survey_id=sd.survey_id
					and sd.study_id=s.study_id
					and s.client_id=@clientId
					and ps.PracticeSite_ID = su.SUFacility_id)
	BEGIN
		SELECT 0
	END
	ELSE
	BEGIN
		SELECT 1
	END
END
----------------------------


