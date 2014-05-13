Public Class UseFacilitiesCheck
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
    Friend WithEvents chkFacilityPercentiles As System.Windows.Forms.CheckBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.chkFacilityPercentiles = New System.Windows.Forms.CheckBox
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Use Facilities Check"
        Me.SectionPanel1.Controls.Add(Me.chkFacilityPercentiles)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.TabIndex = 2
        '
        'chkFacilityPercentiles
        '
        Me.chkFacilityPercentiles.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.chkFacilityPercentiles.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.chkFacilityPercentiles.Location = New System.Drawing.Point(145, 48)
        Me.chkFacilityPercentiles.Name = "chkFacilityPercentiles"
        Me.chkFacilityPercentiles.Size = New System.Drawing.Size(183, 24)
        Me.chkFacilityPercentiles.TabIndex = 12
        Me.chkFacilityPercentiles.Text = "Aggregate by Facility"
        '
        'UseFacilitiesCheck
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "UseFacilitiesCheck"
        Me.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Property UseFacilities() As Boolean
        Get
            Return chkFacilityPercentiles.Checked
        End Get
        Set(ByVal Value As Boolean)
            chkFacilityPercentiles.Checked = Value
        End Set
    End Property

End Class
