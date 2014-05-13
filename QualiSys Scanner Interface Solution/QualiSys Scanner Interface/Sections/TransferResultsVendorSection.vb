Imports Nrc.QualiSys.Scanning.Library

Public Class TransferResultsVendorSection

#Region " Private Members "

    Private mNode As TransferResultsVendorNode
    Private mVendor As Vendor
    Private mErrorCodes As ErrorCodeCollection

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        'We do not allow saving yet so always return true
        Return True

    End Function

    Public Overrides Sub InactivateSection()

    End Sub

#End Region

#Region " Constructors "

    Public Sub New(ByVal errorCodes As ErrorCodeCollection)

        'Initialize the form
        InitializeComponent()

        'Save the parameters
        mErrorCodes = errorCodes

    End Sub

#End Region

#Region " Public Methods "

    Public Sub InitializeSection(ByVal node As TransferResultsVendorNode)

        'Save the parameters
        mNode = node
        mVendor = Vendor.Get(node.Source.VendorID)

        'This section is not yet implemented
        VendorSectionPanel.Caption = String.Format("Vendor Information: {0} ({1})", mVendor.VendorName, mVendor.VendorId)

    End Sub

#End Region

End Class
