create procedure dbo.QP_Rep_HCMGUserListByClient
@startdate datetime, @enddate datetime, @HCMGClient varchar(50)
as
exec HCMG.HCMG_dev.dbo.UserListByClient @startdate, @enddate, @HCMGclient


