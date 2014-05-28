CREATE TABLE [dbo].[dbg_temp_restore_vendorfilecreationqueue](
	[_tbl_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[vendorfile_id] [int] NULL,
	[sampleset_id] [int] NULL,
	[mailingstep_id] [int] NULL,
	[vendorfilestatus_id] [int] NULL,
	[datefilecreated] [datetime] NULL,
	[datedatacreated] [datetime] NULL,
	[archivefilename] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[recordsinfile] [int] NULL,
	[recordsnolitho] [int] NULL,
	[showintree] [bit] NULL,
	[errordesc] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


