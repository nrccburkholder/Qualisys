-- ===========================================================
--	Copyright c National Research Corporation
--	Author:				Dave Gilsfdorf
--	Create Date:		00-00-0000
--	Routine Name:		qp_rep_HCMGUsageForAllUsersPWD
--	Description:			This routine returns the list of HCMG user 
--							profile for the wanted year.
--    
-- Parameters:    
--   Name            	Type  			Description
--   -----				----				----------- 
--   @startdate 		datetime			Start date
--   @enddate 		datetime			End date
--   @HCMGYear 		varchar(4)		HCMG Year
--    
--	Return Data:    
--		Fieldname			Type		Description
--		---------			----		-----------
--		ClientUser_id		int			Client user ID
--		Client_id				int			Client ID
--		strClient_nm		string		Client name
--		ParentLogin			string		Parent log in name
--		USRLogin			varchar	User log in name
--		USRPWD				varchar	User password
--		USRFName			string		User first name
--		USRLName			string		User last name
--		USRTitle				string		User title
--		USRDegree			string		User degree
--		USRPosition			string		User position
--		USRDepartment	string		User department
--		USRPhone			varchar	User phone
--		USRFax				varchar	User fax
--		USRAddress			varchar	User address
--		USRCity				varchar	User city
--		USRState			string		User state
--		USRZip				varchar	User zip code
--		USREmail				varchar	User email
--		CreationDate		datetime	Date created
--		RetiredDate			datetime	Date expired
--		intTotalMinutes 	int			Total time
-- ===========================================================
-- Revision
-- 10-26-2004	SH			Added privilege_id of 1412 (year 2004)
-- 02-01-2005	SH 		Added additional user profile such as title, degree, position, 
--								department, phone, fax, address to the report.
-- 07-12-2005	SH			Changed NRC16 to Medusa.
-- 09-30-2005 SH		Added privilege_id of 1415
-- 08-31-2006 SH		Added privilege_id of 1424
-- 02-05-2007 RUFFIN	Changed Medusa to HCMG
-- 08-15-2007 SH		Added Privilege_id of 1425 for year 2007.
-- ===========================================================
CREATE PROCEDURE [dbo].[qp_rep_HCMGUsageForAllUsersPWD]
@startdate DATETIME, @enddate DATETIME, @HCMGYear VARCHAR(4)
AS
SELECT cu_31_1.clientuser_id, c_31.client_id, c_31.strclient_nm, cu_31_2.strLogin_Nm AS ParentLogin, 
cu_31_1.strLogin_nm AS USRLogin, 
cu_31_1.strPassword AS USRPWD, cu_31_1.strFirstName AS USRFName, cu_31_1.strLastName AS USRLName,
cu_31_1.strTitle AS USRTitle, cu_31_1.strDegree AS USRDegree, cu_31_1.strPosition AS USRPosition,
cu_31_1.strDepartment AS USRDepartment, cu_31_1.strPhone AS USRPhone, cu_31_1.strFax AS USRFax, 
cu_31_1.strStreet AS USRAddress, cu_31_1.strCity AS USRCity, cu_31_1.strState AS USRState, cu_31_1.strZIP AS USRZIP,
cu_31_1.strEmail AS USREmail, cu_31_1.datCreation AS CreationDate, CASE WHEN IsNull(cu_31_1.datRetired,'3000-01-01') <= 
IsNull(cu_31_2.datRetired,'3000-01-01') and IsNull(cu_31_1.datRetired,'3000-01-01') <= 
IsNull(c_31.datRemoved,'3000-01-01') then cu_31_1.datRetired when IsNull(cu_31_2.datRetired,'3000-01-01') <= 
IsNull(cu_31_1.datRetired,'3000-01-01') and IsNull(cu_31_2.datRetired,'3000-01-01') <= 
IsNull(c_31.datRemoved,'3000-01-01') then cu_31_2.datRetired when IsNull(c_31.datRemoved,'3000-01-01') <= 
IsNull(cu_31_1.datRetired,'3000-01-01') and IsNull(c_31.datRemoved,'3000-01-01') <= 
IsNull(cu_31_2.datRetired,'3000-01-01') then c_31.datRemoved else cu_31_1.datRetired end
as RetiredDate
into #clientusers
from ((HCMG.WebAccounts.dbo.clientuser as cu_31_1 left join HCMG.WebAccounts.dbo.client as c_31 on 
cu_31_1.client_id = c_31.client_id) left join HCMG.WebAccounts.dbo.clientuser as cu_31_2 on 
cu_31_1.parentClientUser_id = cu_31_2.clientUser_id), HCMG.HCMG_dev.dbo.client_marketyear cmy
where (cu_31_1.clientuser_id in (select distinct clientuser_id from 
HCMG.WebAccounts.dbo.clientuserprivilege where privilege_id in (1, 2, 3, 4, 5, 1412, 1415, 1424, 1425))
) and cu_31_1.client_id=cmy.client_id
and cmy.datyear=@HCMGYear and cu_31_1.clientuser_id > 0 and c_31.client_id > 10 and c_31.client_id <> 1051
 and c_31.client_id <> 1586 and cu_31_1.intUserType = 4

update #clientusers
set RetiredDate = m.datRevoked
from #clientusers, (select max(IsNull(datRevoked,'3000-01-01')) as datRevoked, cup.clientuser_id from 
HCMG.Webaccounts.dbo.clientuserprivilege cup where Privilege_id in (1,2,3,4,5, 1412, 1415, 1424, 1425) 
group by cup.clientuser_id) m
where #clientusers.clientuser_id = m.clientuser_id and m.datRevoked <> '3000-01-01' and 
m.datRevoked < RetiredDate

delete #clientusers where not (CreationDate < dateadd(day,1,@enddate) and (RetiredDate is null or RetiredDate > @startdate))

select 0 as clientuser_id, *, 0 as sessionNum into #activitylog
from HCMG.HCMG_dev.dbo.activitylog al1 
where datLog between @startdate and dateadd(day,1,@enddate) and client_id > 10  and client_id <> 1051
and client_id <> 1586

update #activitylog set sessionNum = (select count(*) from #activitylog al2 where al2.strSessionID = #activitylog.strsessionID and 
al2.datLog <= #activitylog.datlog and al2.strFunction = 'Login')

update #activitylog set clientuser_id = IsNull(cu.clientuser_id,0)
from #activitylog al left join #clientusers cu on al.client_id = cu.client_id and al.strUserID = cu.USRLogin and 
cu.CreationDate <= datLog and (cu.RetiredDate is null or cu.RetiredDate >= datLog) 

select clientuser_id, strSessionid,sessionNum, min(datlog) as datStart, max(datLog) as datEnd
into #sessions
from #activitylog al
where clientuser_id <> 0
group by clientuser_id,strSessionid,sessionNum

--Kris wanted to add on 3 minutes because we don't know how long the user accessed the last table
select clientuser_id, sum(datediff(second,datstart,datEnd) + 180) / 60 as intTotalMinutes
into #clientusage
from #sessions s 
group by clientuser_id

select c.*, cs.intTotalMinutes
from #clientusers c left join #clientusage cs on c.clientuser_id = cs.clientuser_id
order by c.strclient_nm, c.USRLogin

DROP TABLE #activitylog
DROP TABLE #sessions
DROP TABLE #clientusers
DROP TABLE #clientusage


