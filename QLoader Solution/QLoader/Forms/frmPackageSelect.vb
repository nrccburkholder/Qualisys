Public Class frmPackageSelect
    Inherits NRC.Framework.WinForms.DialogForm

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal allowVersions As Boolean)

        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        mAllowVersions = allowVersions

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
    Friend WithEvents pnlTree As System.Windows.Forms.Panel
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents txtVersion As System.Windows.Forms.TextBox
    Friend WithEvents lblVersion As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.btnOK = New System.Windows.Forms.Button
        Me.pnlTree = New System.Windows.Forms.Panel
        Me.btnCancel = New System.Windows.Forms.Button
        Me.txtVersion = New System.Windows.Forms.TextBox
        Me.lblVersion = New System.Windows.Forms.Label
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Package Selection"
        Me.mPaneCaption.Name = "mPaneCaption"
        Me.mPaneCaption.Size = New System.Drawing.Size(438, 26)
        '
        'btnOK
        '
        Me.btnOK.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnOK.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnOK.Location = New System.Drawing.Point(128, 416)
        Me.btnOK.Name = "btnOK"
        Me.btnOK.TabIndex = 2
        Me.btnOK.Text = "OK"
        '
        'pnlTree
        '
        Me.pnlTree.Location = New System.Drawing.Point(8, 40)
        Me.pnlTree.Name = "pnlTree"
        Me.pnlTree.Size = New System.Drawing.Size(424, 360)
        Me.pnlTree.TabIndex = 1
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnCancel.Location = New System.Drawing.Point(224, 416)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 2
        Me.btnCancel.Text = "Cancel"
        '
        'txtVersion
        '
        Me.txtVersion.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtVersion.Location = New System.Drawing.Point(384, 416)
        Me.txtVersion.Name = "txtVersion"
        Me.txtVersion.Size = New System.Drawing.Size(40, 21)
        Me.txtVersion.TabIndex = 3
        Me.txtVersion.Text = ""
        '
        'lblVersion
        '
        Me.lblVersion.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblVersion.Location = New System.Drawing.Point(336, 416)
        Me.lblVersion.Name = "lblVersion"
        Me.lblVersion.Size = New System.Drawing.Size(48, 23)
        Me.lblVersion.TabIndex = 4
        Me.lblVersion.Text = "Version:"
        Me.lblVersion.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'frmPackageSelect
        '
        Me.AcceptButton = Me.btnOK
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.Caption = "Package Selection"
        Me.ClientSize = New System.Drawing.Size(440, 456)
        Me.Controls.Add(Me.lblVersion)
        Me.Controls.Add(Me.txtVersion)
        Me.Controls.Add(Me.btnOK)
        Me.Controls.Add(Me.pnlTree)
        Me.Controls.Add(Me.btnCancel)
        Me.DockPadding.All = 1
        Me.Name = "frmPackageSelect"
        Me.Text = "frmPackageSelect"
        Me.Controls.SetChildIndex(Me.btnCancel, 0)
        Me.Controls.SetChildIndex(Me.pnlTree, 0)
        Me.Controls.SetChildIndex(Me.btnOK, 0)
        Me.Controls.SetChildIndex(Me.txtVersion, 0)
        Me.Controls.SetChildIndex(Me.lblVersion, 0)
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Private Members "

    Private WithEvents packageTree As ClientTreeView
    Private mClientID As Integer
    Private mStudyID As Integer
    Private mPackageID As Integer
    Private mVersion As Integer
    Private mAllowVersions As Boolean
    Private mMaxVersion As Integer

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

    Public ReadOnly Property PackageID() As Integer
        Get
            Return mPackageID
        End Get
    End Property

    Public ReadOnly Property Version() As Integer
        Get
            Return mVersion
        End Get
    End Property

#End Region

#Region " Events "

    Private Sub frmPackageSelect_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load

        packageTree = New ClientTreeView(ClientTreeTypes.DefinedPackages)
        packageTree.Dock = DockStyle.Fill
        pnlTree.Controls.Add(packageTree)
        lblVersion.Visible = mAllowVersions
        txtVersion.Visible = mAllowVersions

    End Sub

    Private Sub btnOK_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnOK.Click

        If Not packageTree.SelectedNode.PackageID > 0 Then
            MessageBox.Show("You must select a package.", "Package Selection Error", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If

        Dim errorMsg As String = ""
        If mAllowVersions AndAlso Not ValidateVersion(errorMsg) Then
            MessageBox.Show(errorMsg, "Version Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        mClientID = packageTree.SelectedNode.ClientID
        mStudyID = packageTree.SelectedNode.StudyID
        mPackageID = packageTree.SelectedNode.PackageID

        If mAllowVersions Then
            mVersion = Integer.Parse(txtVersion.Text)
        Else
            mVersion = -1
        End If

        DialogResult = Windows.Forms.DialogResult.OK

    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click

        DialogResult = Windows.Forms.DialogResult.Cancel

    End Sub

#End Region

#Region " Private Methods "

    Private Sub PopulateVersionNumber(ByVal node As PackageNode)

        If Not mAllowVersions Then Exit Sub

        If Not node Is Nothing Then
            If node.PackageID > 0 Then
                mMaxVersion = node.Version
                txtVersion.Text = node.Version.ToString
                txtVersion.SelectionStart = 0
                txtVersion.SelectionLength = txtVersion.Text.Length
            Else
                txtVersion.Text = String.Empty
            End If
        End If

    End Sub

    Private Function ValidateVersion(ByRef errorMessage As String) As Boolean

        Try
            Dim ver As Integer = Integer.Parse(txtVersion.Text)
            If ver < 1 OrElse ver > mMaxVersion Then
                Throw New ArgumentOutOfRangeException("Version")
            End If

            Return True

        Catch ex As FormatException
            errorMessage = String.Format("Version must be an integer between 1 and {0}", mMaxVersion)
            Return False

        Catch ex As ArgumentOutOfRangeException
            errorMessage = String.Format("Version must be between 1 and {0}", mMaxVersion)
            Return False

        Catch ex As Exception
            errorMessage = String.Format("Version must be between 1 and {0}{1}{2}", mMaxVersion, vbCrLf, ex.Message)
            Return False

        End Try

    End Function

    Private Sub packageTree_AfterSelect(ByVal sender As Object, ByVal e As System.Windows.Forms.TreeViewEventArgs) Handles packageTree.AfterSelect

        PopulateVersionNumber(CType(e.Node, PackageNode))

    End Sub

#End Region

End Class
