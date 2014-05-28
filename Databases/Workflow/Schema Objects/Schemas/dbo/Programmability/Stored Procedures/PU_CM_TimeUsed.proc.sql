/*******************************************************************************
 *
 * Procedure Name:
 *           PU_CM_TimeUsed
 *
 * Description:
 *           Check the time used for specific process
 *
 * Parameters:
 *           @pstrTitle      varchar(256)
 *             Process description
 *           @pdatBeginTime  datetime OUTPUT
 *             The begin time of the process.
 *
 * Return:
 *           -1:    Success
 *           Other: Fail
 *
 * History:
 *           1.0  11/28/2003 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.PU_CM_TimeUsed (
         @pstrTitle      varchar(256),
         @pdatBeginTime  datetime OUTPUT
       )
AS
  PRINT @pstrTitle + ': ' + CONVERT(varchar, DATEDIFF(ms, @pdatBeginTime, GETDATE())) + ' ms'
  SET @pdatBeginTime = GETDATE()
    
  RETURN 0


