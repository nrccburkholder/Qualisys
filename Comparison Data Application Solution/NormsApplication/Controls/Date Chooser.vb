Public Class Date_Chooser
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
    Friend WithEvents dtpMaxdate As System.Windows.Forms.DateTimePicker
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents dtpMindate As System.Windows.Forms.DateTimePicker
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.dtpMaxdate = New System.Windows.Forms.DateTimePicker
        Me.dtpMindate = New System.Windows.Forms.DateTimePicker
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Date Chooser"
        Me.SectionPanel1.Controls.Add(Me.dtpMaxdate)
        Me.SectionPanel1.Controls.Add(Me.dtpMindate)
        Me.SectionPanel1.Controls.Add(Me.Label3)
        Me.SectionPanel1.Controls.Add(Me.Label4)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.TabIndex = 0
        '
        'dtpMaxdate
        '
        Me.dtpMaxdate.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.dtpMaxdate.Location = New System.Drawing.Point(256, 72)
        Me.dtpMaxdate.Name = "dtpMaxdate"
        Me.dtpMaxdate.TabIndex = 1
        '
        'dtpMindate
        '
        Me.dtpMindate.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.dtpMindate.Location = New System.Drawing.Point(8, 72)
        Me.dtpMindate.Name = "dtpMindate"
        Me.dtpMindate.Size = New System.Drawing.Size(220, 20)
        Me.dtpMindate.TabIndex = 0
        '
        'Label3
        '
        Me.Label3.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.Label3.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.Location = New System.Drawing.Point(16, 40)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(200, 33)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "Minimum Return Date"
        '
        'Label4
        '
        Me.Label4.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.Label4.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.Location = New System.Drawing.Point(256, 40)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(200, 33)
        Me.Label4.TabIndex = 7
        Me.Label4.Text = "Maximum Return Date"
        '
        'Date_Chooser
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "Date_Chooser"
        Me.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region


    Public Property Mindate() As DateTime
        Get
            Return dtpMindate.Value
        End Get
        Set(ByVal Value As DateTime)
            dtpMindate.Value = Value
        End Set
    End Property

    Public Property Maxdate() As DateTime
        Get
            Return dtpMaxdate.Value
        End Get
        Set(ByVal Value As DateTime)
            dtpMaxdate.Value = Value
        End Set
    End Property

End Class
