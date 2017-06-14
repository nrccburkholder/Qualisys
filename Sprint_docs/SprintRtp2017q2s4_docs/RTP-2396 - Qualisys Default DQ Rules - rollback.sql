SELECT ID = DefaultCriteriaStmt_ID INTO #DQStatements FROM 
DefaultCriteriaStmt WHERE strCriteriaStmt_NM IN ('DQ_MRN','DQ_VNUM','DQ_F','DQ_L','DQ_PHONE','DQ_DSCHD','DQ_DRNPI','DQ_DRFNM','DQ_DRLNM', 'DQ_PHON2')

DELETE FROM DefaultCriteriaInList WHERE DefaultCriteriaClause_id in (SELECT DefaultCriteriaClause_ID FROM DefaultCriteriaClause c JOIN #DQStatements s ON c.DefaultCriteriaStmt_id = s.ID)
DELETE FROM DefaultCriteriaClause WHERE DefaultCriteriaStmt_id IN (SELECT ID FROM #DQStatements)
DELETE FROM DefaultCriteriaStmt WHERE DefaultCriteriaStmt_id IN (SELECT ID FROM #DQStatements)

DELETE FROM SurveyTypeDefaultCriteria WHERE SurveyType_id = 27 AND Country_id = 1 

DROP TABLE #DQStatements

DECLARE @maxID INT  
SELECT @maxID = MAX(DefaultCriteriaStmt_ID) FROM DefaultCriteriaStmt
DBCC CHECKIDENT ('DefaultCriteriaStmt', RESEED, @maxID);  

SELECT @maxID = MAX(DefaultCriteriaClause_ID) FROM DefaultCriteriaClause
DBCC CHECKIDENT ('DefaultCriteriaClause', RESEED, @maxID);  

SELECT @maxID = MAX(DefaultCriteriaInList_id) FROM DefaultCriteriaInList
DBCC CHECKIDENT ('DefaultCriteriaInList', RESEED, @maxID);  