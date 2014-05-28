CREATE TABLE [dbo].[jc_RefreshLog](
	[RefreshLog_id] [int] IDENTITY(540,1) NOT NULL,
	[datRefreshStart] [datetime] NULL,
	[datRefreshEnd] [datetime] NULL,
	[Report_nm] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]


