CREATE TABLE [dbo].[mb_formgenerror_Hold](
	[FormGenError_id] [int] IDENTITY(1,1) NOT NULL,
	[ScheduledMailing_id] [int] NULL,
	[datGenerated] [datetime] NOT NULL,
	[FGErrorType_id] [int] NOT NULL
) ON [PRIMARY]


