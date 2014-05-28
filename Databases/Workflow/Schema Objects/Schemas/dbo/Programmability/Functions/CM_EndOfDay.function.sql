/*******************************************************************************
 *
 * Function Name:
 *           CM_EndOfDay
 *
 * Description:
 *           End of the day
 *
 * Parameters:
 *            @Day    datetime
 *              Given date
 *
 * Return:
 *           End of the day
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.CM_EndOfDay (
         @Day    datetime
       ) RETURNS datetime
AS
BEGIN
  RETURN(CONVERT(datetime, CONVERT(varchar, @Day, 111) + ' 23:59:59.997'))
END


