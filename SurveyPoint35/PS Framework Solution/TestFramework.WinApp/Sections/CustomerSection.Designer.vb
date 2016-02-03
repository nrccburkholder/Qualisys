<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Partial Class CustomerSection
    Inherits Section

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
        Me.components = New System.ComponentModel.Container
        Me.HeaderStrip1 = New PS.Framework.WinForms.HeaderStrip
        Me.ToolStripLabel1 = New System.Windows.Forms.ToolStripLabel
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.grdCustomers = New DevExpress.XtraGrid.GridControl
        Me.bsCustomer = New System.Windows.Forms.BindingSource(Me.components)
        Me.GridView1 = New DevExpress.XtraGrid.Views.Grid.GridView
        Me.colCustomerID = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCompanyName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colContactName = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colContactTitle = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colAddress = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCity = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colRegion = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPostalcode = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colCountry = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colPhone = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colFax = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsDirty = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsNew = New DevExpress.XtraGrid.Columns.GridColumn
        Me.colIsDeleted = New DevExpress.XtraGrid.Columns.GridColumn
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.cmdDelete = New System.Windows.Forms.Button
        Me.cmdSave = New System.Windows.Forms.Button
        Me.cmdClear = New System.Windows.Forms.Button
        Me.cmdNew = New System.Windows.Forms.Button
        Me.txtTitle = New System.Windows.Forms.TextBox
        Me.txtFax = New System.Windows.Forms.TextBox
        Me.txtPhone = New System.Windows.Forms.TextBox
        Me.txtName = New System.Windows.Forms.TextBox
        Me.txtCountry = New System.Windows.Forms.TextBox
        Me.txtPostalCode = New System.Windows.Forms.TextBox
        Me.txtRegion = New System.Windows.Forms.TextBox
        Me.txtCity = New System.Windows.Forms.TextBox
        Me.txtAddress = New System.Windows.Forms.TextBox
        Me.txtCompName = New System.Windows.Forms.TextBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.Label6 = New System.Windows.Forms.Label
        Me.Label5 = New System.Windows.Forms.Label
        Me.Label4 = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.Label2 = New System.Windows.Forms.Label
        Me.Label1 = New System.Windows.Forms.Label
        Me.cmdDialog = New System.Windows.Forms.Button
        Me.HeaderStrip1.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        CType(Me.grdCustomers, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.bsCustomer, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.GroupBox2.SuspendLayout()
        Me.SuspendLayout()
        '
        'HeaderStrip1
        '
        Me.HeaderStrip1.AutoSize = False
        Me.HeaderStrip1.Font = New System.Drawing.Font("Tahoma", 12.0!, System.Drawing.FontStyle.Bold)
        Me.HeaderStrip1.ForeColor = System.Drawing.Color.White
        Me.HeaderStrip1.GripStyle = System.Windows.Forms.ToolStripGripStyle.Hidden
        Me.HeaderStrip1.HeaderStyle = PS.Framework.WinForms.HeaderStripStyle.Large
        Me.HeaderStrip1.Items.AddRange(New System.Windows.Forms.ToolStripItem() {Me.ToolStripLabel1})
        Me.HeaderStrip1.Location = New System.Drawing.Point(0, 0)
        Me.HeaderStrip1.Name = "HeaderStrip1"
        Me.HeaderStrip1.Size = New System.Drawing.Size(872, 25)
        Me.HeaderStrip1.TabIndex = 0
        Me.HeaderStrip1.Text = "HeaderStrip1"
        '
        'ToolStripLabel1
        '
        Me.ToolStripLabel1.Name = "ToolStripLabel1"
        Me.ToolStripLabel1.Size = New System.Drawing.Size(95, 22)
        Me.ToolStripLabel1.Text = "Customers"
        '
        'GroupBox1
        '
        Me.GroupBox1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox1.Controls.Add(Me.grdCustomers)
        Me.GroupBox1.Location = New System.Drawing.Point(14, 37)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(844, 303)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Customer Selection"
        '
        'grdCustomers
        '
        Me.grdCustomers.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.grdCustomers.DataSource = Me.bsCustomer
        Me.grdCustomers.EmbeddedNavigator.Name = ""
        Me.grdCustomers.Location = New System.Drawing.Point(6, 19)
        Me.grdCustomers.MainView = Me.GridView1
        Me.grdCustomers.Name = "grdCustomers"
        Me.grdCustomers.Size = New System.Drawing.Size(832, 278)
        Me.grdCustomers.TabIndex = 0
        Me.grdCustomers.ViewCollection.AddRange(New DevExpress.XtraGrid.Views.Base.BaseView() {Me.GridView1})
        '
        'bsCustomer
        '
        Me.bsCustomer.DataSource = GetType(TestFramework.Library.Customer)
        '
        'GridView1
        '
        Me.GridView1.Columns.AddRange(New DevExpress.XtraGrid.Columns.GridColumn() {Me.colCustomerID, Me.colCompanyName, Me.colContactName, Me.colContactTitle, Me.colAddress, Me.colCity, Me.colRegion, Me.colPostalcode, Me.colCountry, Me.colPhone, Me.colFax, Me.colIsDirty, Me.colIsNew, Me.colIsDeleted})
        Me.GridView1.GridControl = Me.grdCustomers
        Me.GridView1.Name = "GridView1"
        '
        'colCustomerID
        '
        Me.colCustomerID.Caption = "CustomerID"
        Me.colCustomerID.FieldName = "CustomerID"
        Me.colCustomerID.Name = "colCustomerID"
        '
        'colCompanyName
        '
        Me.colCompanyName.Caption = "Company Name"
        Me.colCompanyName.FieldName = "CompanyName"
        Me.colCompanyName.Name = "colCompanyName"
        Me.colCompanyName.OptionsColumn.AllowEdit = False
        Me.colCompanyName.Visible = True
        Me.colCompanyName.VisibleIndex = 0
        '
        'colContactName
        '
        Me.colContactName.Caption = "Contact Name"
        Me.colContactName.FieldName = "ContactName"
        Me.colContactName.Name = "colContactName"
        Me.colContactName.OptionsColumn.AllowEdit = False
        Me.colContactName.Visible = True
        Me.colContactName.VisibleIndex = 1
        '
        'colContactTitle
        '
        Me.colContactTitle.Caption = "ContactTitle"
        Me.colContactTitle.FieldName = "Contact Title"
        Me.colContactTitle.Name = "colContactTitle"
        Me.colContactTitle.OptionsColumn.AllowEdit = False
        Me.colContactTitle.Visible = True
        Me.colContactTitle.VisibleIndex = 2
        '
        'colAddress
        '
        Me.colAddress.Caption = "Address"
        Me.colAddress.FieldName = "Address"
        Me.colAddress.Name = "colAddress"
        Me.colAddress.OptionsColumn.AllowEdit = False
        Me.colAddress.Visible = True
        Me.colAddress.VisibleIndex = 3
        '
        'colCity
        '
        Me.colCity.Caption = "City"
        Me.colCity.FieldName = "City"
        Me.colCity.Name = "colCity"
        Me.colCity.OptionsColumn.AllowEdit = False
        Me.colCity.Visible = True
        Me.colCity.VisibleIndex = 4
        '
        'colRegion
        '
        Me.colRegion.Caption = "Region"
        Me.colRegion.FieldName = "Region"
        Me.colRegion.Name = "colRegion"
        Me.colRegion.OptionsColumn.AllowEdit = False
        Me.colRegion.Visible = True
        Me.colRegion.VisibleIndex = 5
        '
        'colPostalcode
        '
        Me.colPostalcode.Caption = "Postalcode"
        Me.colPostalcode.FieldName = "Postalcode"
        Me.colPostalcode.Name = "colPostalcode"
        Me.colPostalcode.OptionsColumn.AllowEdit = False
        Me.colPostalcode.Visible = True
        Me.colPostalcode.VisibleIndex = 6
        '
        'colCountry
        '
        Me.colCountry.Caption = "Country"
        Me.colCountry.FieldName = "Country"
        Me.colCountry.Name = "colCountry"
        Me.colCountry.OptionsColumn.AllowEdit = False
        Me.colCountry.Visible = True
        Me.colCountry.VisibleIndex = 7
        '
        'colPhone
        '
        Me.colPhone.Caption = "Phone"
        Me.colPhone.FieldName = "Phone"
        Me.colPhone.Name = "colPhone"
        '
        'colFax
        '
        Me.colFax.Caption = "Fax"
        Me.colFax.FieldName = "Fax"
        Me.colFax.Name = "colFax"
        '
        'colIsDirty
        '
        Me.colIsDirty.Caption = "IsDirty"
        Me.colIsDirty.FieldName = "IsDirty"
        Me.colIsDirty.Name = "colIsDirty"
        Me.colIsDirty.OptionsColumn.ReadOnly = True
        '
        'colIsNew
        '
        Me.colIsNew.Caption = "IsNew"
        Me.colIsNew.FieldName = "IsNew"
        Me.colIsNew.Name = "colIsNew"
        Me.colIsNew.OptionsColumn.ReadOnly = True
        '
        'colIsDeleted
        '
        Me.colIsDeleted.Caption = "IsDeleted"
        Me.colIsDeleted.FieldName = "IsDeleted"
        Me.colIsDeleted.Name = "colIsDeleted"
        Me.colIsDeleted.OptionsColumn.ReadOnly = True
        '
        'GroupBox2
        '
        Me.GroupBox2.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GroupBox2.Controls.Add(Me.cmdDialog)
        Me.GroupBox2.Controls.Add(Me.cmdDelete)
        Me.GroupBox2.Controls.Add(Me.cmdSave)
        Me.GroupBox2.Controls.Add(Me.cmdClear)
        Me.GroupBox2.Controls.Add(Me.cmdNew)
        Me.GroupBox2.Controls.Add(Me.txtTitle)
        Me.GroupBox2.Controls.Add(Me.txtFax)
        Me.GroupBox2.Controls.Add(Me.txtPhone)
        Me.GroupBox2.Controls.Add(Me.txtName)
        Me.GroupBox2.Controls.Add(Me.txtCountry)
        Me.GroupBox2.Controls.Add(Me.txtPostalCode)
        Me.GroupBox2.Controls.Add(Me.txtRegion)
        Me.GroupBox2.Controls.Add(Me.txtCity)
        Me.GroupBox2.Controls.Add(Me.txtAddress)
        Me.GroupBox2.Controls.Add(Me.txtCompName)
        Me.GroupBox2.Controls.Add(Me.Label10)
        Me.GroupBox2.Controls.Add(Me.Label9)
        Me.GroupBox2.Controls.Add(Me.Label8)
        Me.GroupBox2.Controls.Add(Me.Label7)
        Me.GroupBox2.Controls.Add(Me.Label6)
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Controls.Add(Me.Label4)
        Me.GroupBox2.Controls.Add(Me.Label3)
        Me.GroupBox2.Controls.Add(Me.Label2)
        Me.GroupBox2.Controls.Add(Me.Label1)
        Me.GroupBox2.Location = New System.Drawing.Point(14, 346)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(844, 202)
        Me.GroupBox2.TabIndex = 0
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Customer Input"
        '
        'cmdDelete
        '
        Me.cmdDelete.Location = New System.Drawing.Point(254, 167)
        Me.cmdDelete.Name = "cmdDelete"
        Me.cmdDelete.Size = New System.Drawing.Size(75, 23)
        Me.cmdDelete.TabIndex = 23
        Me.cmdDelete.Text = "&Delete"
        Me.cmdDelete.UseVisualStyleBackColor = True
        '
        'cmdSave
        '
        Me.cmdSave.Location = New System.Drawing.Point(173, 166)
        Me.cmdSave.Name = "cmdSave"
        Me.cmdSave.Size = New System.Drawing.Size(75, 23)
        Me.cmdSave.TabIndex = 22
        Me.cmdSave.Text = "&Save"
        Me.cmdSave.UseVisualStyleBackColor = True
        '
        'cmdClear
        '
        Me.cmdClear.Location = New System.Drawing.Point(92, 166)
        Me.cmdClear.Name = "cmdClear"
        Me.cmdClear.Size = New System.Drawing.Size(75, 23)
        Me.cmdClear.TabIndex = 21
        Me.cmdClear.Text = "&Clear"
        Me.cmdClear.UseVisualStyleBackColor = True
        '
        'cmdNew
        '
        Me.cmdNew.Location = New System.Drawing.Point(11, 167)
        Me.cmdNew.Name = "cmdNew"
        Me.cmdNew.Size = New System.Drawing.Size(75, 23)
        Me.cmdNew.TabIndex = 20
        Me.cmdNew.Text = "&New"
        Me.cmdNew.UseVisualStyleBackColor = True
        '
        'txtTitle
        '
        Me.txtTitle.Location = New System.Drawing.Point(563, 17)
        Me.txtTitle.Name = "txtTitle"
        Me.txtTitle.Size = New System.Drawing.Size(275, 20)
        Me.txtTitle.TabIndex = 19
        '
        'txtFax
        '
        Me.txtFax.Location = New System.Drawing.Point(312, 67)
        Me.txtFax.Name = "txtFax"
        Me.txtFax.Size = New System.Drawing.Size(214, 20)
        Me.txtFax.TabIndex = 18
        '
        'txtPhone
        '
        Me.txtPhone.Location = New System.Drawing.Point(312, 43)
        Me.txtPhone.Name = "txtPhone"
        Me.txtPhone.Size = New System.Drawing.Size(214, 20)
        Me.txtPhone.TabIndex = 17
        '
        'txtName
        '
        Me.txtName.Location = New System.Drawing.Point(312, 17)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(214, 20)
        Me.txtName.TabIndex = 16
        '
        'txtCountry
        '
        Me.txtCountry.Location = New System.Drawing.Point(80, 141)
        Me.txtCountry.Name = "txtCountry"
        Me.txtCountry.Size = New System.Drawing.Size(183, 20)
        Me.txtCountry.TabIndex = 15
        '
        'txtPostalCode
        '
        Me.txtPostalCode.Location = New System.Drawing.Point(80, 114)
        Me.txtPostalCode.Name = "txtPostalCode"
        Me.txtPostalCode.Size = New System.Drawing.Size(183, 20)
        Me.txtPostalCode.TabIndex = 14
        '
        'txtRegion
        '
        Me.txtRegion.Location = New System.Drawing.Point(80, 90)
        Me.txtRegion.Name = "txtRegion"
        Me.txtRegion.Size = New System.Drawing.Size(183, 20)
        Me.txtRegion.TabIndex = 13
        '
        'txtCity
        '
        Me.txtCity.Location = New System.Drawing.Point(80, 67)
        Me.txtCity.Name = "txtCity"
        Me.txtCity.Size = New System.Drawing.Size(183, 20)
        Me.txtCity.TabIndex = 12
        '
        'txtAddress
        '
        Me.txtAddress.Location = New System.Drawing.Point(80, 43)
        Me.txtAddress.Name = "txtAddress"
        Me.txtAddress.Size = New System.Drawing.Size(183, 20)
        Me.txtAddress.TabIndex = 11
        '
        'txtCompName
        '
        Me.txtCompName.Location = New System.Drawing.Point(80, 17)
        Me.txtCompName.Name = "txtCompName"
        Me.txtCompName.Size = New System.Drawing.Size(183, 20)
        Me.txtCompName.TabIndex = 10
        '
        'Label10
        '
        Me.Label10.AutoSize = True
        Me.Label10.Location = New System.Drawing.Point(268, 70)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(27, 13)
        Me.Label10.TabIndex = 9
        Me.Label10.Text = "Fax:"
        '
        'Label9
        '
        Me.Label9.AutoSize = True
        Me.Label9.Location = New System.Drawing.Point(268, 46)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(41, 13)
        Me.Label9.TabIndex = 8
        Me.Label9.Text = "Phone:"
        '
        'Label8
        '
        Me.Label8.AutoSize = True
        Me.Label8.Location = New System.Drawing.Point(6, 117)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(63, 13)
        Me.Label8.TabIndex = 7
        Me.Label8.Text = "Postalcode:"
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.Location = New System.Drawing.Point(8, 141)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(46, 13)
        Me.Label7.TabIndex = 6
        Me.Label7.Text = "Country:"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.Location = New System.Drawing.Point(527, 20)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(30, 13)
        Me.Label6.TabIndex = 5
        Me.Label6.Text = "Title:"
        '
        'Label5
        '
        Me.Label5.AutoSize = True
        Me.Label5.Location = New System.Drawing.Point(6, 70)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(27, 13)
        Me.Label5.TabIndex = 4
        Me.Label5.Text = "City:"
        '
        'Label4
        '
        Me.Label4.AutoSize = True
        Me.Label4.Location = New System.Drawing.Point(268, 20)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(38, 13)
        Me.Label4.TabIndex = 3
        Me.Label4.Text = "Name:"
        '
        'Label3
        '
        Me.Label3.AutoSize = True
        Me.Label3.Location = New System.Drawing.Point(6, 93)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(44, 13)
        Me.Label3.TabIndex = 2
        Me.Label3.Text = "Region:"
        '
        'Label2
        '
        Me.Label2.AutoSize = True
        Me.Label2.Location = New System.Drawing.Point(6, 20)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(68, 13)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "Comp Name:"
        '
        'Label1
        '
        Me.Label1.AutoSize = True
        Me.Label1.Location = New System.Drawing.Point(6, 46)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(48, 13)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Address:"
        '
        'cmdDialog
        '
        Me.cmdDialog.Location = New System.Drawing.Point(335, 166)
        Me.cmdDialog.Name = "cmdDialog"
        Me.cmdDialog.Size = New System.Drawing.Size(75, 23)
        Me.cmdDialog.TabIndex = 24
        Me.cmdDialog.Text = "Open Dialog"
        Me.cmdDialog.UseVisualStyleBackColor = True
        '
        'CustomerSection
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.HeaderStrip1)
        Me.Name = "CustomerSection"
        Me.Size = New System.Drawing.Size(872, 562)
        Me.HeaderStrip1.ResumeLayout(False)
        Me.HeaderStrip1.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        CType(Me.grdCustomers, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.bsCustomer, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.GridView1, System.ComponentModel.ISupportInitialize).EndInit()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.ResumeLayout(False)

    End Sub
    Friend WithEvents HeaderStrip1 As PS.Framework.WinForms.HeaderStrip
    Friend WithEvents ToolStripLabel1 As System.Windows.Forms.ToolStripLabel
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents grdCustomers As DevExpress.XtraGrid.GridControl
    Friend WithEvents GridView1 As DevExpress.XtraGrid.Views.Grid.GridView
    Friend WithEvents bsCustomer As System.Windows.Forms.BindingSource
    Friend WithEvents colCustomerID As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCompanyName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colContactName As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colContactTitle As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colAddress As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCity As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colRegion As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPostalcode As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colCountry As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colPhone As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colFax As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsDirty As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsNew As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents colIsDeleted As DevExpress.XtraGrid.Columns.GridColumn
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents txtTitle As System.Windows.Forms.TextBox
    Friend WithEvents txtFax As System.Windows.Forms.TextBox
    Friend WithEvents txtPhone As System.Windows.Forms.TextBox
    Friend WithEvents txtName As System.Windows.Forms.TextBox
    Friend WithEvents txtCountry As System.Windows.Forms.TextBox
    Friend WithEvents txtPostalCode As System.Windows.Forms.TextBox
    Friend WithEvents txtRegion As System.Windows.Forms.TextBox
    Friend WithEvents txtCity As System.Windows.Forms.TextBox
    Friend WithEvents txtAddress As System.Windows.Forms.TextBox
    Friend WithEvents txtCompName As System.Windows.Forms.TextBox
    Friend WithEvents cmdDelete As System.Windows.Forms.Button
    Friend WithEvents cmdSave As System.Windows.Forms.Button
    Friend WithEvents cmdClear As System.Windows.Forms.Button
    Friend WithEvents cmdNew As System.Windows.Forms.Button
    Friend WithEvents cmdDialog As System.Windows.Forms.Button

End Class
