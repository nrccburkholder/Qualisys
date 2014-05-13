Imports Nrc.QualiSys.Scanning.Library

Public Class TransferResultsVendorNode
    Inherits TreeNode

#Region " Private Members "

    Private mSource As TransferResultsNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} ({1})", mSource.VendorName, mSource.VendorID)
        End Get
    End Property

    Public ReadOnly Property Source() As TransferResultsNavigatorTree
        Get
            Return mSource
        End Get
    End Property

#End Region

#Region " Friend ReadOnly Properties "

    Friend ReadOnly Property Key() As String
        Get
            Return String.Format("VR{0}", mSource.VendorID)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal source As TransferResultsNavigatorTree)

        'Save the source object
        mSource = source

        'Set the name and text
        Me.Text = DisplayName
        Me.Name = Key

        'Set the image
        Me.ImageKey = TransferResultsImageKeys.Vendor
        Me.SelectedImageKey = TransferResultsImageKeys.Vendor

    End Sub

#End Region

End Class
