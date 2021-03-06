﻿CREATE TABLE [dbo].[drm_study_INC0028463](
	[STUDY_ID] [int] IDENTITY(1,1) NOT NULL,
	[CLIENT_ID] [int] NOT NULL,
	[STRACCOUNTING_CD] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRSTUDY_NM] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[STRSTUDY_DSC] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRBBS_USERNAME] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STRBBS_PASSWORD] [char](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DATCREATE_DT] [datetime] NOT NULL,
	[DATCLOSE_DT] [datetime] NOT NULL,
	[INTARCHIVE_MONTHS] [int] NULL,
	[BITSTUDYONGOING] [bit] NOT NULL,
	[INTAP_NUMREPORTS] [int] NULL,
	[INTAP_CONFINTERVAL] [int] NULL,
	[INTAP_ERRORMARGIN] [int] NULL,
	[INTAP_CUTOFFTARGET] [int] NULL,
	[STROBJECTIVES_TXT] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DATOBJECTIVESIGNOFF_DT] [datetime] NULL,
	[CURBUDGETAMT] [money] NULL,
	[CURTOTALSPENT] [money] NULL,
	[STRAP_BELOWQUOTA] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[INTPOPULATIONTABLEID] [int] NULL,
	[INTENCOUNTERTABLEID] [int] NULL,
	[INTPROVIDERTABLEID] [int] NULL,
	[STRREPORTLEVELS] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[STROBJECTIVEDELIVERABLES] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ADEMPLOYEE_ID] [int] NULL,
	[BITCLEANADDR] [bit] NOT NULL,
	[DATARCHIVED] [datetime] NULL,
	[DATCONTRACTSTART] [datetime] NULL,
	[DATCONTRACTEND] [datetime] NULL,
	[BITCHECKPHON] [bit] NOT NULL,
	[bitProperCase] [bit] NOT NULL,
	[BITMULTADDR] [bit] NOT NULL,
	[Country_id] [int] NULL,
	[bitNCOA] [bit] NOT NULL,
	[bitExtractToDatamart] [bit] NULL,
	[Active] [bit] NULL,
	[bitAutosample] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


