'This file should be in your SQLDataProvider project
'Stored procedure names for DAL
#Region " SP Declarations "
Public NotInheritable Partial Class SP
	'Uncomment the following lines in ONLY ONE of the SP classes if needed.
	'Private Sub New()
	'End Sub
    Public Const SelectAllCultureToLanguages As String = "dbo.QSL_SelectAllCultureToLanguages"
	Public Const SelectCultureToLanguage As String = "dbo.QSL_SelectCultureToLanguage"
    Public Const SelectCultureToLanguageByCultureCode As String = "dbo.QSL_SelectCultureToLanguageByCultureCode"
    Public Const SelectCultureToLanguageByLanguageID As String = "dbo.QSL_SelectCultureToLanguageByLanguageID"
End Class
#End Region
