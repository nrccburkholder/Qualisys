-- =======================================================================
-- Author:			Hui Holay
-- Create date:	01-22-2007
-- Description:		This procedure is similar to QP_Rep_ImagesProcessedTitle with 2 additional
--						parameters: 
--						@Associate		VARCHAR(50)
--						@StartDate		DATETIME		Start date of dashboard report
--						@EndDate		DATETIME		End date of dashboard report
--						@Hours			INT				# of hours 
--						@Dollars			INT				$ to be allocated.
-- =======================================================================
-- Revision:
-- =======================================================================
CREATE PROCEDURE QP_Rep_ImagesProcessedTitleHD 
	@Associate VARCHAR(50),  
	@StartDate DATETIME,  
	@EndDate DATETIME,
	@Hours FLOAT,
	@Dollars FLOAT
AS  
BEGIN
	SELECT CONVERT(VARCHAR(11),@Startdate, 109)+' to '+CONVERT(VARCHAR(11),@Enddate,109) as 'Surveys received from:',
		CONVERT(VARCHAR(20), @Hours) AS '# of Hours', CONVERT(VARCHAR(20), @Dollars) AS '$ to allocate'
END


