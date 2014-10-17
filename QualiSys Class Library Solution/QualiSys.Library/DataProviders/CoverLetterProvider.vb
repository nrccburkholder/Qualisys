Namespace DataProvider
    Public MustInherit Class CoverLetterProvider

#Region " Singleton Implementation "
        Private Shared mInstance As CoverLetterProvider
        Private Const mProviderName As String = "CoverLetterProvider"

        Public Shared ReadOnly Property Instance() As CoverLetterProvider
            <DebuggerHidden()> Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of CoverLetterProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectBySurveyId(ByVal surveyId As Integer) As Collection(Of CoverLetter)
        Public MustOverride Function SelectBySurveyIdAndPageType(ByVal surveyId As Integer, ByVal pageType As Integer) As Collection(Of CoverLetter)
        Public MustOverride Function SelectBySurveyIdAndPageTypes(ByVal surveyId As Integer, ByVal pageTypes As Integer()) As Collection(Of CoverLetter)

        Protected Shared Function CreateCoverLetter(ByVal id As Integer, ByVal name As String) As CoverLetter
            Dim letter As New CoverLetter
            letter.Id = id
            letter.Name = name

            Return letter
        End Function

        Protected Shared Function CreateCoverLetter(ByVal id As Integer, ByVal surveyid As Integer, ByVal name As String, ByVal items As List(Of CoverLetterItem)) As CoverLetter
            Dim letter As New CoverLetter

            letter.Id = id
            letter.Survey_Id = surveyid
            letter.Name = name
            letter.Items = items

            Return letter
        End Function

    End Class

End Namespace
