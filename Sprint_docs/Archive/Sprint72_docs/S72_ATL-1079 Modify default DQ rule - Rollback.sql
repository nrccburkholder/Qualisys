/*

S72_ATL-1079 Modify  DQ rule - Rollback.sql

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

use [qp_prod]
go

update dbo.DefaultCriteriaStmt set strCriteriaString = 
--select strCriteriaString,
replace(convert(nvarchar(max),strCriteriaString), ')', 'AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 NOT IN ("G0104","G0105","G0121","G0260") ) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 NOT IN ("G0104","G0105","G0121","G0260")  AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL) OR (ENCOUNTERCPT_Srg_Cd_Valid = "0" AND ENCOUNTERHCPCSLvl2Cd IS NULL AND ENCOUNTERHCPCSLvl2Cd_2 IS NULL AND ENCOUNTERHCPCSLvl2Cd_3 IS NULL)')
from dbo.DefaultCriteriaStmt
where strCriteriaSTMT_NM = 'DQ_SrgCd'

DELETE
--select *
  FROM [dbo].[DefaultCriteriaStmt_Removed]
	where strCriteriaSTMT_NM = 'DQ_SrgCd'

INSERT INTO [dbo].[DefaultCriteriaClause] 
           ([DefaultCriteriaStmt_id]
           ,[CriteriaPhrase_id]
           ,[strTable_nm]
           ,[Field_id]
           ,[intOperator]
           ,[strLowValue]
           ,[strHighValue])
SELECT DISTINCT [DefaultCriteriaStmt_id]
      ,[CriteriaPhrase_id]
      ,[strTable_nm]
      ,[Field_id]
      ,[intOperator]
      ,[strLowValue]
      ,[strHighValue]
  FROM [dbo].[DefaultCriteriaClause_Removed] where DefaultCriteriaStmt_id in
	(select DefaultCriteriaStmt_id from dbo.DefaultCriteriaStmt where strCriteriaSTMT_NM = 'DQ_SrgCd')
	and (intOperator <> 1 or CriteriaPhrase_id <> 1)

delete dbo.DefaultCriteriaClause_Removed 
--select *
from dbo.DefaultCriteriaClause_Removed dcc
	inner join dbo.DefaultCriteriaStmt dcs on dcc.DefaultCriteriaStmt_id = dcs.DefaultCriteriaStmt_id
	where dcs.strCriteriaSTMT_NM = 'DQ_SrgCd' 

declare @DefaultCriteriaClauseId int = -1

while 1=1
begin
	select @DefaultCriteriaClauseId = min(dcc.DefaultCriteriaClause_id) from DefaultCriteriaClause dcc
	inner join DefaultCriteriaStmt dcs on dcs.DefaultCriteriaStmt_id = dcc.DefaultCriteriaStmt_id
	where strCriteriaStmt_nm = 'DQ_SrgCd' and dcc.intOperator = 11 
		and dcc.DefaultCriteriaClause_id > @DefaultCriteriaClauseId
	
	if @DefaultCriteriaClauseId is null
		break

	insert into DefaultCriteriaInList (DefaultCriteriaClause_ID, strListValue)
	Values  (@DefaultCriteriaClauseId, 'G0104'),
			(@DefaultCriteriaClauseId, 'G0105'),
			(@DefaultCriteriaClauseId, 'G0121'),
			(@DefaultCriteriaClauseId, 'G0260')
end

GO