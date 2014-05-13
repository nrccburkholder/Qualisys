Imports System.Data

Public MustInherit Class TranslatorProvider

#Region " Singleton Implementation "

    Private Shared mInstance As TranslatorProvider
    Private Const mProviderName As String = "TranslatorProvider"

    Public Shared ReadOnly Property Instance() As TranslatorProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of TranslatorProvider)(mProviderName)
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

    Public MustOverride Function GetDataTableCSV(ByVal queueFile As QueuedTransferFile) As DataTable
    Public MustOverride Function GetDataTableCSVHorz(ByVal queueFile As QueuedTransferFile) As DataTable
    Public MustOverride Function GetDataTableTABHorz(ByVal queueFile As QueuedTransferFile) As DataTable
    Public MustOverride Function GetDataTableCSVBedside(ByVal queueFile As QueuedTransferFile) As DataTable
    Public MustOverride Function GetVoviciSurveyScaleValues(ByVal surveyId As Integer, ByVal samplesetId As Integer) As DataSet
    Public MustOverride Function GetBedsideLithoCodeByMRNAdmitDate(ByVal mrn As String, ByVal admitDate As Date, ByVal studyID As Integer, ByVal surveyID As Integer) As String
    Public MustOverride Function GetBedsideLithoCodeByVisitNumAdmitDateVisitType(ByVal visitNum As String, ByVal admitDate As Date, ByVal visitType As String, ByVal studyID As Integer, ByVal surveyID As Integer) As String
    Public MustOverride Function SelectTranslationModuleMappings(ByVal translationModuleID As Integer) As DataTable
    Public MustOverride Function SelectTranslationModuleMappingRecodes(ByVal translationModuleMappingID As Integer) As DataTable

#End Region

End Class
