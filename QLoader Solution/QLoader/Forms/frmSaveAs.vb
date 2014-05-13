Public Class frmSaveAs
    Inherits NRC.Framework.WinForms.DialogForm

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
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents btnOK As System.Windows.Forms.Button
    Friend WithEvents txtNewPackageName As System.Windows.Forms.TextBox
    Friend WithEvents pnlTree As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents txtNewPackageFriendlyName As System.Windows.Forms.TextBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.btnOK = New System.Windows.Forms.Button
        Me.txtNewPackageName = New System.Windows.Forms.TextBox
        Me.pnlTree = New Nrc.Framework.WinForms.SectionPanel
        Me.btnCancel = New System.Windows.Forms.Button
        Me.txtNewPackageFriendlyName = New System.Windows.Forms.TextBox
        Me.Label3 = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Save Package As..."
        Me.mPaneCaption.Size = New System.Drawing.Size(430, 26)
        Me.mPaneCaption.Text = "Save Package As..."
        '
        'Label2
        '
        Me.Label2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(16, 40)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(368, 23)
        Me.Label2.TabIndex = 11
        Me.Label2.Text = "Please select the client and study for the new package."
        '
        'Label1
        '
        Me.Label1.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(16, 314)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(224, 16)
        Me.Label1.TabIndex = 10
        Me.Label1.Text = "Please enter a name for the new package."
        '
        'btnOK
        '
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.Location = New System.Drawing.Point(112, 412)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.Size = New System.Drawing.Size(75, 23)
        Me.btnOK.TabIndex = 9
        Me.btnOK.Text = "OK"
        '
        'txtNewPackageName
        '
        Me.txtNewPackageName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtNewPackageName.Location = New System.Drawing.Point(16, 330)
        Me.txtNewPackageName.Name = "txtNewPackageName"
        Me.txtNewPackageName.Size = New System.Drawing.Size(400, 21)
        Me.txtNewPackageName.TabIndex = 7
        '
        'pnlTree
        '
        Me.pnlTree.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.pnlTree.Caption = ""
        Me.pnlTree.Location = New System.Drawing.Point(16, 64)
        Me.pnlTree.Name = "pnlTree"
        Me.pnlTree.Padding = New System.Windows.Forms.Padding(1)
        Me.pnlTree.ShowCaption = False
        Me.pnlTree.Size = New System.Drawing.Size(400, 240)
        Me.pnlTree.TabIndex = 6
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.Location = New System.Drawing.Point(216, 412)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.Size = New System.Drawing.Size(75, 23)
        Me.btnCancel.TabIndex = 8
        Me.btnCancel.Text = "Cancel"
        '
        'txtNewPackageFriendlyName
        '
        Me.txtNewPackageFriendlyName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtNewPackageFriendlyName.Location = New System.Drawing.Point(16, 385)
        Me.txtNewPackageFriendlyName.MaxLength = 100
        Me.txtNewPackageFriendlyName.Name = "txtNewPackageFriendlyName"
        Me.txtNewPackageFriendlyName.Size = New System.Drawing.Size(400, 21)
        Me.txtNewPackageFriendlyName.TabIndex = 7
        '
        'Label3
        '
        Me.Label3.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(16, 366)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(327, 16)
        Me.Label3.TabIndex = 10
        Me.Label3.Text = "Please enter a client-facing name for the new package."
        '
        'frmSaveAs
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.Caption = "Save Package As..."
        Me.ClientSize = New System.Drawing.Size(432, 447)
        Me.ControlBox = False
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.txtNewPackageName)
        Me.Controls.Add(Me.txtNewPackageFriendlyName)
        Me.Controls.Add(Me.pnlTree)
        Me.Controls.Add(Me.btnCancel)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "frmSaveAs"
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "frmSaveAs"
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.pnlTree, 0)
        Me.Controls.SetChildIndex(Me.txtNewPackageFriendlyName, 0)
        Me.Controls.SetChildIndex(Me.txtNewPackageName, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.Label3, 0)
        Me.Controls.SetChildIndex(Me.Label1, 0)
        Me.Controls.SetChildIndex(Me.Label2, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub

#End Region

#Region " Private Members "

    Private mStudyTree As ClientTreeView
    Private mClientID As Integer
    Private mStudyID As Integer
    Private mNewPackageName As String
    Private mNewFriendlyPackageName As String
    Private WithEvents mPackage As DTSPackage

#End Region

#Region " Public Properties "

    Public ReadOnly Property ClientID() As Integer
        Get
            Return mClientID
        End Get
    End Property

    Public ReadOnly Property StudyID() As Integer
        Get
            Return mStudyID
        End Get
    End Property

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

#End Region

#Region " Events "

    Private Sub frmSaveAs_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        mStudyTree = New ClientTreeView(ClientTreeTypes.AllStudiesNoPackages)
        mStudyTree.Dock = DockStyle.Fill
        pnlTree.Controls.Add(mStudyTree)

    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click

        Dim node As PackageNode = mStudyTree.SelectedNode

        If txtNewPackageName.Text = "" Then
            MessageBox.Show("You must enter a package name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        If txtNewPackageFriendlyName.Text = "" Then
            MessageBox.Show("You must enter a package client-facing name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        If txtNewPackageName.Text.Contains("'") Then
            MessageBox.Show("Single quote characters are not permitted in a package name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        If txtNewPackageFriendlyName.Text.Contains("'") Then
            MessageBox.Show("Single quote characters are not permitted in a package client-facing name.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        If node Is Nothing OrElse node.StudyID < 1 Then
            MessageBox.Show("You must select a study.", "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        If (DTSPackage.IsUniqueFriendlyPackageName(node.ClientID, txtNewPackageFriendlyName.Text) = False) Then
            MessageBox.Show(String.Format("The client-facing name '{0}' already exists for this client.", txtNewPackageFriendlyName.Text.Trim), "New Package Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        mClientID = node.ClientID
        mStudyID = node.StudyID
        mNewPackageName = txtNewPackageName.Text
        mNewFriendlyPackageName = txtNewPackageFriendlyName.Text

        DialogResult = Windows.Forms.DialogResult.OK

    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click

        DialogResult = Windows.Forms.DialogResult.Cancel

    End Sub

#End Region

End Class
