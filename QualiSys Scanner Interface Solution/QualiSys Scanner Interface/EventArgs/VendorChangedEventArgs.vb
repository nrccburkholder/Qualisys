Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library

Public Class VendorChangedEventArgs
    Inherits EventArgs

    Private mVendor As Vendor

    Public ReadOnly Property CurrentVendor() As Vendor
        Get
            Return mVendor
        End Get
    End Property

    Sub New(ByVal myVendor As Vendor)
        mVendor = myVendor
    End Sub
End Class
