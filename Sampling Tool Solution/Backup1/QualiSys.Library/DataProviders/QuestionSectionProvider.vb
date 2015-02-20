Namespace DataProvider

    Public MustInherit Class QuestionSectionProvider

#Region " Singleton Implementation "
        Private Shared mInstance As QuestionSectionProvider
        Private Const mProviderName As String = "QuestionSectionProvider"

        Public Shared ReadOnly Property Instance() As QuestionSectionProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of QuestionSectionProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectSectionsBySurveyId(ByVal surveyId As Integer) As Collection(Of QuestionSection)

    End Class

End Namespace