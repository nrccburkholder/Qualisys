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