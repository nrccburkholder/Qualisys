/****** Object:  Stored Procedure dbo.SP_HH_CrossSurveyNoResize    Script Date: 6/9/99 4:36:35 PM ******/
/*********************************************************************************
**** This stored procedure eliminates duplicate sampling for same households  ****
**** whether the duplicates are part of the same survey or part of different  ****
**** surveys of a study.                                                      ****
**********************************************************************************
**** RC - 03/14/1999                                                          **** 
**********************************************************************************/
CREATE PROCEDURE SP_HH_CrossSurveyNoResize @Study_id NUMERIC AS
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
SELECT @xsql = "SELECT SNum = P1.Subscriber_Num, Counter = count(*) INTO ##DupeNum FROM S"
   + convert(varchar(4), @study_id) + ".population P1, sampleset SS, samplepop sp, #surveys S "
SELECT @xsql2 = "WHERE SS.survey_id = S.survey_id AND SS.sampleset_id = SP.sampleset_id " 
   + "AND SP.pop_id = P1.pop_id GROUP BY P1.Subscriber_Num HAVING COUNT(*) > 1"
EXECUTE (@xsql + @xsql2)
/*********************************************************************************/
/* all pop_ids corresponding to subscriber_nums appearing more than once.     ****/
/*********************************************************************************/
SELECT @xsql = "SELECT D1.SNum, P.pop_id, Priority, SS.sampleset_id, SP.SamplePop_id, SS.Survey_id, Del_flag = 'N' "
    + " INTO ##DelNum FROM ##DupeNum D1, Samplepop SP, SampleSet SS, S" + convert(varchar(4), @study_id) + ".Population P, " 
    + " #Surveys TS "
SELECT @xsql2 = " WHERE D1.SNum = P.Subscriber_Num AND P.pop_id = SP.pop_id AND SS.sampleset_id = SP.sampleset_id"
    + " AND TS.Survey_id = SS.Survey_id"
EXECUTE (@xsql + @xsql2)
/*********************************************************************************/
/**** Step 3.a. identifies duped samples accros surveys with same priority    ****/
/*********************************************************************************/
SELECT @xsql = 'UPDATE D1 ' +
  ' SET D1.Del_flag = ''Y'' ' +
  ' FROM ##DelNum D1, ##DelNum D2 ' +
  ' WHERE D1.SNum = D2.SNum ' +
  ' AND D1.Survey_id > D2.Survey_id '
EXECUTE (@xsql)
/*********************************************************************************/
/**** Step 3.b. identifies duped sample within surveys                        ****/
/*********************************************************************************/
SELECT @xsql = 'UPDATE D1 ' +
  ' SET D1.Del_flag = ''Y'' ' +
  ' FROM ##DelNum D1, ##DelNum D2 ' +
  ' WHERE D1.SNum = D2.SNum ' +
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
 'WHERE D1.SNum = D2.SNum ' +
  'AND D1.priority > D2.priority '
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
/*********************************************************************************/
/**** Step 6. Cleaning temp tables and memory                                 ****/
/*********************************************************************************/
DROP TABLE ##DelNum
DROP TABLE ##DupeNum


