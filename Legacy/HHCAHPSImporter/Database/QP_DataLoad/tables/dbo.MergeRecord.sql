create table dbo.MergeRecord (
	SampleYear int not null,
	SampleMonth int not null,
	CCN varchar(10) not null,
	MatchKey varchar(100) not null,
	RecordXml varchar(max),

	constraint PK_MergeRecord primary key clustered (SampleYear, SampleMonth, CCN, MatchKey)
)
go