create table dbo.MergeRecord (
	SampleYear int not null,
	SampleMonth int not null,
	CCN varchar(10) not null,
	MatchKey nvarchar(100) not null,
	RecordXml nvarchar(max),

	constraint PK_MergeRecord primary key clustered (SampleYear, SampleMonth, CCN, MatchKey)
)
go