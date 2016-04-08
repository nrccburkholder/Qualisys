/*
S46 US16 Delete Groups & Sites NRCAuth - Rollback.sql

As the Compliance PM, I would like to be able to delete CG-CAHPS groups & sites via the interface, 
so that we can remove incorrect entries

Limited by NRCAuth permission

Chris Burkholder

Task 1 - Create permission in NRC Auth (do in interface & create script)
*/

Use [NRCAuth]
go

select m.strMember_nm, mp.MemberPrivilege_id, p.strPrivilege_nm from memberprivilege mp
inner join member m on m.member_id = mp.member_id
inner join OrgUnitPrivilege oup on mp.OrgUnitPrivilege_id = oup.OrgUnitPrivilege_id
inner join Privilege p on p.Privilege_id = oup.Privilege_id
where p.strPrivilege_nm = 'Delete Sites And Groups'

begin tran

declare @NewDeletePrivilegeId int
select @NewDeletePrivilegeId = Privilege_id from Privilege where strPrivilege_nm = 'Delete Sites And Groups'

declare @NewDeleteOrgUnitPrivId int
select @NewDeleteOrgUnitPrivId = min(OrgUnitPrivilege_id) from OrgUnitPrivilege where Privilege_id = @NewDeletePrivilegeId

delete from memberprivilege where OrgUnitPrivilege_id = @NewDeleteOrgUnitPrivId

delete from OrgUnitPrivilege where privilege_id = @NewDeletePrivilegeId

delete from Privilege where strPrivilege_nm = 'Delete Sites And Groups'

--rollback tran

commit tran