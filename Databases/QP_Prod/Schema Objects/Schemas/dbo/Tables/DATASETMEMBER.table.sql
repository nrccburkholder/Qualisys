﻿CREATE TABLE [dbo].[DATASETMEMBER](
	[DATASETMEMBER_ID] [int] IDENTITY(1,1) NOT NULL,
	[DATASET_ID] [int] NOT NULL,
	[POP_ID] [int] NOT NULL,
	[ENC_ID] [int] NULL,
 CONSTRAINT [PK_DATASETMEMBER] PRIMARY KEY CLUSTERED 
(
	[DATASETMEMBER_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]


