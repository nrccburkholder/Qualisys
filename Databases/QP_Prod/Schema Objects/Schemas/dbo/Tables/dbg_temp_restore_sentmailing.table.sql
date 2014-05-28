CREATE TABLE [dbo].[dbg_temp_restore_sentmailing](
	[_tbl_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sentmail_id] [int] NOT NULL,
	[scheduledmailing_id] [int] NULL,
	[datgenerated] [datetime] NULL,
	[datprinted] [datetime] NULL,
	[datmailed] [datetime] NULL,
	[methodology_id] [int] NULL,
	[paperconfig_id] [int] NULL,
	[strlithocode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strpostalbundle] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[intpages] [int] NULL,
	[datundeliverable] [datetime] NULL,
	[intresponseshape] [int] NULL,
	[strgroupdest] [varchar](9) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datdeleted] [datetime] NULL,
	[datbundled] [datetime] NULL,
	[intreprinted] [int] NULL,
	[datreprinted] [datetime] NULL,
	[langid] [int] NULL,
	[datexpire] [datetime] NULL,
	[country_id] [int] NOT NULL,
	[bitexported] [bit] NULL
) ON [PRIMARY]


