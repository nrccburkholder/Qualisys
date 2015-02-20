Namespace DataProvider
    ''' <summary>Abstract class for DAL layer.</summary>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public MustInherit Class MedicareRecalcHistoryProvider

#Region " Singleton Implementation "

        Private Shared mInstance As MedicareRecalcHistoryProvider
        Private Const mProviderName As String = "MedicareRecalcHistoryProvider"

        Public Shared ReadOnly Property Instance() As MedicareRecalcHistoryProvider
            Get
                If mInstance Is Nothing Then
                    mInstance = DataProviderFactory.CreateInstance(Of MedicareRecalcHistoryProvider)(mProviderName)
                End If

                Return mInstance
            End Get
        End Property

#End Region

        Protected Sub New()

        End Sub

        Public MustOverride Function [Get](ByVal medicareRecalcHistoryID As Integer) As MedicareRecalcHistory
        Public MustOverride Function GetAll() As MedicareRecalcHistoryCollection
        Public MustOverride Function Insert(ByVal instance As MedicareRecalcHistory) As Integer
        Public MustOverride Sub Update(ByVal instance As MedicareRecalcHistory)
        Public MustOverride Sub Delete(ByVal medicareRecalcHistoryID As Integer)
        Public MustOverride Function GetLatestByMedicareNumber(ByVal medicareNumber As String, ByVal latestDate As Date) As MedicareRecalcHistory
        Public MustOverride Function GetLatestBySampleDate(ByVal medicareNumber As String, ByVal sampleDate As Date) As MedicareRecalcHistory

    End Class

End Namespace

