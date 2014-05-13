Imports Nrc.QualiSys.Scanning.Library

Public Class DataEntryTemplateNode
    Inherits TreeNode

#Region " Private Fields "

    Private mSource As DataEntryNavigatorTree

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property DisplayName() As String
        Get
            Return mSource.TemplateLabel
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
            Return String.Format("DB{0}-DT{1}", mSource.BatchName, mSource.TemplateName)
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
        ImageKey = DataEntryImageKeys.Survey
        SelectedImageKey = DataEntryImageKeys.Survey

    End Sub

#End Region

#Region " Public Methods "

    Public Sub Refresh()

        'Increment the appropriate quantity
        mSource.IncrementQuantity()

        'Update the display
        Text = DisplayName

    End Sub

#End Region

End Class
