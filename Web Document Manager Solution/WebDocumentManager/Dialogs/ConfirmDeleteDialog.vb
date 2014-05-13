Public Class ConfirmDeleteDialog
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
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btnDeleteAll As System.Windows.Forms.Button
    Friend WithEvents btnDeleteInstance As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Label1 = New System.Windows.Forms.Label
        Me.btnDeleteAll = New System.Windows.Forms.Button
        Me.btnDeleteInstance = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(16, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(368, 56)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Document"
        '
        'btnDeleteAll
        '
        Me.btnDeleteAll.Location = New System.Drawing.Point(154, 96)
        Me.btnDeleteAll.Name = "btnDeleteAll"
        Me.btnDeleteAll.Size = New System.Drawing.Size(112, 23)
        Me.btnDeleteAll.TabIndex = 1
        Me.btnDeleteAll.Text = "Delete All Instances"
        '
        'btnDeleteInstance
        '
        Me.btnDeleteInstance.Location = New System.Drawing.Point(8, 96)
        Me.btnDeleteInstance.Name = "btnDeleteInstance"
        Me.btnDeleteInstance.Size = New System.Drawing.Size(128, 23)
        Me.btnDeleteInstance.TabIndex = 1
        Me.btnDeleteInstance.Text = "Delete this Instance"
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(288, 96)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(101, 23)
        Me.btnCancel.TabIndex = 3
        Me.btnCancel.Text = "Cancel"
        '
        'ConfirmDeleteDialog
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.SystemColors.Control
        Me.ClientSize = New System.Drawing.Size(400, 126)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.btnDeleteInstance)
        Me.Controls.Add(Me.btnDeleteAll)
        Me.Controls.Add(Me.Label1)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ConfirmDeleteDialog"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Confirm Delete"
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Enum DeleteConfirmResult
        DeleteAll = 0
        DeleteInstance = 1
        Cancel = 2
    End Enum


#Region "private members"
    Private mResult As DeleteConfirmResult
#End Region

#Region "public Methods"
    Public ReadOnly Property Result() As DeleteConfirmResult
        Get
            Return mResult
        End Get
    End Property
#End Region

#Region "Private Methods"
    Private Sub btnDeleteAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDeleteAll.Click
        mResult = DeleteConfirmResult.DeleteAll
        Me.Close()
    End Sub

    Private Sub btnDeleteInstance_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDeleteInstance.Click
        mResult = DeleteConfirmResult.DeleteInstance
        Me.Close()
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        mResult = DeleteConfirmResult.Cancel
        Me.Close()
    End Sub
#End Region

End Class
