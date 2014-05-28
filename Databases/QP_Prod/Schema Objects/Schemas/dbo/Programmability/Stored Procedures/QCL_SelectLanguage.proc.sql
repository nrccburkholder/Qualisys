/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     record from the Languages table for the corresponding ID				 */
/*                       										 */  
/* Date Created:  10/17/2005                  								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE QCL_SelectLanguage
@LangId INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT LangId, Language NRCLanguageLabel, WebLanguageLabel Language 
FROM Languages 
WHERE LangId = @LangId

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


