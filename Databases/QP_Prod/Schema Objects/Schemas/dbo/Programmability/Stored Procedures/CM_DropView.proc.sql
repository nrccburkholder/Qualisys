/*******************************************************************************
 *
 * Procedure Name:
 *           CM_DropView
 *
 * Description:
 *           Drop view
 *
 * Parameters:
 *           @ViewName    sysname
 *               view name
 *
 * Return:
 *           0:     Success
 *           Other: Fail
 *
 * History:
 *           2.0.0  04/17/2006 by Brian M
 *
 ******************************************************************************/
CREATE PROCEDURE dbo.CM_DropView (
         @ViewName   sysname
       )
AS
  DECLARE @bitExist           bit,
          @Sql                varchar(512)
  
  IF (dbo.CM_IsViewExisted(@ViewName) = 1) BEGIN
      SET @Sql = 'DROP View ' + @ViewName
      EXEC(@Sql)
  END
  
  RETURN 0


