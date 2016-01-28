ALTER TABLE dbo.TransformClientMapping ADD CONSTRAINT [PK_TransformClientMapping] PRIMARY KEY CLUSTERED
(
	Client_id asc,
	Study_id asc,
	Survey_id asc,
	TransformMappingId asc
) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO