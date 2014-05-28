CREATE TABLE [dbo].[SMUndeliverable_Extract](
	[SMUExtract_id] [int] IDENTITY(1,1) NOT NULL,
	[Study_id] [int] NULL,
	[Samplepop_id] [int] NULL,
	[Sentmail_id] [int] NULL,
	[datUndeliverable] [datetime] NULL,
	[datReturned] [datetime] NULL,
PRIMARY KEY NONCLUSTERED 
(
	[SMUExtract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


