CREATE TABLE [dbo].[HCAHPSUpdateLog](
	[samplepop_id] [int] NULL,
	[field_name] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[old_value] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[new_value] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Change_Date] [datetime] NULL
) ON [PRIMARY]


