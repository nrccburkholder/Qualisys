create procedure dbo.QP_Rep_HCMGUsageByClient2
@startdate datetime, @enddate datetime
as
exec HCMG.HCMG_dev.dbo.UsageByClient @startdate, @enddate


