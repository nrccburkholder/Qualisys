/*

S34.US10.T2 NRCAuth Application Update URL
			
			 	As the Atlas team we want to move click once files to 
				their own drive so that we are consistent across environments.
				
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
*/

-- STAGE
update application set strPath = 
--select
Replace(strPath,'NRCApplications','StageNRCApplications')
from application where strPath like '%Huskers\NRCApplications%'

update application set strPath = 
--select 
Replace(Replace(strPath, 'NRCApplications', 'StageNRCApplications'),'\','/')
from application where strPath like '%/NRCApplications%'

/* 
--PROD
update application set strPath = 
--select
Replace(Replace(strPath,'QualisysApps/Prod','NRCApplications'),'\','/')
from application where strPath like '%QualisysApps/Prod%'

update application set strPath = 
--select
'http:' + Replace(Replace(strPath,'Mercury\QualisysApps\Prod','NRCApplications'),'\','/')
from application where strPath like '%QualisysApps\Prod%' and strPath like '%application'
*/

--select strpath from application
--TESTING
--STAGING
--PRODUCTION

--select * from qualisys.qp_prod.dbo.qualpro_params where strparam_nm = 'EnvName'