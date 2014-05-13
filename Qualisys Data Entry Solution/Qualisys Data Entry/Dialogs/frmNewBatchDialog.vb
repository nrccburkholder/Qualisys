Imports NRC.Qualisys.QualisysDataEntry.Library
Public Class frmNewBatchDialog
    Inherits Nrc.Framework.WinForms.DialogForm

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
    Friend WithEvents lbxLithos As System.Windows.Forms.ListBox
    Friend WithEvents txtLitho As System.Windows.Forms.TextBox
    Friend WithEvents btnAddLitho As System.Windows.Forms.Button
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents lblLithosIncluded As System.Windows.Forms.Label
    Friend WithEvents btnCreate As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents mnuLithos As System.Windows.Forms.ContextMenu
    Friend WithEvents mnuRemove As System.Windows.Forms.MenuItem
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.lbxLithos = New System.Windows.Forms.ListBox
        Me.txtLitho = New System.Windows.Forms.TextBox
        Me.btnAddLitho = New System.Windows.Forms.Button
        Me.Label1 = New System.Windows.Forms.Label
        Me.lblLithosIncluded = New System.Windows.Forms.Label
        Me.btnCreate = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.mnuLithos = New System.Windows.Forms.ContextMenu
        Me.mnuRemove = New System.Windows.Forms.MenuItem
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "New Batch"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(334, 26)
        '
        'lbxLithos
        '
        Me.lbxLithos.ContextMenu = Me.mnuLithos
        Me.lbxLithos.Location = New System.Drawing.Point(40, 120)
        Me.lbxLithos.Name = "lbxLithos"
        Me.lbxLithos.Size = New System.Drawing.Size(248, 199)
        Me.lbxLithos.TabIndex = 3
        Me.lbxLithos.TabStop = False
        '
        'txtLitho
        '
        Me.txtLitho.Location = New System.Drawing.Point(104, 56)
        Me.txtLitho.Name = "txtLitho"
        Me.txtLitho.Size = New System.Drawing.Size(128, 21)
        Me.txtLitho.TabIndex = 1
        Me.txtLitho.Text = ""
        '
        'btnAddLitho
        '
        Me.btnAddLitho.Enabled = False
        Me.btnAddLitho.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnAddLitho.Location = New System.Drawing.Point(240, 56)
        Me.btnAddLitho.Name = "btnAddLitho"
        Me.btnAddLitho.Size = New System.Drawing.Size(48, 23)
        Me.btnAddLitho.TabIndex = 2
        Me.btnAddLitho.Text = "Add"
        '
        'Label1
        '
        Me.Label1.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.Label1.Location = New System.Drawing.Point(40, 56)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(64, 23)
        Me.Label1.TabIndex = 20
        Me.Label1.Text = "Litho Code:"
        Me.Label1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblLithosIncluded
        '
        Me.lblLithosIncluded.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.lblLithosIncluded.Location = New System.Drawing.Point(40, 96)
        Me.lblLithosIncluded.Name = "lblLithosIncluded"
        Me.lblLithosIncluded.Size = New System.Drawing.Size(120, 23)
        Me.lblLithosIncluded.TabIndex = 22
        Me.lblLithosIncluded.Text = "Litho Codes In Batch:"
        Me.lblLithosIncluded.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnCreate
        '
        Me.btnCreate.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCreate.Location = New System.Drawing.Point(72, 344)
        Me.btnCreate.Name = "btnCreate"
        Me.btnCreate.Size = New System.Drawing.Size(80, 23)
        Me.btnCreate.TabIndex = 4
        Me.btnCreate.Text = "Create"
        '
        'btnCancel
        '
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Location = New System.Drawing.Point(176, 344)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 5
        Me.btnCancel.Text = "Cancel"
        '
        'mnuLithos
        '
        Me.mnuLithos.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuRemove})
        '
        'mnuRemove
        '
        Me.mnuRemove.Index = 0
        Me.mnuRemove.Text = "Remove"
        '
        'frmNewBatchDialog
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 14)
        Me.Caption = "New Batch"
        Me.ClientSize = New System.Drawing.Size(336, 392)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnCreate)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.btnAddLitho)
        Me.Controls.Add(Me.txtLitho)
        Me.Controls.Add(Me.lbxLithos)
        Me.Controls.Add(Me.lblLithosIncluded)
        Me.DockPadding.All = 1
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "frmNewBatchDialog"
        Me.Text = "frmNewBatchDialog"
        Me.Controls.SetChildIndex(Me.lblLithosIncluded, 0)
        Me.Controls.SetChildIndex(Me.lbxLithos, 0)
        Me.Controls.SetChildIndex(Me.txtLitho, 0)
        Me.Controls.SetChildIndex(Me.btnAddLitho, 0)
        Me.Controls.SetChildIndex(Me.Label1, 0)
        Me.Controls.SetChildIndex(Me.btnCreate, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Event Handlers "
    'Cancel
    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    'If a litho has been entered then add it to the box
    Private Sub btnAddLitho_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddLitho.Click
        If txtLitho.Text.Length > 0 Then
            'If the litho is already in the list then YELL at the user.
            If lbxLithos.Items.Contains(txtLitho.Text) Then
                Dim ex As New ArgumentException(String.Format("Litho '{0}' has already been added to the list.", txtLitho.Text), "Litho")
                ReportException(ex, "Batch Creation Error")
                Exit Sub
            End If

            Dim confirm As String = InputBox("Please confirm the litho code.", "Litho Confirmation")
            If confirm = "" Then
                'Do nothing
            ElseIf confirm = txtLitho.Text Then
                lbxLithos.Items.Add(txtLitho.Text)
            Else
                Dim ex As New ArgumentException("The lithos do not match.")
                ReportException(ex, "Litho Confirmation Error.")
            End If

            txtLitho.Text = ""
            txtLitho.Focus()
        End If
    End Sub

    'Set the add button to enabled only if something has been typed in the litho textbox
    Private Sub txtLitho_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtLitho.TextChanged
        btnAddLitho.Enabled = (txtLitho.Text.Length > 0)
    End Sub

    'Create a new batch and assign every litho to it.
    Private Sub btnCreate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCreate.Click
        Dim b As Batch = Batch.InsertNewBatch(CurrentUser.LoginName, Batch.BatchOriginType.ManuallyAdded)
        Dim litho As String
        For Each litho In lbxLithos.Items
            'Returns FALSE if the litho can't be added to the batch.
            If Not b.AssignLitho(litho) Then
                MessageBox.Show(String.Format("Litho '{0}' already belongs to a different batch or does not exist.", litho), "Batch Creation Warning", MessageBoxButtons.OK, MessageBoxIcon.Warning)
            End If
        Next

        Me.DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    'Remove the selected litho from the box.
    Private Sub mnuRemove_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles mnuRemove.Click
        lbxLithos.Items.Remove(lbxLithos.SelectedItem)
    End Sub

    'Only display menu if an item is selected
    Private Sub mnuLithos_Popup(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuLithos.Popup
        Dim showMenu As Boolean = (Not lbxLithos.SelectedItem Is Nothing)
        Dim item As MenuItem
        For Each item In mnuLithos.MenuItems
            item.Visible = showMenu
        Next
    End Sub

    'If they press ENTER in the litho textbox then add it to the listbox
    Private Sub txtLitho_KeyDown(ByVal sender As Object, ByVal e As System.Windows.Forms.KeyEventArgs) Handles txtLitho.KeyDown
        If e.KeyData = Keys.Enter Then
            btnAddLitho.PerformClick()
            e.Handled = True
        End If
    End Sub

#End Region

End Class
