Imports NormsApplicationBusinessObjectsLibrary
Public Class CountriesEditor
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
    Friend WithEvents scpCountrysEditor As NRC.WinForms.SectionPanel
    Friend WithEvents ctmCountrys As System.Windows.Forms.ContextMenu
    Friend WithEvents scpNew As NRC.WinForms.SectionPanel
    Friend WithEvents btnAdd As System.Windows.Forms.Button
    Friend WithEvents txtName As System.Windows.Forms.TextBox
    Friend WithEvents mnuRename As System.Windows.Forms.MenuItem
    Friend WithEvents mnuDelete As System.Windows.Forms.MenuItem
    Friend WithEvents CountriesList1 As NormsApplication.CountriesList
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.scpCountrysEditor = New NRC.WinForms.SectionPanel
        Me.CountriesList1 = New NormsApplication.CountriesList
        Me.ctmCountrys = New System.Windows.Forms.ContextMenu
        Me.mnuRename = New System.Windows.Forms.MenuItem
        Me.mnuDelete = New System.Windows.Forms.MenuItem
        Me.scpNew = New NRC.WinForms.SectionPanel
        Me.btnAdd = New System.Windows.Forms.Button
        Me.txtName = New System.Windows.Forms.TextBox
        Me.scpCountrysEditor.SuspendLayout()
        Me.scpNew.SuspendLayout()
        Me.SuspendLayout()
        '
        'scpCountrysEditor
        '
        Me.scpCountrysEditor.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.scpCountrysEditor.Caption = "Countries Editor"
        Me.scpCountrysEditor.Controls.Add(Me.CountriesList1)
        Me.scpCountrysEditor.Controls.Add(Me.scpNew)
        Me.scpCountrysEditor.Dock = System.Windows.Forms.DockStyle.Fill
        Me.scpCountrysEditor.DockPadding.All = 1
        Me.scpCountrysEditor.Location = New System.Drawing.Point(0, 0)
        Me.scpCountrysEditor.Name = "scpCountrysEditor"
        Me.scpCountrysEditor.ShowCaption = True
        Me.scpCountrysEditor.Size = New System.Drawing.Size(456, 504)
        Me.scpCountrysEditor.TabIndex = 0
        '
        'CountriesList1
        '
        Me.CountriesList1.ContextMenu = Me.ctmCountrys
        Me.CountriesList1.Location = New System.Drawing.Point(32, 48)
        Me.CountriesList1.Name = "CountriesList1"
        Me.CountriesList1.SelectedCountry = Nothing
        Me.CountriesList1.Size = New System.Drawing.Size(376, 224)
        Me.CountriesList1.TabIndex = 4
        '
        'ctmCountrys
        '
        Me.ctmCountrys.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuRename, Me.mnuDelete})
        '
        'mnuRename
        '
        Me.mnuRename.Index = 0
        Me.mnuRename.Text = "Rename"
        '
        'mnuDelete
        '
        Me.mnuDelete.Index = 1
        Me.mnuDelete.Text = "Delete"
        '
        'scpNew
        '
        Me.scpNew.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.scpNew.Caption = "New Country"
        Me.scpNew.Controls.Add(Me.btnAdd)
        Me.scpNew.Controls.Add(Me.txtName)
        Me.scpNew.DockPadding.All = 1
        Me.scpNew.Location = New System.Drawing.Point(34, 296)
        Me.scpNew.Name = "scpNew"
        Me.scpNew.ShowCaption = True
        Me.scpNew.Size = New System.Drawing.Size(372, 152)
        Me.scpNew.TabIndex = 2
        '
        'btnAdd
        '
        Me.btnAdd.Location = New System.Drawing.Point(149, 104)
        Me.btnAdd.Name = "btnAdd"
        Me.btnAdd.TabIndex = 2
        Me.btnAdd.Text = "Add"
        '
        'txtName
        '
        Me.txtName.Location = New System.Drawing.Point(16, 56)
        Me.txtName.Name = "txtName"
        Me.txtName.Size = New System.Drawing.Size(340, 20)
        Me.txtName.TabIndex = 1
        Me.txtName.Text = ""
        '
        'CountriesEditor
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.scpCountrysEditor)
        Me.Name = "CountriesEditor"
        Me.Size = New System.Drawing.Size(456, 504)
        Me.scpCountrysEditor.ResumeLayout(False)
        Me.scpNew.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub refreshList()
        CountriesList1.PopulateCountries()
    End Sub
    Private Sub btnAdd_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnAdd.Click
        If txtName.Text = "" Then
            MessageBox.Show("You must Specify a Name.", "Missing Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf NameInUse(txtName.Text) Then
            MessageBox.Show("A country already exists with that name.  Please specify a different name.", "Duplicate Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            'Create New Country
            Country.CreateCountry(txtName.Text)
            refreshList()
        End If
    End Sub

    Private Sub mnuDelete_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuDelete.Click
        If MessageBox.Show("Are you sure you want to delete this survey type?", "Delete", MessageBoxButtons.YesNo, MessageBoxIcon.Warning) = DialogResult.Yes Then
            Country.DeleteCountry(DirectCast(CountriesList1.lstCountries.SelectedItem(), Country).ID)
            refreshList()
        End If
    End Sub

    Private Function NameInUse(ByVal Name As String) As Boolean
        For Each cty As Country In CountriesList1.lstCountries.Items
            If cty.Name = Name Then Return True
        Next
        Return False
    End Function

    Private Sub mnuRename_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuRename.Click
        If txtName.Text = "" Then
            MessageBox.Show("You must Specify a Name.", "Missing Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf NameInUse(txtName.Text) Then
            MessageBox.Show("A country already exists with that name.  Please specify a different name.", "Duplicate Name", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            'Create New Country
            Country.UpdateCountry(DirectCast(CountriesList1.lstCountries.SelectedItem(), Country).ID, txtName.Text)
            refreshList()
        End If
    End Sub

    Private Sub CountrysEditor_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        CountriesList1.PopulateCountries()
    End Sub
End Class
