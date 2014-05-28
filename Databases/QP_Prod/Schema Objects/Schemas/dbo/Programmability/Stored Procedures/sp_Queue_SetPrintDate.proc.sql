CREATE procedure dbo.sp_Queue_SetPrintDate
@Survey_id int, @strPostalBundle varchar(10), @PaperConfig_id int, @datBundled datetime, @PrintDate datetime = '1/1/1980'
as

declare @r int
exec @r=sp_Queue_CheckPCLOutputLocation 'sp_Queue_SetPrintDate'
if @r=-1 return

if @Survey_id=0 -- GroupedPrint
begin
	UPDATE S 
	set datPrinted=@PrintDate, intReprinted=0
	FROM qp_queue..PCLOutput P, PaperSize Z, SentMailing S, MailingMethodology MM, GroupedPrint GP
	WHERE MM.Survey_id = gp.Survey_id 
	and MM.Methodology_id = S.Methodology_id 
	and S.PaperConfig_id = GP.PaperConfig_id 
	and gp.PaperConfig_id=@PaperConfig_id
	and abs(datediff(second,gp.datPrinted,@PrintDate))<=1
	and P.SentMail_id = S.SentMail_id 
	and P.PaperSize_id = Z.PaperSize_id 
	and S.datPrinted IS NULL

	UPDATE S 
	set datPrinted=@PrintDate, intReprinted=0
	FROM qp_queue..PCLOutput P, PaperSize Z, NPSentMailing S, MailingMethodology MM, GroupedPrint GP
	WHERE MM.Survey_id = gp.Survey_id 
	and MM.Methodology_id = S.Methodology_id 
	and S.PaperConfig_id = GP.PaperConfig_id 
	and gp.PaperConfig_id=@PaperConfig_id
	and abs(datediff(second,gp.datPrinted,@PrintDate))<=1
	and P.SentMail_id = S.SentMail_id 
	and P.PaperSize_id = Z.PaperSize_id 
	and S.datPrinted = '4000'

	--UPDATE GP  -- GroupedPrint gets its PrintDate set before spooling
	--set datPrinted=@PrintDate
	--FROM qp_queue..PCLOutput P, PaperSize Z, SentMailing S, MailingMethodology MM, GroupedPrint GP
	--WHERE MM.Survey_id = gp.Survey_id 
	--and MM.Methodology_id = S.Methodology_id 
	--and S.PaperConfig_id = GP.PaperConfig_id 
	--and gp.PaperConfig_id=@PaperConfig_id
	--and P.SentMail_id = S.SentMail_id 
	--and P.PaperSize_id = Z.PaperSize_id 
	--and S.datPrinted = @PrintDate
end
else
begin
	set @PrintDate = getdate()

	UPDATE S
	set datPrinted=@PrintDate, intReprinted=0
	FROM qp_queue..PCLOutput P, PaperSize Z, SentMailing S, MailingMethodology MM
	WHERE MM.Survey_id = @Survey_id 
	and MM.Methodology_id = S.Methodology_id 
	AND S.strPostalBundle = @strPostalBundle
	and S.PaperConfig_id = @PaperConfig_id 
	and abs(datediff(second,S.datBundled,@datBundled))<=1 
	and P.SentMail_id = S.SentMail_id 
	and P.PaperSize_id = Z.PaperSize_id 
	and S.datPrinted IS NULL

	UPDATE S
	set datPrinted=@PrintDate, intReprinted=0
	FROM qp_queue..PCLOutput P, PaperSize Z, NPSentMailing S, MailingMethodology MM
	WHERE MM.Survey_id = @Survey_id 
	and MM.Methodology_id = S.Methodology_id 
	AND S.strPostalBundle = @strPostalBundle
	and S.PaperConfig_id = @PaperConfig_id 
	and abs(datediff(second,S.datBundled,@datBundled))<=1 
	and P.SentMail_id = S.SentMail_id 
	and P.PaperSize_id = Z.PaperSize_id 
	and S.datPrinted = '4000'
end


