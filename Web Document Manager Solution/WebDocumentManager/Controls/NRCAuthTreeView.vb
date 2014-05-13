Imports NRC.DataMart.WebDocumentManager.Library
Imports System.Windows.Forms
Imports System.Drawing

Public Class NRCAuthTreeView
    Inherits System.Windows.Forms.TreeView

#Region " Component Designer generated code "

    Public Sub New()
        MyBase.New()

        ' This call is required by the Component Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.LabelEdit = True
    End Sub

    'Control overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Control Designer
    Private components As System.ComponentModel.IContainer

    ' NOTE: The following procedure is required by the Component Designer
    ' It can be modified using the Component Designer.  Do not modify it
    ' using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        components = New System.ComponentModel.Container
    End Sub

#End Region

    Protected Overrides Sub OnPaint(ByVal pe As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaint(pe)

        'Add your custom paint code here
    End Sub


#Region "public properties"
    Public ReadOnly Property SelectedDocumentNode() As DocumentNode
        Get
            If Not MyBase.SelectedNode.Tag Is Nothing Then
                Return DirectCast(MyBase.SelectedNode.Tag, DocumentNode)
            Else
                Return Nothing
            End If
        End Get
    End Property
#End Region

#Region "Overrides"
    'Override the MouseDown method so that we can select on a right-click
    Protected Overrides Sub OnMouseDown(ByVal e As MouseEventArgs)
        MyBase.OnMouseDown(e)

        If e.Button = MouseButtons.Right Then
            Dim pt As New Point(e.X, e.Y)
            Dim tmpTreeNode As TreeNode = Me.GetNodeAt(pt)
            Dim node As DocumentNode

            If Not tmpTreeNode Is Nothing Then
                node = DirectCast(tmpTreeNode.Tag, DocumentNode)
                If Not tmpTreeNode.IsSelected Then
                    Me.SelectedNode = tmpTreeNode
                End If
            End If
        End If

    End Sub
#End Region

#Region "Private Methods"



#End Region

End Class
