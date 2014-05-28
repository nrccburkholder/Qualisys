CREATE PROCEDURE sp_AssignReportLvls AS

DECLARE @level_id INT
SET @level_id = 1

CREATE TABLE #children (
	survey_id 		INT, 
	sampleplan_id 		INT, 
	sampleunit_id 		INT, 
	prnt_sampleunit_id 	INT)

CREATE TABLE #parents (
	survey_id 		INT, 
	sampleplan_id 		INT, 
	sampleunit_id 		INT, 
	reporting_hierarchy_id 	INT)

/*begin transaction*/
/* Get the first level children that have not been assigned a hierarchy */
INSERT INTO #children (survey_id, sampleplan_id, sampleunit_id)
	SELECT sp.survey_id, sp.sampleplan_id, su.sampleunit_id
	FROM sampleplan sp, sampleunit su
	WHERE sp.sampleplan_id = su.sampleplan_id
	AND su.parentsampleunit_id IS NULL
	AND su.reporting_hierarchy_id IS NULL

/* Create the new reporting hierarchy entry for this level */
INSERT INTO reportinghierarchy (survey_id, study_id, reporting_level_nm, prnt_reporting_hierarchy_id)
	SELECT sd.survey_id, sd.study_id, 'Level ' + CONVERT( VARCHAR( 9 ),@level_id ), NULL
	FROM #children c, survey_def sd
	WHERE c.survey_id = sd.survey_id
	AND NOT EXISTS (
		SELECT reporting_hierarchy_id
		FROM reportinghierarchy
		WHERE survey_id = sd.survey_id
		AND reporting_level_nm = 'Level ' + CONVERT( VARCHAR( 9 ),@level_id)
		AND prnt_reporting_hierarchy_id IS NULL)

/* Assign this number back to the parents in Sampleunit */
UPDATE sampleunit
SET reporting_hierarchy_id = rh.reporting_hierarchy_id
FROM sampleunit su, sampleplan sp, reportinghierarchy rh, #children c
WHERE su.sampleplan_id = sp.sampleplan_id
AND sp.survey_id = rh.survey_id
AND su.sampleunit_id = c.sampleunit_id
AND rh.reporting_level_nm = 'Level ' + CONVERT( VARCHAR( 9 ),@level_id)

/* Now, do these same steps for each of the children. */
INSERT INTO #parents (survey_id, sampleplan_id, sampleunit_id, reporting_hierarchy_id)
	SELECT c.survey_id, c.sampleplan_id, c.sampleunit_id, su.reporting_hierarchy_id
	FROM #children c, sampleunit su
	WHERE c.sampleunit_id = su.sampleunit_id

WHILE @@rowcount > 0
BEGIN
	SET @level_id = @level_id + 1
	TRUNCATE TABLE #children

	/* Get the Nth level children that have not been assigned a hierarchy */
	
	INSERT INTO #children (survey_id, sampleplan_id, sampleunit_id, prnt_sampleunit_id)
		SELECT sp.survey_id, sp.sampleplan_id, su.sampleunit_id, su.parentsampleunit_id
		FROM sampleplan sp, sampleunit su, #parents p
		WHERE sp.sampleplan_id = su.sampleplan_id
		AND su.parentsampleunit_id = p.sampleunit_id
		AND su.reporting_hierarchy_id IS NULL

	/* Create the new reporting hierarchy entry for this level */
	
	INSERT INTO reportinghierarchy (survey_id, study_id, reporting_level_nm, prnt_reporting_hierarchy_id)
		SELECT DISTINCT sd.survey_id, sd.study_id, 'Level ' + convert(varchar(9),@level_id), p.reporting_hierarchy_id
		FROM #parents p, #children c, survey_def sd
		WHERE c.survey_id = sd.survey_id
		AND p.survey_id = c.survey_id
		AND p.sampleunit_id = c.prnt_sampleunit_id
		AND NOT EXISTS (
			SELECT reporting_hierarchy_id
			FROM reportinghierarchy
			WHERE survey_id = sd.survey_id
			AND reporting_level_nm = 'Level ' + CONVERT( VARCHAR( 9 ),@level_id)
			AND prnt_reporting_hierarchy_id = p.reporting_hierarchy_id)

	/* Assign this number back to the parents in Sampleunit */

	UPDATE sampleunit
	SET reporting_hierarchy_id = rh.reporting_hierarchy_id
	FROM sampleunit su, sampleplan sp, reportinghierarchy rh, #children c, #parents p
	WHERE su.sampleplan_id = sp.sampleplan_id
	AND sp.survey_id = rh.survey_id
	AND su.sampleunit_id = c.sampleunit_id
	AND c.prnt_sampleunit_id = p.sampleunit_id
	AND p.reporting_hierarchy_id = rh.prnt_reporting_hierarchy_id

	TRUNCATE TABLE #parents
	/* Now, do these same steps for each of the children. */
	INSERT INTO #parents (survey_id, sampleplan_id, sampleunit_id, reporting_hierarchy_id)
		SELECT c.survey_id, c.sampleplan_id, c.sampleunit_id, su.reporting_hierarchy_id
		FROM #children c, sampleunit su
		WHERE c.sampleunit_id = su.sampleunit_id
END

DROP TABLE #children
DROP TABLE #parents


