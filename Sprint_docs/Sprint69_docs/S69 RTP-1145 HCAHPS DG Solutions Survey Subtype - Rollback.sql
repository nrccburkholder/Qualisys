/*
S69 RTP-1145 HCAHPS DG Solutions Survey Subtype - Rollback.sql

Chris Burkholder

2/13/2017

INSERT INTO Subtype
INSERT INTO SurveyTypeSubtype

select * from surveysubtype
select * from subtype
select * from surveytypesubtype
select * from subtypecategory
*/
USE [QP_Prod]
GO

declare @RT int 
select @RT = Subtype_id from subtype where subtype_nm = 'RT'

delete from SurveyTypeSubType
where SurveyType_id=2 and Subtype_id=@RT

delete from subtype 
where Subtype_id=@RT

GO

/****** Object:  Trigger [dbo].[tr_MailingStep_ExpireFromStep]    Script Date: 1/31/2017 11:19:26 AM ******/
/*
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER TRIGGER [dbo].[tr_MailingStep_ExpireFromStep] ON [dbo].[MAILINGSTEP] 
FOR INSERT
AS

IF exists (SELECT 1 FROM Inserted where ExpireFromStep IS NULL) 
UPDATE ms
SET ms.ExpireFromStep=i.MailingStep_id
FROM MailingStep ms, Inserted i
WHERE i.MailingStep_id=ms.MailingStep_id

GO
*/