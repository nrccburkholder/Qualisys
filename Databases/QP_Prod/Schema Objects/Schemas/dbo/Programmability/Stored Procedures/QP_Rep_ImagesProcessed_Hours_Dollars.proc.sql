-- =======================================================================
-- Author:			Hui Holay
-- Create date:	01-22-2007
-- Description:		This procedure is similar to QP_Rep_ImagesProcessed with 2 additional
--						parameters: 
--						@Associate		VARCHAR(50)
--						@StartDate		DATETIME		Start date of dashboard report
--						@EndDate		DATETIME		End date of dashboard report
--						@Hours			INT				# of hours 
--						@Dollars			INT				$ to be allocated.
-- =======================================================================
-- Revision:
-- =======================================================================
CREATE PROCEDURE QP_Rep_ImagesProcessed_Hours_Dollars 
	@Associate VARCHAR(50),  
	@StartDate DATETIME,  
	@EndDate DATETIME,
	@Hours FLOAT,
	@Dollars FLOAT
AS  
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON 

	-- Testing Variables
/*
	DECLARE
	@Associate VARCHAR(50),
 	@StartDate DATETIME,         -- Start date of dashboard report  
 	@EndDate DATETIME,             -- End date of dashboard report  
	@Hours DECIMAL(4,2),
	@Dollars DECIMAL(4,2)

	SET @Associate = 'SHolay'
 	SET @StartDate = '1/1/2007'
 	SET @EndDate = '1/11/2007'
	SET @Hours = 434.29
	SET @Dollars = 6347.65
*/
	
	SELECT Project, PaperSize, COUNT(*) Surveys, SUM(pages) Pages, SUM(images) Images INTO #Results
	FROM
	(SELECT LEFT(sd.strSurvey_nm,4) Project, 
		qf.QuestionForm_id, ps.PaperSize_nm PaperSize, 
		COUNT(*) Pages, 
		CASE WHEN PaperSize_nm='8.5x11' THEN COUNT(*)*2 
			WHEN PaperSize_nm='8.5x14' THEN COUNT(*)*2 
			WHEN PaperSize_nm='11x17' THEN COUNT(*)*4 END Images  
	FROM QuestionForm qf, SentMailing sm, PaperConfig pc, PaperConfigSheet pcs, PaperSize ps, Survey_def sd  
	WHERE qf.SentMail_id=sm.SentMail_id  
	AND sm.PaperConfig_id=pc.PaperConfig_id  
	AND pc.PaperConfig_id=pcs.PaperConfig_id  
	AND pcs.PaperSize_id=ps.PaperSize_id  
	AND qf.Survey_id=sd.Survey_id  
	AND qf.datReturned>@StartDate  
	AND qf.datReturned<DATEADD(DAY,1,@EndDate)  
	GROUP BY LEFT(sd.strSurvey_nm,4), qf.QuestionForm_id, ps.PaperSize_nm) a
	GROUP BY Project, PaperSize
	ORDER BY project, PaperSize  

	DECLARE @TotalSurveys INT, @TotalPages INT, @TotalImages INT

	SELECT 
		@TotalSurveys = SUM(Surveys),
		@TotalPages = SUM(Pages),
		@TotalImages = CASE WHEN SUM(Images) = 0 THEN 1 ELSE SUM(Images) END 
	FROM #Results

	SELECT Project, PaperSize, Surveys, Pages, Images, 
		ROUND(Images/(@TotalImages * 1.0) * 100, 2) AS Percentage,
		ROUND(Images/(@TotalImages * 1.0) * @Hours * 100,2) AS QTY,
		ROUND(Images/(@TotalImages * 1.0) * @Dollars * 100,2) AS Amount
	FROM #Results
	UNION ALL
	SELECT '           ', 'Total       ', @TotalSurveys, @TotalPages, @TotalImages, @TotalImages, @Hours, @Dollars

	DROP TABLE #results  
	  
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SET NOCOUNT OFF
END


