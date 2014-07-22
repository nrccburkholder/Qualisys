CREATE TABLE [dbo].[SENTMAILING](
	[SENTMAIL_ID] [int] IDENTITY(1,1) NOT NULL,
	[SCHEDULEDMAILING_ID] [int] NULL,
	[DATGENERATED] [datetime] NULL,
	[DATPRINTED] [datetime] NULL,
	[DATMAILED] [datetime] NULL,
	[METHODOLOGY_ID] [int] NULL,
	[PAPERCONFIG_ID] [int] NULL,
	[STRLITHOCODE] [varchar](10) NULL,
	[STRPOSTALBUNDLE] [varchar](10) NULL,
	[INTPAGES] [int] NULL,
	[DATUNDELIVERABLE] [datetime] NULL,
	[INTRESPONSESHAPE] [int] NULL,
	[STRGROUPDEST] [varchar](9) NULL,
	[datDeleted] [datetime] NULL,
	[datBundled] [datetime] NULL,
	[intReprinted] [int] NULL,
	[datReprinted] [datetime] NULL,
	[LangID] [int] NULL,
	[datExpire] [datetime] NULL,
	[Country_id] [int] NOT NULL,
	[bitExported] [bit] NULL,
	[QuestionnaireType_ID] [int] NULL,
 CONSTRAINT [PK_SENTMAILING] PRIMARY KEY CLUSTERED 
(
	[SENTMAIL_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


