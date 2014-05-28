/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectPaperSize
 *
 * Description:
 *           Retrieve paper size info
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
CREATE PROCEDURE dbo.GHS_SelectPaperSize (
        @strSizeCode      char(3)
       )
AS
  SELECT *
    FROM PaperSize
   WHERE strSizeCode = @strSizeCode
   
  RETURN -1


