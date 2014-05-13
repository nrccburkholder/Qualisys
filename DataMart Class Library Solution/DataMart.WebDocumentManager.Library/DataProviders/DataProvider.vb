
Public MustInherit Class DataProvider

#Region " Singleton Implementation "
    Private Shared mInstance As DataProvider
    Private Const mProviderName As String = "DataProvider"
    Public Shared ReadOnly Property Instance() As DataProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of DataProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()
    End Sub

    Public MustOverride Function SelectDocumentBatch(ByVal batchId As Integer) As DocumentBatch
    Public MustOverride Function SelectDocumentBatchesByDateRange(ByVal fromDate As Date, ByVal toDate As Date) As DocumentBatchCollection
    Public MustOverride Function InsertDocumentBatch(ByVal instance As DocumentBatch) As Integer
    Public MustOverride Sub DeleteDocumentBatch(ByVal batchId As Integer)
    Public MustOverride Function CheckIfBatchNameInUse(ByVal name As String) As Boolean
End Class
