Imports Nrc.Qualisys.QLoader.Library.SqlProvider

Public Class frmFormula
    Inherits System.Windows.Forms.Form

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal DestColumn As DestinationColumn, ByVal ClientID As Integer)
        MyBase.New()
        Me.mDestination = DestColumn
        Me.mClientID = ClientID

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
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents SectionPanel1 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents Caption As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents SectionPanel2 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents PaneCaption1 As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents tvwSourceFields As System.Windows.Forms.TreeView
    Friend WithEvents SectionPanel3 As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents PaneCaption2 As Nrc.Framework.WinForms.PaneCaption
    Friend WithEvents txtFormula As System.Windows.Forms.TextBox
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
    Friend WithEvents pnlFunction As System.Windows.Forms.Panel
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    Friend WithEvents btnExecute As System.Windows.Forms.Button
    Friend WithEvents txtFunctionDesc As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmFormula))
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.SectionPanel2 = New Nrc.Framework.WinForms.SectionPanel
        Me.pnlFunction = New System.Windows.Forms.Panel
        Me.PaneCaption1 = New Nrc.Framework.WinForms.PaneCaption
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.SectionPanel1 = New Nrc.Framework.WinForms.SectionPanel
        Me.tvwSourceFields = New System.Windows.Forms.TreeView
        Me.Caption = New Nrc.Framework.WinForms.PaneCaption
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.SectionPanel3 = New Nrc.Framework.WinForms.SectionPanel
        Me.txtFunctionDesc = New System.Windows.Forms.TextBox
        Me.btnExecute = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.PaneCaption2 = New Nrc.Framework.WinForms.PaneCaption
        Me.txtFormula = New System.Windows.Forms.TextBox
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.Panel1.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.SectionPanel2)
        Me.Panel1.Controls.Add(Me.Splitter1)
        Me.Panel1.Controls.Add(Me.SectionPanel1)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(624, 272)
        Me.Panel1.TabIndex = 2
        '
        'SectionPanel2
        '
        Me.SectionPanel2.Controls.Add(Me.pnlFunction)
        Me.SectionPanel2.Controls.Add(Me.PaneCaption1)
        Me.SectionPanel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(258, 0)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.Size = New System.Drawing.Size(366, 272)
        Me.SectionPanel2.TabIndex = 4
        '
        'pnlFunction
        '
        Me.pnlFunction.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlFunction.Location = New System.Drawing.Point(1, 27)
        Me.pnlFunction.Name = "pnlFunction"
        Me.pnlFunction.Size = New System.Drawing.Size(364, 244)
        Me.pnlFunction.TabIndex = 5
        '
        'PaneCaption1
        '
        Me.PaneCaption1.Caption = "Functions"
        Me.PaneCaption1.Dock = System.Windows.Forms.DockStyle.Top
        Me.PaneCaption1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.PaneCaption1.Location = New System.Drawing.Point(1, 1)
        Me.PaneCaption1.Name = "PaneCaption1"
        Me.PaneCaption1.Size = New System.Drawing.Size(364, 26)
        Me.PaneCaption1.TabIndex = 4
        '
        'Splitter1
        '
        Me.Splitter1.Location = New System.Drawing.Point(256, 0)
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(2, 272)
        Me.Splitter1.TabIndex = 3
        Me.Splitter1.TabStop = False
        '
        'SectionPanel1
        '
        Me.SectionPanel1.Controls.Add(Me.tvwSourceFields)
        Me.SectionPanel1.Controls.Add(Me.Caption)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Left
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.Size = New System.Drawing.Size(256, 272)
        Me.SectionPanel1.TabIndex = 2
        '
        'tvwSourceFields
        '
        Me.tvwSourceFields.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tvwSourceFields.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tvwSourceFields.FullRowSelect = True
        Me.tvwSourceFields.ImageIndex = -1
        Me.tvwSourceFields.Location = New System.Drawing.Point(1, 27)
        Me.tvwSourceFields.Name = "tvwSourceFields"
        Me.tvwSourceFields.Nodes.AddRange(New System.Windows.Forms.TreeNode() {New System.Windows.Forms.TreeNode("Source Fields", New System.Windows.Forms.TreeNode() {New System.Windows.Forms.TreeNode("FName"), New System.Windows.Forms.TreeNode("LName"), New System.Windows.Forms.TreeNode("MRN"), New System.Windows.Forms.TreeNode("Addr"), New System.Windows.Forms.TreeNode("City"), New System.Windows.Forms.TreeNode("State"), New System.Windows.Forms.TreeNode("Zip5"), New System.Windows.Forms.TreeNode("Zip4"), New System.Windows.Forms.TreeNode("DOB")})})
        Me.tvwSourceFields.SelectedImageIndex = -1
        Me.tvwSourceFields.Size = New System.Drawing.Size(254, 244)
        Me.tvwSourceFields.TabIndex = 6
        '
        'Caption
        '
        Me.Caption.Caption = "[POPULATION - Addr]"
        Me.Caption.Dock = System.Windows.Forms.DockStyle.Top
        Me.Caption.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.Caption.Location = New System.Drawing.Point(1, 1)
        Me.Caption.Name = "Caption"
        Me.Caption.Size = New System.Drawing.Size(254, 26)
        Me.Caption.TabIndex = 4
        '
        'ImageList1
        '
        Me.ImageList1.ImageSize = New System.Drawing.Size(16, 16)
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        '
        'SectionPanel3
        '
        Me.SectionPanel3.Controls.Add(Me.txtFunctionDesc)
        Me.SectionPanel3.Controls.Add(Me.btnExecute)
        Me.SectionPanel3.Controls.Add(Me.btnCancel)
        Me.SectionPanel3.Controls.Add(Me.btnOK)
        Me.SectionPanel3.Controls.Add(Me.PaneCaption2)
        Me.SectionPanel3.Controls.Add(Me.txtFormula)
        Me.SectionPanel3.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel3.DockPadding.All = 1
        Me.SectionPanel3.Location = New System.Drawing.Point(0, 272)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.Size = New System.Drawing.Size(624, 232)
        Me.SectionPanel3.TabIndex = 6
        '
        'txtFunctionDesc
        '
        Me.txtFunctionDesc.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtFunctionDesc.BackColor = System.Drawing.SystemColors.ControlLightLight
        Me.txtFunctionDesc.Enabled = False
        Me.txtFunctionDesc.ForeColor = System.Drawing.Color.Black
        Me.txtFunctionDesc.Location = New System.Drawing.Point(4, 136)
        Me.txtFunctionDesc.Multiline = True
        Me.txtFunctionDesc.Name = "txtFunctionDesc"
        Me.txtFunctionDesc.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtFunctionDesc.Size = New System.Drawing.Size(612, 56)
        Me.txtFunctionDesc.TabIndex = 11
        Me.txtFunctionDesc.Text = ""
        '
        'btnExecute
        '
        Me.btnExecute.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.btnExecute.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnExecute.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnExecute.Location = New System.Drawing.Point(24, 200)
        Me.btnExecute.Name = "btnExecute"
        Me.btnExecute.Size = New System.Drawing.Size(64, 23)
        Me.btnExecute.TabIndex = 10
        Me.btnExecute.Text = "Execute"
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.Location = New System.Drawing.Point(536, 200)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(64, 23)
        Me.btnCancel.TabIndex = 8
        Me.btnCancel.Text = "Cancel"
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.Location = New System.Drawing.Point(456, 200)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(64, 23)
        Me.btnOK.TabIndex = 7
        Me.btnOK.Text = "OK"
        '
        'PaneCaption2
        '
        Me.PaneCaption2.Caption = "Edit Formula"
        Me.PaneCaption2.Dock = System.Windows.Forms.DockStyle.Top
        Me.PaneCaption2.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.PaneCaption2.Location = New System.Drawing.Point(1, 1)
        Me.PaneCaption2.Name = "PaneCaption2"
        Me.PaneCaption2.Size = New System.Drawing.Size(622, 26)
        Me.PaneCaption2.TabIndex = 4
        '
        'txtFormula
        '
        Me.txtFormula.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtFormula.Location = New System.Drawing.Point(4, 32)
        Me.txtFormula.Multiline = True
        Me.txtFormula.Name = "txtFormula"
        Me.txtFormula.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtFormula.Size = New System.Drawing.Size(612, 96)
        Me.txtFormula.TabIndex = 9
        Me.txtFormula.Text = ""
        '
        'frmFormula
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.ClientSize = New System.Drawing.Size(624, 504)
        Me.Controls.Add(Me.SectionPanel3)
        Me.Controls.Add(Me.Panel1)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MinimumSize = New System.Drawing.Size(536, 440)
        Me.Name = "frmFormula"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent
        Me.Text = "Edit Formula - [Population_Load.FullName]"
        Me.Panel1.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mDestination As DestinationColumn       'The destination colunm of this formula
    Private mClientID As Integer
    Private WithEvents FunctionTree As FunctionTreeView
    Private mScript As New MSScriptControl.ScriptControl

    Private Sub frmFormula_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Set the window title
        'Me.Text = String.Format("Edit Formula - [{0}.{1}]", DirectCast(Me.mDestination.Parent, DTSDestination).TableName, Me.mDestination.ColumnName)
        Me.Caption.Caption = String.Format("[{0}.{1}]", DirectCast(Me.mDestination.Parent, DTSDestination).TableName, Me.mDestination.ColumnName)
        'Set the initial value of the formula
        If Me.mDestination.Formula = "" Then
            Me.txtFormula.Text = String.Format("{0} = ", Me.mDestination.ToString)
        Else
            Me.txtFormula.Text = Me.mDestination.Formula
        End If

        'Place cursor at the end of the text box
        Me.txtFormula.SelectionStart = Me.txtFormula.Text.Length

        'Load all the available source fields into the treeview
        LoadSourceNodes()

        ' Load function tree.
        Me.FunctionTree = New FunctionTreeView(mClientID, True, True)
        Me.LoadControl(Me.FunctionTree)

        Me.txtFormula.Focus()
    End Sub

    Private Sub LoadSourceNodes()
        'Clear all nodes
        Me.tvwSourceFields.Nodes.Clear()
        'Create the root node
        Dim root As New TreeNode("Source Fields")
        Dim node As TreeNode
        Dim Source As Column

        'For every source in this mapping
        For Each Source In Me.mDestination.SourceColumns
            'Create the new node in the tree
            node = New TreeNode(Source.ColumnName)
            node.Tag = Source
            root.Nodes.Add(node)        'Add node to the root
        Next
        root.Expand()       'Root should default to expanded

        Me.tvwSourceFields.Nodes.Add(root)  'Add the root to the tree
    End Sub

#Region " Functions Tree Events "

    Private Sub FunctionTree_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles FunctionTree.AfterSelect
        Me.txtFunctionDesc.Text = Me.FunctionTree.SelectedNode.ToolTip
    End Sub

    Private Sub FunctionTree_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FunctionTree.DoubleClick
        'Get the node being clicked
        Dim ptTree As Point = Me.FunctionTree.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim node As TreeNode = Me.FunctionTree.GetNodeAt(ptTree)

        'If we have a node and it is the selected node and it is not a parent
        If Not node Is Nothing AndAlso node Is Me.FunctionTree.SelectedNode AndAlso node.Nodes.Count = 0 Then
            'Insert text
            Me.InsertFormulaText(node.Text)
        End If
    End Sub

    Private Sub FunctionTree_ItemDrag(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ItemDragEventArgs) Handles FunctionTree.ItemDrag
        'Get the node being drug
        Dim ptTree As Point = Me.FunctionTree.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim node As TreeNode = Me.FunctionTree.GetNodeAt(ptTree)

        'If we have a node then do the drag drop
        If Not node Is Nothing Then
            node = CType(Me.FunctionTree.GetNodeAt(ptTree).Clone, TreeNode)
            Me.FunctionTree.DoDragDrop(node, DragDropEffects.All)
        End If
    End Sub

    Private Sub LoadControl(ByVal ctrl As Control)
        Me.pnlFunction.Controls.Clear()

        If Not ctrl Is Nothing Then
            'Anchor the control to the panel
            ctrl.Anchor = AnchorStyles.Top Or AnchorStyles.Bottom Or AnchorStyles.Left Or AnchorStyles.Right
            'Position control
            ctrl.Location = New Point(0, 0)
            ctrl.Width = Me.pnlFunction.Width
            ctrl.Height = Me.pnlFunction.Height

            'Add new control to panel
            Me.pnlFunction.Controls.Add(ctrl)
        End If
    End Sub

#End Region

#Region " Source Tree Events "

    Private Sub tvwSourceFields_ItemDrag(ByVal sender As System.Object, ByVal e As System.Windows.Forms.ItemDragEventArgs) Handles tvwSourceFields.ItemDrag
        'Get the node being drug
        Dim ptTree As Point = Me.tvwSourceFields.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim node As TreeNode = Me.tvwSourceFields.GetNodeAt(ptTree)

        'If we got a node
        If Not node Is Nothing Then
            'make a COPY of the node and change the text
            node = CType(Me.tvwSourceFields.GetNodeAt(ptTree).Clone, TreeNode)
            node.Text = String.Format("DTSSource(""{0}"")", node.Text)

            'Do the drag
            Me.tvwSourceFields.DoDragDrop(node, DragDropEffects.All)
        End If
    End Sub

    Private Sub tvwSourceFields_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles tvwSourceFields.DoubleClick
        'Get the node being clicked
        Dim ptTree As Point = Me.tvwSourceFields.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim node As TreeNode = Me.tvwSourceFields.GetNodeAt(ptTree)

        'If we have a node and it is the selected node and it is not a parent
        If Not node Is Nothing AndAlso node Is Me.tvwSourceFields.SelectedNode AndAlso node.Nodes.Count = 0 Then
            'Insert text
            Me.InsertFormulaText(String.Format("DTSSource(""{0}"")", node.Text))
        End If
    End Sub

#End Region

#Region " Formula Events "
    Private Sub txtFormula_DragDrop(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles txtFormula.DragDrop
        Try
            'Get the node being dropped
            Dim node As New TreeNode
            node = CType(e.Data.GetData(node.GetType.ToString, True), TreeNode)

            'Insert the text from the node
            Me.InsertFormulaText(node.Text)
        Catch ex As Exception
        End Try
    End Sub

    Private Sub txtFormula_DragOver(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles txtFormula.DragOver
        'Show the right icon when dragging
        e.Effect = DragDropEffects.Move
    End Sub

    Private Sub txtFormula_DragEnter(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DragEventArgs) Handles txtFormula.DragEnter
        'Give text box the focus
        Me.txtFormula.Focus()
    End Sub

    Private Sub InsertFormulaText(ByVal text As String)
        Dim Start As Integer = Me.txtFormula.SelectionStart
        Dim Len As Integer = Me.txtFormula.SelectionLength
        Me.txtFormula.Focus()

        'Remove any hilighted text
        Me.txtFormula.Text = Me.txtFormula.Text.Remove(Start, Len)

        'Insert the new text where the cursor was
        Me.txtFormula.Text = Me.txtFormula.Text.Insert(Start, text)

        'Place the cursor at the end of the new text
        Me.txtFormula.SelectionStart += Start + text.Length
    End Sub

#End Region

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        If Me.mDestination.Formula = "" Then
            Me.txtFormula.Text = String.Format("{0} = ", Me.mDestination.ToString)
        Else
            Me.txtFormula.Text = Me.mDestination.Formula
        End If

        Me.UpdateSources()
        Me.Close()
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        'Make sure the formula is valid then save it
        If Me.ValidateFormula(Me.txtFormula.Text) Then
            Me.mDestination.Formula = Me.txtFormula.Text
            Me.UpdateSources()
            Me.Close()
        End If
    End Sub

    Private Sub UpdateSources()
        Dim i As Integer
        Dim Col As SourceColumn
        Dim RemoveList As New List(Of Integer)

        For i = 0 To Me.mDestination.SourceColumns.Count - 1
            Col = DirectCast(Me.mDestination.SourceColumns(i), SourceColumn)
            If Me.txtFormula.Text.ToLower.IndexOf(String.Format("dtssource(""{0}"")", Col.ColumnName.ToLower)) >= 0 Then
            Else
                Col.MapCount -= 1
                RemoveList.Add(i - RemoveList.Count)
            End If
        Next

        For i = 0 To RemoveList.Count - 1
            Me.mDestination.SourceColumns.RemoveAt(RemoveList(i))
        Next
    End Sub

    Private Function ValidateFormula(ByVal Formula As String) As Boolean
        'Removed on 5/18/2004 - JPC
        'Formulas might be in form If 1=1 then DTSDestination("xyz") = 3 Else ...
        ''Ensure that formula begins with DTSDestination("field") =
        'If Not Formula.StartsWith(String.Format("{0} =", Me.mDestination.ToString)) Then
        '    MessageBox.Show(String.Format("Invalid Formula.  Formula must begin with {0} =", Me.mDestination.ToString), "Formula Error", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1)
        '    Return False
        'End If

        'Make sure there is more than just the destination
        If Formula.Replace(" ", "").ToLower = String.Format("{0}=", Me.mDestination.ToString).ToLower Then
            MessageBox.Show("Invalid Formula.  Destination must be set equal to a value.", "Formula Error", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1)
            Return False
        End If

        'Validate parenthesis
        If Not StringCount(Formula, "(") = StringCount(Formula, ")") Then
            MessageBox.Show("Invalid Formula.  Unmatching parenthesis.", "Formula Error", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1)
            Return False
        End If

        If Not Me.ValidateSources(Formula) Then
            Return False
        End If

        Return True
    End Function

    Private Function GetIncludedFunctions() As String
        Dim functions As DataTable = PackageDB.GetAllFunctions(mClientID)
        Dim row As DataRow
        Dim allFunctions As String = ""

        For Each row In functions.Rows
            allFunctions &= row("strFunction_Code").ToString & vbCrLf
        Next

        Return allFunctions
    End Function

    Private Function ExecuteFormula(ByVal Formula As String) As Boolean
        'Get a string containing all the functions in the library
        Dim allFunctions As String = Me.GetIncludedFunctions
        Dim input As frmInputDialog
        Dim col As SourceColumn

        'For each source column, prompt the user for a value to test
        For Each col In mDestination.SourceColumns
            input = New frmInputDialog(frmInputDialog.InputType.TextBox)
            input.Title = "Formula Parameters"
            input.Prompt = "Enter a value for " & col.ToString
            If input.ShowDialog = Windows.Forms.DialogResult.Cancel Then
                Return False
            End If

            'Replace the source column with the input value
            Formula = Formula.Replace(col.ToString, input.Input)
        Next

        'Replace the destination column with a variable called "returnValue"
        Formula = Formula.Replace(mDestination.ToString, "returnValue")

        'Add the call to display the returnValue and append all functions in library
        Formula &= vbCrLf & "MsgBox returnValue" & vbCrLf & allFunctions

        Try
            'Execute the script which should display result or error
            mScript.Language = "VBScript"
            mScript.Reset()
            mScript.ExecuteStatement(Formula)
            Return True
        Catch ex As Exception
            ReportException(ex, "Syntax Error")
            'MessageBox.Show(ex.Message, "Syntax Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End Try

    End Function

    'Count the occurences of a given value within a string
    Private Function StringCount(ByVal inString As String, ByVal value As String) As Integer
        Dim Count As Integer = 0
        Dim Index As Integer = inString.IndexOf(value, 0)
        While Index >= 0
            Count += 1
            Index = inString.IndexOf(value, Index + 1)
        End While

        Return Count
    End Function

    Private Function ValidateSources(ByVal Formula As String) As Boolean
        'TODO:  Comment this...
        Dim StartPos As Integer = Formula.IndexOf("DTSSource(")
        Dim EndPos As Integer = 0
        Dim Source As String
        Dim Col As Column
        Dim Found As Boolean = False

        While StartPos >= 0
            StartPos += 10
            EndPos = Formula.IndexOf(")", StartPos)
            Source = Formula.Substring(StartPos, EndPos - StartPos)
            If Not Source.StartsWith("""") OrElse Not Source.EndsWith("""") Then
                MessageBox.Show("Invalid Formula.  DTSSource field must be enclosed in quotes.", "Formula Error", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1)
                Return False
            End If

            Source = Source.Remove(0, 1)
            Source = Source.Remove(Source.Length - 1, 1)

            Found = False
            For Each Col In Me.mDestination.SourceColumns
                If Col.ColumnName = Source Then
                    Found = True
                    Exit For
                End If
            Next

            If Not Found Then
                MessageBox.Show(String.Format("Invalid Formula.  DTSSource(""{0}"") is not a valid Source Column in the field mapping.", Source), "Formula Error", MessageBoxButtons.OK, MessageBoxIcon.Error, MessageBoxDefaultButton.Button1)
                Return False
            End If

            StartPos = Formula.IndexOf("DTSSource(", StartPos)
        End While

        Return True
    End Function

    Private Sub btnExecute_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExecute.Click
        Me.ExecuteFormula(txtFormula.Text)
    End Sub
End Class
