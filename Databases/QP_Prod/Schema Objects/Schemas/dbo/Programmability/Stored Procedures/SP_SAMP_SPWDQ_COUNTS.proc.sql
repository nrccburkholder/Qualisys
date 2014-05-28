/**********************************************************************
	This stored procedure will calculate the sampleset counts for DQ rules.

	Updates:
	3-18-2004 DC
		Initial Creation

***********************************************************************/
CREATE      PROCEDURE SP_SAMP_SPWDQ_COUNTS 
	@intsampleset int, 
	@intsurvey_id int
as
DECLARE @bitDynamic int, @bitNewBorn int, @bitDoHousehold int, @strHouseholdingType char(1)


SELECT @bitdynamic=bitdynamic,
		@bitNewBorn=bitnewborn_flg,
		@bitdoHousehold=bitdoHousehold,
		@strHouseholdingType=strHouseholdingtype
FROM survey_def
where survey_Id=@intsurvey_Id

CREATE TABLE #BusinessRule (businessrule_id int, strcriteriastmt_nm varchar(8))

insert into #BusinessRule
SELECT CS.CriteriaStmt_id, CS.strCriteriaStmt_nm
  FROM BusinessRule BR, CriteriaStmt CS 
  WHERE BR.CriteriaStmt_id = CS.CriteriaStmt_id AND 
        BR.Survey_id = @intSurvey_id AND 
        BR.BusRule_cd = 'Q'
ORDER BY strCriteriaStmt_nm

CREATE TABLE #Removed_Rules (ID int, rule_name varchar(20))

Insert into #Removed_Rules values (1, 'Resurvey')
IF @bitNewBorn=1 Insert into #Removed_Rules values (2, 'NewBorn')
Insert into #Removed_Rules values (3, 'TOCL')
Insert into #Removed_Rules values (4, 'DQRule')
--Only check deduping for static
IF @bitdynamic=0 Insert into #Removed_Rules values (5, 'ExcEnc')
IF @bitDoHousehold=1 
BEGIN
	IF @StrHouseholdingType='M' Insert into #Removed_Rules values (6, 'HHMinor')
	IF @StrHouseholdingType='A' Insert into #Removed_Rules values (7, 'HHAdult')
END
IF @bitdynamic=0 Insert into #Removed_Rules values (8, 'SSRemove')

CREATE TABLE #SPWDQCounts (sampleset_id int, sampleunit_id int, DQ varchar(8), N int)

INSERT INTO #SPWDQCounts (sampleset_id, sampleunit_id, DQ, N)
	select @intsampleset, sampleunit_id, strcriteriastmt_nm as DQ, 0
	from (select distinct sampleunit_id
			from #Sampleunit_universe) s, #BusinessRule
union
	select @intsampleset, sampleunit_id, rule_name as DQ, 0
	from (select distinct sampleunit_id
			from #Sampleunit_universe) s, #Removed_Rules rr
	WHERE rr.id <> 4

UPDATE #SPWDQCounts 
SET N=DQ_count
FROM #SPWDQCounts S,
		(select distinct sampleunit_id, coalesce(strCriteriaStmt_nm,rule_name) as DQ, count(distinct pop_id) as DQ_Count
		from #Sampleunit_universe d left join #BusinessRule b
			on d.dq_bus_rule=B.businessrule_id 
			Join #Removed_Rules rr
			on d.removed_rule=rr.id
		group by sampleunit_id, coalesce(strCriteriaStmt_nm,rule_name)) C
WHERE s.sampleunit_id=c.sampleunit_id and
	  s.DQ=C.DQ


INSERT INTO SPWDQCounts (sampleset_id, sampleunit_Id, DQ, N)
SELECT sampleset_id, sampleunit_Id, DQ, N
FROM #SPWDQCounts
ORDER BY sampleset_id, sampleunit_Id, DQ


DROP TABLE #BusinessRule
DROP TABLE #Removed_Rules
DROP TABLE #SPWDQCounts


