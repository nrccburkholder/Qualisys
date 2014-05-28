CREATE TABLE [dbo].[dbg_temp_restore_vendorfiletracking](
	[_tbl_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[vendorfiletracking_id] [int] NOT NULL,
	[member_id] [int] NULL,
	[actiondesc] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[vendorfile_id] [int] NULL,
	[actiondate] [datetime] NULL
) ON [PRIMARY]


