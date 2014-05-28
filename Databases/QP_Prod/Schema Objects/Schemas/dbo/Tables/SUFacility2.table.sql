CREATE TABLE [dbo].[SUFacility2](
	[SUFacility_id] [int] IDENTITY(1,1) NOT NULL,
	[Client_id] [int] NOT NULL,
	[strFacility_nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Region_id] [int] NULL,
	[AdmitNumber] [int] NULL,
	[BedSize] [int] NULL,
	[bitPeds] [bit] NULL,
	[bitTeaching] [bit] NULL,
	[bitTrauma] [bit] NULL,
	[bitReligious] [bit] NULL,
	[bitGovernment] [bit] NULL,
	[bitRural] [bit] NULL,
	[bitForProfit] [bit] NULL,
	[bitRehab] [bit] NULL,
	[bitCancerCenter] [bit] NULL,
	[bitPicker] [bit] NULL,
	[bitFreeStanding] [bit] NULL,
	[AHA_id] [int] NULL
) ON [PRIMARY]


