USE QP_Comments
go
ALTER PROCEDURE [dbo].[Sp_extract_bubbledata]
AS
  BEGIN
	/**************************************************************************************************************************************************/
	-- Modified 6/24/04 SS -- Identify and include ONLY studies that have a Big_Table_NULL to move data from......
	-- Modified 12/19/07 MB -- Added check to only create indexes --(AggValues and QstnCoreSamplePop)
	--          on Study_Results_Vertical if it does not already exist.  This only causes a problem when
	--          extract dies and has to be manually restarted.
	-- Modified 7/18/2011 MWB
	--   for performance testing going to track numbers for the extract by counting distinct studys, surveys and samplepops processed.
	-- Modified 7/21/2011 MWB
	--   #return sql statements  having alot of issues with performance.
	--   Creating these indexes to see if it helps.
	-- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work
	-- Modified 1/9/2012 DRH - to not create the tmpDedup on the #Dedup temp table ... seems to be causing performance issues on the deletes within the loop--(s)
	-- Modified 02/27/2014 CB - added -5 and -6 as non-response codes. Phone surveys can code -5 as "Refused" and -6 as "Don't Know"
	-- Modified 06/16/2014 TSB - update *CAHPSDisposition table references to use SurveyTypeDispositions table
	-- Modified 09/04/2014 DBG - replaced references to @Server with Qualisys, removed old commented out code
	--                           reformated for readability 
	--                           modified the UPDATE Snnn.Study_Results_work command to accomodate skipped multiple-response responses
	/**************************************************************************************************************************************************/
      SET nocount ON
      SET arithabort ON

      -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work
      --set arithabort on -- for stage only for now 1/8/2013
      DECLARE @Nstrsql  NVARCHAR--(4000),
              @strsql   VARCHAR--(8000),
              @user     VARCHAR--(10),
              @Study   ,
              @Survey  ,
              @strfield VARCHAR--(42)
      DECLARE @cnt    ,
              @core   ,
              @strCore VARCHAR--(20),
              @Gen     DATETIME
      DECLARE @HCAHPS_Complete      ,
              @HCAHPS_NotComplete   ,
              @HHCAHPS_NotComplete  ,
              @HHCAHPS_CompleteMail ,
              @HHCAHPS_CompletePhone

      SELECT @HCAHPS_NotComplete = d.disposition_id
      FROM   disposition d,
             surveytypedispositions hd
      WHERE  d.disposition_id = hd.disposition_id
             AND hd.value = '06'
             AND hd.surveytype_id = 2

      SELECT @HCAHPS_Complete = d.disposition_id
      FROM   disposition d,
             surveytypedispositions hd
      WHERE  d.disposition_id = hd.disposition_id
             AND hd.value = '01'
             AND hd.surveytype_id = 2

      SELECT @HHCAHPS_NotComplete = d.disposition_id
      FROM   disposition d,
             surveytypedispositions hd
      WHERE  d.disposition_id = hd.disposition_id
             AND hd.value = '310'
             AND hd.surveytype_id = 3

      SELECT @HHCAHPS_CompleteMail = d.disposition_id
      FROM   disposition d,
             surveytypedispositions hd
      WHERE  d.disposition_id = hd.disposition_id
             AND hd.value = '110'
             AND hd.surveytype_id = 3

      SELECT @HHCAHPS_CompletePhone = d.disposition_id
      FROM   disposition d,
             surveytypedispositions hd
      WHERE  d.disposition_id = hd.disposition_id
             AND hd.value = '120'
             AND hd.surveytype_id = 3

      insert into drm_tracktimes
      SELECT Getdate--(), 'Call SP_Phase3_QuestionResult_For_Extract'

      EXEC qualisys.qp_prod.dbo.Sp_phase3_questionresult_for_extract

      TRUNCATE TABLE questionresult_work

      TRUNCATE TABLE extract_sr_nonquestion

      CREATE TABLE #coreflds
        --(
           strfield_nm VARCHAR--(20),
           qstncore   ,
           val        ,
           bitsingle   BIT,
           bitused     BIT
        )

      CREATE TABLE #updatebigtable
        --(
           samplepop_id          ,
           tableschema            VARCHAR--(10),
           tablename              VARCHAR--(200),
           bitcomplete            BIT,
           daysfromfirstmailing  ,
           daysfromcurrentmailing,
           langid                
        )

      -- CREATE TABLE #TableCheck --(TableSchema VARCHAR--(10), TableName VARCHAR--(200))
      PRINT 'updating QuestionResult_Work'

      insert into questionresult_work
                  --(questionform_id,
                   strlithocode,
                   samplepop_id,
                   val,
                   sampleunit_id,
                   qstncore,
                   datmailed,
                   datimported,
                   study_id,
                   datgenerated,
                   survey_id)
      SELECT questionform_id,
             strlithocode,
             samplepop_id,
             val,
             sampleunit_id,
             qstncore,
             datmailed,
             datimported,
             study_id,
             datgenerated,
             survey_id
      FROM   qualisys.qp_prod.dbo.cmnt_questionresult_work

      --************************************************************************************************
      --mwb 7/18/2011
      --for performance testing going to track numbers for the extract
      DECLARE @studyCount    ,
              @surveyCount   ,
              @samplepopCount

      SELECT @StudyCount = Count--(DISTINCT study_id),
             @SurveyCount = Count--(DISTINCT survey_id),
             @SamplePopCount = Count--(DISTINCT samplepop_id)
      FROM   questionresult_work

      insert into extract_processingcounts
                  --(datrun,
                   studiesprocessed,
                   surveysprocessed,
                   samplepopsprocessed)
      VALUES      --(Getdate--(),
                   @studyCount,
                   @surveyCount,
                   @samplepopCount)

      --mwb 12/28/2012
      --further performance code to tract survey Types by day
      insert into extract_surveycounts
                  --(surveytype,
                   surveycounts)
      SELECT st.surveytype_dsc,
             Count--(qrw.survey_id)
      FROM   questionresult_work qrw,
             qualisys.qp_prod.dbo.survey_def sd,
             qualisys.qp_prod.dbo.surveytype st
      WHERE  qrw.survey_id = sd.survey_id
             AND sd.surveytype_id = st.surveytype_id
      GROUP  BY st.surveytype_dsc

      --select * from Extract_processingCounts
      --************************************************************************************************
      insert into drm_tracktimes
      SELECT Getdate--(), 'insert into Extract_SR_NonQuestion'

      PRINT 'Updating Extract_SR_NonQuestion'

      --Now to insert into Extract_SR_NonQuestion for the datamart
      --This is used at a later step in the extract
      insert into extract_sr_nonquestion
                  --(study_id,
                   survey_id,
                   questionform_id,
                   samplepop_id,
                   sampleunit_id,
                   strlithocode,
                   sampleset_id,
                   datreturned,
                   datreportdate,
                   strunitselecttype,
                   bitcomplete,
                   daysfromfirstmailing,
                   daysfromcurrentmailing,
                   langid,
                   receipttype_id)
      SELECT study_id,
             survey_id,
             questionform_id,
             samplepop_id,
             sampleunit_id,
             strlithocode,
             sampleset_id,
             datreturned,
             datreportdate,
             strunitselecttype,
             bitcomplete,
             daysfromfirstmailing,
             daysfromcurrentmailing,
             langid,
             receipttype_id
      FROM   qualisys.qp_prod.dbo.phase4_nonquestion_view

      PRINT 'Running Sampleunit Fix made by Don'

      --DRM 03/06/2013
      --Check for missing big_table data
      EXEC Sp_extract_bubbledata_errorcheck

      --Update bithasResults in clientStudySurvey so the Survey can be accessed via the applications
      UPDATE clientstudysurvey
      SET    bithasresults = 1
      WHERE  survey_id IN --(SELECT DISTINCT e.survey_id
                           FROM   extract_sr_nonquestion e,
                                  sampleunit su
                           WHERE  e.sampleunit_id = su.sampleunit_id)

      --Delete records we don't want to keep.  They will join to the Sampleremove table.
      DELETE q
      FROM   extract_sr_nonquestion q,
             sampleremove s
      WHERE  q.sampleset_id = s.sampleset_id
             AND q.sampleunit_id = s.sampleunit_id
             AND q.strunitselecttype = s.strunitselecttype

      SELECT DISTINCT study_id,
                      qstncore
     O   #study
      FROM   questionresult_work

      insert into drm_tracktimes
      SELECT Getdate--(), 'Get distinct valid qstncores and vals'

      --get the distinct QstnCore/Val that are Valid for each Study
      SELECT DISTINCT t.study_id,
                      t.qstncore,
                      val,
                      nummarkcount
     O   #valid
      FROM   #study t,
             clientstudysurvey css,
             questions q,
             scales s
      WHERE  t.study_id = css.study_id
             AND css.survey_id = q.survey_id
             AND t.qstncore = q.qstncore
             AND q.survey_id = s.survey_id
             AND q.scaleid = s.scaleid
             AND q.language = 1
             AND q.language = s.language

      CREATE INDEX tmpvalid
        ON #valid --(study_id, qstncore, val)

      insert into drm_tracktimes
      SELECT Getdate--(), 'Log the inValid responses'

      --Log the inValid responses
      insert into invalid_entries
                  --(questionform_id,
                   strlithocode,
                   samplepop_id,
                   val,
                   sampleunit_id,
                   qstncore,
                   datmailed,
                   datimported,
                   study_id)
      SELECT q.questionform_id,
             q.strlithocode,
             q.samplepop_id,
             q.val,
             q.sampleunit_id,
             q.qstncore,
             q.datmailed,
             q.datimported,
             q.study_id
      FROM   questionresult_work q
             LEFT OUTER JOIN #valid t
                          ON q.study_id = t.study_id
                             AND q.qstncore = t.qstncore
                             AND --( q.val = t.val
                                    OR q.val - 10000 = t.val ) -- We add 10000 to any responses that should have been skipped.
      WHERE  t.val IS NULL
             AND q.val NOT IN --( -9,-8,-7,-6,-5 )
             --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
             AND q.val IS NOT NULL

      --Set inValid responses to -8
      UPDATE q
      SET    q.val = -8
      FROM   questionresult_work q
             LEFT OUTER JOIN #valid t
                          ON q.study_id = t.study_id
                             AND q.qstncore = t.qstncore
                             AND --( q.val = t.val
                                    OR q.val - 10000 = t.val )
      WHERE  t.val IS NULL
             AND q.val NOT IN --( -9,-8,-7,-6,-5 )
             --Modified 02/27/2014 CB - now including -5/-6 Refused/Don't Know
             AND q.val IS NOT NULL

      insert into drm_tracktimes
      SELECT Getdate--(), 'Delete duplicate returns'

      --Delete duplicate returns that are in the same extract
      SELECT samplepop_id,
             Min--(strlithocode) Litho
     O   #keep
      FROM   extract_sr_nonquestion
      GROUP  BY samplepop_id,
                sampleunit_id

      -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work
      CREATE INDEX tmpkeep
        ON #keep --(litho, samplepop_id)

      DELETE n
      FROM   extract_sr_nonquestion n
             LEFT OUTER JOIN #keep t
                          ON n.samplepop_id = t.samplepop_id
                             AND n.strlithocode = t.litho
      WHERE  t.litho IS NULL

      DELETE q
      FROM   questionresult_work q
             LEFT OUTER JOIN #keep t
                          ON q.samplepop_id = t.samplepop_id
                             AND q.strlithocode = t.litho
      WHERE  t.litho IS NULL

      DROP TABLE #keep

      insert into drm_tracktimes
      SELECT Getdate--(), 'Populate datReportDate'

      PRINT 'populating datReportDate'

      --Need to Populate datReportDate with the return date for Surveys that report on return date
      --First get the SampleUnits for the given Surveys
      SELECT sampleunit_id
     O   #rd
      FROM   sampleunit su,
             clientstudysurvey css
      WHERE  css.strreportdatefield = 'ReturnDate'
             AND css.survey_id = su.survey_id

      -- Modified 1/8/2012 DRH - tuning stmts involving extract_sr_nonquestion and questionresult_work
      CREATE INDEX tmprd
        ON #rd --(sampleunit_id)

      --now to set datReportdate=datReturned
      UPDATE n
      SET    n.datreportdate = datReturned
      FROM   #rd t,
             extract_sr_nonquestion n
      WHERE  t.sampleunit_id = n.sampleunit_id

      --Now to move the big_table entries
      SELECT study_id,
             samplepop_id,
             datreportdate
     O   #move
      FROM   extract_sr_nonquestion nq
      WHERE  datreportdate IS NOT NULL
             AND EXISTS --(SELECT DISTINCT CONVERT--(INT, Substring--(table_schema, 2, 10)) AS Study_id
                         FROM   information_schema.tables t
                         WHERE  LEFT--(table_schema, 1) = 's'
                                AND table_name = 'Big_Table_Null'
                                AND nq.study_id = CONVERT--(INT, Substring--(table_schema, 2, 10)))

      -- Identify and include ONLY studies that have a Big_Table_NULL to move data from...... Mod 6/24/04 SS
      insert into drm_tracktimes
      SELECT Getdate--(), 'Start looping through studies'

      PRINT 'Starting loop Thru Studies'

      --loop thru the studies
      WHILE --(SELECT Count--(*)
             FROM   #move) > 0
        BEGIN
            SELECT TOP 1 @Study = study_id
            FROM   #move

            insert into drm_tracktimes
            SELECT Getdate--(), 'Big_table_null'

            --We will move the records backo a work table and then run the movefromwork
            SET @strsql='UPDATE b '+CHAR--(10)+
					  ' SET b.datReportDate=t.datReportDate '+CHAR--(10)+
					  ' FROM S'+CONVERT--(VARCHAR,@Study)+'.Big_Table_NULL b, #move t '+CHAR--(10)+
					  ' WHERE t.SamplePop_id=b.SamplePop_id'

            PRINT @strsql

            EXEC --(@strsql)

            CREATE TABLE #retcolumns
              --(
                 col VARCHAR--(42)
              )

            insert into #retcolumns
            SELECT sc.name
            FROM   dbo.sql2kobjects so,
                   dbo.sql2kusers su,
                   dbo.sql2kcolumns sc
            WHERE  su.name = 's' + CONVERT--(VARCHAR, @Study)
                   AND su.uid = so.uid
                   AND so.name = 'Big_Table_NULL'
                   AND so.id = sc.id
                   AND iscomputed = 0

            DECLARE @selcol  VARCHAR--(7500),
                    @colname VARCHAR--(42)

            SET @selcol=''

            SELECT TOP 1 @colname = col
            FROM   #retcolumns

            WHILE @@ROWCOUNT > 0
              BEGIN
                  SET @selcol=@selcol + ',' + @colname

                  DELETE #retcolumns
                  WHERE  col = @colname

                  SELECT TOP 1 @colname = col
                  FROM   #retcolumns
              END

            SET @strsql='SET QUOTED_IDENTIFIER ON SELECT dbo.YearQtr--(datReportDate) QtrTable'+@selcol+CHAR--(10)+
					  'O S'+CONVERT--(VARCHAR,@Study)+'.Big_Table_Work '+CHAR--(10)+
					  ' FROM S'+CONVERT--(VARCHAR,@Study)+'.Big_Table_NULL '+CHAR--(10)+
					  ' WHERE datReportDate IS NOT NULL '+CHAR--(10)+
					  ' DELETE S'+CONVERT--(VARCHAR,@Study)+'.Big_Table_NULL '+CHAR--(10)+
					  ' WHERE datReportDate IS NOT NULL'

            PRINT @strsql

            EXEC --(@strsql)

            DROP TABLE #retcolumns

            --Delete the records for the Study
            DELETE #move
            WHERE  study_id = @Study
        --end the loop
        END

      insert into drm_tracktimes
      SELECT Getdate--(), 'MoveFromWork big_table'

      --use the movefromwork procedure to put the records in the appropriate table
      EXEC Sp_dbm_movefromwork 'Big_Table'

      --clean up
      DROP TABLE #move
      DROP TABLE #rd

      insert into drm_tracktimes
      SELECT Getdate--(), 'Begin loop to build vert table'

      --Loop through the studies to first build the vertical table and then use it to Populate the horizontal table
      WHILE --(SELECT Count--(*)
             FROM   #study) > 0
        BEGIN --loop3
            PRINT 'Study_ID ' + Cast--(@Study AS VARCHAR--(100))

            PRINT 'System User ID ' + Cast --(@user AS VARCHAR--(100))

            SET @Study=--(SELECT TOP 1 study_id
                        FROM   #study
                        ORDER  BY study_id)
            SET @user=--(SELECT uid
                       FROM   dbo.sql2kusers
                       WHERE  name = 's' + CONVERT--(VARCHAR, @Study))

            --if the Results already exist, we will just delete the new records
            --First get rid of the QuestionForms
            PRINT 'First get rid of the QuestionForms'

            IF EXISTS --(SELECT *
                       FROM   dbo.sql2kobjects
                       WHERE  type = 'v'
                              AND name = 'Study_Results_view'
                              AND uid = --(SELECT uid
                                         FROM   dbo.sql2kusers
                                         WHERE  name = 'S' + CONVERT--(VARCHAR, @Study))
                      )
              BEGIN
                  SET @strsql='BEGIN
							   DELETE e
							   FROM Extract_SR_NonQuestion e, S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_View s
							   WHERE e.Study_id='+RTRIM--(CONVERT--(VARCHAR,@Study))+' AND e.SamplePop_id=s.SamplePop_id
							   DELETE e
							   FROM QuestionResult_Work e, S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_View s
							   WHERE e.Study_id='+RTRIM--(CONVERT--(VARCHAR,@Study))+' AND e.SamplePop_id=s.SamplePop_id
							   END'

                  PRINT @strsql

                  EXEC --(@strsql)
              END

            PRINT 'Deleted duplicates ' + CONVERT--(VARCHAR, Getdate--())

            --get the reportdate from big_table_view
            PRINT 'Get the reportdate from big_table_view'

            SET @strsql='UPDATE n '+CHAR--(10)+
					  ' SET n.datReportDate=b.datReportDate '+CHAR--(10)+
					  ' FROM S'+CONVERT--(VARCHAR,@Study)+'.Big_Table_View b, Extract_SR_NonQuestion n '+CHAR--(10)+
					  ' WHERE n.Study_id='+CONVERT--(VARCHAR,@Study)+CHAR--(10)+
					  ' AND n.SamplePop_id=b.SamplePop_id '+CHAR--(10)+
					  ' AND n.SampleUnit_id=b.SampleUnit_id'
            PRINT @strsql
            EXEC --(@strsql)

            -- Populate the bitComplete and daysfrommailing columns in big_table
            -- Get the values we need to deal with
            TRUNCATE TABLE #updatebigtable

            --  TRUNCATE TABLE #TableCheck
            --mb here
            insert into drm_tracktimes
            SELECT Getdate--(), 'insert into #updatebigtable'

            insert into #updatebigtable
                        --(samplepop_id,
                         tableschema,
                         tablename,
                         bitcomplete,
                         daysfromfirstmailing,
                         daysfromcurrentmailing,
                         langid)
            SELECT samplepop_id,
                   'S' + Ltrim--(Str--(study_id))                TableSchema,
                   'Big_Table_' + dbo.Yearqtr--(datreportdate) TableName,
                   bitcomplete,
                   daysfromfirstmailing,
                   daysfromcurrentmailing,
                   langid
            FROM   extract_sr_nonquestion
            WHERE  study_id = @Study

            PRINT 'Before BitComplete Update to Big_table'

            -- Now to populate the fields
            SELECT @strsql = ''

            SELECT @strsql = @strsql + 'UPDATE b SET bitComplete=t.bitComplete, DaysFromFirstMailing=t.DaysFromFirstMailing,'+CHAR--(10)+
									 'DaysFromCurrentMailing=t.DaysFromCurrentMailing, LangID=t.LangID'+CHAR--(10)+
									 'FROM '+TableSchema+'.'+TableName+' b, #UpdateBigTable t'+CHAR--(10)+
									 'WHERE t.SamplePop_id=b.SamplePop_id' + Char--(10)
            FROM   --(SELECT DISTINCT tableschema, tablename
                    FROM   #updatebigtable) a

            PRINT 'After BitComplete Update to Big_table before execution'
            PRINT @strsql
            EXEC --(@strsql)

            insert into drm_tracktimes
            SELECT Getdate--(), 'Update respratecount'

            PRINT 'Updating RespRateCount'

            -- Now to update/populate the RR_ReturnCountByDays table
            SELECT CONVERT--(INT, NULL) Survey_id,
                   sampleset_id,
                   sampleunit_id,
                   daysfromfirstmailing,
                   daysfromcurrentmailing,
                   Count--(*)          Returned
           O   #returns
            FROM   extract_sr_nonquestion
            WHERE  study_id = @Study
            GROUP  BY sampleset_id,
                      sampleunit_id,
                      daysfromfirstmailing,
                      daysfromcurrentmailing

            --MWB 7-21-11
            --#return sql statements  having alot of issues with performance.
            --Creating these indexes to see if it helps.
            CREATE INDEX tmpreturns1 ON #returns --(sampleset_id)

            CREATE INDEX tmpreturns2 ON #returns --(sampleset_id, sampleunit_id, daysfromfirstmailing, daysfromcurrentmailing)

            UPDATE r
            SET    survey_id = rr.survey_id
            FROM   respratecount rr,
                   #returns r
            WHERE  r.sampleset_id = rr.sampleset_id

            UPDATE rr
            SET    rr.intreturned = rr.intreturned + t.intreturned
            FROM   rr_returncountbydays rr,
                   #returns t
            WHERE  t.sampleset_id = rr.sampleset_id
                   AND t.sampleunit_id = rr.sampleunit_id
                   AND t.daysfromfirstmailing = rr.daysfromfirstmailing
                   AND t.daysfromcurrentmailing = rr.daysfromcurrentmailing

            DELETE t
            FROM   rr_returncountbydays rr,
                   #returns t
            WHERE  t.sampleset_id = rr.sampleset_id
                   AND t.sampleunit_id = rr.sampleunit_id
                   AND t.daysfromfirstmailing = rr.daysfromfirstmailing
                   AND t.daysfromcurrentmailing = rr.daysfromcurrentmailing

            insert into rr_returncountbydays
                        --(survey_id,
                         sampleset_id,
                         sampleunit_id,
                         daysfromfirstmailing,
                         daysfromcurrentmailing,
                        returned)
            SELECT survey_id,
                   sampleset_id,
                   sampleunit_id,
                   daysfromfirstmailing,
                   daysfromcurrentmailing,
                  returned
            FROM   #returns

            DROP TABLE #returns

            insert into drm_tracktimes
            SELECT Getdate--(), 'On to Study_resuls_vertical_work'

            PRINT 'UID is ' + @user

            PRINT 'Onto Study_Results_Vertical_work ' + CONVERT--(VARCHAR, Getdate--())

            SET nocount ON

            TRUNCATE TABLE #coreflds

            --identify all of the needed fields to add to the work table
            --This is also a list of Valid cores needed for the Population of the Vertical table.
            insert into #coreflds
            SELECT DISTINCT 'Q' + RIGHT--('00000'+CONVERT--(VARCHAR, qstncore), 6),
                            qstncore,
                            0,
                            1,
                            0
            FROM   #valid
            WHERE  study_id = @Study
                   AND nummarkcount = 1
            UNION
            SELECT DISTINCT 'Q' + RIGHT--('00000'+CONVERT--(VARCHAR, qstncore), 6) + CASE WHEN val BETWEEN 1 AND 26 THEN Char--(96+val) ELSE '' END,
                            qstncore,
                            val,
                            0,
                            0
            FROM   #valid
            WHERE  study_id = @Study
                   AND nummarkcount > 1

            SET nocount OFF

            IF NOT EXISTS --(SELECT *
                           FROM   dbo.sql2kobjects
                           WHERE  name = 'Study_Results_Vertical_Work'
                                  AND uid = @user)
              BEGIN
                  --loop4
                  SET @strsql='CREATE TABLE S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work --('+
							   ' QtrTable VARCHAR--(10), SamplePop_id, SampleUnit_id, strLithoCode VARCHAR--(10), SampleSet_id, datReturned DATETIME, '+
							   ' QstnCore,ResponseVal, datReportDate DATETIME, bitComplete BIT)'
                  PRINT @strsql
                  EXEC --(@strsql)
              END --loop4

            SET @strsql='insert into s'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work  '+
					  ' --(QtrTable, SamplePop_id,SampleUnit_id,strLithoCode,SampleSet_id,datreturned,QstnCore,intresponseVal,datreportdate,bitComplete ) '+
					  ' SELECT dbo.YearQtr--(datReportDate), w.SamplePop_id, n.SampleUnit_id, n.strLithoCode, n.Sampleset_id, n.datReturned, QstnCore, Val, datReportDate,bitComplete '+
					  ' FROM QuestionResult_work w, extract_sr_nonQuestion n'+
					  ' where w.Study_id='+CONVERT--(VARCHAR,@Study)+
					  ' and w.Study_id=n.Study_id '+
					  ' and w.SamplePop_id=n.SamplePop_id '+
					  ' and w.strLithoCode=n.strLithoCode' +
					  ' OPTION--(FORCE ORDER)'

            PRINT @strsql
            EXEC --(@strsql)

            SET @strsql='CREATE INDEX DedupValues ON S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work --(SamplePop_id, SampleUnit_id, QstnCore,responseVal)'

            --Need to make sure we only have one response for each SamplePop/SampleUnit/QstnCore combination for single response Questions
            CREATE TABLE #dedup
              --(
                 samplepop_id ,
                 sampleunit_id,
                 qstncore     ,
                 datreportdate DATETIME,
                 sampleset_id ,
                 datreturned   DATETIME,
                 bitcomplete   BIT
              )

            --Find the duplicates
            SET @strsql='insert into #Dedup select SamplePop_id, SampleUnit_id, w.QstnCore, w.datReportDate, SampleSet_id, datReturned, bitComplete '+CHAR--(10)+
					  ' FROM s'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work w, #CoreFlds t '+CHAR--(10)+
					  ' WHERE w.QstnCore=t.QstnCore '+CHAR--(10)+
					  ' AND t.bitSingle=1 '+CHAR--(10)+
					  ' GROUP BY SamplePop_id, SampleUnit_id, w.QstnCore, w.datReportDate, SampleSet_id, datReturned, bitComplete HAVING COUNT--(*)>1'
            PRINT @strsql
            EXEC --(@strsql)

            IF --(SELECT Count--(*) FROM #dedup) > 0
              BEGIN
                  --Delete all duplicate responses.  We will insert new records based on the Values in #Dedup
                  SET @strsql='DELETE w '+CHAR--(10)+
							  ' FROM #Dedup t, s'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work w '+CHAR--(10)+
							  ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR--(10)+
							  ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR--(10)+
							  ' AND t.QstnCore=w.QstnCore'
                  PRINT @strsql
                  EXEC --(@strsql)

                  --Insert where the SampleUnits match
                  SET @strsql='insert into s'+convert--(varchar,@Study)+'.Study_Results_Vertical_Work '+CHAR--(10)+
							  ' SELECT dbo.YearQtr--(datReportDate), t.SamplePop_id, t.SampleUnit_id, q.strLithoCode, t.Sampleset_id, '+CHAR--(10)+
							  ' t.datReturned, t.QstnCore, Val, t.datReportDate, bitComplete '+CHAR--(10)+
							  ' FROM QuestionResult_Work q, #Dedup t '+CHAR--(10)+
							  ' WHERE q.Study_id='+RTRIM--(CONVERT--(VARCHAR,@Study))+' AND t.SamplePop_id=q.SamplePop_id '+CHAR--(10)+
							  ' AND t.SampleUnit_id=q.SampleUnit_id '+CHAR--(10)+
							  ' AND t.QstnCore=q.QstnCore'
                  PRINT @strsql
                  EXEC --(@strsql)

                  SET @strsql='DELETE t '+CHAR--(10)+
							  ' FROM #dedup t, s'+convert--(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR--(10)+
							  ' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR--(10)+
							  ' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR--(10)+
							  ' AND t.QstnCore=w.QstnCore'
                  PRINT @strsql
                  EXEC --(@strsql)

                  --Just to make sure we enter the loop
                  SELECT TOP 1 @strsql = CONVERT--(VARCHAR, samplepop_id)
                  FROM   #dedup

                  WHILE @@rowcount > 0
                    BEGIN
                        --update with another Valid Value.  This is the same update statement as when we Populate the horizontal table.
                        SET @strsql='insert into s'+convert--(varchar,@Study)+'.Study_Results_Vertical_Work '+CHAR--(10)+
									' SELECT TOP 1 dbo.YearQtr--(datReportDate), t.SamplePop_id, t.SampleUnit_id, q.strLithoCode, t.Sampleset_id, '+CHAR--(10)+
									' t.datReturned, t.QstnCore, Val, t.datReportDate, bitComplete '+CHAR--(10)+
									' FROM QuestionResult_Work q, #Dedup t '+CHAR--(10)+
									' WHERE q.Study_id='+RTRIM--(CONVERT--(VARCHAR,@Study))+' AND t.SamplePop_id=q.SamplePop_id '+CHAR--(10)+
									' AND t.QstnCore=q.QstnCore '+CHAR--(10)+
									' AND q.Val>-1'
                        PRINT @strsql
                        EXEC --(@strsql)

                        SET @strsql='DELETE t '+CHAR--(10)+
									' FROM #dedup t, s'+convert--(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR--(10)+
									' WHERE t.SamplePop_id=w.SamplePop_id '+CHAR--(10)+
									' AND t.SampleUnit_id=w.SampleUnit_id '+CHAR--(10)+
									' AND t.QstnCore=w.QstnCore'
                        PRINT @strsql
                        EXEC --(@strsql)
                    END

                  --Just to make sure we enter the loop
                  SELECT TOP 1 @strsql = CONVERT--(VARCHAR, samplepop_id)
                  FROM   #dedup

                  WHILE @@rowcount > 0
                    BEGIN
                        --update with another Value.  This is the same update statement as when we Populate the horizontal table.
                        SET @strsql='insert into s'+convert--(varchar,@Study)+'.Study_Results_Vertical_Work '+CHAR--(10)+
									'SELECT TOP 1 dbo.YearQtr--(datReportDate), t.SamplePop_id, t.SampleUnit_id, q.strLithoCode, t.Sampleset_id, '+CHAR--(10)+
									't.datReturned, t.QstnCore, Val, t.datReportDate, bitComplete '+CHAR--(10)+
									'FROM QuestionResult_Work q, #Dedup t '+CHAR--(10)+
									'WHERE q.Study_id='+RTRIM--(CONVERT--(VARCHAR,@Study))+' AND t.SamplePop_id=q.SamplePop_id '+CHAR--(10)+
									'AND t.QstnCore=q.QstnCore'
                        PRINT @strsql
                        EXEC --(@strsql)

                        SET @strsql='DELETE t '+CHAR--(10)+
									'FROM #dedup t, s'+convert--(varchar,@Study)+'.Study_Results_Vertical_Work w '+CHAR--(10)+
									'WHERE t.SamplePop_id=w.SamplePop_id '+CHAR--(10)+
									'AND t.SampleUnit_id=w.SampleUnit_id '+CHAR--(10)+
									'AND t.QstnCore=w.QstnCore'
                        PRINT @strsql
                        EXEC --(@strsql)
                    END
              END

            --Get rid of the temp table before the next loop
            DROP TABLE #dedup

            --mwb 1
            IF NOT EXISTS --(SELECT so.name
                           FROM   dbo.sql2kobjects so,
                                  dbo.sql2kindexes si,
                                  dbo.sql2kusers su
                           WHERE  so.id = si.id
                                  AND so.uid = su.uid
                                  AND so.name = 'Study_Results_Vertical_Work'
                                  AND si.name = 'AggValues'
                                  AND su.name = 'S' + CONVERT--(VARCHAR, @Study))
              BEGIN
                  SET @strsql='CREATE INDEX AggValues ON S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work --(datReportDate, SampleUnit_id, QstnCore,responseVal)'
                  EXEC --(@strsql)
              END

            IF NOT EXISTS --(SELECT so.name
                           FROM   dbo.sql2kobjects so,
                                  dbo.sql2kindexes si,
                                  dbo.sql2kusers su
                           WHERE  so.id = si.id
                                  AND so.uid = su.uid
                                  AND so.name = 'Study_Results_Vertical_Work'
                                  AND si.name = 'QstnCoreSamplePop'
                                  AND su.name = 'S' + CONVERT--(VARCHAR, @Study))
              BEGIN
                  SET @strsql='CREATE INDEX QstnCoreSamplePop ON S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work --(QstnCore, SamplePop_id)'
                  EXEC --(@strsql)
              END

            insert into drm_tracktimes
            SELECT Getdate--(), 'Study_results_work'

            IF NOT EXISTS --(SELECT *
                           FROM   dbo.sql2kobjects
                           WHERE  name = 'Study_Results_Work'
                                  AND uid = @user)
              BEGIN
                  -- SRW loop
                  PRINT 'Create ' + CONVERT--(VARCHAR, @Study) + ' table ' + CONVERT--(VARCHAR, Getdate--())
                  SET @strsql='CREATE TABLE S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Work '+
							  ' --(QtrTable VARCHAR--(10), SamplePop_id NOT NULL, SampleUnit_id NOT NULL, strLithoCode VARCHAR--(10), '+
							  ' SampleSet_id, datReturned SMALLDATETIME, datReportDate SMALLDATETIME, bitComplete BIT)'
                  PRINT @strsql
                  EXEC --(@strsql)

                  PRINT 'Add the PK ' + CONVERT--(VARCHAR, Getdate--())

                  SET @strsql='ALTER TABLE S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Work '+
							  'WITH NOCHECK ADD CONSTRAINT [PK_Study_Results_Work] '+
							  'PRIMARY KEY  CLUSTERED --(SamplePop_id, SampleUnit_id)  ON [PRIMARY]'
                  EXEC --(@strsql)

                  SET @strsql='insert into S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Work --( '+
							  'QtrTable, SamplePop_id, SampleUnit_id, strLithoCode, SampleSet_id, datReturned, '+
							  'datReportDate, bitComplete) '+
							  'SELECT DISTINCT dbo.YearQtr--(datReportDate), SamplePop_id, SampleUnit_id, strLithoCode, SampleSet_id, '+
							  'datReturned, datReportDate, bitComplete '+
							  'FROM s'+convert--(varchar,@Study)+'.Study_Results_Vertical_Work'
                  PRINT @strsql
                  EXEC --(@strsql)

                  PRINT 'Insertedo Study_Results_work ' + CONVERT--(VARCHAR, Getdate--())

                  SET @strsql='ALTER TABLE S' + CONVERT--(VARCHAR, @Study) + '.Study_Results_work ADD '

                  --loop to add the needed fields
                  WHILE --(SELECT Count--(*)
                         FROM   #coreflds
                         WHERE  bitused = 0) > 0
                    BEGIN
                        -- Alter loop
                        SET @strCore=--(SELECT TOP 1 strfield_nm
                                      FROM   #coreflds
                                      WHERE  bitused = 0)

                        IF RIGHT--(@strsql, 4) = 'ADD '
                          SET @strsql=@strsql + @strCore + ' '
                        ELSE
                          SET @strsql=@strsql + ', ' + @strCore + ' '

                        --execute the alter statement if it is longer than 6000 characters
                        IF Len--(@strsql) > 6000
                          BEGIN
                              BEGIN try
                                  EXEC --(@strsql)
                              END try

                              BEGIN catch
                                  PRINT @strsql

                                  insert into drm_tmp_coreflds
                                              --(section,
                                               study,
                                               strfield_nm,
                                               qstncore,
                                               val,
                                               bitsingle,
                                               bitused)
                                  SELECT 1,
                                         @study,
                                         strfield_nm,
                                         qstncore,
                                         val,
                                         bitsingle,
                                         bitused
                                  FROM   #coreflds
                              END catch

                              PRINT 'Alter table ' + CONVERT--(VARCHAR, Getdate--())

                              --reinitialize the variable
                              IF --(SELECT Count--(*)
                                  FROM   #coreflds
                                  WHERE  bitused = 0) > 1
                                SET @strsql='ALTER TABLE S' + CONVERT--(VARCHAR, @Study) + '.Study_Results_work ADD '
                              ELSE
                                SET @strsql=''
                          END

                        UPDATE #coreflds
                        SET    bitused = 1
                        WHERE  strfield_nm = @strCore
                    END -- Alter loop
                  BEGIN try
                      EXEC --(@strsql)
                  END try

                  BEGIN catch
                      PRINT @strsql

                      insert into drm_tmp_coreflds
                                  --(section,
                                   study,
                                   strfield_nm,
                                   qstncore,
                                   val,
                                   bitsingle,
                                   bitused)
                      SELECT 2,
                             @study,
                             strfield_nm,
                             qstncore,
                             val,
                             bitsingle,
                             bitused
                      FROM   #coreflds
                  END catch
              END
            -- SRW loop
            DECLARE curqstn CURSOR FOR
              SELECT strfield_nm,
                     qstncore
              FROM   #coreflds
              WHERE  bitsingle = 1

            PRINT 'Updating the cores ' + CONVERT--(VARCHAR, Getdate--())

            OPEN curqstn

            FETCH next FROM curqstnO @strCore, @Core

            WHILE @@FETCH_STATUS = 0
              BEGIN
                  SET @Nstrsql='UPDATE s SET s.'+@strCore+'=intresponseVal
							  FROM S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_work s, S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work t
							  WHERE t.QstnCore='+CONVERT--(VARCHAR,@core)+'
							  AND s.SamplePop_id=t.SamplePop_id
							  AND s.SampleUnit_id=t.SampleUnit_id'

                  EXEC Sp_executesql @Nstrsql

                  FETCH next FROM curqstnO @strCore, @Core
              END

            CLOSE curqstn

            DEALLOCATE curqstn

            insert into drm_tracktimes
            SELECT Getdate--(), 'Updating MR cores'

            PRINT 'Updating the MR cores ' + CONVERT--(VARCHAR, Getdate--())

            --Multiple Response
            DECLARE curqstn CURSOR FOR
              SELECT strfield_nm,
                     qstncore,
                     val
              FROM   #coreflds
              WHERE  bitsingle = 0

            OPEN curqstn

            FETCH next FROM curqstnO @strCore, @Core, @Cnt

            WHILE @@FETCH_STATUS = 0
              BEGIN
                  SELECT @Nstrsql = 'UPDATE s
									  SET '+@strCore+'=intresponseVal
									  FROM S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_work s, S'+CONVERT--(VARCHAR,@Study)+'.Study_Results_Vertical_Work t
									  WHERE s.SamplePop_id=t.SamplePop_id
									  AND s.SampleUnit_id=t.SampleUnit_id
									  AND t.QstnCore='+CONVERT--(VARCHAR,@Core)+'
									  AND t.intresponseVal % 10000 =' + CONVERT--(VARCHAR, @Cnt)

                  EXEC Sp_executesql @Nstrsql

                  FETCH next FROM curqstnO @strCore, @Core, @Cnt
              END

            CLOSE curqstn
            DEALLOCATE curqstn

            ---------------------------------------------------------------------------------------------------------------------------------------------------------
            -- Response Rate PART 2 of 3 --(New Returns Update)
            insert into drm_tracktimes
            SELECT Getdate--(), 'sp_extract_resprate'

            EXEC Sp_extract_resprate @Study, @procpart=2

            ---------------------------------------------------------------------------------------------------------------------------------------------------------
            insert into drm_tracktimes
            SELECT Getdate--(), 'Update qualisys'

            PRINT 'Updating Qualysis: Study=' + CONVERT--(VARCHAR, @Study) + ' Processed. [' + CONVERT--(VARCHAR, Getdate--()) + ']'

            EXEC qualisys.qp_prod.dbo.Sp_cmnt_update_qfextract @study

            DELETE questionresult_work
            WHERE  study_id = @Study

            DELETE #study
            WHERE  study_id = @Study

            PRINT 'Get New Study to Process. [End of Loop3]'
        END --loop3

      insert into drm_tracktimes
      SELECT Getdate--(), 'SP_DBM_Comments_Extract_to_History'

      EXEC qualisys.qp_prod.dbo.Sp_dbm_comments_extract_to_history

      DROP TABLE #study
      DROP TABLE #valid
      DROP TABLE #coreflds
  END
