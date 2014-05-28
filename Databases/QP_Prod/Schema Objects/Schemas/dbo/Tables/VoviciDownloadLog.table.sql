CREATE TABLE [dbo].[VoviciDownloadLog](
	[VoviciDownload_ID] [int] IDENTITY(1,1) NOT NULL,
	[VoviciSurvey_ID] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[datLastDownload] [datetime] NULL,
 CONSTRAINT [PK_VoviciDownloadLog] PRIMARY KEY CLUSTERED 
(
	[VoviciDownload_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


