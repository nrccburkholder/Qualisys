CREATE procedure QP_Rep_HCMGDashboardProto
@associate varchar(30), @State varchar(50), @Market varchar(200), @ReportName varchar(200), @MonthDate Datetime, @QuarterDate Datetime, @YearDate Datetime
as
exec vulcan.hcmg_dev.dbo.DashboardProto @state, @market, @reportname, @monthdate, @quarterdate, @yeardate


