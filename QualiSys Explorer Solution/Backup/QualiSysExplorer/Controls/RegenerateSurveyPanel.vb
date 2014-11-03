Imports Nrc.QualiSys.Library

Public Class RegenerateSurveyPanel
    Inherits ActionPanel

#Region " Windows Form Designer generated code "

    Public Sub New(ByVal allowChangeLanguage As Boolean)
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call
        Me.mAllowChangeLanguage = allowChangeLanguage
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
    Friend WithEvents RegenerateButton As System.Windows.Forms.Button
    Friend WithEvents LanguageList As System.Windows.Forms.ComboBox
    Friend WithEvents LanguageGroup As System.Windows.Forms.GroupBox
    Friend WithEvents ActionLabel As System.Windows.Forms.Label
    Friend WithEvents LanguageLabel As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.ActionLabel = New System.Windows.Forms.Label
        Me.RegenerateButton = New System.Windows.Forms.Button
        Me.LanguageList = New System.Windows.Forms.ComboBox
        Me.LanguageLabel = New System.Windows.Forms.Label
        Me.LanguageGroup = New System.Windows.Forms.GroupBox
        Me.LanguageGroup.SuspendLayout()
        Me.SuspendLayout()
        '
        'ActionLabel
        '
        Me.ActionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ActionLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold)
        Me.ActionLabel.Location = New System.Drawing.Point(4, 8)
        Me.ActionLabel.Name = "ActionLabel"
        Me.ActionLabel.Size = New System.Drawing.Size(484, 40)
        Me.ActionLabel.TabIndex = 2
        Me.ActionLabel.Text = "A survey will be regenerated and sent to the respondent."
        '
        'RegenerateButton
        '
        Me.RegenerateButton.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.RegenerateButton.FlatStyle = System.Windows.Forms.FlatStyle.System
        Me.RegenerateButton.Location = New System.Drawing.Point(408, 304)
        Me.RegenerateButton.Name = "RegenerateButton"
        Me.RegenerateButton.TabIndex = 3
        Me.RegenerateButton.Text = "Regenerate"
        '
        'LanguageList
        '
        Me.LanguageList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.LanguageList.Location = New System.Drawing.Point(168, 32)
        Me.LanguageList.Name = "LanguageList"
        Me.LanguageList.Size = New System.Drawing.Size(160, 21)
        Me.LanguageList.TabIndex = 4
        '
        'LanguageLabel
        '
        Me.LanguageLabel.Location = New System.Drawing.Point(16, 32)
        Me.LanguageLabel.Name = "LanguageLabel"
        Me.LanguageLabel.Size = New System.Drawing.Size(144, 23)
        Me.LanguageLabel.TabIndex = 5
        Me.LanguageLabel.Text = "Select a survey language"
        Me.LanguageLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LanguageGroup
        '
        Me.LanguageGroup.Controls.Add(Me.LanguageLabel)
        Me.LanguageGroup.Controls.Add(Me.LanguageList)
        Me.LanguageGroup.Location = New System.Drawing.Point(8, 48)
        Me.LanguageGroup.Name = "LanguageGroup"
        Me.LanguageGroup.Size = New System.Drawing.Size(344, 80)
        Me.LanguageGroup.TabIndex = 6
        Me.LanguageGroup.TabStop = False
        Me.LanguageGroup.Text = "Language Selection"
        '
        'RegenerateSurveyPanel
        '
        Me.Controls.Add(Me.LanguageGroup)
        Me.Controls.Add(Me.RegenerateButton)
        Me.Controls.Add(Me.ActionLabel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "RegenerateSurveyPanel"
        Me.Size = New System.Drawing.Size(496, 336)
        Me.LanguageGroup.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private mAllowChangeLanguage As Boolean

    Public Overrides Sub LoadPanel(ByVal mail As Mailing, ByVal dispo As QDisposition, ByVal receiptMethod As ReceiptType)
        MyBase.LoadPanel(mail, dispo, receiptMethod)
        Me.LanguageGroup.Visible = mAllowChangeLanguage
        PopulateLanguageList()
        Me.Enabled = True
    End Sub

    Private Sub PopulateLanguageList()
        Me.LanguageList.Items.Clear()

        If mAllowChangeLanguage Then
            Me.LanguageList.DataSource = Mailing.GetAvailableLanguages
            Me.LanguageList.DisplayMember = "DisplayLabel"
            Me.LanguageList.ValueMember = "Id"
        End If
    End Sub

    Private Sub RegenerateButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RegenerateButton.Click
        If mAllowChangeLanguage Then
            Dim lang As Language = DirectCast(Me.LanguageList.SelectedItem, Language)
            Mailing.RegenerateMailing(Me.Disposition.Id, Me.ReceiptType.Id, CurrentUser.UserName, lang.Id)
            MyBase.OnActionTaken(New ActionTakenEventArgs("The survey will be regenerated in " & lang.Name))
        Else
            Mailing.RegenerateMailing(Me.Disposition.Id, Me.ReceiptType.Id, CurrentUser.UserName)
            MyBase.OnActionTaken(New ActionTakenEventArgs("The survey will be regenerated."))
        End If

    End Sub

End Class
