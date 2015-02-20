Imports Nrc.Framework.Data

Namespace DataProvider

    Public MustInherit Class FormGenJobProvider

#Region " Singleton Implementation "
        Private Shared mInstance As FormGenJobProvider
        Private Const mProviderName As String = "FormGenJobProvider"

        Public Shared ReadOnly Property Instance() As FormGenJobProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of FormGenJobProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub

        Public MustOverride Function SelectByGenerationDate(ByVal startDate As Date, ByVal endDate As Date) As Collection(Of FormGenJob)
        Public MustOverride Sub UpdatePriority(ByVal surveyId As Integer, ByVal priority As Integer)
        Public MustOverride Sub UpdateGenerationDate(ByVal surveyId As Integer, ByVal mailStepId As Integer, ByVal originalGenerationDate As Date, ByVal newGenerationDate As Date)
        Public MustOverride Sub ScheduleNextMailSteps()

        Protected Shared Function CreateFormGenJob(ByVal clientId As Integer, ByVal clientName As String, _
                                    ByVal studyId As Integer, ByVal studyName As String, _
                                    ByVal surveyId As Integer, ByVal surveyName As String, _
                                    ByVal mailStepId As Integer, ByVal mailStepName As String, _
                                    ByVal surveyType As String, ByVal generationDate As Date, ByVal priority As Integer, _
                                    ByVal formCount As Integer, ByVal isFormGenReleased As Boolean) As FormGenJob
            Dim obj As New FormGenJob
            obj.ClientId = clientId
            obj.ClientName = clientName
            obj.StudyId = studyId
            obj.StudyName = studyName
            obj.SurveyId = surveyId
            obj.SurveyName = surveyName
            obj.MailStepId = mailStepId
            obj.MailStepName = mailStepName
            obj.SurveyType = surveyType
            obj.GenerationDate = generationDate
            obj.OriginalGenerationDate = generationDate
            obj.Priority = priority
            obj.FormCount = formCount
            obj.IsFormGenerationReleased = isFormGenReleased
            obj.ResetDirtyFlag()

            Return obj
        End Function
    End Class
End Namespace
