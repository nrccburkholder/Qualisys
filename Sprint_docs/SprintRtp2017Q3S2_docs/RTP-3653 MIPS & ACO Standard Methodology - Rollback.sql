/*
	RTP-3653 MIPS & ACO Standard Methodology - rollback.sql

	Chris Burkholder

	8/16/2017

	select * from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone','ACO-PQRS Mixed Mail-Phone','ACO-MIPS Mixed Mail-Phone')
	select * from standardmailingstep where standardMethodologyid in (select standardmethodologyid from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone','ACO-PQRS Mixed Mail-Phone','ACO-MIPS Mixed Mail-Phone'))
	select * from StandardMethodologyBySurveyType where StandardMethodologyID in (select StandardMethodologyID from standardmethodology where strStandardMethodology_nm in ('ACO Mixed Mail-Phone','PQRS Mixed Mail-Phone','ACO-PQRS Mixed Mail-Phone','ACO-MIPS Mixed Mail-Phone'))
*/

USE [QP_PROD]
GO

begin tran

----------------------- RTP-3653 MIPS & ACO Standard Methodology ----------------------

declare @ACOPQRS int, @newACOMIPS int

select @ACOPQRS = StandardMethodologyID from StandardMethodology where strStandardMethodology_nm = 'ACO-PQRS Mixed Mail-Phone'

	select * from StandardMethodology where strStandardMethodology_nm in ('ACO-PQRS Mixed Mail-Phone', 'ACO-MIPS Mixed Mail-Phone')

select @newACOMIPS = max(StandardMethodologyID) from StandardMethodology where strStandardMethodology_nm = 'ACO-MIPS Mixed Mail-Phone'

delete from StandardMethodology where StandardMethodologyID = @newACOMIPS

delete from StandardMethodologyBySurveyType where StandardMethodologyID = @newACOMIPS

update StandardMethodologyBySurveyType set bitExpired = 0 where StandardMethodologyID in (@ACOPQRS)

	select * from StandardMethodologyBySurveyType where StandardMethodologyID in (@ACOPQRS, @newACOMIPS)

delete from StandardMailingStep where StandardMethodologyID = @newACOMIPS

	select * from StandardMailingStep where StandardMethodologyID = @newACOMIPS

DECLARE @maxID INT  
SELECT @maxID = MAX(StandardMethodologyId) FROM StandardMethodology
DBCC CHECKIDENT ('StandardMethodology', RESEED, @maxID);  

SELECT @maxID = MAX(StandardMailingStepId) FROM StandardMailingStep
DBCC CHECKIDENT ('StandardMailingStep', RESEED, @maxID);
--rollback tran
commit tran

GO