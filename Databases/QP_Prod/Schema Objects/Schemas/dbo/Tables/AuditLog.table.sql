CREATE TABLE [dbo].[AuditLog](
	[auditlog_id] [int] IDENTITY(1,1) NOT NULL,
	[employee_id] [int] NOT NULL,
	[study_id] [int] NOT NULL,
	[survey_id] [int] NULL,
	[datChanged] [datetime] NOT NULL DEFAULT (getdate()),
	[auditcategory_id] [int] NOT NULL,
	[audittype_id] [int] NOT NULL,
	[module_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[field_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[previous_value] [varchar](2550) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[new_value] [varchar](2550) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_update_timestamp] [timestamp] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[auditlog_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


