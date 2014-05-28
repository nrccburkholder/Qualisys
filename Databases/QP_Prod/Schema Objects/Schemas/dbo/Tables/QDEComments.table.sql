CREATE TABLE [dbo].[QDEComments](
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
	[bitIgnore] [bit] NOT NULL CONSTRAINT [DF_QDEComments_bitIgnore]  DEFAULT (0),
 CONSTRAINT [PK_QDEComments] PRIMARY KEY CLUSTERED 
(
	[Cmnt_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


