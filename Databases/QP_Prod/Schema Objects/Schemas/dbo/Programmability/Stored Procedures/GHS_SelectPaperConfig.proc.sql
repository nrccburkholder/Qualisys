/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectPaperConfig
 *
 * Description:
 *           Retrieve paper config info
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
CREATE PROCEDURE dbo.GHS_SelectPaperConfig (
        @PaperConfig_ID      int
       )
AS
  SELECT *
    FROM PaperConfig
   WHERE PaperConfig_ID = @PaperConfig_ID
   
  RETURN -1


