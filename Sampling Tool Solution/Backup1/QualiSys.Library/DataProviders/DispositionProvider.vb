Imports NRC.Framework.BusinessLogic

Public MustInherit Class DispositionProvider

#Region " Singleton Implementation "

    Private Shared mInstance As DispositionProvider
    Private Const mProviderName As String = "DispositionProvider"

    Public Shared ReadOnly Property Instance() As DispositionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProvider.DataProviderFactory.CreateInstance(Of DispositionProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property
#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectDisposition(ByVal id As Integer) As Disposition
    Public MustOverride Function SelectAllDispositions() As DispositionCollection
    Public MustOverride Function InsertDisposition(ByVal instance As Disposition) As Integer
    Public MustOverride Sub UpdateDisposition(ByVal instance As Disposition)
    Public MustOverride Sub DeleteDisposition(ByVal Disposition As Disposition)

End Class

