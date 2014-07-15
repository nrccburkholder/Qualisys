use qp_prod
go
/*
select * from surveytype
select * from sys.tables where name like '%criter%'
select * from sys.procedures where name like '%InsertCriteriaStmt%'

exec sp_help CRITERIASTMT
exec sp_help CRITERIACLAUSE
exec sp_help CRITERIAINLIST

exec sp_helptext qcl_InsertCriteriaStmt
exec sp_helptext qcl_InsertBusinessRule
exec sp_helptext qcl_InsertDefaultCriteriaClause
exec sp_helptext qcl_InsertCriteriaInValue	

*/

if exists (select * from sys.tables where schema_id=1 and name = 'SurveyTypeDefaultCriteria')
	drop table dbo.SurveyTypeDefaultCriteria 

if exists (select * from sys.tables where schema_id=1 and name = 'DefaultCriteriaStmt')
	drop table dbo.DefaultCriteriaStmt 

if exists (select * from sys.tables where schema_id=1 and name = 'DefaultCriteriaClause')
	drop table dbo.DefaultCriteriaClause

if exists (select * from sys.tables where schema_id=1 and name = 'DefaultCriteriaInList')
	drop table dbo.DefaultCriteriaInList 
	
drop procedure #NewDefaultDQ
drop procedure #NewSurveyTypeDefaultCriteria
go
create table dbo.SurveyTypeDefaultCriteria (SurveyTypeDefaultCriteria int identity (1,1)
	, SurveyType_id int
	, Country_id int
	, DefaultCriteriaStmt_id int
	)

create table dbo.DefaultCriteriaStmt (DefaultCriteriaStmt_id int identity(1,1)
	, strCriteriaStmt_nm char(8)
	, strCriteriaString varchar(7000)
	, BusRule_cd char(1) 
	)

create table dbo.DefaultCriteriaClause (DefaultCriteriaClause_id int identity(1,1)
	, DefaultCriteriaStmt_id int
	, CriteriaPhrase_id int
	, strTable_nm varchar(20)
	, Field_id int
	, intOperator int
	, strLowValue varchar(42)
	, strHighValue varchar(42)
	)

create table dbo.DefaultCriteriaInList (DefaultCriteriaInList_id int identity(1,1)
	, DefaultCriteriaClause_id int
	, strListValue varchar(42)
	)

go
create procedure #NewDefaultDQ (@CritSt_nm char(8), @CritString varchar(7000), @BusRule_cd char(1)
	, @Part1Phrase int, @Part1Table_nm varchar(20), @Part1Field_id int, @Part1Operator_id int, @Part1LowVal varchar(42), @Part1HighVal varchar(42), @Part1In varchar(2000)
	, @Part2Phrase int = -1, @Part2Table_nm varchar(20) = '', @Part2Field_id int = -1, @Part2Operator_id int = -1, @Part2LowVal varchar(42) = '', @Part2HighVal varchar(42) = '', @Part2In varchar(2000) = ''
	, @Part3Phrase int = -1, @Part3Table_nm varchar(20) = '', @Part3Field_id int = -1, @Part3Operator_id int = -1, @Part3LowVal varchar(42) = '', @Part3HighVal varchar(42) = '', @Part3In varchar(2000) = ''
	, @Part4Phrase int = -1, @Part4Table_nm varchar(20) = '', @Part4Field_id int = -1, @Part4Operator_id int = -1, @Part4LowVal varchar(42) = '', @Part4HighVal varchar(42) = '', @Part4In varchar(2000) = ''
	, @Part5Phrase int = -1, @Part5Table_nm varchar(20) = '', @Part5Field_id int = -1, @Part5Operator_id int = -1, @Part5LowVal varchar(42) = '', @Part5HighVal varchar(42) = '', @Part5In varchar(2000) = ''
	, @Part6Phrase int = -1, @Part6Table_nm varchar(20) = '', @Part6Field_id int = -1, @Part6Operator_id int = -1, @Part6LowVal varchar(42) = '', @Part6HighVal varchar(42) = '', @Part6In varchar(2000) = ''
	)
as
Declare @CritSt_id int, @CritClause_id int

if exists (select *
		from dbo.DefaultCriteriaStmt
		where rtrim(strCriteriaStmt_nm)+'.'+strCriteriaString = rtrim(left(@CritSt_nm,8))+'.'+@CritString)
begin
	print 'Rule "'+rtrim(left(@CritSt_nm,8))+'.'+@CritString+'" already exists. Aborting'
	return
end

insert into dbo.DefaultCriteriaStmt (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) values (@CritSt_nm, @CritString, @BusRule_cd)
set @CritSt_id = scope_identity()

insert into dbo.DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
values (@CritSt_id, @Part1Phrase, @Part1Table_nm, @Part1Field_id, @Part1Operator_id, @Part1LowVal, @Part1HighVal)

set @CritClause_id = scope_identity()

if @Part1Operator_id in (7,12)
begin
	insert into dbo.DefaultCriteriaInList (DefaultCriteriaClause_id, strListValue)
	select @CritClause_id, items
	from dbo.split(@Part1In,',')
end

if @Part2Field_id<>-1
begin
	insert into dbo.DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
	values (@CritSt_id, @Part2Phrase, @Part2Table_nm, @Part2Field_id, @Part2Operator_id, @Part2LowVal, @Part2HighVal)

	set @CritClause_id = scope_identity()

	if @Part2Operator_id in (7,12)
	begin
		insert into dbo.DefaultCriteriaInList (DefaultCriteriaClause_id, strListValue)
		select @CritClause_id, items
		from dbo.split(@Part2In,',')
	end
end

if @Part3Field_id<>-1
begin
	insert into dbo.DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
	values (@CritSt_id, @Part3Phrase, @Part3Table_nm, @Part3Field_id, @Part3Operator_id, @Part3LowVal, @Part3HighVal)

	set @CritClause_id = scope_identity()

	if @Part3Operator_id in (7,12)
	begin
		insert into dbo.DefaultCriteriaInList (DefaultCriteriaClause_id, strListValue)
		select @CritClause_id, items
		from dbo.split(@Part3In,',')
	end
end

if @Part4Field_id<>-1
begin
	insert into dbo.DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
	values (@CritSt_id, @Part4Phrase, @Part4Table_nm, @Part4Field_id, @Part4Operator_id, @Part4LowVal, @Part4HighVal)

	set @CritClause_id = scope_identity()

	if @Part4Operator_id in (7,12)
	begin
		insert into dbo.DefaultCriteriaInList (DefaultCriteriaClause_id, strListValue)
		select @CritClause_id, items
		from dbo.split(@Part4In,',')
	end
end

if @Part5Field_id<>-1
begin
	insert into dbo.DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
	values (@CritSt_id, @Part5Phrase, @Part5Table_nm, @Part5Field_id, @Part5Operator_id, @Part5LowVal, @Part5HighVal)

	set @CritClause_id = scope_identity()

	if @Part5Operator_id in (7,12)
	begin
		insert into dbo.DefaultCriteriaInList (DefaultCriteriaClause_id, strListValue)
		select @CritClause_id, items
		from dbo.split(@Part5In,',')
	end
end

if @Part6Field_id<>-1
begin
	insert into dbo.DefaultCriteriaClause (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
	values (@CritSt_id, @Part6Phrase, @Part6Table_nm, @Part6Field_id, @Part6Operator_id, @Part6LowVal, @Part6HighVal)

	set @CritClause_id = scope_identity()

	if @Part6Operator_id in (7,12)
	begin
		insert into dbo.DefaultCriteriaInList (DefaultCriteriaClause_id, strListValue)
		select @CritClause_id, items
		from dbo.split(@Part6In,',')
	end
end

go
create procedure #NewSurveyTypeDefaultCriteria 
  @SurveyType_id int
, @US char(1)
, @CN char(1)
, @RuleLookup varchar(1000)
as
begin
declare @CritSt_id int

select @CritSt_id = DefaultCriteriaStmt_id 
from dbo.DefaultCriteriaStmt
where rtrim(strCriteriaStmt_nm)+'.'+strCriteriaString = @RuleLookup

if @CritSt_id is null
begin
	print 'Can''t find "'+@ruleLookup+'." Aborting.'
	return
end

if @surveytype_id=0
begin
	if @US='X'
	begin
		insert into dbo.SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
		values (1, 1, @CritSt_id)
		insert into dbo.SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
		values (4, 1, @CritSt_id)
	end
	if @CN='X'
		insert into dbo.SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
		values (7, 2, @CritSt_id)
end
else
begin
	if @US='X'
		insert into dbo.SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
		values (@SurveyType_id, 1, @CritSt_id)
	if @CN='X'
		insert into dbo.SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id)
		values (@SurveyType_id, 2, @CritSt_id)
end

end
go
exec #NewDefaultDQ 'DQ_L Nm','(POPULATIONLName IS NULL)', 'Q', 1, 'POPULATION', 6,9,'NULL','',''
exec #NewDefaultDQ 'DQ_F Nm','(POPULATIONFName IS NULL)', 'Q', 1, 'POPULATION', 7,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Addr','(POPULATIONADDR IS NULL)', 'Q', 1, 'POPULATION', 9,9,'NULL','',''
exec #NewDefaultDQ 'DQ_City','(POPULATIONCITY IS NULL)', 'Q', 1, 'POPULATION', 10,9,'NULL','',''
exec #NewDefaultDQ 'DQ_ST','(POPULATIONST IS NULL)', 'Q', 1, 'POPULATION', 11,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Zip5','(POPULATIONZIP5 IS NULL)', 'Q', 1, 'POPULATION', 12,9,'NULL','',''
exec #NewDefaultDQ 'DQ_PROV','(POPULATIONProvince IS NULL)', 'Q', 1, 'POPULATION', 1120,9,'NULL','',''
exec #NewDefaultDQ 'DQ_PstCd','(POPULATIONPostal_Code IS NULL)', 'Q', 1, 'POPULATION', 1121,9,'NULL','',''
exec #NewDefaultDQ 'DQ_DOB','(POPULATIONDOB IS NULL)', 'Q', 1, 'POPULATION', 13,9,'NULL','',''
exec #NewDefaultDQ 'DQ_AGE','(POPULATIONAge IS NULL) OR (POPULATIONAGE < 0)', 'Q', 1, 'POPULATION', 16,9,'NULL','',''
,2, 'POPULATION', 16,5,'0','',''
exec #NewDefaultDQ 'DQ_SEX','(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)', 'Q', 1, 'POPULATION', 14,2,'M','',''
,1, 'POPULATION', 14,2,'F','',''
,2, 'POPULATION', 14,9,'NULL','',''
exec #NewDefaultDQ 'DQ_SEX','(POPULATIONSex IS NULL)', 'Q', 1, 'POPULATION', 14,9,'NULL','',''
--exec #NewDefaultDQ 'DQ_PHONSTAT','(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)', 'Q', 1, 'POPULATION', 133,2,'0','',''
--,1, 'POPULATION', 133,10,'NULL','',''
exec #NewDefaultDQ 'DQ_LangID','(POPULATIONLangID IS NULL)', 'Q', 1, 'POPULATION', 26,9,'NULL','',''
exec #NewDefaultDQ 'DQ_MRN','(POPULATIONMRN IS NULL)', 'Q', 1, 'POPULATION', 1,9,'NULL','',''
exec #NewDefaultDQ 'DQ_MDAE','(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))', 'Q', 1, 'POPULATION', 22,7,'','','NC,TL,FO,NU'



exec #NewDefaultDQ 'DQ_MDAE','(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))', 'Q', 1, 'POPULATION', 22,7,'','','NC,TL,FO,NU'



exec #NewDefaultDQ 'DQ_Dead','(ENCOUNTERHDischargeStatus IN (''20'',"40",''41'',"42"))', 'Q', 1, 'ENCOUNTER', 1209,7,'','','20,40,41,42'



exec #NewDefaultDQ 'DQ_Hospc','(ENCOUNTERHDischargeStatus IN (''50'',''51''))', 'Q', 1, 'ENCOUNTER', 1209,7,'','','50,51'

exec #NewDefaultDQ 'DQ_Law','(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus IN ("21","87") )', 'Q', 1, 'ENCOUNTER', 1208,1,'8','',''
,2, 'ENCOUNTER', 1209,7,'','','21,87'

exec #NewDefaultDQ 'DQ_MDFA','(POPULATIONAddrErr=''FO'')', 'Q', 1, 'POPULATION', 22,1,'FO','',''
exec #NewDefaultDQ 'DQ_SNF','(ENCOUNTERHDischargeStatus IN (''3'',''03'',''61'',''64'',"83","92"))', 'Q', 1, 'ENCOUNTER', 1209,7,'','','3,03,61,64,83,92'





exec #NewDefaultDQ 'DQ_VisMo','(ENCOUNTERHHVisitCnt < 1)', 'Q', 1, 'ENCOUNTER', 1410,5,'1','',''
--exec #NewDefaultDQ 'DQ_VisLk','(ENCOUNTERHHLookbackCnt NOT IN (0,1) )', 'Q', 1, 'ENCOUNTER', 1411,12,'','','0,1'
exec #NewDefaultDQ 'DQ_VisLk','(ENCOUNTERHHLookbackCnt IN (0,1) )', 'Q', 1, 'ENCOUNTER', 1411,7,'','','0,1'

exec #NewDefaultDQ 'DQ_Payer','(ENCOUNTERHHPay_Mcare <> ''1'' AND ENCOUNTERHHPay_Mcaid <> ''1'' AND ENCOUNTERHHPay_Ins = ''1'') OR (ENCOUNTERHHPay_Mcare <> ''1'' AND ENCOUNTERHHPay_Mcaid <> ''1'' AND ENCOUNTERHHPay_Other = ''1'')', 'Q', 1, 'ENCOUNTER', 1418,2,'1','',''
,1, 'ENCOUNTER', 1419,2,'1','',''
,1, 'ENCOUNTER', 1420,1,'1','',''
,2, 'ENCOUNTER', 1418,2,'1','',''
,2, 'ENCOUNTER', 1419,2,'1','',''
,2, 'ENCOUNTER', 1421,1,'1','',''
exec #NewDefaultDQ 'DQ_Age','(ENCOUNTERHHEOMAge < 18)', 'Q', 1, 'ENCOUNTER', 1437,5,'18','',''
exec #NewDefaultDQ 'DQ_Hospc','(ENCOUNTERHHHospice = ''Y'')', 'Q', 1, 'ENCOUNTER', 1440,1,'Y','',''
exec #NewDefaultDQ 'DQ_Mat','(ENCOUNTERHHMaternity = ''Y'')', 'Q', 1, 'ENCOUNTER', 1439,1,'Y','',''
exec #NewDefaultDQ 'DQ_Dead','(ENCOUNTERHHDeceased = ''Y'')', 'Q', 1, 'ENCOUNTER', 1441,1,'Y','',''
exec #NewDefaultDQ 'DQ_NoPub','(ENCOUNTERHHNoPub = ''Y'')', 'Q', 1, 'ENCOUNTER', 1442,1,'Y','',''
exec #NewDefaultDQ 'DQ_L Nm','(POPULATIONLName IS NULL)', 'Q', 1, 'POPULATION', 6,9,'NULL','',''



exec #NewDefaultDQ 'DQ_F Nm','(POPULATIONFName IS NULL)', 'Q', 1, 'POPULATION', 7,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Addr','(POPULATIONADDR IS NULL)', 'Q', 1, 'POPULATION', 9,9,'NULL','',''
exec #NewDefaultDQ 'DQ_City','(POPULATIONCITY IS NULL)', 'Q', 1, 'POPULATION', 10,9,'NULL','',''
exec #NewDefaultDQ 'DQ_ST','(POPULATIONST IS NULL)', 'Q', 1, 'POPULATION', 11,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Zip5','(POPULATIONZIP5 IS NULL)', 'Q', 1, 'POPULATION', 12,9,'NULL','',''
exec #NewDefaultDQ 'DQ_PROV','(POPULATIONProvince IS NULL)', 'Q', 1, 'POPULATION', 1120,9,'NULL','',''
exec #NewDefaultDQ 'DQ_PstCd','(POPULATIONPostal_Code IS NULL)', 'Q', 1, 'POPULATION', 1121,9,'NULL','',''
exec #NewDefaultDQ 'DQ_SEX','(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)', 'Q', 1, 'POPULATION', 14,2,'M','',''
,1, 'POPULATION', 14,2,'F','',''
,2, 'POPULATION', 14,9,'NULL','',''
--exec #NewDefaultDQ 'DQ_PHONSTAT','(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)', 'Q', 1, 'POPULATION', 133,2,'0','',''
--,1, 'POPULATION', 133,10,'NULL','',''
exec #NewDefaultDQ 'DQ_LangID','(POPULATIONLangID IS NULL)', 'Q', 1, 'POPULATION', 26,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Email','(POPULATIONEMAIL_ADDRESS IS NULL)', 'Q', 1, 'POPULATION', 934,9,'NULL','',''
exec #NewDefaultDQ 'DQ_ID','(ENCOUNTERDrID IS NULL AND ENCOUNTERDrNPI IS NULL)', 'Q', 1, 'ENCOUNTER', 38,9,'NULL','',''
,1, 'ENCOUNTER', 1444,9,'NULL','',''
exec #NewDefaultDQ 'DQ_L Nm','(POPULATIONLName IS NULL)', 'Q', 1, 'POPULATION', 6,9,'NULL','',''
exec #NewDefaultDQ 'DQ_F Nm','(POPULATIONFName IS NULL)', 'Q', 1, 'POPULATION', 7,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Addr','(POPULATIONADDR IS NULL)', 'Q', 1, 'POPULATION', 9,9,'NULL','',''
exec #NewDefaultDQ 'DQ_City','(POPULATIONCITY IS NULL)', 'Q', 1, 'POPULATION', 10,9,'NULL','',''
exec #NewDefaultDQ 'DQ_ST','(POPULATIONST IS NULL)', 'Q', 1, 'POPULATION', 11,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Zip5','(POPULATIONZIP5 IS NULL)', 'Q', 1, 'POPULATION', 12,9,'NULL','',''
exec #NewDefaultDQ 'DQ_PROV','(POPULATIONProvince IS NULL)', 'Q', 1, 'POPULATION', 1120,9,'NULL','',''
exec #NewDefaultDQ 'DQ_PstCd','(POPULATIONPostal_Code IS NULL)', 'Q', 1, 'POPULATION', 1121,9,'NULL','',''
exec #NewDefaultDQ 'DQ_SEX','(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)', 'Q', 1, 'POPULATION', 14,2,'M','',''
,1, 'POPULATION', 14,2,'F','',''
,2, 'POPULATION', 14,9,'NULL','',''
--exec #NewDefaultDQ 'DQ_PHONSTAT','(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)', 'Q', 1, 'POPULATION', 133,2,'0','',''
--,1, 'POPULATION', 133,10,'NULL','',''
exec #NewDefaultDQ 'DQ_LangID','(POPULATIONLangID IS NULL)', 'Q', 1, 'POPULATION', 26,9,'NULL','',''
exec #NewDefaultDQ 'DQ_Email','(POPULATIONEMAIL_ADDRESS IS NULL)', 'Q', 1, 'POPULATION', 934,9,'NULL','',''

go
exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_L Nm.(POPULATIONLName IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_F Nm.(POPULATIONFName IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_Addr.(POPULATIONADDR IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_City.(POPULATIONCITY IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', '', 'DQ_ST.(POPULATIONST IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', '', 'DQ_Zip5.(POPULATIONZIP5 IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, '', 'X', 'DQ_PROV.(POPULATIONProvince IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, '', 'X', 'DQ_PstCd.(POPULATIONPostal_Code IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_DOB.(POPULATIONDOB IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_AGE.(POPULATIONAge IS NULL) OR (POPULATIONAGE < 0)'

exec #NewSurveyTypeDefaultCriteria 0, 'X', '', 'DQ_SEX.(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)'


exec #NewSurveyTypeDefaultCriteria 0, '', 'X', 'DQ_SEX.(POPULATIONSex IS NULL)'
--exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_PHONS.(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)'

exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_LangI.(POPULATIONLangID IS NULL)'
exec #NewSurveyTypeDefaultCriteria 0, 'X', 'X', 'DQ_MRN.(POPULATIONMRN IS NULL)'
exec #NewSurveyTypeDefaultCriteria 1, 'X', '', 'DQ_MDAE.(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))'



exec #NewSurveyTypeDefaultCriteria 7, '', 'X', 'DQ_MDAE.(POPULATIONAddrErr IN (''NC'',''TL'',''FO'',''NU''))'



exec #NewSurveyTypeDefaultCriteria 2, 'X', '', 'DQ_Dead.(ENCOUNTERHDischargeStatus IN (''20'',"40",''41'',"42"))'



exec #NewSurveyTypeDefaultCriteria 2, 'X', '', 'DQ_Hospc.(ENCOUNTERHDischargeStatus IN (''50'',''51''))'

exec #NewSurveyTypeDefaultCriteria 2, 'X', '', 'DQ_Law.(ENCOUNTERHAdmissionSource = "8") OR (ENCOUNTERHDischargeStatus IN ("21","87") )'


exec #NewSurveyTypeDefaultCriteria 2, 'X', '', 'DQ_MDFA.(POPULATIONAddrErr=''FO'')'
exec #NewSurveyTypeDefaultCriteria 2, 'X', '', 'DQ_SNF.(ENCOUNTERHDischargeStatus IN (''3'',''03'',''61'',''64'',"83","92"))'





exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_VisMo.(ENCOUNTERHHVisitCnt < 1)'
exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_VisLk.(ENCOUNTERHHLookbackCnt IN (0,1) )'

exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_Payer.(ENCOUNTERHHPay_Mcare <> ''1'' AND ENCOUNTERHHPay_Mcaid <> ''1'' AND ENCOUNTERHHPay_Ins = ''1'') OR (ENCOUNTERHHPay_Mcare <> ''1'' AND ENCOUNTERHHPay_Mcaid <> ''1'' AND ENCOUNTERHHPay_Other = ''1'')'





exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_Age.(ENCOUNTERHHEOMAge < 18)'
exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_Hospc.(ENCOUNTERHHHospice = ''Y'')'
exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_Mat.(ENCOUNTERHHMaternity = ''Y'')'
exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_Dead.(ENCOUNTERHHDeceased = ''Y'')'
exec #NewSurveyTypeDefaultCriteria 3, 'X', '', 'DQ_NoPub.(ENCOUNTERHHNoPub = ''Y'')'
exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_L Nm.(POPULATIONLName IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_F Nm.(POPULATIONFName IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_Addr.(POPULATIONADDR IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_City.(POPULATIONCITY IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', '', 'DQ_ST.(POPULATIONST IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', '', 'DQ_Zip5.(POPULATIONZIP5 IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, '', 'X', 'DQ_PROV.(POPULATIONProvince IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, '', 'X', 'DQ_PstCd.(POPULATIONPostal_Code IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_SEX.(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)'


--exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_PHONS.(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)'

exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_LangI.(POPULATIONLangID IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_Email.(POPULATIONEMAIL_ADDRESS IS NULL)'
exec #NewSurveyTypeDefaultCriteria 5, 'X', 'X', 'DQ_ID.(ENCOUNTERDrID IS NULL AND ENCOUNTERDrNPI IS NULL)'

exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_L Nm.(POPULATIONLName IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_F Nm.(POPULATIONFName IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_Addr.(POPULATIONADDR IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_City.(POPULATIONCITY IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, 'X', '', 'DQ_ST.(POPULATIONST IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, 'X', '', 'DQ_Zip5.(POPULATIONZIP5 IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, '', 'X', 'DQ_PROV.(POPULATIONProvince IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, '', 'X', 'DQ_PstCd.(POPULATIONPostal_Code IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_SEX.(POPULATIONSex <> "M" AND POPULATIONSex <> "F") OR (POPULATIONSex IS NULL)'


--exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_PHONS.(POPULATIONPHONSTAT <> 0 AND POPULATIONPHONSTAT IS NOT NULL)'

exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_LangI.(POPULATIONLangID IS NULL)'
exec #NewSurveyTypeDefaultCriteria 6, 'X', 'X', 'DQ_Email.(POPULATIONEMAIL_ADDRESS IS NULL)'

go

select st.surveytype_id, st.surveytype_dsc, c.strCountry_nm, cs.*
from dbo.SurveyTypeDefaultCriteria dc
inner join (select surveytype_id, surveytype_dsc from surveytype union select 7, 'NRC Canada') st on dc.surveytype_id=st.surveytype_id
inner join country c on dc.country_id=c.country_id
inner join dbo.DefaultCriteriaStmt cs on dc.defaultCriteriaStmt_id=cs.defaultCriteriaStmt_id
order by st.surveytype_id, c.country_id,dc.defaultCriteriaStmt_id

select strCriteriaStmt_nm,count(*),count(distinct strCriteriaString), min(strCriteriaString), max(strCriteriaString)
from dbo.DefaultCriteriaStmt 
group by strCriteriaStmt_nm 
order by 3,2


select cs.*, cc.DefaultCriteriaClause_id, cc.CriteriaPhrase_id, cc.strTable_nm, mf.strField_nm, op.strOperator, cc.strLowValue, cc.strHighValue, ci.strListValue
from dbo.DefaultCriteriaStmt cs
inner join dbo.DefaultCriteriaClause cc on cs.DefaultCriteriaStmt_id=cc.DefaultCriteriaStmt_id
inner join metafield mf on cc.field_id=mf.field_id
inner join operator op on cc.intOperator=op.Operator_num
left join dbo.DefaultCriteriaInList ci on cc.DefaultCriteriaClause_id=ci.DefaultCriteriaClause_id

