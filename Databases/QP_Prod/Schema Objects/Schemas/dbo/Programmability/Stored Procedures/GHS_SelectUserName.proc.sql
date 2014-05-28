/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectUserName
 *
 * Description:
 *           Retrieve employee name by NT login name
 *
 * Parameters:
 *           {parameter}  {data type}
 *              {brief parameter description}
 *           ...
 *
 * Return:
 *           -1:     Succeed
 *           Others: Failed
 *
 * History:
 *           1.0  10/31/2005 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.GHS_SelectUserName (
        @strNTLogin_NM         varchar(32)
       )
AS
  SELECT strEmployee_First_NM,
         strEmployee_Last_NM
    FROM Employee
   WHERE strNtLogin_NM = @strNtLogin_NM
  
  RETURN -1


