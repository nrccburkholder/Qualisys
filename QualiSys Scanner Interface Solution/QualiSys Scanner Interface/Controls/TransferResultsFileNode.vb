Imports Nrc.QualiSys.Scanning.Library

Public Class TransferResultsFileNode
    Inherits TreeNode

#Region " Private Fields "

    Private mSource As TransferResultsNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return String.Format("{0} ({1})", mSource.DataLoadName, mSource.DataLoadID)
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
            Return String.Format("VR{0}-DL{1}", mSource.VendorID, mSource.DataLoadID)
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
        If mSource.DataLoadHasBadLithos AndAlso mSource.DataLoadHasSurveyErrors Then
            ImageKey = TransferResultsImageKeys.DataLoadBadLithosAndSurveys
            SelectedImageKey = TransferResultsImageKeys.DataLoadBadLithosAndSurveys
        ElseIf mSource.DataLoadHasBadLithos Then
            ImageKey = TransferResultsImageKeys.DataLoadBadLithos
            SelectedImageKey = TransferResultsImageKeys.DataLoadBadLithos
        ElseIf mSource.DataLoadHasSurveyErrors Then
            ImageKey = TransferResultsImageKeys.DataLoadBadSurveys
            SelectedImageKey = TransferResultsImageKeys.DataLoadBadSurveys
        Else
            ImageKey = TransferResultsImageKeys.DataLoad
            SelectedImageKey = TransferResultsImageKeys.DataLoad
        End If

    End Sub

#End Region

End Class
