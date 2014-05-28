create procedure dbo.QP_Rep_HCMGUsageByClientUser2
@startdate datetime, @enddate datetime
as
exec HCMG.HCMG_dev.dbo.UsageByClientUser @startdate, @enddate


