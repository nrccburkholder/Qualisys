CREATE TABLE [dbo].[SUFacility](
	[SUFacility_id] [int] IDENTITY(1,1) NOT NULL,
	[strFacility_nm] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[City] [varchar](42) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[State] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
	[AHA_id] [int] NULL,
	[MedicareNumber] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_SUF_SUFacilityID] PRIMARY KEY CLUSTERED 
(
	[SUFacility_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


