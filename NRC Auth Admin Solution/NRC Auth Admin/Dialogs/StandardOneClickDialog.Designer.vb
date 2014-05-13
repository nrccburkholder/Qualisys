<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class StandardOneClickDialog
    Inherits Nrc.Framework.WinForms.DialogForm

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
        Dim GridLevelNode1 As DevExpress.XtraGrid.GridLevelNode = New DevExpress.XtraGrid.GridLevelNode
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(StandardOneClickDialog))
        Me.OneClickDefinitionGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.OneClickDefinitionOrderColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickDefinitionCategoryColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickDefinitionNameColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickDefinitionDescriptionColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickDefinitionReportIdColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.OneClickTypeGrid = New DevExpress.XtraGrid.GridControl
        Me.OneClickTypeBindingSource = New System.Windows.Forms.BindingSource(Me.components)
        Me.OneClickTypeGridView = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.OneClickTypeNameColumn = New DevExpress.XtraGrid.Columns.GridColumn
        Me.TableLayoutPanel2 = New System.Windows.Forms.TableLayoutPanel
        Me.Cancel_Button = New System.Windows.Forms.Button
        Me.OK_Button = New System.Windows.Forms.Button
        Me.OneClickTypeNavigator = New System.Windows.Forms.BindingNavigator(Me.components)
        Me.OneClickTypeNavigatorAddNewTSButton = New System.Windows.Forms.ToolStripButton
        Me.OneClickTypeNavigatorDeleteTSButton = New System.Windows.Forms.ToolStripButton
        Me.OneClickTypeNavigatorSaveTSButton = New System.Windows.Forms.ToolStripButton
        CType(Me.OneClickDefinitionGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickTypeGrid, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickTypeBindingSource, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.OneClickTypeGridView, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.TableLayoutPanel2.SuspendLayout()
        CType(Me.OneClickTypeNavigator, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.OneClickTypeNavigator.SuspendLayout()
        Me.SuspendLayout()
        '
        'mPaneCaption
        '
        Me.mPaneCaption.Caption = "Standard OneClick Reports"
        Me.mPaneCaption.Size = New System.Drawing.Size(598, 26)
        Me.mPaneCaption.Text = "Standard OneClick Reports"
        '
        'OneClickDefinitionGridView
        '
        Me.OneClickDefinitionGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.OneClickDefinitionOrderColumn, Me.OneClickDefinitionCategoryColumn, Me.OneClickDefinitionNameColumn, Me.OneClickDefinitionDescriptionColumn, Me.OneClickDefinitionReportIdColumn})
        Me.OneClickDefinitionGridView.GridControl = Me.OneClickTypeGrid
        Me.OneClickDefinitionGridView.Name = "OneClickDefinitionGridView"
        Me.OneClickDefinitionGridView.OptionsCustomization.AllowGroup = False
        Me.OneClickDefinitionGridView.OptionsDetail.AllowZoomDetail = False
        Me.OneClickDefinitionGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.OneClickDefinitionGridView.OptionsView.ShowGroupPanel = False
        '
        'OneClickDefinitionOrderColumn
        '
        Me.OneClickDefinitionOrderColumn.Caption = "Display Order"
        Me.OneClickDefinitionOrderColumn.FieldName = "Order"
        Me.OneClickDefinitionOrderColumn.Name = "OneClickDefinitionOrderColumn"
        Me.OneClickDefinitionOrderColumn.Visible = True
        Me.OneClickDefinitionOrderColumn.VisibleIndex = 0
        '
        'OneClickDefinitionCategoryColumn
        '
        Me.OneClickDefinitionCategoryColumn.Caption = "Category Name"
        Me.OneClickDefinitionCategoryColumn.FieldName = "CategoryName"
        Me.OneClickDefinitionCategoryColumn.Name = "OneClickDefinitionCategoryColumn"
        Me.OneClickDefinitionCategoryColumn.Visible = True
        Me.OneClickDefinitionCategoryColumn.VisibleIndex = 1
        '
        'OneClickDefinitionNameColumn
        '
        Me.OneClickDefinitionNameColumn.Caption = "Report Name"
        Me.OneClickDefinitionNameColumn.FieldName = "OneClickReportName"
        Me.OneClickDefinitionNameColumn.Name = "OneClickDefinitionNameColumn"
        Me.OneClickDefinitionNameColumn.Visible = True
        Me.OneClickDefinitionNameColumn.VisibleIndex = 2
        '
        'OneClickDefinitionDescriptionColumn
        '
        Me.OneClickDefinitionDescriptionColumn.Caption = "Report Description"
        Me.OneClickDefinitionDescriptionColumn.FieldName = "OneClickReportDescription"
        Me.OneClickDefinitionDescriptionColumn.Name = "OneClickDefinitionDescriptionColumn"
        Me.OneClickDefinitionDescriptionColumn.Visible = True
        Me.OneClickDefinitionDescriptionColumn.VisibleIndex = 3
        '
        'OneClickDefinitionReportIdColumn
        '
        Me.OneClickDefinitionReportIdColumn.Caption = "Report ID"
        Me.OneClickDefinitionReportIdColumn.FieldName = "ReportId"
        Me.OneClickDefinitionReportIdColumn.Name = "OneClickDefinitionReportIdColumn"
        Me.OneClickDefinitionReportIdColumn.Visible = True
        Me.OneClickDefinitionReportIdColumn.VisibleIndex = 4
        '
        'OneClickTypeGrid
        '
        Me.OneClickTypeGrid.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.OneClickTypeGrid.DataSource = Me.OneClickTypeBindingSource
        Me.OneClickTypeGrid.EmbeddedNavigator.Name = ""
        GridLevelNode1.LevelTemplate = Me.OneClickDefinitionGridView
        GridLevelNode1.RelationName = "Definitions"
        Me.OneClickTypeGrid.LevelTree.Nodes.AddRange(New DevExpress.XtraGrid.GridLevelNode() {GridLevelNode1})
        Me.OneClickTypeGrid.Location = New System.Drawing.Point(4, 55)
        Me.OneClickTypeGrid.MainView = Me.OneClickTypeGridView
        Me.OneClickTypeGrid.Name = "OneClickTypeGrid"
        Me.OneClickTypeGrid.Size = New System.Drawing.Size(592, 305)
        Me.OneClickTypeGrid.TabIndex = 8
        Me.OneClickTypeGrid.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.OneClickTypeGridView, Me.OneClickDefinitionGridView})
        '
        'OneClickTypeBindingSource
        '
        Me.OneClickTypeBindingSource.DataSource = GetType(Nrc.DataMart.MySolutions.Library.OneClickType)
        '
        'OneClickTypeGridView
        '
        Me.OneClickTypeGridView.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.OneClickTypeNameColumn})
        Me.OneClickTypeGridView.GridControl = Me.OneClickTypeGrid
        Me.OneClickTypeGridView.Name = "OneClickTypeGridView"
        Me.OneClickTypeGridView.OptionsCustomization.AllowGroup = False
        Me.OneClickTypeGridView.OptionsDetail.AllowZoomDetail = False
        Me.OneClickTypeGridView.OptionsDetail.ShowDetailTabs = False
        Me.OneClickTypeGridView.OptionsView.EnableAppearanceEvenRow = True
        Me.OneClickTypeGridView.OptionsView.ShowGroupPanel = False
        '
        'OneClickTypeNameColumn
        '
        Me.OneClickTypeNameColumn.Caption = "Type Name"
        Me.OneClickTypeNameColumn.FieldName = "OneClickTypeName"
        Me.OneClickTypeNameColumn.Name = "OneClickTypeNameColumn"
        Me.OneClickTypeNameColumn.Visible = True
        Me.OneClickTypeNameColumn.VisibleIndex = 0
        '
        'TableLayoutPanel2
        '
        Me.TableLayoutPanel2.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.TableLayoutPanel2.ColumnCount = 2
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel2.ColumnStyles.Add(New System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel2.Controls.Add(Me.Cancel_Button, 1, 0)
        Me.TableLayoutPanel2.Controls.Add(Me.OK_Button, 0, 0)
        Me.TableLayoutPanel2.Location = New System.Drawing.Point(448, 366)
        Me.TableLayoutPanel2.Name = "TableLayoutPanel2"
        Me.TableLayoutPanel2.RowCount = 1
        Me.TableLayoutPanel2.RowStyles.Add(New System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Percent, 50.0!))
        Me.TableLayoutPanel2.Size = New System.Drawing.Size(146, 29)
        Me.TableLayoutPanel2.TabIndex = 7
        '
        'Cancel_Button
        '
        Me.Cancel_Button.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.Cancel_Button.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Cancel_Button.Location = New System.Drawing.Point(76, 3)
        Me.Cancel_Button.Name = "Cancel_Button"
        Me.Cancel_Button.Size = New System.Drawing.Size(67, 23)
        Me.Cancel_Button.TabIndex = 1
        Me.Cancel_Button.Text = "Cancel"
        '
        'OK_Button
        '
        Me.OK_Button.Anchor = System.Windows.Forms.AnchorStyles.None
        Me.OK_Button.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.OK_Button.Location = New System.Drawing.Point(3, 3)
        Me.OK_Button.Name = "OK_Button"
        Me.OK_Button.Size = New System.Drawing.Size(67, 23)
        Me.OK_Button.TabIndex = 0
        Me.OK_Button.Text = "OK"
        '
        'OneClickTypeNavigator
        '
        Me.OneClickTypeNavigator.AddNewItem = Nothing
        Me.OneClickTypeNavigator.BindingSource = Me.OneClickTypeBindingSource
        Me.OneClickTypeNavigator.CountItem = Nothing
        Me.OneClickTypeNavigator.DeleteItem = Nothing
        Me.OneClickTypeNavigator.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.OneClickTypeNavigatorAddNewTSButton, Me.OneClickTypeNavigatorDeleteTSButton, Me.OneClickTypeNavigatorSaveTSButton})
        Me.OneClickTypeNavigator.Location = New System.Drawing.Point(1, 27)
        Me.OneClickTypeNavigator.MoveFirstItem = Nothing
        Me.OneClickTypeNavigator.MoveLastItem = Nothing
        Me.OneClickTypeNavigator.MoveNextItem = Nothing
        Me.OneClickTypeNavigator.MovePreviousItem = Nothing
        Me.OneClickTypeNavigator.Name = "OneClickTypeNavigator"
        Me.OneClickTypeNavigator.PositionItem = Nothing
        Me.OneClickTypeNavigator.Size = New System.Drawing.Size(598, 25)
        Me.OneClickTypeNavigator.TabIndex = 9
        Me.OneClickTypeNavigator.Text = "BindingNavigator1"
        '
        'OneClickTypeNavigatorAddNewTSButton
        '
        Me.OneClickTypeNavigatorAddNewTSButton.Image = CType(resources.GetObject("OneClickTypeNavigatorAddNewTSButton.Image"), System.Drawing.Image)
        Me.OneClickTypeNavigatorAddNewTSButton.Name = "BindingNavigatorAddNewItem"
        Me.OneClickTypeNavigatorAddNewTSButton.RightToLeftAutoMirrorImage = True
        Me.OneClickTypeNavigatorAddNewTSButton.Size = New System.Drawing.Size(46, 22)
        Me.OneClickTypeNavigatorAddNewTSButton.Text = "Add"
        '
        'OneClickTypeNavigatorDeleteTSButton
        '
        Me.OneClickTypeNavigatorDeleteTSButton.Image = CType(resources.GetObject("OneClickTypeNavigatorDeleteTSButton.Image"), System.Drawing.Image)
        Me.OneClickTypeNavigatorDeleteTSButton.Name = "BindingNavigatorDeleteItem"
        Me.OneClickTypeNavigatorDeleteTSButton.RightToLeftAutoMirrorImage = True
        Me.OneClickTypeNavigatorDeleteTSButton.Size = New System.Drawing.Size(58, 22)
        Me.OneClickTypeNavigatorDeleteTSButton.Text = "Delete"
        '
        'OneClickTypeNavigatorSaveTSButton
        '
        Me.OneClickTypeNavigatorSaveTSButton.Image = Global.Nrc.NrcAuthAdmin.My.Resources.Resources.Save16
        Me.OneClickTypeNavigatorSaveTSButton.ImageTransparentColor = System.Drawing.Color.Magenta
        Me.OneClickTypeNavigatorSaveTSButton.Name = "OneClickTypeNavigatorSaveTSButton"
        Me.OneClickTypeNavigatorSaveTSButton.Size = New System.Drawing.Size(51, 22)
        Me.OneClickTypeNavigatorSaveTSButton.Text = "Save"
        '
        'StandardOneClickDialog
        '
        Me.Caption = "Standard OneClick Reports"
        Me.ClientSize = New System.Drawing.Size(600, 400)
        Me.ControlBox = False
        Me.Controls.Add(Me.OneClickTypeNavigator)
        Me.Controls.Add(Me.OneClickTypeGrid)
        Me.Controls.Add(Me.TableLayoutPanel2)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.SizableToolWindow
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "StandardOneClickDialog"
        Me.ShowIcon = False
        Me.Controls.SetChildIndex(Me.mPaneCaption, 0)
        Me.Controls.SetChildIndex(Me.TableLayoutPanel2, 0)
        Me.Controls.SetChildIndex(Me.OneClickTypeGrid, 0)
        Me.Controls.SetChildIndex(Me.OneClickTypeNavigator, 0)
        CType(Me.OneClickDefinitionGridView, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickTypeGrid, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickTypeBindingSource, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.OneClickTypeGridView, System.ComponentModel.ISupportInitialize).EndInit()
        Me.TableLayoutPanel2.ResumeLayout(False)
        CType(Me.OneClickTypeNavigator, System.ComponentModel.ISupportInitialize).EndInit()
        Me.OneClickTypeNavigator.ResumeLayout(False)
        Me.OneClickTypeNavigator.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents TableLayoutPanel2 As System.Windows.Forms.TableLayoutPanel
    Friend WithEvents Cancel_Button As System.Windows.Forms.Button
    Friend WithEvents OK_Button As System.Windows.Forms.Button
    Friend WithEvents OneClickTypeBindingSource As System.Windows.Forms.BindingSource
    Friend WithEvents OneClickTypeGrid As DevExpress.XtraGrid.GridControl
    Friend WithEvents OneClickTypeGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents OneClickDefinitionGridView As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents OneClickDefinitionOrderColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickDefinitionCategoryColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickDefinitionNameColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickDefinitionDescriptionColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickDefinitionReportIdColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickTypeNameColumn As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents OneClickTypeNavigator As System.Windows.Forms.BindingNavigator
    Friend WithEvents OneClickTypeNavigatorAddNewTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OneClickTypeNavigatorDeleteTSButton As System.Windows.Forms.ToolStripButton
    Friend WithEvents OneClickTypeNavigatorSaveTSButton As System.Windows.Forms.ToolStripButton

End Class
