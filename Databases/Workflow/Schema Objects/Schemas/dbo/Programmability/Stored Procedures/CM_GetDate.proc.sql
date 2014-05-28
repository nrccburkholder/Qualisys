/*******************************************************************************
 *
 * Procedure Name:
 *           CM_GetDate
 *
 * Description:
 *           Get current date and time
 *
 * Parameters:
 *           N/A
 *
 * Return:
 *           Current date and time
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_GetDate
AS
  SELECT GETDATE() AS CurrentDate


