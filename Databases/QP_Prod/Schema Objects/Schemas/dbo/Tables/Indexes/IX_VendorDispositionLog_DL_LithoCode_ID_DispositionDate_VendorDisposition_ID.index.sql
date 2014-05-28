CREATE NONCLUSTERED INDEX [IX_VendorDispositionLog_DL_LithoCode_ID_DispositionDate_VendorDisposition_ID] ON [dbo].[VendorDispositionLog]
(
	[DL_LithoCode_ID] ASC,
	[DispositionDate] ASC,
	[VendorDisposition_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


