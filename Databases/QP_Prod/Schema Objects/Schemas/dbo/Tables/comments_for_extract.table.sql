CREATE TABLE [dbo].[comments_for_extract](
	[cmnt_id] [int] NULL,
	[questionform_id] [int] NULL,
	[SamplePop_id] [int] NULL,
	[strlithocode] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strcmnttext] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[study_id] [int] NULL,
	[survey_id] [int] NULL,
	[datreported] [datetime] NULL,
	[cmnttype_id] [int] NULL,
	[cmntvalence_id] [int] NULL,
	[qstncore] [int] NULL,
	[strsampleunit_nm] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sampleunit_id] [int] NULL,
	[actualsampleunit_id] [int] NULL,
	[strcmntorhand] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datsamplecreate_dt] [datetime] NULL,
	[datreturned] [datetime] NULL,
	[cutofffield] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[strCmntTextUM] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


