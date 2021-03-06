﻿CREATE TABLE [dbo].[SAMPLEPOP](
	[SAMPLEPOP_ID] [int] IDENTITY(1,1) NOT NULL,
	[SAMPLESET_ID] [int] NOT NULL,
	[STUDY_ID] [int] NULL,
	[POP_ID] [int] NOT NULL,
	[QPC_TIMESTAMP] [timestamp] NULL,
	[bitBadAddress] [bit] NOT NULL CONSTRAINT [DF__SAMPLEPOP__bitBa__26DB7884]  DEFAULT (0),
	[bitBadPhone] [bit] NOT NULL CONSTRAINT [DF__SAMPLEPOP__bitBa__27CF9CBD]  DEFAULT (0),
 CONSTRAINT [PK_SAMPLEPOP] PRIMARY KEY CLUSTERED 
(
	[SAMPLEPOP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


