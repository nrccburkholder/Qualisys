<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class MedicareMngrNavigator
    Inherits Qualisys.ConfigurationManager.Navigator

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()> _
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        If disposing AndAlso components IsNot Nothing Then
            components.Dispose()
        End If
        MyBase.Dispose(disposing)
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> _
    Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Me.MedicareNavToolStrip = New System.Windows.Forms.ToolStrip
        Me.MedicareNavNewTSButton = New System.Windows.Forms.ToolStripButton
        Me.MedicareNavDeleteTSButton = New System.Windows.Forms.ToolStripButton
        Me.MedicareNavRefreshTSButton = New System.Windows.Forms.ToolStripButton
        Me.MedicareNavGrid = New DevExpress.XtraGrid.GridControl
        Me.MedicareNavMenuStrip = New System.Windows.Forms.ContextMenuStrip(Me.components)
        Me.MedicareNavNewTSMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MedicareNavDeleteTSMenuItem = New System.Windows.Forms.ToolStripMenuItem
        Me.MedicareNumberBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.MedicareNavGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colMedicareNumber = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colProportionCalcType = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colEstAnnualVolume = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colEstResponseRate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colEstIneligibleRate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSwitchToCalcDate = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAnnualReturnTarget = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colProportion = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSamplingLocked = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colProportionChangeThreshold = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCensusForced = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colDisplayLabel = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colSamplingLockedImage = New DevExpress.XtraGrid.Columns.GridColumn
        Me.DefaultToolTipController = New DevExpress.Utils.DefaultToolTipController(Me.components)
        Me.MedicareNavToolStrip.SuspendLayout()
        CType(Me.MedicareNavGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.MedicareNavMenuStrip.SuspendLayout()
        CType(Me.MedicareNumberBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.MedicareNavGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.SuspendLayout()
        '
        'MedicareNavToolStrip
        '
        Me.MedicareNavToolStrip.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.MedicareNavToolStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MedicareNavNewTSButton, Me.MedicareNavDeleteTSButton, Me.MedicareNavRefreshTSButton})
        Me.MedicareNavToolStrip.Location = New System.Drawing.Point(0, 0)
        Me.MedicareNavToolStrip.Name = "MedicareNavToolStrip"
        Me.MedicareNavToolStrip.Size = New System.Drawing.Size(221, 25)
        Me.DefaultToolTipController.SetSuperTip(Me.MedicareNavToolStrip, Nothing)
        Me.MedicareNavToolStrip.TabIndex = 0
        Me.MedicareNavToolStrip.Text = "ToolStrip1"
        '
        'MedicareNavNewTSButton
        '
        Me.MedicareNavNewTSButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.New16
        Me.MedicareNavNewTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MedicareNavNewTSButton.Name = "MedicareNavNewTSButton"
        Me.MedicareNavNewTSButton.Size = New System.Drawing.Size(48, 22)
        Me.MedicareNavNewTSButton.Text = "New"
        '
        'MedicareNavDeleteTSButton
        '
        Me.MedicareNavDeleteTSButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.MedicareNavDeleteTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MedicareNavDeleteTSButton.Name = "MedicareNavDeleteTSButton"
        Me.MedicareNavDeleteTSButton.Size = New System.Drawing.Size(58, 22)
        Me.MedicareNavDeleteTSButton.Text = "Delete"
        '
        'MedicareNavRefreshTSButton
        '
        Me.MedicareNavRefreshTSButton.Alignment = System.Windows.Forms.ToolStripItemAlignment.Right
        Me.MedicareNavRefreshTSButton.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.Refresh
        Me.MedicareNavRefreshTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.MedicareNavRefreshTSButton.Name = "MedicareNavRefreshTSButton"
        Me.MedicareNavRefreshTSButton.Size = New System.Drawing.Size(65, 22)
        Me.MedicareNavRefreshTSButton.Text = "Refresh"
        '
        'MedicareNavGrid
        '
        Me.MedicareNavGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MedicareNavGrid.ContextMenuStrip = Me.MedicareNavMenuStrip
        Me.MedicareNavGrid.DataSource = Me.MedicareNumberBindingSource
        Me.MedicareNavGrid.EmbeddedNavigator.Name = ""
        Me.MedicareNavGrid.Location = New System.Drawing.Point(3, 28)
        Me.MedicareNavGrid.MainView = Me.MedicareNavGridView
        Me.MedicareNavGrid.Name = "MedicareNavGrid"
        Me.MedicareNavGrid.Size = New System.Drawing.Size(215, 437)
        Me.MedicareNavGrid.TabIndex = 1
        Me.MedicareNavGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.MedicareNavGridView})
        '
        'MedicareNavMenuStrip
        '
        Me.MedicareNavMenuStrip.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.MedicareNavNewTSMenuItem, Me.MedicareNavDeleteTSMenuItem})
        Me.MedicareNavMenuStrip.Name = "MedicareNavMenuStrip"
        Me.MedicareNavMenuStrip.Size = New System.Drawing.Size(203, 48)
        Me.DefaultToolTipController.SetSuperTip(Me.MedicareNavMenuStrip, Nothing)
        '
        'MedicareNavNewTSMenuItem
        '
        Me.MedicareNavNewTSMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.New16
        Me.MedicareNavNewTSMenuItem.Name = "MedicareNavNewTSMenuItem"
        Me.MedicareNavNewTSMenuItem.Size = New System.Drawing.Size(202, 22)
        Me.MedicareNavNewTSMenuItem.Text = "New Medicare Number"
        '
        'MedicareNavDeleteTSMenuItem
        '
        Me.MedicareNavDeleteTSMenuItem.Image = Global.Nrc.Qualisys.ConfigurationManager.My.Resources.Resources.DeleteRed16
        Me.MedicareNavDeleteTSMenuItem.Name = "MedicareNavDeleteTSMenuItem"
        Me.MedicareNavDeleteTSMenuItem.Size = New System.Drawing.Size(202, 22)
        Me.MedicareNavDeleteTSMenuItem.Text = "Delete Medicare Number"
        '
        'MedicareNumberBindingSource
        '
        Me.MedicareNumberBindingSource.DataSource = GetType(Nrc.Qualisys.Library.MedicareNumber)
        '
        'MedicareNavGridView
        '
        Me.MedicareNavGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colMedicareNumber, Me.colName, Me.colProportionCalcType, Me.colEstAnnualVolume, Me.colEstResponseRate, Me.colEstIneligibleRate, Me.colSwitchToCalcDate, Me.colAnnualReturnTarget, Me.colProportion, Me.colSamplingLocked, Me.colProportionChangeThreshold, Me.colCensusForced, Me.colDisplayLabel, Me.colSamplingLockedImage})
        Me.MedicareNavGridView.GridControl = Me.MedicareNavGrid
        Me.MedicareNavGridView.IndicatorWidth = 38
        Me.MedicareNavGridView.Name = "MedicareNavGridView"
        Me.MedicareNavGridView.OptionsBehavior.Editable = False
        Me.MedicareNavGridView.OptionsCustomization.AllowColumnMoving = False
        Me.MedicareNavGridView.OptionsCustomization.AllowGroup = False
        Me.MedicareNavGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.MedicareNavGridView.OptionsView.EnableAppearanceOddRow = True
        Me.MedicareNavGridView.OptionsView.ShowAutoFilterRow = True
        Me.MedicareNavGridView.OptionsView.ShowDetailButtons = False
        Me.MedicareNavGridView.OptionsView.ShowGroupPanel = False
        '
        'colMedicareNumber
        '
        Me.colMedicareNumber.Caption = "Number"
        Me.colMedicareNumber.FieldName = "MedicareNumber"
        Me.colMedicareNumber.Name = "colMedicareNumber"
        Me.colMedicareNumber.Visible = True
        Me.colMedicareNumber.VisibleIndex = 0
        '
        'colName
        '
        Me.colName.Caption = "Name"
        Me.colName.FieldName = "Name"
        Me.colName.Name = "colName"
        Me.colName.Visible = True
        Me.colName.VisibleIndex = 1
        '
        'colProportionCalcType
        '
        Me.colProportionCalcType.Caption = "ProportionCalcType"
        Me.colProportionCalcType.FieldName = "ProportionCalcType"
        Me.colProportionCalcType.Name = "colProportionCalcType"
        '
        'colEstAnnualVolume
        '
        Me.colEstAnnualVolume.Caption = "EstAnnualVolume"
        Me.colEstAnnualVolume.FieldName = "EstAnnualVolume"
        Me.colEstAnnualVolume.Name = "colEstAnnualVolume"
        '
        'colEstResponseRate
        '
        Me.colEstResponseRate.Caption = "EstResponseRate"
        Me.colEstResponseRate.FieldName = "EstResponseRate"
        Me.colEstResponseRate.Name = "colEstResponseRate"
        '
        'colEstIneligibleRate
        '
        Me.colEstIneligibleRate.Caption = "EstIneligibleRate"
        Me.colEstIneligibleRate.FieldName = "EstIneligibleRate"
        Me.colEstIneligibleRate.Name = "colEstIneligibleRate"
        '
        'colSwitchToCalcDate
        '
        Me.colSwitchToCalcDate.Caption = "SwitchToCalcDate"
        Me.colSwitchToCalcDate.FieldName = "SwitchToCalcDate"
        Me.colSwitchToCalcDate.Name = "colSwitchToCalcDate"
        '
        'colAnnualReturnTarget
        '
        Me.colAnnualReturnTarget.Caption = "AnnualReturnTarget"
        Me.colAnnualReturnTarget.FieldName = "AnnualReturnTarget"
        Me.colAnnualReturnTarget.Name = "colAnnualReturnTarget"
        '
        'colProportion
        '
        Me.colProportion.Caption = "Proportion"
        Me.colProportion.FieldName = "Proportion"
        Me.colProportion.Name = "colProportion"
        '
        'colSamplingLocked
        '
        Me.colSamplingLocked.Caption = "SamplingLocked"
        Me.colSamplingLocked.FieldName = "SamplingLocked"
        Me.colSamplingLocked.Name = "colSamplingLocked"
        '
        'colProportionChangeThreshold
        '
        Me.colProportionChangeThreshold.Caption = "ProportionChangeThreshold"
        Me.colProportionChangeThreshold.FieldName = "ProportionChangeThreshold"
        Me.colProportionChangeThreshold.Name = "colProportionChangeThreshold"
        '
        'colCensusForced
        '
        Me.colCensusForced.Caption = "CensusForced"
        Me.colCensusForced.FieldName = "CensusForced"
        Me.colCensusForced.Name = "colCensusForced"
        '
        'colDisplayLabel
        '
        Me.colDisplayLabel.Caption = "DisplayLabel"
        Me.colDisplayLabel.FieldName = "DisplayLabel"
        Me.colDisplayLabel.Name = "colDisplayLabel"
        '
        'colSamplingLockedImage
        '
        Me.colSamplingLockedImage.Caption = "SamplingLockedImage"
        Me.colSamplingLockedImage.FieldName = "SamplingLockedImage"
        Me.colSamplingLockedImage.Name = "colSamplingLockedImage"
        '
        'DefaultToolTipController
        '
        '
        '
        '
        Me.DefaultToolTipController.DefaultController.AutoPopDelay = 15000
        '
        'MedicareMngrNavigator
        '
        Me.Controls.Add(Me.MedicareNavGrid)
        Me.Controls.Add(Me.MedicareNavToolStrip)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "MedicareMngrNavigator"
        Me.Size = New System.Drawing.Size(221, 468)
        Me.DefaultToolTipController.SetSuperTip(Me, Nothing)
        Me.MedicareNavToolStrip.ResumeLayout(False)
        Me.MedicareNavToolStrip.PerformLayout()
        CType(Me.MedicareNavGrid, System.ComponentModel.ISupportInitialize).EndInit()
        Me.MedicareNavMenuStrip.ResumeLayout(False)
        CType(Me.MedicareNumberBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.MedicareNavGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents MedicareNavToolStrip As System.Windows.Forms.ToolStrip
    Friend WithEvents MedicareNavNewTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MedicareNavDeleteTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents MedicareNavGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents MedicareNavGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents MedicareNumberBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents colMedicareNumber As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colProportionCalcType As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colEstAnnualVolume As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colEstResponseRate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colEstIneligibleRate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSwitchToCalcDate As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAnnualReturnTarget As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colProportion As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSamplingLocked As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colProportionChangeThreshold As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCensusForced As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colDisplayLabel As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colSamplingLockedImage As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents MedicareNavMenuStrip As System.Windows.Forms.ContextMenuStrip
    Friend WithEvents MedicareNavNewTSMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents MedicareNavDeleteTSMenuItem As System.Windows.Forms.ToolStripMenuItem
    Friend WithEvents DefaultToolTipController As DevExpress.Utils.DefaultToolTipController
    Friend WithEvents MedicareNavRefreshTSButton As System.Windows.Forms.ToolStripButton

End Class
