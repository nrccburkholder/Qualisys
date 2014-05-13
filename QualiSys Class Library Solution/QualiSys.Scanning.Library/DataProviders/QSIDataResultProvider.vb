Imports NRC.Framework.BusinessLogic

Public MustInherit Class QSIDataResultProvider

#Region " Singleton Implementation "

    Private Shared mInstance As QSIDataResultProvider
    Private Const mProviderName As String = "QSIDataResultProvider"

    Public Shared ReadOnly Property Instance() As QSIDataResultProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of QSIDataResultProvider)(mProviderName)
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

    Public MustOverride Function SelectQSIDataResult(ByVal resultId As Integer) As QSIDataResult
    Public MustOverride Function SelectQSIDataResultsByFormId(ByVal formId As Integer) As QSIDataResultCollection
    Public MustOverride Function InsertQSIDataResult(ByVal instance As QSIDataResult) As Integer
    Public MustOverride Sub UpdateQSIDataResult(ByVal instance As QSIDataResult)
    Public MustOverride Sub DeleteQSIDataResult(ByVal QSIDataResult As QSIDataResult)
    Public MustOverride Sub DeleteQSIDataResultsByFormId(ByVal formId As Integer)
    Public MustOverride Sub DeleteQSIDataResultsByQstnCore(ByVal formId As Integer, ByVal qstnCore As Integer)

#End Region

End Class

