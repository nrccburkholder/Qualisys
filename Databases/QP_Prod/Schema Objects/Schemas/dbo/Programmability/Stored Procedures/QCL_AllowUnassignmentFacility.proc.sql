----------------------------
CREATE PROCEDURE QCL_AllowUnassignmentFacility
@FacilityId INT,
@ClientId INT
AS

--Return 1 if facility can be unassigned, otherwise return 0
IF EXISTS (SELECT * 
			FROM SampleUnit su, sampleplan sp, survey_def sd, study s 
			WHERE su.SUFacility_id = @FacilityId
					and su.sampleplan_Id=sp.sampleplan_Id
					and sp.survey_id=sd.survey_id
					and sd.study_id=s.study_id
					and s.client_id=@clientId)
BEGIN
	SELECT 0
END
ELSE
BEGIN
	SELECT 1
END
----------------------------


