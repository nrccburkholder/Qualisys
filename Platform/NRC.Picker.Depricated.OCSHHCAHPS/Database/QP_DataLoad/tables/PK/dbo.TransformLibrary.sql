ALTER TABLE dbo.TransformLibrary ADD CONSTRAINT [PK_TransformLibrary] PRIMARY KEY CLUSTERED
(
	TransformLibraryId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO