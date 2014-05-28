-- ================================================================================================
-- Author:	Kathi Nussralalh
-- Procedure Name: csp_GetStudyExtractData
-- Create date: 3/01/2009 
-- Description:	Extracts study data from QP_Prod tables
-- History: 1.0  3/01/2009  by Kathi Nussralalh
--          1.1 3/22/2011 kmn modifed logic to extact study owner data 
-- =================================================================================================
CREATE PROCEDURE [dbo].[csp_GetStudyMetaExtractData] 
	@ExtractFileID int
--exec dbo.csp_GetStudyMetaExtractData 9
AS
	SET NOCOUNT ON 	
	
	SELECT  DISTINCT 1  AS Tag
		,NULL  AS Parent
		,mt.STUDY_ID AS [studymetadata!1!id]
		,RTRIM(mf.STRFIELD_NM) AS [studymetadata!1!fieldName] 		
		,RTRIM(mf.STRFIELD_DSC) AS [studymetadata!1!fieldDescription]
		,'false' as [studymetadata!1!deleteEntity]		
	FROM ( SELECT DISTINCT PKey1--TABLPKey1
		   FROM dbo.ExtractHistory eh WITH (NOLOCK)
		   WHERE ExtractFileID = @ExtractFileID
		   AND eh.EntityTypeID IN (17,18) ) x
	INNER JOIN QP_Prod.dbo.MetaTable mt ON x.PKey1 = mt.TABLE_ID
	LEFT JOIN QP_Prod.dbo.metastructure AS ms ON mt.table_id = ms.table_id
	LEFT JOIN QP_Prod.dbo.metafield AS mf ON ms.FIELD_ID = mf.FIELD_ID
	FOR XML EXPLICIT


