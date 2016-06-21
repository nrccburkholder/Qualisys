/*

S36.US10.T4 NRCAuth Application Update URL.sql
			
10 NRCAuth / Change request for click-once move ---- 

As an Atlas user I want to create a step-by-step plan for moving 
the click-once updates to production and create the change ticket 
so that we can move just it without the rest of the NRCAuth updates 
NOTES: deal with desktop shortcut 				

Task 2 - document steps, including script to update NRC Auth database applications table 

Chris Burkholder 

UPDATE Application
*/


use nrcauth
go
/* 
--TEST
update application set strPath = 
--select
'http:/' + Replace(Replace(strPath,'\Superman\NRCApplications','TestNRCApplications'),'\','/')
from application where strPath like '%Superman\NRCApplications%'

update application set strPath = 
--select 
'http:' + Replace(Replace(strPath, 'TestNRCApplications\NRCApplications', 'TestNRCApplications'),'\','/')
from application where strPath like '%\\TestNRCApplications%'

update application set strPath = 
--select
Replace(strpath, 'apbstatus.aspx', 'default.aspx')
from application where strpath like '%apbstatus.aspx%'
*/
/*
-- STAGE
update application set strPath = 
--select
Replace(strPath,'NRCApplications','StageNRCApplications')
from application where strPath like '%Huskers\NRCApplications%'

update application set strPath = 
--select 
Replace(Replace(strPath, 'NRCApplications', 'StageNRCApplications'),'\','/')
from application where strPath like '%/NRCApplications%'

update application set strPath = 
--select
Replace(strpath, 'apbstatus.aspx', 'default.aspx')
from application where strpath like '%apbstatus.aspx%'
*/
-- CANADA STAGE
/*
update application set strPath = 
--select
Replace(strPath,'NRCApplications','StageNRCApplications')
from application where strPath like '%Huskers\NRCApplications%'

update application set strPath = 
--select 
Replace(Replace(strPath, 'NRCApplications', 'StageNRCApplications'),'\','/')
from application where strPath like '%/NRCApplications%'

update application set strPath = 
--select
Replace(strpath, 'apbstatus.aspx', 'default.aspx')
from application where strpath like '%apbstatus.aspx%'
*/
 
--PROD
update application set strPath = 
--select
Replace(Replace(strPath,'QualisysApps/Prod','NRCApplications'),'\','/')
from application where strPath like '%QualisysApps/Prod%'

update application set strPath = 
--select
'http:' + Replace(Replace(strPath,'Mercury\QualisysApps\Prod','NRCApplications'),'\','/')
from application where strPath like '%QualisysApps\Prod%' and strPath like '%application'

update application set strPath =
--select
Replace(strPath,'/corp/','/corp2/')
from application where strPath like '%/corp/%'

--select strpath, * from application where strpath like '%workflow%' or strApplication_nm like '%web%'
--TESTING
--STAGING
--PRODUCTION

--select * from qualisys.qp_prod.dbo.qualpro_params where strparam_nm = 'EnvName'