/*

Sprint 41 User Story 16: OCS HH Process Update Files.
Task 4: Create a table to store records that have been parsed, but not yet transformed.

Brendan Goble

*/

use QP_DataLoad
go

if not exists (select * from sys.tables where name = 'MergeRecord' and schema_id = SCHEMA_ID('dbo'))
begin
	create table dbo.MergeRecord (
		SampleYear int not null,
		SampleMonth int not null,
		CCN varchar(10) not null,
		MatchKey varchar(100) not null,
		RecordXml varchar(max),

		constraint PK_MergeRecord primary key clustered (SampleYear, SampleMonth, CCN, MatchKey)
	);
end
go

if exists (select * from sys.procedures where name = 'UpdateMergeRecords' and schema_id = SCHEMA_ID('dbo'))
	drop procedure dbo.UpdateMergeRecords;
go
create procedure dbo.UpdateMergeRecords
	@SampleYear int,
	@SampleMonth int,
	@CCN varchar(10),
	@Records xml
as
begin
	merge dbo.MergeRecord as target
	using
	(
		select MatchKey, min(RecordXml) as RecordXml
		from
		(
			select T.r.value('./@matchkey', 'varchar(100)') as MatchKey, cast(T.r.query('.') as varchar(max)) as RecordXml
			from @Records.nodes('/rows/r') as T(r)
		) as records
		group by MatchKey
	) as source
	on
		target.SampleYear = @SampleYear
		and target.SampleMonth = @SampleMonth
		and target.CCN = @CCN
		and target.MatchKey = source.MatchKey
	when matched then
		update set RecordXml = source.RecordXml
	when not matched then
		insert (SampleYear, SampleMonth, CCN, MatchKey, RecordXml)
		values (@SampleYear, @SampleMonth, @CCN, source.MatchKey, source.RecordXml);
end
go