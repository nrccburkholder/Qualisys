CREATE TABLE [dbo].[VendorNotes](
	[VendorNote_ID] [int] IDENTITY(1,1) NOT NULL,
	[Vendor_ID] [int] NULL,
	[Employee_ID] [int] NULL,
	[NoteDateTime] [datetime] NULL,
	[Note] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_VendorNotes] PRIMARY KEY CLUSTERED 
(
	[VendorNote_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


