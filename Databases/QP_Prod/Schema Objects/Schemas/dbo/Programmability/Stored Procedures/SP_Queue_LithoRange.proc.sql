--Created 9/10/2002 BD This procedure creates the Litho Range for a given Postal Bundle.
CREATE PROCEDURE SP_Queue_LithoRange @datBundled DATETIME, @Survey_id INT, @PaperConfig INT, @strPostalBundle VARCHAR(20)
AS

DECLARE @strsql VARCHAR(7000)

SET @strsql = 'SELECT MAX(CONVERT(INTEGER,strLithoCode)), MIN(CONVERT(INTEGER,strLithoCode))' + CHAR(10) +
	' FROM NPSentMailing NP, MailingMethodology MM, QualPro_Params QP' + CHAR(10) +
	' WHERE NP.Methodology_id = MM.Methodology_id ' + CHAR(10) +
	' AND MM.Survey_id = ' + CONVERT(VARCHAR,@Survey_id) + CHAR(10) +
	' AND NP.PaperConfig_id = ' + CONVERT(VARCHAR,@PaperConfig) + CHAR(10) +
	' AND ABS(datediff(second,NP.datBundled,''' + CONVERT(VARCHAR,@datBundled,120) + ''')) <= 1 ' + CHAR(10) +
	' AND QP.strParam_nm = ''MailedDaysInQ''' + CHAR(10) +
	' AND (NP.datMailed = ''1/1/4000'' OR datediff(DAY,NP.datMailed,getdate()) <= QP.numParam_Value) ' + CHAR(10) +
	' AND NP.strPostalBundle = ''' + @strPostalBundle + '''' 

EXEC (@strsql)


