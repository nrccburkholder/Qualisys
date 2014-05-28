/****** Object:  Stored Procedure dbo.SP_HH_CrossSurvey    Script Date: 4/6/99 7:16:24 AM ******/
/* ??? */
/* Last Modified by:  Daniel Vansteenburg - 5/5/1999 */
CREATE PROCEDURE SP_HH_CrossSurvey
 @Study_id int, 
 @adult_target int, 
 @child_target int, 
 @ovs_target int
AS
declare @xsql varchar(255)
declare @xsql2 varchar(255)
/* 1. identify surveys in the study */
SELECT survey_id, convert(int, strMailFreq) as Priority 
 INTO #surveys FROM dbo.survey_def
 WHERE study_id = @study_id
 ORDER BY convert(int, strMailFreq) 
/* 2. identify Subscriber_num's appearing multiple times for the study */
select @xsql = "SELECT SNum = P1.Subscriber_Num, Counter = count(*) INTO ##DupeNum FROM S"
   + convert(varchar(4), @study_id) + ".population P1, sampleset SS, samplepop sp, #surveys S "
select @xsql2 = "WHERE SS.survey_id = S.survey_id AND SS.sampleset_id = SP.sampleset_id " 
   + "AND SP.pop_id = P1.pop_id GROUP BY P1.Subscriber_Num HAVING COUNT(*) > 1"
execute (@xsql + @xsql2)
SELECT @xsql = 'SELECT * FROM ##DupeNum'
execute (@xsql)
/* all pop_ids corresponding to subscriber_nums appearing more than once. */
select @xsql = "SELECT D1.SNum, P.pop_id, Priority, SS.sampleset_id, SP.SamplePop_id, SS.Survey_id, Del_flag = 'N' "
    + " INTO ##DelNum FROM ##DupeNum D1, dbo.Samplepop SP, dbo.SampleSet SS, S" + convert(varchar(4), @study_id) + ".Population P, " 
    + " #Surveys TS "
select @xsql2 = " WHERE D1.SNum = P.Subscriber_Num AND P.pop_id = SP.pop_id AND SS.sampleset_id = SP.sampleset_id"
    + " AND TS.Survey_id = SS.Survey_id"
execute (@xsql + @xsql2)
/* 3.a. deletes duped sample within surveys */
SELECT @xsql = 'SELECT D1.* FROM ##DelNum D1, ##DelNum D2 ' +
  'WHERE D1.SNum = D2.SNum ' +
  'AND D1.Survey_id = D2.Survey_id ' +
  'AND D1.samplePop_id > D2.SamplePop_id '
SELECT (@xsql)
execute (@xsql)
SELECT @xsql = 'UPDATE D1 ' +
  ' SET D1.Del_flag = ''Y'' ' +
  ' FROM ##DelNum D1, ##DelNum D2 ' +
  ' WHERE D1.SNum = D2.SNum ' +
  ' AND D1.Survey_id = D2.Survey_id ' +
  ' AND D1.samplePop_id > D2.SamplePop_id '
SELECT (@xsql)
execute (@xsql)
/* 3.b delete duped sample from all but highest priority  */
/* (must use '>' because highest priority has lowest number) */
SELECT @xsql = 'SELECT D1.* FROM ##DelNum D1, ##DelNum D2 ' +
  'WHERE D1.SNum = D2.SNum ' +
  'AND D1.priority > D2.priority '
SELECT (@xsql)
execute (@xsql)
SELECT @xsql = 'UPDATE D1 ' +
 'SET D1.Del_flag = ''Y'' ' +
 'FROM ##DelNum D1, ##DelNum D2 ' +
 'WHERE D1.SNum = D2.SNum ' +
  'AND D1.priority > D2.priority '
SELECT (@xsql)
execute (@xsql)
SELECT @xsql = 'SELECT * FROM ##DelNum'
EXECUTE (@xsql)
SELECT @xsql = 'DELETE ' +
 'dbo.samplepop ' +
 'FROM ##DelNum D ' +
 'WHERE D.pop_id = samplepop.pop_id ' +
  'AND D.sampleset_id = samplepop.sampleset_id ' +
  'AND D.del_flag = ''Y'' '
SELECT @xsql
EXECUTE (@xsql)
SELECT @xsql = 'DELETE ' +
 'dbo.SelectedSample ' +
 'FROM ##DelNum D ' +
 'WHERE D.pop_id = SelectedSample.pop_id ' +
  'AND D.sampleset_id = SelectedSample.sampleset_id ' +
  'AND D.del_flag = ''Y'' '
SELECT @xsql
EXECUTE (@xsql)
/* 4. adjust sample size downward to target where necessary */
DECLARE @target int
DECLARE @ssize int
DECLARE @Survey_id int
DECLARE @Priority INTEGER
DECLARE @DeleteSize INTEGER
DECLARE SurveyCursor CURSOR 
      FOR SELECT survey_id, priority 
  FROM #surveys 
OPEN SurveyCursor
FETCH NEXT FROM SurveyCursor INTO @survey_id, @priority
WHILE @@fetch_status = 0
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
 FROM dbo.SamplePop sp, dbo.sampleset ss 
 WHERE sp.sampleSet_id = ss.sampleSet_id 
  AND ss.survey_id = @survey_id
    SELECT SampleSize = @ssize
    IF @ssize <= @target 
    BEGIN
       SELECT 'Unable to reduce sample size to target for Survey:' + CONVERT(VARCHAR, @survey_id) + ' Sample Size:' + CONVERT(VARCHAR, @ssize)
    END ELSE BEGIN
    
       SET ROWCOUNT 0
       SELECT @DeleteSize = @ssize - @target
       SET ROWCOUNT @DeleteSize
     
       SELECT SP.* 
 INTO #DelSamp 
 FROM dbo.SamplePop SP, dbo.SampleSet SS
 WHERE  SP.SampleSet_id = SS.SampleSet_id
  AND SS.Survey_id = @survey_id
       SELECT * FROM #DelSamp
       SET ROWCOUNT 0
       DELETE 
 dbo.SelectedSample 
 FROM #DelSamp DS
 WHERE DS.pop_id = SelectedSample.Pop_id
     AND DS.SampleSet_id = SelectedSample.SampleSet_id
       DELETE 
 dbo.SamplePop 
 FROM #DelSamp DS
 WHERE DS.pop_id = SamplePop .Pop_id
     AND DS.SampleSet_id = SamplePop .SampleSet_id
       SELECT 'Householding of survey ' + CONVERT(VARCHAR,@survey_id) + ' successful'
       DROP TABLE #DelSamp
     END
  FETCH NEXT FROM SurveyCursor INTO @survey_id, @priority
END
SELECT 'FINAL SAMPLES:'
SELECT * FROM dbo.SAMPLEPOP WHERE Study_ID = @Study_id
SELECT * FROM dbo.SELECTEDSAMPLE WHERE Study_ID = @Study_id
CLOSE SurveyCursor 
DEALLOCATE SurveyCursor


