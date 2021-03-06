/*

S45 US 17 Medusa ETL - CGCAHPS default disposition 
As a developer I want to modify the SP_Extract_Big_Table sproc so the CGCahps default disposition is 9

Tim Butler

*/

USE [QP_Comments]
GO
/****** Object:  StoredProcedure [dbo].[SP_Extract_Big_Table]    Script Date: 3/21/2016 10:47:54 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_Extract_Big_Table]
AS
  /******************************************************************************************************************                          
  -- Modified 10/17/06 - SJS - Added datSampleEncounterDate field to Big_Table_Work from qp_prod.dbo.Big_View_Web                          
  -- Modified 12/19/07 - MWB - Added debug code so that you can tell which sampleset died and what sql it was                       
  --        attampting to run                      
  -- Modified 10/19/09 - MWB - Added HHDisposition to Big_table_work creation.                    
  -- Modified 02/01/10 - MWB - Modified logic that looked at @View_ID because schemas do not create users anymore.                  
  -- Modified 04/07/10 - MWB - Added logic for MNCM dispositions.            
  -- Modified 09/20/11 - DRM - Added filter for seeded mailing rows.            
  -- Modified 12/02/11 - DRM - Added HNumAttempts.    
  -- Modified 09/24/13 - DBG - Added numCAHPSSupplemental
  -- Modified 10/16/13 - CBC - Line 63: exclude study with issue.
  -- Modified 01/16/14 - DBG - Added logic for ACO dispositions.
  -- Modified 03/21/2016 - TSB - changed CGCAHPS default disposition from 38 to 9            
  ******************************************************************************************************************/
  DECLARE @strsql    VARCHAR(8000),
          @study     INT,
          @field     VARCHAR(30),
          @datatype  VARCHAR(20),
          @length    INT,
          @strsql1   VARCHAR(8000),
          @strsql2   VARCHAR(8000),
          @strsel    VARCHAR(8000),
          @table     VARCHAR(200),
          @user      VARCHAR(10),
          @cnt       INT,
          @SampleSet INT,
          @View_id   INT,
          @WebUser   VARCHAR(10),
          @debugSQL  VARCHAR(8000)
  
  EXEC Qualisys.QP_Prod.dbo.SP_Phase4_Update_ExtractTables

  EXEC Qualisys.QP_Prod.dbo.SP_Phase4_Web_Extract_Flg

  IF EXISTS (SELECT *
             FROM   tempdb.dbo.sysobjects o
             WHERE  o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#SampleSets'))
    DROP TABLE #SampleSets

  CREATE TABLE #SampleSets (Study_id     INT,
                            SampleSet_id INT)

  INSERT INTO #SampleSets                                 
  SELECT Study_id, SampleSet_id                                
  FROM Qualisys.QP_Prod.dbo.WEB_SampleSets
                    
  IF EXISTS (SELECT *
             FROM   tempdb.dbo.sysobjects o
             WHERE  o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#s'))
    DROP TABLE #s

  SELECT DISTINCT study_id
  INTO   #s
  FROM   #SampleSets
 

  SET NOCOUNT ON

  IF EXISTS (SELECT *
             FROM   tempdb.dbo.sysobjects o
             WHERE  o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#columns'))
    DROP TABLE #columns

  CREATE TABLE #columns (field VARCHAR(128))

  IF EXISTS (SELECT *
             FROM   tempdb.dbo.sysobjects o
             WHERE  o.xtype IN ('U')
                    AND o.id = OBJECT_ID(N'tempdb..#alter'))
    DROP TABLE #alter

  CREATE TABLE #alter (strfield_nm      VARCHAR(20),
                       strfielddatatype VARCHAR(20),
                       intfieldlength   INT)

  WHILE (SELECT count(*)
         FROM   #s) > 0
    BEGIN --loop1                                
      TRUNCATE TABLE #alter

      TRUNCATE TABLE #columns

      SET @study=(SELECT TOP 1 study_id
                  FROM   #s)

      --commented out b/c code is not used after 2008 upgrade.                                              
      --SET @WebUser=(SELECT uid FROM sysusers WHERE name='s'+CONVERT(VARCHAR,@study))                                
      --CREATE TABLE #uid (uid INT)      
      --SELECT @strsql='INSERT INTO #uid                                
      --SELECT uid FROM Qualisys.QP_Prod.dbo.SysUsers                                 
      --WHERE name=''S'+LTRIM(STR(@Study))+''''                                
      --EXEC (@strsql)                   
      --SELECT @user=uid FROM #uid                                
      --DROP TABLE #uid                                
      WHILE (SELECT count(*)
             FROM   #SampleSets
             WHERE  study_id = @study) > 0
        BEGIN --SampleSet loop                                
          SET @SampleSet=(SELECT TOP 1 SampleSet_id
                          FROM   #SampleSets
                          WHERE  study_id = @study)

          PRINT 'current Sample Set is '
                + cast(@Sampleset AS VARCHAR(20))

          SELECT 'current Sample Set is '
                 + cast(@Sampleset AS VARCHAR(20))

          --Get the SampleSet/SampleUnit combinations that need to be Removed for this SampleSet.  Rarely will add to the table.                                
          --We will set the strUnitSelectType in Big_Table to 'X' for any records that have a match in this table.  We will not keep                                 
          -- results for these records.                                
          --Find the distinct values for the SampleSet currently being pulled over                                
          IF EXISTS (SELECT *
                     FROM   tempdb.dbo.sysobjects o
                     WHERE  o.xtype IN ('U')
                            AND o.id = OBJECT_ID(N'tempdb..#Remove'))
            DROP TABLE #Remove

          CREATE TABLE #Remove (SampleSet_id       INT,
                                SampleUnit_id      INT,
                                strUnitSelectType  VARCHAR(10),
                                datSampleCreate_dt DATETIME,
                                Target             INT)

          INSERT INTO #Remove                                 
          SELECT SampleSet_id, SampleUnit_id, strUnitSelectType, datSampleCreate_dt, Target                                
          FROM Qualisys.QP_Prod.dbo.WEB_UnitSelectType_View                                
          WHERE SampleSet_id=@SampleSet

          IF EXISTS (SELECT *
                     FROM   tempdb.dbo.sysobjects o
                     WHERE  o.xtype IN ('U')
                            AND o.id = OBJECT_ID(N'tempdb..#Single'))
            DROP TABLE #Single

          --Create a temp table to hold the SampleSet/SampleUnits that only have one entry.                                
          SELECT SampleSet_id,
                 SampleUnit_id
          INTO   #Single
          FROM   #Remove
          GROUP  BY SampleSet_id,
                    SampleUnit_id
          HAVING COUNT(*) = 1

          --We want to now remove Indirects at targeted units                                
          INSERT INTO SampleRemove
                      (SampleSet_id,
                       SampleUnit_id,
                       strUnitSelectType)
          SELECT DISTINCT
                 s.SampleSet_id,
                 s.SampleUnit_id,
                 'I'
          FROM   #Remove r,
                 #Single s
          WHERE  s.SampleSet_id = r.SampleSet_id
                 AND s.SampleUnit_id = r.SampleUnit_id
                 AND r.strUnitSelectType = 'I'
                 AND r.Target > 0

          --Remove the records from the previous query from further inspection                                
          DELETE r
          FROM   #Remove r,
                 #Single s
          WHERE  s.SampleSet_id = r.SampleSet_id
                 AND s.SampleUnit_id = r.SampleUnit_id
                 AND r.strUnitSelectType = 'I'
                 AND r.Target > 0

          --Insert a record for the single occurance SampleSet/SampleUnits                                
          INSERT INTO UnitSelectType
                      (SampleSet_id,
                       SampleUnit_id,
                       strUnitSelectType,
                       datSampleCreate_dt)
          SELECT t.SampleSet_id,
                 t.SampleUnit_id,
                 strUnitSelectType,
                 datSampleCreate_dt
          FROM   #Remove t,
                 #Single s
          WHERE  s.SampleSet_id = t.SampleSet_id
                 AND s.SampleUnit_id = t.SampleUnit_id

          --Delete the SampleSet/SampleUnits that only have one entry in the temp table                                
          DELETE r
          FROM   #Remove r,
                 #Single t
          WHERE  t.SampleSet_id = r.SampleSet_id
                 AND t.SampleUnit_id = r.SampleUnit_id

          --insert a record for the SampleSet/SampleUnits that have both                                
          INSERT INTO UnitSelectType
                      (SampleSet_id,
                       SampleUnit_id,
                       strUnitSelectType,
                       datSampleCreate_dt)
          SELECT DISTINCT
                 SampleSet_id,
                 SampleUnit_id,
                 'B',
                 datSampleCreate_dt
          FROM   #Remove

          --Insert into the sampleRemove table for the indirects                      
          INSERT INTO SampleRemove
          SELECT DISTINCT
                 SampleSet_id,
                 SampleUnit_id,
                 'I'
          FROM   #Remove

          --Cleanup                                
          PRINT 'Call SP_Phase4_Big_View_Web'

          -- To be used when we extract on a SampleSet basis.                                  
          EXEC Qualisys.QP_Prod.dbo.SP_Phase4_Big_View_Web @SampleSet

          PRINT 'Call ETL_Get_Qualisys_TableID'

          --if sql 2008 code needs to be                    
          DECLARE @sStudy VARCHAR(100)

          SET @sStudy = 's' + LTRIM(STR(@study)) + ''

          EXEC Qualisys.qp_prod.dbo.ETL_Get_Qualisys_TableID @sStudy, 'Big_View_Web', @View_id OUTPUT

          --if SQL 2000 CODE NEEDS TO BE                    
          /*                                
          CREATE TABLE #View (View_id INT)                                
          SELECT @strsql='INSERT INTO #View                                
          SELECT id FROM Qualisys.QP_Prod.dbo.SysObjects                                
          WHERE uid='+LTRIM(STR(@User))+'                                
          AND name=''Big_View_Web'''                                
          EXEC (@strsql)                                  
          SELECT @View_id=View_id FROM #View                                
                                      
          DROP TABLE #View                                
          */
          IF EXISTS (SELECT *
                     FROM   sysobjects so,
                            sysusers su
                     WHERE  so.uid = su.uid
                            AND so.name = 'Big_Table_Work'
                            AND su.name = @sStudy)
            BEGIN --loop2
              TRUNCATE TABLE #columns
              
              INSERT INTO #columns 
              SELECT name 
              FROM   syscolumns 
              WHERE  id = Object_id(N'[S'+ LTRIM(STR(@Study))+ '].[BIG_TABLE_Work]') 
                     AND Objectproperty(id, N'IsTable') = 1 

              INSERT INTO #alter 
              SELECT strfield_nm, strfielddatatype, intfieldlength 
              FROM   (SELECT sc.name   strfield_nm, 
                             st.name   strfielddatatype, 
                             sc.length intfieldlength 
                      FROM   Qualisys.qp_prod.dbo.syscolumns sc, 
                             Qualisys.qp_prod.dbo.systypes st 
                      WHERE  id = @View_id 
                             AND sc.xtype = st.xtype) m 
                     LEFT OUTER JOIN #columns c 
                                  ON m.strfield_nm = c.field 
              WHERE  c.field IS NULL 
            
              IF (SELECT count(*) FROM #alter) = 0
                BEGIN
                  PRINT 'SELECT count(*) FROM #alter)=0 TRUE'

                  GOTO populate
                END

              SET @strsql=' ALTER TABLE s' + LTRIM(STR(@Study)) + '.Big_Table_Work ADD '

              -- Add new fields to the big_table for the study.                                 
              WHILE (SELECT COUNT(*) FROM #alter) > 0
                BEGIN --loop3                                
                  SELECT TOP 1 @field=strfield_nm, @datatype=strfielddatatype, @length=intfieldlength
                  FROM   #alter

                  IF @datatype = 'VARCHAR'
                    SET @datatype='VARCHAR(' + CONVERT(VARCHAR, @length) + ')'

                  SET @strsql=@strsql + ' ' + @field + ' '+@datatype+', '

                  DELETE #alter
                  WHERE  strfield_nm = @field
                END --loop3                                
              SET @strsql=LEFT(@strsql, (LEN(@strsql) - 1))
              SET @strsql=@strsql

              PRINT @strsql
              EXEC (@strsql)
            END --loop2                                
          -- This section will create the big_table if it does not exist                                
          ELSE
            BEGIN --loop4                                
              INSERT INTO #alter 
              SELECT sc.name, st.name, sc.length 
              FROM   Qualisys.qp_prod.dbo.syscolumns sc, 
                     Qualisys.qp_prod.dbo.systypes st 
              WHERE  id = @View_id 
                     AND sc.xtype = st.xtype 
                     AND sc.name NOT IN ( 'QuestionForm_id', 'datUndeliverable', 'SamplePop_id', 'SampleSet_id', 'SampleUnit_id', 'datreportdate', 
                            'datSampleEncounterDate', 'strunitselecttype', 'numweight', 'study_id', 'survey_id', 'QtrTable', 'datSampleCreate_dt' ) 
                                
              --DRM 12/02/2011 Added HNumAttempts                                 
              SET @strsql=' CREATE TABLE s' + LTRIM(STR(@Study)) + '.Big_Table_Work ('
                          + ' QtrTable VARCHAR(10), '
                          + --AS ' +                                
                          -- ' convert(varchar(10),(convert(varchar,year(datReportDate))+''_'' ' +                                
                          -- '+convert(varchar,datepart(quarter,datReportDate)))), ' +                                
                          ' questionform_id INT, datUndeliverable DATETIME, SamplePop_id INT NOT NULL, '
                          + ' SampleSet_id INT, SampleUnit_id INT NOT NULL, datReportDate DATETIME, '
                          + ' datSampleEncounterDate DATETIME,'
                          + ' strUnitSelectType CHAR(1), numWeight FLOAT, '
                          + ' study_id INT, survey_id INT, datSampleCreate_dt DATETIME, '
                          + ' DaysFromFirstMailing INT, DaysFromCurrentMailing INT, bitComplete BIT, '
                          + ' HDisposition VARCHAR(20), HHDisposition VARCHAR(20), MNCMDisposition VARCHAR(20), ACODisposition VARCHAR(20), '
                          + ' LagTime int, HNumAttempts int, numCAHPSSupplemental smallint, '

              -- Add fields to the big_table for the study.                                
              WHILE (SELECT COUNT(*) FROM #alter) > 0
                BEGIN --loop5                                
                  SELECT TOP 1 @field=strfield_nm, @datatype=strfielddatatype, @length=intfieldlength
                  FROM   #alter

                  IF @datatype = 'VARCHAR'
                    SET @datatype='VARCHAR(' + CONVERT(VARCHAR, @length) + ')'

                  SET @strsql=@strsql + ' ' + @field + ' '+@datatype+', '

                  DELETE #alter
                  WHERE  strfield_nm = @field
                END --loop5                                
              SET @strsql=LEFT(@strsql, (LEN(@strsql) - 1))
              SET @strsql=@strsql + ') '
              PRINT @strsql
              EXEC (@strsql)

              SET @strsql='ALTER TABLE s' + LTRIM(STR(@Study)) + '.Big_Table_Work WITH NOCHECK ADD            
                                 CONSTRAINT [PK_big_table_work] PRIMARY KEY  CLUSTERED                                 
                                 (                                
                                  [SamplePop_id],                                
                                  [SampleUnit_id]                                
                                 )  ON [PRIMARY] '
              EXEC (@strsql)
            END --loop4                                
          POPULATE:

          -- Now we will add all records for returned surveys.                                
          --   These get inserted INTO Qualisys.QP_Prod.dbo.questionform_extract                                
          --   with a tiextracted value of 1.  The first step is to build the                                 
          --   SELECT statement.                                

          --DRM 12/02/2011 Added HNumAttempts
          SET @strsel=''

          SELECT @strSel = @strSel + name + ', '
          FROM   syscolumns 
          WHERE  id = Object_id(N'[S'+LTRIM(STR(@Study))+'].[BIG_TABLE_WORK]') 
                 AND Objectproperty(id, N'IsTable') = 1 
                 AND name NOT IN ( 'QtrTable', 'bitComplete', 'DaysFromFirstMailing', 'DaysFromCurrentMailing', 'HDisposition', 
                                   'HHDisposition', 'MNCMDisposition', 'ACODisposition', 'LagTime', 'HNumAttempts', 'numCAHPSSupplemental' )

          SET @strsel=LEFT(@strsel, (LEN(@strsel) - 1))
          SET NOCOUNT OFF
          --09/20/2011 DRM added pop_id>0 check to filter out seeded mailing rows.      
          SET @strsql1='INSERT INTO s' + LTRIM(STR(@Study)) + '.Big_Table_Work (QtrTable, ' + @strsel + ') '
          SET @strsql2=' SELECT dbo.YearQtr(datReportDate), ' + @strsel
                       + ' FROM Qualisys.QP_Prod.s' + LTRIM(STR(@Study)) + '.Big_View_Web where pop_id>0'

          -- string lengths                          
          SELECT len(@strsel) AS strsel_len,
                 len(@strsql1) AS strsql1_len,
                 len(@strsql2) AS strsql2_len

          --List the SQL insert.  This is mainly to get the select list if needed for debuging                    
          PRINT @strsql1
          PRINT @strsql2

          EXEC (@strsql1 + @strsql2)

          SET @strsql='UPDATE b ' + CHAR(10)
                      + ' SET b.strUnitSelectType=''X'' ' + CHAR(10)
                      + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, SampleRemove sr ' + CHAR(10)
                      + ' WHERE b.SampleSet_id=sr.SampleSet_id ' + CHAR(10)
                      + ' AND b.SampleUnit_id=sr.SampleUnit_id ' + CHAR(10)
                      + ' AND b.strUnitSelectType=''I'''
          EXEC (@strsql)

          -- Now lets default any HCAHPS survey disposition to '08' (NonResponse After Max Attempts), where surveytype_id = 2 "HCAHPS" for this samplest  
   -- Also set default lagtime values.  
          IF EXISTS (SELECT 1
                     FROM   information_schema.columns
                     WHERE  column_name = 'dischargedate'
                            AND table_schema = 's' + LTRIM(STR(@Study))
                            AND table_name = 'big_table_work')
            BEGIN
              SET @strSQL = 'UPDATE b SET HDisposition = ''08'',  '
                            + ' LagTime = isnull(abs(datediff(dd, dateadd(dd,42,sm.datmailed), b.dischargedate)), 0) ' + CHAR(10)
                            + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, ClientStudySurvey c, Qualisys.qp_prod.dbo.sentmailing sm, '
                            + ' Qualisys.qp_prod.dbo.scheduledmailing schm' + CHAR(10)
                            + ' WHERE b.survey_id = c.survey_id and c.surveytype_id = 2 '
  + ' and sm.sentmail_id = schm.sentmail_id '
                            + ' and schm.samplepop_id = b.samplepop_id '
                            + ' AND b.sampleset_id = ' + LTRIM(STR(@SampleSet))
            END
          ELSE
            BEGIN
              SET @strSQL = 'UPDATE b SET HDisposition = ''08'', LagTime = 0 ' + CHAR(10)
                            + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, ClientStudySurvey c, Qualisys.qp_prod.dbo.sentmailing sm, '
                            + ' Qualisys.qp_prod.dbo.scheduledmailing schm' + CHAR(10)
                            + ' WHERE b.survey_id = c.survey_id and c.surveytype_id = 2  '
                            + ' and sm.sentmail_id = schm.sentmail_id  '
                            + ' and schm.samplepop_id = b.samplepop_id  '
                            + ' AND b.sampleset_id = ' + LTRIM(STR(@SampleSet))
            END

          EXEC (@strsql)

          -- DRM 12/02/11 Added HNumAttempts.  
          -- Update HNumAttempts for HCAHPS surveys.  
          -- Phone            
          --
          -- Lee Kohrs 2013-07-17 HCAHPS 2012 Audit Project TR#7a
          --
          --Old Code
          --SET @strSQL = 'update bt set hnumattempts = isnull(numberofattempts, 5) '
          --              + 'from Qualisys.qp_prod.dbo.survey_def sd inner join Qualisys.qp_prod.dbo.mailingmethodology mm '
          --              + ' on sd.survey_id = mm.survey_id '
          --              + 'inner join Qualisys.qp_prod.dbo.standardmethodology sm '
          --              + ' on mm.standardmethodologyid = sm.standardmethodologyid '
          --              + 'inner join Qualisys.qp_prod.dbo.mailingstep ms '
          --              + ' on ms.methodology_id = mm.methodology_id '
          --              + ' and ms.survey_id = sd.survey_id '
          --              + 'inner join S'
          --              + LTRIM(STR(@Study))
          --              + '.Big_Table_Work bt '
          --              + ' on bt.survey_id = sd.survey_id '
          --              + 'where sd.surveytype_id = 2 '
          --              + 'and mm.bitactivemethodology = 1 '
          --              + 'and sm.standardmethodologyid in (2, 12) '
          --
          --New Code
          SET @strSQL = 'update bt set hnumattempts = isnull(ms.NumberOfAttempts, 5) '
                        + 'from S' + LTRIM(STR(@Study)) + '.Big_Table_Work bt '
                        + 'inner join Qualisys.qp_prod.dbo.scheduledmailing schm '
                        + ' on  bt.samplepop_id =  schm.samplepop_id '
                        + 'inner join Qualisys.qp_prod.dbo.mailingmethodology mm '
                        + ' on schm.methodology_id = mm.methodology_id '
                        + 'inner join Qualisys.qp_prod.dbo.mailingstep ms '
                        + ' on ms.mailingstep_id = schm.mailingstep_id '
                        + 'where mm.standardmethodologyid in (2, 12) '
          EXEC (@strsql)

          -- DRM 12/02/11 Added HNumAttempts.  
          -- Update HNumAttempts for HCAHPS surveys.  
          --
          --
          -- Update HNumAttempts for HCAHPS surveys.  
          -- Mail            
          --
          -- Lee Kohrs 2013-07-17 HCAHPS 2012 Audit Project TR#7b
          --
          --Old Code
          --SET @strSQL = 'update b set hnumattempts = tmp.hnumattempts from '
          --              + 'S'
          --              + LTRIM(STR(@Study))
          --              + '.Big_Table_Work b, (select sd.survey_id, count(*) hnumattempts '
          --              + 'from Qualisys.qp_prod.dbo.survey_def sd inner join Qualisys.qp_prod.dbo.mailingmethodology mm '
          --              + ' on sd.survey_id = mm.survey_id '
          --              + 'inner join Qualisys.qp_prod.dbo.standardmethodology sm '
          --              + ' on mm.standardmethodologyid = sm.standardmethodologyid '
          --              + 'inner join Qualisys.qp_prod.dbo.mailingstep ms '
          --              + ' on ms.methodology_id = mm.methodology_id '
          --              + ' and ms.survey_id = sd.survey_id '
          --              + 'where sd.surveytype_id = 2 '
          --              + 'and mm.bitactivemethodology = 1 '
          --              + 'and sm.standardmethodologyid in (1, 9) '
          --              + 'and ms.bitsendsurvey = 1 '
          --              + 'and sd.survey_id in (select distinct survey_id from S'
          --              + LTRIM(STR(@Study))
          --              + '.Big_Table_Work) '
          --              + 'group by sd.survey_id, mm.methodology_id) tmp '
          --              + 'where b.survey_id = tmp.survey_id '
          ----New Code
          SET @strSQL = 'update b set hnumattempts = tmp.hnumattempts from '
                        + 'S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, (select schm.samplepop_id, count(*) hnumattempts '
                        + 'from Qualisys.qp_prod.dbo.scheduledmailing schm '
                        + ' inner join Qualisys.qp_prod.dbo.mailingmethodology mm '
                        + ' on schm.methodology_id = mm.methodology_id '
                        + 'where mm.standardmethodologyid in (1, 9) '
                        + ' and schm.samplepop_id in (select distinct samplepop_id from S' + LTRIM(STR(@Study)) + '.Big_Table_Work) '
                        + 'group by schm.samplepop_id) tmp '
                        + 'where b.samplepop_id = tmp.samplepop_id '
          EXEC (@strsql)


		    IF EXISTS (SELECT 1
						FROM   information_schema.columns
						WHERE  column_name = 'dischargedate'
                            AND table_schema = 's' + LTRIM(STR(@Study))
                            AND table_name = 'big_table_work')
            BEGIN
                        ----Lee Kohrs 2013-06-28 modified for TR#14 of the HCAHPS 2012 Audit Project
						SET @strSQL = 'if exists (select 1 from clientstudysurvey css'
                        + ' inner join S' + LTRIM(STR(@Study)) + '.Big_Table_Work bt on css.survey_id = bt.survey_id where surveytype_id = 2) '
						+ 'UPDATE B SET '
                        + ' HDISPOSITION = ''08'', '
                        + ' HNUMATTEMPTS = 8, '
                        --+ ' DaysFromFirstMailing  = 0, '
                        --+ ' DaysFromCurrentMailing = 0, '
                        + ' LAGTIME = abs( datediff(dd, schm.datGenerate, b.dischargedate)) ' + CHAR(10)
                        + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, '
                        + ' Qualisys.qp_prod.dbo.scheduledmailing schm' + CHAR(10)
                        + ' WHERE schm.samplepop_id = b.samplepop_id  '
                        + ' AND schm.sentmail_id = -1'
            END
          ELSE
            BEGIN
                        ----Lee Kohrs 2013-06-28 modified for TR#14 of the HCAHPS 2012 Audit Project
						SET @strSQL = 'if exists (select 1 from clientstudysurvey css'
                        + ' inner join S' + LTRIM(STR(@Study)) + '.Big_Table_Work bt on css.survey_id = bt.survey_id where surveytype_id = 2) '
						+ 'UPDATE B SET '
                        + ' HDISPOSITION = ''08'', '
                        + ' HNUMATTEMPTS = 8, '
                        --+ ' DaysFromFirstMailing  = 0, '
                        --+ ' DaysFromCurrentMailing = 0, '
                        + ' LAGTIME = 0' + CHAR(10)
                        + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, '
                        + ' Qualisys.qp_prod.dbo.scheduledmailing schm' + CHAR(10)
                        + ' WHERE schm.samplepop_id = b.samplepop_id  '
                        + ' AND schm.sentmail_id = -1'
            END

		  print @strsql
          EXEC (@strsql)

          -- Now let's default any HHCAHPS survey disposition to '350' (NonResponse After Max Attempts), where surveytype_id = 3 "Home Health CAHPS" for this samplest                       
          SET @strSQL = 'UPDATE b SET HHDisposition = ''350'' ' + CHAR(10)
                        + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, ClientStudySurvey c ' + CHAR(10)
                        + ' WHERE b.survey_id = c.survey_id and c.surveytype_id = 3 AND b.sampleset_id = ' + LTRIM(STR(@SampleSet))
          EXEC (@strsql)

          -- Now let's default any MNCM/CG-CAHPS survey disposition to '9' (NonResponse After Max Attempts), where surveytype_id = 4 "MNCM" for this samplest                       
          SET @strSQL = 'UPDATE b SET MNCMDisposition = ''9'' ' + CHAR(10)
                        + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, ClientStudySurvey c ' + CHAR(10)
                        + ' WHERE b.survey_id = c.survey_id and c.surveytype_id = 4 AND b.sampleset_id = ' + LTRIM(STR(@SampleSet))
          EXEC (@strsql)

          -- Now let's default any ACO CAHPS survey disposition to '33' (NonResponse After Max Attempts), where surveytype_id = 10 "ACO" for this samplest                       
          SET @strSQL = 'UPDATE b SET MNCMDisposition = ''33'' ' + CHAR(10)
                        + ' FROM S' + LTRIM(STR(@Study)) + '.Big_Table_Work b, ClientStudySurvey c ' + CHAR(10)
                        + ' WHERE b.survey_id = c.survey_id and c.surveytype_id = 10 AND b.sampleset_id = ' + LTRIM(STR(@SampleSet))
          EXEC (@strsql)
          
          SET @strSQL = 'update bt set numCAHPSSupplemental = qf.numCAHPSSupplemental '
                        + 'from S' + LTRIM(STR(@Study)) + '.Big_Table_Work bt '
                        + 'inner join Qualisys.qp_prod.dbo.questionform qf '
                        + ' on bt.samplepop_id = qf.samplepop_id'
          EXEC (@strsql)

          SET NOCOUNT ON

          DELETE #SampleSets
          WHERE  SampleSet_id = @SampleSet
                 AND study_id = @study

          UPDATE Qualisys.QP_Prod.dbo.SampleSet 
          SET web_extract_flg=1
          WHERE SampleSet_id=@SampleSet

          EXEC (@strsql)
        END --SampleSet loop                                
      ---------------------------------------------------------------------------------------------------------------------------------------------------------                                
      --  Response Rate PART 1 of 3 (SampleSet/SampleUnit Sampled Count - Update/Insert)                                
      EXEC sp_Extract_RespRate @study ,@procpart=1

      ---------------------------------------------------------------------------------------------------------------------------------------------------------                                
      DELETE #s
      WHERE  study_id = @study
    END --loop 1
