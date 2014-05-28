CREATE NONCLUSTERED INDEX [idx_dl_datLogged] ON [dbo].[DispositionLog]
(
	[datLogged] ASC
)
INCLUDE ( 	[SentMail_id],
	[SamplePop_id],
	[Disposition_id],
	[ReceiptType_id],
	[LoggedBy],
	[DaysFromCurrent],
	[DaysFromFirst]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]


