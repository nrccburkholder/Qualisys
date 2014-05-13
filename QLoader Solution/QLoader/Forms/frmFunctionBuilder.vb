Imports Nrc.Qualisys.QLoader.Library.SqlProvider

Public Class frmFunctionBuilder
    Inherits Nrc.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal clientID As Integer, ByVal functionID As Integer, ByVal groupID As Integer)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mClientID = clientID
        mFunctionID = functionID
        mGroupID = groupID
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
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents grpFunctionList As System.Windows.Forms.GroupBox
    Friend WithEvents ImageList1 As System.Windows.Forms.ImageList
    Friend WithEvents txtFunctionCode As System.Windows.Forms.TextBox
    Friend WithEvents ToolTip1 As System.Windows.Forms.ToolTip
    Friend WithEvents btnExecute As System.Windows.Forms.Button
    Friend WithEvents cboGroupBy As System.Windows.Forms.ComboBox
    Friend WithEvents lblFunctionGroup As System.Windows.Forms.Label
    Friend WithEvents txtDescription As System.Windows.Forms.TextBox
    Friend WithEvents lbxArguments As System.Windows.Forms.ListBox
    Friend WithEvents btnAddArgument As System.Windows.Forms.Button
    Friend WithEvents lblArguments As System.Windows.Forms.Label
    Friend WithEvents lblDescription As System.Windows.Forms.Label
    Friend WithEvents txtFunctionName As System.Windows.Forms.TextBox
    Friend WithEvents btnDown As System.Windows.Forms.Button
    Friend WithEvents lblFunctionName As System.Windows.Forms.Label
    Friend WithEvents btnUp As System.Windows.Forms.Button
    Friend WithEvents btnDelete As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmFunctionBuilder))
        Me.txtFunctionCode = New System.Windows.Forms.TextBox
        Me.btnOK = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnExecute = New System.Windows.Forms.Button
        Me.grpFunctionList = New System.Windows.Forms.GroupBox
        Me.ImageList1 = New System.Windows.Forms.ImageList(Me.components)
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.btnAddArgument = New System.Windows.Forms.Button
        Me.btnDelete = New System.Windows.Forms.Button
        Me.cboGroupBy = New System.Windows.Forms.ComboBox
        Me.lblFunctionGroup = New System.Windows.Forms.Label
        Me.txtDescription = New System.Windows.Forms.TextBox
        Me.lbxArguments = New System.Windows.Forms.ListBox
        Me.lblArguments = New System.Windows.Forms.Label
        Me.lblDescription = New System.Windows.Forms.Label
        Me.txtFunctionName = New System.Windows.Forms.TextBox
        Me.btnDown = New System.Windows.Forms.Button
        Me.lblFunctionName = New System.Windows.Forms.Label
        Me.btnUp = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Function Builder"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(758, 26)
        '
        'txtFunctionCode
        '
        Me.txtFunctionCode.AcceptsReturn = True
        Me.txtFunctionCode.AcceptsTab = True
        Me.txtFunctionCode.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtFunctionCode.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtFunctionCode.Location = New System.Drawing.Point(320, 176)
        Me.txtFunctionCode.MaxLength = 5000
        Me.txtFunctionCode.Multiline = True
        Me.txtFunctionCode.Name = "txtFunctionCode"
        Me.txtFunctionCode.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtFunctionCode.Size = New System.Drawing.Size(424, 240)
        Me.txtFunctionCode.TabIndex = 0
        Me.txtFunctionCode.Text = ""
        '
        'btnOK
        '
        Me.btnOK.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.Location = New System.Drawing.Point(552, 432)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(80, 23)
        Me.btnOK.TabIndex = 23
        Me.btnOK.Text = "OK"
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.Location = New System.Drawing.Point(648, 432)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(88, 23)
        Me.btnCancel.TabIndex = 21
        Me.btnCancel.Text = "Cancel"
        '
        'btnExecute
        '
        Me.btnExecute.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnExecute.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnExecute.Location = New System.Drawing.Point(448, 432)
        Me.btnExecute.Name = "btnExecute"
        Me.btnExecute.Size = New System.Drawing.Size(88, 23)
        Me.btnExecute.TabIndex = 24
        Me.btnExecute.Text = "Execute"
        '
        'grpFunctionList
        '
        Me.grpFunctionList.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.grpFunctionList.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.grpFunctionList.Location = New System.Drawing.Point(320, 40)
        Me.grpFunctionList.Name = "grpFunctionList"
        Me.grpFunctionList.Size = New System.Drawing.Size(424, 125)
        Me.grpFunctionList.TabIndex = 39
        Me.grpFunctionList.TabStop = False
        Me.grpFunctionList.Text = "Built-In Function"
        '
        'ImageList1
        '
        Me.ImageList1.ImageSize = New System.Drawing.Size(16, 16)
        Me.ImageList1.ImageStream = CType(resources.GetObject("ImageList1.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.ImageList1.TransparentColor = System.Drawing.Color.Transparent
        '
        'btnAddArgument
        '
        Me.btnAddArgument.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.btnAddArgument.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnAddArgument.Image = CType(resources.GetObject("btnAddArgument.Image"), System.Drawing.Image)
        Me.btnAddArgument.Location = New System.Drawing.Point(256, 128)
        Me.btnAddArgument.Name = "btnAddArgument"
        Me.btnAddArgument.Size = New System.Drawing.Size(28, 28)
        Me.btnAddArgument.TabIndex = 45
        Me.btnAddArgument.Tag = ""
        Me.ToolTip1.SetToolTip(Me.btnAddArgument, "Add argument")
        '
        'btnDelete
        '
        Me.btnDelete.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.btnDelete.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnDelete.Image = CType(resources.GetObject("btnDelete.Image"), System.Drawing.Image)
        Me.btnDelete.Location = New System.Drawing.Point(256, 160)
        Me.btnDelete.Name = "btnDelete"
        Me.btnDelete.Size = New System.Drawing.Size(28, 28)
        Me.btnDelete.TabIndex = 44
        Me.ToolTip1.SetToolTip(Me.btnDelete, "Delete argument")
        '
        'cboGroupBy
        '
        Me.cboGroupBy.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cboGroupBy.ItemHeight = 13
        Me.cboGroupBy.Location = New System.Drawing.Point(16, 264)
        Me.cboGroupBy.Name = "cboGroupBy"
        Me.cboGroupBy.Size = New System.Drawing.Size(272, 21)
        Me.cboGroupBy.TabIndex = 48
        '
        'lblFunctionGroup
        '
        Me.lblFunctionGroup.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblFunctionGroup.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFunctionGroup.Location = New System.Drawing.Point(16, 248)
        Me.lblFunctionGroup.Name = "lblFunctionGroup"
        Me.lblFunctionGroup.Size = New System.Drawing.Size(64, 16)
        Me.lblFunctionGroup.TabIndex = 47
        Me.lblFunctionGroup.Text = "Group by:"
        '
        'txtDescription
        '
        Me.txtDescription.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDescription.Location = New System.Drawing.Point(16, 304)
        Me.txtDescription.MaxLength = 200
        Me.txtDescription.Multiline = True
        Me.txtDescription.Name = "txtDescription"
        Me.txtDescription.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtDescription.Size = New System.Drawing.Size(272, 152)
        Me.txtDescription.TabIndex = 41
        Me.txtDescription.Text = "Convert the 10-character string into date format (120 - YYYY-MM-DD)"
        '
        'lbxArguments
        '
        Me.lbxArguments.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lbxArguments.Location = New System.Drawing.Point(16, 120)
        Me.lbxArguments.Name = "lbxArguments"
        Me.lbxArguments.Size = New System.Drawing.Size(240, 121)
        Me.lbxArguments.TabIndex = 46
        '
        'lblArguments
        '
        Me.lblArguments.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblArguments.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblArguments.Location = New System.Drawing.Point(16, 104)
        Me.lblArguments.Name = "lblArguments"
        Me.lblArguments.Size = New System.Drawing.Size(72, 16)
        Me.lblArguments.TabIndex = 39
        Me.lblArguments.Text = "Arguments:"
        '
        'lblDescription
        '
        Me.lblDescription.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblDescription.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDescription.Location = New System.Drawing.Point(16, 288)
        Me.lblDescription.Name = "lblDescription"
        Me.lblDescription.Size = New System.Drawing.Size(64, 16)
        Me.lblDescription.TabIndex = 40
        Me.lblDescription.Text = "Description:"
        '
        'txtFunctionName
        '
        Me.txtFunctionName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtFunctionName.Location = New System.Drawing.Point(16, 56)
        Me.txtFunctionName.MaxLength = 200
        Me.txtFunctionName.Multiline = True
        Me.txtFunctionName.Name = "txtFunctionName"
        Me.txtFunctionName.Size = New System.Drawing.Size(276, 40)
        Me.txtFunctionName.TabIndex = 38
        Me.txtFunctionName.Text = ""
        '
        'btnDown
        '
        Me.btnDown.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.btnDown.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnDown.Image = CType(resources.GetObject("btnDown.Image"), System.Drawing.Image)
        Me.btnDown.Location = New System.Drawing.Point(256, 224)
        Me.btnDown.Name = "btnDown"
        Me.btnDown.Size = New System.Drawing.Size(28, 28)
        Me.btnDown.TabIndex = 42
        Me.btnDown.Tag = "Move down"
        '
        'lblFunctionName
        '
        Me.lblFunctionName.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblFunctionName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFunctionName.Location = New System.Drawing.Point(16, 40)
        Me.lblFunctionName.Name = "lblFunctionName"
        Me.lblFunctionName.Size = New System.Drawing.Size(40, 16)
        Me.lblFunctionName.TabIndex = 37
        Me.lblFunctionName.Text = "Name:"
        '
        'btnUp
        '
        Me.btnUp.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.btnUp.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnUp.Image = CType(resources.GetObject("btnUp.Image"), System.Drawing.Image)
        Me.btnUp.Location = New System.Drawing.Point(256, 192)
        Me.btnUp.Name = "btnUp"
        Me.btnUp.Size = New System.Drawing.Size(28, 28)
        Me.btnUp.TabIndex = 43
        Me.btnUp.Tag = "Move up"
        '
        'frmFunctionBuilder
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.Caption = "Function Builder"
        Me.ClientSize = New System.Drawing.Size(760, 472)
        Me.Controls.Add(Me.cboGroupBy)
        Me.Controls.Add(Me.lblFunctionGroup)
        Me.Controls.Add(Me.txtDescription)
        Me.Controls.Add(Me.lbxArguments)
        Me.Controls.Add(Me.btnAddArgument)
        Me.Controls.Add(Me.lblArguments)
        Me.Controls.Add(Me.lblDescription)
        Me.Controls.Add(Me.txtFunctionName)
        Me.Controls.Add(Me.btnDown)
        Me.Controls.Add(Me.lblFunctionName)
        Me.Controls.Add(Me.btnUp)
        Me.Controls.Add(Me.btnDelete)
        Me.Controls.Add(Me.grpFunctionList)
        Me.Controls.Add(Me.txtFunctionCode)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnExecute)
        Me.Controls.Add(Me.btnOK)
        Me.DockPadding.All = 1
        Me.Name = "frmFunctionBuilder"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "frmFunctionBuilder"
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.btnExecute, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.txtFunctionCode, 0)
        Me.Controls.SetChildIndex(Me.grpFunctionList, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.btnDelete, 0)
        Me.Controls.SetChildIndex(Me.btnUp, 0)
        Me.Controls.SetChildIndex(Me.lblFunctionName, 0)
        Me.Controls.SetChildIndex(Me.btnDown, 0)
        Me.Controls.SetChildIndex(Me.txtFunctionName, 0)
        Me.Controls.SetChildIndex(Me.lblDescription, 0)
        Me.Controls.SetChildIndex(Me.lblArguments, 0)
        Me.Controls.SetChildIndex(Me.btnAddArgument, 0)
        Me.Controls.SetChildIndex(Me.lbxArguments, 0)
        Me.Controls.SetChildIndex(Me.txtDescription, 0)
        Me.Controls.SetChildIndex(Me.lblFunctionGroup, 0)
        Me.Controls.SetChildIndex(Me.cboGroupBy, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mClientID As Integer
    Private mFunctionID As Integer
    Private mGroupID As Integer
    Private WithEvents mFunctionTree As FunctionTreeView

    Private mFunction As DTSFunction

#Region " Initialize/Populate Form "
    Private Sub frmFunctionBuilder_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Load the Group box
        Me.PopulateFunctionGroupCombo()
        Me.InitializeForm()

        'If we are modifying a function then load it
        If Me.mFunctionID > 0 Then
            LoadFunction()
        Else
            'Create a new function object
            Me.mFunction = New DTSFunction()
        End If
    End Sub

    Private Sub InitializeForm()
        Me.btnOK.Enabled = False
        Me.txtFunctionName.Enabled = True
        Me.txtFunctionName.Clear()
        Me.lbxArguments.Items.Clear() ' Clear the arguments listbox
        Me.txtDescription.Clear()
        Me.txtFunctionCode.Clear()
        Me.cboGroupBy.SelectedIndex = -1
        Me.mFunctionTree = New FunctionTreeView(mClientID, False, True)
        Me.grpFunctionList.Controls.Add(mFunctionTree)
        Me.mFunctionTree.Dock = DockStyle.Fill
    End Sub

    Private Sub PopulateFunctionGroupCombo()
        Me.cboGroupBy.DataSource = Nothing
        Me.cboGroupBy.Items.Clear() ' Clear the combo box

        With Me.cboGroupBy
            .DataSource = PackageDB.GetFunctionGroup(mGroupID)
            .DisplayMember = "strFunctionGroup_dsc"
            .ValueMember = "FunctionGroup_id"
        End With
        Me.cboGroupBy.SelectedIndex = -1
    End Sub

    Private Sub LoadFunction()
        Me.mFunction = New DTSFunction()
        Me.mFunction.LoadFromDB(Me.mFunctionID)

        Me.lbxArguments.Items.Clear() ' Clear the arguments listbox.

        Me.lbxArguments.Items.AddRange(mFunction.Parameters.ToArray)

        Me.txtFunctionName.Text = mFunction.Name
        Me.txtDescription.Text = mFunction.Description
        Me.cboGroupBy.SelectedValue = Me.mFunction.GroupID
        Me.txtFunctionCode.Text = Me.mFunction.SourceCode

        Me.txtFunctionName.Enabled = False
        Me.btnOK.Enabled = True
    End Sub

#End Region

#Region " Argument Events "

    Private Sub btnUp_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUp.Click
        Dim row As Integer = Me.lbxArguments.SelectedIndex
        If row > 0 Then Me.lbxArguments.SelectedIndex = row - 1
        Me.UpdateFunctionHeader()
    End Sub

    Private Sub btnDown_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDown.Click
        Dim row As Integer = Me.lbxArguments.SelectedIndex

        If row < Me.lbxArguments.Items.Count - 1 And _
            row > -1 Then Me.lbxArguments.SelectedIndex = row + 1

        Me.UpdateFunctionHeader()
    End Sub

    Private Sub btnDelete_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDelete.Click
        Me.lbxArguments.Items.Remove(Me.lbxArguments.SelectedItem)
        Me.lbxArguments.SelectedIndex = -1
        Me.UpdateFunctionHeader()
    End Sub

    Private Sub btnAddArgument_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddArgument.Click
        Dim input As New frmInputDialog(frmInputDialog.InputType.TextBox)

        input.Title = "Add Argument"
        input.Prompt = "Argument name"

        If input.ShowDialog() = Windows.Forms.DialogResult.OK Then
            If input.Input.Trim <> "" Then _
                Me.lbxArguments.Items.Add(input.Input.Trim)
        End If

        Me.lbxArguments.SelectedIndex = -1
        Me.UpdateFunctionHeader()
    End Sub
#End Region

#Region " Function Tree Events "
    Private Sub tvwSystemFunction_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mFunctionTree.DoubleClick
        'Get the node being clicked
        Dim ptTree As Point = Me.mFunctionTree.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim node As TreeNode = Me.mFunctionTree.GetNodeAt(ptTree)

        'If we have a node and it is the selected node and it is not a parent
        If Not node Is Nothing AndAlso node Is Me.mFunctionTree.SelectedNode AndAlso node.Nodes.Count = 0 Then
            'Insert text
            Me.InsertFormulaText(node.Text)
        End If
    End Sub

    Private Sub InsertFormulaText(ByVal text As String)
        Dim Start As Integer = Me.txtFunctionCode.SelectionStart
        Dim Len As Integer = Me.txtFunctionCode.SelectionLength
        Me.txtFunctionCode.Focus()

        'Remove any hilighted text
        Me.txtFunctionCode.Text = Me.txtFunctionCode.Text.Remove(Start, Len)

        'Insert the new text where the cursor was
        Me.txtFunctionCode.Text = Me.txtFunctionCode.Text.Insert(Start, text)

        'Place the cursor at the end of the new text
        Me.txtFunctionCode.SelectionStart += Start + text.Length
    End Sub
#End Region

#Region " Form Events "
    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        'Update the function object
        Me.UpdateFunctionObject()

        ' Make sure the function is valid and then save it.
        Dim result As String = ""
        Try
            If mFunction.Validate(result) Then
                mFunction.SaveToDB()
                Me.DialogResult = Windows.Forms.DialogResult.OK
                Me.Close()
            Else
                Throw New Exception(result)
            End If
        Catch ex As Exception
            ReportException(ex, "Function Definition Error")
            'MessageBox.Show(ex.Message, "Function Definition Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        End Try
    End Sub

    Private Sub txtFunctionCode_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtFunctionCode.Click
        If Me.txtFunctionCode.Text.Trim = "" Then ' First time new function
            Me.UpdateFunctionObject()
            Me.txtFunctionCode.Text = mFunction.FunctionStub
        End If
    End Sub

    Private Sub txtFunctionName_KeyPress(ByVal sender As System.Object, ByVal e As System.Windows.Forms.KeyPressEventArgs) Handles txtFunctionName.KeyPress
        Dim c As Char = e.KeyChar

        ' Function name can contain only letter or digit.
        If Not (Char.IsLetterOrDigit(c) Or Char.IsControl(c)) Then e.Handled = True
    End Sub

    Private Sub btnExecute_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnExecute.Click
        Me.btnOK.Enabled = Me.ExecuteFunction()
    End Sub

#End Region

    Private Sub UpdateFunctionHeader()
        'Update the object with the options on the form
        Me.UpdateFunctionObject()

        'Replace the first line with the new header...
        If Me.txtFunctionCode.Lines.Length > 0 Then _
        Me.txtFunctionCode.Text = Me.txtFunctionCode.Text.Replace(Me.txtFunctionCode.Lines(0), "Function " & mFunction.Signature)
    End Sub

    Private Sub UpdateFunctionObject()
        'Populate the function object with the info on the form
        Dim i As Integer

        'Add all the parameters
        mFunction.Parameters.Clear()
        For i = 0 To Me.lbxArguments.Items.Count - 1
            mFunction.Parameters.Add(lbxArguments.Items(i).ToString)
        Next

        'Set everything else...
        mFunction.Name = Me.txtFunctionName.Text
        mFunction.Description = txtDescription.Text.Trim()
        mFunction.SourceCode = txtFunctionCode.Text.Trim()
        mFunction.ClientID = mClientID
        mFunction.GroupID = CType(cboGroupBy.SelectedValue, Integer)
    End Sub

    Private Function ExecuteFunction() As Boolean
        Dim input As frmInputDialog
        Dim params As New ArrayList
        Dim param As String
        Dim result As String = ""

        Try
            Me.UpdateFunctionObject()
            For Each param In mFunction.Parameters
                input = New frmInputDialog(frmInputDialog.InputType.TextBox)
                input.Title = "Function Parameters"
                input.Prompt = "Enter a value for the """ & param & """ parameter."
                If input.ShowDialog = Windows.Forms.DialogResult.Cancel Then
                    Exit Function
                End If

                params.Add(input.Input)
            Next

            If mFunction.Execute(result, params.ToArray) Then
                MessageBox.Show(result, "Execution Test Result", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Else
                Throw New Exception(result)
            End If
            Return True
        Catch ex As Exception
            ReportException(ex, "Execution Failure")
            'MessageBox.Show(ex.Message, "Execution Failure", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Return False
        End Try
    End Function
End Class