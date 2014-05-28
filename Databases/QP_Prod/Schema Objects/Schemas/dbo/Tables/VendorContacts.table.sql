CREATE TABLE [dbo].[VendorContacts](
	[VendorContact_ID] [int] IDENTITY(1,1) NOT NULL,
	[VendorID] [int] NULL,
	[Type] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FirstName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[emailAddr1] [varchar](150) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[emailAddr2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SendFileArrivalEmail] [bit] NULL CONSTRAINT [DF_VendorContacts_SendFileArrivalEmail]  DEFAULT (0),
	[Phone1] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone2] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Notes] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorContacts] PRIMARY KEY CLUSTERED 
(
	[VendorContact_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


