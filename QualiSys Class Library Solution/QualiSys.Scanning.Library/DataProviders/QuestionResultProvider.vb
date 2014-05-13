Imports NRC.Framework.BusinessLogic

Public MustInherit Class QuestionResultProvider

#Region " Singleton Implementation "

    Private Shared mInstance As QuestionResultProvider
    Private Const mProviderName As String = "QuestionResultProvider"

    Public Shared ReadOnly Property Instance() As QuestionResultProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of QuestionResultProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

#Region " Constructors "

    Protected Sub New()

    End Sub

#End Region

#Region " Public MustOverride Methods "

    Public MustOverride Function SelectQuestionResult(ByVal questionResultId As Integer) As QuestionResult
    Public MustOverride Function SelectQuestionResultsByLithoCodeId(ByVal lithoCodeId As Integer) As QuestionResultCollection
    Public MustOverride Function InsertQuestionResult(ByVal instance As QuestionResult) As Integer
    Public MustOverride Sub UpdateQuestionResult(ByVal instance As QuestionResult)
    Public MustOverride Sub DeleteQuestionResult(ByVal instance As QuestionResult)

#End Region

End Class

