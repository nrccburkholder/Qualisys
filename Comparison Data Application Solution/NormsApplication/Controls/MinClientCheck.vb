Public Class MinClientCheck
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
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents chkMinClientCheck As System.Windows.Forms.CheckBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.chkMinClientCheck = New System.Windows.Forms.CheckBox
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Minimum Client Check"
        Me.SectionPanel1.Controls.Add(Me.chkMinClientCheck)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.TabIndex = 2
        '
        'chkMinClientCheck
        '
        Me.chkMinClientCheck.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.chkMinClientCheck.Checked = True
        Me.chkMinClientCheck.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkMinClientCheck.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkMinClientCheck.Location = New System.Drawing.Point(84, 40)
        Me.chkMinClientCheck.Name = "chkMinClientCheck"
        Me.chkMinClientCheck.Size = New System.Drawing.Size(304, 40)
        Me.chkMinClientCheck.TabIndex = 12
        Me.chkMinClientCheck.Text = "Do Not Include Questions Used by 1 Client"
        '
        'MinClientCheck
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "MinClientCheck"
        Me.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Property MinClientCheck() As Boolean
        Get
            Return chkMinClientCheck.Checked
        End Get
        Set(ByVal Value As Boolean)
            chkMinClientCheck.Checked = Value
        End Set
    End Property
End Class
