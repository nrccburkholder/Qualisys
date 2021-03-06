/*
ATL-1370 Automate the study data structure creation process for an HCAHPS client.sql

Chris Burkholder

1/24/2017

CREATE SCHEMA RTPhoenix

CREATE TABLE RTPhoenix.Template
CREATE TABLE RTPhoenix.TemplateLog
CREATE TABLE RTPhoenix.TemplateJob

CREATE TABLE RTPhoenix.ClientTemplate
CREATE TABLE RTPhoenix.StudyTemplate
CREATE TABLE RTPhoenix.Survey_DefTemplate
CREATE TABLE RTPhoenix.SurveySubtypeTemplate
CREATE TABLE RTPhoenix.MailingMethodologyTemplate
CREATE TABLE RTPhoenix.MailingStepTemplate
CREATE TABLE RTPhoenix.SamplePlanTemplate
CREATE TABLE RTPhoenix.PeriodDefTemplate
CREATE TABLE RTPhoenix.PeriodDatesTemplate
CREATE TABLE RTPhoenix.SampleUnitTemplate
CREATE TABLE RTPhoenix.SUFacilityTemplate
CREATE TABLE RTPhoenix.SampleUnitSectionTemplate
CREATE TABLE RTPhoenix.ModeSectionMappingTemplate
CREATE TABLE RTPhoenix.MedicareLookupTemplate
CREATE TABLE RTPhoenix.BusinessRuleTemplate
CREATE TABLE RTPhoenix.HouseholdRuleTemplate
CREATE TABLE RTPhoenix.CriteriaStmtTemplate
CREATE TABLE RTPhoenix.CriteriaClauseTemplate
CREATE TABLE RTPhoenix.CriteriaInlistTemplate
CREATE TABLE RTPhoenix.Sel_CoverTemplate
CREATE TABLE RTPhoenix.Sel_LogoTemplate
CREATE TABLE RTPhoenix.Sel_PCLTemplate
CREATE TABLE RTPhoenix.Sel_QstnsTemplate
CREATE TABLE RTPhoenix.Sel_SclsTemplate
CREATE TABLE RTPhoenix.Sel_SkipTemplate
CREATE TABLE RTPhoenix.Sel_TextboxTemplate
CREATE TABLE RTPhoenix.TagFieldTemplate
CREATE TABLE RTPhoenix.CodeTxtboxTemplate
CREATE TABLE RTPhoenix.CodeQstnsTemplate
CREATE TABLE RTPhoenix.CodeSclsTemplate
CREATE TABLE RTPhoenix.Study_EmployeeTemplate
CREATE TABLE RTPhoenix.MetaTableTemplate
CREATE TABLE RTPhoenix.MetaStructureTemplate
CREATE VIEW RTPhoenix.ClientStudySurvey_viewTemplate

CREATE TABLE RTPhoenix.DestinationQLTemplate
CREATE TABLE RTPhoenix.DTSMappingQLTemplate
CREATE TABLE RTPhoenix.PackageQLTemplate
CREATE TABLE RTPhoenix.SourceQLTemplate
*/
USE [QP_Prod]
GO

CREATE SCHEMA [RTPhoenix]
GO

/****** Object:  Table [RTPhoenix].[Template]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[Template](
	[Template_ID] [int] IDENTITY(1,1) NOT NULL,
	[Client_ID] [int] NOT NULL,
	[Study_ID] [int] NOT NULL, 
	[Template_NM] [varchar](40) NOT NULL,
	[Active] [bit] NULL,
	[DateCreated] [datetime] NULL
 CONSTRAINT [PK_TEMPLATE] PRIMARY KEY CLUSTERED 
(
	[Template_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[TemplateLog]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[TemplateLog](
	[TemplateLog_ID] [int] IDENTITY(1,1) NOT NULL,
	[Template_ID] [int] NOT NULL,
	[Message] [varchar](400) NOT NULL,
	[LoggedBy] [varchar](40) NOT NULL,
	[LoggedAt] [datetime] NULL
 CONSTRAINT [PK_TEMPLATELOG] PRIMARY KEY CLUSTERED 
(
	[TemplateLog_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[TemplateJob]    Script Date: 1/24/2017 11:28:30 AM ******/
--DROP TABLE [RTPhoenix].[TemplateJob]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[TemplateJob](
	[TemplateJob_ID] [int] IDENTITY(1,1) NOT NULL,
	[Template_ID] [int] NULL,
	[CAHPSSurveyType_ID] [int] NULL,
	[CAHPSSurveySubtype_ID] [int] NULL,
	[RTSurveyType_ID] [int] NULL,
	[RTSurveySubtype_ID] [int] NULL,
	[TargetClient_ID] [int] NOT NULL,
	[TargetStudy_ID] [int] NOT NULL,
	[Client_nm] [varchar](40) NULL,
	[Study_nm] [varchar](10) NULL,
	[Study_desc] [varchar](255) NULL,
	[MedicareNumber] [varchar](20) NOT NULL,
	[LoggedBy] [varchar](40) NOT NULL,
	[LoggedAt] [datetime] NULL,
	[CompletedNotes] [varchar](255) NULL,
	[CompletedAt] [datetime] NULL
 CONSTRAINT [PK_TEMPLATEJOB] PRIMARY KEY CLUSTERED 
(
	[TemplateJob_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO


/****** Object:  Table [RTPhoenix].[BUSINESSRULETemplate]    Script Date: 1/24/2017 11:28:29 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[BUSINESSRULETemplate](
	[BUSINESSRULETemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[BUSINESSRULE_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[STUDY_ID] [int] NULL,
	[CRITERIASTMT_ID] [int] NULL,
	[BUSRULE_CD] [char](1) NOT NULL,
 CONSTRAINT [PK_BUSINESSRULE] PRIMARY KEY CLUSTERED 
(
	[BUSINESSRULE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[CLIENTTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[CLIENTTemplate](
	[CLIENTTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[CLIENT_ID] [int] NOT NULL,
	[STRCLIENT_NM] [varchar](40) NULL,
	[Active] [bit] NULL,
	[ClientGroup_ID] [int] NULL,
 CONSTRAINT [PK_CLIENT] PRIMARY KEY CLUSTERED 
(
	[CLIENT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[CODEQSTNSTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[CODEQSTNSTemplate](
	[CODEQSTNSTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SELQSTNS_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[CODE] [int] NOT NULL,
	[INTSTARTPOS] [int] NOT NULL,
	[INTLENGTH] [int] NOT NULL,
 CONSTRAINT [PK_CODEQSTNS] PRIMARY KEY CLUSTERED 
(
	[SELQSTNS_ID] ASC,
	[SURVEY_ID] ASC,
	[LANGUAGE] ASC,
	[CODE] ASC,
	[INTSTARTPOS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[CODESCLSTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[CODESCLSTemplate](
	[CodesSCLSTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[ITEM] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[CODE] [int] NOT NULL,
	[INTSTARTPOS] [int] NOT NULL,
	[INTLENGTH] [int] NOT NULL,
 CONSTRAINT [PK_CODESCLS] PRIMARY KEY CLUSTERED 
(
	[SURVEY_ID] ASC,
	[QPC_ID] ASC,
	[ITEM] ASC,
	[LANGUAGE] ASC,
	[CODE] ASC,
	[INTSTARTPOS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[CODETXTBOXTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[CODETXTBOXTemplate](
	[CodeTextBoxTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[CODE] [int] NOT NULL,
	[INTSTARTPOS] [int] NOT NULL,
	[INTLENGTH] [int] NOT NULL,
 CONSTRAINT [PK_CODETXTBOX] PRIMARY KEY CLUSTERED 
(
	[QPC_ID] ASC,
	[SURVEY_ID] ASC,
	[LANGUAGE] ASC,
	[CODE] ASC,
	[INTSTARTPOS] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[CRITERIACLAUSETemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[CRITERIACLAUSETemplate](
	[CRITERIACLAUSETemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[CRITERIACLAUSE_ID] [int] NOT NULL,
	[CRITERIAPHRASE_ID] [int] NOT NULL,
	[CRITERIASTMT_ID] [int] NULL,
	[TABLE_ID] [int] NOT NULL,
	[FIELD_ID] [int] NOT NULL,
	[INTOPERATOR] [int] NULL,
	[STRLOWVALUE] [varchar](42) NULL,
	[STRHIGHVALUE] [varchar](42) NULL,
 CONSTRAINT [PK_CRITERIACLAUSE] PRIMARY KEY CLUSTERED 
(
	[CRITERIACLAUSE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[CRITERIAINLISTTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[CRITERIAINLISTTemplate](
	[CRITERIAINLISTTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[CRITERIAINLIST_ID] [int] NOT NULL,
	[CRITERIACLAUSE_ID] [int] NULL,
	[STRLISTVALUE] [varchar](42) NOT NULL,
 CONSTRAINT [PK_CRITERIAINLIST] PRIMARY KEY CLUSTERED 
(
	[CRITERIAINLIST_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[CRITERIASTMTTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[CRITERIASTMTTemplate](
	[CRITERIASTMTTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[CRITERIASTMT_ID] [int] NOT NULL,
	[STUDY_ID] [int] NULL,
	[STRCRITERIASTMT_NM] [char](8) NOT NULL,
	[strCriteriaString] [text] NULL,
 CONSTRAINT [PK_CRITERIASTMT] PRIMARY KEY CLUSTERED 
(
	[CRITERIASTMT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[HOUSEHOLDRULETemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[HOUSEHOLDRULETemplate](
	[HOUSEHOLDRULETemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[HOUSEHOLDRULE_ID] [int] NOT NULL,
	[TABLE_ID] [int] NULL,
	[FIELD_ID] [int] NULL,
	[SURVEY_ID] [int] NULL,
 CONSTRAINT [PK_HOUSEHOLDRULE] PRIMARY KEY CLUSTERED 
(
	[HOUSEHOLDRULE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[MAILINGMETHODOLOGYTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[MAILINGMETHODOLOGYTemplate](
	[METHODOLOGYTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[METHODOLOGY_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NULL,
	[BITACTIVEMETHODOLOGY] [bit] NOT NULL,
	[STRMETHODOLOGY_NM] [varchar](42) NOT NULL,
	[DATCREATE_DT] [datetime] NOT NULL,
	[StandardMethodologyID] [int] NOT NULL,
 CONSTRAINT [PK_MAILINGMETHODOLOGY] PRIMARY KEY CLUSTERED 
(
	[METHODOLOGY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[MAILINGSTEPTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[MAILINGSTEPTemplate](
	[MAILINGSTEPTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[MAILINGSTEP_ID] [int] NOT NULL,
	[METHODOLOGY_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NULL,
	[INTSEQUENCE] [int] NOT NULL,
	[SELCOVER_ID] [int] NULL,
	[BITSURVEYINLINE] [bit] NOT NULL,
	[BITSENDSURVEY] [bit] NOT NULL,
	[INTINTERVALDAYS] [int] NOT NULL,
	[BITTHANKYOUITEM] [bit] NOT NULL,
	[STRMAILINGSTEP_NM] [varchar](42) NOT NULL,
	[BITFIRSTSURVEY] [bit] NOT NULL,
	[OverRide_Langid] [int] NULL,
	[MMMailingStep_id] [int] NULL,
	[MailingStepMethod_id] [int] NULL,
	[ExpireInDays] [int] NULL,
	[ExpireFromStep] [int] NULL,
	[Quota_ID] [int] NULL,
	[QuotaStopCollectionAt] [int] NULL,
	[DaysInField] [int] NULL,
	[NumberOfAttempts] [int] NULL,
	[WeekDay_Day_Call] [bit] NULL,
	[WeekDay_Eve_Call] [bit] NULL,
	[Sat_Day_Call] [bit] NULL,
	[Sat_Eve_Call] [bit] NULL,
	[Sun_Day_Call] [bit] NULL,
	[Sun_Eve_Call] [bit] NULL,
	[CallBackOtherLang] [bit] NULL,
	[CallbackUsingTTY] [bit] NULL,
	[AcceptPartial] [bit] NULL,
	[SendEmailBlast] [bit] NULL,
	[Vendor_ID] [int] NULL,
	[ExcludePII] [bit] NULL,
 CONSTRAINT [PK_MAILINGSTEP] PRIMARY KEY CLUSTERED 
(
	[MAILINGSTEP_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[MedicareLookupTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[MedicareLookupTemplate](
	[MedicareLookupTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[MedicareNumber] [varchar](20) NOT NULL,
	[MedicareName] [varchar](200) NOT NULL,
	[Active] [bit] NULL,
	[MedicarePropCalcType_ID] [int] NOT NULL,
	[EstAnnualVolume] [int] NULL,
	[EstRespRate] [decimal](8, 4) NULL,
	[EstIneligibleRate] [decimal](8, 4) NULL,
	[SwitchToCalcDate] [datetime] NULL,
	[AnnualReturnTarget] [int] NULL,
	[SamplingLocked] [tinyint] NULL,
	[ProportionChangeThreshold] [decimal](8, 4) NULL,
	[CensusForced] [tinyint] NULL,
	[PENumber] [varchar](50) NULL,
	[SystematicAnnualReturnTarget] [int] NULL,
	[SystematicEstRespRate] [decimal](8, 4) NULL,
	[SystematicSwitchToCalcDate] [datetime] NULL,
	[NonSubmitting] [bit] NULL,
 CONSTRAINT [PK_ML_MedicareNumber] PRIMARY KEY CLUSTERED 
(
	[MedicareNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[METASTRUCTURETemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[METASTRUCTURETemplate](
	[METASTRUCTURETemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[TABLE_ID] [int] NOT NULL,
	[FIELD_ID] [int] NOT NULL,
	[BITKEYFIELD_FLG] [bit] NOT NULL,
	[BITUSERFIELD_FLG] [bit] NOT NULL,
	[BITMATCHFIELD_FLG] [bit] NOT NULL,
	[BITPOSTEDFIELD_FLG] [bit] NOT NULL,
	[bitPII] [bit] NULL,
	[bitAllowUS] [bit] NULL,
 CONSTRAINT [PK_METASTRUCTURE] PRIMARY KEY CLUSTERED 
(
	[TABLE_ID] ASC,
	[FIELD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[METATABLETemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[METATABLETemplate](
	[METATABLETemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[TABLE_ID] [int] NOT NULL,
	[STRTABLE_NM] [varchar](20) NULL,
	[STRTABLE_DSC] [varchar](80) NULL,
	[STUDY_ID] [int] NULL,
	[BITUSESADDRESS] [bit] NOT NULL,
 CONSTRAINT [PK_METATABLE] PRIMARY KEY CLUSTERED 
(
	[TABLE_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[ModeSectionMappingTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[ModeSectionMappingTemplate](
	[ModeSectionMappingTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[ID] [int] NOT NULL,
	[Survey_Id] [int] NULL,
	[MailingStepMethod_Id] [int] NULL,
	[MailingStepMethod_nm] [varchar](42) NULL,
	[Section_Id] [int] NULL,
	[SectionLabel] [varchar](60) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[PeriodDatesTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[PeriodDatesTemplate](
	[PeriodDatesTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[PeriodDef_id] [int] NOT NULL,
	[SampleNumber] [int] NOT NULL,
	[datScheduledSample_dt] [datetime] NOT NULL,
	[SampleSet_id] [int] NULL,
	[datSampleCreate_dt] [datetime] NULL,
 CONSTRAINT [PK_PeriodDates] PRIMARY KEY CLUSTERED 
(
	[PeriodDef_id] ASC,
	[SampleNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[PeriodDefTemplateTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[PeriodDefTemplate](
	[PeriodDefTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[PeriodDef_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
	[Employee_id] [int] NOT NULL,
	[datAdded] [datetime] NOT NULL,
	[strPeriodDef_nm] [varchar](42) NOT NULL,
	[intExpectedSamples] [int] NOT NULL,
	[DaysToSample] [int] NOT NULL,
	[datExpectedEncStart] [datetime] NULL,
	[datExpectedEncEnd] [datetime] NULL,
	[strDayOrder] [char](6) NULL,
	[MonthWeek] [char](1) NOT NULL,
	[SamplingMethod_id] [int] NOT NULL,
 CONSTRAINT [PK_PeriodDef] PRIMARY KEY CLUSTERED 
(
	[PeriodDef_id] ASC,
	[Survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SAMPLEPLANTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[SAMPLEPLANTemplate](
	[SAMPLEPLANTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SAMPLEPLAN_ID] [int] NOT NULL,
	[ROOTSAMPLEUNIT_ID] [int] NULL,
	[EMPLOYEE_ID] [int] NULL,
	[SURVEY_ID] [int] NULL,
	[DATCREATE_DT] [datetime] NOT NULL,
 CONSTRAINT [PK_SAMPLEPLAN] PRIMARY KEY CLUSTERED 
(
	[SAMPLEPLAN_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[SAMPLEUNITTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SAMPLEUNITTemplate](
	[SAMPLEUNITTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SAMPLEUNIT_ID] [int] NOT NULL,
	[CRITERIASTMT_ID] [int] NULL,
	[SAMPLEPLAN_ID] [int] NOT NULL,
	[PARENTSAMPLEUNIT_ID] [int] NULL,
	[STRSAMPLEUNIT_NM] [varchar](42) NULL,
	[INTTARGETRETURN] [int] NULL,
	[INTMINCONFIDENCE] [int] NULL,
	[INTMAXMARGIN] [int] NULL,
	[NUMINITRESPONSERATE] [int] NULL,
	[NUMRESPONSERATE] [int] NULL,
	[REPORTING_HIERARCHY_ID] [int] NULL,
	[SUFacility_id] [int] NULL,
	[SUServices] [varchar](300) NULL,
	[bitsuppress] [bit] NOT NULL,
	[bitCHART] [bit] NULL,
	[Priority] [int] NOT NULL,
	[SampleSelectionType_id] [int] NOT NULL,
	[DontSampleUnit] [tinyint] NOT NULL,
	[CAHPSType_id] [int] NULL,
	[bitHCAHPS]  AS (case when [CAHPSType_id]=(2) then (1) else (0) end),
	[bitHHCAHPS]  AS (case when [CAHPSType_id]=(3) then (1) else (0) end),
	[bitMNCM]  AS (case when [CAHPSType_id]=(4) then (1) else (0) end),
	[bitACOCAHPS]  AS (case when [CAHPSType_id]=(10) then (1) else (0) end),
	[bitLowVolumeUnit] [bit] NOT NULL,
 CONSTRAINT [PK_SAMPLEUNIT] PRIMARY KEY CLUSTERED 
(
	[SAMPLEUNIT_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SAMPLEUNITSECTIONTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[SAMPLEUNITSECTIONTemplate](
	[SAMPLEUNITSECTIONTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SAMPLEUNITSECTION_ID] [int] NOT NULL,
	[SAMPLEUNIT_ID] [int] NULL,
	[SELQSTNSSECTION] [int] NULL,
	[SELQSTNSSURVEY_ID] [int] NULL,
 CONSTRAINT [PK_SAMPLEUNITSECTION] PRIMARY KEY CLUSTERED 
(
	[SAMPLEUNITSECTION_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[Sel_CoverTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[Sel_CoverTemplate](
	[Sel_CoverTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SelCover_id] [int] NOT NULL,
	[Survey_id] [int] NOT NULL,
	[PageType] [int] NULL,
	[Description] [char](60) NULL,
	[Integrated] [bit] NOT NULL,
	[bitLetterHead] [bit] NOT NULL,
 CONSTRAINT [PK_SEL_COVER] PRIMARY KEY CLUSTERED 
(
	[SelCover_id] ASC,
	[Survey_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SEL_LOGOTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SEL_LOGOTemplate](
	[SEL_LOGOTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[COVERID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[DESCRIPTION] [char](60) NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[SCALING] [int] NULL,
	[BITMAP] [image] NULL,
	[VISIBLE] [bit] NOT NULL,
 CONSTRAINT [PK_SEL_LOGO] PRIMARY KEY CLUSTERED 
(
	[QPC_ID] ASC,
	[COVERID] ASC,
	[SURVEY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SEL_PCLTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SEL_PCLTemplate](
	[SEL_PCLTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[COVERID] [int] NULL,
	[DESCRIPTION] [char](60) NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[PCLSTREAM] [image] NULL,
	[KNOWNDIMENSIONS] [bit] NOT NULL,
 CONSTRAINT [PK_SEL_PCL] PRIMARY KEY CLUSTERED 
(
	[QPC_ID] ASC,
	[SURVEY_ID] ASC,
	[LANGUAGE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SEL_QSTNSTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SEL_QSTNSTemplate](
	[SEL_QSTNSTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SELQSTNS_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[SCALEID] [int] NOT NULL,
	[SECTION_ID] [int] NULL,
	[LABEL] [char](60) NULL,
	[PLUSMINUS] [char](3) NULL,
	[SUBSECTION] [int] NULL,
	[ITEM] [int] NULL,
	[SUBTYPE] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[RICHTEXT] [text] NULL,
	[SCALEPOS] [int] NULL,
	[SCALEFLIPPED] [int] NULL,
	[NUMMARKCOUNT] [int] NULL,
	[BITMEANABLE] [bit] NOT NULL,
	[NUMBUBBLECOUNT] [int] NULL,
	[QSTNCORE] [int] NOT NULL,
	[BITLANGREVIEW] [bit] NOT NULL,
	[strFullQuestion] [varchar](6000) NULL,
 CONSTRAINT [PK_SELQSTNS] PRIMARY KEY CLUSTERED 
(
	[SELQSTNS_ID] ASC,
	[SURVEY_ID] ASC,
	[LANGUAGE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SEL_SCLSTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SEL_SCLSTemplate](
	[SEL_SCLSTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[ITEM] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[VAL] [int] NOT NULL,
	[LABEL] [char](60) NULL,
	[RICHTEXT] [text] NULL,
	[MISSING] [bit] NOT NULL,
	[CHARSET] [int] NULL,
	[SCALEORDER] [int] NULL,
	[INTRESPTYPE] [int] NULL,
 CONSTRAINT [PK_SEL_SCLS] PRIMARY KEY CLUSTERED 
(
	[SURVEY_ID] ASC,
	[QPC_ID] ASC,
	[ITEM] ASC,
	[LANGUAGE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SEL_SKIPTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[SEL_SKIPTemplate](
	[SEL_SKIPTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[SELQSTNS_ID] [int] NOT NULL,
	[SELSCLS_ID] [int] NOT NULL,
	[SCALEITEM] [int] NOT NULL,
	[NUMSKIP] [int] NULL,
	[NUMSKIPTYPE] [int] NULL,
 CONSTRAINT [PK_SEL_SKIP] PRIMARY KEY CLUSTERED 
(
	[SURVEY_ID] ASC,
	[SELQSTNS_ID] ASC,
	[SELSCLS_ID] ASC,
	[SCALEITEM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SEL_TEXTBOX]    Script Date: 1/25/2017 3:16:17 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SEL_TEXTBOXTemplate](
	[SEL_TEXTBOXTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[QPC_ID] [int] NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[LANGUAGE] [int] NOT NULL,
	[COVERID] [int] NOT NULL,
	[X] [int] NULL,
	[Y] [int] NULL,
	[WIDTH] [int] NULL,
	[HEIGHT] [int] NULL,
	[RICHTEXT] [text] NULL,
	[BORDER] [int] NULL,
	[SHADING] [int] NULL,
	[BITLANGREVIEW] [bit] NOT NULL,
	[LABEL] [char](60) NOT NULL,
 CONSTRAINT [PK_SEL_TEXTBOX] PRIMARY KEY CLUSTERED 
(
	[QPC_ID] ASC,
	[SURVEY_ID] ASC,
	[LANGUAGE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[STUDYTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[STUDYTemplate](
	[STUDYTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[STUDY_ID] [int] NOT NULL,
	[CLIENT_ID] [int] NOT NULL,
	[STRACCOUNTING_CD] [char](10) NULL,
	[STRSTUDY_NM] [char](10) NOT NULL,
	[STRSTUDY_DSC] [varchar](255) NULL,
	[STRBBS_USERNAME] [char](8) NULL,
	[STRBBS_PASSWORD] [char](8) NULL,
	[DATCREATE_DT] [datetime] NOT NULL,
	[DATCLOSE_DT] [datetime] NOT NULL,
	[INTARCHIVE_MONTHS] [int] NULL,
	[BITSTUDYONGOING] [bit] NOT NULL,
	[INTAP_NUMREPORTS] [int] NULL,
	[INTAP_CONFINTERVAL] [int] NULL,
	[INTAP_ERRORMARGIN] [int] NULL,
	[INTAP_CUTOFFTARGET] [int] NULL,
	[STROBJECTIVES_TXT] [text] NULL,
	[DATOBJECTIVESIGNOFF_DT] [datetime] NULL,
	[CURBUDGETAMT] [money] NULL,
	[CURTOTALSPENT] [money] NULL,
	[STRAP_BELOWQUOTA] [varchar](255) NULL,
	[INTPOPULATIONTABLEID] [int] NULL,
	[INTENCOUNTERTABLEID] [int] NULL,
	[INTPROVIDERTABLEID] [int] NULL,
	[STRREPORTLEVELS] [text] NULL,
	[STROBJECTIVEDELIVERABLES] [text] NULL,
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
	[bitAutosample] [bit] NOT NULL,
 CONSTRAINT [PK_STUDY] PRIMARY KEY CLUSTERED 
(
	[STUDY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[STUDY_EMPLOYEETemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[STUDY_EMPLOYEETemplate](
	[STUDY_EMPLOYEETemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[EMPLOYEE_ID] [int] NOT NULL,
	[STUDY_ID] [int] NOT NULL,
 CONSTRAINT [PK_STUDY_EMPLOYEE] PRIMARY KEY CLUSTERED 
(
	[EMPLOYEE_ID] ASC,
	[STUDY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[SUFacilityTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SUFacilityTemplate](
	[SUFacilityTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[SUFacility_id] [int] NOT NULL,
	[strFacility_nm] [varchar](100) NOT NULL,
	[City] [varchar](42) NOT NULL,
	[State] [varchar](2) NOT NULL,
	[Country] [varchar](42) NULL,
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
	[MedicareNumber] [varchar](20) NULL,
 CONSTRAINT [PK_SUF_SUFacilityID] PRIMARY KEY CLUSTERED 
(
	[SUFacility_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SURVEY_DEFTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SURVEY_DEFTemplate](
	[SURVEY_DefTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[SURVEY_ID] [int] NOT NULL,
	[STUDY_ID] [int] NOT NULL,
	[STRSURVEY_NM] [char](10) NOT NULL,
	[STRSURVEY_DSC] [varchar](40) NULL,
	[INTRESPONSE_RECALC_PERIOD] [int] NOT NULL,
	[INTRESURVEY_PERIOD] [int] NULL,
	[BITREPEATINGENCOUNTERS_FLG] [bit] NOT NULL,
	[BITPHYSASSIST_NAME_FLG] [bit] NOT NULL,
	[BITMINOR_EXCEPT_FLG] [bit] NOT NULL,
	[BITNEWBORN_FLG] [bit] NOT NULL,
	[DATSURVEY_START_DT] [datetime] NULL,
	[DATSURVEY_END_DT] [datetime] NULL,
	[STRMAILFREQ] [char](9) NOT NULL,
	[INTSAMPLESINPERIOD] [int] NOT NULL,
	[STRXMITROUTE] [char](16) NULL,
	[BITUSECOMMENTS] [bit] NOT NULL,
	[STRCMNTCOPYTYPE] [varchar](15) NULL,
	[STRCMNTSORT] [varchar](40) NULL,
	[BITSENDCMNTOUT] [bit] NOT NULL,
	[STRSPECIALINSTRUCTIONS] [text] NULL,
	[STRCMNTMAILFREQ] [char](9) NULL,
	[STRCMNTCARRIER] [varchar](14) NULL,
	[STROTHERINSTRUCTIONS] [varchar](40) NULL,
	[STRCMNTTYPING_DBVER] [varchar](40) NULL,
	[BITCMNTTYPING_ONDISK] [bit] NOT NULL,
	[STRCMNT_CMNT] [varchar](255) NULL,
	[BITVALIDATED_FLG] [bit] NOT NULL,
	[DATVALIDATED] [datetime] NULL,
	[BITFORMGENRELEASE] [bit] NOT NULL,
	[BITLAYOUTVALID] [bit] NOT NULL,
	[BITDYNAMIC] [bit] NOT NULL,
	[STRCUTOFFRESPONSE_CD] [char](1) NULL,
	[cutofftable_id] [int] NULL,
	[cutofffield_id] [int] NULL,
	[strHouseholdingType] [char](1) NOT NULL,
	[bitDoHousehold] [bit] NOT NULL,
	[vcHouseholding] [char](1) NULL,
	[intQuarter] [int] NULL,
	[weighttype] [tinyint] NOT NULL,
	[bitmultreturns] [bit] NULL,
	[Priority_Flg] [tinyint] NULL,
	[bitEnforceSkip] [bit] NULL,
	[strclientfacingName] [varchar](42) NULL,
	[SurveyType_id] [int] NULL,
	[AHANumber] [int] NULL,
	[SurveyTypeDef_id] [int] NULL,
	[ReSurveyMethod_id] [int] NOT NULL,
	[SamplingAlgorithmID] [int] NULL,
	[SampleEncounterField_id] [int] NULL,
	[SampleEncounterTable_id] [int] NULL,
	[Contract] [varchar](9) NULL,
	[bitPhoneTelematch] [bit] NULL,
	[Active] [bit] NULL,
	[PervasiveMapName] [varchar](255) NULL,
	[ContractedLanguages] [varchar](50) NULL,
	[UseUSPSAddrChangeService] [bit] NULL,
	[IsHandout] [bit] NULL,
	[IsPointInTime] [bit] NULL,
 CONSTRAINT [PK_SURVEY_DEF] PRIMARY KEY CLUSTERED 
(
	[SURVEY_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SurveySubtypeTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[SurveySubtypeTemplate](
	[SurveySubtypeTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[SurveySubtype_id] [int] NOT NULL,
	[Survey_id] [int] NULL,
	[Subtype_id] [int] NULL,
 CONSTRAINT [pk_SurveySubtype] PRIMARY KEY CLUSTERED 
(
	[SurveySubtype_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[TAGFIELD]    Script Date: 1/25/2017 3:56:02 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[TAGFIELDTemplate](
	[TAGFIELDTemplate_ID] [int] IDENTITY(-1,-1) NOT NULL,
	[TAGFIELD_ID] [int] NOT NULL,
	[TAG_ID] [int] NOT NULL,
	[TABLE_ID] [int] NULL,
	[FIELD_ID] [int] NULL,
	[STUDY_ID] [int] NULL,
	[REPLACEFIELD_FLG] [bit] NOT NULL,
	[STRREPLACELITERAL] [varchar](40) NULL,
 CONSTRAINT [PK_TAGFIELD] PRIMARY KEY CLUSTERED 
(
	[TAGFIELD_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [RTPhoenix].[ClientStudySurvey_viewTemplate]    Script Date: 1/24/2017 11:28:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [RTPhoenix].[ClientStudySurvey_viewTemplate]    
as    
select	Template_ID, t.Active,
		c.strClient_nm, st.strStudy_nm, sd.strSurvey_nm, c.client_id, st.study_id, sd.survey_id,   
		SurveyType_id, Subtype_id, c.Active ClientActive, st.active StudyActive, 
		sd.active SurveyActive, sp.sampleplan_id, mm.methodology_id    
from	RTPhoenix.clientTemplate c
		INNER JOIN RTPhoenix.STUDYTemplate  AS st ON c.CLIENT_ID = st.CLIENT_ID     
        INNER JOIN RTPhoenix.Template t on T.Study_ID = st.STUDY_ID
		INNER JOIN RTPhoenix.SURVEY_DEFTemplate AS sd ON st.STUDY_ID = sd.STUDY_ID     
		INNER JOIN RTPhoenix.sampleplanTemplate AS sp on sd.survey_id=sp.survey_id 
		INNER JOIN RTPhoenix.mailingmethodologyTemplate as mm on sd.survey_id=mm.survey_id  
		LEFT JOIN RTPhoenix.SurveySubTypeTemplate SST on SST.Survey_id = SD.SURVEY_ID

GO
ALTER TABLE [RTPhoenix].[CLIENTTemplate] ADD  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [RTPhoenix].[MAILINGMETHODOLOGYTemplate] ADD  DEFAULT ((5)) FOR [StandardMethodologyID]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [MailingStepMethod_id]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((84)) FOR [ExpireInDays]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [QuotaStopCollectionAt]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [DaysInField]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [NumberOfAttempts]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [WeekDay_Day_Call]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [WeekDay_Eve_Call]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [Sat_Day_Call]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [Sat_Eve_Call]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [Sun_Day_Call]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [Sun_Eve_Call]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [CallBackOtherLang]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [CallbackUsingTTY]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [AcceptPartial]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] ADD  DEFAULT ((0)) FOR [SendEmailBlast]
GO
ALTER TABLE [RTPhoenix].[MedicareLookupTemplate] ADD  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [RTPhoenix].[MedicareLookupTemplate] ADD  DEFAULT ((2)) FOR [MedicarePropCalcType_ID]
GO
ALTER TABLE [RTPhoenix].[MedicareLookupTemplate] ADD  DEFAULT ((0)) FOR [SamplingLocked]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] ADD  DEFAULT ((1)) FOR [Priority]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] ADD  DEFAULT ((1)) FOR [SampleSelectionType_id]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] ADD  DEFAULT ((0)) FOR [DontSampleUnit]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] ADD  DEFAULT ((0)) FOR [CAHPSType_id]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] ADD  DEFAULT ((0)) FOR [bitLowVolumeUnit]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((0)) FOR [BITCHECKPHON]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((1)) FOR [bitProperCase]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((0)) FOR [BITMULTADDR]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((1)) FOR [Country_id]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((0)) FOR [bitNCOA]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((1)) FOR [bitExtractToDatamart]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] ADD  DEFAULT ((0)) FOR [bitAutosample]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [BITREPEATINGENCOUNTERS_FLG]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [BITPHYSASSIST_NAME_FLG]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [BITMINOR_EXCEPT_FLG]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [BITNEWBORN_FLG]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ('') FOR [STRMAILFREQ]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [INTSAMPLESINPERIOD]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [BITUSECOMMENTS]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [BITSENDCMNTOUT]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [BITCMNTTYPING_ONDISK]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [BITVALIDATED_FLG]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [BITFORMGENRELEASE]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [BITLAYOUTVALID]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ('N') FOR [strHouseholdingType]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [bitDoHousehold]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [weighttype]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [bitmultreturns]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((5)) FOR [Priority_Flg]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((0)) FOR [bitEnforceSkip]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [ReSurveyMethod_id]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] ADD  DEFAULT ((1)) FOR [Active]
GO
ALTER TABLE [RTPhoenix].[BUSINESSRULETemplate]  WITH CHECK ADD  CONSTRAINT [FK_BUSINESS_REF_18027_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [RTPhoenix].[STUDYTemplate] ([STUDY_ID])
GO
ALTER TABLE [RTPhoenix].[BUSINESSRULETemplate] CHECK CONSTRAINT [FK_BUSINESS_REF_18027_STUDY]
GO
/*ALTER TABLE [RTPhoenix].[CLIENTTemplate]  WITH CHECK ADD  CONSTRAINT [FK_CLIENT_ClientGroups] FOREIGN KEY([ClientGroup_ID])
REFERENCES [RTPhoenix].[ClientGroupsTemplate] ([ClientGroup_ID])
GO
ALTER TABLE [RTPhoenix].[CLIENTTemplate] CHECK CONSTRAINT [FK_CLIENT_ClientGroups]
GO*/
ALTER TABLE [RTPhoenix].[CODEQSTNSTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_CODEQSTN_REF_28910_CODES] FOREIGN KEY([CODE])
REFERENCES [dbo].[Codes] ([Code])
GO
ALTER TABLE [RTPhoenix].[CODEQSTNSTemplate] CHECK CONSTRAINT [FK_CODEQSTN_REF_28910_CODES]
GO
ALTER TABLE [RTPhoenix].[CODESCLSTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_CODESCLS_REF_28954_CODES] FOREIGN KEY([CODE])
REFERENCES [dbo].[Codes] ([Code])
GO
ALTER TABLE [RTPhoenix].[CODESCLSTemplate] CHECK CONSTRAINT [FK_CODESCLS_REF_28954_CODES]
GO
ALTER TABLE [RTPhoenix].[CODETXTBOXTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_CODETXTB_REF_28941_CODES] FOREIGN KEY([CODE])
REFERENCES [dbo].[Codes] ([Code])
GO
ALTER TABLE [RTPhoenix].[CODETXTBOXTemplate] CHECK CONSTRAINT [FK_CODETXTB_REF_28941_CODES]
GO
ALTER TABLE [RTPhoenix].[CRITERIACLAUSETemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_CRITERIA_REF_1715_METASTRU] FOREIGN KEY([TABLE_ID], [FIELD_ID])
REFERENCES [RTPhoenix].[METASTRUCTURETemplate] ([TABLE_ID], [FIELD_ID])
GO
ALTER TABLE [RTPhoenix].[CRITERIACLAUSETemplate] CHECK CONSTRAINT [FK_CRITERIA_REF_1715_METASTRU]
GO
ALTER TABLE [RTPhoenix].[CRITERIASTMTTemplate]  WITH CHECK ADD  CONSTRAINT [FK_CRITERIA_REF_16400_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [RTPhoenix].[STUDYTemplate] ([STUDY_ID])
GO
ALTER TABLE [RTPhoenix].[CRITERIASTMTTemplate] CHECK CONSTRAINT [FK_CRITERIA_REF_16400_STUDY]
GO
ALTER TABLE [RTPhoenix].[HOUSEHOLDRULETemplate]  WITH CHECK ADD  CONSTRAINT [FK_HOUSEHOL_REF_4438_METASTRU] FOREIGN KEY([TABLE_ID], [FIELD_ID])
REFERENCES [RTPhoenix].[METASTRUCTURETemplate] ([TABLE_ID], [FIELD_ID])
GO
ALTER TABLE [RTPhoenix].[HOUSEHOLDRULETemplate] CHECK CONSTRAINT [FK_HOUSEHOL_REF_4438_METASTRU]
GO
ALTER TABLE [RTPhoenix].[MAILINGMETHODOLOGYTemplate]  WITH CHECK ADD  CONSTRAINT [FK_MAILINGM_REF_6478_SURVEY_D] FOREIGN KEY([SURVEY_ID])
REFERENCES [RTPhoenix].[SURVEY_DEFTemplate] ([SURVEY_ID])
GO
ALTER TABLE [RTPhoenix].[MAILINGMETHODOLOGYTemplate] CHECK CONSTRAINT [FK_MAILINGM_REF_6478_SURVEY_D]
GO
ALTER TABLE [RTPhoenix].[MAILINGMETHODOLOGYTemplate]  WITH CHECK ADD  CONSTRAINT [MM_StandardMethodology] FOREIGN KEY([StandardMethodologyID])
REFERENCES [dbo].[StandardMethodology] ([StandardMethodologyID])
GO
ALTER TABLE [RTPhoenix].[MAILINGMETHODOLOGYTemplate] CHECK CONSTRAINT [MM_StandardMethodology]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate]  WITH CHECK ADD  CONSTRAINT [FK__MAILINGST__Quota__60B4AB0C] FOREIGN KEY([Vendor_ID])
REFERENCES [dbo].[Vendors] ([Vendor_ID])
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] CHECK CONSTRAINT [FK__MAILINGST__Quota__60B4AB0C]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate]  WITH CHECK ADD  CONSTRAINT [FK_MAILINGS_REF_6482_MAILINGM] FOREIGN KEY([METHODOLOGY_ID])
REFERENCES [RTPhoenix].[MAILINGMETHODOLOGYTemplate] ([METHODOLOGY_ID])
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] CHECK CONSTRAINT [FK_MAILINGS_REF_6482_MAILINGM]
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate]  WITH CHECK ADD  CONSTRAINT [FK_MAILINGSTEP_MAILINGSTEPMETHOD] FOREIGN KEY([MailingStepMethod_id])
REFERENCES [dbo].[MAILINGSTEPMETHOD] ([MailingStepMethod_id])
GO
ALTER TABLE [RTPhoenix].[MAILINGSTEPTemplate] CHECK CONSTRAINT [FK_MAILINGSTEP_MAILINGSTEPMETHOD]
GO
ALTER TABLE [RTPhoenix].[METASTRUCTURETemplate]  WITH CHECK ADD  CONSTRAINT [FK_METASTRU_REF_178_METATABL] FOREIGN KEY([TABLE_ID])
REFERENCES [RTPhoenix].[METATABLETemplate] ([TABLE_ID])
GO
ALTER TABLE [RTPhoenix].[METASTRUCTURETemplate] CHECK CONSTRAINT [FK_METASTRU_REF_178_METATABL]
GO
ALTER TABLE [RTPhoenix].[METASTRUCTURETemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_METASTRU_REF_181_METAFIEL] FOREIGN KEY([FIELD_ID])
REFERENCES [dbo].[METAFIELD] ([FIELD_ID])
GO
ALTER TABLE [RTPhoenix].[METASTRUCTURETemplate] CHECK CONSTRAINT [FK_METASTRU_REF_181_METAFIEL]
GO
ALTER TABLE [RTPhoenix].[METATABLETemplate]  WITH CHECK ADD  CONSTRAINT [FK_METATABL_REF_222_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [RTPhoenix].[STUDYTemplate] ([STUDY_ID])
GO
ALTER TABLE [RTPhoenix].[METATABLETemplate] CHECK CONSTRAINT [FK_METATABL_REF_222_STUDY]
GO
ALTER TABLE [RTPhoenix].[SAMPLEPLANTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_SAMPLEPL_REF_2083_EMPLOYEE] FOREIGN KEY([EMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])
GO
ALTER TABLE [RTPhoenix].[SAMPLEPLANTemplate] CHECK CONSTRAINT [FK_SAMPLEPL_REF_2083_EMPLOYEE]
GO
ALTER TABLE [RTPhoenix].[SAMPLEPLANTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLEPL_REF_4957_SAMPLEUN] FOREIGN KEY([ROOTSAMPLEUNIT_ID])
REFERENCES [RTPhoenix].[SAMPLEUNITTemplate] ([SAMPLEUNIT_ID])
GO
ALTER TABLE [RTPhoenix].[SAMPLEPLANTemplate] CHECK CONSTRAINT [FK_SAMPLEPL_REF_4957_SAMPLEUN]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLEUN_REF_2096_SAMPLEUN] FOREIGN KEY([PARENTSAMPLEUNIT_ID])
REFERENCES [RTPhoenix].[SAMPLEUNITTemplate] ([SAMPLEUNIT_ID])
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] CHECK CONSTRAINT [FK_SAMPLEUN_REF_2096_SAMPLEUN]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_SAMPLEUNIT_REF_2092_SAMPLEPL] FOREIGN KEY([SAMPLEPLAN_ID])
REFERENCES [RTPhoenix].[SAMPLEPLANTemplate] ([SAMPLEPLAN_ID])
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] CHECK CONSTRAINT [FK_SAMPLEUNIT_REF_2092_SAMPLEPL]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_SampleUnitHierarchy] FOREIGN KEY([REPORTING_HIERARCHY_ID])
REFERENCES [dbo].[REPORTINGHIERARCHY] ([REPORTING_HIERARCHY_ID])
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITTemplate] CHECK CONSTRAINT [FK_SampleUnitHierarchy]
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITSECTIONTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SAMPLEUN_REF_4355_SAMPLEUN] FOREIGN KEY([SAMPLEUNIT_ID])
REFERENCES [RTPhoenix].[SAMPLEUNITTemplate] ([SAMPLEUNIT_ID])
GO
ALTER TABLE [RTPhoenix].[SAMPLEUNITSECTIONTemplate] CHECK CONSTRAINT [FK_SAMPLEUN_REF_4355_SAMPLEUN]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate]  WITH CHECK ADD  CONSTRAINT [FK_STUDY_CLIENT] FOREIGN KEY([CLIENT_ID])
REFERENCES [RTPhoenix].[CLIENTTemplate] ([CLIENT_ID])
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] CHECK CONSTRAINT [FK_STUDY_CLIENT]
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_STUDY_REF_16407_EMPLOYEE] FOREIGN KEY([ADEMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])
GO
ALTER TABLE [RTPhoenix].[STUDYTemplate] CHECK CONSTRAINT [FK_STUDY_REF_16407_EMPLOYEE]
GO
ALTER TABLE [RTPhoenix].[STUDY_EMPLOYEETemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_STUDY_EM_REF_913_EMPLOYEE] FOREIGN KEY([EMPLOYEE_ID])
REFERENCES [dbo].[EMPLOYEE] ([EMPLOYEE_ID])
GO
ALTER TABLE [RTPhoenix].[STUDY_EMPLOYEETemplate] CHECK CONSTRAINT [FK_STUDY_EM_REF_913_EMPLOYEE]
GO
ALTER TABLE [RTPhoenix].[STUDY_EMPLOYEETemplate]  WITH CHECK ADD  CONSTRAINT [FK_STUDY_EM_REF_917_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [RTPhoenix].[STUDYTemplate] ([STUDY_ID])
GO
ALTER TABLE [RTPhoenix].[STUDY_EMPLOYEETemplate] CHECK CONSTRAINT [FK_STUDY_EM_REF_917_STUDY]
GO
ALTER TABLE [RTPhoenix].[SUFacilityTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SUF_Medicare] FOREIGN KEY([MedicareNumber])
REFERENCES [RTPhoenix].[MedicareLookupTemplate] ([MedicareNumber])
GO
ALTER TABLE [RTPhoenix].[SUFacilityTemplate] CHECK CONSTRAINT [FK_SUF_Medicare]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_CutoffField_id] FOREIGN KEY([cutofffield_id])
REFERENCES [dbo].[METAFIELD] ([FIELD_ID])
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] CHECK CONSTRAINT [FK_CutoffField_id]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate]  WITH NOCHECK ADD  CONSTRAINT [FK_CutoffTable_id] FOREIGN KEY([cutofftable_id])
REFERENCES [RTPhoenix].[METATABLETemplate] ([TABLE_ID])
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] CHECK CONSTRAINT [FK_CutoffTable_id]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SampEncField_id] FOREIGN KEY([SampleEncounterField_id])
REFERENCES [dbo].[METAFIELD] ([FIELD_ID])
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] CHECK CONSTRAINT [FK_SampEncField_id]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SampEncTable_id] FOREIGN KEY([SampleEncounterTable_id])
REFERENCES [RTPhoenix].[METATABLETemplate] ([TABLE_ID])
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] CHECK CONSTRAINT [FK_SampEncTable_id]
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate]  WITH CHECK ADD  CONSTRAINT [FK_SURVEY_D_REF_441_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [RTPhoenix].[STUDYTemplate] ([STUDY_ID])
GO
ALTER TABLE [RTPhoenix].[SURVEY_DEFTemplate] CHECK CONSTRAINT [FK_SURVEY_D_REF_441_STUDY]
GO
ALTER TABLE [RTPhoenix].[SurveySubtypeTemplate]  WITH CHECK ADD  CONSTRAINT [fk_SurveySubtype_Subtype] FOREIGN KEY([Subtype_id])
REFERENCES [dbo].[Subtype] ([Subtype_id])
GO
ALTER TABLE [RTPhoenix].[SurveySubtypeTemplate] CHECK CONSTRAINT [fk_SurveySubtype_Subtype]
GO
ALTER TABLE [RTPhoenix].[SurveySubtypeTemplate]  WITH CHECK ADD  CONSTRAINT [fk_SurveySubtype_Survey] FOREIGN KEY([Survey_id])
REFERENCES [RTPhoenix].[SURVEY_DEFTemplate] ([SURVEY_ID])
GO
ALTER TABLE [RTPhoenix].[SurveySubtypeTemplate] CHECK CONSTRAINT [fk_SurveySubtype_Survey]
GO
ALTER TABLE [RTPhoenix].[TAGFIELDTemplate]  WITH CHECK ADD  CONSTRAINT [FK_TAGFIELD_REF_38365_STUDY] FOREIGN KEY([STUDY_ID])
REFERENCES [RTPhoenix].[STUDYTemplate] ([STUDY_ID])
GO
ALTER TABLE [RTPhoenix].[TAGFIELDTemplate] CHECK CONSTRAINT [FK_TAGFIELD_REF_38365_STUDY]
GO
ALTER TABLE [RTPhoenix].[TAGFIELDTemplate]  WITH CHECK ADD  CONSTRAINT [FK_TAGFIELD_REF_9276_TAG] FOREIGN KEY([TAG_ID])
REFERENCES [dbo].[TAG] ([TAG_ID])
GO
ALTER TABLE [RTPhoenix].[TAGFIELDTemplate] CHECK CONSTRAINT [FK_TAGFIELD_REF_9276_TAG]
GO
ALTER TABLE [RTPhoenix].[TAGFIELDTemplate]  WITH CHECK ADD  CONSTRAINT [FK_TAGFIELD_REF_9280_METASTRU] FOREIGN KEY([TABLE_ID], [FIELD_ID])
REFERENCES [RTPhoenix].[METASTRUCTURETemplate] ([TABLE_ID], [FIELD_ID])
GO
ALTER TABLE [RTPhoenix].[TAGFIELDTemplate] CHECK CONSTRAINT [FK_TAGFIELD_REF_9280_METASTRU]
GO
/**********************
******* QP_LOAD *******
**********************/
/****** Object:  Table [RTPhoenix].[DestinationQLTemplate]    Script Date: 1/26/2017 1:06:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[DestinationQLTemplate](
	[DestinationQLTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[Destination_id] [int] NOT NULL,
	[Package_id] [int] NOT NULL,
	[intVersion] [int] NOT NULL,
	[Table_id] [int] NOT NULL,
	[Field_id] [int] NOT NULL,
	[Formula] [varchar](2000) NOT NULL,
	[bitNULLCount] [bit] NOT NULL,
	[intFreqLimit] [smallint] NULL,
	[Sources] [varchar](500) NULL,
 CONSTRAINT [PK__Destination__21B6055D] PRIMARY KEY NONCLUSTERED 
(
	[Destination_id] ASC,
	[Package_id] ASC,
	[intVersion] ASC,
	[Table_id] ASC,
	[Field_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[DTSMappingQLTemplate]    Script Date: 1/26/2017 1:06:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RTPhoenix].[DTSMappingQLTemplate](
	[DTSMappingQLTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[intVersion] [int] NOT NULL,
	[Source_id] [int] NOT NULL,
	[Destination_id] [int] NOT NULL,
	[Package_id] [int] NOT NULL,
PRIMARY KEY NONCLUSTERED 
(
	[intVersion] ASC,
	[Source_id] ASC,
	[Destination_id] ASC,
	[Package_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [RTPhoenix].[PackageQLTemplate]    Script Date: 1/26/2017 1:06:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[PackageQLTemplate](
	[PackageQLTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[Package_id] [int] NOT NULL,
	[intVersion] [int] NOT NULL,
	[strPackage_nm] [varchar](42) NOT NULL,
	[Client_id] [int] NOT NULL,
	[Study_id] [int] NOT NULL,
	[intTeamNumber] [int] NULL,
	[strLogin_nm] [varchar](42) NOT NULL,
	[datLastModified] [datetime] NULL,
	[bitArchive] [bit] NULL,
	[datArchive] [datetime] NULL,
	[FileType_id] [int] NULL,
	[FileTypeSettings] [varchar](500) NULL,
	[SignOffBy_id] [int] NULL,
	[datCreated] [datetime] NULL,
	[strPackageFriendly_nm] [varchar](100) NULL,
	[bitActive] [bit] NULL,
	[bitDeleted] [bit] NULL,
	[OwnerMember_id] [int] NOT NULL,
 CONSTRAINT [PK__Package__2C3393D0] PRIMARY KEY NONCLUSTERED 
(
	[intVersion] ASC,
	[Package_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [ClientID_FriendlyPackageName] UNIQUE NONCLUSTERED 
(
	[Client_id] ASC,
	[strPackageFriendly_nm] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [RTPhoenix].[SourceQLTemplate]    Script Date: 1/26/2017 1:06:01 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [RTPhoenix].[SourceQLTemplate](
	[SourceQLTemplate_id] [int] IDENTITY(-1,-1) NOT NULL,
	[Source_id] [int] NOT NULL,
	[Package_id] [int] NOT NULL,
	[intVersion] [int] NOT NULL,
	[strName] [varchar](42) NOT NULL,
	[strAlias] [varchar](42) NULL,
	[intLength] [int] NULL,
	[DataType_id] [int] NOT NULL,
	[Ordinal] [int] NOT NULL,
 CONSTRAINT [PK__Source__32E0915F] PRIMARY KEY NONCLUSTERED 
(
	[Package_id] ASC,
	[intVersion] ASC,
	[Source_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [RTPhoenix].[DestinationQLTemplate] ADD  CONSTRAINT [DF_Destination_bitNULLCount]  DEFAULT (0) FOR [bitNULLCount]
GO
ALTER TABLE [RTPhoenix].[PackageQLTemplate] ADD  CONSTRAINT [DF_Package_OwnerMember_id]  DEFAULT ((-1)) FOR [OwnerMember_id]
GO
