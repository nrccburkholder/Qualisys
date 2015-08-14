<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class FacilityAdminSection
    Inherits Nrc.Qualisys.ConfigurationManager.Section

    'UserControl overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.tabCtrlFacilityAdmin = New DevExpress.XtraTab.XtraTabControl()
        Me.tpageFacility = New DevExpress.XtraTab.XtraTabPage()
        Me.FacilitySection2 = New Nrc.Qualisys.ConfigurationManager.FacilitySection()
        Me.tpageGroupsSites = New DevExpress.XtraTab.XtraTabPage()
        Me.FacilityGroupSiteMappingSection1 = New Nrc.Qualisys.ConfigurationManager.FacilityGroupSiteMappingSection()
        CType(Me.tabCtrlFacilityAdmin, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.tabCtrlFacilityAdmin.SuspendLayout()
        Me.tpageFacility.SuspendLayout()
        Me.tpageGroupsSites.SuspendLayout()
        Me.SuspendLayout()
        '
        'tabCtrlFacilityAdmin
        '
        Me.tabCtrlFacilityAdmin.Dock = System.Windows.Forms.DockStyle.Fill
        Me.tabCtrlFacilityAdmin.Location = New System.Drawing.Point(0, 0)
        Me.tabCtrlFacilityAdmin.Name = "tabCtrlFacilityAdmin"
        Me.tabCtrlFacilityAdmin.SelectedTabPage = Me.tpageFacility
        Me.tabCtrlFacilityAdmin.ShowTabHeader = DevExpress.Utils.DefaultBoolean.[False]
        Me.tabCtrlFacilityAdmin.Size = New System.Drawing.Size(998, 561)
        Me.tabCtrlFacilityAdmin.TabIndex = 0
        Me.tabCtrlFacilityAdmin.TabPages.AddRange(New DevExpress.XtraTab.XtraTabPage() {Me.tpageFacility, Me.tpageGroupsSites})
        '
        'tpageFacility
        '
        Me.tpageFacility.Controls.Add(Me.FacilitySection2)
        Me.tpageFacility.Name = "tpageFacility"
        Me.tpageFacility.Size = New System.Drawing.Size(991, 532)
        Me.tpageFacility.Text = "Facilities"
        '
        'FacilitySection2
        '
        Me.FacilitySection2.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FacilitySection2.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FacilitySection2.Location = New System.Drawing.Point(0, 0)
        Me.FacilitySection2.Name = "FacilitySection2"
        Me.FacilitySection2.Size = New System.Drawing.Size(991, 532)
        Me.FacilitySection2.TabIndex = 0
        '
        'tpageGroupsSites
        '
        Me.tpageGroupsSites.Controls.Add(Me.FacilityGroupSiteMappingSection1)
        Me.tpageGroupsSites.Name = "tpageGroupsSites"
        Me.tpageGroupsSites.Size = New System.Drawing.Size(991, 554)
        Me.tpageGroupsSites.Text = "Groups and Sites"
        '
        'FacilityGroupSiteMappingSection1
        '
        Me.FacilityGroupSiteMappingSection1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.FacilityGroupSiteMappingSection1.Location = New System.Drawing.Point(0, 0)
        Me.FacilityGroupSiteMappingSection1.Name = "FacilityGroupSiteMappingSection1"
        Me.FacilityGroupSiteMappingSection1.Size = New System.Drawing.Size(991, 554)
        Me.FacilityGroupSiteMappingSection1.TabIndex = 0
        '
        'FacilityAdminSection
        '
        Me.Controls.Add(Me.tabCtrlFacilityAdmin)
        Me.Name = "FacilityAdminSection"
        Me.Size = New System.Drawing.Size(998, 561)
        CType(Me.tabCtrlFacilityAdmin, System.ComponentModel.ISupportInitialize).EndInit()
        Me.tabCtrlFacilityAdmin.ResumeLayout(False)
        Me.tpageFacility.ResumeLayout(False)
        Me.tpageGroupsSites.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents XtraTabControl1 As DevExpress.XtraTab.XtraTabControl
    Friend WithEvents XtraTabPage1 As DevExpress.XtraTab.XtraTabPage
    Friend WithEvents XtraTabPage2 As DevExpress.XtraTab.XtraTabPage
    Friend WithEvents FacilitySection1 As Nrc.Qualisys.ConfigurationManager.FacilitySection
    Friend WithEvents tabCtrlFacilityAdmin As DevExpress.XtraTab.XtraTabControl
    Friend WithEvents tpageFacility As DevExpress.XtraTab.XtraTabPage
    Friend WithEvents FacilitySection2 As Nrc.Qualisys.ConfigurationManager.FacilitySection
    Friend WithEvents tpageGroupsSites As DevExpress.XtraTab.XtraTabPage
    Friend WithEvents FacilityGroupSiteMappingSection1 As Nrc.Qualisys.ConfigurationManager.FacilityGroupSiteMappingSection

End Class
