create procedure dbo.QP_Rep_HCMGUserListByClient2
@startdate datetime, @enddate datetime, @HCMGClient varchar(50)
as
set @hcmgclient='%'+@HCMGclient+'%'
exec HCMG.HCMG_dev.dbo.UserListByClient @startdate, @enddate, @HCMGclient


