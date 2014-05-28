CREATE NONCLUSTERED INDEX [IX_TransferResultLoginActivity_UserName] ON [dbo].[TransferResultLoginActivity]
(
	[UserName] ASC,
	[WorkStationName] ASC
)
INCLUDE ( 	[TransferResultLoginActivity_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


