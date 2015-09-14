/*

S31.US25.T2 25	backpopulate CGCAHPS group and site tool

As the compliance team I want a way to manage CGCAHPS groups and sites	 	2	25.1	modify the facility dropdown in the sample plan interface to make sites available
					25.2	backpopulate all the new tables (sample unit group to client mapping and sample unit to site mapping)

Chris Burkholder 

INSERT INTO SiteGroup
INSERT INTO PracticeSite

*/

use [qp_prod]
go

begin tran

--select * from sitegroup
delete from SiteGroup
set identity_insert SiteGroup on

insert into SiteGroup (Addr1, Addr2, AssignedID, bitActive, City, GroupContactEmail, GroupContactName, GroupContactPhone,
	GroupName, GroupOwnership, MasterGroupID, MasterGroupName, Phone, SiteGroup_ID, ST, Zip5)
select Addr1, Addr2, CGGroupID, 1, City, GroupContactEmail, GroupContactName, GroupContactPhone,
	GroupName, GroupOwnership, MasterGroupID, MasterGroupName, Phone, CGCAHPSGroup_ID, ST, Zip5 from [datamart].[qp_comments].[dbo].[cgcahpsgroup]

set identity_insert SiteGroup off
go

--select * from practicesite
delete from PracticeSite
set identity_insert PracticeSite on

insert into PracticeSite (Addr1, Addr2, AssignedID, bitActive, PatVisitsWeek, PracticeContactEmail, PracticeContactName,
	PracticeContactPhone, PracticeName, PracticeOwnership, PracticeSite_ID, SampleUnit_id, SiteGroup_ID, ST, Zip5)
select ps.Addr1, ps.Addr2, ps.CGGroupID, bitActive, PatVisitsWeek, PracticeContactEmail, PracticeContactName,
	PracticeContactPhone, PracticeName, PracticeOwnership, CGCAHPSPracticeSite_ID, SampleUnit_id, CGCAHPSGroup_ID, ps.ST, ps.Zip5 
	from [datamart].[qp_comments].[dbo].[cgcahpspracticesite] ps
	inner join [datamart].[qp_comments].[dbo].[cgcahpsgroup] sg on sg.CGgroupid = ps.CGgroupid

set identity_insert PracticeSite off
go

--delete from cgcahpsgroup where cgcahpsgroup_id = 93

--rollback tran

commit tran