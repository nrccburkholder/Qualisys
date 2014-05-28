/****** Object:  Stored Procedure dbo.sp_GetReportManager_Fields    Script Date: 6/9/99 4:36:35 PM ******/
/****** Object:  Stored Procedure dbo.sp_GetReportManager_Fields    Script Date: 3/12/99 4:16:08 PM ******/
/****** Object:  Stored Procedure dbo.sp_GetReportManager_Fields    Script Date: 12/7/98 2:34:54 PM ******/
CREATE PROCEDURE sp_GetReportManager_Fields
AS
SELECT * FROM ReportManager_Reports ORDER BY ReportName


