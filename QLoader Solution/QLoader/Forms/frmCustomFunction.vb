Public Class frmCustomFunction
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal clientID As Integer)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()
        mClientID = clientID

        'Add any initialization after the InitializeComponent() call
        Me.LoadControl(Me.FunctionTree)
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
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
    Friend WithEvents cmnFunctions As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuNewFunction As System.Windows.Forms.MenuItem
    Friend WithEvents mnuModify As System.Windows.Forms.MenuItem
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    Friend WithEvents btnCreate As System.Windows.Forms.Button
    Friend WithEvents btnClose As System.Windows.Forms.Button
    Friend WithEvents pnlInput As System.Windows.Forms.Panel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmCustomFunction))
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.cmnFunctions = New System.Windows.Forms.ContextMenu
        Me.mnuNewFunction = New System.Windows.Forms.MenuItem
        Me.mnuModify = New System.Windows.Forms.MenuItem
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.btnCreate = New System.Windows.Forms.Button
        Me.btnClose = New System.Windows.Forms.Button
        Me.pnlInput = New System.Windows.Forms.Panel
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Function Library"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(318, 26)
        '
        'ImageList1
        '
        Me.ImageList1.ImageSize = New System.Drawing.Size(16, 16)
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        '
        'cmnFunctions
        '
        Me.cmnFunctions.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuNewFunction, Me.mnuModify})
        '
        'mnuNewFunction
        '
        Me.mnuNewFunction.Index = 0
        Me.mnuNewFunction.Text = "New Function"
        '
        'mnuModify
        '
        Me.mnuModify.Index = 1
        Me.mnuModify.Text = "Modify Function"
        '
        'btnCreate
        '
        Me.btnCreate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCreate.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCreate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCreate.Location = New System.Drawing.Point(8, 336)
        Me.btnCreate.Name = "btnCreate"
        Me.btnCreate.Size = New System.Drawing.Size(136, 23)
        Me.btnCreate.TabIndex = 8
        Me.btnCreate.Text = "Create Client Function"
        '
        'btnClose
        '
        Me.btnClose.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnClose.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnClose.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnClose.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClose.Location = New System.Drawing.Point(248, 336)
        Me.btnClose.Name = "btnClose"
        Me.btnClose.Size = New System.Drawing.Size(56, 23)
        Me.btnClose.TabIndex = 7
        Me.btnClose.Text = "Close"
        '
        'pnlInput
        '
        Me.pnlInput.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pnlInput.Location = New System.Drawing.Point(8, 40)
        Me.pnlInput.Name = "pnlInput"
        Me.pnlInput.Size = New System.Drawing.Size(298, 280)
        Me.pnlInput.TabIndex = 6
        '
        'frmCustomFunction
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.Caption = "Function Library"
        Me.ClientSize = New System.Drawing.Size(320, 375)
        Me.Controls.Add(Me.btnCreate)
        Me.Controls.Add(Me.btnClose)
        Me.Controls.Add(Me.pnlInput)
        Me.DockPadding.All = 1
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.Name = "frmCustomFunction"
        Me.Text = "Function Library"
        Me.Controls.SetChildIndex(Me.pnlInput, 0)
        Me.Controls.SetChildIndex(Me.btnClose, 0)
        Me.Controls.SetChildIndex(Me.btnCreate, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private WithEvents FunctionTree As FunctionTreeView
    Private mClientID As Integer

    Private Sub frmCustomFunction_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Get the function tree for this client (if one was selected) hide System Functions
        Me.FunctionTree = New FunctionTreeView(mClientID, True, False)
        'Load the tree onto the form
        Me.LoadControl(Me.FunctionTree)

        'Enable the "create client" button if a client was selected
        Me.btnCreate.Enabled = (mClientID > 0)
        'Attach the context menu
        Me.FunctionTree.ContextMenu = cmnFunctions
    End Sub

#Region " Context Menu Events "
    Private Sub cmnFunctions_Popup(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmnFunctions.Popup
        Dim i As Integer

        'Hide all the items by default
        For i = 0 To Me.cmnFunctions.MenuItems.Count - 1
            Me.cmnFunctions.MenuItems(i).Visible = False
        Next

        Dim node As FunctionTreeView.FunctionNode
        node = Me.FunctionTree.SelectedNode

        If Not node Is Nothing Then
            'If this is a "Global" group then show "New" option if user can
            If node.NodeID = 2 Then
                Me.mnuNewFunction.Visible = CurrentUser.IsFunctionAuthor
            End If

            'If this is a "Client" group then show "New" option no matter what
            If node.NodeID = 3 Then
                Me.mnuNewFunction.Visible = True
            End If

            'If this is a Function then we might show "Modify" option
            If Not node.FunctionID = 0 Then
                'If this is a client function then show it
                If node.ClientID > 0 Then
                    Me.mnuModify.Visible = True
                Else    'If this is global function then show only if user has rights
                    Me.mnuModify.Visible = CurrentUser.IsFunctionAuthor
                End If
            End If

        End If
    End Sub

    Private Sub mnuNewFunction_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuNewFunction.Click
        Dim node As FunctionTreeView.FunctionNode = Me.FunctionTree.SelectedNode

        If Not node Is Nothing Then
            'If this is a "Global" group
            If node.NodeID = 2 Then
                ShowFunctionEditor(node.FunctionID, 0, node.NodeID)
                'If this is a "Client" group
            ElseIf node.NodeID = 3 Then
                ShowFunctionEditor(node.FunctionID, mClientID, node.NodeID)
            End If
        End If

    End Sub

    Private Sub mnuModify_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuModify.Click
        Dim node As FunctionTreeView.FunctionNode = Me.FunctionTree.SelectedNode
        If Not node Is Nothing Then
            ShowFunctionEditor(node.FunctionID, node.ClientID, node.NodeID)
        End If
    End Sub
#End Region

    Private Sub ShowFunctionEditor(ByVal funcID As Integer, ByVal clientID As Integer, ByVal nodeID As Integer)
        'Dim node As FunctionTreeView.FunctionNode = Me.FunctionTree.SelectedNode
        Dim groupID As Integer
        Dim frmEditor As frmFunctionBuilder

        'Determine the group that the function will belong to
        If funcID = 0 Then
            groupID = nodeID
        ElseIf clientID = 0 Then
            groupID = 2
        Else
            groupID = 3
        End If

        'Create the Function Builder
        frmEditor = New frmFunctionBuilder(clientID, funcID, groupID)

        'Display it
        'Me.Hide()
        frmEditor.ShowDialog()
        'Me.Show()

        'Now refresh the tree
        Me.FunctionTree.RefreshTree()
    End Sub

    Private Sub LoadControl(ByVal ctrl As Control)
        'Load the control onto the form
        Me.pnlInput.Controls.Clear()

        If Not ctrl Is Nothing Then
            'Anchor the control to the panel
            ctrl.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
            'Position control
            ctrl.Location = New Point(0, 0)
            ctrl.Width = Me.pnlInput.Width
            ctrl.Height = Me.pnlInput.Height

            'Add new control to panel
            Me.pnlInput.Controls.Add(ctrl)
        End If
    End Sub

    Private Sub btnClose_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) handles btnClose.Click
        Me.Close()
    End Sub

    Private Sub btnCreate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) handles btnCreate.Click
        ' New client custom function node
        ShowFunctionEditor(0, mClientID, 3)
    End Sub

    Private Sub FunctionTree_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles FunctionTree.DoubleClick
        'Get the node being clicked
        Dim node As FunctionTreeView.FunctionNode = Me.FunctionTree.SelectedNode

        If Not node Is Nothing AndAlso node Is Me.FunctionTree.SelectedNode AndAlso node.Nodes.Count = 0 Then
            If (node.ClientID = 0 And CurrentUser.IsFunctionAuthor) Or node.ClientID > 0 Then
                ShowFunctionEditor(node.FunctionID, node.ClientID, node.NodeID)
            End If
        End If
    End Sub
End Class
