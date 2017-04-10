/*

S72_ATL-1079 Modify  DQ rule.sql

Chris Burkholder

4/10/2017

DELETE DefaultCriteriaInList
INSERT INTO [dbo].[DefaultCriteriaClause_Removed]
DELETE DefaultCriteriaClause
INSERT INTO [dbo].[DefaultCriteriaStmt_Removed]
UPDATE DefaultCriteriaStmt

select * from dbo.DefaultCriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd'

select * from dbo.DefaultCriteriaClause where DefaultCriteriaStmt_id in
(select DefaultCriteriaStmt_id from dbo.DefaultCriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd')

select * from dbo.DefaultCriteriaInList where DefaultCriteriaClause_id in 
(select DefaultCriteriaClause_id from dbo.DefaultCriteriaClause where DefaultCriteriaStmt_id in
(select DefaultCriteriaStmt_id from dbo.DefaultCriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd'))

*/

delete 
--select *
from dbo.DefaultCriteriaInList where DefaultCriteriaClause_id in 
(select DefaultCriteriaClause_id from dbo.DefaultCriteriaClause where DefaultCriteriaStmt_id in
(select DefaultCriteriaStmt_id from dbo.DefaultCriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd'))

INSERT INTO [dbo].[DefaultCriteriaClause_Removed]
           ([DefaultCriteriaClause_id]
           ,[DefaultCriteriaStmt_id]
           ,[CriteriaPhrase_id]
           ,[strTable_nm]
           ,[Field_id]
           ,[intOperator]
           ,[strLowValue]
           ,[strHighValue])
SELECT [DefaultCriteriaClause_id]
      ,[DefaultCriteriaStmt_id]
      ,[CriteriaPhrase_id]
      ,[strTable_nm]
      ,[Field_id]
      ,[intOperator]
      ,[strLowValue]
      ,[strHighValue]
  FROM [dbo].[DefaultCriteriaClause] where DefaultCriteriaStmt_id in
	(select DefaultCriteriaStmt_id from dbo.DefaultCriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd')
	and (intOperator <> 1 or CriteriaPhrase_id <> 1)

delete 
--select *
from dbo.DefaultCriteriaClause where DefaultCriteriaStmt_id in
(select DefaultCriteriaStmt_id from dbo.DefaultCriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd')
and (intOperator <> 1 or CriteriaPhrase_id <> 1)

INSERT INTO [dbo].[DefaultCriteriaStmt_Removed]
           ([DefaultCriteriaStmt_id]
           ,[strCriteriaStmt_nm]
           ,[strCriteriaString]
           ,[BusRule_cd])
SELECT [DefaultCriteriaStmt_id]
      ,[strCriteriaStmt_nm]
      ,[strCriteriaString]
      ,[BusRule_cd]
  FROM [dbo].[DefaultCriteriaStmt]
	where strCriteriaSTMT_NM = 'DQ_SrgCd'

update dbo.DefaultCriteriaStmt set strCriteriaString = 
--select strCriteriaString,
replace(convert(nvarchar(max),strCriteriaString), 'AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL)', ')')
from dbo.DefaultCriteriaStmt
where strCriteriaSTMT_NM = 'DQ_SrgCd'
