Imports Nrc.QualiSys.Scanning.Library

Public Class VendorFileSurveyNode
    Inherits TreeNode

#Region " Private Members "

    Private mSource As VendorFileNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} ({1})", mSource.SurveyName, mSource.SurveyID)
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
            Return String.Format("RT{0}-CL{1}-ST{2}-SD{3}", mSource.MailingStepMethodID, mSource.ClientID, mSource.StudyID, mSource.SurveyID)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal source As VendorFileNavigatorTree)

        'Save the source object
        mSource = source

        'Set the name and text
        Text = DisplayName
        Name = Key

        'Set the image
        ImageKey = VendorFileImageKeys.Survey
        SelectedImageKey = VendorFileImageKeys.Survey

    End Sub

#End Region

End Class