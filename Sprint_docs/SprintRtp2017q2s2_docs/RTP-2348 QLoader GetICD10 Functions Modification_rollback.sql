/*
	RTP-2348 QLoader GetICD10 Functions Modification

	Hector Mata
*/

USE [QP_Load]
GO


declare @function nvarchar(4000)
select @function = N'''Function GetHomeHealthICD10(strValue)
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

UPDATE dbo.functions
SET strFunction_Code = @function
WHERE strfunction_nm = 'GetHomeHealthICD10'


select @function = N'''Function GetHospiceICD10(strValue)
If Not IsNullOrBlank(strValue) Then
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
end function'
UPDATE dbo.functions
SET strFunction_Code = @function
WHERE strfunction_nm = 'GetHospiceICD10'

GO