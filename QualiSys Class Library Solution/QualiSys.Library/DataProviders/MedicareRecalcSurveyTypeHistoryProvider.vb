Namespace DataProvider
    ''' <summary>Abstract class for DAL layer.</summary>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class MedicareRecalcSurveyTypeHistoryProvider

#Region " Singleton Implementation "

        Private Shared mInstance As MedicareRecalcSurveyTypeHistoryProvider
        Private Const mProviderName As String = "MedicareRecalcSurveyTypeHistoryProvider"

        Public Shared ReadOnly Property Instance() As MedicareRecalcSurveyTypeHistoryProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MedicareRecalcSurveyTypeHistoryProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Get](ByVal MedicareRecalcSurveyTypeHistoryID As Integer) As MedicareRecalcSurveyTypeHistory
        Public MustOverride Function GetAll() As MedicareRecalcSurveyTypeHistoryCollection
        Public MustOverride Function Insert(ByVal instance As MedicareRecalcSurveyTypeHistory) As Integer
        Public MustOverride Function GetLatestByMedicareNumber(ByVal medicareNumber As String, ByVal latestDate As Date, ByVal surveyTypeID As Integer) As MedicareRecalcSurveyTypeHistory
        Public MustOverride Function GetLatestBySampleDate(ByVal medicareNumber As String, ByVal sampleDate As Date, ByVal surveyTypeId As Integer) As MedicareRecalcSurveyTypeHistory

    End Class

End Namespace
