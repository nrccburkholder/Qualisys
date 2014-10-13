--/****** Script for SelectTopNRows command from SSMS  ******/
SELECT stdc.*, dcs.*, dcc.*, dcil.*
  FROM [dbo].[SurveyTypeDefaultCriteria] stdc
  inner join [dbo].[DefaultCriteriaStmt] dcs on dcs.DefaultCriteriaStmt_id = stdc.DefaultCriteriaStmt_id
  inner join [dbo].[DefaultCriteriaClause] dcc on dcc.DefaultCriteriaStmt_id = stdc.DefaultCriteriaStmt_id
  inner join [dbo].[DefaultCriteriaInList] dcil on dcil.DefaultCriteriaClause_id = dcc.DefaultCriteriaClause_id
  where SurveyType_id = 2



  SELECT dcs.[DefaultCriteriaStmt_id], dcs.strCriteriaStmt_nm, dcs.strCriteriaString
  FROM [dbo].[SurveyTypeDefaultCriteria] stdc
  inner join [dbo].[DefaultCriteriaStmt] dcs on dcs.DefaultCriteriaStmt_id = stdc.DefaultCriteriaStmt_id
  where SurveyType_id = 2

declare @survey_id int
DECLARE @Study_id INT
DECLARE @Country_id INT
DECLARE @CriteriaStmt_id INT
DECLARE @SurveyType_ID int

SET @survey_id = 15724


SELECT  @surveyType_id = SurveyType_id
from SURVEY_DEF
where SURVEY_ID = @Survey_id

/*Get the Country_id from the QualPro_Params*/
SELECT @Country_id=numParam_Value
FROM QualPro_Params
WHERE strParam_nm='Country'


IF @SurveyType_id not in (select SurveyType_ID from surveytype where CAHPSType_id is not null)
BEGIN
    RETURN
END

DECLARE @SurveyTypeDescription varchar(20)

SELECT @SurveyTypeDescription = [SurveyType_dsc]
FROM [dbo].[SurveyType] 
WHERE SurveyType_ID = @surveyType_id

  --Create a Temp table of the DQ rules for this survey type

create table #DefaultCriteriaStmt (DefaultCriteriaStmt_id int, strCriteriaStmt_nm char(8))
create table #DefaultCriteriaClause (DefaultCriteriaClause_id int 
	, CriteriaPhrase_id int
	, strTable_nm varchar(20)
	, Table_id int
	, Field_id int
	, Field_nm varchar(100)
	, intOperator int
	, Operator_nm varchar(8)
	, strLowValue varchar(42)
	, strHighValue varchar(42)
	, bitFieldExistsInStudy bit
	, CriteriaClause_id int
	)

/* list all the DQ Rules for this surveytype/country */
if exists (	select * 
			from dbo.subtype st
			inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
			where st.bitRuleOverRide=1
			and sst.survey_id=@Survey_id)
	-- if any one of the survey's subtype's has bitOverride=1, only use that subtype's default DQ rules
	-- (BTW: there shouldn't be more than one subtype that has bitOverride=1 for any given survey_id. Config Mgr interface enforces this.)
	insert into #DefaultCriteriaStmt (DefaultCriteriaStmt_id,strCriteriaStmt_nm)
	select distinct dc.DefaultCriteriaStmt_id,strCriteriaStmt_nm
	from dbo.SurveyTypeDefaultCriteria dc
	inner join dbo.DefaultCriteriaStmt cs on dc.DefaultCriteriaStmt_id = cs.DefaultCriteriaStmt_id
	where dc.SurveyType_id=@SurveyType_ID
	and dc.country_id=@Country_id
	and dc.Subtype_id=(	select st.subtype_id
						from dbo.subtype st
						inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
						where st.bitRuleOverRide=1
						and sst.survey_id=@Survey_id)
else
	-- if none of the survey's subtype's has bitOveride=1, use all of the default DQ rules for the survey type and all the subtype(s)
	insert into #DefaultCriteriaStmt (DefaultCriteriaStmt_id,strCriteriaStmt_nm)
	select distinct dc.DefaultCriteriaStmt_id,strCriteriaStmt_nm
	from dbo.SurveyTypeDefaultCriteria dc
	inner join dbo.DefaultCriteriaStmt cs on dc.DefaultCriteriaStmt_id = cs.DefaultCriteriaStmt_id
	where dc.SurveyType_id=@SurveyType_ID
	and dc.country_id=@Country_id
	and (dc.Subtype_id=0
		or dc.subtype_id in (	select st.subtype_id 
								from dbo.subtype st
								inner join dbo.surveysubtype sst on st.subtype_id=sst.subtype_id
								where sst.survey_id=@Survey_id )
		)



/* process each rule, one at a time */
declare @DefaultDQ_id int, @Crit_nm char(8)
select top 1 @DefaultDQ_id=DefaultCriteriaStmt_id, @Crit_nm=strCriteriaStmt_nm from #DefaultCriteriaStmt 
while @@rowcount>0
begin
	if exists (	select * 
				from CriteriaStmt cs
				inner join BusinessRule br on cs.criteriastmt_id=br.criteriastmt_id
				where cs.study_id=@study_id
				and cs.strCriteriaStmt_nm=@Crit_nm
				and br.survey_id=@survey_id)
	begin
		print '"'+@Crit_nm+'" already exists for survey '+convert(varchar,@survey_id)+'. skipping...'
	end
	else
	begin

	
		/* put all criteria clauses in a temp table. If one or more of them don't check out, we'll roll back the transaction and the DQ rule won't get applied */
		insert into #DefaultCriteriaClause (DefaultCriteriaClause_id, CriteriaPhrase_id, strTable_nm, Field_id, Field_nm, intOperator, Operator_nm, strLowValue, strHighValue, bitFieldExistsInStudy)
		select DefaultCriteriaClause_id, CriteriaPhrase_id, strTable_nm, dcc.Field_id, mf.STRFIELD_NM, intOperator, op.strOperator, strLowValue, strHighValue, 0
		from dbo.DefaultCriteriaClause dcc
		inner join MetaField mf on dcc.Field_id = mf.Field_id
		inner join Operator op on dcc.intOperator = op.Operator_Num
		where DefaultCriteriaStmt_id=@DefaultDQ_id

		select *
		from #DefaultCriteriaClause



		IF EXISTS
		(
		 SELECT br.BUSINESSRULE_ID--, cs.strCriteriaStmt_nm, count(*), min(strListValue),max(strListValue),round(stdev(convert(int,strlistvalue)),6)
		  FROM BusinessRule br
		  inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
		  inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
		  inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
		  inner join MetaField mf on cc.Field_id = mf.Field_id
		  inner join Operator op on cc.intOperator = op.Operator_Num
		  inner join #DefaultCriteriaClause dcc on (dcc.
		  WHERE mf.strField_Nm = 'HDischargeStatus'
		   AND op.strOperator = 'IN'
		   AND br.Survey_id = @Survey_id
		  GROUP BY br.BUSINESSRULE_ID
		  having count(*)=6 and min(strListValue) = '03' and max(strListValue)= '92' and round(stdev(convert(int,strlistvalue)),6)=38.940981
		  -- the STDEV of (3, 3, 61, 64, 83, 92) is 38.940981. Another combination of 6 integers with 3 as the min and 92 as the max would come up with a different STDEV
		)
			--INSERT INTO #M (Error, strMessage)
			SELECT 0,'Survey has DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'
		ELSE
			--INSERT INTO #M (Error, strMessage)
			SELECT 1,'Survey does not have DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'


	end

	delete from #DefaultCriteriaClause 
	delete from #DefaultCriteriaStmt where DefaultCriteriaStmt_id=@DefaultDQ_id
	select top 1 @DefaultDQ_id=DefaultCriteriaStmt_id, @Crit_nm=strCriteriaStmt_nm from #DefaultCriteriaStmt 
end

drop table #DefaultCriteriaClause 
drop table #DefaultCriteriaStmt

/*
DECLARE @iLoopControl INT
DECLARE @iNextRowID INT
DECLARE @iCurrentRowID INT
DECLARE @defaultCriteriaStmt_id int
DECLARE @strCriteriaString VARCHAR(7000)
DECLARE @rule_name VARCHAR(150)
DECLARE @sql VARCHAR(8000)

SET @iLoopControl = 1 

SELECT @iNextRowID = Min(ID)
FROM #DQRules

SELECT @iCurrentRowID = ID,
	   @defaultCriteriaStmt_id = defaultCriteriaStmt_id,
	   @rule_name = strCriteriaStmt_nm,
	   @strCriteriaString = strCriteriaString
FROM  #DQRules
WHERE ID = @iNextRowID


	WHILE @iLoopControl = 1
	BEGIN
      
		   

		   SELECT distinct @rule_name as rule_name
		   , cil.DefaultCriteriaClause_id
		   , cil.strListValue
		   , mf.FIELD_ID
		   , mf.STRFIELD_NM
		   , op.operator_num
		   , op.strOperator
		   from [dbo].[DefaultCriteriaSTMT] cs
		   inner join [dbo].[DefaultCRITERIACLAUSE] cc on cc.DefaultCRITERIASTMT_ID = cs.DefaultCRITERIASTMT_ID
		   inner join [dbo].[DefaultCriteriaInList] cil on cil.DefaultCriteriaClause_id = cc.DefaultCriteriaClause_id
		   inner join MetaField mf on cc.Field_id = mf.Field_id
		   inner join Operator op on cc.intOperator = op.Operator_Num
		   where cs.STRCRITERIASTMT_NM = @rule_name


		   /*
		   IF EXISTS
			(
			 SELECT br.BUSINESSRULE_ID--, cs.strCriteriaStmt_nm, count(*), min(strListValue),max(strListValue),round(stdev(convert(int,strlistvalue)),6)
			  FROM BusinessRule br
			  inner join CriteriaStmt cs on br.CriteriaStmt_id = cs.CriteriaStmt_id
			  inner join CriteriaClause cc on cs.CriteriaStmt_id = cc.CriteriaStmt_id
			  inner join CriteriaInList ci on cc.CriteriaClause_id = ci.CriteriaClause_id
			  inner join MetaField mf on cc.Field_id = mf.Field_id
			  inner join Operator op on cc.intOperator = op.Operator_Num
			  WHERE mf.strField_Nm = 'HDischargeStatus'
			   AND op.strOperator = 'IN'
			   AND br.Survey_id = @Survey_id
			  GROUP BY br.BUSINESSRULE_ID
			  having count(*)=6 and min(strListValue) = '03' and max(strListValue)= '92' and round(stdev(convert(int,strlistvalue)),6)=38.940981
			  -- the STDEV of (3, 3, 61, 64, 83, 92) is 38.940981. Another combination of 6 integers with 3 as the min and 92 as the max would come up with a different STDEV
			)
				--INSERT INTO #M (Error, strMessage)
				SELECT 0,'Survey has DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'
			ELSE
				--INSERT INTO #M (Error, strMessage)
				SELECT 1,'Survey does not have DQ_SNF rule (ENCOUNTERHDischargeStatus IN ("3","03","61","64","83","92")).'

			*/

			-- Reset looping variables
				SET @iNextRowID = NULL
				SELECT @iNextRowID = Min(ID)
				FROM #DQRules
				WHERE ID > @iCurrentRowID

				-- Is this a valid next row id?
				IF ISNULL(@iNextRowId,0) = 0
				BEGIN

					GOTO END_LOOP
				END

				-- Retrieve the next row
				SELECT @iCurrentRowID = ID,
					   @defaultCriteriaStmt_id = defaultCriteriaStmt_id,
					   @rule_name = strCriteriaStmt_nm,
					   @strCriteriaString = strCriteriaString
				FROM  #DQRules
				WHERE ID = @iNextRowID   

	END

END_LOOP:



DROP TABLE #DQRules

*/