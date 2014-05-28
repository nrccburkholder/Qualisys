CREATE TABLE [dbo].[dbg_temp_restore_vendorfile_freqs](
	[_tbl_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[vendorfile_freqs_id] [int] NOT NULL,
	[vendorfile_id] [int] NOT NULL,
	[field_id] [int] NULL,
	[strfield_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strvalue] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[occurrences] [int] NULL
) ON [PRIMARY]


