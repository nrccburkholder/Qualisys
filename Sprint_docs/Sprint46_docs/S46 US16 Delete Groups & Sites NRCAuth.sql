/*
S46 US16 Delete Groups & Sites NRCAuth.sql

As the Compliance PM, I would like to be able to delete CG-CAHPS groups & sites via the interface, 
so that we can remove incorrect entries

Limited by NRCAuth permission

Chris Burkholder

Task 1 - Create permission in NRC Auth (do in interface & create script)
*/

Use [NRCAuth]
go

begin tran

if not exists(select * from Privilege where strPrivilege_nm = 'Delete Sites And Groups')
Insert into Privilege (Application_id,strPrivilege_nm,strPrivilege_dsc,Author,datOccurred,PrivilegeLevel_id)
select a.Application_id,'Delete Sites And Groups','Allows access to the Delete button on the grid for Sites and Groups',150002,GetDate(),1
from Application a
where a.strApplication_nm = 'Configuration Manager'

declare @NewDeletePrivilegeId int
select @NewDeletePrivilegeId = Privilege_id from Privilege where strPrivilege_nm = 'Delete Sites And Groups'

if not exists(select * from OrgUnitPrivilege where privilege_id = @NewDeletePrivilegeId)
insert into OrgUnitPrivilege
(OrgUnit_id,	Privilege_id,	datGranted,	datRevoked,	Author,	datOccurred)
select OrgUnit_id,@NewDeletePrivilegeId,GetDate(),NULL,150002,GetDate()
from orgunit where strOrgUnit_nm in ('NRCIS','NRC General')

declare @NewDeleteOrgUnitPrivId int
select @NewDeleteOrgUnitPrivId = min(OrgUnitPrivilege_id) from OrgUnitPrivilege where Privilege_id = @NewDeletePrivilegeId

insert into memberprivilege
(Member_id,OrgUnitPrivilege_id,Author,datOccurred,datGranted,datRevoked)
select Member_id, @NewDeleteOrgUnitPrivId, 150002, GetDate(), GetDate(), null 
from member where strMember_nm in ('JWilley','RBeavers','SFryda','JTobey','CBurkholder','TButler','VRuenprom')

select m.strMember_nm, mp.MemberPrivilege_id, p.strPrivilege_nm from memberprivilege mp
inner join member m on m.member_id = mp.member_id
inner join OrgUnitPrivilege oup on mp.OrgUnitPrivilege_id = oup.OrgUnitPrivilege_id
inner join Privilege p on p.Privilege_id = oup.Privilege_id
where p.strPrivilege_nm = 'Delete Sites And Groups'
or p.strPrivilege_nm = 'Copy Data Structure'

--rollback tran

commit tran