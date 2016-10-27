CREATE PROCEDURE [QualisysStudy].[BuildEmailBody]
 @StartDate VARCHAR(20),@EndDate VARCHAR(20)

 --DECLARE @EmailBody VARCHAR(2000); EXEC [QualisysStudy].[BuildEmailBody] '2014-01-01', '2014-07-01', @EmailBody OUTPUT; SELECT @EmailBody
AS
 SET NOCOUNT ON
 BEGIN 
 
	DECLARE @EmailBody VARCHAR(200);
	 SET @EmailBody = 'Files for the date range ' 
						+ @StartDate
						+ ' through '
						+ @EndDate
						+ ' are ready to download.  The files are located in the "downloads" folder on your FTP site.';

	SELECT @EmailBody AS EmailBody;
 
END
