Imports Nrc.QualiSys.Scanning.Library

Public Class VendorFileStudyNode
    Inherits TreeNode

#Region " Private Members "

    Private mSource As VendorFileNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} ({1})", mSource.StudyName, mSource.StudyID)
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
            Return String.Format("RT{0}-CL{1}-ST{2}", mSource.MailingStepMethodID, mSource.ClientID, mSource.StudyID)
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
        Me.ImageKey = VendorFileImageKeys.Study
        Me.SelectedImageKey = VendorFileImageKeys.Study

    End Sub

#End Region

End Class
