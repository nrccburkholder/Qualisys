-- Created 9/10/2 BD This procedure is used to generate the bundle list for a given survey.
CREATE PROCEDURE SP_Queue_BundleList @PCLOutPut VARCHAR(200), @Survey_id INT, @QueueType CHAR(1)
AS

declare @r int
exec @r=sp_Queue_CheckPCLOutputLocation 'SP_Queue_BundleList', @PCLOutput
if @r=-1 
begin
	SELECT '' as strPaperConfig_nm, 0 as PaperConfig_id, 0 as intPages, 0 as Study_id, 0 as Survey_id, 0
	return
end

--Mail Queue
IF @QueueType = 'M'
BEGIN
	SELECT CASE WHEN isnull(NP.datbundled,'4000')='4000' THEN '(unbundled)' ELSE 
	 CONVERT(VARCHAR,NP.datBundled,120) END + '  ' + PC.strPaperConfig_nm AS strPaperConfig_nm, 
	 PC.PaperConfig_id, PC.intPages, SD.Study_id, SD.Survey_id, SUM(1), sum(case when np.datMailed='4000' then 0 else 1 end) as numMailed,
	 min(np.datMailed) as datmailed 
	 FROM NPSentMailing NP, Survey_Def SD, MailingMethodology MM, PaperConfig PC, QualPro_Params QP 
	 WHERE NP.SentMail_id in (SELECT SentMail_id from qp_queue..pcloutput) 
	 AND NP.Methodology_id = MM.Methodology_id 
	 AND SD.Survey_id = @Survey_id
	 AND SD.Survey_id = MM.Survey_id 
	 AND NP.PaperConfig_id = PC.PaperConfig_id 
	 AND QP.strParam_nm = 'MailedDaysInQ'
	 AND NP.datPrinted <> '1/1/4000' 
	 AND (NP.datMailed = '1/1/4000' or datediff(day,NP.datMailed,getdate()) <= QP.numParam_Value) 
	 GROUP BY NP.datBundled, PC.strPaperConfig_nm, PC.PaperConfig_id, PC.intPages, SD.Study_id, SD.Survey_id 
	 ORDER BY NP.datBundled, PC.strPaperConfig_nm
END

--Print Queue
ELSE IF @QueueType = 'P'
BEGIN
	SELECT CASE WHEN isnull(NP.datbundled,'4000')='4000' THEN '(unbundled)' ELSE 
	 CONVERT(VARCHAR,NP.datBundled,120) END + '  ' + PC.strPaperConfig_nm AS strPaperConfig_nm, 
	 PC.PaperConfig_id, PC.intPages, SD.Study_id, SD.Survey_id, SUM(1), 0 as numMailed, convert(datetime,'4000') as datMailed 
	 FROM NPSentMailing NP, Survey_Def SD, MailingMethodology MM, PaperConfig PC 
	 WHERE NP.SentMail_id in (SELECT SentMail_id from qp_queue..pcloutput) 
	 AND NP.Methodology_id = MM.Methodology_id 
	 AND SD.Survey_id = @Survey_id
	 AND SD.Survey_id = MM.Survey_id 
	 AND NP.PaperConfig_id = PC.PaperConfig_id 
	 AND NP.datPrinted = '1/1/4000'
	 GROUP BY NP.datBundled, PC.strPaperConfig_nm, PC.PaperConfig_id, PC.intPages, SD.Study_id, SD.Survey_id 
	 ORDER BY NP.datBundled, PC.strPaperConfig_nm
END


