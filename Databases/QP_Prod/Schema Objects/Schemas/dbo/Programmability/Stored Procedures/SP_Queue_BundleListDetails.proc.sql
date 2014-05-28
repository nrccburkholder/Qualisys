-- Created 9/10/2 BD This procedure is used to generate the bundle list for a given survey, bundle, and paperconfig.
CREATE PROCEDURE SP_Queue_BundleListDetails @PCLOutPut VARCHAR(200), @Survey_id INT, @datBundled datetime, @PaperConfig INT, @QueueType CHAR(1)
AS

declare @r int
exec @r=sp_Queue_CheckPCLOutputLocation 'SP_Queue_BundleListDetails', @PCLOutput
if @r=-1 
begin
	SELECT ''as strPostalBundle, 0 as Total, 0 as Survey_id, 0 as PaperConfig_id, 0 as intPages, 0, 0, getdate(), getdate()
	return
end

--Mail Queue
IF @QueueType = 'M'
BEGIN

	SELECT NP.strPostalBundle, count(*) as Total, MS.Survey_id, NP.PaperConfig_id, NP.intPages, SUM(1), 
	 CONVERT(INTEGER,SV.bitLetterHead), CONVERT(VARCHAR,NP.datBundled,120), 
	 CASE WHEN NP.datMailed = '4000-01-01' THEN NULL ELSE CONVERT(VARCHAR,NP.datMailed,120) END 
	 FROM NPSentMailing NP, ScheduledMailing SCHM, MailingStep MS, Sel_Cover SV, QualPro_Params QP 
	 WHERE NP.SentMail_id in (SELECT SentMail_id from qp_queue..pcloutput) 
	 AND SV.Survey_id = @Survey_id
	 AND NP.PaperConfig_id = @PaperConfig
	 AND ABS(datediff(SECOND,NP.datBundled,@datBundled)) <= 1 
	 AND NP.SentMail_id = SCHM.SentMail_id 
	 AND SCHM.MailingStep_id = MS.MailingStep_id 
	 AND SV.Survey_id = MS.Survey_id 
	 AND SV.SelCover_id = MS.SelCover_id 
	 AND QP.strParam_nm = 'MailedDaysInQ'
	 AND NP.datPrinted <> '1/1/4000' 
	 AND (NP.datMailed = '1/1/4000' or datediff(day,NP.datMailed,getdate()) <= QP.numParam_Value) 
	 GROUP BY MS.Survey_id, NP.PaperConfig_id, NP.strPostalBundle, NP.intPages, 
	 CONVERT(INTEGER,SV.bitLetterHead), NP.datBundled, NP.datMailed 
	 ORDER by MS.Survey_id, NP.PaperConfig_id, strPostalBundle 
END

--Print Queue
ELSE IF @QueueType = 'P'
BEGIN

	SELECT NP.strPostalBundle, count(*) as Total, MS.Survey_id, NP.PaperConfig_id, NP.intPages, SUM(1), 
	 CONVERT(INTEGER,SV.bitLetterHead), CONVERT(VARCHAR,NP.datBundled,120), 
	 CASE WHEN NP.datMailed = '4000-01-01' THEN NULL ELSE CONVERT(VARCHAR,NP.datMailed,120) END 
	 FROM NPSentMailing NP, ScheduledMailing SCHM, MailingStep MS, Sel_Cover SV 
	 WHERE NP.SentMail_id in (SELECT SentMail_id from qp_queue..pcloutput) 
	 AND SV.Survey_id = @Survey_id
	 AND NP.PaperConfig_id = @PaperConfig
	 AND ABS(datediff(SECOND,NP.datBundled,@datBundled)) <= 1 
	 AND NP.SentMail_id = SCHM.SentMail_id 
	 AND SCHM.MailingStep_id = MS.MailingStep_id 
	 AND SV.Survey_id = MS.Survey_id 
	 AND SV.SelCover_id = MS.SelCover_id 
	 AND NP.datPrinted = '1/1/4000' 
	 GROUP BY MS.Survey_id, NP.PaperConfig_id, NP.strPostalBundle, NP.intPages, 
	 CONVERT(INTEGER,SV.bitLetterHead), NP.datBundled, NP.datMailed 
	 ORDER by MS.Survey_id, NP.PaperConfig_id, strPostalBundle 
END


