/*******************************************************************************
 *
 * Function Name:
 *           YesterdayMidnight
 *
 * Description:
 *           ...
 *
 * Parameters:
 *            @datDate    datetime
 *              Given date
 *
 * Return:
 *           first day of the year
 *
 * History:
 *           {release}  {date} by {author}
 *             {release description}
 *
 ******************************************************************************/
CREATE FUNCTION dbo.YesterdayMidnight (
         @pdatTime      datetime
       ) RETURNS datetime
AS
BEGIN
  RETURN (CONVERT(datetime, CONVERT(varchar, DATEADD(day, -1, @pdatTime), 111) + ' 23:59:59:997'))
  
END


