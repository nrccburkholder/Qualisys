Imports NRC.Framework.BusinessLogic
Imports System.Data.Common

Public MustInherit Class LithoCodeProvider

#Region " Singleton Implementation "

    Private Shared mInstance As LithoCodeProvider
    Private Const mProviderName As String = "LithoCodeProvider"

    Public Shared ReadOnly Property Instance() As LithoCodeProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of LithoCodeProvider)(mProviderName)
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

    Public MustOverride Function SelectLithoCode(ByVal lithoCodeId As Integer) As LithoCode
    Public MustOverride Function SelectLithoCodesBySurveyDataLoadId(ByVal surveyDataLoadId As Integer) As LithoCodeCollection
    Public MustOverride Function InsertLithoCode(ByVal instance As LithoCode) As Integer
    Public MustOverride Sub UpdateLithoCode(ByVal instance As LithoCode)
    Public MustOverride Sub DeleteLithoCode(ByVal instance As LithoCode)

    Public MustOverride Function CreateConnection() As DbConnection
    Public MustOverride Function SelectLithoCodePrevFinalDispoCount(ByVal instance As LithoCode) As Integer
    Public MustOverride Sub GetAdditionalInfo(ByVal instance As LithoCode)
    Public MustOverride Sub SaveLithoCodeToQualiSys(ByVal litho As LithoCode, ByVal transaction As DbTransaction)
    Public MustOverride Sub SaveQuestionResultToQualiSys(ByVal questionFormID As Integer, ByVal sampleUnitID As Integer, ByVal qstnCore As Integer, ByVal responseVal As Integer, ByVal transaction As DbTransaction)
    Public MustOverride Sub SaveHandEntryToQualiSys(ByVal litho As LithoCode, ByVal hand As HandEntry, ByVal transaction As DbTransaction)
    Public MustOverride Sub SavePopMappingToQualiSys(ByVal litho As LithoCode, ByVal pop As PopMapping, ByVal transaction As DbTransaction)
    Public MustOverride Sub SaveDispositionToQualiSys(ByVal litho As LithoCode, ByVal dispo As Disposition, ByVal userName As String, ByVal transaction As DbTransaction)
    Public MustOverride Sub SaveLangIdToQualiSys(ByVal litho As LithoCode, ByVal transaction As DbTransaction)

#End Region

End Class

