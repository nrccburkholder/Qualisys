/*******************************************************************************
 *
 * Function Name:
 *           CM_BeginOfDay
 *
 * Description:
 *           Begin of the day
 *
 * Parameters:
 *            @Day    datetime
 *              Given date
 *
 * Return:
 *           Begin of the day
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/

CREATE FUNCTION dbo.CM_BeginOfDay (
         @Day    datetime
       ) RETURNS datetime
AS
BEGIN
  RETURN(CONVERT(datetime, CONVERT(varchar, @Day, 111)))
END


