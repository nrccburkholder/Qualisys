CREATE TABLE [dbo].[dbg_temp_restore_questionform](
	[_tbl_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[questionform_id] [int] NOT NULL,
	[sentmail_id] [int] NULL,
	[samplepop_id] [int] NULL,
	[cutoff_id] [int] NULL,
	[datreturned] [datetime] NULL,
	[survey_id] [int] NULL,
	[unusedreturn_id] [int] NULL,
	[datunusedreturn] [datetime] NULL,
	[datresultsimported] [datetime] NULL,
	[strstrbatchnumber] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intstrlinenumber] [int] NULL,
	[intphoneattempts] [int] NULL,
	[bitcomplete] [bit] NULL,
	[receipttype_id] [int] NULL,
	[strscanbatch] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bubblecnt] [int] NULL,
	[qstncorecnt] [int] NULL,
	[bitexported] [bit] NULL
) ON [PRIMARY]


