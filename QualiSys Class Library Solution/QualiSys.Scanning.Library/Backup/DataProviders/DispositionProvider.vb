Imports NRC.Framework.BusinessLogic

Public MustInherit Class DispositionProvider

#Region " Singleton Implementation "

    Private Shared mInstance As DispositionProvider
    Private Const mProviderName As String = "DispositionProvider"

    Public Shared ReadOnly Property Instance() As DispositionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of DispositionProvider)(mProviderName)
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

    Public MustOverride Function SelectDisposition(ByVal dispositionId As Integer) As Disposition
    Public MustOverride Function SelectDispositionsByLithoCodeId(ByVal lithoCodeId As Integer) As DispositionCollection
    Public MustOverride Function InsertDisposition(ByVal instance As Disposition) As Integer
    Public MustOverride Sub UpdateDisposition(ByVal instance As Disposition)
    Public MustOverride Sub DeleteDisposition(ByVal instance As Disposition)

#End Region

End Class

