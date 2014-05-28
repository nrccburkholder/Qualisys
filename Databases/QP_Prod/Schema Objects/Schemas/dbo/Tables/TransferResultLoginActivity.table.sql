CREATE TABLE [dbo].[TransferResultLoginActivity](
	[TransferResultLoginActivity_id] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkStationName] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Login_dt] [datetime] NULL,
	[Logout_dt] [datetime] NULL,
	[STRChecked] [bit] NULL,
	[VSTRChecked] [bit] NULL,
 CONSTRAINT [PK_TransferResultLoginActivity] PRIMARY KEY CLUSTERED 
(
	[TransferResultLoginActivity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]


