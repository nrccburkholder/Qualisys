/*********************************************************************************************************/  
/*                       										 */  
/* Business Purpose: This procedure is used to support the Qualisys Class Library.  It returns a single  */ 
/*   		     record representing the QualiSys Parameter that matches the given parameter name	 */
/*                       										 */  
/* Date Created:  10/17/2005                  								 */  
/*                       										 */  
/* Created by:  Joe Camp                   								 */  
/*                       										 */  
/*********************************************************************************************************/  
CREATE PROCEDURE QCL_SelectQualiSysParam
@ParamName VARCHAR(20)
AS

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED  
SET NOCOUNT ON  

SELECT Param_id, strParam_nm, strParam_grp, Comments, strParam_Type, 
  numParam_Value, strParam_Value, datParam_Value
FROM QualPro_Params 
WHERE strParam_nm=@ParamName

SET TRANSACTION ISOLATION LEVEL READ COMMITTED  
SET NOCOUNT OFF


