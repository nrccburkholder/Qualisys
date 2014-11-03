Imports Nrc.QualiSys.Library
Imports System.Collections.ObjectModel

Public Class DispositionSection
    Inherits ContentControlBase

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
    Friend WithEvents MailStepLabel As System.Windows.Forms.Label
    Friend WithEvents PopIdValue As System.Windows.Forms.Label
    Friend WithEvents LithoCode As System.Windows.Forms.Label
    Friend WithEvents MailStep As System.Windows.Forms.Label
    Friend WithEvents PopId As System.Windows.Forms.Label
    Friend WithEvents ScheduledGenerationDate As System.Windows.Forms.Label
    Friend WithEvents ScheduledGenerationDateLabel As System.Windows.Forms.Label
    Friend WithEvents GenerationDateLabel As System.Windows.Forms.Label
    Friend WithEvents PrintDateLabel As System.Windows.Forms.Label
    Friend WithEvents MailDateLabel As System.Windows.Forms.Label
    Friend WithEvents GenerationDate As System.Windows.Forms.Label
    Friend WithEvents PrintDate As System.Windows.Forms.Label
    Friend WithEvents MailDate As System.Windows.Forms.Label
    Friend WithEvents LithoCodeLabel As System.Windows.Forms.Label
    Friend WithEvents MailingPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents DispositionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents PopInfoPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents PopulationInfo As System.Windows.Forms.ListView
    Friend WithEvents DispositionList As System.Windows.Forms.ListBox
    Friend WithEvents CheckBoxImages As System.Windows.Forms.ImageList
    Friend WithEvents ActionPanel As System.Windows.Forms.Panel
    Friend WithEvents QualiSysActionPanel As Nrc.Framework.WinForms.SectionPanel
    Friend WithEvents ActionResultLabel As System.Windows.Forms.Label
    Friend WithEvents SurveyLabel As System.Windows.Forms.Label
    Friend WithEvents SurveyName As System.Windows.Forms.Label
    Friend WithEvents StudyLabel As System.Windows.Forms.Label
    Friend WithEvents StudyName As System.Windows.Forms.Label
    Friend WithEvents ClientLabel As System.Windows.Forms.Label
    Friend WithEvents ClientName As System.Windows.Forms.Label
    Friend WithEvents LanguageLabel As System.Windows.Forms.Label
    Friend WithEvents SurveyLanguage As System.Windows.Forms.Label
    Friend WithEvents DispositionLabel As System.Windows.Forms.Label
    Friend WithEvents ReceiptTypeList As System.Windows.Forms.ComboBox
    Friend WithEvents ReceiptTypeLabel As System.Windows.Forms.Label
    Friend WithEvents ReturnDateLabel As System.Windows.Forms.Label
    Friend WithEvents ReturnDate As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.ComponentModel.ComponentResourceManager = New System.ComponentModel.ComponentResourceManager(GetType(DispositionSection))
        Me.MailingPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ReturnDateLabel = New System.Windows.Forms.Label
        Me.ReturnDate = New System.Windows.Forms.Label
        Me.ClientLabel = New System.Windows.Forms.Label
        Me.ClientName = New System.Windows.Forms.Label
        Me.SurveyLabel = New System.Windows.Forms.Label
        Me.SurveyName = New System.Windows.Forms.Label
        Me.LithoCodeLabel = New System.Windows.Forms.Label
        Me.MailStepLabel = New System.Windows.Forms.Label
        Me.StudyLabel = New System.Windows.Forms.Label
        Me.PopIdValue = New System.Windows.Forms.Label
        Me.LithoCode = New System.Windows.Forms.Label
        Me.MailStep = New System.Windows.Forms.Label
        Me.StudyName = New System.Windows.Forms.Label
        Me.PopId = New System.Windows.Forms.Label
        Me.ScheduledGenerationDate = New System.Windows.Forms.Label
        Me.ScheduledGenerationDateLabel = New System.Windows.Forms.Label
        Me.GenerationDateLabel = New System.Windows.Forms.Label
        Me.PrintDateLabel = New System.Windows.Forms.Label
        Me.MailDateLabel = New System.Windows.Forms.Label
        Me.GenerationDate = New System.Windows.Forms.Label
        Me.PrintDate = New System.Windows.Forms.Label
        Me.MailDate = New System.Windows.Forms.Label
        Me.SurveyLanguage = New System.Windows.Forms.Label
        Me.LanguageLabel = New System.Windows.Forms.Label
        Me.DispositionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ReceiptTypeLabel = New System.Windows.Forms.Label
        Me.ReceiptTypeList = New System.Windows.Forms.ComboBox
        Me.ActionResultLabel = New System.Windows.Forms.Label
        Me.DispositionLabel = New System.Windows.Forms.Label
        Me.DispositionList = New System.Windows.Forms.ListBox
        Me.PopInfoPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.PopulationInfo = New System.Windows.Forms.ListView
        Me.CheckBoxImages = New System.Windows.Forms.ImageList(Me.components)
        Me.QualiSysActionPanel = New Nrc.Framework.WinForms.SectionPanel
        Me.ActionPanel = New System.Windows.Forms.Panel
        Me.MailingPanel.SuspendLayout()
        Me.DispositionPanel.SuspendLayout()
        Me.PopInfoPanel.SuspendLayout()
        Me.QualiSysActionPanel.SuspendLayout()
        Me.SuspendLayout()
        '
        'MailingPanel
        '
        Me.MailingPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.MailingPanel.Caption = "Mailing Details"
        Me.MailingPanel.Controls.Add(Me.ReturnDateLabel)
        Me.MailingPanel.Controls.Add(Me.ReturnDate)
        Me.MailingPanel.Controls.Add(Me.ClientLabel)
        Me.MailingPanel.Controls.Add(Me.ClientName)
        Me.MailingPanel.Controls.Add(Me.SurveyLabel)
        Me.MailingPanel.Controls.Add(Me.SurveyName)
        Me.MailingPanel.Controls.Add(Me.LithoCodeLabel)
        Me.MailingPanel.Controls.Add(Me.MailStepLabel)
        Me.MailingPanel.Controls.Add(Me.StudyLabel)
        Me.MailingPanel.Controls.Add(Me.PopIdValue)
        Me.MailingPanel.Controls.Add(Me.LithoCode)
        Me.MailingPanel.Controls.Add(Me.MailStep)
        Me.MailingPanel.Controls.Add(Me.StudyName)
        Me.MailingPanel.Controls.Add(Me.PopId)
        Me.MailingPanel.Controls.Add(Me.ScheduledGenerationDate)
        Me.MailingPanel.Controls.Add(Me.ScheduledGenerationDateLabel)
        Me.MailingPanel.Controls.Add(Me.GenerationDateLabel)
        Me.MailingPanel.Controls.Add(Me.PrintDateLabel)
        Me.MailingPanel.Controls.Add(Me.MailDateLabel)
        Me.MailingPanel.Controls.Add(Me.GenerationDate)
        Me.MailingPanel.Controls.Add(Me.PrintDate)
        Me.MailingPanel.Controls.Add(Me.MailDate)
        Me.MailingPanel.Controls.Add(Me.SurveyLanguage)
        Me.MailingPanel.Controls.Add(Me.LanguageLabel)
        Me.MailingPanel.Dock = System.Windows.Forms.DockStyle.Top
        Me.MailingPanel.Location = New System.Drawing.Point(0, 0)
        Me.MailingPanel.Name = "MailingPanel"
        Me.MailingPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.MailingPanel.ShowCaption = True
        Me.MailingPanel.Size = New System.Drawing.Size(744, 184)
        Me.MailingPanel.TabIndex = 0
        '
        'ReturnDateLabel
        '
        Me.ReturnDateLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ReturnDateLabel.Location = New System.Drawing.Point(301, 152)
        Me.ReturnDateLabel.Name = "ReturnDateLabel"
        Me.ReturnDateLabel.Size = New System.Drawing.Size(176, 23)
        Me.ReturnDateLabel.TabIndex = 10
        Me.ReturnDateLabel.Text = "Return Date:"
        Me.ReturnDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ReturnDate
        '
        Me.ReturnDate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ReturnDate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ReturnDate.Location = New System.Drawing.Point(485, 152)
        Me.ReturnDate.Name = "ReturnDate"
        Me.ReturnDate.Size = New System.Drawing.Size(251, 23)
        Me.ReturnDate.TabIndex = 9
        Me.ReturnDate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ClientLabel
        '
        Me.ClientLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ClientLabel.Location = New System.Drawing.Point(8, 32)
        Me.ClientLabel.Name = "ClientLabel"
        Me.ClientLabel.Size = New System.Drawing.Size(72, 23)
        Me.ClientLabel.TabIndex = 7
        Me.ClientLabel.Text = "Client:"
        Me.ClientLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ClientName
        '
        Me.ClientName.AutoEllipsis = True
        Me.ClientName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ClientName.Location = New System.Drawing.Point(88, 32)
        Me.ClientName.Name = "ClientName"
        Me.ClientName.Size = New System.Drawing.Size(207, 23)
        Me.ClientName.TabIndex = 6
        Me.ClientName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyLabel
        '
        Me.SurveyLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SurveyLabel.Location = New System.Drawing.Point(8, 80)
        Me.SurveyLabel.Name = "SurveyLabel"
        Me.SurveyLabel.Size = New System.Drawing.Size(72, 23)
        Me.SurveyLabel.TabIndex = 4
        Me.SurveyLabel.Text = "Survey:"
        Me.SurveyLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyName
        '
        Me.SurveyName.AutoEllipsis = True
        Me.SurveyName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SurveyName.Location = New System.Drawing.Point(88, 80)
        Me.SurveyName.Name = "SurveyName"
        Me.SurveyName.Size = New System.Drawing.Size(207, 23)
        Me.SurveyName.TabIndex = 3
        Me.SurveyName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LithoCodeLabel
        '
        Me.LithoCodeLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LithoCodeLabel.Location = New System.Drawing.Point(8, 104)
        Me.LithoCodeLabel.Name = "LithoCodeLabel"
        Me.LithoCodeLabel.Size = New System.Drawing.Size(72, 23)
        Me.LithoCodeLabel.TabIndex = 1
        Me.LithoCodeLabel.Text = "Litho Code:"
        Me.LithoCodeLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MailStepLabel
        '
        Me.MailStepLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MailStepLabel.Location = New System.Drawing.Point(301, 32)
        Me.MailStepLabel.Name = "MailStepLabel"
        Me.MailStepLabel.Size = New System.Drawing.Size(176, 23)
        Me.MailStepLabel.TabIndex = 1
        Me.MailStepLabel.Text = "Mailing Step:"
        Me.MailStepLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'StudyLabel
        '
        Me.StudyLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.StudyLabel.Location = New System.Drawing.Point(8, 56)
        Me.StudyLabel.Name = "StudyLabel"
        Me.StudyLabel.Size = New System.Drawing.Size(72, 23)
        Me.StudyLabel.TabIndex = 1
        Me.StudyLabel.Text = "Study:"
        Me.StudyLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PopIdValue
        '
        Me.PopIdValue.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PopIdValue.Location = New System.Drawing.Point(8, 128)
        Me.PopIdValue.Name = "PopIdValue"
        Me.PopIdValue.Size = New System.Drawing.Size(72, 23)
        Me.PopIdValue.TabIndex = 1
        Me.PopIdValue.Text = "Pop ID:"
        Me.PopIdValue.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LithoCode
        '
        Me.LithoCode.AutoEllipsis = True
        Me.LithoCode.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LithoCode.Location = New System.Drawing.Point(88, 104)
        Me.LithoCode.Name = "LithoCode"
        Me.LithoCode.Size = New System.Drawing.Size(207, 23)
        Me.LithoCode.TabIndex = 1
        Me.LithoCode.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MailStep
        '
        Me.MailStep.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MailStep.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MailStep.Location = New System.Drawing.Point(485, 32)
        Me.MailStep.Name = "MailStep"
        Me.MailStep.Size = New System.Drawing.Size(251, 23)
        Me.MailStep.TabIndex = 1
        Me.MailStep.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'StudyName
        '
        Me.StudyName.AutoEllipsis = True
        Me.StudyName.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.StudyName.Location = New System.Drawing.Point(88, 56)
        Me.StudyName.Name = "StudyName"
        Me.StudyName.Size = New System.Drawing.Size(207, 23)
        Me.StudyName.TabIndex = 1
        Me.StudyName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PopId
        '
        Me.PopId.AutoEllipsis = True
        Me.PopId.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PopId.Location = New System.Drawing.Point(88, 128)
        Me.PopId.Name = "PopId"
        Me.PopId.Size = New System.Drawing.Size(207, 23)
        Me.PopId.TabIndex = 1
        Me.PopId.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ScheduledGenerationDate
        '
        Me.ScheduledGenerationDate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ScheduledGenerationDate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ScheduledGenerationDate.Location = New System.Drawing.Point(485, 56)
        Me.ScheduledGenerationDate.Name = "ScheduledGenerationDate"
        Me.ScheduledGenerationDate.Size = New System.Drawing.Size(251, 23)
        Me.ScheduledGenerationDate.TabIndex = 1
        Me.ScheduledGenerationDate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ScheduledGenerationDateLabel
        '
        Me.ScheduledGenerationDateLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.ScheduledGenerationDateLabel.Location = New System.Drawing.Point(301, 56)
        Me.ScheduledGenerationDateLabel.Name = "ScheduledGenerationDateLabel"
        Me.ScheduledGenerationDateLabel.Size = New System.Drawing.Size(176, 23)
        Me.ScheduledGenerationDateLabel.TabIndex = 1
        Me.ScheduledGenerationDateLabel.Text = "Scheduled Generation Date:"
        Me.ScheduledGenerationDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'GenerationDateLabel
        '
        Me.GenerationDateLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GenerationDateLabel.Location = New System.Drawing.Point(301, 80)
        Me.GenerationDateLabel.Name = "GenerationDateLabel"
        Me.GenerationDateLabel.Size = New System.Drawing.Size(176, 23)
        Me.GenerationDateLabel.TabIndex = 1
        Me.GenerationDateLabel.Text = "Generation Date:"
        Me.GenerationDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PrintDateLabel
        '
        Me.PrintDateLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PrintDateLabel.Location = New System.Drawing.Point(301, 104)
        Me.PrintDateLabel.Name = "PrintDateLabel"
        Me.PrintDateLabel.Size = New System.Drawing.Size(176, 23)
        Me.PrintDateLabel.TabIndex = 1
        Me.PrintDateLabel.Text = "Print Date:"
        Me.PrintDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MailDateLabel
        '
        Me.MailDateLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MailDateLabel.Location = New System.Drawing.Point(301, 128)
        Me.MailDateLabel.Name = "MailDateLabel"
        Me.MailDateLabel.Size = New System.Drawing.Size(176, 23)
        Me.MailDateLabel.TabIndex = 1
        Me.MailDateLabel.Text = "Mail Date:"
        Me.MailDateLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'GenerationDate
        '
        Me.GenerationDate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.GenerationDate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GenerationDate.Location = New System.Drawing.Point(485, 80)
        Me.GenerationDate.Name = "GenerationDate"
        Me.GenerationDate.Size = New System.Drawing.Size(251, 23)
        Me.GenerationDate.TabIndex = 1
        Me.GenerationDate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'PrintDate
        '
        Me.PrintDate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PrintDate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.PrintDate.Location = New System.Drawing.Point(485, 104)
        Me.PrintDate.Name = "PrintDate"
        Me.PrintDate.Size = New System.Drawing.Size(251, 23)
        Me.PrintDate.TabIndex = 1
        Me.PrintDate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'MailDate
        '
        Me.MailDate.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.MailDate.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.MailDate.Location = New System.Drawing.Point(485, 128)
        Me.MailDate.Name = "MailDate"
        Me.MailDate.Size = New System.Drawing.Size(251, 23)
        Me.MailDate.TabIndex = 1
        Me.MailDate.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'SurveyLanguage
        '
        Me.SurveyLanguage.AutoEllipsis = True
        Me.SurveyLanguage.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.SurveyLanguage.Location = New System.Drawing.Point(88, 152)
        Me.SurveyLanguage.Name = "SurveyLanguage"
        Me.SurveyLanguage.Size = New System.Drawing.Size(207, 23)
        Me.SurveyLanguage.TabIndex = 1
        Me.SurveyLanguage.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'LanguageLabel
        '
        Me.LanguageLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LanguageLabel.Location = New System.Drawing.Point(8, 152)
        Me.LanguageLabel.Name = "LanguageLabel"
        Me.LanguageLabel.Size = New System.Drawing.Size(72, 23)
        Me.LanguageLabel.TabIndex = 1
        Me.LanguageLabel.Text = "Language:"
        Me.LanguageLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'DispositionPanel
        '
        Me.DispositionPanel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.DispositionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.DispositionPanel.Caption = "Respondent Disposition"
        Me.DispositionPanel.Controls.Add(Me.ReceiptTypeLabel)
        Me.DispositionPanel.Controls.Add(Me.ReceiptTypeList)
        Me.DispositionPanel.Controls.Add(Me.ActionResultLabel)
        Me.DispositionPanel.Controls.Add(Me.DispositionLabel)
        Me.DispositionPanel.Controls.Add(Me.DispositionList)
        Me.DispositionPanel.Location = New System.Drawing.Point(0, 328)
        Me.DispositionPanel.Name = "DispositionPanel"
        Me.DispositionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.DispositionPanel.ShowCaption = True
        Me.DispositionPanel.Size = New System.Drawing.Size(320, 368)
        Me.DispositionPanel.TabIndex = 1
        '
        'ReceiptTypeLabel
        '
        Me.ReceiptTypeLabel.Location = New System.Drawing.Point(8, 72)
        Me.ReceiptTypeLabel.Name = "ReceiptTypeLabel"
        Me.ReceiptTypeLabel.Size = New System.Drawing.Size(80, 23)
        Me.ReceiptTypeLabel.TabIndex = 8
        Me.ReceiptTypeLabel.Text = "Receipt Type:"
        Me.ReceiptTypeLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'ReceiptTypeList
        '
        Me.ReceiptTypeList.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.ReceiptTypeList.Location = New System.Drawing.Point(96, 72)
        Me.ReceiptTypeList.Name = "ReceiptTypeList"
        Me.ReceiptTypeList.Size = New System.Drawing.Size(216, 21)
        Me.ReceiptTypeList.TabIndex = 7
        '
        'ActionResultLabel
        '
        Me.ActionResultLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.ActionResultLabel.ForeColor = System.Drawing.Color.Blue
        Me.ActionResultLabel.Location = New System.Drawing.Point(8, 104)
        Me.ActionResultLabel.Name = "ActionResultLabel"
        Me.ActionResultLabel.Size = New System.Drawing.Size(304, 24)
        Me.ActionResultLabel.TabIndex = 5
        '
        'DispositionLabel
        '
        Me.DispositionLabel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DispositionLabel.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.DispositionLabel.Location = New System.Drawing.Point(8, 32)
        Me.DispositionLabel.Name = "DispositionLabel"
        Me.DispositionLabel.Size = New System.Drawing.Size(304, 40)
        Me.DispositionLabel.TabIndex = 3
        Me.DispositionLabel.Text = "Please select the appropriate disposition for this respondent."
        Me.DispositionLabel.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'DispositionList
        '
        Me.DispositionList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.DispositionList.BackColor = System.Drawing.SystemColors.Control
        Me.DispositionList.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.DispositionList.Cursor = System.Windows.Forms.Cursors.Default
        Me.DispositionList.DrawMode = System.Windows.Forms.DrawMode.OwnerDrawVariable
        Me.DispositionList.Font = New System.Drawing.Font("Tahoma", 8.25!)
        Me.DispositionList.Location = New System.Drawing.Point(16, 136)
        Me.DispositionList.Name = "DispositionList"
        Me.DispositionList.Size = New System.Drawing.Size(296, 224)
        Me.DispositionList.TabIndex = 1
        '
        'PopInfoPanel
        '
        Me.PopInfoPanel.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PopInfoPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.PopInfoPanel.Caption = "Population Information"
        Me.PopInfoPanel.Controls.Add(Me.PopulationInfo)
        Me.PopInfoPanel.Location = New System.Drawing.Point(0, 192)
        Me.PopInfoPanel.Name = "PopInfoPanel"
        Me.PopInfoPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.PopInfoPanel.ShowCaption = True
        Me.PopInfoPanel.Size = New System.Drawing.Size(744, 128)
        Me.PopInfoPanel.TabIndex = 2
        '
        'PopulationInfo
        '
        Me.PopulationInfo.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.PopulationInfo.GridLines = True
        Me.PopulationInfo.Location = New System.Drawing.Point(8, 40)
        Me.PopulationInfo.Name = "PopulationInfo"
        Me.PopulationInfo.Size = New System.Drawing.Size(728, 80)
        Me.PopulationInfo.TabIndex = 1
        Me.PopulationInfo.UseCompatibleStateImageBehavior = False
        Me.PopulationInfo.View = System.Windows.Forms.View.Details
        '
        'CheckBoxImages
        '
        Me.CheckBoxImages.ImageStream = CType(resources.GetObject("CheckBoxImages.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.CheckBoxImages.TransparentColor = System.Drawing.Color.Transparent
        Me.CheckBoxImages.Images.SetKeyName(0, "")
        Me.CheckBoxImages.Images.SetKeyName(1, "")
        '
        'QualiSysActionPanel
        '
        Me.QualiSysActionPanel.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.QualiSysActionPanel.BorderColor = System.Drawing.Color.FromArgb(CType(CType(0, Byte), Integer), CType(CType(45, Byte), Integer), CType(CType(150, Byte), Integer))
        Me.QualiSysActionPanel.Caption = "QualiSys Action"
        Me.QualiSysActionPanel.Controls.Add(Me.ActionPanel)
        Me.QualiSysActionPanel.Location = New System.Drawing.Point(328, 328)
        Me.QualiSysActionPanel.Name = "QualiSysActionPanel"
        Me.QualiSysActionPanel.Padding = New System.Windows.Forms.Padding(1)
        Me.QualiSysActionPanel.ShowCaption = True
        Me.QualiSysActionPanel.Size = New System.Drawing.Size(416, 368)
        Me.QualiSysActionPanel.TabIndex = 3
        '
        'ActionPanel
        '
        Me.ActionPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.ActionPanel.Location = New System.Drawing.Point(1, 27)
        Me.ActionPanel.Name = "ActionPanel"
        Me.ActionPanel.Size = New System.Drawing.Size(414, 340)
        Me.ActionPanel.TabIndex = 1
        '
        'DispositionSection
        '
        Me.Controls.Add(Me.QualiSysActionPanel)
        Me.Controls.Add(Me.MailingPanel)
        Me.Controls.Add(Me.DispositionPanel)
        Me.Controls.Add(Me.PopInfoPanel)
        Me.Font = New System.Drawing.Font("Tahoma", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Name = "DispositionSection"
        Me.Size = New System.Drawing.Size(744, 696)
        Me.MailingPanel.ResumeLayout(False)
        Me.DispositionPanel.ResumeLayout(False)
        Me.PopInfoPanel.ResumeLayout(False)
        Me.QualiSysActionPanel.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

    Private WithEvents mDispoNav As DispositionNavigator
    Private mMailing As Mailing
    Private mActionPanel As ActionPanel

    Public Overrides Sub RegisterNavControl(ByVal navControl As System.Windows.Forms.Control)
        If Not TypeOf navControl Is DispositionNavigator Then
            Throw New ArgumentException("A control of type 'DispositionNavigator' was expected", "navControl")
        Else
            mDispoNav = DirectCast(navControl, DispositionNavigator)
        End If
    End Sub

    Private Sub DispositionSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles MyBase.Load
        LoadReceiptTypeList()
    End Sub

    Private Sub mDispoNav_MailingSelected(ByVal sender As Object, ByVal e As DispositionNavigator.MailingSelectedEventArgs) Handles mDispoNav.MailingSelected
        mMailing = e.Mailing
        LoadMailingInfo(e.Mailing)
        LoadPopInfo(e.Mailing)
        LoadDispositionList(e.Mailing)
    End Sub
    ''' <summary>
    '''     ''' 
    ''' </summary>
    ''' <param name="mail"></param>
    ''' <remarks>SK 09-09-2008 Added check for 99999 language id when displaying surveylanguage text on disposition section</remarks>
    Private Sub LoadMailingInfo(ByVal mail As Mailing)
        Dim surv As Survey = Survey.Get(mail.SurveyId)
        Dim stdy As Study = surv.Study
        Dim clnt As Client = stdy.Client

        Me.ClientName.Text = clnt.DisplayLabel
        Me.StudyName.Text = stdy.DisplayLabel
        Me.SurveyName.Text = surv.DisplayLabel

        Me.LithoCode.Text = mail.LithoCode

        'SK 09/09/2008 - Added check for 99999 as well
        If mail.LanguageId > 0 And Not mail.LanguageId = 99999 Then
            Me.SurveyLanguage.Text = Language.GetLanguage(mail.LanguageId).DisplayLabel
        Else
            Me.SurveyLanguage.Text = "Unknown"
        End If
        Me.MailStep.Text = mail.MethodologyStepName
        Me.PopId.Text = mail.PopId.ToString
        Me.ScheduledGenerationDate.Text = mail.ScheduledGenerationDate.ToString
        If mail.IsGenerated Then
            Me.GenerationDate.Text = mail.GenerationDate.ToString
        Else
            Me.GenerationDate.Text = ""
        End If
        If mail.IsPrinted Then
            Me.PrintDate.Text = mail.PrintDate.ToString
        Else
            Me.PrintDate.Text = ""
        End If
        If mail.IsMailed Then
            Me.MailDate.Text = mail.MailDate.ToString
        Else
            Me.MailDate.Text = ""
        End If
        Me.ReturnDate.Text = mail.ReturnLabel
    End Sub

    Private Function FindTable(ByVal tables As Collection(Of StudyTable), ByVal tableName As String) As StudyTable
        For Each table As StudyTable In tables
            If table.Name.Equals(tableName, StringComparison.CurrentCultureIgnoreCase) Then
                Return table
            End If
        Next
        Return Nothing
    End Function
    Private Sub LoadPopInfo(ByVal mail As Mailing)
        Dim tables As Collection(Of StudyTable) = StudyTable.GetAllStudyTables(mail.StudyId)
        Dim p As StudyTable = FindTable(tables, "POPULATION")
        Dim tbl As DataTable = p.Query("WHERE POP_ID = " & mail.PopId.ToString, 1)

        Me.PopulationInfo.Items.Clear()
        Me.PopulationInfo.Columns.Clear()

        For Each col As DataColumn In tbl.Columns
            Me.PopulationInfo.Columns.Add(col.ColumnName, 75, HorizontalAlignment.Left)
        Next

        For Each row As DataRow In tbl.Rows
            Dim items(tbl.Columns.Count - 1) As String
            For i As Integer = 0 To tbl.Columns.Count - 1
                items(i) = row(i).ToString()
            Next
            Me.PopulationInfo.Items.Add(New ListViewItem(items))
        Next
        If tbl.Rows.Count > 1 Then
            Me.PopulationInfo.Items(0).Selected = True
        End If
        Me.PopulationInfo.AutoResizeColumns(ColumnHeaderAutoResizeStyle.HeaderSize)
        'Me.AutoSizeListViewColumns(Me.PopulationInfo)
    End Sub

    'Private Sub AutoSizeListViewColumns(ByVal list As ListView)
    '    Dim g As Graphics = list.CreateGraphics
    '    For Each col As ColumnHeader In list.Columns
    '        Dim stringSize As SizeF = g.MeasureString(col.Text, list.Font)
    '        col.Width = CInt(stringSize.Width) + 20
    '    Next
    '    g.Dispose()
    'End Sub

    Private Sub LoadReceiptTypeList()
        Me.ReceiptTypeList.DataSource = Nothing
        Me.ReceiptTypeList.Items.Clear()
        Me.ReceiptTypeList.DataSource = ReceiptType.GetAll
        Me.ReceiptTypeList.DisplayMember = "Name"
        Me.ReceiptTypeList.ValueMember = "Id"
    End Sub

    Private Sub LoadDispositionList(ByVal mail As Mailing)
        Me.ActionResultLabel.Text = ""
        Me.DispositionList.Enabled = True
        Me.UnloadActionPanel()

        Me.DispositionList.Items.Clear()
        Me.DispositionList.DisplayMember = "Name"

        Dim dispositions As QDispositionCollection = QDisposition.GetDispositionsBySurvey(mail.SurveyId)
        For Each dispo As QDisposition In dispositions
            If Not dispo.Action = DispositionAction.ContactTeam Then
                'Do not show "Please Send me another survey" 
                'and "Please Send me another survey in a different language" checkboxes 
                'on "Respondent Disposition" panel  if mail is expired. (By Arman Mnatsakanyan)
                If mail.IsExpired Then
                    If Not ( _
                    dispo.Action = DispositionAction.Regenerate Or dispo.Action = DispositionAction.RegenerateNewLang _
                    ) Then
                        Me.DispositionList.Items.Add(dispo)
                    End If
                Else
                    Me.DispositionList.Items.Add(dispo)
                End If
            End If
        Next
    End Sub

#Region " Owner Draw Disposition List Code "
    Private Sub DispositionList_DrawItem(ByVal sender As Object, ByVal e As System.Windows.Forms.DrawItemEventArgs) Handles DispositionList.DrawItem
        If e.Index < 0 Then
            e.DrawBackground()
            e.DrawFocusRectangle()
            Exit Sub
        End If

        Dim list As ListBox = DirectCast(sender, ListBox)
        Dim backBrush As New SolidBrush(list.BackColor)
        Dim itemFont As Font = list.Font
        Dim itemColor As Color = list.ForeColor
        Dim itemBrush As SolidBrush
        Dim itemText As String = ""

        e.Graphics.FillRectangle(backBrush, e.Bounds)
        backBrush.Dispose()

        If (e.State And DrawItemState.Selected) = DrawItemState.Selected Then
            e.Graphics.DrawImage(CheckBoxImages.Images(0), e.Bounds.Left, e.Bounds.Top)
        Else
            e.Graphics.DrawImage(CheckBoxImages.Images(1), e.Bounds.Left, e.Bounds.Top)
        End If

        If (e.State And DrawItemState.Disabled) = DrawItemState.Disabled OrElse (e.State And DrawItemState.Grayed) = DrawItemState.Grayed Then
            itemColor = Color.Gray
        End If

        itemText = list.GetItemText(DispositionList.Items(e.Index))

        Dim itemRect As RectangleF = RectangleF.op_Implicit(e.Bounds)
        itemRect.X += 18
        itemRect.Width -= 18

        'Draw the item...
        Dim format As New StringFormat
        format.LineAlignment = StringAlignment.Center
        format.Alignment = StringAlignment.Near
        itemBrush = New SolidBrush(itemColor)
        e.Graphics.DrawString(itemText, DispositionList.Font, itemBrush, itemRect, format)
        itemBrush.Dispose()
    End Sub

    Private Sub DispositionList_MeasureItem(ByVal sender As Object, ByVal e As System.Windows.Forms.MeasureItemEventArgs) Handles DispositionList.MeasureItem
        e.ItemHeight = 18

        Dim list As ListBox = DirectCast(sender, ListBox)
        Dim itemFont As Font = list.Font
        Dim itemText As String
        Try
            itemText = list.GetItemText(list.Items(e.Index))
        Catch ex As Exception
            itemText = ""
        End Try

        'dim format as New StringFormat(StringFormatFlags.NoClip
        Dim textArea As SizeF = e.Graphics.MeasureString(itemText, itemFont, list.Width - 18)

        If textArea.Height > e.ItemHeight Then
            e.ItemHeight = CType(textArea.Height, Integer)
        End If

    End Sub
#End Region

    Private Sub DispositionList_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DispositionList.SelectedIndexChanged
        If DispositionList.SelectedIndex > -1 Then
            Dim dispo As QDisposition = DirectCast(DispositionList.SelectedItem, QDisposition)
            LoadActionPanel(dispo.Action)
        End If
    End Sub

    Private Sub UnloadActionPanel()
        Me.ActionPanel.Controls.Clear()
        If Not mActionPanel Is Nothing Then
            RemoveHandler mActionPanel.ActionTaken, AddressOf ActionPanel_ActionTaken
        End If

    End Sub
    Private Sub LoadActionPanel(ByVal action As DispositionAction)
        UnloadActionPanel()
        Dim pnl As ActionPanel

        Select Case action
            Case DispositionAction.CancelMailings
                pnl = New CancelMailingsPanel
            Case DispositionAction.ChangeOfAddress
                pnl = New ChangeAddressPanel
            Case DispositionAction.Regenerate
                pnl = New RegenerateSurveyPanel(False)
            Case DispositionAction.RegenerateNewLang
                pnl = New RegenerateSurveyPanel(True)
            Case DispositionAction.Tocl
                pnl = New TakeOffCallListPanel
            Case Else
                pnl = Nothing
        End Select

        If pnl Is Nothing Then
            Throw New ArgumentOutOfRangeException("action")
        End If

        pnl.LoadPanel(mMailing, DirectCast(DispositionList.SelectedItem, QDisposition), DirectCast(ReceiptTypeList.SelectedItem, ReceiptType))
        pnl.Dock = DockStyle.Fill
        Me.ActionPanel.Controls.Add(pnl)
        Me.ActionPanel.Enabled = True
        mActionPanel = pnl
        AddHandler mActionPanel.ActionTaken, AddressOf ActionPanel_ActionTaken
    End Sub

    Private Sub ActionPanel_ActionTaken(ByVal sender As Object, ByVal e As ActionPanel.ActionTakenEventArgs)
        Me.ActionResultLabel.Text = e.Message
        Me.DispositionList.Enabled = False
        Me.ActionPanel.Enabled = False
    End Sub

End Class