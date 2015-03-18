/*

	S17 US17 Hospice CAHPS QLoader Global Functions

	As an Implementation Associate, I want custom global functions in QLoader for Hospice CAHPS, so that the data will be loaded correctly and consistently.

	Document Requirements, Write functions and script them out. 

	Tim Butler

*/
USE [QP_Load]
GO

DECLARE @FunctionGroup_id int
DECLARE @strFunctionGroup_dsc varchar(42) 
SET @strFunctionGroup_dsc = 'Hospice CAHPS'

IF NOT Exists (Select 1 FROM [dbo].[FunctionGroup] WHERE [strFunctionGroup_dsc] = @strFunctionGroup_dsc)
BEGIN

	INSERT INTO [dbo].[FunctionGroup]
			   ([strFunctionGroup_dsc]
			   ,[intParentFunctionGroup_id])
		 VALUES
			   ( @strFunctionGroup_dsc
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
DECLARE @bitVBS bit
DECLARE @Client_id int

DECLARE @IsUpdateFunction bit

SET @strFunction_nm = 'HSPGetValidValues'
SET @strFunction_Sig = 'HSPGetValidValues(strValue,strField)'
SET @strFunction_dsc = 'Check for valid values for Hospice CAHPS data.Fields: "CaregiverRel", "Hispanic", "LastLoc", "Payer", "Race"'
SET @strFunction_Code = 'Function HSPGetValidValues(strValue,strField)
If IsNumeric(strValue) Then
	Select Case strField
	Case "CaregiverRel"
		HSPGetValidValues = CheckHospiceValues(CInt(strValue), 1, 7)
	Case "Hispanic"
		HSPGetValidValues = CheckHospiceValues(CInt(strValue), 1, 2)
	Case "LastLoc"
		HSPGetValidValues = CheckHospiceValues(CInt(strValue), 1, 10)
	Case "Payer"
		HSPGetValidValues = CheckHospiceValues(CInt(strValue), 1, 6)
	Case "Race"
		HSPGetValidValues = CheckHospiceValues(CInt(strValue), 1, 7)
	End Select
Else
	HSPGetValidValues = "M"
End If
End Function

Function CheckHospiceValues (intValue, intLow, intHigh)
If intValue >= intLow And intValue <= intHigh Then
	CheckHospiceValues = intValue
Else
	CheckHospiceValues = "M"
End If
End Function'

SET @bitVBS = 0
SET @Client_id = 0
SET @IsUpdateFunction = 0


IF NOT Exists (Select 1 FROM [dbo].[Functions] WHERE [strFunction_nm] = @strFunction_nm and [FunctionGroup_id] = @FunctionGroup_id)
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
ELSE IF @IsUpdateFunction = 1
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


SET @strFunction_nm = 'GetHospiceICD9'
SET @strFunction_Sig = 'GetHospiceICD9(strValue)'
SET @strFunction_dsc = 'Verify the format of the ICD-9 code.'
SET @strFunction_Code = 'Function GetHospiceICD9(strValue)
If Not IsNullOrBlank(strValue) Then
dim objRegExp : set objRegExp = new RegExp
with objRegExp
	.Pattern =  "^(V\d{2}(\.\d{1,2})?|\d{3}(\.\d{1,2})?|E\d{3}(\.\d)?)$"
	.IgnoreCase = TRUE
	.Global = True
end with
 
If objRegExp.test(strValue) = TRUE Then
	GetHospiceICD9 = strValue
Else
	GetHospiceICD9 = dbNull
End If

set objRegExp = nothing
End If
end function'

SET @bitVBS = 0
SET @Client_id = 0
SET @IsUpdateFunction = 1


IF NOT Exists (Select 1 FROM [dbo].[Functions] WHERE [strFunction_nm] = @strFunction_nm and [FunctionGroup_id] = @FunctionGroup_id)
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
ELSE IF @IsUpdateFunction = 1
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

SET @strFunction_nm = 'GetHospiceICD10'
SET @strFunction_Sig = 'GetHospiceICD10(strValue)'
SET @strFunction_dsc = 'Verify the format of the ICD-10 code.'
SET @strFunction_Code = 'Function GetHospiceICD10(strValue)
If not IsNullOrBlank(strValue) Then
dim objRegExp : set objRegExp = new RegExp
with objRegExp
    .Pattern =  "^[A-TV-Z][0-9][A-Z0-9](\.[A-Z0-9]{1,4})?$"
    .IgnoreCase = TRUE
    .Global = True
end with
 
If objRegExp.test(strValue) = TRUE Then
    GetHospiceICD10 = strValue
Else
    GetHospiceICD10 = dbNull
End If

set objRegExp = nothing 
End If
End Function'

SET @bitVBS = 0
SET @Client_id = 0
SET @IsUpdateFunction = 1


IF NOT Exists (Select 1 FROM [dbo].[Functions] WHERE [strFunction_nm] = @strFunction_nm and [FunctionGroup_id] = @FunctionGroup_id)
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
ELSE IF @IsUpdateFunction = 1
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

 SELECT *
 FROM functiongroup
 WHERE FunctionGroup_id = @FunctionGroup_id

 SELECT * 
 FROM [dbo].[Functions] 
 WHERE FunctionGroup_id = @FunctionGroup_id

 GO