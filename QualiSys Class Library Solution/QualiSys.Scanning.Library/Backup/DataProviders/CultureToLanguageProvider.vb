Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class CultureToLanguageProvider

#Region " Singleton Implementation "
    Private Shared mInstance As CultureToLanguageProvider
	Private Const mProviderName As String = "CultureToLanguageProvider"
	Public Shared ReadOnly Property Instance() As CultureToLanguageProvider
        Get
            If mInstance Is Nothing Then
				mInstance = DataProviderFactory.CreateInstance(Of CultureToLanguageProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

	Protected Sub New()
	End Sub

	Public MustOverride Function SelectCultureToLanguage(ByVal cultureLangID As Integer) As CultureToLanguage
	Public MustOverride Function SelectAllCultureToLanguages() As CultureToLanguageCollection
    Public MustOverride Function SelectByCultureCode(ByVal cultureCode As String) As CultureToLanguage
    Public MustOverride Function SelectByLanguageID(ByVal langID As Integer) As CultureToLanguage
End Class

