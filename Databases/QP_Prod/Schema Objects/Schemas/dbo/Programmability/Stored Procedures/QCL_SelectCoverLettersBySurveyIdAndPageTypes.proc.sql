CREATE PROCEDURE [dbo].[QCL_SelectCoverLettersBySurveyIdAndPageTypes]
@SurveyID INT,
@PageTypes VARCHAR(10)
AS

SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

DECLARE @SQL as varchar(500)

SET @SQL = 'SELECT SelCover_id, [Description], Survey_id
FROM Sel_Cover 
WHERE Survey_id=' + CAST(@SurveyID as varchar) + 
' AND PageType in (' + @PageTypes + ')'

EXEC (@Sql)

SET NOCOUNT OFF
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

