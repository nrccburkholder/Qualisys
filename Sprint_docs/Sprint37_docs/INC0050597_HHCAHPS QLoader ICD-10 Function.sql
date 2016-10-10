/*

	INC0050597 - HHCAHPS QLoader ICD-10 Function

	Problems with ICD10 function not correctly identifying ICD9 codes

	Caller"  Tara Duggar

	t appears that the GetICD10 function is not correctly identifying ICD9 codes that are being included in the field. Particularly, ICD9 V codes - V58.61, etc. For an example, please see: 

	W:\Client Project Folders\Indiana University Health\HHCAHPS\Central Region\Loaded 
	File: 269638_IU_IUHealth_HH_October_2015.csv 


	Tim Butler

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


SET @strFunction_nm = 'GetHomeHealthICD10'
SET @strFunction_Sig = 'GetHomeHealthICD10(strValue)'
SET @strFunction_dsc = 'Verify the format of the ICD-10 code.'
SET @strFunction_Code = 'Function GetHomeHealthICD10(strValue)
If Len(strValue) > 0 AND ISNULL(strValue) = false Then

dim objRegExp : set objRegExp = new RegExp

''first, check to see if this validates against ICD9 pattern
with objRegExp
	.Pattern =  "^(V\d{2}(\.\d{1,2})?|\d{3}(\.\d{1,2})?|E\d{3}(\.\d)?)$"
	.IgnoreCase = TRUE
	.Global = True
end with

If objRegExp.test(strValue) = TRUE Then
	GetHomeHealthICD10 = dbNull
Else
	'' not an ICD9, so validate against ICD10 pattern
	with objRegExp
		.Pattern =  "^[A-TV-Z][0-9][A-Z0-9](\.[A-Z0-9]{1,4})?$"
		.IgnoreCase = TRUE
		.Global = True
	end with
 
	If objRegExp.test(strValue) = TRUE Then
		GetHomeHealthICD10 = strValue
	Else
		GetHomeHealthICD10 = dbNull
	End If

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

 /*

 Function GetHomeHealthICD10(strValue)
If Len(strValue) > 0 AND ISNULL(strValue) = false Then
dim objRegExp : set objRegExp = new RegExp
with objRegExp
	.Pattern =  "^[A-TV-Z][0-9][A-Z0-9](\.[A-Z0-9]{1,4})?$"
	.IgnoreCase = TRUE
	.Global = True
end with
 
If objRegExp.test(strValue) = TRUE Then
	GetHomeHealthICD10 = strValue
Else
	GetHomeHealthICD10 = dbNull
End If

set objRegExp = nothing 
End If
End Function



'Function GetHomeHealthICD10(strValue)
If Len(strValue) > 0 AND ISNULL(strValue) = false Then

dim objRegExp : set objRegExp = new RegExp

''first, check to see if this validates against ICD9 pattern
with objRegExp
	.Pattern =  "^(V\d{2}(\.\d{1,2})?|\d{3}(\.\d{1,2})?|E\d{3}(\.\d)?)$"
	.IgnoreCase = TRUE
	.Global = True
end with

If objRegExp.test(strValue) = TRUE Then
	GetHomeHealthICD10 = dbNull
Else
	'' not an ICD9, so validate against ICD10 pattern
	with objRegExp
		.Pattern =  "^[A-TV-Z][0-9][A-Z0-9](\.[A-Z0-9]{1,4})?$"
		.IgnoreCase = TRUE
		.Global = True
	end with
 
	If objRegExp.test(strValue) = TRUE Then
		GetHomeHealthICD10 = strValue
	Else
		GetHomeHealthICD10 = dbNull
	End If

End If

set objRegExp = nothing

End If
End Function'
 */