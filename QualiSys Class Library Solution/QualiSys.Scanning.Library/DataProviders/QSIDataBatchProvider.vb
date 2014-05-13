Public MustInherit Class QSIDataBatchProvider

#Region " Singleton Implementation "

    Private Shared mInstance As QSIDataBatchProvider
    Private Const mProviderName As String = "QSIDataBatchProvider"

    Public Shared ReadOnly Property Instance() As QSIDataBatchProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of QSIDataBatchProvider)(mProviderName)
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

    Public MustOverride Function SelectQSIDataBatch(ByVal batchId As Integer) As QSIDataBatch
    Public MustOverride Function SelectAllQSIDataBatches() As QSIDataBatchCollection
    Public MustOverride Function InsertQSIDataBatch(ByVal instance As QSIDataBatch) As Integer
    Public MustOverride Sub UpdateQSIDataBatch(ByVal instance As QSIDataBatch)
    Public MustOverride Sub DeleteQSIDataBatch(ByVal instance As QSIDataBatch)
    Public MustOverride Function IsQSIDataBatchComplete(ByVal batchId As Integer) As Boolean

#End Region

End Class

