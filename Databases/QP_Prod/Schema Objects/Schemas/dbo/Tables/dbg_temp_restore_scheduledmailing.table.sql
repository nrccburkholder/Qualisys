CREATE TABLE [dbo].[dbg_temp_restore_scheduledmailing](
	[_tbl_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[scheduledmailing_id] [int] NOT NULL,
	[mailingstep_id] [int] NULL,
	[samplepop_id] [int] NULL,
	[overrideitem_id] [int] NULL,
	[sentmail_id] [int] NULL,
	[methodology_id] [int] NULL,
	[datgenerate] [datetime] NOT NULL
) ON [PRIMARY]


