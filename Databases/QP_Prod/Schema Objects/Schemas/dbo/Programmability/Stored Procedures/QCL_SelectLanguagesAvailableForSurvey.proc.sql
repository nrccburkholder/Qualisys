/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     dataset representing the languages that are available for a survey			 */
/*                       										 */  
/* Date Created:  10/17/2005                  								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE QCL_SelectLanguagesAvailableForSurvey
@Survey_id INT
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT WebLanguageLabel Language, l.LangID, Language NRCLanguageLabel  
FROM Languages l, SurveyLanguage sl
WHERE sl.Survey_id=@Survey_id
AND sl.LangID=l.LangID    
ORDER BY WebLanguageLabel

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


