Imports NRC.Framework.BusinessLogic

'This class should go to your .Library project
Public MustInherit Class VendorDispositionProvider

#Region " Singleton Implementation "

    Private Shared mInstance As VendorDispositionProvider
    Private Const mProviderName As String = "VendorDispositionProvider"

    Public Shared ReadOnly Property Instance() As VendorDispositionProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorDispositionProvider)(mProviderName)
            End If

            Return mInstance
        End Get
    End Property

#End Region

    Protected Sub New()

    End Sub

    Public MustOverride Function SelectVendorDisposition(ByVal vendorDispositionId As Integer) As VendorDisposition
    Public MustOverride Function SelectVendorDispositionsByVendorId(ByVal vendorId As Integer) As VendorDispositionCollection
    Public MustOverride Function InsertVendorDisposition(ByVal instance As VendorDisposition) As Integer
    Public MustOverride Sub UpdateVendorDisposition(ByVal instance As VendorDisposition)
    Public MustOverride Sub DeleteVendorDisposition(ByVal VendorDisposition As VendorDisposition)

End Class

