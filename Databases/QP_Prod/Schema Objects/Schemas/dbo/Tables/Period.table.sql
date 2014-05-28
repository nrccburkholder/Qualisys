CREATE TABLE [dbo].[Period](
	[Period_id] [int] IDENTITY(1,1) NOT NULL,
	[Survey_id] [int] NOT NULL,
	[datPeriodDate] [datetime] NOT NULL,
	[Employee_id] [int] NOT NULL
) ON [PRIMARY]


