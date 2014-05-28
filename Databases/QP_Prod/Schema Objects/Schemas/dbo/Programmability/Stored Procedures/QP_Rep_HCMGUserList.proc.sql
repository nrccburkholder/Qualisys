CREATE procedure dbo.QP_Rep_HCMGUserList
@associate varchar(30)
as
exec HCMG.HCMG_dev.dbo.UserList


