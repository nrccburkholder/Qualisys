CREATE PROCEDURE [QualisysStudy].[GetEmailSubscribers]
	@ExtractClientStudyID INT, @RunTypeID INT
	--exec [McKesson].[csp_GetEmailRecipients] 1094
AS
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @Tos NVARCHAR(250),@CCs NVARCHAR(250)

	IF @RunTypeID = 1
	BEGIN
			SET @Tos = 
				(SELECT RTRIM(LTRIM(EmailAddress)) + ';' 
				FROM [QualisysStudy].Subscriber WITH(NOLOCK)
				WHERE ExtractClientStudyID = @ExtractClientStudyID AND RecipientType = 'To' AND IsActive = 1
				ORDER BY EmailAddress
				FOR XML PATH('') ) 	
		
			SET @CCs = 
				(SELECT RTRIM(LTRIM(EmailAddress)) + ';' 
				FROM [QualisysStudy].Subscriber WITH(NOLOCK)
				WHERE ExtractClientStudyID = @ExtractClientStudyID AND RecipientType = 'Cc' AND IsActive = 1
				ORDER BY EmailAddress
				FOR XML PATH('') ) 
	END
	ELSE
	BEGIN
			SET @Tos = 
				(SELECT RTRIM(LTRIM(EmailAddress)) + ';' 
				FROM [QualisysStudy].Subscriber WITH(NOLOCK)
				WHERE ExtractClientStudyID = @ExtractClientStudyID AND RecipientType = 'To' AND IsActive = 1 AND InternalContact = 1
				ORDER BY EmailAddress
				FOR XML PATH('') ) 	
		
			SET @CCs = 
				(SELECT RTRIM(LTRIM(EmailAddress)) + ';' 
				FROM [QualisysStudy].Subscriber WITH(NOLOCK)
				WHERE ExtractClientStudyID = @ExtractClientStudyID AND RecipientType = 'Cc' AND IsActive = 1 AND InternalContact = 1
				ORDER BY EmailAddress
				FOR XML PATH('') ) 
	END


	;WITH cteEmail AS
	(
		SELECT LEFT(@Tos, LEN(@Tos) - 1) AS ToLine,LEFT(@CCs, LEN(@CCs) - 1) AS CCLine
	
	)		

	SELECT (ToLine + ';ITDatabaseAdmins@nationalresearch.ca') AS ToLine ,CCLine 
	FROM cteEmail			
		
END


--exec [QualisysStudy].[GetEmailSubscribers] 2, 2