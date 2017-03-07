/*

S69 RTP-1471 set up Qualisys methodology for mail vendor - Rollback.sql

Chris Burkholder

February 24, 2017

INSERT MAILINGSTEPMETHOD
INSERT STANDARDMETHODOLOGY
INSERT STANDARDMETHODOLOGYBYSURVEYTYPE
INSERT METHODOLOGYSTEPTYPE
INSERT STANDARDMAILINGSTEP

*/

USE [QP_Prod]
GO

BEGIN TRAN

delete from StandardMailingStep where strMailingStep_nm in
('1st Svy Vendor Mail','2nd Svy Vendor Mail')

delete from MethodologyStepType where strMailingStep_nm in
('1st Svy Vendor Mail','2nd Svy Vendor Mail')

declare @VendorMailStandardMethodology int 

select @VendorMailStandardMethodology = StandardMethodologyID
from StandardMethodology 
where strStandardMethodology_nm = 'HCAHPS + RT Mail Only'

delete from StandardMethodologyBySurveyType
where StandardMethodologyID = @VendorMailStandardMethodology

delete from StandardMethodology 
where StandardMethodologyID = @VendorMailStandardMethodology

delete from MailingStepMethod
where MailingStepMethod_nm = 'Vendor Mail'


declare @maxseed int
select @maxseed=max(MailingStepMethod_id) from MAILINGSTEPMETHOD
DBCC CHECKIDENT ('dbo.MAILINGSTEPMETHOD', RESEED, @maxseed);  

select @maxseed=max(StandardMethodologyID) from StandardMethodology
DBCC CHECKIDENT ('dbo.StandardMethodology', RESEED, @maxseed);  

select @maxseed=max(MethodologyStepTypeId) from MethodologyStepType
DBCC CHECKIDENT ('dbo.MethodologyStepType', RESEED, @maxseed);  

select @maxseed=max(StandardMailingStepID) from StandardMailingStep
DBCC CHECKIDENT ('dbo.StandardMailingStep', RESEED, @maxseed);  


select * from StandardMethodology where StandardMethodologyID = @VendorMailStandardMethodology
select * from StandardMethodologyBySurveyType where StandardMethodologyID = @VendorMailStandardMethodology
select * from MethodologyStepType 
select * from StandardMailingStep where StandardMethodologyID = @VendorMailStandardMethodology
select * from MailingStepMethod 

COMMIT TRAN

GO