CREATE PROCEDURE [dbo].[QP_REP_HCAHPSMissingDataReportTitle]
	@Associate varchar(50),
	@Client varchar(50),
	@Study varchar(50),
	@Survey varchar(50),
    @encounterStart DATETIME, 
    @encounterEnd DATETIME
AS

Select convert(varchar,@encounterStart,101) + ' - ' + convert(varchar,@encounterEnd,101) as [Selected Date Range]


