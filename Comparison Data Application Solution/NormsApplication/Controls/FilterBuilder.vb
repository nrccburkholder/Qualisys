Imports NormsApplicationBusinessObjectsLibrary
Public Class FilterBuilder
    Inherits System.Windows.Forms.UserControl
    Public Event CriteriaChanged()
    Public Event NormCriteriaAdded(ByVal startDate As DateTime, ByVal enddate As DateTime)
    Private mUseProduction As Boolean

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
    Friend WithEvents SectionPanel4 As NRC.WinForms.SectionPanel
    Public WithEvents txtCriteria As System.Windows.Forms.TextBox
    Protected WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents SectionPanel3 As NRC.WinForms.SectionPanel
    Protected WithEvents Label1 As System.Windows.Forms.Label
    Protected WithEvents btnAddNormCriteria As System.Windows.Forms.Button
    Friend WithEvents SectionPanel2 As NRC.WinForms.SectionPanel
    Protected WithEvents lblFilterValues As System.Windows.Forms.Label
    Protected WithEvents lblFilterColumns As System.Windows.Forms.Label
    Protected WithEvents btnAddCustomCriteria As System.Windows.Forms.Button
    Protected WithEvents btnCheckSyntax As System.Windows.Forms.Button
    Friend WithEvents lstNormsList As System.Windows.Forms.ListBox
    Friend WithEvents lstFilterColumns As System.Windows.Forms.ListBox
    Friend WithEvents lstFilterValues As System.Windows.Forms.ListBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.SectionPanel4 = New NRC.WinForms.SectionPanel
        Me.txtCriteria = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.btnCheckSyntax = New System.Windows.Forms.Button
        Me.SectionPanel3 = New NRC.WinForms.SectionPanel
        Me.Label1 = New System.Windows.Forms.Label
        Me.btnAddNormCriteria = New System.Windows.Forms.Button
        Me.lstNormsList = New System.Windows.Forms.ListBox
        Me.SectionPanel2 = New NRC.WinForms.SectionPanel
        Me.lstFilterColumns = New System.Windows.Forms.ListBox
        Me.lblFilterValues = New System.Windows.Forms.Label
        Me.lblFilterColumns = New System.Windows.Forms.Label
        Me.lstFilterValues = New System.Windows.Forms.ListBox
        Me.btnAddCustomCriteria = New System.Windows.Forms.Button
        Me.SectionPanel1.SuspendLayout()
        Me.SectionPanel4.SuspendLayout()
        Me.SectionPanel3.SuspendLayout()
        Me.SectionPanel2.SuspendLayout()
        Me.SuspendLayout()
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Filter Builder"
        Me.SectionPanel1.Controls.Add(Me.SectionPanel4)
        Me.SectionPanel1.Controls.Add(Me.SectionPanel3)
        Me.SectionPanel1.Controls.Add(Me.SectionPanel2)
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(8, 8)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(784, 496)
        Me.SectionPanel1.TabIndex = 32
        '
        'SectionPanel4
        '
        Me.SectionPanel4.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel4.Caption = "Criteria Statement"
        Me.SectionPanel4.Controls.Add(Me.txtCriteria)
        Me.SectionPanel4.Controls.Add(Me.Label5)
        Me.SectionPanel4.Controls.Add(Me.btnCheckSyntax)
        Me.SectionPanel4.DockPadding.All = 1
        Me.SectionPanel4.Location = New System.Drawing.Point(8, 272)
        Me.SectionPanel4.Name = "SectionPanel4"
        Me.SectionPanel4.ShowCaption = True
        Me.SectionPanel4.Size = New System.Drawing.Size(760, 216)
        Me.SectionPanel4.TabIndex = 34
        '
        'txtCriteria
        '
        Me.txtCriteria.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.txtCriteria.Location = New System.Drawing.Point(16, 68)
        Me.txtCriteria.Multiline = True
        Me.txtCriteria.Name = "txtCriteria"
        Me.txtCriteria.ScrollBars = System.Windows.Forms.ScrollBars.Vertical
        Me.txtCriteria.Size = New System.Drawing.Size(728, 128)
        Me.txtCriteria.TabIndex = 9
        Me.txtCriteria.Text = ""
        '
        'Label5
        '
        Me.Label5.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.Label5.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.Location = New System.Drawing.Point(8, 44)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(216, 16)
        Me.Label5.TabIndex = 10
        Me.Label5.Text = "Criteria Statement"
        '
        'btnCheckSyntax
        '
        Me.btnCheckSyntax.Location = New System.Drawing.Point(336, 40)
        Me.btnCheckSyntax.Name = "btnCheckSyntax"
        Me.btnCheckSyntax.Size = New System.Drawing.Size(88, 23)
        Me.btnCheckSyntax.TabIndex = 31
        Me.btnCheckSyntax.Text = "Check Syntax"
        '
        'SectionPanel3
        '
        Me.SectionPanel3.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel3.Caption = "Include Criteria from a Norm Group"
        Me.SectionPanel3.Controls.Add(Me.Label1)
        Me.SectionPanel3.Controls.Add(Me.btnAddNormCriteria)
        Me.SectionPanel3.Controls.Add(Me.lstNormsList)
        Me.SectionPanel3.DockPadding.All = 1
        Me.SectionPanel3.Location = New System.Drawing.Point(416, 32)
        Me.SectionPanel3.Name = "SectionPanel3"
        Me.SectionPanel3.ShowCaption = True
        Me.SectionPanel3.Size = New System.Drawing.Size(352, 232)
        Me.SectionPanel3.TabIndex = 33
        '
        'Label1
        '
        Me.Label1.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.Label1.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(24, 44)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(160, 16)
        Me.Label1.TabIndex = 17
        Me.Label1.Text = "Norms"
        '
        'btnAddNormCriteria
        '
        Me.btnAddNormCriteria.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.btnAddNormCriteria.Location = New System.Drawing.Point(140, 204)
        Me.btnAddNormCriteria.Name = "btnAddNormCriteria"
        Me.btnAddNormCriteria.Size = New System.Drawing.Size(72, 23)
        Me.btnAddNormCriteria.TabIndex = 15
        Me.btnAddNormCriteria.Text = "Add"
        '
        'lstNormsList
        '
        Me.lstNormsList.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.lstNormsList.HorizontalScrollbar = True
        Me.lstNormsList.Location = New System.Drawing.Point(28, 68)
        Me.lstNormsList.Name = "lstNormsList"
        Me.lstNormsList.Size = New System.Drawing.Size(300, 121)
        Me.lstNormsList.TabIndex = 14
        '
        'SectionPanel2
        '
        Me.SectionPanel2.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel2.Caption = "Custom Criteria Builder"
        Me.SectionPanel2.Controls.Add(Me.lstFilterColumns)
        Me.SectionPanel2.Controls.Add(Me.lblFilterValues)
        Me.SectionPanel2.Controls.Add(Me.lblFilterColumns)
        Me.SectionPanel2.Controls.Add(Me.lstFilterValues)
        Me.SectionPanel2.Controls.Add(Me.btnAddCustomCriteria)
        Me.SectionPanel2.DockPadding.All = 1
        Me.SectionPanel2.Location = New System.Drawing.Point(8, 32)
        Me.SectionPanel2.Name = "SectionPanel2"
        Me.SectionPanel2.ShowCaption = True
        Me.SectionPanel2.Size = New System.Drawing.Size(392, 232)
        Me.SectionPanel2.TabIndex = 32
        '
        'lstFilterColumns
        '
        Me.lstFilterColumns.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.lstFilterColumns.HorizontalScrollbar = True
        Me.lstFilterColumns.Location = New System.Drawing.Point(16, 68)
        Me.lstFilterColumns.Name = "lstFilterColumns"
        Me.lstFilterColumns.Size = New System.Drawing.Size(168, 121)
        Me.lstFilterColumns.TabIndex = 6
        '
        'lblFilterValues
        '
        Me.lblFilterValues.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.lblFilterValues.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFilterValues.Location = New System.Drawing.Point(216, 44)
        Me.lblFilterValues.Name = "lblFilterValues"
        Me.lblFilterValues.Size = New System.Drawing.Size(136, 16)
        Me.lblFilterValues.TabIndex = 4
        Me.lblFilterValues.Text = "Values to Filter by"
        '
        'lblFilterColumns
        '
        Me.lblFilterColumns.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.lblFilterColumns.Font = New System.Drawing.Font("Microsoft Sans Serif", 10.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblFilterColumns.Location = New System.Drawing.Point(16, 44)
        Me.lblFilterColumns.Name = "lblFilterColumns"
        Me.lblFilterColumns.Size = New System.Drawing.Size(144, 16)
        Me.lblFilterColumns.TabIndex = 3
        Me.lblFilterColumns.Text = "Columns to filter by"
        '
        'lstFilterValues
        '
        Me.lstFilterValues.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.lstFilterValues.HorizontalScrollbar = True
        Me.lstFilterValues.Location = New System.Drawing.Point(216, 68)
        Me.lstFilterValues.Name = "lstFilterValues"
        Me.lstFilterValues.SelectionMode = System.Windows.Forms.SelectionMode.MultiExtended
        Me.lstFilterValues.Size = New System.Drawing.Size(160, 121)
        Me.lstFilterValues.TabIndex = 7
        '
        'btnAddCustomCriteria
        '
        Me.btnAddCustomCriteria.Anchor = System.Windows.Forms.AnchorStyles.Left
        Me.btnAddCustomCriteria.Location = New System.Drawing.Point(168, 204)
        Me.btnAddCustomCriteria.Name = "btnAddCustomCriteria"
        Me.btnAddCustomCriteria.Size = New System.Drawing.Size(72, 23)
        Me.btnAddCustomCriteria.TabIndex = 11
        Me.btnAddCustomCriteria.Text = "Add"
        '
        'FilterBuilder
        '
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "FilterBuilder"
        Me.Size = New System.Drawing.Size(792, 512)
        Me.SectionPanel1.ResumeLayout(False)
        Me.SectionPanel4.ResumeLayout(False)
        Me.SectionPanel3.ResumeLayout(False)
        Me.SectionPanel2.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Public Property UseProduction() As Boolean
        Get
            Return mUseProduction
        End Get
        Set(ByVal Value As Boolean)
            mUseProduction = Value
        End Set
    End Property

    Private Sub FilterBuilder_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        If Not Me.DesignMode Then
            lstFilterColumns.DataSource = Nothing
            lstFilterColumns.DataSource = FilterColumn.GetallFilterColumns
            lstFilterColumns.DisplayMember = "ColumnDescription"
            RefreshNormsList()
        End If
    End Sub

    Public Sub RefreshNormsList()
        lstNormsList.DataSource = Nothing
        lstNormsList.DataSource = USNormSetting.GetAllNorms(mUseProduction)
        lstNormsList.DisplayMember = "NormLabel"
    End Sub

    Public Function FilterValue() As String
        If txtCriteria.Text <> "" Then
            Return txtCriteria.Text
        Else
            Return ""
        End If
    End Function

    Private Sub lbFilterColumns_SelectedValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lstFilterColumns.SelectedValueChanged
        If Not Me.DesignMode Then
            lstFilterValues.DataSource = Nothing
            If lstFilterColumns.SelectedIndex <> -1 Then lstFilterValues.DataSource = DirectCast(lstFilterColumns.SelectedItem, FilterColumn).DataValues
        End If
    End Sub

    Private Sub btnAddCustomCriteria_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddCustomCriteria.Click
        Dim SelectedValues As String = ""
        Dim tmpSelectedItem As String
        If lstFilterValues.SelectedItems.Count > 0 Then
            For Each tmpSelectedItem In lstFilterValues.SelectedItems
                If DirectCast(lstFilterColumns.SelectedItem, FilterColumn).DataType = "int" Then
                    SelectedValues = SelectedValues & tmpSelectedItem & ","
                ElseIf DirectCast(lstFilterColumns.SelectedItem, FilterColumn).DataType = "bit" Then
                    If tmpSelectedItem = "False" Then
                        SelectedValues = SelectedValues & "0" & ","
                    Else : SelectedValues = SelectedValues & "1" & ","
                    End If
                Else
                    SelectedValues = SelectedValues & "'" & tmpSelectedItem & "',"
                End If
            Next
            SelectedValues = SelectedValues.Substring(0, SelectedValues.Length - 1)
            If SelectedValues.IndexOf(",") > 0 Then
                txtCriteria.Text = txtCriteria.Text & DirectCast(lstFilterColumns.SelectedItem, FilterColumn).ColumnName & " in (" & SelectedValues & ") "
            Else
                txtCriteria.Text = txtCriteria.Text & DirectCast(lstFilterColumns.SelectedItem, FilterColumn).ColumnName & " =" & SelectedValues & " "
            End If
        End If

    End Sub

    Private Sub btnAddNormCriteria_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAddNormCriteria.Click
        If Not lstNormsList.SelectedItem Is Nothing Then
            txtCriteria.Text = txtCriteria.Text & " " & DirectCast(lstNormsList.SelectedItem, USNormSetting).CriteriaStatement
            RaiseEvent NormCriteriaAdded(DirectCast(lstNormsList.SelectedItem, USNormSetting).MinDate, DirectCast(lstNormsList.SelectedItem, USNormSetting).MaxDate)
            txtCriteria.Focus()
        End If
    End Sub

    Private Sub btnCheckSyntax_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCheckSyntax.Click
        DataAccess.CheckFilterSyntax(txtCriteria.Text)
        txtCriteria.Focus()
    End Sub

    Private Sub txtCriteria_TextChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles txtCriteria.TextChanged
        RaiseEvent CriteriaChanged()
    End Sub
End Class
