CREATE TABLE [dbo].[dbcctableaffinity](
	[Owner] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjId] [int] NULL,
	[IndId] [int] NULL,
	[FileGroup] [int] NULL,
	[IAMField] [int] NULL,
	[IAMPageNo] [int] NULL,
	[ManagedFileId] [int] NULL,
	[ManagedExtStart] [int] NULL,
	[ExtentsInUse] [int] NULL,
	[MixedPagesInUse] [int] NULL,
	[SPID] [int] NULL CONSTRAINT [DF__dbcctablea__SPID__13BB1F1A]  DEFAULT (@@spid)
) ON [PRIMARY]


