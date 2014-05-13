Public Class ucModifyComment
    Inherits System.Windows.Forms.UserControl

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

    End Sub

    'UserControl overrides dispose to clean up the component list.
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
    Friend WithEvents lblLitho As System.Windows.Forms.Label
    Friend WithEvents btnFind As System.Windows.Forms.Button
    Friend WithEvents spnModify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents txtKey As System.Windows.Forms.TextBox
    Friend WithEvents lblQstnCore As System.Windows.Forms.Label
    Friend WithEvents btnUpdate As System.Windows.Forms.Button
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents SectionHeader1 As SectionHeader
    Friend WithEvents txtQstnCore As System.Windows.Forms.TextBox
    Friend WithEvents txtLitho As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.spnModify = New Nrc.Framework.WinForms.SectionPanel
        Me.SectionHeader1 = New SectionHeader
        Me.lblLitho = New System.Windows.Forms.Label
        Me.lblQstnCore = New System.Windows.Forms.Label
        Me.txtQstnCore = New System.Windows.Forms.TextBox
        Me.btnFind = New System.Windows.Forms.Button
        Me.btnUpdate = New System.Windows.Forms.Button
        Me.txtKey = New System.Windows.Forms.TextBox
        Me.btnCancel = New System.Windows.Forms.Button
        Me.txtLitho = New System.Windows.Forms.TextBox
        Me.spnModify.SuspendLayout()
        Me.SectionHeader1.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnModify
        '
        Me.spnModify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnModify.Caption = "Modify Transferred Comment"
        Me.spnModify.Controls.Add(Me.SectionHeader1)
        Me.spnModify.Controls.Add(Me.btnUpdate)
        Me.spnModify.Controls.Add(Me.txtKey)
        Me.spnModify.Controls.Add(Me.btnCancel)
        Me.spnModify.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnModify.DockPadding.All = 1
        Me.spnModify.Location = New System.Drawing.Point(0, 0)
        Me.spnModify.Name = "spnModify"
        Me.spnModify.ShowCaption = True
        Me.spnModify.Size = New System.Drawing.Size(528, 632)
        Me.spnModify.TabIndex = 0
        '
        'SectionHeader1
        '
        Me.SectionHeader1.Controls.Add(Me.lblLitho)
        Me.SectionHeader1.Controls.Add(Me.lblQstnCore)
        Me.SectionHeader1.Controls.Add(Me.txtQstnCore)
        Me.SectionHeader1.Controls.Add(Me.btnFind)
        Me.SectionHeader1.Controls.Add(Me.txtLitho)
        Me.SectionHeader1.Dock = System.Windows.Forms.DockStyle.Top
        Me.SectionHeader1.Location = New System.Drawing.Point(1, 27)
        Me.SectionHeader1.Name = "SectionHeader1"
        Me.SectionHeader1.Size = New System.Drawing.Size(526, 32)
        Me.SectionHeader1.TabIndex = 6
        '
        'lblLitho
        '
        Me.lblLitho.BackColor = System.Drawing.Color.Transparent
        Me.lblLitho.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblLitho.Location = New System.Drawing.Point(8, 5)
        Me.lblLitho.Name = "lblLitho"
        Me.lblLitho.Size = New System.Drawing.Size(72, 23)
        Me.lblLitho.TabIndex = 10
        Me.lblLitho.Text = "Litho Code:"
        Me.lblLitho.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblQstnCore
        '
        Me.lblQstnCore.BackColor = System.Drawing.Color.Transparent
        Me.lblQstnCore.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblQstnCore.Location = New System.Drawing.Point(224, 5)
        Me.lblQstnCore.Name = "lblQstnCore"
        Me.lblQstnCore.Size = New System.Drawing.Size(96, 23)
        Me.lblQstnCore.TabIndex = 11
        Me.lblQstnCore.Text = "Question Core:"
        Me.lblQstnCore.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'txtQstnCore
        '
        Me.txtQstnCore.Location = New System.Drawing.Point(320, 5)
        Me.txtQstnCore.Name = "txtQstnCore"
        Me.txtQstnCore.Size = New System.Drawing.Size(72, 21)
        Me.txtQstnCore.TabIndex = 2
        Me.txtQstnCore.Text = ""
        '
        'btnFind
        '
        Me.btnFind.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnFind.Location = New System.Drawing.Point(410, 5)
        Me.btnFind.Name = "btnFind"
        Me.btnFind.Size = New System.Drawing.Size(56, 23)
        Me.btnFind.TabIndex = 3
        Me.btnFind.Text = "Find"
        '
        'btnUpdate
        '
        Me.btnUpdate.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnUpdate.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnUpdate.Location = New System.Drawing.Point(176, 592)
        Me.btnUpdate.Name = "btnUpdate"
        Me.btnUpdate.TabIndex = 5
        Me.btnUpdate.Text = "Update"
        '
        'txtKey
        '
        Me.txtKey.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtKey.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.txtKey.Location = New System.Drawing.Point(8, 72)
        Me.txtKey.MaxLength = 12000
        Me.txtKey.Multiline = True
        Me.txtKey.Name = "txtKey"
        Me.txtKey.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.txtKey.Size = New System.Drawing.Size(512, 512)
        Me.txtKey.TabIndex = 4
        Me.txtKey.Text = ""
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = System.Windows.Forms.AnchorStyles.Bottom
        Me.btnCancel.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.btnCancel.Location = New System.Drawing.Point(272, 592)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 6
        Me.btnCancel.Text = "Cancel"
        '
        'txtLitho
        '
        Me.txtLitho.Location = New System.Drawing.Point(88, 5)
        Me.txtLitho.Name = "txtLitho"
        Me.txtLitho.Size = New System.Drawing.Size(128, 21)
        Me.txtLitho.TabIndex = 1
        Me.txtLitho.Text = ""
        '
        'ucModifyComment
        '
        Me.Controls.Add(Me.spnModify)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "ucModifyComment"
        Me.Size = New System.Drawing.Size(528, 632)
        Me.spnModify.ResumeLayout(False)
        Me.SectionHeader1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub InitializeControls(ByVal enable As Boolean)

    End Sub

    Private Sub ucModifyComment_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        txtKey.DataBindings.Add("font", Settings, "CommentFont")
    End Sub

    Private Sub btnFind_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFind.Click

    End Sub

    Private Sub btnUpdate_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnUpdate.Click

    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click

    End Sub

End Class
