CREATE PROCEDURE [QualisysStudy].[GetEmailSubscribersByClientID]
	@ExtractClientStudyID INT
AS
BEGIN
	
	SET NOCOUNT ON
	
	DECLARE @Tos NVARCHAR(250),@CCs NVARCHAR(250)

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
			
	
	IF @Tos = ''
	BEGIN
		SELECT NULL AS ToLine,NULL AS CCLine
	END
				
	SELECT LEFT(@Tos, LEN(@Tos) - 1) AS ToLine,LEFT(@CCs, LEN(@CCs) - 1) AS CCLine
		
END
