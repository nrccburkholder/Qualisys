/****** Object:  Stored Procedure dbo.SP_HH_Check    Script Date: 6/9/99 4:36:35 PM ******/
CREATE PROCEDURE SP_HH_Check @Study_id NUMERIC AS
DECLARE @xsql    VARCHAR(255)
DECLARE @xsql2   VARCHAR(255)
PRINT '********************'
PRINT '* HOUSEHOLD CHECK: *'
PRINT '********************'
SELECT sp.study_id as 'Study ID', sd.survey_id as 'Survey ID', count(*) as 'Sample Size'
 FROM samplepop sp, survey_def sd, sampleset ss
 WHERE sd.survey_id = ss.survey_id 
  AND ss.sampleset_id = sp.sampleset_id
  AND sp.study_id = @Study_id 
 GROUP BY sp.study_id, sd.survey_id
 ORDER BY sp.study_id, sd.survey_id
SELECT @xsql = 'SELECT subscriber_num, count(*) ' +
   'FROM study s, survey_def sd, sampleset ss, samplepop sp, s' + CONVERT(VARCHAR, @Study_id) + '.population p '
SELECT @xsql2 =   'WHERE s.study_id = sd.study_id ' + 
    'AND sd.survey_id = ss.survey_id ' +
    'AND ss.sampleset_id = sp.sampleset_id ' +
    'AND sp.pop_id = p.pop_id ' +
    'AND s.study_id = ' + CONVERT(VARCHAR, @Study_id) + ' ' +
   'GROUP BY subscriber_num ' +
   'HAVING COUNT(*) > 1 '
EXECUTE (@xsql + @xsql2)


