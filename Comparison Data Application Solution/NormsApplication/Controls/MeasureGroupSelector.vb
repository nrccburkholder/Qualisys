Imports NormsApplicationBusinessObjectsLibrary
Public Class MeasureGroupSelector
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
    Friend WithEvents cboMeasure As System.Windows.Forms.ComboBox
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.cboMeasure = New System.Windows.Forms.ComboBox
        Me.Label11 = New System.Windows.Forms.Label
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'cboMeasure
        '
        Me.cboMeasure.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.cboMeasure.Location = New System.Drawing.Point(114, 64)
        Me.cboMeasure.Name = "cboMeasure"
        Me.cboMeasure.Size = New System.Drawing.Size(244, 21)
        Me.cboMeasure.TabIndex = 9
        '
        'Label11
        '
        Me.Label11.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.Label11.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label11.Location = New System.Drawing.Point(114, 40)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(246, 23)
        Me.Label11.TabIndex = 8
        Me.Label11.Text = "Measure/Grouping"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Select Measure/Grouping"
        Me.SectionPanel1.Controls.Add(Me.Label11)
        Me.SectionPanel1.Controls.Add(Me.cboMeasure)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.TabIndex = 10
        '
        'MeasureGroupSelector
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "MeasureGroupSelector"
        Me.Size = New System.Drawing.Size(472, 104)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Sub PopulateMeasures()
        cboMeasure.DataSource = Nothing
        cboMeasure.DataSource = DataAccess.GetMeasures()
        cboMeasure.DisplayMember = "GroupingName"
        cboMeasure.ValueMember = "GroupingID"
        For Each tmpGrouping As Groupings In cboMeasure.DataSource
            If tmpGrouping.GroupingID = 998 Then
                cboMeasure.SelectedItem = tmpGrouping
                Exit For
            End If
        Next
    End Sub

    Public ReadOnly Property SelectedGroupID() As Integer
        Get
            Return DirectCast(cboMeasure.SelectedItem, Groupings).GroupingID
        End Get
    End Property
End Class
