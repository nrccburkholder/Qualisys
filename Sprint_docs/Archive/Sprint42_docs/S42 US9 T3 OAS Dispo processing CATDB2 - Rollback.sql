/*
S42 US9 T3 OAS Dispo processing CATDB2.sql

 9 OAS: Dispo Processing
As an OAS-CAHPS vendor, we need to assign the correct final disposition to each record, so that we submit accurate data
See x-walk document in BA folder on SP. Acceptance: Records get default ""no response"" dispo when samplepops ETL'd. 
All dispositions are evaluated against the hierarchy and assigned correctly. Completeness is accurately evaluated per 
OAS guidelines. The disposition tables in Catalyst and QP_Prod are updated. (see script from story 32.22 for PQRS) 
Need before returns come back (firsts mailing BY 2/21) (date is off-cycle) 

Task 3 - Insert records into catalyst disposition mapping tables

Chris Burkholder

2/5/2016

NRC_Datamart:
insert into CahpsDispositionMapping 
insert into CahpsDisposition
*/

use [NRC_Datamart]

GO

begin tran

select * from CAHPSDisposition where CahpsTypeID=9

select * from CahpsDispositionMapping where CahpsTypeID=9

delete
--select * 
from CahpsDispositionMapping where CahpsTypeID=9

delete
--select * 
from CAHPSDisposition where CahpsTypeID=9 --and CahpsDispositionid >= 900 and CahpsDispositionId < 1000

select * from CAHPSDisposition where CahpsTypeID=9

select * from CahpsDispositionMapping where CahpsTypeID=9

--update CAHPSDisposition set IsCahpsDispositionComplete = 1 where CahpsDispositionID = 902

--rollback tran
commit tran

