CREATE PROCEDURE [dbo].[ETL_UnsentServiceAlertEmails] 
    @Debug BIT = 0
AS

--Prepare the environment
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

--Declare required variables
DECLARE @ClientUserID INT
DECLARE @LithoCode    VARCHAR(15)
DECLARE @LithoList    VARCHAR(5000)
DECLARE @Sql          VARCHAR(8000)

--Collect the Comments that should have received Emails
--Collect the loaded Comments that may get Emails
SELECT cc.strLithoCode, cs.Client_id, cs.Study_id, cs.Survey_id, cc.SampleUnit_id, cs.ad
INTO #Email
FROM DataMart.QP_Comments.dbo.ClientStudySurvey cs, DataMart.QP_Comments.dbo.Comments cc
WHERE cc.CmntType_id in (2, 3)
AND cc.Survey_id = cs.Survey_id 

IF @Debug = 1
    SELECT '[#Email All]', * FROM #Email

--Drop the LithoCodes that did in fact get an Email
DELETE em 
FROM #Email em 
WHERE EXISTS (SELECT * 
              FROM DataMart.QP_Comments.dbo.EmailLog 
              WHERE strLithoList like '%' + em.strLithoCode + '%'
             )

IF @Debug = 1
    SELECT '[#Email Unsent]', * FROM #Email

--Determine the ClientUser_ids associated with the above Comments
CREATE TABLE #Users (ClientUser_id INT, strLithoCode VARCHAR(15), AD VARCHAR(42))

INSERT INTO #Users (ClientUser_id, strLithoCode, AD)
SELECT DISTINCT gr.Group_id, em.strLithoCode, em.ad
FROM DataMart.QP_Comments.dbo.GroupsRights gr, #Email em
WHERE gr.intValue = em.Client_id
  AND gr.ValueType_id = 1
UNION
SELECT DISTINCT gr.Group_id, em.strLithoCode, em.ad
FROM DataMart.QP_Comments.dbo.GroupsRights gr, #Email em
WHERE gr.intValue = em.Study_id
  AND gr.ValueType_id = 2
UNION
SELECT DISTINCT gr.Group_id, em.strLithoCode, em.ad
FROM DataMart.QP_Comments.dbo.GroupsRights gr, #Email em
WHERE gr.intValue = em.Survey_id
  AND gr.ValueType_id = 3
UNION
SELECT DISTINCT gr.Group_id, em.strLithoCode, em.ad
FROM DataMart.QP_Comments.dbo.GroupsRights gr, #Email em
WHERE gr.intValue = em.SampleUnit_id
  AND gr.ValueType_id = 4

IF @Debug = 1
    SELECT '[#Users]', * FROM #Users

--Select the list of ClientUsers and lithos
SELECT ClientUser_id, strLithoCode 
INTO #ClientUserLitho
FROM #Users u, DataMart.QP_Comments.dbo.UserAccessWA ua
WHERE u.ClientUser_id = ua.User_id
ORDER BY 1, 2

IF @Debug = 1
    SELECT '[#ClientUserLitho]', * FROM #ClientUserLitho

--Change the Lithos for each ClientUser into a comma separated list
--Create table to hold comma separated litho list
CREATE TABLE #ClientUserLithos (ClientUser_id INT, 
                                strLithoList  VARCHAR(5000), 
                                strLoginName  VARCHAR(100), 
                                bitSAEmail    BIT DEFAULT (0))

--Get a distinct list of users
SELECT DISTINCT ClientUser_id
INTO #ClientUsers
FROM #ClientUserLitho

--Loop through each user and build its litho list
SET @LithoList = ''
SELECT TOP 1 @ClientUserID = ClientUser_id FROM #ClientUsers

WHILE @@ROWCOUNT > 0
BEGIN
    --Get the first litho for this user
    SELECT TOP 1 @LithoCode = strLithoCode FROM #ClientUserLitho WHERE ClientUser_id = @ClientUserID
	
    WHILE @@ROWCOUNT > 0
    BEGIN
        --Add this litho to the list
        IF @LithoList = ''
            SET @LithoList = @LithoCode
        ELSE
            SET @LithoList = @LithoList + ',' + @LithoCode
        
        --Prepare for next pass
        DELETE #ClientUserLitho WHERE ClientUser_id = @ClientUserID AND strLithoCode = @LithoCode
        SELECT TOP 1 @LithoCode = strLithoCode FROM #ClientUserLitho WHERE ClientUser_id = @ClientUserID
    END
    
    --Insert this list of lithos
    INSERT INTO #ClientUserLithos (ClientUser_id, strLithoList)
    VALUES (@ClientUserID, @LithoList)
    
    --Prepare for next pass
    SET @LithoList = ''
    DELETE #ClientUsers WHERE ClientUser_id = @ClientUserID
    SELECT TOP 1 @ClientUserID = ClientUser_id FROM #ClientUsers
END    

--Get NRCAuth data
UPDATE cl
SET cl.strLoginName = gr.strGroup_Nm, 
    cl.bitSAEmail = CASE 
                        WHEN gr.datRetired IS NULL AND
                             gp.datGranted IS NOT NULL AND
                             ISNULL(gp.datRevoked, '4000-01-01') > GETDATE() 
                        THEN 1
                        ELSE 0
                    END
FROM #ClientUserLithos cl, Security.NRCAuth.dbo.Groups gr, 
     Security.NRCAuth.dbo.GroupPrivilege gp, Security.NRCAuth.dbo.OrgUnitPrivilege op, 
     Security.NRCAuth.dbo.Privilege pr, Security.NRCAuth.dbo.Application ap
WHERE cl.ClientUser_id = gr.Group_id
  AND gr.Group_id = gp.Group_id
  AND gp.OrgUnitPrivilege_id = op.OrgUnitPrivilege_id
  AND op.Privilege_id = pr.Privilege_id
  AND pr.Application_id = ap.Application_id
  AND ap.strApplication_Nm = 'eComments'
  AND pr.strPrivilege_nm = 'Receive Service Alert/Contact Emails'

IF @Debug = 1
    SELECT '[#ClientUserLithos]', * FROM #ClientUserLithos

--Build the query
SET @Sql = 'SELECT DISTINCT cs.strClient_Nm + '' ('' + CONVERT(VARCHAR, cs.Client_id) + '')'' AS [Client], 
                            REPLACE(ua.strEmailList,'' '','''') AS [To], 
                            us.ad + ''@NationalResearch.com'' AS [CC], 
                            cl.strLithoList AS [Survey Codes], 
                            cl.strLoginName AS [eComments Login]
            FROM #Users us, DataMart.QP_Comments.dbo.UserAccessWA ua, #ClientUserLithos cl, DataMart.QP_Comments.dbo.ClientStudySurvey cs
            WHERE us.ClientUser_id = ua.User_id
              AND us.ClientUser_id = cl.ClientUser_id
              AND ua.Client_id = cs.Client_id
              AND cl.bitSAEmail = 1
            ORDER BY cs.strClient_Nm + '' ('' + CONVERT(VARCHAR, cs.Client_id) + '')'''

IF @Debug = 1
BEGIN
    PRINT @Sql
    EXEC (@Sql)
END

--Send the email report
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail', 
                             @recipients='JFleming@NationalResearch.com', 
--                             @recipients='RM@NationalResearch.com', 
                             @blind_copy_recipients = 'MDIQualiSys@NationalResearch.com', 
                             @subject='Unsent Service Alert Emails', 
                             @body = 'Attached is a list of Service Alert Emails that were not sent in todays Nightly Extract.  Please notify clients as appropriate.', 
                             @body_format='HTML', 
                             @importance='High', 
                             @execute_query_database = 'QP_Prod', 
                             @attach_query_result_as_file = 1, 
                             @query_attachment_filename = 'UnsentServiceAlerts.txt', 
                             @Query=@Sql

/*
--Build the body
DECLARE @Body VARCHAR(MAX)
SET @Body = '<html><head><title>Unsent Service Alert Emails</title></head><body><H1>Unsent Service Alert Emails</H1><table border="1"><tr><th>Client</th><th>To</th><th>CC</th><th>Survey Codes</th><th>eComments Login</th></tr>'
SELECT DISTINCT @Body = @Body + '<tr><td>' + cs.strClient_Nm + ' (' + CONVERT(VARCHAR, cs.Client_id) + ')' + '</td>' +
                                '<td>' + REPLACE(ua.strEmailList,' ','') + '</td>' + 
                                '<td>' + us.ad + '@NationalResearch.com' + '</td>' + 
                                '<td>' + cl.strLithoList + '</td>' + 
                                '<td>' + cl.strLoginName + '</td></tr>'
FROM #Users us, DataMart.QP_Comments.dbo.UserAccessWA ua, #ClientUserLithos cl, DataMart.QP_Comments.dbo.ClientStudySurvey cs
WHERE us.ClientUser_id = ua.User_id
  AND us.ClientUser_id = cl.ClientUser_id
  AND ua.Client_id = cs.Client_id
  AND cl.bitSAEmail = 1
ORDER BY cs.strClient_Nm + ' (' + CONVERT(VARCHAR, cs.Client_id) + ')'

IF @Debug = 1
    PRINT @Body
*/

/*
--Send the email report
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail', 
                             @recipients='JFleming@NationalResearch.com', 
--                             @recipients='RM@NationalResearch.com', 
                             @blind_copy_recipients = 'MDIQualiSys@NationalResearch.com', 
                             @subject='Unsent Service Alert Emails', 
                             @body = @Body, 
                             @body_format='HTML', 
                             @importance='High'
*/

/*
DECLARE @Body VARCHAR(MAX)
SET @Body = '<H1>Unsent Service Alert Emails</H1>' +
            '<table border="1">' +
            '<tr><th>Client</th><th>To</th><th>CC</th><th>Survey Codes</th><th>eComments Login</th></tr>' +
            CAST (( SELECT td = cs.strClient_Nm + ' (' + CONVERT(VARCHAR, cs.Client_id) + ')', '', 
                           td = REPLACE(ua.strEmailList,' ',''), '', 
                           td = us.ad + '@NationalResearch.com', '', 
                           td = cl.strLithoList, '', 
                           td = cl.strLoginName, ''
                    FROM #Users us, DataMart.QP_Comments.dbo.UserAccessWA ua, #ClientUserLithos cl, DataMart.QP_Comments.dbo.ClientStudySurvey cs
                    WHERE us.ClientUser_id = ua.User_id
                      AND us.ClientUser_id = cl.ClientUser_id
                      AND ua.Client_id = cs.Client_id
                      AND cl.bitSAEmail = 1
                    ORDER BY cs.strClient_Nm + ' (' + CONVERT(VARCHAR, cs.Client_id) + ')'
            FOR XML PATH('tr'), TYPE) AS VARCHAR(MAX)) +
            '</table>'

--Just in case there are no emails to send
SELECT @Body = ISNULL(@Body, '<H1>Unsent Service Alert Emails</H1><table border="1"><tr><th>Client</th><th>To</th><th>CC</th><th>Survey Codes</th><th>eComments Login</th></tr></table>')

--Send the email report
EXEC msdb.dbo.sp_send_dbmail @profile_name='QualisysEmail', 
                             @recipients='JFleming@NationalResearch.com', 
--                             @recipients='RM@NationalResearch.com', 
                             @blind_copy_recipients = 'MDIQualiSys@NationalResearch.com', 
                             @subject='Unsent Service Alert Emails', 
                             @body = @Body, 
                             @body_format='HTML', 
                             @importance='High'
*/

--Drop the temp tables
DROP TABLE #Users
DROP TABLE #Email
DROP TABLE #ClientUsers
DROP TABLE #ClientUserLitho
DROP TABLE #ClientUserLithos

--Reset the environment
SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED


