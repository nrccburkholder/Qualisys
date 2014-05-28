CREATE PROCEDURE [dbo].[csp_GetScheduledMailings_OneTime] 
AS
  BEGIN
	SET NOCOUNT ON 
	
	SELECT schm.SamplePop_id, strLithoCode, MailingStep_id, CONVERT(DATETIME,CONVERT(VARCHAR(10),ISNULL(datMailed,datPrinted),120)) datMailed    
	 FROM QP_Prod.dbo.ScheduledMailing schm WITH (NOLOCK)
		INNER JOIN QP_Prod.dbo.SentMailing sm WITH (NOLOCK)  ON schm.SentMail_id=sm.SentMail_id  

	SET NOCOUNT OFF	

  END


