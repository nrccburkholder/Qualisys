CREATE TABLE [dbo].[drm_bad_samplepops](
	[SAMPLEPOP_ID] [int] IDENTITY(1,1) NOT NULL,
	[SAMPLESET_ID] [int] NOT NULL,
	[STUDY_ID] [int] NULL,
	[POP_ID] [int] NOT NULL,
	[QPC_TIMESTAMP] [timestamp] NULL,
	[bitBadAddress] [bit] NOT NULL,
	[bitBadPhone] [bit] NOT NULL
) ON [PRIMARY]


