Public Class frmPickedPrints
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
    Friend WithEvents Panel2 As System.Windows.Forms.Panel
    Friend WithEvents Panel3 As System.Windows.Forms.Panel
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents SqlSelectCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlInsertCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlUpdateCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlDeleteCommand1 As System.Data.SqlClient.SqlCommand
    Friend WithEvents SqlDataAdapter1 As System.Data.SqlClient.SqlDataAdapter
    Friend WithEvents grdResult As System.Windows.Forms.DataGrid
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnOK As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Panel2 = New System.Windows.Forms.Panel
        Me.grdResult = New System.Windows.Forms.DataGrid
        Me.Panel3 = New System.Windows.Forms.Panel
        Me.btnCancel = New System.Windows.Forms.Button
        Me.btnOK = New System.Windows.Forms.Button
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.Label1 = New System.Windows.Forms.Label
        Me.SqlSelectCommand1 = New System.Data.SqlClient.SqlCommand
        Me.SqlInsertCommand1 = New System.Data.SqlClient.SqlCommand
        Me.SqlUpdateCommand1 = New System.Data.SqlClient.SqlCommand
        Me.SqlDeleteCommand1 = New System.Data.SqlClient.SqlCommand
        Me.SqlDataAdapter1 = New System.Data.SqlClient.SqlDataAdapter
        Me.Panel2.SuspendLayout()
        CType(Me.grdResult, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.Panel3.SuspendLayout()
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel2
        '
        Me.Panel2.Controls.Add(Me.grdResult)
        Me.Panel2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel2.Location = New System.Drawing.Point(0, 64)
        Me.Panel2.Name = "Panel2"
        Me.Panel2.Size = New System.Drawing.Size(616, 182)
        Me.Panel2.TabIndex = 1
        '
        'grdResult
        '
        Me.grdResult.DataMember = ""
        Me.grdResult.Dock = System.Windows.Forms.DockStyle.Fill
        Me.grdResult.HeaderForeColor = System.Drawing.SystemColors.ControlText
        Me.grdResult.Location = New System.Drawing.Point(0, 0)
        Me.grdResult.Name = "grdResult"
        Me.grdResult.ReadOnly = True
        Me.grdResult.Size = New System.Drawing.Size(616, 182)
        Me.grdResult.TabIndex = 0
        '
        'Panel3
        '
        Me.Panel3.Controls.Add(Me.btnCancel)
        Me.Panel3.Controls.Add(Me.btnOK)
        Me.Panel3.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Panel3.Location = New System.Drawing.Point(0, 246)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(616, 56)
        Me.Panel3.TabIndex = 2
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(408, 16)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 1
        Me.btnCancel.Text = "Cancel"
        '
        'btnOK
        '
        Me.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.btnOK.Location = New System.Drawing.Point(520, 16)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 0
        Me.btnOK.Text = "OK"
        '
        'Panel1
        '
        Me.Panel1.Controls.Add(Me.Label1)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Top
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(616, 64)
        Me.Panel1.TabIndex = 3
        '
        'Label1
        '
        Me.Label1.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.Label1.Location = New System.Drawing.Point(0, 14)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(616, 50)
        Me.Label1.TabIndex = 4
        Me.Label1.Text = "The following %d surveys will be generated and PDFs will be mailed to %s"
        '
        'SqlDataAdapter1
        '
        Me.SqlDataAdapter1.DeleteCommand = Me.SqlDeleteCommand1
        Me.SqlDataAdapter1.InsertCommand = Me.SqlInsertCommand1
        Me.SqlDataAdapter1.SelectCommand = Me.SqlSelectCommand1
        Me.SqlDataAdapter1.UpdateCommand = Me.SqlUpdateCommand1
        '
        'frmPickedPrints
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.ClientSize = New System.Drawing.Size(616, 302)
        Me.Controls.Add(Me.Panel2)
        Me.Controls.Add(Me.Panel1)
        Me.Controls.Add(Me.Panel3)
        Me.Name = "frmPickedPrints"
        Me.Text = "Test Prints"
        Me.Panel2.ResumeLayout(False)
        CType(Me.grdResult, System.ComponentModel.ISupportInitialize).EndInit()
        Me.Panel3.ResumeLayout(False)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

   
    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click

    End Sub
End Class
