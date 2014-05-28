CREATE TABLE [dbo].[dbg_temp_restore_vendorfile_messages](
	[_tbl_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[vendorfile_message_id] [int] NOT NULL,
	[vendorfile_id] [int] NULL,
	[vendorfile_messagetype_id] [int] NULL,
	[message] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


