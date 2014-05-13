Imports NRC.Framework.BusinessLogic
Imports System.Data

Public MustInherit Class SurveyDataLoadProvider

#Region " Singleton Implementation "

    Private Shared mInstance As SurveyDataLoadProvider
    Private Const mProviderName As String = "SurveyDataLoadProvider"

    Public Shared ReadOnly Property Instance() As SurveyDataLoadProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of SurveyDataLoadProvider)(mProviderName)
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

    Public MustOverride Function SelectSurveyDataLoad(ByVal surveyDataLoadId As Integer) As SurveyDataLoad
    Public MustOverride Function SelectSurveyDataLoadsByDataLoadId(ByVal dataLoadId As Integer) As SurveyDataLoadCollection
    Public MustOverride Function InsertSurveyDataLoad(ByVal instance As SurveyDataLoad) As Integer
    Public MustOverride Sub UpdateSurveyDataLoad(ByVal instance As SurveyDataLoad)
    Public MustOverride Sub DeleteSurveyDataLoad(ByVal instance As SurveyDataLoad)

    Public MustOverride Function SelectValidationDataBySampleSet(ByVal sampleSetId As Integer) As DataSet

#End Region

End Class

