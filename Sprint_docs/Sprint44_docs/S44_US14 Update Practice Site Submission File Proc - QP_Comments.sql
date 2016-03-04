/*

Sprint 44 User Story 14: Update Practice Site Submission File Proc.

Brendan Goble

*/

use QP_Comments
go

if exists (select * from sys.procedures where name = 'GetCGCahpsPracticeSiteInfo' and schema_id = SCHEMA_ID('dbo'))
	drop procedure dbo.GetCGCahpsPracticeSiteInfo;
go
/*
Procedure to return practice site information for cgcahps submissions.  Is used in conjunction with proc GetCGCahpsGroupInfo.

01/13/2012	DRM		Initial creation.
*/
CREATE proc [dbo].[GetCGCahpsPracticeSiteInfo] 
	@survey_id int,
	@encounter_begindate datetime,
	@encounter_enddate datetime
as

--test
--declare @survey_id int, @encounter_begindate datetime, @encounter_enddate datetime
--select @survey_id=11577
--select @encounter_begindate = '8/1/2011'
--select @encounter_enddate = '8/31/2011'

declare @FieldPeriodStart datetime
declare @FieldPeriodEnd datetime

if @encounter_enddate > getdate() set @encounter_enddate = dateadd(day,-1,getdate())

--Get MNCM sampleunits for the passed in survey_id.
select sampleunit_id 
into #tmp_sampleunit
from sampleunit 
where survey_id = @survey_id 
and bitmncm = 1

--Get samplesets that were sampled for the units from previous step.
select distinct sampleset_id 
into #tmp_sampleset
from qualisys.qp_prod.dbo.selectedsample 
where sampleunit_id in (select * from #tmp_sampleunit)

--Get rid of samplesets outside of passed in date range
delete t
from #tmp_sampleset t inner join qualisys.qp_prod.dbo.sampleset ss
 on t.sampleset_id = ss.sampleset_id
where ss.datdaterange_fromdate < @encounter_begindate
or ss.datdaterange_todate > @encounter_enddate

--Get count of completes for appropriate samplesets, grouped by sampleunit.
--has to be count of distinct samplepops because phone surveys can have multiple complete dispos logged
select t2.sampleunit_id, count(distinct dl.samplepop_id) as total
into #tmp_completes
from dispositionlog dl inner join qualisys.qp_prod.dbo.samplepop sp
 on dl.samplepop_id = sp.samplepop_id
inner join #tmp_sampleset t
 on sp.sampleset_id = t.sampleset_id
inner join qualisys.qp_prod.dbo.selectedsample ss
 on sp.pop_id = ss.pop_id
 and sp.sampleset_id = ss.sampleset_id
inner join #tmp_sampleunit t2
 on ss.sampleunit_id = t2.sampleunit_id
where dl.disposition_id in (19,20)
and dl.bitevaluated = 1
group by t2.sampleunit_id

--Get count of ineligible returns for appropriate samplesets, grouped by sampleunit.
select t2.sampleunit_id, count(*) as total
into #tmp_inelg
from dispositionlog dl inner join qualisys.qp_prod.dbo.samplepop sp
 on dl.samplepop_id = sp.samplepop_id
inner join #tmp_sampleset t
 on sp.sampleset_id = t.sampleset_id
inner join qualisys.qp_prod.dbo.selectedsample ss
 on sp.pop_id = ss.pop_id
 and sp.sampleset_id = ss.sampleset_id
inner join #tmp_sampleunit t2
 on ss.sampleunit_id = t2.sampleunit_id
where dl.disposition_id in (3,23)
and dl.bitevaluated = 1
group by t2.sampleunit_id


--Get response rate data by sampleunit_id for the appropriate samplesets.
select t2.sampleunit_id, sum(intsampled) as intSampled, min(isnull(t3.total,0)) as Completes, min(isnull(t4.total,0)) as Ineligibles --, sum(intReturned) as intReturned
into #tmp_data
from respratecount rrc inner join #tmp_sampleset t1
 on rrc.sampleset_id = t1.sampleset_id
inner join #tmp_sampleunit t2
 on rrc.sampleunit_id = t2.sampleunit_id
left join #tmp_completes t3
 on rrc.sampleunit_id = t3.sampleunit_id
left join #tmp_inelg t4
 on rrc.sampleunit_id = t4.sampleunit_id 
group by t2.sampleunit_id


--Get earliest mail date and latest expiration date for out list of samplesets.
select @FieldPeriodStart = min(sm.datmailed),
	@FieldPeriodEnd = max(sm.datexpire)
from #tmp_sampleset t inner join qualisys.qp_prod.dbo.samplepop sp
 on t.sampleset_id = sp.sampleset_id
inner join qualisys.qp_prod.dbo.scheduledmailing schm
 on sp.samplepop_id = schm.samplepop_id
inner join qualisys.qp_prod.dbo.sentmailing sm
 on schm.sentmail_id = sm.sentmail_id
 
  --some surveys may not yet be expired. 
 --set field end date to yesterday to represent the last day of returns that is included.
 if @FieldPeriodEnd > getdate() set @FieldPeriodEnd = dateadd(day,-1,getdate())

--select @FieldPeriodStart, @FieldPeriodEnd

select
	right(space(10) + isnull(ps.AssignedID,0), 10)+										--Practice Site ID
	right(space(10) + isnull(sg.AssignedID,0), 10)+										--GroupID
	right(space(50) + rtrim(ltrim(isnull(ps.practicename,''))), 50)+					--PracticeName
	right(space(30) + rtrim(ltrim(isnull(ps.addr1,''))), 30)+							--Street Address 1
	right(space(30) + rtrim(ltrim(isnull(ps.addr2,''))), 30)+							--Street Address 2
	right(space(30) + rtrim(ltrim(isnull(ps.city,''))), 30)+							--City
	right(space(2) + rtrim(ltrim(isnull(ps.st,''))), 2)+								--State
	right(space(5) + rtrim(ltrim(isnull(ps.Zip5,''))), 5)+								--Zip Code
    right('00' + isnull(ps.practiceownership,'  '), 2)+									--Practice Ownership and Affiliation  
	right(space(5) + rtrim(ltrim(isnull(ps.patvisitsweek,0))), 5)+						--Patient Visits Per Week
	right(space(2) + rtrim(ltrim(isnull(ps.provworkweek,0))), 2)+						--Providers Working Each Week
	cast(ps.Sampling as varchar)+														--Sampling
	right(space(7) + cast(isnull(t.intSampled,0) as varchar), 7)+						--Sample Size
	right(space(8) + replace(convert(varchar,isnull(@FieldPeriodStart,''),110),'-',''), 8)+											--Field Period Start
	right(space(8) + replace(convert(varchar,isnull(@FieldPeriodEnd,''),110),'-',''), 8)+											--Field Period End
	right(space(8) + cast(cast(cast(completes as float)/cast(intSampled-ineligibles as float) as decimal(8,6)) as varchar), 8)+		--Response Rate
	right(space(30) + rtrim(ltrim(isnull(ps.practicecontactname,''))), 30)+				--Practice Contact Name
	right(space(10) + rtrim(ltrim(isnull(ps.practicecontactphone,''))), 10)+			--Practice Contact Phone
	right(space(30) + rtrim(ltrim(isnull(ps.practicecontactemail,''))), 50)				--Practice Contact Email
from
	Qualisys.QP_Prod.dbo.PracticeSite ps
	inner join Qualisys.QP_Prod.dbo.SiteGroup sg on sg.SiteGroup_ID = ps.SiteGroup_ID
	inner join #tmp_data t on ps.SampleUnit_id = t.sampleunit_id
go