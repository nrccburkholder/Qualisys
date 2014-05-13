Public Class Administration
    Inherits System.Windows.Forms.UserControl
    Public Event btnPressed(ByVal SelectedButton As AdministrationButtons)

    Public Enum AdministrationButtons
        btnCreateDimension = 0
        btnEquivalentQuestions = 1
        btnSurveyTypes = 2
        btnCountries = 3
        btnEditDimension = 4
        btnSurveyQuestions = 5
        btnChangeCountry = 6
    End Enum


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
    Friend WithEvents Panel1 As System.Windows.Forms.Panel
    Friend WithEvents btnCountries As System.Windows.Forms.Button
    Friend WithEvents btnSurveyTypes As System.Windows.Forms.Button
    Friend WithEvents btnEquivalentQuestions As System.Windows.Forms.Button
    Friend WithEvents btnCreateDimension As System.Windows.Forms.Button
    Friend WithEvents btnEditDimension As System.Windows.Forms.Button
    Friend WithEvents btnSurveyQuestions As System.Windows.Forms.Button
    Friend WithEvents btnChangeCountry As System.Windows.Forms.Button
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Panel1 = New System.Windows.Forms.Panel
        Me.btnChangeCountry = New System.Windows.Forms.Button
        Me.btnSurveyQuestions = New System.Windows.Forms.Button
        Me.btnEditDimension = New System.Windows.Forms.Button
        Me.btnCountries = New System.Windows.Forms.Button
        Me.btnSurveyTypes = New System.Windows.Forms.Button
        Me.btnEquivalentQuestions = New System.Windows.Forms.Button
        Me.btnCreateDimension = New System.Windows.Forms.Button
        Me.Panel1.SuspendLayout()
        Me.SuspendLayout()
        '
        'Panel1
        '
        Me.Panel1.BackColor = System.Drawing.SystemColors.Control
        Me.Panel1.Controls.Add(Me.btnChangeCountry)
        Me.Panel1.Controls.Add(Me.btnSurveyQuestions)
        Me.Panel1.Controls.Add(Me.btnEditDimension)
        Me.Panel1.Controls.Add(Me.btnCountries)
        Me.Panel1.Controls.Add(Me.btnSurveyTypes)
        Me.Panel1.Controls.Add(Me.btnEquivalentQuestions)
        Me.Panel1.Controls.Add(Me.btnCreateDimension)
        Me.Panel1.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel1.Location = New System.Drawing.Point(0, 0)
        Me.Panel1.Name = "Panel1"
        Me.Panel1.Size = New System.Drawing.Size(152, 408)
        Me.Panel1.TabIndex = 0
        '
        'btnChangeCountry
        '
        Me.btnChangeCountry.Location = New System.Drawing.Point(8, 333)
        Me.btnChangeCountry.Name = "btnChangeCountry"
        Me.btnChangeCountry.Size = New System.Drawing.Size(136, 23)
        Me.btnChangeCountry.TabIndex = 7
        Me.btnChangeCountry.Text = "Change Country"
        '
        'btnSurveyQuestions
        '
        Me.btnSurveyQuestions.Enabled = False
        Me.btnSurveyQuestions.Location = New System.Drawing.Point(8, 286)
        Me.btnSurveyQuestions.Name = "btnSurveyQuestions"
        Me.btnSurveyQuestions.Size = New System.Drawing.Size(136, 23)
        Me.btnSurveyQuestions.TabIndex = 6
        Me.btnSurveyQuestions.Text = "Survey Questions"
        '
        'btnEditDimension
        '
        Me.btnEditDimension.Enabled = False
        Me.btnEditDimension.Location = New System.Drawing.Point(8, 51)
        Me.btnEditDimension.Name = "btnEditDimension"
        Me.btnEditDimension.Size = New System.Drawing.Size(136, 23)
        Me.btnEditDimension.TabIndex = 5
        Me.btnEditDimension.Text = "Edit Dimension"
        '
        'btnCountries
        '
        Me.btnCountries.Location = New System.Drawing.Point(8, 239)
        Me.btnCountries.Name = "btnCountries"
        Me.btnCountries.Size = New System.Drawing.Size(136, 23)
        Me.btnCountries.TabIndex = 4
        Me.btnCountries.Text = "Countries"
        '
        'btnSurveyTypes
        '
        Me.btnSurveyTypes.Location = New System.Drawing.Point(8, 192)
        Me.btnSurveyTypes.Name = "btnSurveyTypes"
        Me.btnSurveyTypes.Size = New System.Drawing.Size(136, 23)
        Me.btnSurveyTypes.TabIndex = 3
        Me.btnSurveyTypes.Text = "Survey Types"
        '
        'btnEquivalentQuestions
        '
        Me.btnEquivalentQuestions.Location = New System.Drawing.Point(8, 145)
        Me.btnEquivalentQuestions.Name = "btnEquivalentQuestions"
        Me.btnEquivalentQuestions.Size = New System.Drawing.Size(136, 23)
        Me.btnEquivalentQuestions.TabIndex = 2
        Me.btnEquivalentQuestions.Text = "Equivalent Questions"
        '
        'btnCreateDimension
        '
        Me.btnCreateDimension.Enabled = False
        Me.btnCreateDimension.Location = New System.Drawing.Point(8, 98)
        Me.btnCreateDimension.Name = "btnCreateDimension"
        Me.btnCreateDimension.Size = New System.Drawing.Size(136, 23)
        Me.btnCreateDimension.TabIndex = 1
        Me.btnCreateDimension.Text = "Create Dimension"
        '
        'Administration
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.Panel1)
        Me.Name = "Administration"
        Me.Size = New System.Drawing.Size(152, 408)
        Me.Panel1.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private Sub btnEditDimension_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEditDimension.Click
        RaiseEvent btnPressed(AdministrationButtons.btnEditDimension)
    End Sub


    Private Sub btnCreateDimension_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCreateDimension.Click
        RaiseEvent btnPressed(AdministrationButtons.btnCreateDimension)
    End Sub

    Private Sub btnEquivalentQuestions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnEquivalentQuestions.Click
        RaiseEvent btnPressed(AdministrationButtons.btnEquivalentQuestions)
    End Sub

    Private Sub btnSurveyTypes_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSurveyTypes.Click
        RaiseEvent btnPressed(AdministrationButtons.btnSurveyTypes)
    End Sub

    Private Sub btnCountries_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCountries.Click
        RaiseEvent btnPressed(AdministrationButtons.btnCountries)
    End Sub

    Private Sub btnSurveyQuestions_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSurveyQuestions.Click
        RaiseEvent btnPressed(AdministrationButtons.btnSurveyQuestions)
    End Sub

    Private Sub btnChangeCountry_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnChangeCountry.Click
        RaiseEvent btnPressed(AdministrationButtons.btnChangeCountry)

    End Sub
End Class
