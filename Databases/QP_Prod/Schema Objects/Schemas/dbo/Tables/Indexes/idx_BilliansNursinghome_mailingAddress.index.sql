CREATE NONCLUSTERED INDEX [idx_BilliansNursinghome_mailingAddress] ON [dbo].[Billians_NursingHomes]
(
	[Street Address] ASC,
	[Mail Address] ASC,
	[City] ASC,
	[State] ASC,
	[Street Zip] ASC,
	[Mail Zip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


