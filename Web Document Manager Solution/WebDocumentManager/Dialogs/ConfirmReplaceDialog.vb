Public Class ConfirmReplaceDialog
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
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents btnNoToAll As System.Windows.Forms.Button
    Friend WithEvents btnNo As System.Windows.Forms.Button
    Friend WithEvents btnYesToAll As System.Windows.Forms.Button
    Friend WithEvents btnYes As System.Windows.Forms.Button
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents lblFolder As System.Windows.Forms.Label
    Friend WithEvents lblDocument As System.Windows.Forms.Label
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(ConfirmReplaceDialog))
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.PictureBox1 = New System.Windows.Forms.PictureBox
        Me.btnNoToAll = New System.Windows.Forms.Button
        Me.btnNo = New System.Windows.Forms.Button
        Me.btnYesToAll = New System.Windows.Forms.Button
        Me.btnYes = New System.Windows.Forms.Button
        Me.Label9 = New System.Windows.Forms.Label
        Me.lblFolder = New System.Windows.Forms.Label
        Me.lblDocument = New System.Windows.Forms.Label
        Me.btnCancel = New System.Windows.Forms.Button
        Me.SuspendLayout()
        '
        'Label2
        '
        Me.Label2.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(62, 96)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(612, 16)
        Me.Label2.TabIndex = 28
        Me.Label2.Text = "already contains a document named "
        '
        'Label1
        '
        Me.Label1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(62, 32)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(612, 16)
        Me.Label1.TabIndex = 26
        Me.Label1.Text = "Folder"
        '
        'PictureBox1
        '
        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
        Me.PictureBox1.Location = New System.Drawing.Point(14, 24)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(32, 32)
        Me.PictureBox1.TabIndex = 35
        Me.PictureBox1.TabStop = False
        '
        'btnNoToAll
        '
        Me.btnNoToAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNoToAll.Location = New System.Drawing.Point(606, 216)
        Me.btnNoToAll.Name = "btnNoToAll"
        Me.btnNoToAll.TabIndex = 34
        Me.btnNoToAll.Text = "No to All"
        '
        'btnNo
        '
        Me.btnNo.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNo.Location = New System.Drawing.Point(526, 216)
        Me.btnNo.Name = "btnNo"
        Me.btnNo.TabIndex = 33
        Me.btnNo.Text = "No"
        '
        'btnYesToAll
        '
        Me.btnYesToAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnYesToAll.Location = New System.Drawing.Point(446, 216)
        Me.btnYesToAll.Name = "btnYesToAll"
        Me.btnYesToAll.TabIndex = 32
        Me.btnYesToAll.Text = "Yes to All"
        '
        'btnYes
        '
        Me.btnYes.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnYes.Location = New System.Drawing.Point(368, 216)
        Me.btnYes.Name = "btnYes"
        Me.btnYes.TabIndex = 31
        Me.btnYes.Text = "Yes"
        '
        'Label9
        '
        Me.Label9.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label9.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label9.Location = New System.Drawing.Point(62, 160)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(612, 16)
        Me.Label9.TabIndex = 30
        Me.Label9.Text = "Would you like to replace the existing document?"
        '
        'lblFolder
        '
        Me.lblFolder.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblFolder.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblFolder.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFolder.Location = New System.Drawing.Point(90, 56)
        Me.lblFolder.Name = "lblFolder"
        Me.lblFolder.Size = New System.Drawing.Size(584, 32)
        Me.lblFolder.TabIndex = 27
        '
        'lblDocument
        '
        Me.lblDocument.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblDocument.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblDocument.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblDocument.Location = New System.Drawing.Point(90, 120)
        Me.lblDocument.Name = "lblDocument"
        Me.lblDocument.Size = New System.Drawing.Size(584, 32)
        Me.lblDocument.TabIndex = 29
        '
        'btnCancel
        '
        Me.btnCancel.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.btnCancel.Location = New System.Drawing.Point(280, 216)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 36
        Me.btnCancel.Text = "Cancel"
        '
        'ConfirmReplaceDialog
        '
        Me.AcceptButton = Me.btnYes
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.CancelButton = Me.btnCancel
        Me.ClientSize = New System.Drawing.Size(694, 262)
        Me.Controls.Add(Me.btnCancel)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Controls.Add(Me.PictureBox1)
        Me.Controls.Add(Me.btnNoToAll)
        Me.Controls.Add(Me.btnNo)
        Me.Controls.Add(Me.btnYesToAll)
        Me.Controls.Add(Me.btnYes)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.lblFolder)
        Me.Controls.Add(Me.lblDocument)
        Me.Icon = CType(resources.GetObject("$this.Icon"), System.Drawing.Icon)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "ConfirmReplaceDialog"
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Check Reposting Documents"
        Me.ResumeLayout(False)

    End Sub

#End Region


#Region " Private Members"

    Private mFolderPath As String
    Private mDocumentName As String

#End Region

#Region " Public Properties"

    Public Property FolderPath() As String
        Get
            Return mFolderPath
        End Get
        Set(ByVal Value As String)
            mFolderPath = Value
        End Set
    End Property

    Public Property DocumentName() As String
        Get
            Return mDocumentName
        End Get
        Set(ByVal Value As String)
            mDocumentName = Value
        End Set
    End Property
#End Region

#Region " Event Handlers"

    Private Sub frmConfirmReplace_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'EnableThemes(Me)
        Me.lblFolder.Text = Me.mFolderPath
        Me.lblDocument.Text = Me.mDocumentName
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        DialogResult = DialogResult.Cancel
    End Sub

    Private Sub btnYes_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnYes.Click
        DialogResult = DialogResult.Yes
    End Sub

    Private Sub btnYesToAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnYesToAll.Click
        DialogResult = DialogResult.OK
    End Sub

    Private Sub btnNo_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNo.Click
        DialogResult = DialogResult.No
    End Sub

    Private Sub btnNoToAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNoToAll.Click
        DialogResult = DialogResult.Ignore
    End Sub

#End Region

End Class
