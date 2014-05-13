Imports System.Collections.ObjectModel
Imports Nrc.DataMart.MySolutions.Library

Public Class StandardOneClickDialog

#Region " Private Members "

    Private mHasDataChanged As Boolean

    Private mDeletedOneClickTypes As Dictionary(Of Integer, OneClickType) = New Dictionary(Of Integer, Nrc.DataMart.MySolutions.Library.OneClickType)
    Private mDeletedOneClickDefinitions As Dictionary(Of Integer, OneClickDefinition) = New Dictionary(Of Integer, Nrc.DataMart.MySolutions.Library.OneClickDefinition)

#End Region

#Region " Private Properties "

    Private Property HasDataChanged() As Boolean
        Get
            Return mHasDataChanged
        End Get
        Set(ByVal value As Boolean)
            mHasDataChanged = value
            OneClickTypeNavigatorSaveTSButton.Enabled = value
        End Set
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        RestoreOneClickDialogProperties()

        OneClickTypeBindingSource.DataSource = OneClickType.GetAll()
        HasDataChanged = False

    End Sub

#End Region

#Region " Private Methods "


    Private Sub SaveOneClickSectionProperties()

        'Save the form location information
        My.Settings.StandardOneClickDialogSize = Me.Size

        'Save the grid layout
        Using ms As New IO.MemoryStream
            OneClickTypeGridView.SaveLayoutToStream(ms)
            Dim data() As Byte = ms.ToArray
            My.Settings.OneClickSectionGridLayout = data
        End Using

    End Sub


    Private Sub RestoreOneClickDialogProperties()

        'Restore the form location information
        Me.Size = My.Settings.StandardOneClickDialogSize

        'Restore the grid layout
        Dim data As Byte() = DirectCast(My.Settings.OneClickSectionGridLayout, Byte())
        If data IsNot Nothing Then
            Using ms As New IO.MemoryStream(data)
                OneClickTypeGridView.RestoreLayoutFromStream(ms)
            End Using
        End If

    End Sub

#End Region

#Region " Control Events "

#Region " Control Events - Form "

    Private Sub StandardOneClickDialog_FormClosing(ByVal sender As Object, ByVal e As System.Windows.Forms.FormClosingEventArgs) Handles Me.FormClosing

        If Not e.Cancel Then
            SaveOneClickSectionProperties()
        End If

    End Sub

#End Region

#End Region

End Class
