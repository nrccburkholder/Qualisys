Imports NRC.Framework.BusinessLogic

Public MustInherit Class QSIDataFormProvider

#Region " Singleton Implementation "

    Private Shared mInstance As QSIDataFormProvider
    Private Const mProviderName As String = "QSIDataFormProvider"

    Public Shared ReadOnly Property Instance() As QSIDataFormProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of QSIDataFormProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

#Region " Constructors "

    Protected Sub New()

    End Sub

#End Region

#Region " Public Methods "

    Public MustOverride Function SelectQSIDataForm(ByVal formId As Integer) As QSIDataForm
    Public MustOverride Function SelectQSIDataFormsByBatchId(ByVal batchId As Integer) As QSIDataFormCollection
    Public MustOverride Function SelectQSIDataFormsByTemplateName(ByVal batchId As Integer, ByVal templateName As String, ByVal dataEntryMode As DataEntryModes) As QSIDataFormCollection
    Public MustOverride Function InsertQSIDataForm(ByVal instance As QSIDataForm) As Integer
    Public MustOverride Sub UpdateQSIDataForm(ByVal instance As QSIDataForm)
    Public MustOverride Sub DeleteQSIDataForm(ByVal instance As QSIDataForm)
    Public MustOverride Function ValidateLithoCode(ByVal lithoCode As String) As String
    Public MustOverride Function CreateQSIDataForm(ByVal batchId As Integer, ByVal lithoCode As String) As QSIDataForm
    Public MustOverride Function SelectQSIDataFormQuestions(ByVal questionFormID As Integer, ByVal surveyID As Integer, ByVal langID As Integer) As Collection(Of QSIDataFormQuestion)

#End Region

End Class

