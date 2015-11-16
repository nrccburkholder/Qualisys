/*

S38.US1.T2 backpopulate CGCAHPS group and site tool.sql

Task 2 - Move CGCHAPS sites and groups from datamart tables into stage for Rachel and 
	flip the QualPro param to turn this on See note on this task..

From Rachel, " I know as a part of this release, any current facility assignments to 
CG CAHPS sample units will be wiped out in order to be associated with the new sites. 
My email is two-fold. One, I understand this this release will need to be put into a 
user story in order to plan the release. Second, is it possible to make a copy of the 
existing facility table prior to the release to have as a backup just in case something 
would happen down the line and we would need this information?"

Chris Burkholder 

INSERT INTO SiteGroup
INSERT INTO PracticeSite

CREATE TABLE CGCAHPS2015FacilityAssignmentsReplaced
INSERT INTO CGCAHPS2015FacilityAssignmentsReplaced

UPDATE SampleUnit

INSERT INTO ClientPracticeSiteGroupLookup

UPDATE QualPro_Params

*/

use [qp_prod]
go

--CGCAHPSGROUP_ID 93 causes a duplicate which must be eliminated as follows, outside the transaction:
/*
select IsNull(ps.Addr1, ''), IsNull(ps.Addr2, ''), ps.CGGroupID, bitActive, IsNull(ps.City, ''), PatVisitsWeek, IsNull(ps.Phone, ''), IsNull(PracticeContactEmail, ''), IsNull(PracticeContactName, ''),
	IsNull(PracticeContactPhone, ''), IsNull(PracticeName, ''), IsNull(PracticeOwnership, ''), CGCAHPSPracticeSite_ID, SampleUnit_id, CGCAHPSGroup_ID, IsNull(ps.ST, ''), IsNull(ps.Zip5, '')
	from [datamart].[qp_comments].[dbo].[cgcahpspracticesite] ps
	inner join [datamart].[qp_comments].[dbo].[cgcahpsgroup] sg on sg.CGgroupid = ps.CGgroupid
	where CGCAHPSPracticeSite_ID = 747
*/

delete from [datamart].[qp_comments].[dbo].[cgcahpsgroup] where cgcahpsgroup_id = 93 

begin tran

--select * from sitegroup
delete from SiteGroup
set identity_insert SiteGroup on

insert into SiteGroup (Addr1, Addr2, AssignedID, bitActive, City, GroupContactEmail, GroupContactName, GroupContactPhone,
	GroupName, GroupOwnership, MasterGroupID, MasterGroupName, Phone, SiteGroup_ID, ST, Zip5)
select IsNull(Addr1, ''), IsNull(Addr2, ''), CGGroupID, 1, IsNull(City, ''), IsNull(GroupContactEmail, ''), IsNull(GroupContactName, ''), IsNull(GroupContactPhone, ''),
	IsNull(GroupName, ''), IsNull(GroupOwnership, ''), IsNull(MasterGroupID, ''), IsNull(MasterGroupName, ''), IsNull(Phone, ''), IsNull(CGCAHPSGroup_ID, ''), IsNull(ST, ''), IsNull(Zip5, '') from [datamart].[qp_comments].[dbo].[cgcahpsgroup]

set identity_insert SiteGroup off
go

--select * from practicesite
delete from PracticeSite
set identity_insert PracticeSite on

insert into PracticeSite (Addr1, Addr2, AssignedID, bitActive, City, PatVisitsWeek, Phone, PracticeContactEmail, PracticeContactName,
	PracticeContactPhone, PracticeName, PracticeOwnership, PracticeSite_ID, SampleUnit_id, SiteGroup_ID, ST, Zip5)
select IsNull(ps.Addr1, ''), IsNull(ps.Addr2, ''), ps.CGGroupID, bitActive, IsNull(ps.City, ''), PatVisitsWeek, IsNull(ps.Phone, ''), IsNull(PracticeContactEmail, ''), IsNull(PracticeContactName, ''),
	IsNull(PracticeContactPhone, ''), IsNull(PracticeName, ''), IsNull(PracticeOwnership, ''), CGCAHPSPracticeSite_ID, SampleUnit_id, CGCAHPSGroup_ID, IsNull(ps.ST, ''), IsNull(ps.Zip5, '')
	from [datamart].[qp_comments].[dbo].[cgcahpspracticesite] ps
	inner join [datamart].[qp_comments].[dbo].[cgcahpsgroup] sg on sg.CGgroupid = ps.CGgroupid

set identity_insert PracticeSite off
go

/****** Object:  Table [dbo].[CGCAHPS2015FacilityAssignmentsReplaced]    Script Date: 11/16/2015 2:44:53 PM ******/

IF (EXISTS (SELECT * 
                 FROM INFORMATION_SCHEMA.TABLES 
                 WHERE TABLE_SCHEMA = 'dbo' 
                 AND  TABLE_NAME = 'CGCAHPS2015FacilityAssignmentsReplaced'))
DROP TABLE [dbo].[CGCAHPS2015FacilityAssignmentsReplaced]
GO

CREATE TABLE CGCAHPS2015FacilityAssignmentsReplaced
(
 strclient_nm  varchar(40),
 client_id int,
 strstudy_nm char(10),
 study_id int,
 strsurvey_nm char(10),
 survey_id int,
 strsampleunit_nm varchar(42),
 sampleunit_id int,
 SUFacility_id int,
 strfacility_nm varchar(100)
)

GO

insert into CGCAHPS2015FacilityAssignmentsReplaced
select distinct cssv.strclient_nm, cssv.client_id, cssv.strstudy_nm, cssv.study_id, sd.STRSURVEY_NM, ss.survey_id, su.STRSAMPLEUNIT_NM, su.sampleunit_id, su.SUFacility_id, suf.strFacility_nm
from sampleunit su 
inner join sampleset ss on su.SAMPLEPLAN_ID = ss.SAMPLEPLAN_ID
inner join survey_def sd on sd.survey_id = ss.survey_id
inner join surveytype st on st.surveytype_id = sd.surveytype_id
inner join clientstudysurvey_view cssv on cssv.survey_id = ss.survey_id
inner join sufacility suf on suf.SUFacility_id = su.SUFacility_id
where st.SurveyType_dsc = 'CGCAHPS'
order by strclient_nm, strstudy_nm, strsurvey_nm

GO

--select count(*) from CGCAHPS2015FacilityAssignmentsReplaced
--select * from CGCAHPS2015FacilityAssignmentsReplaced


/**********************************************************
Now zero out sufacility_id assignments and then make assignments from PracticeSite table
**********************************************************/

--select sufacility_id, count(sufacility_id) from sampleunit group by sufacility_id

update sampleunit set sufacility_id = 0
--select distinct su.SampleUnit_id, su.StrSampleUnit_nm, ps.PracticeSite_id, ps.PracticeName
from sampleunit su 
left join practicesite ps on su.sampleunit_id = ps.SampleUnit_id
inner join sampleset ss on su.SAMPLEPLAN_ID = ss.SAMPLEPLAN_ID
inner join survey_def sd on sd.survey_id = ss.survey_id
inner join surveytype st on st.surveytype_id = sd.surveytype_id
where st.SurveyType_dsc = 'CGCAHPS'
--and practicesite_id is null 
GO

update sampleunit set sufacility_id = practicesite_id
--select distinct su.SampleUnit_id, su.StrSampleUnit_nm, ps.PracticeSite_id, ps.PracticeName
from sampleunit su 
inner join practicesite ps on su.sampleunit_id = ps.SampleUnit_id
inner join sampleset ss on su.SAMPLEPLAN_ID = ss.SAMPLEPLAN_ID
inner join survey_def sd on sd.survey_id = ss.survey_id
inner join surveytype st on st.surveytype_id = sd.surveytype_id
where st.SurveyType_dsc = 'CGCAHPS'
GO

/**********************************************************
Now include Client Practice Site join for UI to show assigned site as connected
**********************************************************/

insert into ClientPracticeSiteGroupLookup
select distinct client_id, ps.sitegroup_id from
sitegroup sg inner join practicesite ps on sg.SiteGroup_ID = ps.SiteGroup_ID 
inner join sampleunit su on ps.PracticeSite_ID = su.SUFacility_id 
inner join sampleset ss on su.SAMPLEPLAN_ID = ss.SAMPLEPLAN_ID
inner join survey_def sd on ss.survey_id = sd.SURVEY_ID
inner join study s on s.STUDY_ID = sd.STUDY_ID

/**********************************************************
Now set QualPro_params to allow Practice Site hookup to CGCAHPS Sample Units
**********************************************************/

update Qualpro_params set strparam_value = 1
--select * from QualPro_Params
where strparam_nm = 'SurveyRule: FacilitiesArePracticeSites - CGCAHPS'

--rollback tran

commit tran