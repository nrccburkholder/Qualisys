Public Class ucAdministration
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
    Friend WithEvents spnAdmin As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents spnAdminFinalize As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ListView1 As System.Windows.Forms.ListView
    Friend WithEvents spnAdminLoad As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents spnAdminModify As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents spnAdminUser As Nrc.Framework.WinForms.SectionPanel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.spnAdmin = New Nrc.Framework.WinForms.SectionPanel
        Me.spnAdminFinalize = New Nrc.Framework.WinForms.SectionPanel
        Me.ListView1 = New System.Windows.Forms.ListView
        Me.spnAdminLoad = New Nrc.Framework.WinForms.SectionPanel
        Me.spnAdminModify = New Nrc.Framework.WinForms.SectionPanel
        Me.spnAdminUser = New Nrc.Framework.WinForms.SectionPanel
        Me.spnAdmin.SuspendLayout()
        Me.spnAdminFinalize.SuspendLayout()
        Me.SuspendLayout()
        '
        'spnAdmin
        '
        Me.spnAdmin.BackColor = System.Drawing.SystemColors.Control
        Me.spnAdmin.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnAdmin.Caption = "Administration"
        Me.spnAdmin.Controls.Add(Me.spnAdminFinalize)
        Me.spnAdmin.Controls.Add(Me.spnAdminLoad)
        Me.spnAdmin.Controls.Add(Me.spnAdminModify)
        Me.spnAdmin.Controls.Add(Me.spnAdminUser)
        Me.spnAdmin.Dock = System.Windows.Forms.DockStyle.Fill
        Me.spnAdmin.DockPadding.All = 1
        Me.spnAdmin.Location = New System.Drawing.Point(0, 0)
        Me.spnAdmin.Name = "spnAdmin"
        Me.spnAdmin.ShowCaption = True
        Me.spnAdmin.Size = New System.Drawing.Size(704, 600)
        Me.spnAdmin.TabIndex = 8
        '
        'spnAdminFinalize
        '
        Me.spnAdminFinalize.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnAdminFinalize.Caption = "Finalize"
        Me.spnAdminFinalize.Controls.Add(Me.ListView1)
        Me.spnAdminFinalize.DockPadding.All = 1
        Me.spnAdminFinalize.Location = New System.Drawing.Point(1, 27)
        Me.spnAdminFinalize.Name = "spnAdminFinalize"
        Me.spnAdminFinalize.ShowCaption = False
        Me.spnAdminFinalize.Size = New System.Drawing.Size(722, 532)
        Me.spnAdminFinalize.TabIndex = 1
        '
        'ListView1
        '
        Me.ListView1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.ListView1.CheckBoxes = True
        Me.ListView1.FullRowSelect = True
        Me.ListView1.GridLines = True
        Me.ListView1.Location = New System.Drawing.Point(8, 8)
        Me.ListView1.Name = "ListView1"
        Me.ListView1.Size = New System.Drawing.Size(688, 288)
        Me.ListView1.TabIndex = 0
        Me.ListView1.View = System.Windows.Forms.View.Details
        '
        'spnAdminLoad
        '
        Me.spnAdminLoad.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnAdminLoad.Caption = "Load Offline File"
        Me.spnAdminLoad.DockPadding.All = 1
        Me.spnAdminLoad.Location = New System.Drawing.Point(1, 27)
        Me.spnAdminLoad.Name = "spnAdminLoad"
        Me.spnAdminLoad.ShowCaption = False
        Me.spnAdminLoad.Size = New System.Drawing.Size(722, 532)
        Me.spnAdminLoad.TabIndex = 2
        '
        'spnAdminModify
        '
        Me.spnAdminModify.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnAdminModify.Caption = "Modify Existing Comment"
        Me.spnAdminModify.DockPadding.All = 1
        Me.spnAdminModify.Location = New System.Drawing.Point(1, 27)
        Me.spnAdminModify.Name = "spnAdminModify"
        Me.spnAdminModify.ShowCaption = False
        Me.spnAdminModify.Size = New System.Drawing.Size(722, 532)
        Me.spnAdminModify.TabIndex = 3
        '
        'spnAdminUser
        '
        Me.spnAdminUser.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.spnAdminUser.Caption = "User Administration"
        Me.spnAdminUser.DockPadding.All = 1
        Me.spnAdminUser.Location = New System.Drawing.Point(1, 27)
        Me.spnAdminUser.Name = "spnAdminUser"
        Me.spnAdminUser.ShowCaption = False
        Me.spnAdminUser.Size = New System.Drawing.Size(722, 532)
        Me.spnAdminUser.TabIndex = 4
        '
        'ucAdministration
        '
        Me.Controls.Add(Me.spnAdmin)
        Me.Name = "ucAdministration"
        Me.Size = New System.Drawing.Size(704, 600)
        Me.spnAdmin.ResumeLayout(False)
        Me.spnAdminFinalize.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

End Class
