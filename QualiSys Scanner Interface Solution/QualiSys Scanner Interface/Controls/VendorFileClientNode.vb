Imports Nrc.QualiSys.Scanning.Library

Public Class VendorFileClientNode
    Inherits TreeNode

#Region " Private Members "

    Private mSource As VendorFileNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} ({1})", mSource.ClientName, mSource.ClientID)
        End Get
    End Property

    Public ReadOnly Property Source() As VendorFileNavigatorTree
        Get
            Return mSource
        End Get
    End Property

#End Region

#Region " Friend ReadOnly Properties "

    Friend ReadOnly Property Key() As String
        Get
            Return String.Format("RT{0}-CL{1}", mSource.MailingStepMethodID, mSource.ClientID)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal source As VendorFileNavigatorTree)

        'Save the source object
        mSource = source

        'Set the name and text
        Me.Text = DisplayName
        Me.Name = Key

        'Set the image
        Me.ImageKey = VendorFileImageKeys.Client
        Me.SelectedImageKey = VendorFileImageKeys.Client

    End Sub

#End Region

End Class