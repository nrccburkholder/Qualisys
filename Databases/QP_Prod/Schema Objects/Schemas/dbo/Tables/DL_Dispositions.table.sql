CREATE TABLE [dbo].[DL_Dispositions](
	[DL_Disposition_ID] [int] IDENTITY(1,1) NOT NULL,
	[DL_LithoCode_ID] [int] NULL,
	[DL_Error_ID] [int] NULL,
	[DispositionDate] [datetime] NULL,
	[VendorDispositionCode] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsFinal] [bit] NULL,
 CONSTRAINT [PK_DL_Dispositions] PRIMARY KEY CLUSTERED 
(
	[DL_Disposition_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


