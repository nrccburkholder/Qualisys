Imports NRC.Framework.BusinessLogic

Public MustInherit Class VendorFileTrackingProvider

#Region " Singleton Implementation "

    Private Shared mInstance As VendorFileTrackingProvider
    Private Const mProviderName As String = "VendorFileTrackingProvider"

    Public Shared ReadOnly Property Instance() As VendorFileTrackingProvider
        Get
            If mInstance Is Nothing Then
                mInstance = DataProviderFactory.CreateInstance(Of VendorFileTrackingProvider)(mProviderName)
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

    Public MustOverride Function SelectVendorFileTracking(ByVal id As Integer) As VendorFileTracking
    Public MustOverride Function SelectAllVendorFileTrackings() As VendorFileTrackingCollection
    Public MustOverride Function SelectVendorFileTrackingsByVendorFileID(ByVal vendorFileID As Integer) As VendorFileTrackingCollection
    Public MustOverride Function InsertVendorFileTracking(ByVal instance As VendorFileTracking) As Integer
    Public MustOverride Sub UpdateVendorFileTracking(ByVal instance As VendorFileTracking)
    Public MustOverride Sub DeleteVendorFileTracking(ByVal VendorFileTracking As VendorFileTracking)

#End Region

End Class

