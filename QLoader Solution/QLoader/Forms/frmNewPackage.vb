Public Class frmNewPackage
    Inherits Nrc.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal clientid As Integer)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mClientId = clientid
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
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents txtNewPackageName As System.Windows.Forms.TextBox
    Friend WithEvents txtNewPackageFriendlyName As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Label1 = New System.Windows.Forms.Label
        Me.btnOK = New System.Windows.Forms.Button
        Me.txtNewPackageName = New System.Windows.Forms.TextBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.txtNewPackageFriendlyName = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Create New Package"
        Me.mPaneCaption.Size = New System.Drawing.Size(430, 26)
        Me.mPaneCaption.Text = "Create New Package"
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(19, 47)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(224, 16)
        Me.Label1.TabIndex = 10
        Me.Label1.Text = "Please enter a name for the new package."
        '
        'btnOK
        '
        Me.btnOK.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.Location = New System.Drawing.Point(115, 145)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(75, 23)
        Me.btnOK.TabIndex = 9
        Me.btnOK.Text = "OK"
        '
        'txtNewPackageName
        '
        Me.txtNewPackageName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtNewPackageName.Location = New System.Drawing.Point(19, 63)
        Me.txtNewPackageName.Name = "txtNewPackageName"
        Me.txtNewPackageName.Size = New System.Drawing.Size(400, 21)
        Me.txtNewPackageName.TabIndex = 7
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.Location = New System.Drawing.Point(219, 145)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 8
        Me.btnCancel.Text = "Cancel"
        '
        'txtNewPackageFriendlyName
        '
        Me.txtNewPackageFriendlyName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtNewPackageFriendlyName.Location = New System.Drawing.Point(19, 118)
        Me.txtNewPackageFriendlyName.MaxLength = 100
        Me.txtNewPackageFriendlyName.Name = "txtNewPackageFriendlyName"
        Me.txtNewPackageFriendlyName.Size = New System.Drawing.Size(400, 21)
        Me.txtNewPackageFriendlyName.TabIndex = 7
        '
        'Label3
        '
        Me.Label3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(19, 99)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(327, 16)
        Me.Label3.TabIndex = 10
        Me.Label3.Text = "Please enter a client-facing name for the new package."
        '
        'frmNewPackage
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.Caption = "Save Package As..."
        Me.ClientSize = New System.Drawing.Size(432, 183)
        Me.ControlBox = False
        Me.Controls.Add(Me.txtNewPackageName)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.txtNewPackageFriendlyName)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmNewPackage"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "frmSaveAs"
        Me.Controls.SetChildIndex(Me.txtNewPackageFriendlyName, 0)
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.Label3, 0)
        Me.Controls.SetChildIndex(Me.Label1, 0)
        Me.Controls.SetChildIndex(Me.txtNewPackageName, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

    Private mClientId As Integer



    Public ReadOnly Property NewPackageName() As String
        Get
            Return mNewPackageName
        End Get
    End Property
    Public ReadOnly Property NewFriendlyPackageName() As String
        Get
            Return mNewFriendlyPackageName
        End Get
    End Property

    Private mNewPackageName As String
    Private mNewFriendlyPackageName As String

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click
        Me.DialogResult = Windows.Forms.DialogResult.None

        If Me.txtNewPackageName.Text = "" Then
            MessageBox.Show("You must enter a package name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If
        If Me.txtNewPackageFriendlyName.Text = "" Then
            MessageBox.Show("You must enter a package client-facing name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        If Me.txtNewPackageName.Text.Contains("'") Then
            MessageBox.Show("Single quote characters are not permitted in a package name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If
        If Me.txtNewPackageFriendlyName.Text.Contains("'") Then
            MessageBox.Show("Single quote characters are not permitted in a package client-facing name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If


        'Steve Kennedy - edit 04/09/2008 - I added this if block like the ones above

        If (DTSPackage.IsUniqueFriendlyPackageName(mClientID, Me.txtNewPackageFriendlyName.Text) = False) Then
            MessageBox.Show("The client-facing name '" & Me.txtNewPackageFriendlyName.Text.Trim & "' already exists for this client.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If


        Me.mNewPackageName = Me.txtNewPackageName.Text
        Me.mNewFriendlyPackageName = Me.txtNewPackageFriendlyName.Text

        Me.DialogResult = Windows.Forms.DialogResult.OK

    End Sub
End Class
