CREATE PROCEDURE SP_PEPC_DQRules @Survey_id INT
AS
	DECLARE @Study_id int
	DECLARE @Table_id int
	DECLARE @CriteriaStmt_id int	
	DECLARE @CriteriaClause_id int
	DECLARE @Owner varchar(32)

/*Get the Study_id for this survey*/
	SELECT @Study_id = Study_id
	FROM dbo.Survey_def
	WHERE Survey_id = @Survey_id
	IF @Study_id IS NULL
begin
print 'No study'
		RETURN
end

/*Get Population's Table_id*/
	SELECT @Table_id = mt.Table_id	
	FROM dbo.metaTable mt
	WHERE mt.strTable_nm = 'ENCOUNTER'
	AND mt.Study_id = @Study_id
	IF @Table_id IS NULL
	BEGIN
print 'No pop table'
		RETURN
	END

	IF EXISTS (SELECT field_id FROM dbo.metadata_view WHERE table_id = @Table_id 
			AND study_id = @Study_id
			AND strfield_nm = 'DRG')
	BEGIN
		EXEC dbo.sp_DQ_CriteriaStmt @Study_id, 'DQ_PSYCH', @CriteriaStmt_id OUTPUT 
		EXEC dbo.sp_DQ_BusRule @Survey_id, @Study_id, @CriteriaStmt_id
		EXEC dbo.sp_DQ_CriteriaClause 1, @CriteriaStmt_id, @Table_id, 'DRG', 'IN', '', '', @CriteriaClause_id OUTPUT
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '424'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '425'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '426'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '427'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '428'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '429'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '430'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '431'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '432'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '433'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '434'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '435'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '436'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, '437'
	END

	IF EXISTS (SELECT field_id FROM dbo.metadata_view WHERE table_id = @Table_id 
			AND study_id = @Study_id
			AND strfield_nm = 'ICD9')
	BEGIN
		EXEC dbo.sp_DQ_CriteriaStmt @Study_id, 'DQ_STILL', @CriteriaStmt_id OUTPUT 
		EXEC dbo.sp_DQ_BusRule @Survey_id, @Study_id, @CriteriaStmt_id
		EXEC dbo.sp_DQ_CriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ICD9', 'IN', '', '', @CriteriaClause_id OUTPUT
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'V27.1'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'V27.3'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'V27.4'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'V27.6'
		EXEC dbo.sp_DQ_INList @CriteriaClause_id, 'V27.7'
		EXEC dbo.sp_DQ_CriteriaClause 2, @CriteriaStmt_id, @Table_id, 'ICD9', 'BETWEEN', '656.399', '656.499', @CriteriaClause_id OUTPUT
	END

	IF EXISTS (SELECT field_id FROM dbo.metadata_view WHERE table_id = @Table_id 
			AND study_id = @Study_id
			AND strfield_nm = 'ICD9')
	BEGIN
		EXEC dbo.sp_DQ_CriteriaStmt @Study_id, 'DQ_ABORT', @CriteriaStmt_id OUTPUT 
		EXEC dbo.sp_DQ_BusRule @Survey_id, @Study_id, @CriteriaStmt_id
		EXEC dbo.sp_DQ_CriteriaClause 1, @CriteriaStmt_id, @Table_id, 'ICD9', 'BETWEEN', '629.999', '639.999', @CriteriaClause_id OUTPUT
	END


