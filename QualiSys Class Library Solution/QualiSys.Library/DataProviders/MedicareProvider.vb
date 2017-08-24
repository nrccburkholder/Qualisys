Namespace DataProvider
    Public MustInherit Class MedicareProvider

#Region " Singleton Implementation "

        Private Shared mInstance As MedicareProvider
        Private Const mProviderName As String = "MedicareProvider"

        Public Shared ReadOnly Property Instance() As MedicareProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MedicareProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Select](ByVal medicareNumber As String) As MedicareNumber
        Public MustOverride Function SelectAll() As MedicareNumberList
        Public MustOverride Function SelectAllAsDictionary() As Dictionary(Of String, MedicareNumber)
        Public MustOverride Function SelectBySurveyID(ByVal surveyID As Integer) As MedicareNumberList

        Public MustOverride Sub Insert(ByVal medicareNum As MedicareNumber)
        Public MustOverride Sub Update(ByVal medicareNum As MedicareNumber)
        Public MustOverride Sub Delete(ByVal medicareNumber As String)
        Public MustOverride Function AllowDelete(ByVal medicareNumber As String) As Boolean

        Public MustOverride Function GetHistoricAnnualVolume(ByVal MedicareNumber As String, ByVal propSampleDate As Date, Optional ByVal surveyTypeID As Integer = 2) As Integer
        Public MustOverride Function GetHistoricRespRate(ByVal MedicareNumber As String, ByVal propSampleDate As Date, Optional ByVal surveyTypeID As Integer = 2) As Decimal
        Public MustOverride Function HasHistoricValues(ByVal MedicareNumber As String, ByVal propSampleDate As Date, Optional ByVal surveyTypeID As Integer = 2) As Boolean
        Public MustOverride Function SelectSamplingLockedBySurveyIDs(ByVal surveyIDs As String) As DataTable
        Public MustOverride Function SelectLockedSampleUnitsByMedicareNumber(ByVal medicareNumber As String) As DataTable
        Public MustOverride Sub LogUnlockSample(ByVal medicareNumber As String, ByVal memberId As Integer, ByVal dateUnlocked As Date, Optional ByVal surveyTypeID As Integer = 2)

        Protected NotInheritable Class ReadOnlyAccessor

            Private Sub New()
            End Sub

        End Class

    End Class

End Namespace
