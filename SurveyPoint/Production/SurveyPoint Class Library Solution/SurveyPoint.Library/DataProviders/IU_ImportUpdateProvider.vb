Imports System.Data
Namespace DataProviders
    Public MustInherit Class IU_ImportUpdateProvider

#Region " Singleton Implementation "
        Private Shared mInstance As IU_ImportUpdateProvider
        Private Const mProviderName As String = "IU_ImportUpdateProvider"
        Public Shared ReadOnly Property Instance() As IU_ImportUpdateProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of IU_ImportUpdateProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property
#End Region

        Protected Sub New()
        End Sub
        Public MustOverride Function GetFileDefReaderByTemplateID(ByVal templateID As Integer) As DataTable
        Public MustOverride Function GetFileDefByFileDefID(ByVal filedefid As Integer) As DataTable
        Public MustOverride Function GetSurveyInstaceID(ByVal respondentID As Integer, ByVal clientID As Integer, ByVal surveyID As Integer) As Integer
        Public MustOverride Function GetResponseCount(ByVal respondentID As Integer) As Integer
        Public MustOverride Function GetSurveyQuestionValues(ByVal itemorder As Integer, ByVal surveyID As Integer) As DataTable
        Public MustOverride Function GetQuestionValues(ByVal questionID As Integer) As DataTable
    End Class
End Namespace
