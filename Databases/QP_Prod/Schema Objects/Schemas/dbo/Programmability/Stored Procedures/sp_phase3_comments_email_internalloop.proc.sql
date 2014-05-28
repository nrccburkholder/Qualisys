CREATE procedure sp_phase3_comments_email_internalloop
as

exec sp_clientcontact_replacequotes

--Create the table to hold the email addresses for each litho code
CREATE TABLE #Main (Study_id        int, 
                    Survey_id       int, 
                    strLithoCode    varchar(10), 
                    strFName        varchar(42),
                    strLName        varchar(42),
                    strAreaCode     varchar(3),
                    strPhone        varchar(10),
                    strMRN          varchar(42)
                   )

--Create the table to hold the formated email
CREATE TABLE ##Email (Line_id int identity,
                      strLine varchar(65)
                     )

--Populate the study, survey and lithocodes in temp table
INSERT INTO #Main (Study_id, Survey_id, strLithoCode)
SELECT Study_id, Survey_id, strLithoCode
FROM comments_for_extract
WHERE CmntType_id in (2,3)
/*Modified 2/5/2 BD This is to be used by everyone except Trinity.  Remove this line once Trinity is using this solution. */
and study_id not in (select study_id from study where client_id = 253)

--Declare required variables
DECLARE @Recip       varchar(2000)
DECLARE @TempRecip   varchar(35)
DECLARE @CCopy       varchar(20)
DECLARE @SurveyID    int
DECLARE @StudyID     int
DECLARE @strSql      varchar(2000)
DECLARE @LithoCode   varchar(10)
DECLARE @FName       varchar(42)
DECLARE @LName       varchar(42)
DECLARE @AreaCode    varchar(3)
DECLARE @Phone       varchar(10)
DECLARE @MRN         varchar(42)
DECLARE @PhoneString varchar(14)
DECLARE @Subject     varchar(100)

create table #fields (FieldName varchar(42), strFieldName varchar(42), Field varchar(42), updated bit)

insert into #fields (FieldName, strFieldName)
select 'FName', 'strFName'
union
select 'LName', 'strLName'
union
select 'AreaCode', 'strAreaCode'
union
select 'Phone', 'strPhone'
union
select 'MRN', 'strMRN'

--Loop through all studies
WHILE (SELECT TOP 1 Study_id FROM #Main) > 1
BEGIN
    --Get the study_id to be worked with
    SET @StudyID = (SELECT TOP 1 Study_id FROM #Main ORDER BY study_id)

update #fields set field = 'N/A', updated = 0

update f
set f.field = mdv.strfield_nm
from #fields f, metadata_view mdv
where f.fieldname = mdv.strfield_nm
and mdv.study_id = @studyid

update #fields

    SET @strSql = 'UPDATE mn ' + char(10) + 
		  'SET '
declare @f1 varchar(42), @f2 varchar(42)

while (select count(*) from #fields where updated = 0) > 0
begin

set @f1 = (select top 1 strfieldname from #fields where updated = 0)

set @f2 = (select field from #fields where strfieldname = @f1)

if @f2 = 'N/A'
  begin

     set @strsql = @strsql + 'mn.' + @f1 + '=''' + @f2 + ''', '

  end

else
  begin

     set @strsql = @strsql + 'mn.' + @f1 + '=po.' + @f2 + ', '

  end

update #fields set updated = 1 where strfieldname = @f1

end

set @strsql = left(@strsql,(len(@strsql)-1))

set @strsql = @strsql + 
                  ' FROM #Main mn, SentMailing sm, QuestionForm qf, SamplePop sp, ' + char(10) + 
                  '     s' + convert(varchar, @StudyID) + '.Population po ' + char(10) + 
                  ' WHERE mn.strLithoCode = sm.strLithoCode ' + char(10) + 
                  '  AND sm.SentMail_id = qf.SentMail_id ' + char(10) + 
                  '  AND qf.SamplePop_id = sp.SamplePop_id ' + char(10) + 
                  '  AND mn.Study_id = sp.Study_id ' + char(10) + 
                  '  AND sp.Pop_id = po.Pop_id ' + char(10) +
                  '  AND mn.Study_id = ' + convert(varchar, @StudyID)
    EXEC (@strSql)

    --Loop through and generate the required emails
    WHILE (SELECT TOP 1 Survey_id FROM #Main WHERE Study_id = @StudyID) > 1
    BEGIN
        --Get the survey_id to be worked with
        SET @SurveyID = (SELECT TOP 1 Survey_id FROM #Main WHERE Study_id = @StudyID ORDER BY survey_id)
        
        --Get the account director email address
        SET @CCopy = (SELECT em.strNTLogin_Nm 
                      FROM Study st, Employee em 
                      WHERE st.Study_id = @StudyID 
                        AND st.ADEmployee_id = em.Employee_id
                     )
/* Modified 2/5/2 BD This will need to be added back in once we want the emails to go to the clients. */
        --Get the client contact email address
        SET @Recip = ''

            DECLARE TmpRecip CURSOR FOR
            SELECT cc.strContactEmail
            FROM Study st, Client_Contact cc, Survey_Contact sc
            WHERE st.Client_id = cc.Client_id
              AND cc.Contact_id = sc.Contact_id
              AND st.Study_id = @StudyID
              AND sc.Survey_id = @SurveyID
              AND sc.ContactType_id = 5
              AND cc.strContactEmail IS NOT NULL
        OPEN TmpRecip
        FETCH NEXT FROM TmpRecip INTO @TempRecip
        WHILE @@fetch_status = 0
        BEGIN

IF LEN(@Recip) + LEN(@TempRecip) > 255
BEGIN

        --Determine the subject line

        IF @CCopy = @Recip
            SET @Subject = 'Service Alert/Contact - No Client Contact Specified Survey ' + convert(varchar,@surveyid)
        ELSE
            SET @Subject = 'Service Alert/Contact'

        --Clear the email table
        TRUNCATE TABLE ##Email

        --Determine the number of service alerts
        DECLARE @cnt INT
        SELECT @cnt=COUNT(*) FROM #Main WHERE Survey_id=@SurveyID

        IF @cnt = 1
          BEGIN
          --Insert the top line
             INSERT INTO ##Email ( strLine ) VALUES ( 'This email has been sent as notification that ' + CONVERT(VARCHAR,@cnt) + ' Service' )
             INSERT INTO ##Email ( strLine ) VALUES ( 'Alert/Contact Comment has been posted to your IDEAS web site.' )
          END

        ELSE
          BEGIN
          --Insert the top line
             INSERT INTO ##Email ( strLine ) VALUES ( 'This email has been sent as notification that ' + CONVERT(VARCHAR,@cnt) + ' Service' )
             INSERT INTO ##Email ( strLine ) VALUES ( 'Alert/Contact Comments have been posted to your IDEAS web site.' )
          END
       
        --Populate the email table
        DECLARE Tmp CURSOR FOR SELECT strLithoCode, strFName, strLName, strAreaCode, strPhone, strMRN FROM #Main WHERE Survey_id = @SurveyID ORDER BY strLithoCode
        OPEN Tmp
        FETCH NEXT FROM Tmp INTO @LithoCode, @FName, @LName, @AreaCode, @Phone, @MRN
        WHILE @@fetch_status = 0
        BEGIN
            --Format the phone string
            --Insert the LithoCode Line
            INSERT INTO ##Email ( strLine ) VALUES ( 'Survey Code:  ' + @LithoCode )

            --Prepare for the next pass through the loop
            FETCH NEXT FROM Tmp INTO @LithoCode, @FName, @LName, @AreaCode, @Phone, @MRN
        END
        CLOSE Tmp
        DEALLOCATE Tmp

        --Insert a blank row
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        
        --Insert the IDEAS address line
        INSERT INTO ##Email ( strLine ) VALUES ( 'Click here to link to IDEAS:' )
        INSERT INTO ##Email ( strLine ) VALUES ( '    http://ideas.nationalresearch.com/default.asp' )
        
        --Insert two blank lines
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        
        --Insert the footer
        INSERT INTO ##Email ( strLine ) VALUES ( 'National Research Corporation' )
        INSERT INTO ##Email ( strLine ) VALUES ( '1245 Q Street' )
        INSERT INTO ##Email ( strLine ) VALUES ( 'Lincoln, NE 68508' )
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        INSERT INTO ##Email ( strLine ) VALUES ( 'Phone: (402) 475-2525' )
        INSERT INTO ##Email ( strLine ) VALUES ( 'Fax:   (402) 475-9061' )
        
        --Send the email
        SET @strSql = 'master..xp_sendmail @recipients = ''' + @Recip + ''', ' + char(10) +
                      '                    @copy_recipients = ''' + @CCopy + ''', ' + char(10) +
                      '                    @blind_copy_recipients = ''JFleming; BDohmen; PErnesti'', ' + char(10) +
                      '                    @subject = ''' + @Subject + ''', ' + char(10) +
                      '                    @query = ''SELECT strLine FROM ##Email ORDER BY Line_id'', ' + char(10) +
                      '                    @no_header = ''TRUE'''
--        EXEC (@strSql)
	PRINT @strSql
       
SET @Recip = ''

END  


            --Build the recipient string
            IF LEN(@Recip) > 0
                SET @Recip = @Recip + ';' + @TempRecip
            ELSE
                SET @Recip = @TempRecip
            
            --Prepare for the next pass through the loop
            FETCH NEXT FROM TmpRecip INTO @TempRecip
        END
        CLOSE TmpRecip
        DEALLOCATE TmpRecip
     
        --If the client contact email is null set it to account director email
        IF LEN(@Recip) = 0
         SET @Recip = @CCopy

        --Determine the subject line

        IF @CCopy = @Recip
            SET @Subject = 'Service Alert/Contact - No Client Contact Specified Survey ' + convert(varchar,@surveyid)
        ELSE
            SET @Subject = 'Service Alert/Contact'

        --Clear the email table
        TRUNCATE TABLE ##Email

        --Determine the number of service alerts
--        DECLARE @cnt INT
        SELECT @cnt=COUNT(*) FROM #Main WHERE Survey_id=@SurveyID

        IF @cnt = 1
          BEGIN
          --Insert the top line
             INSERT INTO ##Email ( strLine ) VALUES ( 'This email has been sent as notification that ' + CONVERT(VARCHAR,@cnt) + ' Service' )
             INSERT INTO ##Email ( strLine ) VALUES ( 'Alert/Contact Comment has been posted to your IDEAS web site.' )
          END

        ELSE
          BEGIN
          --Insert the top line
             INSERT INTO ##Email ( strLine ) VALUES ( 'This email has been sent as notification that ' + CONVERT(VARCHAR,@cnt) + ' Service' )
             INSERT INTO ##Email ( strLine ) VALUES ( 'Alert/Contact Comments have been posted to your IDEAS web site.' )
          END

        --Populate the email table
        DECLARE Tmp CURSOR FOR SELECT strLithoCode, strFName, strLName, strAreaCode, strPhone, strMRN FROM #Main WHERE Survey_id = @SurveyID ORDER BY strLithoCode
        OPEN Tmp
        FETCH NEXT FROM Tmp INTO @LithoCode, @FName, @LName, @AreaCode, @Phone, @MRN
        WHILE @@fetch_status = 0
        BEGIN
            --Format the phone string
            --Insert the LithoCode Line
            INSERT INTO ##Email ( strLine ) VALUES ( 'Survey Code:  ' + @LithoCode )

            --Prepare for the next pass through the loop
            FETCH NEXT FROM Tmp INTO @LithoCode, @FName, @LName, @AreaCode, @Phone, @MRN
        END
        CLOSE Tmp
        DEALLOCATE Tmp

        --Insert a blank row
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        
        --Insert the IDEAS address line
        INSERT INTO ##Email ( strLine ) VALUES ( 'Click here to link to IDEAS:' )
        INSERT INTO ##Email ( strLine ) VALUES ( '    http://ideas.nationalresearch.com/default.asp' )
        
        --Insert two blank lines
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        
        --Insert the footer
        INSERT INTO ##Email ( strLine ) VALUES ( 'National Research Corporation' )
        INSERT INTO ##Email ( strLine ) VALUES ( '1245 Q Street' )
        INSERT INTO ##Email ( strLine ) VALUES ( 'Lincoln, NE 68508' )
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        INSERT INTO ##Email ( strLine ) VALUES ( 'Phone: (402) 475-2525' )
        INSERT INTO ##Email ( strLine ) VALUES ( 'Fax:   (402) 475-9061' )
        
        --Send the email
        SET @strSql = 'master..xp_sendmail @recipients = ''' + @Recip + ''', ' + char(10) +
                      '                    @copy_recipients = ''' + @CCopy + ''', ' + char(10) +
                      '                    @blind_copy_recipients = ''JFleming; BDohmen; PErnesti'', ' + char(10) +
                      '                    @subject = ''' + @Subject + ''', ' + char(10) +
                      '                    @query = ''SELECT strLine FROM ##Email ORDER BY Line_id'', ' + char(10) +
                      '                    @no_header = ''TRUE'''
--        EXEC (@strSql)
	PRINT @strSql

        --Delete all records for this survey_id from the temp table
        DELETE FROM #Main WHERE Survey_id = @SurveyID
        
    END  --Survey Loop
    
    --Delete all records for this study if any exist
    DELETE FROM #Main WHERE Study_id = @StudyID
    
END  --Study Loop

--Cleanup
DROP TABLE #Main
DROP TABLE ##Email
DROP TABLE #fields


