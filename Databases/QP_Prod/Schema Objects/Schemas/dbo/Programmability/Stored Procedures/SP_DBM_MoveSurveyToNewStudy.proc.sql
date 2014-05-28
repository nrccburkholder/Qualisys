--Procedure to move a survey to a different study
CREATE PROCEDURE SP_DBM_MoveSurveyToNewStudy
	@Survey_id		INT,
	@Survey_nm		VARCHAR(42),
	@OldStudy_id	INT,
	@NewStudy_id	INT
AS

IF NOT EXISTS (SELECT * FROM Study WHERE Study_id=@OldStudy_id)
BEGIN
	PRINT 'The specified starting study_id does not exist'
	RETURN
END

IF NOT EXISTS (SELECT * FROM Study WHERE Study_id=@NewStudy_id)
BEGIN
	PRINT 'The new study_id does not exist'
	RETURN
END

IF NOT EXISTS (SELECT * FROM Survey_def WHERE Survey_id=@Survey_id AND Study_id=@OldStudy_id)
BEGIN
	PRINT 'The specified survey_id does not belong to the specified study_id'
	RETURN
END

IF NOT EXISTS (SELECT * FROM Survey_def WHERE Survey_id=@Survey_id AND strSurvey_nm=@Survey_nm)
BEGIN
	PRINT 'The survey_id does match the survey name supplied'
	RETURN
END

--Make sure the two studies have the same metastructure
SELECT ISNULL(o.strTable_nm,n.strTable_nm) strTable_nm, ISNULL(o.strField_nm,n.strField_nm) strField_nm, 
	o.Table_id OldTable_id, n.Table_id NewTable_id, ISNULL(o.bitKeyField_flg,n.bitKeyField_flg) bitKeyField_flg
INTO #ms
FROM MetaData_View o FULL JOIN MetaData_View n
ON n.Study_id=@NewStudy_id
AND o.strTable_nm=n.strTable_nm
AND o.strField_nm=n.strField_nm
WHERE o.Study_id=@OldStudy_id

IF EXISTS (SELECT * FROM #ms WHERE OldTable_id IS NULL OR NewTable_id IS NULL)
BEGIN
	PRINT 'The studies do not have the same metastructure'
	RETURN
END

SELECT strTable_nm, OldTable_id, NewTable_id
INTO #Cross
FROM #ms
GROUP BY strTable_nm, OldTable_id, NewTable_id

BEGIN TRANSACTION

--Survey_def
UPDATE Survey_def SET Study_id=@NewStudy_id WHERE Survey_id=@Survey_id
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--BusinessRule
UPDATE BusinessRule SET Study_id=@NewStudy_id WHERE Survey_id=@Survey_id
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--CriteriaStmt
UPDATE cs SET cs.Study_id=@NewStudy_id FROM CriteriaStmt cs, BusinessRule br WHERE br.Survey_id=@Survey_id AND br.CriteriaStmt_id=cs.CriteriaStmt_id
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--UnitDQ
UPDATE UnitDQ SET Study_id=@NewStudy_id WHERE Survey_id=@Survey_id
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--Study_Employee
INSERT INTO Study_Employee 
SELECT Employee_id, @NewStudy_id 
	FROM Study_Employee 
	WHERE Study_id=@OldStudy_id 
	AND Employee_id NOT IN (
		SELECT Employee_id 
		FROM Study_Employee 
		WHERE Study_id=@NewStudy_id)
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--Identify the samplesets associated with the survey to be moved.  This will
--  be used to update SamplePop and SelectedSample.
SELECT SampleSet_id
INTO #s
FROM SampleSet
WHERE Survey_id=@Survey_id

--SamplePop
UPDATE sp
SET sp.Study_id=@NewStudy_id
FROM SamplePop sp, #s t
WHERE t.SampleSet_id=sp.SampleSet_id
AND sp.Study_id=@OldStudy_id
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--SelectedSample
UPDATE ss
SET ss.Study_id=@NewStudy_id
FROM SelectedSample ss, #s t
WHERE t.SampleSet_id=ss.SampleSet_id
AND ss.Study_id=@OldStudy_id
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--ReportingHierarchy
UPDATE ReportingHierarchy SET Study_id=@NewStudy_id WHERE Study_id=@OldStudy_id AND Survey_id=@Survey_id
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

--TagField
INSERT INTO TagField (Tag_id, Table_id, Field_id, Study_id, ReplaceField_flg, strReplaceLiteral)
SELECT Tag_id, NewTable_id, Field_id, @NewStudy_id, ReplaceField_flg, strReplaceLiteral
FROM TagField tf, #Cross t
WHERE tf.Study_id=@OldStudy_id
AND tf.Table_id=t.OldTable_id
AND Tag_id NOT IN (SELECT Tag_id FROM TagField WHERE Study_id=@NewStudy_id)
IF @@ERROR<>0
BEGIN
	ROLLBACK TRANSACTION
	RETURN
END

DROP TABLE #s
DROP TABLE #ms
DROP TABLE #Cross

COMMIT TRANSACTION

PRINT 'Make sure to copy the study tables and reseed the identity value for the _Load tables.'


