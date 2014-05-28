/****** Object:  Stored Procedure dbo.sp_Queue_Update_Params    Script Date: 7/15/99 3:57:39 PM ******/
/****** Object:  Stored Procedure dbo.sp_Queue_Update_Params    Script Date: 7/15/99 10:03:50 AM ******/
CREATE PROCEDURE sp_Queue_Update_Params 
 @Param_nm varchar(50),
 @Column_nm varchar(50),
 @ParamValue varchar(50)
AS
 DECLARE @strSQL varchar(255)
 IF LOWER(@Column_nm) NOT IN ('numparam_value', 'datparam_value')
  BEGIN
   DECLARE @Msg  varchar(255)
   SELECT @Msg = "Invalid Column Name.  The '@Column_nm' parameter can only " +
      "accept 'strParam_value', 'numParam_value', or 'datParam_value'"
   RAISERROR (@Msg, 16, -1)
  END
 ELSE
  BEGIN
   IF LOWER(@Column_nm) = 'datparam_value'
    SELECT @ParamValue = "'" + @ParamValue + "'"
   SELECT @strSQL = "UPDATE dbo.QualPro_params " +
         " SET " + @Column_nm + " = " + @ParamValue +
         "  WHERE strParam_nm = '" + @Param_nm + "' " +
         "  AND strParam_grp = 'QueueManager'"
   EXECUTE (@strSQL)
  END


