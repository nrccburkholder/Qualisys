CREATE procedure sp_phase3_emaila
as

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
SELECT Study_id, Survey_id, LithoCode
FROM phase3_comments
WHERE CommentType = 'Service Alert'

--Declare required variables
DECLARE @Recip       varchar(350)
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

--Loop through all studies
WHILE (SELECT TOP 1 Study_id FROM #Main) > 1
BEGIN
    --Get the study_id to be worked with
    SET @StudyID = (SELECT TOP 1 Study_id FROM #Main)
    
    --Update the name and MRN
    SET @strSql = 'UPDATE mn ' + char(10) + 
                  'SET mn.strFName = po.FName, mn.strLName = po.LName, mn.strMRN = po.MRN ' + char(10) + 
                  'FROM #Main mn, SentMailing sm, QuestionForm qf, SamplePop sp, ' + char(10) + 
                  '     s' + convert(varchar, @StudyID) + '.Population po ' + char(10) + 
                  'WHERE mn.strLithoCode = sm.strLithoCode ' + char(10) + 
                  '  AND sm.SentMail_id = qf.SentMail_id ' + char(10) + 
                  '  AND qf.SamplePop_id = sp.SamplePop_id ' + char(10) + 
                  '  AND mn.Study_id = sp.Study_id ' + char(10) + 
                  '  AND sp.Pop_id = po.Pop_id ' + char(10) +
                  '  AND mn.Study_id = ' + convert(varchar, @StudyID)
    EXEC (@strSql)
    
    --Update the phone
    IF EXISTS (SELECT mf.Field_id 
               FROM MetaTable mt, MetaStructure ms, MetaField mf
               WHERE mt.Table_id = ms.Table_id
                 AND ms.Field_id = mf.Field_id
                 AND mt.Study_id = @StudyID
                 AND mf.strField_Nm = 'Phone')
    BEGIN
        IF EXISTS (SELECT mf.Field_id 
                   FROM MetaTable mt, MetaStructure ms, MetaField mf
                   WHERE mt.Table_id = ms.Table_id
                     AND ms.Field_id = mf.Field_id
                     AND mt.Study_id = @StudyID
                     AND mf.strField_Nm = 'AreaCode')
        BEGIN
            SET @strSql = 'UPDATE mn ' + char(10) + 
                          'SET mn.strAreaCode = po.AreaCode, mn.strPhone = po.Phone ' + char(10) + 
                          'FROM #Main mn, SentMailing sm, QuestionForm qf, SamplePop sp, ' + char(10) + 
                          '     s' + convert(varchar, @StudyID) + '.Population po ' + char(10) + 
                          'WHERE mn.strLithoCode = sm.strLithoCode ' + char(10) + 
                          '  AND sm.SentMail_id = qf.SentMail_id ' + char(10) + 
                          '  AND qf.SamplePop_id = sp.SamplePop_id ' + char(10) + 
                          '  AND mn.Study_id = sp.Study_id ' + char(10) + 
                          '  AND sp.Pop_id = po.Pop_id ' + char(10) +
                          '  AND mn.Study_id = ' + convert(varchar, @StudyID)
            EXEC (@strSql)
        END
        ELSE
        BEGIN
            SET @strSql = 'UPDATE mn ' + char(10) + 
                          'SET mn.strPhone = po.Phone ' + char(10) + 
                          'FROM #Main mn, SentMailing sm, QuestionForm qf, SamplePop sp, ' + char(10) + 
                          '     s' + convert(varchar, @StudyID) + '.Population po ' + char(10) + 
                          'WHERE mn.strLithoCode = sm.strLithoCode ' + char(10) + 
                          '  AND sm.SentMail_id = qf.SentMail_id ' + char(10) + 
                          '  AND qf.SamplePop_id = sp.SamplePop_id ' + char(10) + 
                          '  AND mn.Study_id = sp.Study_id ' + char(10) + 
                          '  AND sp.Pop_id = po.Pop_id ' + char(10) +
                          '  AND mn.Study_id = ' + convert(varchar, @StudyID)
            EXEC (@strSql)
        END
    END
    ELSE
    BEGIN
        UPDATE #Main SET strPhone = 'N/A' WHERE Study_id = @StudyID
    END
    
    --Loop through and generate the required emails
    WHILE (SELECT TOP 1 Survey_id FROM #Main WHERE Study_id = @StudyID) > 1
    BEGIN
        --Get the survey_id to be worked with
        SET @SurveyID = (SELECT TOP 1 Survey_id FROM #Main WHERE Study_id = @StudyID)
        
        --Get the account director email address
        SET @CCopy = (SELECT em.strNTLogin_Nm 
                      FROM Study st, Employee em 
                      WHERE st.Study_id = @StudyID 
                        AND st.ADEmployee_id = em.Employee_id
                     )

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
            SET @Subject = 'Service Alert - No Client Contact Specified'
        ELSE
            SET @Subject = 'Service Alert'
        
        --Clear the email table
        TRUNCATE TABLE ##Email
        
        --Insert the top line
        INSERT INTO ##Email ( strLine ) VALUES ( 'This email has been sent as notification that a Service Alert has' )
        INSERT INTO ##Email ( strLine ) VALUES ( 'been posted to your IDEAS web site.' )
        
        --Populate the email table
        DECLARE Tmp CURSOR FOR SELECT strLithoCode, strFName, strLName, strAreaCode, strPhone, strMRN FROM #Main WHERE Survey_id = @SurveyID ORDER BY strLithoCode
        OPEN Tmp
        FETCH NEXT FROM Tmp INTO @LithoCode, @FName, @LName, @AreaCode, @Phone, @MRN
        WHILE @@fetch_status = 0
        BEGIN
            --Format the phone string
            IF @AreaCode IS NULL
            BEGIN
                IF LEN(@Phone) = 7
                    SET @PhoneString = SUBSTRING(@Phone, 1, 3) + '-' + SUBSTRING(@Phone, 4, 4)
                ELSE IF LEN(@Phone) = 10
                    SET @PhoneString = '(' + SUBSTRING(@Phone, 1, 3) + ') ' + SUBSTRING(@Phone, 4, 3) + '-' + SUBSTRING(@Phone, 7, 4)
                ELSE
                    SET @PhoneString = @Phone

            END
            ELSE IF LEN(@AreaCode) = 3
            BEGIN
                IF LEN(@Phone) = 7
                    SET @PhoneString = '(' + @AreaCode + ')' + SUBSTRING(@Phone, 1, 3) + '-' + SUBSTRING(@Phone, 4, 4)
                ELSE
                    SET @PhoneString = '(' + @AreaCode + ')' + @Phone
            END
            ELSE
                SET @PhoneString = @AreaCode + @Phone
            
            --Insert a blank row
            INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
            
            --Insert the LithoCode Line
            INSERT INTO ##Email ( strLine ) VALUES ( 'Survey Code:  ' + @LithoCode )
            
            --Insert the FName line
            INSERT INTO ##Email ( strLine ) VALUES ( 'First Name:   ' + @FName )
            
            --Insert the LName line
            INSERT INTO ##Email ( strLine ) VALUES ( 'Last Name:    ' + @LName )
            
            --Insert the Phone line
            INSERT INTO ##Email ( strLine ) VALUES ( 'Phone Number: ' + @PhoneString )
            
            --Insert the MRN line
            INSERT INTO ##Email ( strLine ) VALUES ( 'MRN:          ' + @MRN )
            
            --Prepare for the next pass through the loop
            FETCH NEXT FROM Tmp INTO @LithoCode, @FName, @LName, @AreaCode, @Phone, @MRN
        END
        CLOSE Tmp
        DEALLOCATE Tmp
        
        --Insert a blank row
        INSERT INTO ##Email ( strLine ) VALUES ( ' ' )
        
        --Insert the LithoCode Line
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
                      '                    @blind_copy_recipients = ''JFleming;PErnesti'', ' + char(10) +
                      '                    @subject = ''' + @Subject + ''', ' + char(10) +
                      '                    @query = ''SELECT strLine FROM ##Email ORDER BY Line_id'', ' + char(10) +
                      '                    @no_header = ''TRUE'''
        EXEC (@strSql)
        
        --Delete all records for this survey_id from the temp table
        DELETE FROM #Main WHERE Survey_id = @SurveyID
        
    END  --Survey Loop
    
    --Delete all records for this study if any exist
    DELETE FROM #Main WHERE Study_id = @StudyID
    
END  --Study Loop

--Cleanup
DROP TABLE #Main
DROP TABLE ##Email


