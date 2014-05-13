Imports Nrc.QualiSys.Scanning.Library

Public Class DataEntryBatchNode
    Inherits TreeNode

#Region " Private Members "

    Private mSource As DataEntryNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return mSource.BatchName
        End Get
    End Property

    Public ReadOnly Property Source() As DataEntryNavigatorTree
        Get
            Return mSource
        End Get
    End Property

#End Region

#Region " Friend ReadOnly Properties "

    Friend ReadOnly Property Key() As String
        Get
            Return String.Format("DB{0}", mSource.BatchName)
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal source As DataEntryNavigatorTree)

        'Save the source object
        mSource = source

        'Set the name and text
        Text = DisplayName
        Name = Key

        'Set the image
        ImageKey = DataEntryImageKeys.Batch
        SelectedImageKey = DataEntryImageKeys.Batch

    End Sub

#End Region

End Class
