--Created 1/27/3 BD Populate the enc_id column in selectedsample.  This 
--     allows us to get rid of Unikeys.  If enc_id is null, the study does not
--     have an encounter table and therefore you can use the pop_id from 
--     selectedsample.
CREATE PROCEDURE SP_Samp_SelectedSampleEncid @intSampleSet_id INT
AS

DECLARE @study INT, @table INT, @sql VARCHAR(2000)

SELECT @table = table_id, @study = sd.study_id FROM metatable mt, survey_def sd, sampleset ss 
		WHERE ss.sampleset_id = @intSampleSet_id
		AND ss.survey_id = sd.survey_id
		AND sd.study_id = mt.study_id
		AND mt.strtable_nm = 'encounter'

IF @table = NULL
RETURN

BEGIN

SET @sql = 'UPDATE ss ' + 
	' SET ss.enc_id = u.keyvalue ' +
	' FROM selectedsample ss, s' + CONVERT(VARCHAR,@study) + '.unikeys u ' +
	' WHERE ss.sampleset_id = ' + CONVERT(VARCHAR,@intSampleSet_id) + 
	' AND ss.sampleset_id = u.sampleset_id ' + 
	' AND ss.pop_id = u.pop_id ' + 
	' AND ss.sampleunit_id = u.sampleunit_id ' + 
	' AND u.table_id = ' + CONVERT(VARCHAR,@table)

EXEC (@sql)

END


