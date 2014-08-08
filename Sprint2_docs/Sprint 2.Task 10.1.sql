/*
Story 10: As an Implementation Associate, I want to be able to indicate the ICH-CAHPS sample unit, so the system knows what data 
to report.
Task 10.1: Alter sample units tables to add new fields with survey types, populate that new field with the bit fields and dropping 
bit fields and populate with calculated bit fields.
*/
use qp_prod

begin tran

select bitHCAHPS,bitHHCAHPS,bitMNCM,isnull(bitACOCAHPS,0) as bitACOCAHPS, count(*) 
from sampleunit
group by bitHCAHPS,bitHHCAHPS,bitMNCM,isnull(bitACOCAHPS,0)
order by 1,2,3,4
go
alter table sampleunit add CAHPSType_id int default (0)
go
-- drop the default value constraint on bitACOCAHPS
alter table SampleUnit 
drop constraint DF__SAMPLEUNI__bitAC__4E498009 
go
-- drop the indexes involving bitHCAHPS
DROP INDEX [IX_SAMPLEUNIT_SUFacility_id_bitHCAHPS] ON [dbo].[SAMPLEUNIT];
DROP INDEX [IX_SAMPLEUNIT_bitHCAHPS_SUFacility_id] ON [dbo].[SAMPLEUNIT];
go
update SampleUnit set CAHPSType_id=0
go
update SampleUnit set CAHPSType_id=2 where bitHCAHPS=1
update SampleUnit set CAHPSType_id=3 where bithHCAHPS=1
update SampleUnit set CAHPSType_id=4 where bitMNCM=1
update SampleUnit set CAHPSType_id=10 where bitACOCAHPS=1
go
alter table sampleunit drop column bitHCAHPS
alter table sampleunit drop column bitHHCAHPS
alter table sampleunit drop column bitMNCM
alter table sampleunit drop column bitACOCAHPS
go
alter table sampleunit add bitHCAHPS	as case when CAHPSType_id=2 then 1 else 0 end
alter table sampleunit add bitHHCAHPS	as case when CAHPSType_id=3 then 1 else 0 end
alter table sampleunit add bitMNCM		as case when CAHPSType_id=4 then 1 else 0 end
alter table sampleunit add bitACOCAHPS	as case when CAHPSType_id=10 then 1 else 0 end
go
-- recreate indexes
go
CREATE NONCLUSTERED INDEX [IX_SAMPLEUNIT_SUFacility_id_bitHCAHPS] ON [dbo].[SAMPLEUNIT] ([SUFacility_id] ASC, [bitHCAHPS] ASC)go
CREATE NONCLUSTERED INDEX [IX_SAMPLEUNIT_bitHCAHPS_SUFacility_id] ON [dbo].[SAMPLEUNIT] ([bitHCAHPS] ASC) INCLUDE ([SUFacility_id])go
select bitHCAHPS,bitHHCAHPS,bitMNCM,bitACOCAHPS, count(*), CAHPSType_id
from sampleunit
group by bitHCAHPS,bitHHCAHPS,bitMNCM,bitACOCAHPS, CAHPSType_id
order by 1,2,3,4
go
exec sp_help sampleunit

commit tran