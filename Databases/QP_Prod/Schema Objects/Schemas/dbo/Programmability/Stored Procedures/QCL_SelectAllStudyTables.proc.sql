/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     dataset representing all of the study data tables that exist for the study ID 	 */
/*                       										 */  
/* Date Created:  10/17/2005                  								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE QCL_SelectAllStudyTables
@StudyId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Table_id, strTable_nm, strTable_dsc, Study_id, 0 IsView
FROM MetaTable
WHERE Study_id = @StudyId
UNION
SELECT 0, Table_Name, 'Combined view of all study tables', @StudyId, 1
FROM Information_Schema.Tables
WHERE Table_Schema = 's' + CONVERT(VARCHAR, @StudyId)
AND Table_Name = 'Big_View'
AND Table_Type = 'VIEW'
ORDER BY 2


SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


