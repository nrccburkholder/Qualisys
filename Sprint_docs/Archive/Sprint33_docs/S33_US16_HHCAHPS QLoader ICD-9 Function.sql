/*

S33 US16 - HHCAHPS QLoader ICD-9 Functions 

As a Data Mgmt Associate, I want the existing ICD-9 functions in QLoader updated to check if the values are ICD-9s, so that we load data into the correct fields


Task 16.1: change code in existing Q loader HHCAHPS ICD-9 functions 
	GetHomeHealthICD9
	GetHomeHealthPrimaryICD9


*/
USE [QP_Load]
GO

DECLARE @FunctionGroup_id int
DECLARE @strFunctionGroup_dsc varchar(42) 
SET @strFunctionGroup_dsc = 'HHCAHPS'

Select @FunctionGroup_id = FunctionGroup_id FROM [dbo].[FunctionGroup] WHERE [strFunctionGroup_dsc] = @strFunctionGroup_dsc


IF @FunctionGroup_id is null return

DECLARE @strFunction_nm varchar(42)
DECLARE @strFunction_Sig varchar(200)
DECLARE @strFunction_dsc varchar(200)
DECLARE @strFunction_Code varchar(5000)
DECLARE @bitVBS bit
DECLARE @Client_id int

DECLARE @IsUpdateFunction bit


SET @strFunction_nm = 'GetHomeHealthICD9'
SET @strFunction_Sig = 'GetHomeHealthICD9(strValue)'
SET @strFunction_dsc = 'Removes decimal and pads with leading zeros'
SET @strFunction_Code = 'Function GetHomeHealthICD9(strValue)
If Len(strValue) > 0 AND ISNULL(strValue) = false Then
dim objRegExp : set objRegExp = new RegExp
with objRegExp
	.Pattern =  "^(V\d{2}(\.\d{1,2})?|\d{3}(\.\d{1,2})?|E\d{3}(\.\d)?)$"
	.IgnoreCase = TRUE
	.Global = True
end with
 
If objRegExp.test(strValue) = TRUE Then
	If InStr(strValue,Chr(46)) Then          
        strValue = Replace(strValue, Chr(46), "")      
    End If  
    If IsNumeric(Left(strValue,1)) Then
        GetHomeHealthICD9 = Right("00000" & strValue, 5)
    Else
        GetHomeHealthICD9 = strValue
    End If
Else
	GetHomeHealthICD9 = dbNull
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



SET @strFunction_nm = 'GetHomeHealthPrimaryICD9'
SET @strFunction_Sig = 'GetHomeHealthPrimaryICD9(strValue)'
SET @strFunction_dsc = 'Returns HHCAHPS-acceptable Primary ICD9'
SET @strFunction_Code = 'Function GetHomeHealthPrimaryICD9(strValue)
If Len(strValue) > 0 AND ISNULL(strValue) = false Then
dim objRegExp : set objRegExp = new RegExp
with objRegExp
	.Pattern =  "^(V\d{2}(\.\d{1,2})?|\d{3}(\.\d{1,2})?|E\d{3}(\.\d)?)$"
	.IgnoreCase = TRUE
	.Global = True
end with
 
If objRegExp.test(strValue) = TRUE Then
	If InStr(strValue,Chr(46)) Then          
        strValue = Replace(strValue, Chr(46), "")      
    End If  
    If IsNumeric(Left(strValue,1)) Then
        GetHomeHealthPrimaryICD9 = Right("00000" & strValue, 5)
    Else
        If InStr(strValue,"E") Then
            GetHomeHealthPrimaryICD9 = dbNull
        Else
            GetHomeHealthPrimaryICD9 = strValue
        End If
    End If
Else
	GetHomeHealthPrimaryICD9 = dbNull
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


 SELECT *
 FROM functiongroup
 WHERE FunctionGroup_id = @FunctionGroup_id

 SELECT * 
 FROM [dbo].[Functions] 
 WHERE FunctionGroup_id = @FunctionGroup_id

 GO