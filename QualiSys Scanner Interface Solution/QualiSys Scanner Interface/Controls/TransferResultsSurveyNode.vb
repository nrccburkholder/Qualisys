Imports Nrc.QualiSys.Scanning.Library

Public Class TransferResultsSurveyNode
    Inherits TreeNode

#Region " Private Members "

    Private mSource As TransferResultsNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} ({1})", mSource.SurveyName, mSource.SurveyID)
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
            Return String.Format("VR{0}-DL{1}-SD{2}", mSource.VendorID, mSource.DataLoadID, mSource.SurveyDataLoadID)
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
        If mSource.SurveyDataLoadHasErrors Then
            Me.ImageKey = TransferResultsImageKeys.SurveyDataLoadError
            Me.SelectedImageKey = TransferResultsImageKeys.SurveyDataLoadError
        Else
            Me.ImageKey = TransferResultsImageKeys.SurveyDataLoad
            Me.SelectedImageKey = TransferResultsImageKeys.SurveyDataLoad
        End If

    End Sub

#End Region

End Class