CREATE NONCLUSTERED INDEX [IX_TransferResultLoginActivity_Logout_dt] ON [dbo].[TransferResultLoginActivity]
(
	[Logout_dt] ASC
)
INCLUDE ( 	[UserName],
	[WorkStationName],
	[Login_dt],
	[STRChecked],
	[VSTRChecked]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


