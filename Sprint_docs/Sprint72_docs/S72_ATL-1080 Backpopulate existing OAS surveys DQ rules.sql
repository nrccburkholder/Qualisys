/*

S72_ATL-1080 Backpopulate existing OAS surveys DQ rules.sql

Chris Burkholder

4/10/2017

DELETE CriteriaInList
DELETE CriteriaClause
UPDATE CriteriaStmt

select * from dbo.CriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd'

select * from dbo.CriteriaClause where CriteriaStmt_id in
(select CriteriaStmt_id from dbo.CriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd')

select * from dbo.CriteriaInList where CriteriaClause_id in 
(select CriteriaClause_id from dbo.CriteriaClause where CriteriaStmt_id in
(select CriteriaStmt_id from dbo.CriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd'))

*/

delete 
--select *
from dbo.CriteriaInList where CriteriaClause_id in 
(select CriteriaClause_id from dbo.CriteriaClause where CriteriaStmt_id in
(select CriteriaStmt_id from dbo.CriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd'))

delete 
--select *
from dbo.CriteriaClause where CriteriaStmt_id in
(select CriteriaStmt_id from dbo.CriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd')
and intOperator <> 1

update dbo.CriteriaStmt set strCriteriaString = 
--select strCriteriaString,
replace(convert(nvarchar(max),strCriteriaString), ' AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL)', ')')
from dbo.CriteriaStmt
where strCriteriaSTMT_NM = 'DQ_SrgCd'
