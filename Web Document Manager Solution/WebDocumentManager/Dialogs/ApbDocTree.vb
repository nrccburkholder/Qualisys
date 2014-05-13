Option Explicit On 
Option Strict On

Public Class ApbDocTree
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing Then
            If Not (components Is Nothing) Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend WithEvents tvwPath As System.Windows.Forms.TreeView
    Friend WithEvents imlIcon As System.Windows.Forms.ImageList
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(ApbDocTree))
        Me.btnClose = New System.Windows.Forms.Button
        Me.tvwPath = New System.Windows.Forms.TreeView
        Me.imlIcon = New System.Windows.Forms.ImageList(Me.components)
        Me.SuspendLayout()
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.Location = New System.Drawing.Point(285, 360)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.TabIndex = 0
        Me.btnClose.Text = "Close"
        '
        'tvwPath
        '
        Me.tvwPath.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tvwPath.ImageList = Me.imlIcon
        Me.tvwPath.Location = New System.Drawing.Point(16, 16)
        Me.tvwPath.Name = "tvwPath"
        Me.tvwPath.Size = New System.Drawing.Size(344, 336)
        Me.tvwPath.TabIndex = 1
        '
        'imlIcon
        '
        Me.imlIcon.ImageSize = New System.Drawing.Size(16, 16)
        Me.imlIcon.ImageStream = CType(resources.GetObject("imlIcon.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlIcon.TransparentColor = System.Drawing.Color.Transparent
        '
        'ApbDocTree
        '
        Me.AcceptButton = Me.btnClose
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnClose
        Me.ClientSize = New System.Drawing.Size(376, 398)
        Me.Controls.Add(Me.tvwPath)
        Me.Controls.Add(Me.btnClose)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimizeBox = False
        Me.Name = "ApbDocTree"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Document Path"
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members"

    Private Enum EntryType
        Node = 1
        Document = 2
    End Enum

    Private Structure Entry
        Dim EntryName As String
        Dim EntryType As EntryType

        Sub New(ByVal name As String, ByVal type As EntryType)
            EntryName = name
            EntryType = type
        End Sub
    End Structure

    Private mEntrys As New ArrayList

#End Region

#Region " Public Properties"

    Public WriteOnly Property Path() As String
        Set(ByVal Value As String)
            Value = Value.Trim
            Dim startPos As Integer = 0
            Dim endPos As Integer
            Dim isLastEntry As Boolean = False
            Dim name As String
            Dim type As EntryType

            mEntrys.Clear()
            Do While (startPos < Value.Length)
                Do While (Value.Substring(startPos, 1) = "\")
                    startPos += 1
                Loop
                endPos = Value.IndexOf("\", startPos)
                If (endPos < 0) Then
                    isLastEntry = True
                    endPos = Value.Length
                End If

                name = Value.Substring(startPos, endPos - startPos)
                type = CType(IIf(isLastEntry, EntryType.Document, EntryType.Node), EntryType)

                mEntrys.Add(New Entry(name, type))

                If (isLastEntry) Then Exit Do
                startPos = endPos + 1
            Loop
        End Set
    End Property

#End Region

    Private Sub ApbDocTree_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim entry As Entry
        Dim node As TreeNode = Nothing

        'EnableThemes(Me)
        tvwPath.BeginUpdate()
        tvwPath.Nodes.Clear()
        For Each entry In Me.mEntrys
            If (node Is Nothing) Then
                tvwPath.Nodes.Add(New TreeNode(entry.EntryName))
                node = tvwPath.Nodes(0)
            Else
                node.Nodes.Add(New TreeNode(entry.EntryName))
                node = node.Nodes(0)
            End If
            If (entry.EntryType = EntryType.Node) Then
                node.ImageIndex = 1
                node.SelectedImageIndex = 1
            Else
                node.ImageIndex = 2
                node.SelectedImageIndex = 2
            End If
        Next
        tvwPath.ExpandAll()
        tvwPath.EndUpdate()
    End Sub

    Private Sub tvwPath_AfterExpand(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles tvwPath.AfterExpand
        e.Node.ImageIndex = 1
    End Sub

    Private Sub tvwPath_AfterCollapse(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles tvwPath.AfterCollapse
        e.Node.ImageIndex = 0
    End Sub
End Class
