CREATE TABLE [dbo].[PCLGenPosError](
	[batch_id] [int] NULL,
	[sql_error] [int] NULL,
	[returned_error] [int] NULL,
	[isResolved] [tinyint] NULL CONSTRAINT [DF__PCLGenPos__isRes__097F5470]  DEFAULT (0),
	[datgenerated] [datetime] NULL CONSTRAINT [DF__PCLGenPos__datge__0A7378A9]  DEFAULT (getdate())
) ON [PRIMARY]


