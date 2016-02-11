CREATE TABLE [dbo].[VRT_CallOutcomeEventCodeMap_West](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CallOutcome] [varchar](500) NOT NULL,
	[CallType] [varchar](20) NOT NULL,
	[EventID] [int] NOT NULL,
	CONSTRAINT [PK_VRT_CallOutcomeEventCodeMap_West] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	) 
) ON [PRIMARY]

INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('BUSY','Outbound',5005)
--INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('COMPLETESURVEY','Outbound',N/A)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('DECEASED','Outbound',5014)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('DISCONNECTED','Outbound',5003)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('DISENROLLED','Outbound',5015)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('HANGUP','Outbound',5017)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('INCORRECTNUMBER','Outbound',5002)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('LANGUAGEBARRIER','Outbound',5016)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('MACHINEANSWERED','Outbound',5007)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('NOANSWER','Outbound',5004)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('NOOPTIN','Outbound',5017)
--INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('PARTIALSURVEY','Outbound',N/A)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('SCHEDULECALLBACK','Outbound',5009)

INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('BUSY','Inbound',5005)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('COMPLETESURVEY','Inbound',8887)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('DECEASED','Inbound',5014)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('DISCONNECTED','Inbound',5003)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('DISENROLLED','Inbound',5015)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('HANGUP','Inbound',5017)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('INCORRECTNUMBER','Inbound',5002)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('LANGUAGEBARRIER','Inbound',5016)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('MACHINEANSWERED','Inbound',5007)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('NOANSWER','Inbound',5004)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('NOOPTIN','Inbound',5017)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('PARTIALSURVEY','Inbound',8888)
INSERT INTO dbo.[VRT_CallOutcomeEventCodeMap_West](CallOutcome,CallType,EventId) VALUES('SCHEDULECALLBACK','Inbound',5009)



