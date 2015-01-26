Namespace DataProvider
    Public MustInherit Class LanguageProvider

#Region " Singleton Implementation "
        Private Shared mInstance As LanguageProvider
        Private Const mProviderName As String = "LanguageProvider"
        Public Shared ReadOnly Property Instance() As LanguageProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of LanguageProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region
        Protected Sub New()

        End Sub
        Public MustOverride Function [Select](ByVal languageId As Integer) As Language
        Public MustOverride Function SelectLanguagesAvailableForSurvey(ByVal surveyId As Integer) As Collection(Of Language)

        Protected NotInheritable Class ReadOnlyAccessor
            Private Sub New()
            End Sub

            Public Shared WriteOnly Property LanguageId(ByVal obj As Language) As Integer
                Set(ByVal value As Integer)
                    If obj IsNot Nothing Then
                        obj.Id = value
                    End If
                End Set
            End Property

        End Class
    End Class
End Namespace
