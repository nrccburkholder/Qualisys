use qp_prod

-- old criteriastring: (ENCOUNTERHHLookbackCnt < 2)
DECLARE @DO_IT as bit
SET @DO_IT = 0   -- set to 1 to do the actual updates, otherwise it will skip the update/insert/delete statements

DECLARE @DQRuleName varchar(10)
DECLARE @surveytype_id int

SET @DQRuleName = 'DQ_VisLk'
SET @surveytype_id = 3  -- HHCAHPS


SELECT br.*, cs.* ,cc.*, sdef.*
FROM [QP_Prod].[dbo].[BUSINESSRULE] br
INNER JOIN [dbo].[CRITERIASTMT] cs ON (cs.CRITERIASTMT_ID = br.CRITERIASTMT_ID)
INNER JOIN [dbo].[CRITERIACLAUSE] cc ON (cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID)
INNER JOIN [dbo].[SURVEY_DEF] sdef ON (sdef.SURVEY_ID = br.SURVEY_ID AND sdef.SURVEYType_ID = @surveytype_id)
WHERE cs.STRCRITERIASTMT_NM = @DQRuleName


-- These are the ones to be changed
SELECT cs.CRITERIASTMT_ID, cc.CRITERIACLAUSE_ID      
INTO #temp 
FROM [QP_Prod].[dbo].[BUSINESSRULE] br
INNER JOIN [dbo].[CRITERIASTMT] cs ON (cs.CRITERIASTMT_ID = br.CRITERIASTMT_ID)
INNER JOIN [dbo].[CRITERIACLAUSE] cc ON (cc.CRITERIASTMT_ID = cs.CRITERIASTMT_ID)
INNER JOIN [dbo].[SURVEY_DEF] sdef ON (sdef.SURVEY_ID = br.SURVEY_ID AND sdef.SURVEYType_ID = @surveytype_id)
WHERE cs.STRCRITERIASTMT_NM = @DQRuleName

-- these are the surveys involved
SELECT br.SURVEY_ID
FROM [dbo].[BUSINESSRULE] br
INNER JOIN [dbo].[CRITERIASTMT] cs ON (cs.CRITERIASTMT_ID = br.CRITERIASTMT_ID)
INNER JOIN [dbo].[SURVEY_DEF] sdef ON (sdef.SURVEY_ID = br.SURVEY_ID AND sdef.SURVEYType_ID = @surveytype_id)
WHERE cs.STRCRITERIASTMT_NM = @DQRuleName
group by br.SURVEY_ID



IF @DO_IT = 1
BEGIN
	print 'We are doing it!'
	BEGIN Transaction T1

	update cs
		SET 
			cs.strCriteriaString = '(ENCOUNTERHHLookbackCnt IN (0,1) )'	
		FROM [dbo].[CRITERIASTMT] cs
		INNER JOIN #temp t on (t.[CRITERIASTMT_ID] = cs.[CRITERIASTMT_ID])

	update cc
		SET 
			cc.INTOPERATOR = 7 -- 7 = IN operator
		FROM [dbo].[CRITERIACLAUSE] cc
		INNER JOIN #temp t on (t.[CRITERIASTMT_ID] = cc.[CRITERIASTMT_ID])

	IF NOT EXISTS(select 'x' FROM [dbo].[CRITERIAINLIST] CL INNER JOIN #temp t ON (t.CRITERIACLAUSE_ID = CL.CRITERIACLAUSE_ID) WHERE CL.STRLISTVALUE = '0')
	BEGIN

		INSERT INTO [dbo].[CRITERIAINLIST]
		SELECT CriteriaClause_ID,'0' from #temp

	END ELSE print 'CriteriaINList for 0 already exists'


	IF NOT EXISTS(select 'x' FROM [dbo].[CRITERIAINLIST] CL INNER JOIN #temp t ON (t.CRITERIACLAUSE_ID = CL.CRITERIACLAUSE_ID) WHERE CL.STRLISTVALUE = '1')
	BEGIN
		INSERT INTO [dbo].[CRITERIAINLIST]
		SELECT CriteriaClause_ID,'1' from #temp
	END ELSE print 'CriteriaINList for 1 already exists'


	print 'We did it.  DO NOT FORGET TO COMMIT!!!!!'
END else print 'We did NOT do it.'


DROP TABLE #temp

/*

rollback transaction T1

*/

/*

Commit Transaction T1

*/