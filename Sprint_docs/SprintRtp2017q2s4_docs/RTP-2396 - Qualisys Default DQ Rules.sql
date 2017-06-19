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


-- DQ_MRN

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_MRN')
BEGIN

INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_MRN','(POPULATIONMRN IS NULL)','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm, Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'POPULATION', 1, 9, 'NULL', '')

END

-- DQ_DSCHD

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_DSCHD')
BEGIN
INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_DSCHD','(ENCOUNTERDischargeDate IS NULL)','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'ENCOUNTER', 54, 9, 'NULL', '')

-- DQ_DRNPI

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_DRNPI')
BEGIN

INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_DRNPI','(ENCOUNTERDrNPI IS NULL)','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'ENCOUNTER', 1444, 9, 'NULL', '')
END


-- DQ_DRFNM

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_DRFNM')
BEGIN

INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_DRFNM','(ENCOUNTERDrFirstName IS NULL)','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'ENCOUNTER', 119, 9, 'NULL', '')
END

-- DQ_DRLNM

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_DRLNM')
BEGIN

INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_DRLNM','(ENCOUNTERDrLastName IS NULL)','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'ENCOUNTER', 118, 9, 'NULL', '')
END


-- DQ_PHON2

IF NOT EXISTS( SELECT * FROM DefaultCriteriaStmt WHERE strCriteriaStmt_nm = 'DQ_PHON2')
BEGIN

INSERT INTO DefaultCriteriaStmt     
        (strCriteriaStmt_nm, strCriteriaString, BusRule_cd) 
VALUES  ('DQ_PHON2','(POPULATIONServiceind_99 = "0")','Q')

SELECT @statementID = @@IDENTITY

INSERT INTO DefaultCriteriaClause 
        (DefaultCriteriaStmt_id, CriteriaPhrase_id, strTable_nm,Field_id, intOperator, strLowValue, strHighValue)
VALUES  (@statementID, 1,'POPULATION', 1540, 1, '0', '')
END


SELECT ID = DefaultCriteriaStmt_ID INTO #DQStatements FROM 
DefaultCriteriaStmt WHERE strCriteriaStmt_NM IN ('DQ_DOB','DQ_MRN','DQ_VNUM','DQ_F','DQ_L','DQ_PHONE','DQ_DSCHD','DQ_DRNPI','DQ_DRFNM','DQ_DRLNM', 'DQ_PHON2')

INSERT INTO SurveyTypeDefaultCriteria (SurveyType_id, Country_id, DefaultCriteriaStmt_id) 
    SELECT 27, 1, ID FROM #DQStatements WHERE ID NOT IN (SELECT DefaultCriteriaStmt_id FROM SurveyTypeDefaultCriteria WHERE SurveyType_id = 27)

DROP TABLE #DQStatements

