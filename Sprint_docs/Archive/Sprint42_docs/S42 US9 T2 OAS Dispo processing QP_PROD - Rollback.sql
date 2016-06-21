/*
S42 US9 T2 OAS Dispo processing QP_PROD.sql

 9 OAS: Dispo Processing
As an OAS-CAHPS vendor, we need to assign the correct final disposition to each record, so that we submit accurate data
See x-walk document in BA folder on SP. Acceptance: Records get default ""no response"" dispo when samplepops ETL'd. 
All dispositions are evaluated against the hierarchy and assigned correctly. Completeness is accurately evaluated per 
OAS guidelines. The disposition tables in Catalyst and QP_Prod are updated. (see script from story 32.22 for PQRS) 
Need before returns come back (firsts mailing BY 2/21) (date is off-cycle) 

Task 2 - Insert records into survey type dispositions in qp_prod 

Chris Burkholder

2/5/2016

*/

use [QP_Prod]

GO

begin tran


select * from SurveyTypeDispositions
where SurveyType_id = 16


delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 8

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 3

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 4

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 10

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 26

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 2

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 19

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 20

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 49

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 11

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 14

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 16

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 5

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 12

delete
--select * 
from SurveyTypeDispositions where SurveyType_id = 16 and Disposition_ID = 25

select * from SurveyTypeDispositions
where SurveyType_id = 16

--rollback tran
commit tran
