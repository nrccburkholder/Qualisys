Imports NormsApplicationBusinessObjectsLibrary
Public Class ChangeSurveyCountry
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
    Friend WithEvents cmbClient As System.Windows.Forms.ComboBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents lsvSurveys As System.Windows.Forms.ListView
    Friend WithEvents ctmSurveys As System.Windows.Forms.ContextMenu
    Friend WithEvents chdSurveyID As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdSurveyName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdCountry As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents SectionPanel1 As NRC.WinForms.SectionPanel
    Friend WithEvents mnuChangeCountry As System.Windows.Forms.MenuItem
    Friend WithEvents btnChange As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.cmbClient = New System.Windows.Forms.ComboBox
        Me.Label1 = New System.Windows.Forms.Label
        Me.lsvSurveys = New System.Windows.Forms.ListView
        Me.chdSurveyID = New System.Windows.Forms.ColumnHeader
        Me.chdSurveyName = New System.Windows.Forms.ColumnHeader
        Me.chdCountry = New System.Windows.Forms.ColumnHeader
        Me.ctmSurveys = New System.Windows.Forms.ContextMenu
        Me.mnuChangeCountry = New System.Windows.Forms.MenuItem
        Me.Label2 = New System.Windows.Forms.Label
        Me.SectionPanel1 = New NRC.WinForms.SectionPanel
        Me.btnChange = New System.Windows.Forms.Button
        Me.SectionPanel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'cmbClient
        '
        Me.cmbClient.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbClient.Location = New System.Drawing.Point(28, 68)
        Me.cmbClient.Name = "cmbClient"
        Me.cmbClient.Size = New System.Drawing.Size(408, 21)
        Me.cmbClient.TabIndex = 0
        '
        'Label1
        '
        Me.Label1.Location = New System.Drawing.Point(28, 44)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(408, 23)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Select Client"
        '
        'lsvSurveys
        '
        Me.lsvSurveys.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdSurveyID, Me.chdSurveyName, Me.chdCountry})
        Me.lsvSurveys.ContextMenu = Me.ctmSurveys
        Me.lsvSurveys.FullRowSelect = True
        Me.lsvSurveys.Location = New System.Drawing.Point(28, 140)
        Me.lsvSurveys.Name = "lsvSurveys"
        Me.lsvSurveys.Size = New System.Drawing.Size(416, 412)
        Me.lsvSurveys.TabIndex = 2
        Me.lsvSurveys.View = System.Windows.Forms.View.Details
        '
        'chdSurveyID
        '
        Me.chdSurveyID.Text = "Survey ID"
        Me.chdSurveyID.Width = 66
        '
        'chdSurveyName
        '
        Me.chdSurveyName.Text = "Survey Name"
        Me.chdSurveyName.Width = 200
        '
        'chdCountry
        '
        Me.chdCountry.Text = "Country"
        Me.chdCountry.Width = 146
        '
        'ctmSurveys
        '
        Me.ctmSurveys.MenuItems.AddRange(New System.Windows.Forms.MenuItem() {Me.mnuChangeCountry})
        '
        'mnuChangeCountry
        '
        Me.mnuChangeCountry.Index = 0
        Me.mnuChangeCountry.Text = "Change Country"
        '
        'Label2
        '
        Me.Label2.Location = New System.Drawing.Point(30, 116)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(400, 23)
        Me.Label2.TabIndex = 3
        Me.Label2.Text = "Surveys"
        '
        'SectionPanel1
        '
        Me.SectionPanel1.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.SectionPanel1.Caption = "Survey Country"
        Me.SectionPanel1.Controls.Add(Me.btnChange)
        Me.SectionPanel1.Controls.Add(Me.Label1)
        Me.SectionPanel1.Controls.Add(Me.cmbClient)
        Me.SectionPanel1.Controls.Add(Me.lsvSurveys)
        Me.SectionPanel1.Controls.Add(Me.Label2)
        Me.SectionPanel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.SectionPanel1.DockPadding.All = 1
        Me.SectionPanel1.Location = New System.Drawing.Point(0, 0)
        Me.SectionPanel1.Name = "SectionPanel1"
        Me.SectionPanel1.ShowCaption = True
        Me.SectionPanel1.Size = New System.Drawing.Size(472, 632)
        Me.SectionPanel1.TabIndex = 4
        '
        'btnChange
        '
        Me.btnChange.Location = New System.Drawing.Point(184, 576)
        Me.btnChange.Name = "btnChange"
        Me.btnChange.Size = New System.Drawing.Size(96, 23)
        Me.btnChange.TabIndex = 5
        Me.btnChange.Text = "Change Country"
        '
        'ChangeSurveyCountry
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.SectionPanel1)
        Me.Name = "ChangeSurveyCountry"
        Me.Size = New System.Drawing.Size(472, 632)
        Me.SectionPanel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub ChangeSurveyCountry_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        cmbClient.DataSource = QPClient.getAllClients
        cmbClient.DisplayMember = "Name"
    End Sub

    Private Sub cmbClient_SelectedValueChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles cmbClient.SelectedValueChanged
        PopulateSurveys()
    End Sub

    Private Sub PopulateSurveys()
        Dim SurveyList As SurveysCollection = Survey.getClientSurveys(DirectCast(cmbClient.SelectedItem, QPClient).ID)
        lsvSurveys.Items.Clear()
        For Each srvy As Survey In SurveyList
            Dim tmpListView As New Windows.Forms.ListViewItem(srvy.ID)
            tmpListView.Tag = srvy
            tmpListView.SubItems.Add(srvy.Name)
            tmpListView.SubItems.Add(srvy.CountryOfOrigin.Name)
            lsvSurveys.Items.Add(tmpListView)
        Next
    End Sub

    Private Sub mnuChangeCountry_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles mnuChangeCountry.Click
        ChangeCountry()
    End Sub

    Private Sub ChangeCountry()
        If lsvSurveys.SelectedItems.Count > 0 Then
            Dim input As New InputDialog(InputDialog.InputType.ListBox)
            Dim CountryList As CountryCollection = Country.getAllCountries

            input.Title = "Change Country"
            input.Prompt = "Please select the country that each selected survey belongs to."
            input.MultiSelect = False

            input.ListBoxDataSource(CountryList, "Name")

            If input.ShowDialog = DialogResult.OK Then
                For Each srvy As ListViewItem In lsvSurveys.SelectedItems
                    DirectCast(srvy.Tag, Survey).CountryOfOrigin = DirectCast(input.Input, Country)
                Next
            End If
            PopulateSurveys()
        Else
            MessageBox.Show("You must choose 1 or more surveys.", "No Surveys Selected", MessageBoxButtons.OK, MessageBoxIcon.Warning)
        End If
    End Sub

    Private Sub btnChange_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnChange.Click
        ChangeCountry()
    End Sub
End Class
