/****** Object:  Stored Procedure dbo.SP_HH_CrossSurveyAddress    Script Date: 6/9/99 4:36:35 PM ******/
/*********************************************************************************
**** This stored procedure eliminates duplicate sampling for same households  ****
**** whether the duplicates are part of the same survey or part of different  ****
**** surveys of a study.                                                      ****
**********************************************************************************
**** RC - 03/18/1999                                                          **** 
**********************************************************************************/
CREATE PROCEDURE SP_HH_CrossSurveyAddress @Study_id NUMERIC, 
   @adult_target NUMERIC, 
   @child_target NUMERIC, 
   @ovs_target NUMERIC AS
DECLARE @xsql varchar(255)
DECLARE @xsql2 varchar(255)
/*********************************************************************************/
/***** Step 1. identify surveys in the study                                  ****/
/*********************************************************************************/
SELECT survey_id, convert(int, strMailFreq) as Priority 
 INTO #surveys FROM survey_def
 WHERE study_id = @study_id
 ORDER BY convert(int, strMailFreq) 
/*********************************************************************************/
/**** Step 2. identify Subscriber_num's appearing multiple times for the study ***/
/*********************************************************************************/
SELECT @xsql = "SELECT ADDR = P1.ADDR, Counter = count(*) INTO ##DupeNum FROM S"
   + convert(varchar(4), @study_id) + ".population P1, sampleset SS, samplepop sp, #surveys S "
SELECT @xsql2 = "WHERE SS.survey_id = S.survey_id AND SS.sampleset_id = SP.sampleset_id " 
   + "AND SP.pop_id = P1.pop_id GROUP BY P1.ADDR HAVING COUNT(*) > 1"
EXECUTE (@xsql + @xsql2)
/*********************************************************************************/
/* all pop_ids corresponding to subscriber_nums appearing more than once.     ****/
/*********************************************************************************/
SELECT @xsql = "SELECT D1.ADDR, P.pop_id, Priority, SS.sampleset_id, SP.SamplePop_id, SS.Survey_id, Del_flag = 'N' "
    + " INTO ##DelNum FROM ##DupeNum D1, Samplepop SP, SampleSet SS, S" + convert(varchar(4), @study_id) + ".Population P, " 
    + " #Surveys TS "
SELECT @xsql2 = " WHERE D1.ADDR = P.ADDR AND P.pop_id = SP.pop_id AND SS.sampleset_id = SP.sampleset_id"
    + " AND TS.Survey_id = SS.Survey_id"
EXECUTE (@xsql + @xsql2)
/*********************************************************************************/
/**** Step 3.a. identifies duped samples accros surveys with same priority    ****/
/*********************************************************************************/
SELECT @xsql = 'UPDATE D1 ' +
  ' SET D1.Del_flag = ''Y'' ' +
  ' FROM ##DelNum D1, ##DelNum D2 ' +
  ' WHERE D1.ADDR = D2.ADDR ' +
   ' AND D1.Survey_id > D2.Survey_id '
EXECUTE (@xsql)
/*********************************************************************************/
/**** Step 3.b. identifies duped sample within surveys                        ****/
/*********************************************************************************/
SELECT @xsql = 'UPDATE D1 ' +
  ' SET D1.Del_flag = ''Y'' ' +
  ' FROM ##DelNum D1, ##DelNum D2 ' +
  ' WHERE D1.ADDR = D2.ADDR ' +
   ' AND D1.Survey_id = D2.Survey_id ' +
   ' AND D1.samplePop_id > D2.SamplePop_id '
EXECUTE (@xsql)
/*********************************************************************************/
/**** Step 3.c identifies duped samples accross surveys (different priority) *****/
/**** (must use '>' because highest priority has lowest number)              *****/
/*********************************************************************************/
SELECT @xsql = 'UPDATE D1 ' +
 'SET D1.Del_flag = ''Y'' ' +
 'FROM ##DelNum D1, ##DelNum D2 ' +
 ' WHERE D1.ADDR = D2.ADDR ' +
  ' AND D1.priority > D2.priority '
execute (@xsql)
/*********************************************************************************/
/**** Step 3.d deletes all identified duplicate subcriber numbers            *****/
/*********************************************************************************/
SELECT @xsql = 'DELETE ' +
 'samplepop ' +
 'FROM ##DelNum D ' +
 'WHERE D.pop_id = samplepop.pop_id ' +
  'AND D.sampleset_id = samplepop.sampleset_id ' +
  'AND D.del_flag = ''Y'' '
EXECUTE (@xsql)
SELECT @xsql = 'DELETE ' +
 'SelectedSample ' +
 'FROM ##DelNum D ' +
 'WHERE D.pop_id = SelectedSample.pop_id ' +
  'AND D.sampleset_id = SelectedSample.sampleset_id ' +
  'AND D.del_flag = ''Y'' '
EXECUTE (@xsql)
/*********************************************************************************/
/**** Step 4 loops by survey to resize the samples                           *****/
/*********************************************************************************/
DECLARE @target NUMERIC
DECLARE @ssize NUMERIC
DECLARE @Survey_id NUMERIC
DECLARE @Priority INTEGER
DECLARE @DeleteSize INTEGER
DECLARE SurveyCursor CURSOR 
      FOR SELECT survey_id, priority 
  FROM #surveys 
OPEN SurveyCursor
FETCH NEXT FROM SurveyCursor INTO @survey_id, @priority
WHILE @@fetch_status <> -1
BEGIN
  IF @@fetch_status <> -2
  BEGIN
/********* here we assume that all child surveys will be priority 2 *******/
/********* 685 is the number of outgo surveys for children ****************/
    IF @priority = 1
       SELECT @target = @adult_target
    ELSE IF @priority = 2
       SELECT @target = @child_target
    ELSE 
       SELECT @target = @ovs_target
    SELECT @ssize = COUNT(*) 
 FROM SamplePop sp, sampleset ss 
 WHERE sp.sampleSet_id = ss.sampleSet_id 
  AND ss.survey_id = @survey_id
    IF @ssize <= @target 
    BEGIN
       SELECT 'Unable to reduce sample size to target for Survey:' + CONVERT(VARCHAR, @survey_id) + ' Sample Size:' + CONVERT(VARCHAR, @ssize)
    END ELSE BEGIN
    
       SET ROWCOUNT 0
       SELECT @DeleteSize = @ssize - @target
       SET ROWCOUNT @DeleteSize
     
       SELECT SP.* 
 INTO #DelSamp 
 FROM SamplePop SP, SampleSet SS
 WHERE  SP.SampleSet_id = SS.SampleSet_id
  AND SS.Survey_id = @survey_id
       SET ROWCOUNT 0
       DELETE 
 SelectedSample 
 FROM #DelSamp DS
 WHERE DS.pop_id = SelectedSample.Pop_id
     AND DS.SampleSet_id = SelectedSample.SampleSet_id
       DELETE 
 SamplePop 
 FROM #DelSamp DS
 WHERE DS.pop_id = SamplePop .Pop_id
     AND DS.SampleSet_id = SamplePop .SampleSet_id
       SELECT 'Householding of survey ' + CONVERT(VARCHAR,@survey_id) + ' successful'
       DROP TABLE #DelSamp
     END
  END
  FETCH NEXT FROM SurveyCursor INTO @survey_id, @priority
END
/*********************************************************************************/
/**** Step 5. Displaying final QA queries                                     ****/
/*********************************************************************************/
PRINT '*******************'
PRINT '* FINAL QA CHECK: *'
PRINT '*******************'
SELECT sp.study_id as 'Study ID', sd.survey_id as 'Survey ID', count(*) as 'Sample Size'
 FROM samplepop sp, survey_def sd, sampleset ss
 WHERE sd.survey_id = ss.survey_id 
  AND ss.sampleset_id = sp.sampleset_id
  AND sp.study_id = @Study_id 
 GROUP BY sp.study_id, sd.survey_id
 ORDER BY sp.study_id, sd.survey_id
SELECT @xsql = 'SELECT ADDR, count(*) ' +
   'FROM study s, survey_def sd, sampleset ss, samplepop sp, s' + CONVERT(VARCHAR, @Study_id) + '.population p '
SELECT @xsql2 =   'WHERE s.study_id = sd.study_id ' + 
    'AND sd.survey_id = ss.survey_id ' +
    'AND ss.sampleset_id = sp.sampleset_id ' +
    'AND sp.pop_id = p.pop_id ' +
    'AND s.study_id = ' + CONVERT(VARCHAR, @Study_id) + ' ' +
   'GROUP BY ADDR ' +
   'HAVING COUNT(*) > 1 '
EXECUTE (@xsql + @xsql2)
/*********************************************************************************/
/**** Step 6. Cleaning temp tables and memory                                 ****/
/*********************************************************************************/
DROP TABLE ##DelNum
DROP TABLE ##DupeNum
CLOSE SurveyCursor 
DEALLOCATE SurveyCursor


