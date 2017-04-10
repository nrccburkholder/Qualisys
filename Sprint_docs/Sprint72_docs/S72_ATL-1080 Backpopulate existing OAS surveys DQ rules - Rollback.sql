/*

S72_ATL-1080 Backpopulate existing OAS surveys DQ rules - Rollback.sql

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

update dbo.CriteriaStmt set strCriteriaString = 
--select strCriteriaString,
replace(convert(nvarchar(max),strCriteriaString), ')', ' AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL)')
from dbo.CriteriaStmt
where strCriteriaSTMT_NM = 'DQ_SrgCd'

INSERT INTO [dbo].[CRITERIACLAUSE]
           ([CRITERIAPHRASE_ID]
           ,[CRITERIASTMT_ID]
           ,[TABLE_ID]
           ,[FIELD_ID]
           ,[INTOPERATOR]
           ,[STRLOWVALUE]
           ,[STRHIGHVALUE])
select dcc.[CRITERIAPHRASE_ID]
           ,cc.[CRITERIASTMT_ID]
           ,cc.[TABLE_ID]
           ,dcc.[FIELD_ID]
           ,dcc.[INTOPERATOR]
           ,dcc.[STRLOWVALUE]
           ,dcc.[STRHIGHVALUE]
from dbo.DefaultCriteriaClause_Removed dcc
	inner join dbo.DefaultCriteriaStmt dcs on dcc.DefaultCriteriaStmt_id = dcs.DefaultCriteriaStmt_id
	inner join dbo.CriteriaStmt cs on cs.strCriteriaStmt_Nm = dcs.strCriteriaStmt_NM
	inner join dbo.CriteriaClause cc on cs.CRITERIASTMT_ID = cc.CRITERIASTMT_ID and dcc.CriteriaPhrase_ID = cc.CriteriaPhrase_ID
	where dcs.strCriteriaSTMT_NM = 'DQ_SrgCd' and cc.INTOPERATOR = 1 and cc.CRITERIAPHRASE_ID = 1 

INSERT INTO [dbo].[CRITERIAINLIST]
           ([CRITERIACLAUSE_ID]
           ,[STRLISTVALUE])
select distinct cc.[CRITERIACLAUSE_ID]
           ,[STRLISTVALUE]
from dbo.DefaultCriteriaInList dci 
	inner join dbo.DefaultCriteriaClause dcc on dci.DefaultCriteriaClause_id = dcc.DefaultCriteriaClause_id
	inner join dbo.DefaultCriteriaStmt dcs on dcc.DefaultCriteriaStmt_id = dcs.DefaultCriteriaStmt_id
	inner join dbo.CriteriaStmt cs on cs.strCriteriaStmt_Nm = dcs.strCriteriaStmt_NM
	inner join dbo.CriteriaClause cc on cs.CRITERIASTMT_ID = cc.CRITERIASTMT_ID and dcc.CriteriaPhrase_ID = cc.CriteriaPhrase_ID
where dcs.strCriteriaSTMT_NM = 'DQ_SrgCd' and dcc.intOperator = 11
