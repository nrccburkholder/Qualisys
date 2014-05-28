/*******************************************************************************
 *
 * Procedure Name:
 *           GHS_SelectPrinterTerm
 *
 * Description:
 *           Retrieve printer terminology
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
CREATE PROCEDURE dbo.GHS_SelectPrinterTerm (
        @AbbrLabel     varchar(16)
       )
AS
  SELECT *
    FROM GHS_PrinterTerm
   WHERE AbbrLabel = @AbbrLabel

  RETURN -1


