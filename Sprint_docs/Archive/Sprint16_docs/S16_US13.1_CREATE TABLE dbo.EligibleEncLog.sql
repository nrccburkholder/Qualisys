/*

	S16 US13 As an authorized Hospice CAHPS vendor, we need to log patients who are eligible to be sampled, so that we can report the count to CMS.

	Task 13.1 Create new table and populate the table from existing tables


	Tim Butler

	CREATE TABLE [dbo].[EligibleEncLog] 

*/


USE [QP_Prod]
GO

/****** Object:  Table [dbo].[EligibleEncLog]    Script Date: 1/9/2015 10:14:15 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[EligibleEncLog](
[sampleset_id] [int] NOT NULL,
[sampleunit_id] [int] NOT NULL,
[pop_id] [int] NOT NULL,
[enc_id] [int] NULL,
[SampleEncounterDate] [datetime] NOT NULL,
[SurveyType_id] [int] NOT NULL
) ON [PRIMARY]

GO


