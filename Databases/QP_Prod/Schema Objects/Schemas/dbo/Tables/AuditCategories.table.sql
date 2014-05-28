CREATE TABLE [dbo].[AuditCategories](
	[auditcategory_id] [int] NOT NULL,
	[auditcategory_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[auditcategory_desc] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY NONCLUSTERED 
(
	[auditcategory_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


