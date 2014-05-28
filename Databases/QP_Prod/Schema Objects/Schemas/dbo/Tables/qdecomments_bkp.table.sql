CREATE TABLE [dbo].[qdecomments_bkp](
	[Cmnt_id] [int] IDENTITY(1,1) NOT NULL,
	[Form_id] [int] NOT NULL,
	[QstnCore] [int] NOT NULL,
	[SampleUnit_id] [int] NOT NULL,
	[strCmntText] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CmntType_id] [int] NULL,
	[CmntValence_id] [int] NULL,
	[datKeyed] [datetime] NULL,
	[strKeyedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datKeyVerified] [datetime] NULL,
	[strKeyVerifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datCoded] [datetime] NULL,
	[strCodedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datCodeVerified] [datetime] NULL,
	[strCodeVerifiedBy] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[bitIgnore] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


