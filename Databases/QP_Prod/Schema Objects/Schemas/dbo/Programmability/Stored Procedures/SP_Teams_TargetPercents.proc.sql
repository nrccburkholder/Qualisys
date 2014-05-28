CREATE PROCEDURE SP_Teams_TargetPercents
AS
TRUNCATE TABLE teamstatus_targetpercents

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @survey_id INT, @equal INT, @more INT, @less INT, @perequal DECIMAL(5,2), @permore DECIMAL(5,2), @perless DECIMAL(5,2), @total INT

DECLARE target CURSOR FOR
SELECT DISTINCT survey_id FROM targetinfo (NOLOCK) WHERE perioddate > '12/1/00'

OPEN target
FETCH NEXT FROM target INTO @survey_id
WHILE @@FETCH_STATUS = 0
BEGIN

	SET @total = (SELECT COUNT(*) 
	FROM targetinfo (NOLOCK)
	WHERE survey_id = @survey_id 
	AND perioddate > '12/1/00')

	SET @equal = (SELECT COUNT(*) 
	FROM targetinfo (NOLOCK)
	WHERE survey_id = @survey_id 
	AND perioddate > '12/1/00'
	AND target = returns)

	SET @perequal = (@equal / (@total * 1.00)) * 100

	SET @more = (SELECT COUNT(*) 
	FROM targetinfo (NOLOCK)
	WHERE survey_id = @survey_id 
	AND perioddate > '12/1/00'
	AND target < returns)
	
	SET @permore = (@more / (@total * 1.00)) * 100

	SET @less = (SELECT COUNT(*) 
	FROM targetinfo (NOLOCK)
	WHERE survey_id = @survey_id 
	AND perioddate > '12/1/00'
	AND target > returns)

	SET @perless = (@less / (@total * 1.00)) * 100

INSERT INTO teamstatus_targetpercents
SELECT strclient_nm, strstudy_nm, s.study_id, strsurvey_nm, @survey_id, @perequal, @permore, @perless
FROM survey_def sd(NOLOCK), study s(NOLOCK), client c(NOLOCK)
WHERE survey_id = @survey_id
AND sd.study_id = s.study_id
AND s.client_id = c.client_id

FETCH NEXT FROM target INTO @survey_id
END

CLOSE target
DEALLOCATE target


