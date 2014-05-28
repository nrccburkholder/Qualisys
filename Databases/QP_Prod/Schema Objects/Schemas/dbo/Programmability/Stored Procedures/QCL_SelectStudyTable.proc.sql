/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     dataset representing the study data tables for the tableId 	 */
/*                       										 */  
/* Date Created:  3/10/2006                 								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE [dbo].[QCL_SelectStudyTable]
@TableId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Table_id, strTable_nm, strTable_dsc, Study_id, 0 IsView
FROM MetaTable
WHERE Table_id = @TableId


SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


