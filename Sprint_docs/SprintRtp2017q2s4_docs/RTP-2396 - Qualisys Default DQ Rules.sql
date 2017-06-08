USE QP_Prod

GO

DECLARE @statementID INT
DECLARE @clauseID INT

-- DQ_VNUM

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_VNUM')
BEGIN
    INSERT INTO DefaultCriteriaStmt     
            (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
    VALUES  ('DQ_VNUM','(ENCOUNTERVisitNum IS NULL)','Q')

    SELECT @statementID = @@IDENTITY

    INSERT INTO DefaultCriteriaClause 
            (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
    VALUES  (@statementID, 1,'ENCOUNTER', 83, 9, 'NULL', '')
END

--DQ_F

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_F')
BEGIN
    INSERT INTO DefaultCriteriaStmt     
            (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
    VALUES  ('DQ_F','(POPULATIONFName IS NULL)','Q')

    SELECT @statementID = @@IDENTITY

    INSERT INTO DefaultCriteriaClause 
            (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
    VALUES  (@statementID, 1,'POPULATION', 7, 9, 'NULL', '')
END

-- DQ_L

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_L')
BEGIN

INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_L','(POPULATIONLName IS NULL)','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'POPULATION', 6, 9, 'NULL', '')
END


-- DQ_PHONE

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_PHONE')
BEGIN

INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_PHONE','(POPULATIONPhone IS NULL)','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'POPULATION', 76, 9, 'NULL', '')
END

-- DQ_DSCHD

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_DSCHD')
BEGIN
INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_DSCHD','(ENCOUNTERDischargeDate IS NULL) OR (ENCOUNTERDischargeDate < ''1/1/1753'')','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'ENCOUNTER', 54, 9, 'NULL', '')

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 2,'ENCOUNTER', 54, 5, '1/1/1753', '')
END

-- DQ_VTYPE

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_VTYPE')
BEGIN
INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_VTYPE','(ENCOUNTERVisitType IS NULL) OR (ENCOUNTERVisitType NOT IN (''E'',''ED'',''ER'',''I'',''IN'',''MP'',''NA'',''O'',''OP'',''OPS'',''R''))','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'ENCOUNTER', 144, 9, 'NULL', '')

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator)
VALUES  (@statementID, 1,'ENCOUNTER', 144, 11)

SELECT @clauseID = @@IDENTITY

INSERT INTO DefaultCriteriaInList 
        (DefaultCriteriaClause_id, strListValue)
VALUES  (@clauseID, 'E'  ),
        (@clauseID, 'ED' ),
        (@clauseID, 'ER' ),
        (@clauseID, 'I'  ),
        (@clauseID, 'IN' ),
        (@clauseID, 'MP' ),
        (@clauseID, 'NA' ),
        (@clauseID, 'O'  ),
        (@clauseID, 'OP' ),
        (@clauseID, 'OPS'),
        (@clauseID, 'R'  )
END

SELECT ID = DefaultCriteriaStmt_ID INTO #DQStatements FROM 
DefaultCriteriaStmt WHERE strCriteriaStmt_NM IN ('DQ_DOB','DQ_MRN','DQ_VNUM','DQ_F','DQ_L','DQ_PHONE','DQ_DSCHD','DQ_VTYPE')

INSERT INTO SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id) 
    SELECT 27, 1, ID FROM #DQStatements 

DROP TABLE #DQStatements

