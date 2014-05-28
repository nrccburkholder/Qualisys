﻿CREATE TABLE [dbo].[StandardMethodology](
	[StandardMethodologyID] [int] IDENTITY(1,1) NOT NULL,
	[strStandardMethodology_nm] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[bitCustom] [bit] NULL,
	[MethodologyType] [varchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_StandardMethodology] PRIMARY KEY CLUSTERED 
(
	[StandardMethodologyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


