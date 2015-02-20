Namespace DataProvider

    Public MustInherit Class ContractedLanguageProvider

#Region " Singleton Implementation "

        Private Shared mInstance As ContractedLanguageProvider
        Private Const mProviderName As String = "ContractedLanguageProvider"

        Public Shared ReadOnly Property Instance() As ContractedLanguageProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of ContractedLanguageProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function SelectContractedLanguage(ByVal languageCode As String) As ContractedLanguage
        Public MustOverride Function SelectAllContractedLanguages() As ContractedLanguageCollection

    End Class

End Namespace

