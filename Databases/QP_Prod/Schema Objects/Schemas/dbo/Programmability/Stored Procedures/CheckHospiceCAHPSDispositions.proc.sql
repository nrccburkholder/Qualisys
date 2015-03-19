CREATE PROCEDURE [dbo].[CheckHospiceCAHPSDispositions]
as
-- created 3/1/2015 DBG
-- As a Hospice CAHPS vendor, we need to be able to assign the appropriate final disposition so it can be reported to CMS.
-- For mixed mode methodology, only add bad phone & address if both address and phone are bad. 

create table #EQ (
	[ExtractQueueID] [int] NOT NULL,
	[EntityTypeID] [int] NOT NULL,
	[PKey1] [int] NOT NULL,
	[PKey2] [int] NULL,
	[IsMetaData] [bit] NOT NULL,
	[ExtractFileID] [int] NULL,
	[IsDeleted] [bit] NOT NULL,
	[Created] [datetime] NOT NULL,
	[Source] [nvarchar](50) NOT NULL,
	[bitArchived] bit NOT NULL)

-- list of all ExtractQueue records for bad addr/phone dispositions that haven't been processed
insert into #EQ ([ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source], [bitArchived])
select [ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source], 0
from NRC_DataMart_ETL.dbo.ExtractQueue 
where entitytypeID=14 -- dispositionlog
and pkey2 in (5,14,16,46,47) -- disposition_id
and ExtractFileID is null 

-- remove non-hospice cahps surveys
delete eq
from #EQ eq
inner join dbo.samplepop sp on eq.PKey1=sp.samplepop_id
inner join dbo.sampleset ss on sp.sampleset_id=ss.sampleset_id
inner join dbo.survey_def sd on ss.survey_id=sd.survey_id
inner join dbo.Surveytype st on sd.Surveytype_id=st.Surveytype_id
WHERE st.SurveyType_dsc <> 'Hospice CAHPS'

-- remove non-mixed methodologies 
delete eq
from #EQ eq
inner join dbo.questionform qf on eq.PKey1=qf.samplepop_id
inner join dbo.sentmailing sm on qf.sentmail_id=sm.sentmail_id
inner join dbo.mailingmethodology mm on sm.methodology_id=mm.methodology_id
where mm.StandardMethodologyID<>26 -- Hospice Mixed Mail-Phone

if not exists (select * from #eq)
begin
	drop table #EQ
	return
end

-- if anyone is left in the table, add in any previously processed dispositions
insert into #EQ ([ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source],[bitArchived])
select p.[ExtractQueueID],p.[EntityTypeID],p.[PKey1],p.[PKey2],p.[IsMetaData],p.[ExtractFileID], p.[IsDeleted],p.[Created],p.[Source], 0
from nrc_datamart_etl.dbo.ExtractQueue p
inner join (select distinct pkey1 from #eq) t on p.pkey1=t.pkey1
where p.entitytypeID=14 -- dispositionlog
and p.pkey2 in (5,14,16,46,47) -- disposition_id
and p.ExtractFileID is not null 

insert into #EQ ([ExtractQueueID],[EntityTypeID],[PKey1],[PKey2],[IsMetaData],[ExtractFileID], [IsDeleted],[Created],[Source],[bitArchived])
select p.[ExtractQueueArchiveID],p.[EntityTypeID],p.[PKey1],p.[PKey2],p.[IsMetaData],p.[ExtractFileID], p.[IsDeleted],p.[Created],p.[Source], 1
from nrc_datamart_etl.dbo.ExtractQueueArchive p
inner join (select distinct pkey1 from #eq) t on p.pkey1=t.pkey1
where p.entitytypeID=14 -- dispositionlog
and p.pkey2 in (5,14,16,46,47) -- disposition_id
and p.ExtractFileID is not null 

-- create a list of samplepop_id's with three bit fields: 
	-- have they ever had a bad address disp? 
	-- have they ever had a bad phone disp? 
	-- have they ever had an unused disp? 
select eq.pkey1 as samplepop_id 
	, max(case when eq.pkey2 in (5,46) then 1 else 0 end) as BadAddr
	, max(case when eq.pkey2 in (14,16,47) then 1 else 0 end) as BadPhone
	, max(case when eq.pkey2 in (46,47) then 1 else 0 end) as UnusedDisps
into #Hospice
FROM #EQ eq
group by eq.pkey1

if @@rowcount>0
begin
	-- if there's a bad address, but no bad phone - change the bad addr disposition(s) to "unused bad addr"
	-- remove "bad addr" from ExtractQueue
	update p set ExtractFileID = -1
	from #Hospice h
	inner join #eq t on h.samplepop_id=t.pkey1 
	inner join NRC_Datamart_etl.dbo.ExtractQueue p on t.ExtractQueueID=p.ExtractQueueID
	where h.BadAddr=1 and h.BadPhone=0 
	and t.bitArchived=0
	and t.ExtractFileID is null
	and t.pkey2 in (5)
	
	-- change bad addr to unused bad addr in dispositionlog. a trigger will insert unused bad addr to ExtractQueue
	update dl set disposition_id=46, LoggedBy = left(LoggedBy + ',CheckHospiceCAHPSDispositions',42)
	from #Hospice h
    inner join dbo.dispositionlog dl on h.samplepop_id=dl.samplepop_id
	where h.BadAddr=1 and h.BadPhone=0 and dl.disposition_id in (5)


	-- if there's a bad phone, but no bad addr - change the bad phone disposition(s) to "unused bad phone"
	-- remove "bad phone" from ExtractQueue
	update p set ExtractFileID = -1
	from #Hospice h
	inner join #eq t on h.samplepop_id=t.pkey1 
	inner join NRC_Datamart_etl.dbo.ExtractQueue p on t.ExtractQueueID=p.ExtractQueueID
	where h.BadAddr=0 and h.BadPhone=1 
	and t.bitArchived=0
	and t.ExtractFileID is null
	and t.pkey2 in (14,16)

	-- change bad phone to unused bad phone in dispositionlog. a trigger will insert unused bad phone to ExtractQueue
	update dl set disposition_id=47, LoggedBy = left(LoggedBy + ',CheckHospiceCAHPSDispositions',42)
	from #Hospice h
    inner join dbo.dispositionlog dl on h.samplepop_id=dl.samplepop_id
	where h.BadAddr=0 and h.BadPhone=1 and dl.disposition_id in (14,16)

	
	-- if there's both bad phone and bad addr - change any previously Unused dispositions back to used
	-- remove "unused bad phone" and "unused bad addr" from ExtractQueue
	update p set ExtractFileID = -1
	from #Hospice h
	inner join #eq t on h.samplepop_id=t.pkey1 
	inner join NRC_Datamart_etl.dbo.ExtractQueue p on t.ExtractQueueID=p.ExtractQueueID
	where h.BadAddr=1 and h.BadPhone=1 and h.UnusedDisps=1 
	and t.bitArchived=0
	and t.ExtractFileID is null
	and t.pkey2 in (46,47)
	
	-- change unused bad addr to bad addr and unused bad phone to bad phone in dispositionlog. a trigger will insert the appropriate record to ExtractQueue
	update dl set disposition_id=case when dl.disposition_id=46 then 5 else 14 end
	from #Hospice h
    inner join dbo.dispositionlog dl on h.samplepop_id=dl.samplepop_id
	where h.BadAddr=1 and h.BadPhone=1 and h.UnusedDisps=1 and dl.disposition_id in (46,47)
end
drop table #Hospice
