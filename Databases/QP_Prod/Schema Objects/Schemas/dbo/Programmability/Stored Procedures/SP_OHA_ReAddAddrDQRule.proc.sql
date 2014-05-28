CREATE PROCEDURE SP_OHA_ReAddAddrDQRule @Survey_id int
AS
SET NOCOUNT ON

	DECLARE @Study_id int
	DECLARE @Table_id int
	DECLARE @CriteriaStmt_id int	
	DECLARE @CriteriaClause_id int

/*Get the Study_id for this survey*/
	SELECT @Study_id = Study_id
	FROM dbo.Survey_def
	WHERE Survey_id = @Survey_id
	IF @Study_id IS NULL
		RETURN

/*Get Population's Table_id*/
	SELECT @Table_id = mt.Table_id	
	FROM dbo.metaTable mt
	WHERE mt.strTable_nm = 'POPULATION'
	AND mt.Study_id = @Study_id
	IF @Table_id IS NULL
	BEGIN
		RAISERROR ('No Population Table defined for Survey %s', 16, 1, @Survey_id)
		RETURN
	END

/*Add AddrErr Rule, Operator 7 */
	IF EXISTS (SELECT field_id FROM dbo.metadata_view WHERE table_id = @Table_id 
			AND study_id = @Study_id
			AND strfield_nm = 'ADDRERR')
	BEGIN
		IF NOT EXISTS (SELECT * 
				FROM CriteriaStmt cs, BusinessRule br 
				WHERE cs.Study_id = @Study_id 
				AND strCriteriaStmt_nm = 'DQ_AddEr' 
				AND cs.CriteriaStmt_id = br.CriteriaStmt_id 
				AND br.Survey_id = @Survey_id)
		BEGIN
			EXEC dbo.sp_DQ_CriteriaStmt @Study_id, 'DQ_AddEr', @CriteriaStmt_id OUTPUT 
			EXEC dbo.sp_DQ_BusRule @Survey_id, @Study_id, @CriteriaStmt_id
			EXEC dbo.sp_DQ_CriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ADDRERR', 'IN', '', '', @CriteriaClause_id OUTPUT
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E101'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E212'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E213'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E214'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E216'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E302'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E421'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E422'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E423'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E425'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E427'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E428'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E429'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E432'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E433'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E434'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E435'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E436'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E437'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E450'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E451'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E452'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E453'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E502'
			EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'E600'
			PRINT 'Rule added for survey '+convert(varchar,@survey_id)
		END
		ELSE
			PRINT 'Rule already existed for survey '+convert(varchar,@survey_id)
		
	END


