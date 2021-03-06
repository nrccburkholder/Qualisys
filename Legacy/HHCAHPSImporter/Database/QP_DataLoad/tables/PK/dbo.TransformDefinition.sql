ALTER TABLE dbo.TransformDefinition ADD CONSTRAINT [PK_TransformDefinition] PRIMARY KEY CLUSTERED
(
		TransformId ASC,
		TransformTargetId ASC
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO