/****** Object:  StoredProcedure [dbo].[get_Criteria]    Script Date: 08/09/2006 15:22:56 ******/
IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
DROP PROCEDURE [dbo].[get_Criteria]
GO
/****** Object:  StoredProcedure [dbo].[get_Criteria]    Script Date: 08/09/2006 15:22:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[dbo].[get_Criteria]') AND OBJECTPROPERTY(id,N'IsProcedure') = 1)
BEGIN
EXEC dbo.sp_executesql @statement = N'






CREATE   PROCEDURE get_Criteria 
(
	@criteriaID int
)
AS
BEGIN
SET NOCOUNT ON

/* create a table to collect the tree structure */
CREATE TABLE #x 
(
	Hierarchy varchar(800),	/* sortable code */
	CriteriaID int unique,	/* criteria id.  Note -- is unique to protect against infinite loops */
	Lvl int 		/* starting with 1 going down */
)

DECLARE @level int
DECLARE @rct int

SET @level = 1

-- add the first record,  if the criteria exists
INSERT INTO #x (Hierarchy, CriteriaID, Lvl)
SELECT SUBSTRING(CONVERT(varchar(12), 1000000000 + @criteriaID), 2, 9), CriteriaID, @level
FROM Criteria
WHERE CriteriaID = @CriteriaID

SET @rct = @@rowcount  

-- while there are possible subcriteria to look at
WHILE (@rct != 0) 
BEGIN
	
	-- add the children
	INSERT INTO #x (Hierarchy, CriteriaID, Lvl)
	SELECT	a.Hierarchy + '':'' + 
	  	SUBSTRING(CONVERT(varchar(12), 10000 + ISNULL(b.referenceCriteriaSequence,0)), 2, 4) + '':'' +
		SUBSTRING(CONVERT(varchar(12), 1000000000 + b.criteriaID), 2, 9),
		b.CriteriaID, @level+1
	FROM 	#x a, Criteria b
	WHERE 	b.referenceCriteriaID = a.CriteriaID 
		AND a.Lvl = @level

   	SET @rct = @@rowcount
    
	-- prepare for the next level
	SET @level = @level+1

END -- WHILE

-- report what we found
SELECT	a.Hierarchy, a.CriteriaID, a.Lvl, b.CriteriaName, b.SurveyID, 
	b.CriteriaTypeID, b.AnswerCategoryID, b.CriteriaDataTypeID, 
	b.ParameterName, b.TextValue, b.ReferenceCriteriaID, 
	b.ReferenceCriteriaSequence, b.Flag
FROM 	#x a, Criteria b
WHERE 	a.CriteriaID = b.CriteriaID
ORDER BY a.Hierarchy

-- clean up
DROP TABLE #x

SET NOCOUNT OFF

END




' 
END
GO
GRANT EXECUTE ON [dbo].[get_Criteria] TO [reporter]
GO
