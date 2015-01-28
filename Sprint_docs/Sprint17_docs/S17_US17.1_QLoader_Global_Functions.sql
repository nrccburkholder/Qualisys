
USE [QP_Load]
GO

DECLARE @FunctionGroup_id int
DECLARE @strFunctionGroup_dsc varchar(42) = 'Hospice CAHPS'

IF NOT Exists (Select 1 FROM [dbo].[FunctionGroup] WHERE [strFunctionGroup_dsc] = @strFunctionGroup_dsc)
BEGIN

	INSERT INTO [dbo].[FunctionGroup]
			   ([strFunctionGroup_dsc]
			   ,[intParentFunctionGroup_id])
		 VALUES
			   ('Hospice CAHPS'
			   ,2)
	SELECT @FunctionGroup_id = SCOPE_IDENTITY()
END
ELSE 
BEGIN
	Select @FunctionGroup_id = FunctionGroup_id FROM [dbo].[FunctionGroup] WHERE [strFunctionGroup_dsc] = @strFunctionGroup_dsc
END

IF @FunctionGroup_id is null return

DECLARE @strFunction_nm varchar(42)
DECLARE @strFunction_Sig varchar(200)
DECLARE @strFunction_dsc varchar(200)
DECLARE @strFunction_Code varchar(5000)
DECLARE @bitVBS bit = 0
DECLARE @Client_id int = 0

SET @strFunction_nm = ''
SET @strFunction_Sig = ''
SET @strFunction_dsc = ''
SET @strFunction_Code = 'Function GetHCAHPSDischargeStatus(strDischargeStatus,strVisitType) 
    ''Only consider inpatient records
    If strVisitType = "I" Then
        Select Case strDischargeStatus
            Case "01","1","02","2","03","3","04","4","05","5","06","6","07","7","20","21","40","41","42","43","50","51","61","62","63","64","65","66","69","70","81","82","83","84","85","86","87","88","89","90","91","92","93","94","95"
                GetHCAHPSDischargeStatus = strDischargeStatus      
            Case Else
                GetHCAHPSDischargeStatus = "M"    ''code for missing value
        End Select
    Else
        GetHCAHPSDischargeStatus = dbNull
    End If
End Function'
SET @bitVBS = 0
SET @Client_id = 0


IF NOT Exists (Select 1 FROM [dbo].[Functions] WHERE [strFunction_nm] = @strFunction_nm)
BEGIN

	INSERT INTO [dbo].[Functions]
			   ([strFunction_nm]
			   ,[strFunction_Sig]
			   ,[strFunction_dsc]
			   ,[strFunction_Code]
			   ,[bitVBS]
			   ,[Client_id]
			   ,[FunctionGroup_id])
		 VALUES
			   (@strFunction_nm
			   ,@strFunction_Sig
			   ,@strFunction_dsc
			   ,@strFunction_Code
			   ,@bitVBS
			   ,@Client_id
			   ,@FunctionGroup_id)
END
ELSE
BEGIN

	UPDATE [dbo].[Functions]
	   SET [strFunction_Sig] = @strFunction_Sig
		  ,[strFunction_dsc] = @strFunction_dsc
		  ,[strFunction_Code] = @strFunction_Code
		  ,[bitVBS] = @bitVBS
		  ,[Client_id] = @Client_id
		  ,[FunctionGroup_id] = @FunctionGroup_id
	 WHERE [strFunction_nm] = @strFunction_nm

END
GO




 SELECT * 
 FROM [dbo].[Functions] 
 WHERE strFunction_nm = 'GetHCAHPSDischargeStatus' 
