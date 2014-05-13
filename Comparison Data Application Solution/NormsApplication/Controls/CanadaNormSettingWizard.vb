Option Explicit On 
Option Strict On

Imports System.Text
Imports NormsApplicationBusinessObjectsLibrary
Imports NRC.WinForms

Public Class CanadaNormSettingWizard
    Inherits System.Windows.Forms.UserControl

#Region " Private Fields"

    Private Shared CANCEL_BUTTON As String = "Cancel"
    Private Shared BACK_BUTTON As String = "< Back"
    Private Shared NEXT_BUTTON As String = "Next >"
    Private Shared FINISH_BUTTON As String = "Finish"

    Private Shared CAPTION As String = "Canadian Norm Setup Wizard"

    Public Enum WizardStep
        Start = 0
        ChooseTask = 1
        NormNames = 2
        NormSettings = 3
        Clients = 4
        Surveys = 5
        Criteria = 6
        Rollups = 7
        Approval = 8
        Finish = 9
    End Enum

    Private Enum TaskPageListField
        NormName = 0
        NormID = 1
        NormDescription = 2
    End Enum

    Private Enum ClientPageListField
        ClientName = 0
        ClientID = 1
    End Enum

    Private Enum SurveyPageListField
        ClientName = 0
        ClientID = 1
        StudyName = 2
        StudyID = 3
        SurveyName = 4
        SurveyID = 5
    End Enum

    Private Enum RollupPageListField
        RollupName = 0
        RollupID = 1
        RollupDescription = 2
    End Enum

    Private mController As New CanadaNormSettingController
    Private WithEvents mWizard As MapWizard
    Private mWizardData(WizardStep.Finish) As MapWizardData
    Private mTriggeredByProgram As Boolean = False

#Region " Controls in <Approve> page"
    Private mApprovePageCheckItems() As Label
    Private mApprovePageSummaryButtons() As Button
    Private mApprovePageGroups() As GroupBox
    Private mApprovePageModifierNames() As Label
    Private mApprovePageModifyDates() As Label
    Private mApprovePageApproveStatus() As Label
    Private mApprovePageApproverNameLabels() As Label
    Private mApprovePageApproverNames() As Label
    Private mApprovePageApproveDateLabels() As Label
    Private mApprovePageApproveDates() As Label
    Private mApprovePageStatusImage() As PictureBox
#End Region

#End Region

#Region " Windows Form Designer generated code "

    Public Sub New()
        MyBase.New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Add any initialization after the InitializeComponent() call

        'Move tab upward to hide the tabulars
        Me.tabWizard.Top -= 24
        Me.tabWizard.Height += 24
        Me.tabWizard.SendToBack()

        'Init controls in approve page
        InitApprovePageControls()

        'Set wizard step info
        InitWizardStepInfo()
        mWizard = New MapWizard(mWizardData)

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
    Friend WithEvents tabWizard As System.Windows.Forms.TabControl
    Friend WithEvents btnCancel As System.Windows.Forms.Button
    Friend WithEvents btnBack As System.Windows.Forms.Button
    Friend WithEvents btnNext As System.Windows.Forms.Button
    Friend WithEvents btnFinish As System.Windows.Forms.Button
    Friend WithEvents lblStepStart As System.Windows.Forms.Label
    Friend WithEvents lblStepRollup As System.Windows.Forms.Label
    Friend WithEvents lblStepApproval As System.Windows.Forms.Label
    Friend WithEvents PictureBox1 As System.Windows.Forms.PictureBox
    Friend WithEvents Label2 As System.Windows.Forms.Label
    Friend WithEvents lblStepFinish As System.Windows.Forms.Label
    Friend WithEvents lblStepSurvey As System.Windows.Forms.Label
    Friend WithEvents lblStepSetting As System.Windows.Forms.Label
    Friend WithEvents lblStepName As System.Windows.Forms.Label
    Friend WithEvents lblStepTask As System.Windows.Forms.Label
    Friend WithEvents pnlStepFinish As System.Windows.Forms.Panel
    Friend WithEvents pnlStepApproval As System.Windows.Forms.Panel
    Friend WithEvents pnlStepRollup As System.Windows.Forms.Panel
    Friend WithEvents pnlStepSurvey As System.Windows.Forms.Panel
    Friend WithEvents pnlStepSetting As System.Windows.Forms.Panel
    Friend WithEvents pnlStepName As System.Windows.Forms.Panel
    Friend WithEvents pnlStepTask As System.Windows.Forms.Panel
    Friend WithEvents pnlStepStart As System.Windows.Forms.Panel
    Friend WithEvents tpgStepStart As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepTask As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepName As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepSetting As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepSurvey As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepRollup As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepApproval As System.Windows.Forms.TabPage
    Friend WithEvents tpgStepFinish As System.Windows.Forms.TabPage
    Friend WithEvents pnlBackPanel As NRC.WinForms.SectionPanel
    Friend WithEvents optTaskPageUpdateNorm As System.Windows.Forms.RadioButton
    Friend WithEvents optTaskPageNewNorm As System.Windows.Forms.RadioButton
    Friend WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Friend WithEvents Label3 As System.Windows.Forms.Label
    Friend WithEvents lblNamePageNormID As System.Windows.Forms.Label
    Friend WithEvents Label4 As System.Windows.Forms.Label
    Friend WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Friend WithEvents Label5 As System.Windows.Forms.Label
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents Label10 As System.Windows.Forms.Label
    Friend WithEvents Label12 As System.Windows.Forms.Label
    Friend WithEvents Label13 As System.Windows.Forms.Label
    Friend WithEvents Label14 As System.Windows.Forms.Label
    Friend WithEvents Label16 As System.Windows.Forms.Label
    Friend WithEvents txtNamePageAvgCompDescription As System.Windows.Forms.TextBox
    Friend WithEvents lblNamePageAvgCompID As System.Windows.Forms.Label
    Friend WithEvents txtNamePageAvgCompLabel As System.Windows.Forms.TextBox
    Friend WithEvents txtNamePageHpCompLabel As System.Windows.Forms.TextBox
    Friend WithEvents txtNamePageHpCompDescription As System.Windows.Forms.TextBox
    Friend WithEvents lblNamePageHpCompID As System.Windows.Forms.Label
    Friend WithEvents txtNamePageLpCompLabel As System.Windows.Forms.TextBox
    Friend WithEvents txtNamePageLpCompDescription As System.Windows.Forms.TextBox
    Friend WithEvents lblNamePageLpCompID As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Friend WithEvents Label11 As System.Windows.Forms.Label
    Friend WithEvents chkNamePageAvgComp As System.Windows.Forms.CheckBox
    Friend WithEvents chkNamePageHpComp As System.Windows.Forms.CheckBox
    Friend WithEvents chkNamePageLpComp As System.Windows.Forms.CheckBox
    Friend WithEvents Label15 As System.Windows.Forms.Label
    Friend WithEvents Label17 As System.Windows.Forms.Label
    Friend WithEvents Label18 As System.Windows.Forms.Label
    Friend WithEvents Label19 As System.Windows.Forms.Label
    Friend WithEvents Label20 As System.Windows.Forms.Label
    Friend WithEvents Label21 As System.Windows.Forms.Label
    Friend WithEvents Label22 As System.Windows.Forms.Label
    Friend WithEvents Label23 As System.Windows.Forms.Label
    Friend WithEvents Label24 As System.Windows.Forms.Label
    Friend WithEvents Label25 As System.Windows.Forms.Label
    Friend WithEvents Label26 As System.Windows.Forms.Label
    Friend WithEvents Label27 As System.Windows.Forms.Label
    Friend WithEvents Label28 As System.Windows.Forms.Label
    Friend WithEvents Label29 As System.Windows.Forms.Label
    Friend WithEvents Label30 As System.Windows.Forms.Label
    Friend WithEvents chkSettingPageWeight As System.Windows.Forms.CheckBox
    Friend WithEvents nudSettingPageHpSurvey As System.Windows.Forms.NumericUpDown
    Friend WithEvents nudSettingPageLpSurvey As System.Windows.Forms.NumericUpDown
    Friend WithEvents dtpSettingPageReportDateBegin As System.Windows.Forms.DateTimePicker
    Friend WithEvents dtpSettingPageReportDateEnd As System.Windows.Forms.DateTimePicker
    Friend WithEvents dtpSettingPageReturnDateMax As System.Windows.Forms.DateTimePicker
    Friend WithEvents txtNamePageNormLabel As System.Windows.Forms.TextBox
    Friend WithEvents txtNamePageNormDescription As System.Windows.Forms.TextBox
    Friend WithEvents Label31 As System.Windows.Forms.Label
    Friend WithEvents Label32 As System.Windows.Forms.Label
    Friend WithEvents Label33 As System.Windows.Forms.Label
    Friend WithEvents lvwSurveyPageList As NRC.WinForms.NRCListView
    Friend WithEvents lnkSurveyPageDeselectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkSurveyPageSelectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkSurveyPageDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkSurveyPageSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents chdSurveyPageClientName As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdSurveyPageClientID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdSurveyPageStudyName As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdSurveyPageStudyID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdSurveyPageSurveyName As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdSurveyPageSurveyID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents tpgStepClient As System.Windows.Forms.TabPage
    Friend WithEvents lblStepClient As System.Windows.Forms.Label
    Friend WithEvents pnlStepClient As System.Windows.Forms.Panel
    Friend WithEvents Label34 As System.Windows.Forms.Label
    Friend WithEvents btnClientPageSelectAll As System.Windows.Forms.Button
    Friend WithEvents btnClientPageSelect As System.Windows.Forms.Button
    Friend WithEvents btnClientPageUnselect As System.Windows.Forms.Button
    Friend WithEvents btnClientPageUnselectAll As System.Windows.Forms.Button
    Friend WithEvents pnlClientPageBack As System.Windows.Forms.Panel
    Friend WithEvents pnlClientPageBackLeft As System.Windows.Forms.Panel
    Friend WithEvents Label35 As System.Windows.Forms.Label
    Friend WithEvents lvwClientPageUnusedClient As NRC.WinForms.NRCListView
    Friend WithEvents ColumnHeader2 As System.Windows.Forms.ColumnHeader
    Friend WithEvents NrcColumnHeader2 As NRC.WinForms.NRCColumnHeader
    Friend WithEvents splClientPageSplitter As System.Windows.Forms.Splitter
    Friend WithEvents pnlClientPageBackRight As System.Windows.Forms.Panel
    Friend WithEvents pnlClientPageSplitter As System.Windows.Forms.Panel
    Friend WithEvents Panel3 As System.Windows.Forms.Panel
    Friend WithEvents Label36 As System.Windows.Forms.Label
    Friend WithEvents ColumnHeader3 As System.Windows.Forms.ColumnHeader
    Friend WithEvents NrcColumnHeader3 As NRC.WinForms.NRCColumnHeader
    Friend WithEvents lvwClientPageUsedClient As NRC.WinForms.NRCListView
    Friend WithEvents pnlClientPageButtons As System.Windows.Forms.Panel
    Friend WithEvents lblSurveyPageTotalCount As System.Windows.Forms.Label
    Friend WithEvents lblSurveyPageSelectCount As System.Windows.Forms.Label
    Friend WithEvents Label37 As System.Windows.Forms.Label
    Friend WithEvents Label38 As System.Windows.Forms.Label
    Friend WithEvents Label40 As System.Windows.Forms.Label
    Friend WithEvents lvwRollupPageList As NRC.WinForms.NRCListView
    Friend WithEvents chdRollupPageName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdRollupPageID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents lnkRollupPageDeselectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkRollupPageSelectHighlight As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkRollupPageDeselectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkRollupPageSelectAll As System.Windows.Forms.LinkLabel
    Friend WithEvents lblRollupPageTotalCount As System.Windows.Forms.Label
    Friend WithEvents lblRollupPageSelectCount As System.Windows.Forms.Label
    Friend WithEvents chdRollupPageDescription As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label39 As System.Windows.Forms.Label
    Friend WithEvents Label42 As System.Windows.Forms.Label
    Friend WithEvents Label43 As System.Windows.Forms.Label
    Friend WithEvents Label48 As System.Windows.Forms.Label
    Friend WithEvents Label49 As System.Windows.Forms.Label
    Friend WithEvents Label41 As System.Windows.Forms.Label
    Friend WithEvents Label46 As System.Windows.Forms.Label
    Friend WithEvents grpApprovePageGroup2 As System.Windows.Forms.GroupBox
    Friend WithEvents grpApprovePageGroup1 As System.Windows.Forms.GroupBox
    Friend WithEvents grpApprovePageGroup0 As System.Windows.Forms.GroupBox
    Friend WithEvents lblApprovePageModifierName2 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageModifierName1 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageModifierName0 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproverName2 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageModifyDate2 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveDate2 As System.Windows.Forms.Label
    Friend WithEvents btnApprovePageShowSummary2 As System.Windows.Forms.Button
    Friend WithEvents lblApprovePageApproverName1 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageModifyDate1 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveDate1 As System.Windows.Forms.Label
    Friend WithEvents btnApprovePageShowSummary1 As System.Windows.Forms.Button
    Friend WithEvents lblApprovePageModifyDate0 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproverName0 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveDate0 As System.Windows.Forms.Label
    Friend WithEvents btnApprovePageShowSummary0 As System.Windows.Forms.Button
    Friend WithEvents lblApprovePageCheckItem0 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageCheckItem1 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageCheckItem2 As System.Windows.Forms.Label
    Friend WithEvents Label55 As System.Windows.Forms.Label
    Friend WithEvents Label56 As System.Windows.Forms.Label
    Friend WithEvents Label57 As System.Windows.Forms.Label
    Friend WithEvents Label59 As System.Windows.Forms.Label
    Friend WithEvents Label60 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproverNameLabel2 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveDateLabel2 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproverNameLabel1 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveDateLabel1 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproverNameLabel0 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveDateLabel0 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveStatus2 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveStatus1 As System.Windows.Forms.Label
    Friend WithEvents lblApprovePageApproveStatus0 As System.Windows.Forms.Label
    Friend WithEvents lvwTaskPageNorm As NRC.WinForms.NRCListView
    Friend WithEvents chdTaskPageName As System.Windows.Forms.ColumnHeader
    Friend WithEvents chdTaskPageNormID As NRC.WinForms.NRCColumnHeader
    Friend WithEvents chdTaskPageDescription As System.Windows.Forms.ColumnHeader
    Friend WithEvents Label45 As System.Windows.Forms.Label
    Friend WithEvents PictureBox3 As System.Windows.Forms.PictureBox
    Friend WithEvents pnlLeft As System.Windows.Forms.Panel
    Friend WithEvents pnlBottom As System.Windows.Forms.Panel
    Friend WithEvents Splitter1 As System.Windows.Forms.Splitter
    Friend WithEvents pnlRight As System.Windows.Forms.Panel
    Friend WithEvents btnSurveyPageLoad As System.Windows.Forms.Button
    Friend WithEvents Label51 As System.Windows.Forms.Label
    Friend WithEvents imlApproval As System.Windows.Forms.ImageList
    Friend WithEvents picApprovePageStatusImage0 As System.Windows.Forms.PictureBox
    Friend WithEvents picApprovePageStatusImage1 As System.Windows.Forms.PictureBox
    Friend WithEvents picApprovePageStatusImage2 As System.Windows.Forms.PictureBox
    Friend WithEvents Label47 As System.Windows.Forms.Label
    Friend WithEvents PictureBox2 As System.Windows.Forms.PictureBox
    Friend WithEvents PictureBox4 As System.Windows.Forms.PictureBox
    Friend WithEvents PictureBox5 As System.Windows.Forms.PictureBox
    Friend WithEvents tpgStepCriteria As System.Windows.Forms.TabPage
    Friend WithEvents lblStepCriteria As System.Windows.Forms.Label
    Friend WithEvents pnlStepCriteria As System.Windows.Forms.Panel
    Friend WithEvents txtCriteriaPageCriteria As System.Windows.Forms.TextBox
    Friend WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents lnkCriteriaPageCheck As System.Windows.Forms.LinkLabel
    Friend WithEvents lnkCriteriaPageHelp As System.Windows.Forms.LinkLabel
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container
        Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(CanadaNormSettingWizard))
        Me.pnlBackPanel = New NRC.WinForms.SectionPanel
        Me.pnlRight = New System.Windows.Forms.Panel
        Me.tabWizard = New System.Windows.Forms.TabControl
        Me.tpgStepStart = New System.Windows.Forms.TabPage
        Me.PictureBox2 = New System.Windows.Forms.PictureBox
        Me.Label51 = New System.Windows.Forms.Label
        Me.PictureBox1 = New System.Windows.Forms.PictureBox
        Me.Label2 = New System.Windows.Forms.Label
        Me.tpgStepTask = New System.Windows.Forms.TabPage
        Me.lvwTaskPageNorm = New NRC.WinForms.NRCListView
        Me.chdTaskPageName = New System.Windows.Forms.ColumnHeader
        Me.chdTaskPageNormID = New NRC.WinForms.NRCColumnHeader
        Me.chdTaskPageDescription = New System.Windows.Forms.ColumnHeader
        Me.Label6 = New System.Windows.Forms.Label
        Me.optTaskPageUpdateNorm = New System.Windows.Forms.RadioButton
        Me.optTaskPageNewNorm = New System.Windows.Forms.RadioButton
        Me.tpgStepName = New System.Windows.Forms.TabPage
        Me.Label11 = New System.Windows.Forms.Label
        Me.GroupBox2 = New System.Windows.Forms.GroupBox
        Me.Label21 = New System.Windows.Forms.Label
        Me.Label20 = New System.Windows.Forms.Label
        Me.Label19 = New System.Windows.Forms.Label
        Me.Label18 = New System.Windows.Forms.Label
        Me.Label17 = New System.Windows.Forms.Label
        Me.Label13 = New System.Windows.Forms.Label
        Me.txtNamePageLpCompLabel = New System.Windows.Forms.TextBox
        Me.chkNamePageLpComp = New System.Windows.Forms.CheckBox
        Me.txtNamePageLpCompDescription = New System.Windows.Forms.TextBox
        Me.Label14 = New System.Windows.Forms.Label
        Me.lblNamePageLpCompID = New System.Windows.Forms.Label
        Me.Label16 = New System.Windows.Forms.Label
        Me.Label9 = New System.Windows.Forms.Label
        Me.txtNamePageHpCompLabel = New System.Windows.Forms.TextBox
        Me.chkNamePageHpComp = New System.Windows.Forms.CheckBox
        Me.txtNamePageHpCompDescription = New System.Windows.Forms.TextBox
        Me.Label10 = New System.Windows.Forms.Label
        Me.lblNamePageHpCompID = New System.Windows.Forms.Label
        Me.Label12 = New System.Windows.Forms.Label
        Me.Label8 = New System.Windows.Forms.Label
        Me.txtNamePageAvgCompLabel = New System.Windows.Forms.TextBox
        Me.chkNamePageAvgComp = New System.Windows.Forms.CheckBox
        Me.txtNamePageAvgCompDescription = New System.Windows.Forms.TextBox
        Me.Label5 = New System.Windows.Forms.Label
        Me.lblNamePageAvgCompID = New System.Windows.Forms.Label
        Me.Label7 = New System.Windows.Forms.Label
        Me.GroupBox1 = New System.Windows.Forms.GroupBox
        Me.Label15 = New System.Windows.Forms.Label
        Me.txtNamePageNormLabel = New System.Windows.Forms.TextBox
        Me.txtNamePageNormDescription = New System.Windows.Forms.TextBox
        Me.Label4 = New System.Windows.Forms.Label
        Me.lblNamePageNormID = New System.Windows.Forms.Label
        Me.Label3 = New System.Windows.Forms.Label
        Me.tpgStepSetting = New System.Windows.Forms.TabPage
        Me.dtpSettingPageReturnDateMax = New System.Windows.Forms.DateTimePicker
        Me.Label30 = New System.Windows.Forms.Label
        Me.Label29 = New System.Windows.Forms.Label
        Me.dtpSettingPageReportDateEnd = New System.Windows.Forms.DateTimePicker
        Me.dtpSettingPageReportDateBegin = New System.Windows.Forms.DateTimePicker
        Me.Label28 = New System.Windows.Forms.Label
        Me.nudSettingPageLpSurvey = New System.Windows.Forms.NumericUpDown
        Me.Label26 = New System.Windows.Forms.Label
        Me.Label27 = New System.Windows.Forms.Label
        Me.nudSettingPageHpSurvey = New System.Windows.Forms.NumericUpDown
        Me.Label25 = New System.Windows.Forms.Label
        Me.Label24 = New System.Windows.Forms.Label
        Me.chkSettingPageWeight = New System.Windows.Forms.CheckBox
        Me.Label23 = New System.Windows.Forms.Label
        Me.Label22 = New System.Windows.Forms.Label
        Me.tpgStepClient = New System.Windows.Forms.TabPage
        Me.pnlClientPageBack = New System.Windows.Forms.Panel
        Me.pnlClientPageBackRight = New System.Windows.Forms.Panel
        Me.Panel3 = New System.Windows.Forms.Panel
        Me.lvwClientPageUsedClient = New NRC.WinForms.NRCListView
        Me.ColumnHeader3 = New System.Windows.Forms.ColumnHeader
        Me.NrcColumnHeader3 = New NRC.WinForms.NRCColumnHeader
        Me.Label36 = New System.Windows.Forms.Label
        Me.pnlClientPageSplitter = New System.Windows.Forms.Panel
        Me.pnlClientPageButtons = New System.Windows.Forms.Panel
        Me.btnClientPageUnselectAll = New System.Windows.Forms.Button
        Me.btnClientPageUnselect = New System.Windows.Forms.Button
        Me.btnClientPageSelect = New System.Windows.Forms.Button
        Me.btnClientPageSelectAll = New System.Windows.Forms.Button
        Me.splClientPageSplitter = New System.Windows.Forms.Splitter
        Me.pnlClientPageBackLeft = New System.Windows.Forms.Panel
        Me.lvwClientPageUnusedClient = New NRC.WinForms.NRCListView
        Me.ColumnHeader2 = New System.Windows.Forms.ColumnHeader
        Me.NrcColumnHeader2 = New NRC.WinForms.NRCColumnHeader
        Me.Label35 = New System.Windows.Forms.Label
        Me.Label34 = New System.Windows.Forms.Label
        Me.tpgStepSurvey = New System.Windows.Forms.TabPage
        Me.btnSurveyPageLoad = New System.Windows.Forms.Button
        Me.Label32 = New System.Windows.Forms.Label
        Me.lblSurveyPageTotalCount = New System.Windows.Forms.Label
        Me.Label33 = New System.Windows.Forms.Label
        Me.lblSurveyPageSelectCount = New System.Windows.Forms.Label
        Me.lnkSurveyPageDeselectHighlight = New System.Windows.Forms.LinkLabel
        Me.lnkSurveyPageSelectHighlight = New System.Windows.Forms.LinkLabel
        Me.lnkSurveyPageDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkSurveyPageSelectAll = New System.Windows.Forms.LinkLabel
        Me.lvwSurveyPageList = New NRC.WinForms.NRCListView
        Me.chdSurveyPageClientName = New NRC.WinForms.NRCColumnHeader
        Me.chdSurveyPageClientID = New NRC.WinForms.NRCColumnHeader
        Me.chdSurveyPageStudyName = New NRC.WinForms.NRCColumnHeader
        Me.chdSurveyPageStudyID = New NRC.WinForms.NRCColumnHeader
        Me.chdSurveyPageSurveyName = New NRC.WinForms.NRCColumnHeader
        Me.chdSurveyPageSurveyID = New NRC.WinForms.NRCColumnHeader
        Me.Label31 = New System.Windows.Forms.Label
        Me.tpgStepCriteria = New System.Windows.Forms.TabPage
        Me.lnkCriteriaPageHelp = New System.Windows.Forms.LinkLabel
        Me.lnkCriteriaPageCheck = New System.Windows.Forms.LinkLabel
        Me.Label1 = New System.Windows.Forms.Label
        Me.txtCriteriaPageCriteria = New System.Windows.Forms.TextBox
        Me.tpgStepRollup = New System.Windows.Forms.TabPage
        Me.Label38 = New System.Windows.Forms.Label
        Me.lblRollupPageTotalCount = New System.Windows.Forms.Label
        Me.Label40 = New System.Windows.Forms.Label
        Me.lblRollupPageSelectCount = New System.Windows.Forms.Label
        Me.lnkRollupPageDeselectHighlight = New System.Windows.Forms.LinkLabel
        Me.lnkRollupPageSelectHighlight = New System.Windows.Forms.LinkLabel
        Me.lnkRollupPageDeselectAll = New System.Windows.Forms.LinkLabel
        Me.lnkRollupPageSelectAll = New System.Windows.Forms.LinkLabel
        Me.Label37 = New System.Windows.Forms.Label
        Me.lvwRollupPageList = New NRC.WinForms.NRCListView
        Me.chdRollupPageName = New System.Windows.Forms.ColumnHeader
        Me.chdRollupPageID = New NRC.WinForms.NRCColumnHeader
        Me.chdRollupPageDescription = New System.Windows.Forms.ColumnHeader
        Me.tpgStepApproval = New System.Windows.Forms.TabPage
        Me.grpApprovePageGroup2 = New System.Windows.Forms.GroupBox
        Me.picApprovePageStatusImage2 = New System.Windows.Forms.PictureBox
        Me.Label60 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveStatus2 = New System.Windows.Forms.Label
        Me.Label59 = New System.Windows.Forms.Label
        Me.lblApprovePageCheckItem2 = New System.Windows.Forms.Label
        Me.Label41 = New System.Windows.Forms.Label
        Me.Label46 = New System.Windows.Forms.Label
        Me.lblApprovePageApproverNameLabel2 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveDateLabel2 = New System.Windows.Forms.Label
        Me.lblApprovePageModifierName2 = New System.Windows.Forms.Label
        Me.lblApprovePageApproverName2 = New System.Windows.Forms.Label
        Me.lblApprovePageModifyDate2 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveDate2 = New System.Windows.Forms.Label
        Me.btnApprovePageShowSummary2 = New System.Windows.Forms.Button
        Me.grpApprovePageGroup1 = New System.Windows.Forms.GroupBox
        Me.picApprovePageStatusImage1 = New System.Windows.Forms.PictureBox
        Me.Label57 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveStatus1 = New System.Windows.Forms.Label
        Me.Label56 = New System.Windows.Forms.Label
        Me.lblApprovePageCheckItem1 = New System.Windows.Forms.Label
        Me.Label48 = New System.Windows.Forms.Label
        Me.Label49 = New System.Windows.Forms.Label
        Me.lblApprovePageApproverNameLabel1 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveDateLabel1 = New System.Windows.Forms.Label
        Me.lblApprovePageModifierName1 = New System.Windows.Forms.Label
        Me.lblApprovePageApproverName1 = New System.Windows.Forms.Label
        Me.lblApprovePageModifyDate1 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveDate1 = New System.Windows.Forms.Label
        Me.btnApprovePageShowSummary1 = New System.Windows.Forms.Button
        Me.grpApprovePageGroup0 = New System.Windows.Forms.GroupBox
        Me.Label47 = New System.Windows.Forms.Label
        Me.picApprovePageStatusImage0 = New System.Windows.Forms.PictureBox
        Me.Label55 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveStatus0 = New System.Windows.Forms.Label
        Me.lblApprovePageCheckItem0 = New System.Windows.Forms.Label
        Me.Label42 = New System.Windows.Forms.Label
        Me.lblApprovePageModifierName0 = New System.Windows.Forms.Label
        Me.Label43 = New System.Windows.Forms.Label
        Me.lblApprovePageModifyDate0 = New System.Windows.Forms.Label
        Me.lblApprovePageApproverNameLabel0 = New System.Windows.Forms.Label
        Me.lblApprovePageApproverName0 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveDateLabel0 = New System.Windows.Forms.Label
        Me.lblApprovePageApproveDate0 = New System.Windows.Forms.Label
        Me.btnApprovePageShowSummary0 = New System.Windows.Forms.Button
        Me.Label39 = New System.Windows.Forms.Label
        Me.tpgStepFinish = New System.Windows.Forms.TabPage
        Me.PictureBox5 = New System.Windows.Forms.PictureBox
        Me.PictureBox4 = New System.Windows.Forms.PictureBox
        Me.Label45 = New System.Windows.Forms.Label
        Me.PictureBox3 = New System.Windows.Forms.PictureBox
        Me.Splitter1 = New System.Windows.Forms.Splitter
        Me.pnlLeft = New System.Windows.Forms.Panel
        Me.lblStepCriteria = New System.Windows.Forms.Label
        Me.pnlStepCriteria = New System.Windows.Forms.Panel
        Me.pnlStepApproval = New System.Windows.Forms.Panel
        Me.lblStepClient = New System.Windows.Forms.Label
        Me.pnlStepClient = New System.Windows.Forms.Panel
        Me.lblStepFinish = New System.Windows.Forms.Label
        Me.lblStepApproval = New System.Windows.Forms.Label
        Me.lblStepRollup = New System.Windows.Forms.Label
        Me.lblStepSurvey = New System.Windows.Forms.Label
        Me.lblStepSetting = New System.Windows.Forms.Label
        Me.lblStepName = New System.Windows.Forms.Label
        Me.lblStepTask = New System.Windows.Forms.Label
        Me.lblStepStart = New System.Windows.Forms.Label
        Me.pnlStepRollup = New System.Windows.Forms.Panel
        Me.pnlStepSurvey = New System.Windows.Forms.Panel
        Me.pnlStepSetting = New System.Windows.Forms.Panel
        Me.pnlStepName = New System.Windows.Forms.Panel
        Me.pnlStepTask = New System.Windows.Forms.Panel
        Me.pnlStepStart = New System.Windows.Forms.Panel
        Me.pnlStepFinish = New System.Windows.Forms.Panel
        Me.pnlBottom = New System.Windows.Forms.Panel
        Me.btnFinish = New System.Windows.Forms.Button
        Me.btnNext = New System.Windows.Forms.Button
        Me.btnBack = New System.Windows.Forms.Button
        Me.btnCancel = New System.Windows.Forms.Button
        Me.imlApproval = New System.Windows.Forms.ImageList(Me.components)
        Me.pnlBackPanel.SuspendLayout()
        Me.pnlRight.SuspendLayout()
        Me.tabWizard.SuspendLayout()
        Me.tpgStepStart.SuspendLayout()
        Me.tpgStepTask.SuspendLayout()
        Me.tpgStepName.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.tpgStepSetting.SuspendLayout()
        CType(Me.nudSettingPageLpSurvey, System.ComponentModel.ISupportInitialize).BeginInit()
        CType(Me.nudSettingPageHpSurvey, System.ComponentModel.ISupportInitialize).BeginInit()
        Me.tpgStepClient.SuspendLayout()
        Me.pnlClientPageBack.SuspendLayout()
        Me.pnlClientPageBackRight.SuspendLayout()
        Me.Panel3.SuspendLayout()
        Me.pnlClientPageSplitter.SuspendLayout()
        Me.pnlClientPageButtons.SuspendLayout()
        Me.pnlClientPageBackLeft.SuspendLayout()
        Me.tpgStepSurvey.SuspendLayout()
        Me.tpgStepCriteria.SuspendLayout()
        Me.tpgStepRollup.SuspendLayout()
        Me.tpgStepApproval.SuspendLayout()
        Me.grpApprovePageGroup2.SuspendLayout()
        Me.grpApprovePageGroup1.SuspendLayout()
        Me.grpApprovePageGroup0.SuspendLayout()
        Me.tpgStepFinish.SuspendLayout()
        Me.pnlLeft.SuspendLayout()
        Me.pnlBottom.SuspendLayout()
        Me.SuspendLayout()
        '
        'pnlBackPanel
        '
        Me.pnlBackPanel.AutoScroll = True
        Me.pnlBackPanel.BackColor = System.Drawing.Color.Black
        Me.pnlBackPanel.BorderColor = System.Drawing.Color.FromArgb(CType(0, Byte), CType(45, Byte), CType(150, Byte))
        Me.pnlBackPanel.Caption = "Canadian Norm Setup Wizard"
        Me.pnlBackPanel.Controls.Add(Me.pnlRight)
        Me.pnlBackPanel.Controls.Add(Me.Splitter1)
        Me.pnlBackPanel.Controls.Add(Me.pnlLeft)
        Me.pnlBackPanel.Controls.Add(Me.pnlBottom)
        Me.pnlBackPanel.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlBackPanel.DockPadding.All = 1
        Me.pnlBackPanel.Location = New System.Drawing.Point(0, 0)
        Me.pnlBackPanel.Name = "pnlBackPanel"
        Me.pnlBackPanel.ShowCaption = True
        Me.pnlBackPanel.Size = New System.Drawing.Size(776, 688)
        Me.pnlBackPanel.TabIndex = 0
        '
        'pnlRight
        '
        Me.pnlRight.Controls.Add(Me.tabWizard)
        Me.pnlRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlRight.Location = New System.Drawing.Point(145, 27)
        Me.pnlRight.Name = "pnlRight"
        Me.pnlRight.Size = New System.Drawing.Size(630, 620)
        Me.pnlRight.TabIndex = 23
        '
        'tabWizard
        '
        Me.tabWizard.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.tabWizard.Controls.Add(Me.tpgStepStart)
        Me.tabWizard.Controls.Add(Me.tpgStepTask)
        Me.tabWizard.Controls.Add(Me.tpgStepName)
        Me.tabWizard.Controls.Add(Me.tpgStepSetting)
        Me.tabWizard.Controls.Add(Me.tpgStepClient)
        Me.tabWizard.Controls.Add(Me.tpgStepSurvey)
        Me.tabWizard.Controls.Add(Me.tpgStepCriteria)
        Me.tabWizard.Controls.Add(Me.tpgStepRollup)
        Me.tabWizard.Controls.Add(Me.tpgStepApproval)
        Me.tabWizard.Controls.Add(Me.tpgStepFinish)
        Me.tabWizard.Location = New System.Drawing.Point(0, 0)
        Me.tabWizard.Name = "tabWizard"
        Me.tabWizard.SelectedIndex = 0
        Me.tabWizard.Size = New System.Drawing.Size(635, 616)
        Me.tabWizard.TabIndex = 18
        '
        'tpgStepStart
        '
        Me.tpgStepStart.Controls.Add(Me.PictureBox2)
        Me.tpgStepStart.Controls.Add(Me.Label51)
        Me.tpgStepStart.Controls.Add(Me.PictureBox1)
        Me.tpgStepStart.Controls.Add(Me.Label2)
        Me.tpgStepStart.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepStart.Name = "tpgStepStart"
        Me.tpgStepStart.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepStart.TabIndex = 1
        Me.tpgStepStart.Text = "Start"
        '
        'PictureBox2
        '
        Me.PictureBox2.Image = CType(resources.GetObject("PictureBox2.Image"), System.Drawing.Image)
        Me.PictureBox2.Location = New System.Drawing.Point(24, 24)
        Me.PictureBox2.Name = "PictureBox2"
        Me.PictureBox2.Size = New System.Drawing.Size(440, 32)
        Me.PictureBox2.TabIndex = 3
        Me.PictureBox2.TabStop = False
        '
        'Label51
        '
        Me.Label51.BackColor = System.Drawing.Color.White
        Me.Label51.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label51.Location = New System.Drawing.Point(328, 328)
        Me.Label51.Name = "Label51"
        Me.Label51.Size = New System.Drawing.Size(136, 24)
        Me.Label51.TabIndex = 2
        Me.Label51.Text = "Click Next to continue"
        Me.Label51.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'PictureBox1
        '
        Me.PictureBox1.BackColor = System.Drawing.Color.White
        Me.PictureBox1.Image = CType(resources.GetObject("PictureBox1.Image"), System.Drawing.Image)
        Me.PictureBox1.Location = New System.Drawing.Point(112, 136)
        Me.PictureBox1.Name = "PictureBox1"
        Me.PictureBox1.Size = New System.Drawing.Size(352, 216)
        Me.PictureBox1.TabIndex = 1
        Me.PictureBox1.TabStop = False
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.Color.White
        Me.Label2.Font = New System.Drawing.Font("Microsoft Sans Serif", 9.75!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.Location = New System.Drawing.Point(112, 64)
        Me.Label2.Name = "Label2"
        Me.Label2.Size = New System.Drawing.Size(352, 72)
        Me.Label2.TabIndex = 1
        Me.Label2.Text = "This wizard will take you step by step  through the process of setting up and gen" & _
        "erating norms."
        Me.Label2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'tpgStepTask
        '
        Me.tpgStepTask.Controls.Add(Me.lvwTaskPageNorm)
        Me.tpgStepTask.Controls.Add(Me.Label6)
        Me.tpgStepTask.Controls.Add(Me.optTaskPageUpdateNorm)
        Me.tpgStepTask.Controls.Add(Me.optTaskPageNewNorm)
        Me.tpgStepTask.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepTask.Name = "tpgStepTask"
        Me.tpgStepTask.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepTask.TabIndex = 0
        Me.tpgStepTask.Text = "Task"
        '
        'lvwTaskPageNorm
        '
        Me.lvwTaskPageNorm.AlternateColor1 = System.Drawing.Color.White
        Me.lvwTaskPageNorm.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwTaskPageNorm.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwTaskPageNorm.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdTaskPageName, Me.chdTaskPageNormID, Me.chdTaskPageDescription})
        Me.lvwTaskPageNorm.FullRowSelect = True
        Me.lvwTaskPageNorm.GridLines = True
        Me.lvwTaskPageNorm.HideSelection = False
        Me.lvwTaskPageNorm.Location = New System.Drawing.Point(56, 120)
        Me.lvwTaskPageNorm.MultiSelect = False
        Me.lvwTaskPageNorm.Name = "lvwTaskPageNorm"
        Me.lvwTaskPageNorm.Size = New System.Drawing.Size(539, 448)
        Me.lvwTaskPageNorm.SortColumn = -1
        Me.lvwTaskPageNorm.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwTaskPageNorm.TabIndex = 3
        Me.lvwTaskPageNorm.View = System.Windows.Forms.View.Details
        '
        'chdTaskPageName
        '
        Me.chdTaskPageName.Text = "Norm Group Name"
        Me.chdTaskPageName.Width = 120
        '
        'chdTaskPageNormID
        '
        Me.chdTaskPageNormID.DataType = NRC.WinForms.DataType._Unknown
        Me.chdTaskPageNormID.Text = "ID"
        Me.chdTaskPageNormID.WidthAutoAdjust = False
        Me.chdTaskPageNormID.WidthProportion = 0
        '
        'chdTaskPageDescription
        '
        Me.chdTaskPageDescription.Text = "Description"
        Me.chdTaskPageDescription.Width = 120
        '
        'Label6
        '
        Me.Label6.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label6.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.Location = New System.Drawing.Point(24, 24)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(576, 23)
        Me.Label6.TabIndex = 0
        Me.Label6.Text = "What do you want to do?"
        '
        'optTaskPageUpdateNorm
        '
        Me.optTaskPageUpdateNorm.Checked = True
        Me.optTaskPageUpdateNorm.Location = New System.Drawing.Point(32, 96)
        Me.optTaskPageUpdateNorm.Name = "optTaskPageUpdateNorm"
        Me.optTaskPageUpdateNorm.Size = New System.Drawing.Size(168, 24)
        Me.optTaskPageUpdateNorm.TabIndex = 2
        Me.optTaskPageUpdateNorm.TabStop = True
        Me.optTaskPageUpdateNorm.Text = "Update existing norm group"
        '
        'optTaskPageNewNorm
        '
        Me.optTaskPageNewNorm.Location = New System.Drawing.Point(32, 64)
        Me.optTaskPageNewNorm.Name = "optTaskPageNewNorm"
        Me.optTaskPageNewNorm.Size = New System.Drawing.Size(168, 24)
        Me.optTaskPageNewNorm.TabIndex = 1
        Me.optTaskPageNewNorm.Text = "Create a new norm group"
        '
        'tpgStepName
        '
        Me.tpgStepName.Controls.Add(Me.Label11)
        Me.tpgStepName.Controls.Add(Me.GroupBox2)
        Me.tpgStepName.Controls.Add(Me.GroupBox1)
        Me.tpgStepName.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepName.Name = "tpgStepName"
        Me.tpgStepName.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepName.TabIndex = 2
        Me.tpgStepName.Text = "Norm Names"
        '
        'Label11
        '
        Me.Label11.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label11.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label11.Location = New System.Drawing.Point(24, 24)
        Me.Label11.Name = "Label11"
        Me.Label11.Size = New System.Drawing.Size(576, 40)
        Me.Label11.TabIndex = 0
        Me.Label11.Text = "What are the labels and descriptions of the norm group and individual norms?"
        '
        'GroupBox2
        '
        Me.GroupBox2.Controls.Add(Me.Label21)
        Me.GroupBox2.Controls.Add(Me.Label20)
        Me.GroupBox2.Controls.Add(Me.Label19)
        Me.GroupBox2.Controls.Add(Me.Label18)
        Me.GroupBox2.Controls.Add(Me.Label17)
        Me.GroupBox2.Controls.Add(Me.Label13)
        Me.GroupBox2.Controls.Add(Me.txtNamePageLpCompLabel)
        Me.GroupBox2.Controls.Add(Me.chkNamePageLpComp)
        Me.GroupBox2.Controls.Add(Me.txtNamePageLpCompDescription)
        Me.GroupBox2.Controls.Add(Me.Label14)
        Me.GroupBox2.Controls.Add(Me.lblNamePageLpCompID)
        Me.GroupBox2.Controls.Add(Me.Label16)
        Me.GroupBox2.Controls.Add(Me.Label9)
        Me.GroupBox2.Controls.Add(Me.txtNamePageHpCompLabel)
        Me.GroupBox2.Controls.Add(Me.chkNamePageHpComp)
        Me.GroupBox2.Controls.Add(Me.txtNamePageHpCompDescription)
        Me.GroupBox2.Controls.Add(Me.Label10)
        Me.GroupBox2.Controls.Add(Me.lblNamePageHpCompID)
        Me.GroupBox2.Controls.Add(Me.Label12)
        Me.GroupBox2.Controls.Add(Me.Label8)
        Me.GroupBox2.Controls.Add(Me.txtNamePageAvgCompLabel)
        Me.GroupBox2.Controls.Add(Me.chkNamePageAvgComp)
        Me.GroupBox2.Controls.Add(Me.txtNamePageAvgCompDescription)
        Me.GroupBox2.Controls.Add(Me.Label5)
        Me.GroupBox2.Controls.Add(Me.lblNamePageAvgCompID)
        Me.GroupBox2.Controls.Add(Me.Label7)
        Me.GroupBox2.Location = New System.Drawing.Point(24, 200)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.Size = New System.Drawing.Size(552, 368)
        Me.GroupBox2.TabIndex = 2
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Individual Norms"
        '
        'Label21
        '
        Me.Label21.Location = New System.Drawing.Point(40, 264)
        Me.Label21.Name = "Label21"
        Me.Label21.Size = New System.Drawing.Size(80, 24)
        Me.Label21.TabIndex = 19
        Me.Label21.Text = "LP Norm"
        Me.Label21.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label20
        '
        Me.Label20.Location = New System.Drawing.Point(40, 144)
        Me.Label20.Name = "Label20"
        Me.Label20.Size = New System.Drawing.Size(80, 24)
        Me.Label20.TabIndex = 10
        Me.Label20.Text = "HP Norm"
        Me.Label20.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label19
        '
        Me.Label19.Location = New System.Drawing.Point(40, 24)
        Me.Label19.Name = "Label19"
        Me.Label19.Size = New System.Drawing.Size(80, 24)
        Me.Label19.TabIndex = 1
        Me.Label19.Text = "Average Norm"
        Me.Label19.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label18
        '
        Me.Label18.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label18.Location = New System.Drawing.Point(40, 248)
        Me.Label18.Name = "Label18"
        Me.Label18.Size = New System.Drawing.Size(488, 2)
        Me.Label18.TabIndex = 17
        Me.Label18.Text = "Label18"
        '
        'Label17
        '
        Me.Label17.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label17.Location = New System.Drawing.Point(40, 128)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(488, 2)
        Me.Label17.TabIndex = 8
        Me.Label17.Text = "Label17"
        '
        'Label13
        '
        Me.Label13.Location = New System.Drawing.Point(40, 328)
        Me.Label13.Name = "Label13"
        Me.Label13.Size = New System.Drawing.Size(64, 20)
        Me.Label13.TabIndex = 24
        Me.Label13.Text = "Description"
        Me.Label13.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'txtNamePageLpCompLabel
        '
        Me.txtNamePageLpCompLabel.Location = New System.Drawing.Point(224, 296)
        Me.txtNamePageLpCompLabel.MaxLength = 50
        Me.txtNamePageLpCompLabel.Name = "txtNamePageLpCompLabel"
        Me.txtNamePageLpCompLabel.Size = New System.Drawing.Size(304, 20)
        Me.txtNamePageLpCompLabel.TabIndex = 23
        Me.txtNamePageLpCompLabel.Text = ""
        '
        'chkNamePageLpComp
        '
        Me.chkNamePageLpComp.Location = New System.Drawing.Point(24, 264)
        Me.chkNamePageLpComp.Name = "chkNamePageLpComp"
        Me.chkNamePageLpComp.Size = New System.Drawing.Size(16, 24)
        Me.chkNamePageLpComp.TabIndex = 18
        '
        'txtNamePageLpCompDescription
        '
        Me.txtNamePageLpCompDescription.Location = New System.Drawing.Point(120, 328)
        Me.txtNamePageLpCompDescription.MaxLength = 300
        Me.txtNamePageLpCompDescription.Name = "txtNamePageLpCompDescription"
        Me.txtNamePageLpCompDescription.Size = New System.Drawing.Size(408, 20)
        Me.txtNamePageLpCompDescription.TabIndex = 25
        Me.txtNamePageLpCompDescription.Text = ""
        '
        'Label14
        '
        Me.Label14.Location = New System.Drawing.Point(184, 296)
        Me.Label14.Name = "Label14"
        Me.Label14.Size = New System.Drawing.Size(40, 20)
        Me.Label14.TabIndex = 22
        Me.Label14.Text = "Label"
        Me.Label14.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblNamePageLpCompID
        '
        Me.lblNamePageLpCompID.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblNamePageLpCompID.Location = New System.Drawing.Point(120, 296)
        Me.lblNamePageLpCompID.Name = "lblNamePageLpCompID"
        Me.lblNamePageLpCompID.Size = New System.Drawing.Size(48, 20)
        Me.lblNamePageLpCompID.TabIndex = 21
        Me.lblNamePageLpCompID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label16
        '
        Me.Label16.Location = New System.Drawing.Point(40, 296)
        Me.Label16.Name = "Label16"
        Me.Label16.Size = New System.Drawing.Size(64, 20)
        Me.Label16.TabIndex = 20
        Me.Label16.Text = "Type ID"
        Me.Label16.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label9
        '
        Me.Label9.Location = New System.Drawing.Point(40, 208)
        Me.Label9.Name = "Label9"
        Me.Label9.Size = New System.Drawing.Size(64, 20)
        Me.Label9.TabIndex = 15
        Me.Label9.Text = "Description"
        Me.Label9.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'txtNamePageHpCompLabel
        '
        Me.txtNamePageHpCompLabel.Location = New System.Drawing.Point(224, 176)
        Me.txtNamePageHpCompLabel.MaxLength = 50
        Me.txtNamePageHpCompLabel.Name = "txtNamePageHpCompLabel"
        Me.txtNamePageHpCompLabel.Size = New System.Drawing.Size(304, 20)
        Me.txtNamePageHpCompLabel.TabIndex = 14
        Me.txtNamePageHpCompLabel.Text = ""
        '
        'chkNamePageHpComp
        '
        Me.chkNamePageHpComp.Location = New System.Drawing.Point(24, 144)
        Me.chkNamePageHpComp.Name = "chkNamePageHpComp"
        Me.chkNamePageHpComp.Size = New System.Drawing.Size(16, 24)
        Me.chkNamePageHpComp.TabIndex = 9
        '
        'txtNamePageHpCompDescription
        '
        Me.txtNamePageHpCompDescription.Location = New System.Drawing.Point(120, 208)
        Me.txtNamePageHpCompDescription.MaxLength = 300
        Me.txtNamePageHpCompDescription.Name = "txtNamePageHpCompDescription"
        Me.txtNamePageHpCompDescription.Size = New System.Drawing.Size(408, 20)
        Me.txtNamePageHpCompDescription.TabIndex = 16
        Me.txtNamePageHpCompDescription.Text = ""
        '
        'Label10
        '
        Me.Label10.Location = New System.Drawing.Point(184, 176)
        Me.Label10.Name = "Label10"
        Me.Label10.Size = New System.Drawing.Size(40, 20)
        Me.Label10.TabIndex = 13
        Me.Label10.Text = "Label"
        Me.Label10.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblNamePageHpCompID
        '
        Me.lblNamePageHpCompID.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblNamePageHpCompID.Location = New System.Drawing.Point(120, 176)
        Me.lblNamePageHpCompID.Name = "lblNamePageHpCompID"
        Me.lblNamePageHpCompID.Size = New System.Drawing.Size(48, 20)
        Me.lblNamePageHpCompID.TabIndex = 12
        Me.lblNamePageHpCompID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label12
        '
        Me.Label12.Location = New System.Drawing.Point(40, 176)
        Me.Label12.Name = "Label12"
        Me.Label12.Size = New System.Drawing.Size(64, 20)
        Me.Label12.TabIndex = 11
        Me.Label12.Text = "Type ID"
        Me.Label12.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label8
        '
        Me.Label8.Location = New System.Drawing.Point(40, 88)
        Me.Label8.Name = "Label8"
        Me.Label8.Size = New System.Drawing.Size(64, 20)
        Me.Label8.TabIndex = 6
        Me.Label8.Text = "Description"
        Me.Label8.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'txtNamePageAvgCompLabel
        '
        Me.txtNamePageAvgCompLabel.Location = New System.Drawing.Point(224, 56)
        Me.txtNamePageAvgCompLabel.MaxLength = 50
        Me.txtNamePageAvgCompLabel.Name = "txtNamePageAvgCompLabel"
        Me.txtNamePageAvgCompLabel.Size = New System.Drawing.Size(304, 20)
        Me.txtNamePageAvgCompLabel.TabIndex = 5
        Me.txtNamePageAvgCompLabel.Text = ""
        '
        'chkNamePageAvgComp
        '
        Me.chkNamePageAvgComp.Location = New System.Drawing.Point(24, 24)
        Me.chkNamePageAvgComp.Name = "chkNamePageAvgComp"
        Me.chkNamePageAvgComp.Size = New System.Drawing.Size(16, 24)
        Me.chkNamePageAvgComp.TabIndex = 0
        '
        'txtNamePageAvgCompDescription
        '
        Me.txtNamePageAvgCompDescription.Location = New System.Drawing.Point(120, 88)
        Me.txtNamePageAvgCompDescription.MaxLength = 300
        Me.txtNamePageAvgCompDescription.Name = "txtNamePageAvgCompDescription"
        Me.txtNamePageAvgCompDescription.Size = New System.Drawing.Size(408, 20)
        Me.txtNamePageAvgCompDescription.TabIndex = 7
        Me.txtNamePageAvgCompDescription.Text = ""
        '
        'Label5
        '
        Me.Label5.Location = New System.Drawing.Point(184, 56)
        Me.Label5.Name = "Label5"
        Me.Label5.Size = New System.Drawing.Size(40, 20)
        Me.Label5.TabIndex = 4
        Me.Label5.Text = "Label"
        Me.Label5.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblNamePageAvgCompID
        '
        Me.lblNamePageAvgCompID.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblNamePageAvgCompID.Location = New System.Drawing.Point(120, 56)
        Me.lblNamePageAvgCompID.Name = "lblNamePageAvgCompID"
        Me.lblNamePageAvgCompID.Size = New System.Drawing.Size(48, 20)
        Me.lblNamePageAvgCompID.TabIndex = 3
        Me.lblNamePageAvgCompID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label7
        '
        Me.Label7.Location = New System.Drawing.Point(40, 56)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(64, 20)
        Me.Label7.TabIndex = 2
        Me.Label7.Text = "Type ID"
        Me.Label7.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'GroupBox1
        '
        Me.GroupBox1.Controls.Add(Me.Label15)
        Me.GroupBox1.Controls.Add(Me.txtNamePageNormLabel)
        Me.GroupBox1.Controls.Add(Me.txtNamePageNormDescription)
        Me.GroupBox1.Controls.Add(Me.Label4)
        Me.GroupBox1.Controls.Add(Me.lblNamePageNormID)
        Me.GroupBox1.Controls.Add(Me.Label3)
        Me.GroupBox1.Location = New System.Drawing.Point(24, 80)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.Size = New System.Drawing.Size(552, 96)
        Me.GroupBox1.TabIndex = 1
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Norm Group"
        '
        'Label15
        '
        Me.Label15.Location = New System.Drawing.Point(40, 56)
        Me.Label15.Name = "Label15"
        Me.Label15.Size = New System.Drawing.Size(64, 20)
        Me.Label15.TabIndex = 4
        Me.Label15.Text = "Description"
        Me.Label15.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'txtNamePageNormLabel
        '
        Me.txtNamePageNormLabel.Location = New System.Drawing.Point(224, 24)
        Me.txtNamePageNormLabel.MaxLength = 256
        Me.txtNamePageNormLabel.Name = "txtNamePageNormLabel"
        Me.txtNamePageNormLabel.Size = New System.Drawing.Size(304, 20)
        Me.txtNamePageNormLabel.TabIndex = 3
        Me.txtNamePageNormLabel.Text = ""
        '
        'txtNamePageNormDescription
        '
        Me.txtNamePageNormDescription.Location = New System.Drawing.Point(120, 56)
        Me.txtNamePageNormDescription.MaxLength = 256
        Me.txtNamePageNormDescription.Name = "txtNamePageNormDescription"
        Me.txtNamePageNormDescription.Size = New System.Drawing.Size(408, 20)
        Me.txtNamePageNormDescription.TabIndex = 5
        Me.txtNamePageNormDescription.Text = ""
        '
        'Label4
        '
        Me.Label4.Location = New System.Drawing.Point(184, 24)
        Me.Label4.Name = "Label4"
        Me.Label4.Size = New System.Drawing.Size(40, 20)
        Me.Label4.TabIndex = 2
        Me.Label4.Text = "Label"
        Me.Label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblNamePageNormID
        '
        Me.lblNamePageNormID.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblNamePageNormID.Location = New System.Drawing.Point(120, 24)
        Me.lblNamePageNormID.Name = "lblNamePageNormID"
        Me.lblNamePageNormID.Size = New System.Drawing.Size(48, 20)
        Me.lblNamePageNormID.TabIndex = 1
        Me.lblNamePageNormID.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label3
        '
        Me.Label3.Location = New System.Drawing.Point(40, 24)
        Me.Label3.Name = "Label3"
        Me.Label3.Size = New System.Drawing.Size(88, 20)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "Norm Group ID"
        Me.Label3.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'tpgStepSetting
        '
        Me.tpgStepSetting.Controls.Add(Me.dtpSettingPageReturnDateMax)
        Me.tpgStepSetting.Controls.Add(Me.Label30)
        Me.tpgStepSetting.Controls.Add(Me.Label29)
        Me.tpgStepSetting.Controls.Add(Me.dtpSettingPageReportDateEnd)
        Me.tpgStepSetting.Controls.Add(Me.dtpSettingPageReportDateBegin)
        Me.tpgStepSetting.Controls.Add(Me.Label28)
        Me.tpgStepSetting.Controls.Add(Me.nudSettingPageLpSurvey)
        Me.tpgStepSetting.Controls.Add(Me.Label26)
        Me.tpgStepSetting.Controls.Add(Me.Label27)
        Me.tpgStepSetting.Controls.Add(Me.nudSettingPageHpSurvey)
        Me.tpgStepSetting.Controls.Add(Me.Label25)
        Me.tpgStepSetting.Controls.Add(Me.Label24)
        Me.tpgStepSetting.Controls.Add(Me.chkSettingPageWeight)
        Me.tpgStepSetting.Controls.Add(Me.Label23)
        Me.tpgStepSetting.Controls.Add(Me.Label22)
        Me.tpgStepSetting.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepSetting.Name = "tpgStepSetting"
        Me.tpgStepSetting.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepSetting.TabIndex = 3
        Me.tpgStepSetting.Text = "Settings"
        '
        'dtpSettingPageReturnDateMax
        '
        Me.dtpSettingPageReturnDateMax.CustomFormat = "MMM d, yyyy"
        Me.dtpSettingPageReturnDateMax.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpSettingPageReturnDateMax.Location = New System.Drawing.Point(272, 232)
        Me.dtpSettingPageReturnDateMax.Name = "dtpSettingPageReturnDateMax"
        Me.dtpSettingPageReturnDateMax.Size = New System.Drawing.Size(88, 20)
        Me.dtpSettingPageReturnDateMax.TabIndex = 14
        '
        'Label30
        '
        Me.Label30.Location = New System.Drawing.Point(24, 232)
        Me.Label30.Name = "Label30"
        Me.Label30.Size = New System.Drawing.Size(232, 20)
        Me.Label30.TabIndex = 13
        Me.Label30.Text = "Cutoff date"
        Me.Label30.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label29
        '
        Me.Label29.Location = New System.Drawing.Point(368, 192)
        Me.Label29.Name = "Label29"
        Me.Label29.Size = New System.Drawing.Size(16, 20)
        Me.Label29.TabIndex = 11
        Me.Label29.Text = "to"
        Me.Label29.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'dtpSettingPageReportDateEnd
        '
        Me.dtpSettingPageReportDateEnd.CustomFormat = "MMM d, yyyy"
        Me.dtpSettingPageReportDateEnd.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpSettingPageReportDateEnd.Location = New System.Drawing.Point(392, 192)
        Me.dtpSettingPageReportDateEnd.Name = "dtpSettingPageReportDateEnd"
        Me.dtpSettingPageReportDateEnd.Size = New System.Drawing.Size(88, 20)
        Me.dtpSettingPageReportDateEnd.TabIndex = 12
        '
        'dtpSettingPageReportDateBegin
        '
        Me.dtpSettingPageReportDateBegin.CustomFormat = "MMM d, yyyy"
        Me.dtpSettingPageReportDateBegin.Format = System.Windows.Forms.DateTimePickerFormat.Short
        Me.dtpSettingPageReportDateBegin.Location = New System.Drawing.Point(272, 192)
        Me.dtpSettingPageReportDateBegin.Name = "dtpSettingPageReportDateBegin"
        Me.dtpSettingPageReportDateBegin.Size = New System.Drawing.Size(88, 20)
        Me.dtpSettingPageReportDateBegin.TabIndex = 10
        '
        'Label28
        '
        Me.Label28.Location = New System.Drawing.Point(24, 192)
        Me.Label28.Name = "Label28"
        Me.Label28.Size = New System.Drawing.Size(232, 20)
        Me.Label28.TabIndex = 9
        Me.Label28.Text = "Report date range"
        Me.Label28.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'nudSettingPageLpSurvey
        '
        Me.nudSettingPageLpSurvey.Location = New System.Drawing.Point(272, 152)
        Me.nudSettingPageLpSurvey.Maximum = New Decimal(New Integer() {5, 0, 0, 0})
        Me.nudSettingPageLpSurvey.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.nudSettingPageLpSurvey.Name = "nudSettingPageLpSurvey"
        Me.nudSettingPageLpSurvey.Size = New System.Drawing.Size(48, 20)
        Me.nudSettingPageLpSurvey.TabIndex = 7
        Me.nudSettingPageLpSurvey.Value = New Decimal(New Integer() {5, 0, 0, 0})
        '
        'Label26
        '
        Me.Label26.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label26.Location = New System.Drawing.Point(328, 152)
        Me.Label26.Name = "Label26"
        Me.Label26.Size = New System.Drawing.Size(168, 20)
        Me.Label26.TabIndex = 8
        Me.Label26.Text = "(default: 5, min: 1, max: 5)"
        Me.Label26.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label27
        '
        Me.Label27.Location = New System.Drawing.Point(24, 152)
        Me.Label27.Name = "Label27"
        Me.Label27.Size = New System.Drawing.Size(232, 20)
        Me.Label27.TabIndex = 6
        Me.Label27.Text = "Number of surveys to be included in LP norm"
        Me.Label27.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'nudSettingPageHpSurvey
        '
        Me.nudSettingPageHpSurvey.Location = New System.Drawing.Point(272, 112)
        Me.nudSettingPageHpSurvey.Maximum = New Decimal(New Integer() {5, 0, 0, 0})
        Me.nudSettingPageHpSurvey.Minimum = New Decimal(New Integer() {1, 0, 0, 0})
        Me.nudSettingPageHpSurvey.Name = "nudSettingPageHpSurvey"
        Me.nudSettingPageHpSurvey.Size = New System.Drawing.Size(48, 20)
        Me.nudSettingPageHpSurvey.TabIndex = 4
        Me.nudSettingPageHpSurvey.Value = New Decimal(New Integer() {1, 0, 0, 0})
        '
        'Label25
        '
        Me.Label25.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label25.Location = New System.Drawing.Point(328, 112)
        Me.Label25.Name = "Label25"
        Me.Label25.Size = New System.Drawing.Size(168, 20)
        Me.Label25.TabIndex = 5
        Me.Label25.Text = "(default: 1, min: 1, max: 5)"
        Me.Label25.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label24
        '
        Me.Label24.Location = New System.Drawing.Point(24, 72)
        Me.Label24.Name = "Label24"
        Me.Label24.Size = New System.Drawing.Size(232, 20)
        Me.Label24.TabIndex = 1
        Me.Label24.Text = "Apply weighting on average norm"
        Me.Label24.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'chkSettingPageWeight
        '
        Me.chkSettingPageWeight.Location = New System.Drawing.Point(270, 72)
        Me.chkSettingPageWeight.Name = "chkSettingPageWeight"
        Me.chkSettingPageWeight.RightToLeft = System.Windows.Forms.RightToLeft.Yes
        Me.chkSettingPageWeight.Size = New System.Drawing.Size(16, 24)
        Me.chkSettingPageWeight.TabIndex = 2
        '
        'Label23
        '
        Me.Label23.Location = New System.Drawing.Point(24, 112)
        Me.Label23.Name = "Label23"
        Me.Label23.Size = New System.Drawing.Size(232, 20)
        Me.Label23.TabIndex = 3
        Me.Label23.Text = "Number of surveys to be included in HP norm"
        Me.Label23.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label22
        '
        Me.Label22.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label22.Location = New System.Drawing.Point(24, 24)
        Me.Label22.Name = "Label22"
        Me.Label22.Size = New System.Drawing.Size(568, 24)
        Me.Label22.TabIndex = 0
        Me.Label22.Text = "What are the norm settings for this norm group?"
        '
        'tpgStepClient
        '
        Me.tpgStepClient.Controls.Add(Me.pnlClientPageBack)
        Me.tpgStepClient.Controls.Add(Me.Label34)
        Me.tpgStepClient.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepClient.Name = "tpgStepClient"
        Me.tpgStepClient.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepClient.TabIndex = 9
        Me.tpgStepClient.Text = "Clients"
        '
        'pnlClientPageBack
        '
        Me.pnlClientPageBack.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.pnlClientPageBack.Controls.Add(Me.pnlClientPageBackRight)
        Me.pnlClientPageBack.Controls.Add(Me.splClientPageSplitter)
        Me.pnlClientPageBack.Controls.Add(Me.pnlClientPageBackLeft)
        Me.pnlClientPageBack.Location = New System.Drawing.Point(24, 56)
        Me.pnlClientPageBack.Name = "pnlClientPageBack"
        Me.pnlClientPageBack.Size = New System.Drawing.Size(579, 512)
        Me.pnlClientPageBack.TabIndex = 14
        '
        'pnlClientPageBackRight
        '
        Me.pnlClientPageBackRight.Controls.Add(Me.Panel3)
        Me.pnlClientPageBackRight.Controls.Add(Me.pnlClientPageSplitter)
        Me.pnlClientPageBackRight.Dock = System.Windows.Forms.DockStyle.Fill
        Me.pnlClientPageBackRight.Location = New System.Drawing.Point(224, 0)
        Me.pnlClientPageBackRight.Name = "pnlClientPageBackRight"
        Me.pnlClientPageBackRight.Size = New System.Drawing.Size(355, 512)
        Me.pnlClientPageBackRight.TabIndex = 3
        '
        'Panel3
        '
        Me.Panel3.Controls.Add(Me.lvwClientPageUsedClient)
        Me.Panel3.Controls.Add(Me.Label36)
        Me.Panel3.Dock = System.Windows.Forms.DockStyle.Fill
        Me.Panel3.Location = New System.Drawing.Point(56, 0)
        Me.Panel3.Name = "Panel3"
        Me.Panel3.Size = New System.Drawing.Size(299, 512)
        Me.Panel3.TabIndex = 1
        '
        'lvwClientPageUsedClient
        '
        Me.lvwClientPageUsedClient.AlternateColor1 = System.Drawing.Color.White
        Me.lvwClientPageUsedClient.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwClientPageUsedClient.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader3, Me.NrcColumnHeader3})
        Me.lvwClientPageUsedClient.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwClientPageUsedClient.FullRowSelect = True
        Me.lvwClientPageUsedClient.GridLines = True
        Me.lvwClientPageUsedClient.HideSelection = False
        Me.lvwClientPageUsedClient.Location = New System.Drawing.Point(0, 23)
        Me.lvwClientPageUsedClient.Name = "lvwClientPageUsedClient"
        Me.lvwClientPageUsedClient.Size = New System.Drawing.Size(299, 489)
        Me.lvwClientPageUsedClient.SortColumn = -1
        Me.lvwClientPageUsedClient.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwClientPageUsedClient.TabIndex = 1
        Me.lvwClientPageUsedClient.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader3
        '
        Me.ColumnHeader3.Text = "Client Name"
        Me.ColumnHeader3.Width = 140
        '
        'NrcColumnHeader3
        '
        Me.NrcColumnHeader3.DataType = NRC.WinForms.DataType._Unknown
        Me.NrcColumnHeader3.Text = "ID"
        Me.NrcColumnHeader3.Width = 50
        Me.NrcColumnHeader3.WidthAutoAdjust = False
        Me.NrcColumnHeader3.WidthProportion = 0
        '
        'Label36
        '
        Me.Label36.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label36.Dock = System.Windows.Forms.DockStyle.Top
        Me.Label36.Font = New System.Drawing.Font("Arial", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label36.Location = New System.Drawing.Point(0, 0)
        Me.Label36.Name = "Label36"
        Me.Label36.Size = New System.Drawing.Size(299, 23)
        Me.Label36.TabIndex = 0
        Me.Label36.Text = "Selected Clients"
        Me.Label36.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'pnlClientPageSplitter
        '
        Me.pnlClientPageSplitter.Controls.Add(Me.pnlClientPageButtons)
        Me.pnlClientPageSplitter.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlClientPageSplitter.Location = New System.Drawing.Point(0, 0)
        Me.pnlClientPageSplitter.Name = "pnlClientPageSplitter"
        Me.pnlClientPageSplitter.Size = New System.Drawing.Size(56, 512)
        Me.pnlClientPageSplitter.TabIndex = 0
        '
        'pnlClientPageButtons
        '
        Me.pnlClientPageButtons.Controls.Add(Me.btnClientPageUnselectAll)
        Me.pnlClientPageButtons.Controls.Add(Me.btnClientPageUnselect)
        Me.pnlClientPageButtons.Controls.Add(Me.btnClientPageSelect)
        Me.pnlClientPageButtons.Controls.Add(Me.btnClientPageSelectAll)
        Me.pnlClientPageButtons.Location = New System.Drawing.Point(8, 112)
        Me.pnlClientPageButtons.Name = "pnlClientPageButtons"
        Me.pnlClientPageButtons.Size = New System.Drawing.Size(32, 120)
        Me.pnlClientPageButtons.TabIndex = 12
        '
        'btnClientPageUnselectAll
        '
        Me.btnClientPageUnselectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClientPageUnselectAll.Location = New System.Drawing.Point(0, 96)
        Me.btnClientPageUnselectAll.Name = "btnClientPageUnselectAll"
        Me.btnClientPageUnselectAll.Size = New System.Drawing.Size(32, 23)
        Me.btnClientPageUnselectAll.TabIndex = 3
        Me.btnClientPageUnselectAll.Tag = "Deselect all"
        Me.btnClientPageUnselectAll.Text = "<<"
        '
        'btnClientPageUnselect
        '
        Me.btnClientPageUnselect.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClientPageUnselect.Location = New System.Drawing.Point(0, 64)
        Me.btnClientPageUnselect.Name = "btnClientPageUnselect"
        Me.btnClientPageUnselect.Size = New System.Drawing.Size(32, 23)
        Me.btnClientPageUnselect.TabIndex = 2
        Me.btnClientPageUnselect.Tag = "Deselect highlighted"
        Me.btnClientPageUnselect.Text = "<"
        '
        'btnClientPageSelect
        '
        Me.btnClientPageSelect.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClientPageSelect.Location = New System.Drawing.Point(0, 32)
        Me.btnClientPageSelect.Name = "btnClientPageSelect"
        Me.btnClientPageSelect.Size = New System.Drawing.Size(32, 23)
        Me.btnClientPageSelect.TabIndex = 1
        Me.btnClientPageSelect.Tag = "Select highlighted"
        Me.btnClientPageSelect.Text = ">"
        '
        'btnClientPageSelectAll
        '
        Me.btnClientPageSelectAll.Font = New System.Drawing.Font("Microsoft Sans Serif", 8.25!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.btnClientPageSelectAll.Location = New System.Drawing.Point(0, 0)
        Me.btnClientPageSelectAll.Name = "btnClientPageSelectAll"
        Me.btnClientPageSelectAll.Size = New System.Drawing.Size(32, 23)
        Me.btnClientPageSelectAll.TabIndex = 0
        Me.btnClientPageSelectAll.Tag = "Select all"
        Me.btnClientPageSelectAll.Text = ">>"
        '
        'splClientPageSplitter
        '
        Me.splClientPageSplitter.Location = New System.Drawing.Point(216, 0)
        Me.splClientPageSplitter.Name = "splClientPageSplitter"
        Me.splClientPageSplitter.Size = New System.Drawing.Size(8, 512)
        Me.splClientPageSplitter.TabIndex = 0
        Me.splClientPageSplitter.TabStop = False
        '
        'pnlClientPageBackLeft
        '
        Me.pnlClientPageBackLeft.Controls.Add(Me.lvwClientPageUnusedClient)
        Me.pnlClientPageBackLeft.Controls.Add(Me.Label35)
        Me.pnlClientPageBackLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlClientPageBackLeft.Location = New System.Drawing.Point(0, 0)
        Me.pnlClientPageBackLeft.Name = "pnlClientPageBackLeft"
        Me.pnlClientPageBackLeft.Size = New System.Drawing.Size(216, 512)
        Me.pnlClientPageBackLeft.TabIndex = 0
        '
        'lvwClientPageUnusedClient
        '
        Me.lvwClientPageUnusedClient.AlternateColor1 = System.Drawing.Color.White
        Me.lvwClientPageUnusedClient.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwClientPageUnusedClient.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.ColumnHeader2, Me.NrcColumnHeader2})
        Me.lvwClientPageUnusedClient.Dock = System.Windows.Forms.DockStyle.Fill
        Me.lvwClientPageUnusedClient.FullRowSelect = True
        Me.lvwClientPageUnusedClient.GridLines = True
        Me.lvwClientPageUnusedClient.HideSelection = False
        Me.lvwClientPageUnusedClient.Location = New System.Drawing.Point(0, 23)
        Me.lvwClientPageUnusedClient.Name = "lvwClientPageUnusedClient"
        Me.lvwClientPageUnusedClient.Size = New System.Drawing.Size(216, 489)
        Me.lvwClientPageUnusedClient.SortColumn = -1
        Me.lvwClientPageUnusedClient.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwClientPageUnusedClient.TabIndex = 1
        Me.lvwClientPageUnusedClient.View = System.Windows.Forms.View.Details
        '
        'ColumnHeader2
        '
        Me.ColumnHeader2.Text = "Client Name"
        Me.ColumnHeader2.Width = 140
        '
        'NrcColumnHeader2
        '
        Me.NrcColumnHeader2.DataType = NRC.WinForms.DataType._Unknown
        Me.NrcColumnHeader2.Text = "ID"
        Me.NrcColumnHeader2.Width = 50
        Me.NrcColumnHeader2.WidthAutoAdjust = False
        Me.NrcColumnHeader2.WidthProportion = 0
        '
        'Label35
        '
        Me.Label35.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label35.Dock = System.Windows.Forms.DockStyle.Top
        Me.Label35.Font = New System.Drawing.Font("Arial", 9.75!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label35.Location = New System.Drawing.Point(0, 0)
        Me.Label35.Name = "Label35"
        Me.Label35.Size = New System.Drawing.Size(216, 23)
        Me.Label35.TabIndex = 0
        Me.Label35.Text = "Unselected Clients"
        Me.Label35.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'Label34
        '
        Me.Label34.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label34.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label34.Location = New System.Drawing.Point(24, 24)
        Me.Label34.Name = "Label34"
        Me.Label34.Size = New System.Drawing.Size(584, 24)
        Me.Label34.TabIndex = 0
        Me.Label34.Text = "Which clients are counted in this norm group?"
        '
        'tpgStepSurvey
        '
        Me.tpgStepSurvey.Controls.Add(Me.btnSurveyPageLoad)
        Me.tpgStepSurvey.Controls.Add(Me.Label32)
        Me.tpgStepSurvey.Controls.Add(Me.lblSurveyPageTotalCount)
        Me.tpgStepSurvey.Controls.Add(Me.Label33)
        Me.tpgStepSurvey.Controls.Add(Me.lblSurveyPageSelectCount)
        Me.tpgStepSurvey.Controls.Add(Me.lnkSurveyPageDeselectHighlight)
        Me.tpgStepSurvey.Controls.Add(Me.lnkSurveyPageSelectHighlight)
        Me.tpgStepSurvey.Controls.Add(Me.lnkSurveyPageDeselectAll)
        Me.tpgStepSurvey.Controls.Add(Me.lnkSurveyPageSelectAll)
        Me.tpgStepSurvey.Controls.Add(Me.lvwSurveyPageList)
        Me.tpgStepSurvey.Controls.Add(Me.Label31)
        Me.tpgStepSurvey.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepSurvey.Name = "tpgStepSurvey"
        Me.tpgStepSurvey.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepSurvey.TabIndex = 4
        Me.tpgStepSurvey.Text = "Surveys"
        '
        'btnSurveyPageLoad
        '
        Me.btnSurveyPageLoad.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnSurveyPageLoad.Location = New System.Drawing.Point(488, 24)
        Me.btnSurveyPageLoad.Name = "btnSurveyPageLoad"
        Me.btnSurveyPageLoad.Size = New System.Drawing.Size(120, 23)
        Me.btnSurveyPageLoad.TabIndex = 10
        Me.btnSurveyPageLoad.Text = "Load From Text File"
        '
        'Label32
        '
        Me.Label32.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label32.Location = New System.Drawing.Point(491, 568)
        Me.Label32.Name = "Label32"
        Me.Label32.Size = New System.Drawing.Size(32, 16)
        Me.Label32.TabIndex = 7
        Me.Label32.Text = "total"
        Me.Label32.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblSurveyPageTotalCount
        '
        Me.lblSurveyPageTotalCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblSurveyPageTotalCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSurveyPageTotalCount.Location = New System.Drawing.Point(451, 568)
        Me.lblSurveyPageTotalCount.Name = "lblSurveyPageTotalCount"
        Me.lblSurveyPageTotalCount.Size = New System.Drawing.Size(32, 16)
        Me.lblSurveyPageTotalCount.TabIndex = 6
        Me.lblSurveyPageTotalCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label33
        '
        Me.Label33.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label33.Location = New System.Drawing.Point(563, 568)
        Me.Label33.Name = "Label33"
        Me.Label33.Size = New System.Drawing.Size(48, 16)
        Me.Label33.TabIndex = 9
        Me.Label33.Text = "selected"
        Me.Label33.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblSurveyPageSelectCount
        '
        Me.lblSurveyPageSelectCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblSurveyPageSelectCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblSurveyPageSelectCount.Location = New System.Drawing.Point(531, 568)
        Me.lblSurveyPageSelectCount.Name = "lblSurveyPageSelectCount"
        Me.lblSurveyPageSelectCount.Size = New System.Drawing.Size(32, 16)
        Me.lblSurveyPageSelectCount.TabIndex = 8
        Me.lblSurveyPageSelectCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lnkSurveyPageDeselectHighlight
        '
        Me.lnkSurveyPageDeselectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkSurveyPageDeselectHighlight.Image = CType(resources.GetObject("lnkSurveyPageDeselectHighlight.Image"), System.Drawing.Image)
        Me.lnkSurveyPageDeselectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkSurveyPageDeselectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkSurveyPageDeselectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkSurveyPageDeselectHighlight.Location = New System.Drawing.Point(288, 568)
        Me.lnkSurveyPageDeselectHighlight.Name = "lnkSurveyPageDeselectHighlight"
        Me.lnkSurveyPageDeselectHighlight.Size = New System.Drawing.Size(120, 16)
        Me.lnkSurveyPageDeselectHighlight.TabIndex = 5
        Me.lnkSurveyPageDeselectHighlight.TabStop = True
        Me.lnkSurveyPageDeselectHighlight.Text = "Deselect Highlights"
        Me.lnkSurveyPageDeselectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkSurveyPageDeselectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkSurveyPageSelectHighlight
        '
        Me.lnkSurveyPageSelectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkSurveyPageSelectHighlight.Image = CType(resources.GetObject("lnkSurveyPageSelectHighlight.Image"), System.Drawing.Image)
        Me.lnkSurveyPageSelectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkSurveyPageSelectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkSurveyPageSelectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkSurveyPageSelectHighlight.Location = New System.Drawing.Point(176, 568)
        Me.lnkSurveyPageSelectHighlight.Name = "lnkSurveyPageSelectHighlight"
        Me.lnkSurveyPageSelectHighlight.Size = New System.Drawing.Size(104, 16)
        Me.lnkSurveyPageSelectHighlight.TabIndex = 4
        Me.lnkSurveyPageSelectHighlight.TabStop = True
        Me.lnkSurveyPageSelectHighlight.Text = "Select Highlights"
        Me.lnkSurveyPageSelectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkSurveyPageSelectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkSurveyPageDeselectAll
        '
        Me.lnkSurveyPageDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkSurveyPageDeselectAll.Image = CType(resources.GetObject("lnkSurveyPageDeselectAll.Image"), System.Drawing.Image)
        Me.lnkSurveyPageDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkSurveyPageDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkSurveyPageDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkSurveyPageDeselectAll.Location = New System.Drawing.Point(88, 568)
        Me.lnkSurveyPageDeselectAll.Name = "lnkSurveyPageDeselectAll"
        Me.lnkSurveyPageDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkSurveyPageDeselectAll.TabIndex = 3
        Me.lnkSurveyPageDeselectAll.TabStop = True
        Me.lnkSurveyPageDeselectAll.Text = "Deselect All"
        Me.lnkSurveyPageDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkSurveyPageDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkSurveyPageSelectAll
        '
        Me.lnkSurveyPageSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkSurveyPageSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkSurveyPageSelectAll.Image = CType(resources.GetObject("lnkSurveyPageSelectAll.Image"), System.Drawing.Image)
        Me.lnkSurveyPageSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkSurveyPageSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkSurveyPageSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkSurveyPageSelectAll.Location = New System.Drawing.Point(16, 568)
        Me.lnkSurveyPageSelectAll.Name = "lnkSurveyPageSelectAll"
        Me.lnkSurveyPageSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkSurveyPageSelectAll.TabIndex = 2
        Me.lnkSurveyPageSelectAll.TabStop = True
        Me.lnkSurveyPageSelectAll.Text = "Select All"
        Me.lnkSurveyPageSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkSurveyPageSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lvwSurveyPageList
        '
        Me.lvwSurveyPageList.AlternateColor1 = System.Drawing.Color.White
        Me.lvwSurveyPageList.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwSurveyPageList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwSurveyPageList.CheckBoxes = True
        Me.lvwSurveyPageList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdSurveyPageClientName, Me.chdSurveyPageClientID, Me.chdSurveyPageStudyName, Me.chdSurveyPageStudyID, Me.chdSurveyPageSurveyName, Me.chdSurveyPageSurveyID})
        Me.lvwSurveyPageList.FullRowSelect = True
        Me.lvwSurveyPageList.GridLines = True
        Me.lvwSurveyPageList.HideSelection = False
        Me.lvwSurveyPageList.Location = New System.Drawing.Point(16, 56)
        Me.lvwSurveyPageList.Name = "lvwSurveyPageList"
        Me.lvwSurveyPageList.Size = New System.Drawing.Size(595, 504)
        Me.lvwSurveyPageList.SortColumn = 0
        Me.lvwSurveyPageList.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwSurveyPageList.TabIndex = 1
        Me.lvwSurveyPageList.View = System.Windows.Forms.View.Details
        '
        'chdSurveyPageClientName
        '
        Me.chdSurveyPageClientName.DataType = NRC.WinForms.DataType._String
        Me.chdSurveyPageClientName.Text = "Client Name"
        Me.chdSurveyPageClientName.Width = 140
        Me.chdSurveyPageClientName.WidthAutoAdjust = True
        Me.chdSurveyPageClientName.WidthProportion = 8
        '
        'chdSurveyPageClientID
        '
        Me.chdSurveyPageClientID.DataType = NRC.WinForms.DataType._Integer
        Me.chdSurveyPageClientID.Text = "ID"
        Me.chdSurveyPageClientID.Width = 50
        Me.chdSurveyPageClientID.WidthAutoAdjust = False
        Me.chdSurveyPageClientID.WidthProportion = 0
        '
        'chdSurveyPageStudyName
        '
        Me.chdSurveyPageStudyName.DataType = NRC.WinForms.DataType._String
        Me.chdSurveyPageStudyName.Text = "Study Name"
        Me.chdSurveyPageStudyName.Width = 120
        Me.chdSurveyPageStudyName.WidthAutoAdjust = True
        Me.chdSurveyPageStudyName.WidthProportion = 3
        '
        'chdSurveyPageStudyID
        '
        Me.chdSurveyPageStudyID.DataType = NRC.WinForms.DataType._Integer
        Me.chdSurveyPageStudyID.Text = "ID"
        Me.chdSurveyPageStudyID.Width = 50
        Me.chdSurveyPageStudyID.WidthAutoAdjust = False
        Me.chdSurveyPageStudyID.WidthProportion = 0
        '
        'chdSurveyPageSurveyName
        '
        Me.chdSurveyPageSurveyName.DataType = NRC.WinForms.DataType._String
        Me.chdSurveyPageSurveyName.Text = "Survey Name"
        Me.chdSurveyPageSurveyName.Width = 120
        Me.chdSurveyPageSurveyName.WidthAutoAdjust = True
        Me.chdSurveyPageSurveyName.WidthProportion = 4
        '
        'chdSurveyPageSurveyID
        '
        Me.chdSurveyPageSurveyID.DataType = NRC.WinForms.DataType._Integer
        Me.chdSurveyPageSurveyID.Text = "ID"
        Me.chdSurveyPageSurveyID.Width = 50
        Me.chdSurveyPageSurveyID.WidthAutoAdjust = False
        Me.chdSurveyPageSurveyID.WidthProportion = 0
        '
        'Label31
        '
        Me.Label31.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label31.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label31.Location = New System.Drawing.Point(24, 24)
        Me.Label31.Name = "Label31"
        Me.Label31.Size = New System.Drawing.Size(456, 24)
        Me.Label31.TabIndex = 0
        Me.Label31.Text = "Which surveys are counted in this norm group?"
        '
        'tpgStepCriteria
        '
        Me.tpgStepCriteria.Controls.Add(Me.lnkCriteriaPageHelp)
        Me.tpgStepCriteria.Controls.Add(Me.lnkCriteriaPageCheck)
        Me.tpgStepCriteria.Controls.Add(Me.Label1)
        Me.tpgStepCriteria.Controls.Add(Me.txtCriteriaPageCriteria)
        Me.tpgStepCriteria.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepCriteria.Name = "tpgStepCriteria"
        Me.tpgStepCriteria.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepCriteria.TabIndex = 10
        Me.tpgStepCriteria.Text = "Criteria"
        '
        'lnkCriteriaPageHelp
        '
        Me.lnkCriteriaPageHelp.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkCriteriaPageHelp.Location = New System.Drawing.Point(488, 560)
        Me.lnkCriteriaPageHelp.Name = "lnkCriteriaPageHelp"
        Me.lnkCriteriaPageHelp.Size = New System.Drawing.Size(32, 16)
        Me.lnkCriteriaPageHelp.TabIndex = 3
        Me.lnkCriteriaPageHelp.TabStop = True
        Me.lnkCriteriaPageHelp.Text = "Help"
        Me.lnkCriteriaPageHelp.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
        '
        'lnkCriteriaPageCheck
        '
        Me.lnkCriteriaPageCheck.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lnkCriteriaPageCheck.Location = New System.Drawing.Point(528, 560)
        Me.lnkCriteriaPageCheck.Name = "lnkCriteriaPageCheck"
        Me.lnkCriteriaPageCheck.Size = New System.Drawing.Size(80, 16)
        Me.lnkCriteriaPageCheck.TabIndex = 2
        Me.lnkCriteriaPageCheck.TabStop = True
        Me.lnkCriteriaPageCheck.Text = "Check Syntax"
        Me.lnkCriteriaPageCheck.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label1
        '
        Me.Label1.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label1.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.Location = New System.Drawing.Point(24, 24)
        Me.Label1.Name = "Label1"
        Me.Label1.Size = New System.Drawing.Size(456, 24)
        Me.Label1.TabIndex = 1
        Me.Label1.Text = "Using background selection criteria statement?"
        '
        'txtCriteriaPageCriteria
        '
        Me.txtCriteriaPageCriteria.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtCriteriaPageCriteria.Font = New System.Drawing.Font("Courier New", 8.25!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtCriteriaPageCriteria.Location = New System.Drawing.Point(16, 56)
        Me.txtCriteriaPageCriteria.Multiline = True
        Me.txtCriteriaPageCriteria.Name = "txtCriteriaPageCriteria"
        Me.txtCriteriaPageCriteria.Size = New System.Drawing.Size(592, 496)
        Me.txtCriteriaPageCriteria.TabIndex = 0
        Me.txtCriteriaPageCriteria.Text = ""
        '
        'tpgStepRollup
        '
        Me.tpgStepRollup.Controls.Add(Me.Label38)
        Me.tpgStepRollup.Controls.Add(Me.lblRollupPageTotalCount)
        Me.tpgStepRollup.Controls.Add(Me.Label40)
        Me.tpgStepRollup.Controls.Add(Me.lblRollupPageSelectCount)
        Me.tpgStepRollup.Controls.Add(Me.lnkRollupPageDeselectHighlight)
        Me.tpgStepRollup.Controls.Add(Me.lnkRollupPageSelectHighlight)
        Me.tpgStepRollup.Controls.Add(Me.lnkRollupPageDeselectAll)
        Me.tpgStepRollup.Controls.Add(Me.lnkRollupPageSelectAll)
        Me.tpgStepRollup.Controls.Add(Me.Label37)
        Me.tpgStepRollup.Controls.Add(Me.lvwRollupPageList)
        Me.tpgStepRollup.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepRollup.Name = "tpgStepRollup"
        Me.tpgStepRollup.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepRollup.TabIndex = 5
        Me.tpgStepRollup.Text = "Roll Ups"
        '
        'Label38
        '
        Me.Label38.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label38.Location = New System.Drawing.Point(491, 568)
        Me.Label38.Name = "Label38"
        Me.Label38.Size = New System.Drawing.Size(32, 16)
        Me.Label38.TabIndex = 7
        Me.Label38.Text = "total"
        Me.Label38.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblRollupPageTotalCount
        '
        Me.lblRollupPageTotalCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblRollupPageTotalCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblRollupPageTotalCount.Location = New System.Drawing.Point(451, 568)
        Me.lblRollupPageTotalCount.Name = "lblRollupPageTotalCount"
        Me.lblRollupPageTotalCount.Size = New System.Drawing.Size(32, 16)
        Me.lblRollupPageTotalCount.TabIndex = 6
        Me.lblRollupPageTotalCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label40
        '
        Me.Label40.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label40.Location = New System.Drawing.Point(563, 568)
        Me.Label40.Name = "Label40"
        Me.Label40.Size = New System.Drawing.Size(48, 16)
        Me.Label40.TabIndex = 9
        Me.Label40.Text = "selected"
        Me.Label40.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblRollupPageSelectCount
        '
        Me.lblRollupPageSelectCount.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lblRollupPageSelectCount.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblRollupPageSelectCount.Location = New System.Drawing.Point(531, 568)
        Me.lblRollupPageSelectCount.Name = "lblRollupPageSelectCount"
        Me.lblRollupPageSelectCount.Size = New System.Drawing.Size(32, 16)
        Me.lblRollupPageSelectCount.TabIndex = 8
        Me.lblRollupPageSelectCount.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lnkRollupPageDeselectHighlight
        '
        Me.lnkRollupPageDeselectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkRollupPageDeselectHighlight.Image = CType(resources.GetObject("lnkRollupPageDeselectHighlight.Image"), System.Drawing.Image)
        Me.lnkRollupPageDeselectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkRollupPageDeselectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkRollupPageDeselectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkRollupPageDeselectHighlight.Location = New System.Drawing.Point(288, 568)
        Me.lnkRollupPageDeselectHighlight.Name = "lnkRollupPageDeselectHighlight"
        Me.lnkRollupPageDeselectHighlight.Size = New System.Drawing.Size(120, 16)
        Me.lnkRollupPageDeselectHighlight.TabIndex = 5
        Me.lnkRollupPageDeselectHighlight.TabStop = True
        Me.lnkRollupPageDeselectHighlight.Text = "Deselect Highlights"
        Me.lnkRollupPageDeselectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkRollupPageDeselectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkRollupPageSelectHighlight
        '
        Me.lnkRollupPageSelectHighlight.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkRollupPageSelectHighlight.Image = CType(resources.GetObject("lnkRollupPageSelectHighlight.Image"), System.Drawing.Image)
        Me.lnkRollupPageSelectHighlight.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkRollupPageSelectHighlight.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkRollupPageSelectHighlight.LinkColor = System.Drawing.Color.Black
        Me.lnkRollupPageSelectHighlight.Location = New System.Drawing.Point(176, 568)
        Me.lnkRollupPageSelectHighlight.Name = "lnkRollupPageSelectHighlight"
        Me.lnkRollupPageSelectHighlight.Size = New System.Drawing.Size(104, 16)
        Me.lnkRollupPageSelectHighlight.TabIndex = 4
        Me.lnkRollupPageSelectHighlight.TabStop = True
        Me.lnkRollupPageSelectHighlight.Text = "Select Highlights"
        Me.lnkRollupPageSelectHighlight.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkRollupPageSelectHighlight.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkRollupPageDeselectAll
        '
        Me.lnkRollupPageDeselectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkRollupPageDeselectAll.Image = CType(resources.GetObject("lnkRollupPageDeselectAll.Image"), System.Drawing.Image)
        Me.lnkRollupPageDeselectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkRollupPageDeselectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkRollupPageDeselectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkRollupPageDeselectAll.Location = New System.Drawing.Point(88, 568)
        Me.lnkRollupPageDeselectAll.Name = "lnkRollupPageDeselectAll"
        Me.lnkRollupPageDeselectAll.Size = New System.Drawing.Size(80, 16)
        Me.lnkRollupPageDeselectAll.TabIndex = 3
        Me.lnkRollupPageDeselectAll.TabStop = True
        Me.lnkRollupPageDeselectAll.Text = "Deselect All"
        Me.lnkRollupPageDeselectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkRollupPageDeselectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'lnkRollupPageSelectAll
        '
        Me.lnkRollupPageSelectAll.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.lnkRollupPageSelectAll.FlatStyle = System.Windows.Forms.FlatStyle.Popup
        Me.lnkRollupPageSelectAll.Image = CType(resources.GetObject("lnkRollupPageSelectAll.Image"), System.Drawing.Image)
        Me.lnkRollupPageSelectAll.ImageAlign = System.Drawing.ContentAlignment.MiddleLeft
        Me.lnkRollupPageSelectAll.LinkBehavior = System.Windows.Forms.LinkBehavior.HoverUnderline
        Me.lnkRollupPageSelectAll.LinkColor = System.Drawing.Color.Black
        Me.lnkRollupPageSelectAll.Location = New System.Drawing.Point(16, 568)
        Me.lnkRollupPageSelectAll.Name = "lnkRollupPageSelectAll"
        Me.lnkRollupPageSelectAll.Size = New System.Drawing.Size(64, 16)
        Me.lnkRollupPageSelectAll.TabIndex = 2
        Me.lnkRollupPageSelectAll.TabStop = True
        Me.lnkRollupPageSelectAll.Text = "Select All"
        Me.lnkRollupPageSelectAll.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        Me.lnkRollupPageSelectAll.VisitedLinkColor = System.Drawing.Color.Black
        '
        'Label37
        '
        Me.Label37.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label37.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label37.Location = New System.Drawing.Point(24, 24)
        Me.Label37.Name = "Label37"
        Me.Label37.Size = New System.Drawing.Size(592, 24)
        Me.Label37.TabIndex = 0
        Me.Label37.Text = "Which rollups are counted in this norm group?"
        '
        'lvwRollupPageList
        '
        Me.lvwRollupPageList.AlternateColor1 = System.Drawing.Color.White
        Me.lvwRollupPageList.AlternateColor2 = System.Drawing.Color.Gainsboro
        Me.lvwRollupPageList.Anchor = CType((((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Bottom) _
                    Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.lvwRollupPageList.CheckBoxes = True
        Me.lvwRollupPageList.Columns.AddRange(New System.Windows.Forms.ColumnHeader() {Me.chdRollupPageName, Me.chdRollupPageID, Me.chdRollupPageDescription})
        Me.lvwRollupPageList.FullRowSelect = True
        Me.lvwRollupPageList.GridLines = True
        Me.lvwRollupPageList.HideSelection = False
        Me.lvwRollupPageList.Location = New System.Drawing.Point(16, 56)
        Me.lvwRollupPageList.Name = "lvwRollupPageList"
        Me.lvwRollupPageList.Size = New System.Drawing.Size(595, 504)
        Me.lvwRollupPageList.SortColumn = -1
        Me.lvwRollupPageList.SortOrder = NRC.WinForms.SortOrder.NotSorted
        Me.lvwRollupPageList.TabIndex = 1
        Me.lvwRollupPageList.View = System.Windows.Forms.View.Details
        '
        'chdRollupPageName
        '
        Me.chdRollupPageName.Text = "Rollup Name"
        Me.chdRollupPageName.Width = 200
        '
        'chdRollupPageID
        '
        Me.chdRollupPageID.DataType = NRC.WinForms.DataType._Integer
        Me.chdRollupPageID.Text = "Rollup ID"
        Me.chdRollupPageID.Width = 100
        Me.chdRollupPageID.WidthAutoAdjust = False
        Me.chdRollupPageID.WidthProportion = 0
        '
        'chdRollupPageDescription
        '
        Me.chdRollupPageDescription.Text = "Description"
        Me.chdRollupPageDescription.Width = 200
        '
        'tpgStepApproval
        '
        Me.tpgStepApproval.Controls.Add(Me.grpApprovePageGroup2)
        Me.tpgStepApproval.Controls.Add(Me.grpApprovePageGroup1)
        Me.tpgStepApproval.Controls.Add(Me.grpApprovePageGroup0)
        Me.tpgStepApproval.Controls.Add(Me.Label39)
        Me.tpgStepApproval.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepApproval.Name = "tpgStepApproval"
        Me.tpgStepApproval.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepApproval.TabIndex = 6
        Me.tpgStepApproval.Text = "Approval"
        '
        'grpApprovePageGroup2
        '
        Me.grpApprovePageGroup2.Controls.Add(Me.picApprovePageStatusImage2)
        Me.grpApprovePageGroup2.Controls.Add(Me.Label60)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageApproveStatus2)
        Me.grpApprovePageGroup2.Controls.Add(Me.Label59)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageCheckItem2)
        Me.grpApprovePageGroup2.Controls.Add(Me.Label41)
        Me.grpApprovePageGroup2.Controls.Add(Me.Label46)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageApproverNameLabel2)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageApproveDateLabel2)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageModifierName2)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageApproverName2)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageModifyDate2)
        Me.grpApprovePageGroup2.Controls.Add(Me.lblApprovePageApproveDate2)
        Me.grpApprovePageGroup2.Controls.Add(Me.btnApprovePageShowSummary2)
        Me.grpApprovePageGroup2.Location = New System.Drawing.Point(24, 392)
        Me.grpApprovePageGroup2.Name = "grpApprovePageGroup2"
        Me.grpApprovePageGroup2.Size = New System.Drawing.Size(584, 144)
        Me.grpApprovePageGroup2.TabIndex = 3
        Me.grpApprovePageGroup2.TabStop = False
        Me.grpApprovePageGroup2.Text = "Group 2"
        '
        'picApprovePageStatusImage2
        '
        Me.picApprovePageStatusImage2.Location = New System.Drawing.Point(112, 72)
        Me.picApprovePageStatusImage2.Name = "picApprovePageStatusImage2"
        Me.picApprovePageStatusImage2.Size = New System.Drawing.Size(32, 32)
        Me.picApprovePageStatusImage2.TabIndex = 14
        Me.picApprovePageStatusImage2.TabStop = False
        '
        'Label60
        '
        Me.Label60.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label60.Location = New System.Drawing.Point(8, 72)
        Me.Label60.Name = "Label60"
        Me.Label60.Size = New System.Drawing.Size(96, 23)
        Me.Label60.TabIndex = 6
        Me.Label60.Text = "Approval Status"
        Me.Label60.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproveStatus2
        '
        Me.lblApprovePageApproveStatus2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproveStatus2.Location = New System.Drawing.Point(152, 72)
        Me.lblApprovePageApproveStatus2.Name = "lblApprovePageApproveStatus2"
        Me.lblApprovePageApproveStatus2.Size = New System.Drawing.Size(104, 23)
        Me.lblApprovePageApproveStatus2.TabIndex = 7
        Me.lblApprovePageApproveStatus2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label59
        '
        Me.Label59.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label59.Location = New System.Drawing.Point(16, 56)
        Me.Label59.Name = "Label59"
        Me.Label59.Size = New System.Drawing.Size(552, 2)
        Me.Label59.TabIndex = 5
        '
        'lblApprovePageCheckItem2
        '
        Me.lblApprovePageCheckItem2.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.lblApprovePageCheckItem2.Location = New System.Drawing.Point(528, 72)
        Me.lblApprovePageCheckItem2.Name = "lblApprovePageCheckItem2"
        Me.lblApprovePageCheckItem2.Size = New System.Drawing.Size(40, 16)
        Me.lblApprovePageCheckItem2.TabIndex = 8
        Me.lblApprovePageCheckItem2.Visible = False
        '
        'Label41
        '
        Me.Label41.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label41.Location = New System.Drawing.Point(16, 24)
        Me.Label41.Name = "Label41"
        Me.Label41.Size = New System.Drawing.Size(88, 23)
        Me.Label41.TabIndex = 0
        Me.Label41.Text = "Modified by"
        Me.Label41.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label46
        '
        Me.Label46.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label46.Location = New System.Drawing.Point(256, 24)
        Me.Label46.Name = "Label46"
        Me.Label46.Size = New System.Drawing.Size(96, 23)
        Me.Label46.TabIndex = 2
        Me.Label46.Text = "Date Modified"
        Me.Label46.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproverNameLabel2
        '
        Me.lblApprovePageApproverNameLabel2.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblApprovePageApproverNameLabel2.Location = New System.Drawing.Point(264, 72)
        Me.lblApprovePageApproverNameLabel2.Name = "lblApprovePageApproverNameLabel2"
        Me.lblApprovePageApproverNameLabel2.Size = New System.Drawing.Size(88, 23)
        Me.lblApprovePageApproverNameLabel2.TabIndex = 9
        Me.lblApprovePageApproverNameLabel2.Text = "Approved by"
        Me.lblApprovePageApproverNameLabel2.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproveDateLabel2
        '
        Me.lblApprovePageApproveDateLabel2.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblApprovePageApproveDateLabel2.Location = New System.Drawing.Point(256, 104)
        Me.lblApprovePageApproveDateLabel2.Name = "lblApprovePageApproveDateLabel2"
        Me.lblApprovePageApproveDateLabel2.Size = New System.Drawing.Size(96, 23)
        Me.lblApprovePageApproveDateLabel2.TabIndex = 11
        Me.lblApprovePageApproveDateLabel2.Text = "Date Approved"
        Me.lblApprovePageApproveDateLabel2.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageModifierName2
        '
        Me.lblApprovePageModifierName2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageModifierName2.Location = New System.Drawing.Point(112, 24)
        Me.lblApprovePageModifierName2.Name = "lblApprovePageModifierName2"
        Me.lblApprovePageModifierName2.Size = New System.Drawing.Size(144, 23)
        Me.lblApprovePageModifierName2.TabIndex = 1
        Me.lblApprovePageModifierName2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageApproverName2
        '
        Me.lblApprovePageApproverName2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproverName2.Location = New System.Drawing.Point(360, 72)
        Me.lblApprovePageApproverName2.Name = "lblApprovePageApproverName2"
        Me.lblApprovePageApproverName2.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageApproverName2.TabIndex = 10
        Me.lblApprovePageApproverName2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageModifyDate2
        '
        Me.lblApprovePageModifyDate2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageModifyDate2.Location = New System.Drawing.Point(360, 24)
        Me.lblApprovePageModifyDate2.Name = "lblApprovePageModifyDate2"
        Me.lblApprovePageModifyDate2.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageModifyDate2.TabIndex = 3
        Me.lblApprovePageModifyDate2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageApproveDate2
        '
        Me.lblApprovePageApproveDate2.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproveDate2.Location = New System.Drawing.Point(360, 104)
        Me.lblApprovePageApproveDate2.Name = "lblApprovePageApproveDate2"
        Me.lblApprovePageApproveDate2.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageApproveDate2.TabIndex = 12
        Me.lblApprovePageApproveDate2.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnApprovePageShowSummary2
        '
        Me.btnApprovePageShowSummary2.Location = New System.Drawing.Point(496, 24)
        Me.btnApprovePageShowSummary2.Name = "btnApprovePageShowSummary2"
        Me.btnApprovePageShowSummary2.Size = New System.Drawing.Size(72, 23)
        Me.btnApprovePageShowSummary2.TabIndex = 4
        Me.btnApprovePageShowSummary2.Text = "Report"
        '
        'grpApprovePageGroup1
        '
        Me.grpApprovePageGroup1.Controls.Add(Me.picApprovePageStatusImage1)
        Me.grpApprovePageGroup1.Controls.Add(Me.Label57)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageApproveStatus1)
        Me.grpApprovePageGroup1.Controls.Add(Me.Label56)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageCheckItem1)
        Me.grpApprovePageGroup1.Controls.Add(Me.Label48)
        Me.grpApprovePageGroup1.Controls.Add(Me.Label49)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageApproverNameLabel1)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageApproveDateLabel1)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageModifierName1)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageApproverName1)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageModifyDate1)
        Me.grpApprovePageGroup1.Controls.Add(Me.lblApprovePageApproveDate1)
        Me.grpApprovePageGroup1.Controls.Add(Me.btnApprovePageShowSummary1)
        Me.grpApprovePageGroup1.Location = New System.Drawing.Point(24, 224)
        Me.grpApprovePageGroup1.Name = "grpApprovePageGroup1"
        Me.grpApprovePageGroup1.Size = New System.Drawing.Size(584, 144)
        Me.grpApprovePageGroup1.TabIndex = 2
        Me.grpApprovePageGroup1.TabStop = False
        Me.grpApprovePageGroup1.Text = "Group 1"
        '
        'picApprovePageStatusImage1
        '
        Me.picApprovePageStatusImage1.Location = New System.Drawing.Point(112, 72)
        Me.picApprovePageStatusImage1.Name = "picApprovePageStatusImage1"
        Me.picApprovePageStatusImage1.Size = New System.Drawing.Size(32, 32)
        Me.picApprovePageStatusImage1.TabIndex = 14
        Me.picApprovePageStatusImage1.TabStop = False
        '
        'Label57
        '
        Me.Label57.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label57.Location = New System.Drawing.Point(8, 72)
        Me.Label57.Name = "Label57"
        Me.Label57.Size = New System.Drawing.Size(96, 23)
        Me.Label57.TabIndex = 6
        Me.Label57.Text = "Approval Status"
        Me.Label57.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproveStatus1
        '
        Me.lblApprovePageApproveStatus1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproveStatus1.Location = New System.Drawing.Point(152, 72)
        Me.lblApprovePageApproveStatus1.Name = "lblApprovePageApproveStatus1"
        Me.lblApprovePageApproveStatus1.Size = New System.Drawing.Size(104, 23)
        Me.lblApprovePageApproveStatus1.TabIndex = 7
        Me.lblApprovePageApproveStatus1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label56
        '
        Me.Label56.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label56.Location = New System.Drawing.Point(16, 56)
        Me.Label56.Name = "Label56"
        Me.Label56.Size = New System.Drawing.Size(552, 2)
        Me.Label56.TabIndex = 5
        '
        'lblApprovePageCheckItem1
        '
        Me.lblApprovePageCheckItem1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.lblApprovePageCheckItem1.Location = New System.Drawing.Point(528, 72)
        Me.lblApprovePageCheckItem1.Name = "lblApprovePageCheckItem1"
        Me.lblApprovePageCheckItem1.Size = New System.Drawing.Size(40, 16)
        Me.lblApprovePageCheckItem1.TabIndex = 8
        Me.lblApprovePageCheckItem1.Visible = False
        '
        'Label48
        '
        Me.Label48.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label48.Location = New System.Drawing.Point(16, 24)
        Me.Label48.Name = "Label48"
        Me.Label48.Size = New System.Drawing.Size(88, 23)
        Me.Label48.TabIndex = 0
        Me.Label48.Text = "Modified by"
        Me.Label48.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'Label49
        '
        Me.Label49.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label49.Location = New System.Drawing.Point(256, 24)
        Me.Label49.Name = "Label49"
        Me.Label49.Size = New System.Drawing.Size(96, 23)
        Me.Label49.TabIndex = 2
        Me.Label49.Text = "Date Modified"
        Me.Label49.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproverNameLabel1
        '
        Me.lblApprovePageApproverNameLabel1.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblApprovePageApproverNameLabel1.Location = New System.Drawing.Point(264, 72)
        Me.lblApprovePageApproverNameLabel1.Name = "lblApprovePageApproverNameLabel1"
        Me.lblApprovePageApproverNameLabel1.Size = New System.Drawing.Size(88, 23)
        Me.lblApprovePageApproverNameLabel1.TabIndex = 9
        Me.lblApprovePageApproverNameLabel1.Text = "Approved by"
        Me.lblApprovePageApproverNameLabel1.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproveDateLabel1
        '
        Me.lblApprovePageApproveDateLabel1.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblApprovePageApproveDateLabel1.Location = New System.Drawing.Point(256, 104)
        Me.lblApprovePageApproveDateLabel1.Name = "lblApprovePageApproveDateLabel1"
        Me.lblApprovePageApproveDateLabel1.Size = New System.Drawing.Size(96, 23)
        Me.lblApprovePageApproveDateLabel1.TabIndex = 11
        Me.lblApprovePageApproveDateLabel1.Text = "Date Approved"
        Me.lblApprovePageApproveDateLabel1.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageModifierName1
        '
        Me.lblApprovePageModifierName1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageModifierName1.Location = New System.Drawing.Point(112, 24)
        Me.lblApprovePageModifierName1.Name = "lblApprovePageModifierName1"
        Me.lblApprovePageModifierName1.Size = New System.Drawing.Size(144, 23)
        Me.lblApprovePageModifierName1.TabIndex = 1
        Me.lblApprovePageModifierName1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageApproverName1
        '
        Me.lblApprovePageApproverName1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproverName1.Location = New System.Drawing.Point(360, 72)
        Me.lblApprovePageApproverName1.Name = "lblApprovePageApproverName1"
        Me.lblApprovePageApproverName1.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageApproverName1.TabIndex = 10
        Me.lblApprovePageApproverName1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageModifyDate1
        '
        Me.lblApprovePageModifyDate1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageModifyDate1.Location = New System.Drawing.Point(360, 24)
        Me.lblApprovePageModifyDate1.Name = "lblApprovePageModifyDate1"
        Me.lblApprovePageModifyDate1.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageModifyDate1.TabIndex = 3
        Me.lblApprovePageModifyDate1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageApproveDate1
        '
        Me.lblApprovePageApproveDate1.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproveDate1.Location = New System.Drawing.Point(360, 104)
        Me.lblApprovePageApproveDate1.Name = "lblApprovePageApproveDate1"
        Me.lblApprovePageApproveDate1.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageApproveDate1.TabIndex = 12
        Me.lblApprovePageApproveDate1.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnApprovePageShowSummary1
        '
        Me.btnApprovePageShowSummary1.Location = New System.Drawing.Point(496, 24)
        Me.btnApprovePageShowSummary1.Name = "btnApprovePageShowSummary1"
        Me.btnApprovePageShowSummary1.Size = New System.Drawing.Size(72, 23)
        Me.btnApprovePageShowSummary1.TabIndex = 4
        Me.btnApprovePageShowSummary1.Text = "Report"
        '
        'grpApprovePageGroup0
        '
        Me.grpApprovePageGroup0.Controls.Add(Me.Label47)
        Me.grpApprovePageGroup0.Controls.Add(Me.picApprovePageStatusImage0)
        Me.grpApprovePageGroup0.Controls.Add(Me.Label55)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageApproveStatus0)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageCheckItem0)
        Me.grpApprovePageGroup0.Controls.Add(Me.Label42)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageModifierName0)
        Me.grpApprovePageGroup0.Controls.Add(Me.Label43)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageModifyDate0)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageApproverNameLabel0)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageApproverName0)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageApproveDateLabel0)
        Me.grpApprovePageGroup0.Controls.Add(Me.lblApprovePageApproveDate0)
        Me.grpApprovePageGroup0.Controls.Add(Me.btnApprovePageShowSummary0)
        Me.grpApprovePageGroup0.Location = New System.Drawing.Point(24, 56)
        Me.grpApprovePageGroup0.Name = "grpApprovePageGroup0"
        Me.grpApprovePageGroup0.Size = New System.Drawing.Size(584, 144)
        Me.grpApprovePageGroup0.TabIndex = 1
        Me.grpApprovePageGroup0.TabStop = False
        Me.grpApprovePageGroup0.Text = "Group 0"
        '
        'Label47
        '
        Me.Label47.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label47.Location = New System.Drawing.Point(8, 72)
        Me.Label47.Name = "Label47"
        Me.Label47.Size = New System.Drawing.Size(96, 23)
        Me.Label47.TabIndex = 14
        Me.Label47.Text = "Approval Status"
        Me.Label47.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'picApprovePageStatusImage0
        '
        Me.picApprovePageStatusImage0.Location = New System.Drawing.Point(112, 72)
        Me.picApprovePageStatusImage0.Name = "picApprovePageStatusImage0"
        Me.picApprovePageStatusImage0.Size = New System.Drawing.Size(32, 32)
        Me.picApprovePageStatusImage0.TabIndex = 13
        Me.picApprovePageStatusImage0.TabStop = False
        '
        'Label55
        '
        Me.Label55.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.Label55.Location = New System.Drawing.Point(16, 56)
        Me.Label55.Name = "Label55"
        Me.Label55.Size = New System.Drawing.Size(552, 2)
        Me.Label55.TabIndex = 5
        '
        'lblApprovePageApproveStatus0
        '
        Me.lblApprovePageApproveStatus0.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproveStatus0.Location = New System.Drawing.Point(152, 72)
        Me.lblApprovePageApproveStatus0.Name = "lblApprovePageApproveStatus0"
        Me.lblApprovePageApproveStatus0.Size = New System.Drawing.Size(104, 23)
        Me.lblApprovePageApproveStatus0.TabIndex = 7
        Me.lblApprovePageApproveStatus0.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageCheckItem0
        '
        Me.lblApprovePageCheckItem0.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle
        Me.lblApprovePageCheckItem0.Location = New System.Drawing.Point(528, 72)
        Me.lblApprovePageCheckItem0.Name = "lblApprovePageCheckItem0"
        Me.lblApprovePageCheckItem0.Size = New System.Drawing.Size(40, 16)
        Me.lblApprovePageCheckItem0.TabIndex = 8
        Me.lblApprovePageCheckItem0.Visible = False
        '
        'Label42
        '
        Me.Label42.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label42.Location = New System.Drawing.Point(16, 24)
        Me.Label42.Name = "Label42"
        Me.Label42.Size = New System.Drawing.Size(88, 23)
        Me.Label42.TabIndex = 0
        Me.Label42.Text = "Modified by"
        Me.Label42.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageModifierName0
        '
        Me.lblApprovePageModifierName0.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageModifierName0.Location = New System.Drawing.Point(112, 24)
        Me.lblApprovePageModifierName0.Name = "lblApprovePageModifierName0"
        Me.lblApprovePageModifierName0.Size = New System.Drawing.Size(144, 23)
        Me.lblApprovePageModifierName0.TabIndex = 1
        Me.lblApprovePageModifierName0.Text = "Dan Christensen"
        Me.lblApprovePageModifierName0.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'Label43
        '
        Me.Label43.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label43.Location = New System.Drawing.Point(264, 24)
        Me.Label43.Name = "Label43"
        Me.Label43.Size = New System.Drawing.Size(88, 23)
        Me.Label43.TabIndex = 2
        Me.Label43.Text = "Date Modified"
        Me.Label43.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageModifyDate0
        '
        Me.lblApprovePageModifyDate0.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageModifyDate0.Location = New System.Drawing.Point(360, 24)
        Me.lblApprovePageModifyDate0.Name = "lblApprovePageModifyDate0"
        Me.lblApprovePageModifyDate0.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageModifyDate0.TabIndex = 3
        Me.lblApprovePageModifyDate0.Text = "12/31/2999 23:59"
        Me.lblApprovePageModifyDate0.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageApproverNameLabel0
        '
        Me.lblApprovePageApproverNameLabel0.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblApprovePageApproverNameLabel0.Location = New System.Drawing.Point(264, 72)
        Me.lblApprovePageApproverNameLabel0.Name = "lblApprovePageApproverNameLabel0"
        Me.lblApprovePageApproverNameLabel0.Size = New System.Drawing.Size(88, 23)
        Me.lblApprovePageApproverNameLabel0.TabIndex = 9
        Me.lblApprovePageApproverNameLabel0.Text = "Disapproved by"
        Me.lblApprovePageApproverNameLabel0.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproverName0
        '
        Me.lblApprovePageApproverName0.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproverName0.Location = New System.Drawing.Point(360, 72)
        Me.lblApprovePageApproverName0.Name = "lblApprovePageApproverName0"
        Me.lblApprovePageApproverName0.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageApproverName0.TabIndex = 10
        Me.lblApprovePageApproverName0.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblApprovePageApproveDateLabel0
        '
        Me.lblApprovePageApproveDateLabel0.Font = New System.Drawing.Font("Microsoft Sans Serif", 7.854546!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lblApprovePageApproveDateLabel0.Location = New System.Drawing.Point(256, 104)
        Me.lblApprovePageApproveDateLabel0.Name = "lblApprovePageApproveDateLabel0"
        Me.lblApprovePageApproveDateLabel0.Size = New System.Drawing.Size(96, 23)
        Me.lblApprovePageApproveDateLabel0.TabIndex = 11
        Me.lblApprovePageApproveDateLabel0.Text = "Date Approved"
        Me.lblApprovePageApproveDateLabel0.TextAlign = System.Drawing.ContentAlignment.MiddleRight
        '
        'lblApprovePageApproveDate0
        '
        Me.lblApprovePageApproveDate0.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
        Me.lblApprovePageApproveDate0.Location = New System.Drawing.Point(360, 104)
        Me.lblApprovePageApproveDate0.Name = "lblApprovePageApproveDate0"
        Me.lblApprovePageApproveDate0.Size = New System.Drawing.Size(128, 23)
        Me.lblApprovePageApproveDate0.TabIndex = 12
        Me.lblApprovePageApproveDate0.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'btnApprovePageShowSummary0
        '
        Me.btnApprovePageShowSummary0.Location = New System.Drawing.Point(496, 24)
        Me.btnApprovePageShowSummary0.Name = "btnApprovePageShowSummary0"
        Me.btnApprovePageShowSummary0.Size = New System.Drawing.Size(72, 23)
        Me.btnApprovePageShowSummary0.TabIndex = 4
        Me.btnApprovePageShowSummary0.Text = "Report"
        '
        'Label39
        '
        Me.Label39.Anchor = CType(((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Left) _
                    Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.Label39.Font = New System.Drawing.Font("Arial", 12.0!, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label39.Location = New System.Drawing.Point(24, 24)
        Me.Label39.Name = "Label39"
        Me.Label39.Size = New System.Drawing.Size(592, 24)
        Me.Label39.TabIndex = 0
        Me.Label39.Text = "Approve the norm settings"
        '
        'tpgStepFinish
        '
        Me.tpgStepFinish.Controls.Add(Me.PictureBox5)
        Me.tpgStepFinish.Controls.Add(Me.PictureBox4)
        Me.tpgStepFinish.Controls.Add(Me.Label45)
        Me.tpgStepFinish.Controls.Add(Me.PictureBox3)
        Me.tpgStepFinish.Location = New System.Drawing.Point(4, 22)
        Me.tpgStepFinish.Name = "tpgStepFinish"
        Me.tpgStepFinish.Size = New System.Drawing.Size(627, 590)
        Me.tpgStepFinish.TabIndex = 8
        Me.tpgStepFinish.Text = "Finish"
        '
        'PictureBox5
        '
        Me.PictureBox5.Image = CType(resources.GetObject("PictureBox5.Image"), System.Drawing.Image)
        Me.PictureBox5.Location = New System.Drawing.Point(172, 170)
        Me.PictureBox5.Name = "PictureBox5"
        Me.PictureBox5.Size = New System.Drawing.Size(288, 40)
        Me.PictureBox5.TabIndex = 8
        Me.PictureBox5.TabStop = False
        '
        'PictureBox4
        '
        Me.PictureBox4.Image = CType(resources.GetObject("PictureBox4.Image"), System.Drawing.Image)
        Me.PictureBox4.Location = New System.Drawing.Point(21, 24)
        Me.PictureBox4.Name = "PictureBox4"
        Me.PictureBox4.Size = New System.Drawing.Size(440, 32)
        Me.PictureBox4.TabIndex = 7
        Me.PictureBox4.TabStop = False
        '
        'Label45
        '
        Me.Label45.BackColor = System.Drawing.Color.White
        Me.Label45.Font = New System.Drawing.Font("Times New Roman", 9.818182!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label45.Location = New System.Drawing.Point(224, 216)
        Me.Label45.Name = "Label45"
        Me.Label45.Size = New System.Drawing.Size(232, 64)
        Me.Label45.TabIndex = 6
        Me.Label45.Text = "Use schedule tool to submit norm updating request"
        Me.Label45.TextAlign = System.Drawing.ContentAlignment.TopRight
        '
        'PictureBox3
        '
        Me.PictureBox3.Image = CType(resources.GetObject("PictureBox3.Image"), System.Drawing.Image)
        Me.PictureBox3.Location = New System.Drawing.Point(112, 64)
        Me.PictureBox3.Name = "PictureBox3"
        Me.PictureBox3.Size = New System.Drawing.Size(352, 304)
        Me.PictureBox3.TabIndex = 3
        Me.PictureBox3.TabStop = False
        '
        'Splitter1
        '
        Me.Splitter1.Location = New System.Drawing.Point(137, 27)
        Me.Splitter1.MinSize = 10
        Me.Splitter1.Name = "Splitter1"
        Me.Splitter1.Size = New System.Drawing.Size(8, 620)
        Me.Splitter1.TabIndex = 22
        Me.Splitter1.TabStop = False
        '
        'pnlLeft
        '
        Me.pnlLeft.BackColor = System.Drawing.Color.Black
        Me.pnlLeft.Controls.Add(Me.lblStepCriteria)
        Me.pnlLeft.Controls.Add(Me.pnlStepCriteria)
        Me.pnlLeft.Controls.Add(Me.pnlStepApproval)
        Me.pnlLeft.Controls.Add(Me.lblStepClient)
        Me.pnlLeft.Controls.Add(Me.pnlStepClient)
        Me.pnlLeft.Controls.Add(Me.lblStepFinish)
        Me.pnlLeft.Controls.Add(Me.lblStepApproval)
        Me.pnlLeft.Controls.Add(Me.lblStepRollup)
        Me.pnlLeft.Controls.Add(Me.lblStepSurvey)
        Me.pnlLeft.Controls.Add(Me.lblStepSetting)
        Me.pnlLeft.Controls.Add(Me.lblStepName)
        Me.pnlLeft.Controls.Add(Me.lblStepTask)
        Me.pnlLeft.Controls.Add(Me.lblStepStart)
        Me.pnlLeft.Controls.Add(Me.pnlStepRollup)
        Me.pnlLeft.Controls.Add(Me.pnlStepSurvey)
        Me.pnlLeft.Controls.Add(Me.pnlStepSetting)
        Me.pnlLeft.Controls.Add(Me.pnlStepName)
        Me.pnlLeft.Controls.Add(Me.pnlStepTask)
        Me.pnlLeft.Controls.Add(Me.pnlStepStart)
        Me.pnlLeft.Controls.Add(Me.pnlStepFinish)
        Me.pnlLeft.Dock = System.Windows.Forms.DockStyle.Left
        Me.pnlLeft.Location = New System.Drawing.Point(1, 27)
        Me.pnlLeft.Name = "pnlLeft"
        Me.pnlLeft.Size = New System.Drawing.Size(136, 620)
        Me.pnlLeft.TabIndex = 21
        '
        'lblStepCriteria
        '
        Me.lblStepCriteria.ForeColor = System.Drawing.Color.White
        Me.lblStepCriteria.Location = New System.Drawing.Point(56, 216)
        Me.lblStepCriteria.Name = "lblStepCriteria"
        Me.lblStepCriteria.Size = New System.Drawing.Size(88, 16)
        Me.lblStepCriteria.TabIndex = 19
        Me.lblStepCriteria.Text = "Criteria"
        Me.lblStepCriteria.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlStepCriteria
        '
        Me.pnlStepCriteria.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepCriteria.Location = New System.Drawing.Point(32, 216)
        Me.pnlStepCriteria.Name = "pnlStepCriteria"
        Me.pnlStepCriteria.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepCriteria.TabIndex = 18
        '
        'pnlStepApproval
        '
        Me.pnlStepApproval.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepApproval.Location = New System.Drawing.Point(32, 280)
        Me.pnlStepApproval.Name = "pnlStepApproval"
        Me.pnlStepApproval.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepApproval.TabIndex = 14
        '
        'lblStepClient
        '
        Me.lblStepClient.ForeColor = System.Drawing.Color.White
        Me.lblStepClient.Location = New System.Drawing.Point(56, 152)
        Me.lblStepClient.Name = "lblStepClient"
        Me.lblStepClient.Size = New System.Drawing.Size(88, 16)
        Me.lblStepClient.TabIndex = 9
        Me.lblStepClient.Text = "Clients"
        Me.lblStepClient.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlStepClient
        '
        Me.pnlStepClient.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepClient.Location = New System.Drawing.Point(32, 152)
        Me.pnlStepClient.Name = "pnlStepClient"
        Me.pnlStepClient.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepClient.TabIndex = 8
        '
        'lblStepFinish
        '
        Me.lblStepFinish.ForeColor = System.Drawing.Color.White
        Me.lblStepFinish.Location = New System.Drawing.Point(48, 312)
        Me.lblStepFinish.Name = "lblStepFinish"
        Me.lblStepFinish.Size = New System.Drawing.Size(88, 16)
        Me.lblStepFinish.TabIndex = 17
        Me.lblStepFinish.Text = "Finish"
        Me.lblStepFinish.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepApproval
        '
        Me.lblStepApproval.ForeColor = System.Drawing.Color.White
        Me.lblStepApproval.Location = New System.Drawing.Point(56, 280)
        Me.lblStepApproval.Name = "lblStepApproval"
        Me.lblStepApproval.Size = New System.Drawing.Size(88, 16)
        Me.lblStepApproval.TabIndex = 15
        Me.lblStepApproval.Text = "Approval"
        Me.lblStepApproval.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepRollup
        '
        Me.lblStepRollup.ForeColor = System.Drawing.Color.White
        Me.lblStepRollup.Location = New System.Drawing.Point(56, 248)
        Me.lblStepRollup.Name = "lblStepRollup"
        Me.lblStepRollup.Size = New System.Drawing.Size(88, 16)
        Me.lblStepRollup.TabIndex = 13
        Me.lblStepRollup.Text = "Roll Ups"
        Me.lblStepRollup.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepSurvey
        '
        Me.lblStepSurvey.ForeColor = System.Drawing.Color.White
        Me.lblStepSurvey.Location = New System.Drawing.Point(56, 184)
        Me.lblStepSurvey.Name = "lblStepSurvey"
        Me.lblStepSurvey.Size = New System.Drawing.Size(88, 16)
        Me.lblStepSurvey.TabIndex = 11
        Me.lblStepSurvey.Text = "Surveys"
        Me.lblStepSurvey.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepSetting
        '
        Me.lblStepSetting.ForeColor = System.Drawing.Color.White
        Me.lblStepSetting.Location = New System.Drawing.Point(56, 120)
        Me.lblStepSetting.Name = "lblStepSetting"
        Me.lblStepSetting.Size = New System.Drawing.Size(88, 16)
        Me.lblStepSetting.TabIndex = 7
        Me.lblStepSetting.Text = "Norm Settings"
        Me.lblStepSetting.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepName
        '
        Me.lblStepName.ForeColor = System.Drawing.Color.White
        Me.lblStepName.Location = New System.Drawing.Point(56, 88)
        Me.lblStepName.Name = "lblStepName"
        Me.lblStepName.Size = New System.Drawing.Size(88, 16)
        Me.lblStepName.TabIndex = 5
        Me.lblStepName.Text = "Norm Labels"
        Me.lblStepName.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepTask
        '
        Me.lblStepTask.ForeColor = System.Drawing.Color.White
        Me.lblStepTask.Location = New System.Drawing.Point(56, 56)
        Me.lblStepTask.Name = "lblStepTask"
        Me.lblStepTask.Size = New System.Drawing.Size(88, 16)
        Me.lblStepTask.TabIndex = 3
        Me.lblStepTask.Text = "Choose Task"
        Me.lblStepTask.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'lblStepStart
        '
        Me.lblStepStart.ForeColor = System.Drawing.Color.White
        Me.lblStepStart.Location = New System.Drawing.Point(48, 24)
        Me.lblStepStart.Name = "lblStepStart"
        Me.lblStepStart.Size = New System.Drawing.Size(88, 16)
        Me.lblStepStart.TabIndex = 1
        Me.lblStepStart.Text = "Start"
        Me.lblStepStart.TextAlign = System.Drawing.ContentAlignment.MiddleLeft
        '
        'pnlStepRollup
        '
        Me.pnlStepRollup.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepRollup.Location = New System.Drawing.Point(32, 248)
        Me.pnlStepRollup.Name = "pnlStepRollup"
        Me.pnlStepRollup.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepRollup.TabIndex = 12
        '
        'pnlStepSurvey
        '
        Me.pnlStepSurvey.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepSurvey.Location = New System.Drawing.Point(32, 184)
        Me.pnlStepSurvey.Name = "pnlStepSurvey"
        Me.pnlStepSurvey.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepSurvey.TabIndex = 10
        '
        'pnlStepSetting
        '
        Me.pnlStepSetting.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepSetting.Location = New System.Drawing.Point(32, 120)
        Me.pnlStepSetting.Name = "pnlStepSetting"
        Me.pnlStepSetting.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepSetting.TabIndex = 6
        '
        'pnlStepName
        '
        Me.pnlStepName.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepName.Location = New System.Drawing.Point(32, 88)
        Me.pnlStepName.Name = "pnlStepName"
        Me.pnlStepName.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepName.TabIndex = 4
        '
        'pnlStepTask
        '
        Me.pnlStepTask.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepTask.Location = New System.Drawing.Point(32, 56)
        Me.pnlStepTask.Name = "pnlStepTask"
        Me.pnlStepTask.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepTask.TabIndex = 2
        '
        'pnlStepStart
        '
        Me.pnlStepStart.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepStart.Location = New System.Drawing.Point(16, 24)
        Me.pnlStepStart.Name = "pnlStepStart"
        Me.pnlStepStart.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepStart.TabIndex = 0
        '
        'pnlStepFinish
        '
        Me.pnlStepFinish.BackColor = System.Drawing.Color.LightGray
        Me.pnlStepFinish.Location = New System.Drawing.Point(16, 312)
        Me.pnlStepFinish.Name = "pnlStepFinish"
        Me.pnlStepFinish.Size = New System.Drawing.Size(16, 16)
        Me.pnlStepFinish.TabIndex = 16
        '
        'pnlBottom
        '
        Me.pnlBottom.BackColor = System.Drawing.SystemColors.Control
        Me.pnlBottom.Controls.Add(Me.btnFinish)
        Me.pnlBottom.Controls.Add(Me.btnNext)
        Me.pnlBottom.Controls.Add(Me.btnBack)
        Me.pnlBottom.Controls.Add(Me.btnCancel)
        Me.pnlBottom.Dock = System.Windows.Forms.DockStyle.Bottom
        Me.pnlBottom.Location = New System.Drawing.Point(1, 647)
        Me.pnlBottom.Name = "pnlBottom"
        Me.pnlBottom.Size = New System.Drawing.Size(774, 40)
        Me.pnlBottom.TabIndex = 19
        '
        'btnFinish
        '
        Me.btnFinish.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnFinish.Location = New System.Drawing.Point(688, 8)
        Me.btnFinish.Name = "btnFinish"
        Me.btnFinish.Size = New System.Drawing.Size(72, 23)
        Me.btnFinish.TabIndex = 3
        Me.btnFinish.Text = "&Finish"
        '
        'btnNext
        '
        Me.btnNext.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnNext.Location = New System.Drawing.Point(608, 8)
        Me.btnNext.Name = "btnNext"
        Me.btnNext.TabIndex = 2
        Me.btnNext.Text = "&Next >>"
        '
        'btnBack
        '
        Me.btnBack.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnBack.Location = New System.Drawing.Point(528, 8)
        Me.btnBack.Name = "btnBack"
        Me.btnBack.TabIndex = 1
        Me.btnBack.Text = "<< &Back"
        '
        'btnCancel
        '
        Me.btnCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.btnCancel.Location = New System.Drawing.Point(448, 8)
        Me.btnCancel.Name = "btnCancel"
        Me.btnCancel.TabIndex = 0
        Me.btnCancel.Text = "&Cancel"
        '
        'imlApproval
        '
        Me.imlApproval.ImageSize = New System.Drawing.Size(32, 32)
        Me.imlApproval.ImageStream = CType(resources.GetObject("imlApproval.ImageStream"), System.Windows.Forms.ImageListStreamer)
        Me.imlApproval.TransparentColor = System.Drawing.Color.Transparent
        '
        'CanadaNormSettingWizard
        '
        Me.AutoScroll = True
        Me.Controls.Add(Me.pnlBackPanel)
        Me.Name = "CanadaNormSettingWizard"
        Me.Size = New System.Drawing.Size(776, 688)
        Me.AutoScrollMinSize = Me.Size
        Me.pnlBackPanel.ResumeLayout(False)
        Me.pnlRight.ResumeLayout(False)
        Me.tabWizard.ResumeLayout(False)
        Me.tpgStepStart.ResumeLayout(False)
        Me.tpgStepTask.ResumeLayout(False)
        Me.tpgStepName.ResumeLayout(False)
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox1.ResumeLayout(False)
        Me.tpgStepSetting.ResumeLayout(False)
        CType(Me.nudSettingPageLpSurvey, System.ComponentModel.ISupportInitialize).EndInit()
        CType(Me.nudSettingPageHpSurvey, System.ComponentModel.ISupportInitialize).EndInit()
        Me.tpgStepClient.ResumeLayout(False)
        Me.pnlClientPageBack.ResumeLayout(False)
        Me.pnlClientPageBackRight.ResumeLayout(False)
        Me.Panel3.ResumeLayout(False)
        Me.pnlClientPageSplitter.ResumeLayout(False)
        Me.pnlClientPageButtons.ResumeLayout(False)
        Me.pnlClientPageBackLeft.ResumeLayout(False)
        Me.tpgStepSurvey.ResumeLayout(False)
        Me.tpgStepCriteria.ResumeLayout(False)
        Me.tpgStepRollup.ResumeLayout(False)
        Me.tpgStepApproval.ResumeLayout(False)
        Me.grpApprovePageGroup2.ResumeLayout(False)
        Me.grpApprovePageGroup1.ResumeLayout(False)
        Me.grpApprovePageGroup0.ResumeLayout(False)
        Me.tpgStepFinish.ResumeLayout(False)
        Me.pnlLeft.ResumeLayout(False)
        Me.pnlBottom.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub

#End Region

#Region " Public Methods"

    Public Sub Start()
        ResetWizard()
        mWizard.CurrentStep = WizardStep.Start
    End Sub

#End Region

#Region " Event Handlers for overall"

    Private Sub BackPanel_Paint(ByVal sender As System.Object, ByVal e As System.Windows.Forms.PaintEventArgs) Handles pnlLeft.Paint
        'Draw rectangle of step cycle 
        Dim p As New Pen(Color.White, 1)
        Dim rect As New Rectangle(24, 32, pnlStepStart.Width, pnlStepStart.Width * 2 * WizardStep.Finish)
        Dim gr As Graphics = e.Graphics
        gr.DrawRectangle(p, rect)
    End Sub

    Private Sub btnCancel_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancel.Click
        Me.Start()
    End Sub

    Private Sub btnBack_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnBack.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            mWizard.MoveBack()
        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub btnNext_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnNext.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            mWizard.MoveNext()
        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub btnFinish_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnFinish.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            mWizard.Finish()
        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub Wizard_Validate(ByVal currentStep As Integer, ByRef CancelMove As Boolean) Handles mWizard.Validate
        Select Case currentStep
            Case WizardStep.ChooseTask
                ValidateChooseTaskPage(currentStep, CancelMove)
            Case WizardStep.NormNames
                ValidateNormNamePage(currentStep, CancelMove)
            Case WizardStep.NormSettings
                ValidateNormSettingPage(currentStep, CancelMove)
            Case WizardStep.Clients
                ValidateNormClientPage(currentStep, CancelMove)
            Case WizardStep.Surveys
                ValidateNormSurveyPage(currentStep, CancelMove)
            Case WizardStep.Criteria
                ValidateNormCriteriaPage(currentStep, CancelMove)
            Case WizardStep.Rollups
                ValidateNormRollupPage(currentStep, CancelMove)
        End Select
    End Sub

    Private Sub mWizard_DisplayStep(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean) Handles mWizard.DisplayStep
        Dim wizardData As MapWizardData = CType(page, MapWizardData)
        Dim i As Integer

        'Set color for step boxes, set font for step labels
        For i = 0 To mWizardData.Length - 1
            With mWizardData(i)
                .StepBox.BackColor = .StepBoxColor
                .StepLabel.Font = .StepLabelFont
            End With
        Next

        'Select tab
        tabWizard.SelectedIndex = wizardData.StepID

        'Set wizard navigating buttons
        With wizardData
            btnCancel.Enabled = .EnableCancelButton
            btnCancel.Text = .CancelButtonText

            btnBack.Enabled = .EnableBackButton
            btnBack.Text = .BackButtonText

            btnNext.Enabled = .EnableNextButton
            btnNext.Text = .NextButtonText

            btnFinish.Enabled = .EnableFinishButton
            btnFinish.Text = .FinishButtonText
        End With

        Select Case currentStep
            Case WizardStep.ChooseTask
                DisplayChooseTaskPage(currentStep, page, moveForward)
            Case WizardStep.NormNames
                DisplayNormNamesPage(currentStep, page, moveForward)
            Case WizardStep.NormSettings
                DisplayNormSettingPage(currentStep, page, moveForward)
            Case WizardStep.Surveys
                DisplayNormSurveyPage(currentStep, page, moveForward)
            Case WizardStep.Criteria
                DisplayNormCriteriaPage(currentStep, page, moveForward)
            Case WizardStep.Rollups
                DisplayNormRollupPage(currentStep, page, moveForward)
            Case WizardStep.Approval
                DisplayNormApprovePage(currentStep, page, moveForward)
        End Select

    End Sub

    Private Sub mWizard_Terminate(ByVal currentStep As Integer) Handles mWizard.Terminate
        'Save all the settings to DB
        If (currentStep > WizardStep.ChooseTask AndAlso currentStep < WizardStep.Rollups) Then
            Me.mController.UpdateNormSettings()
        End If

        'Restart wizard
        Me.Start()
    End Sub

#End Region

#Region " Event Handlers of <Choose Task> page"

    Private Sub optTaskPageNewNorm_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optTaskPageNewNorm.CheckedChanged
        lvwTaskPageNorm.Enabled = False
    End Sub

    Private Sub optTaskPageUpdateNorm_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles optTaskPageUpdateNorm.CheckedChanged
        lvwTaskPageNorm.Enabled = True
        lvwTaskPageNorm.Focus()
    End Sub

    Private Sub lvwTaskPageNorm_DoubleClick(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwTaskPageNorm.DoubleClick
        mWizard.MoveNext()
    End Sub

    Private Sub lvwTaskPageNorm_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwTaskPageNorm.SizeChanged
        ListViewResize(CType(sender, ListView), TaskPageListField.NormName, 2, TaskPageListField.NormDescription, 3)
    End Sub

#End Region

#Region " Event Handlers of <Norm Names> page"

    Private Sub chkNamePageAvgComp_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkNamePageAvgComp.CheckedChanged
        If (chkNamePageAvgComp.Checked) Then
            txtNamePageAvgCompLabel.Enabled = True
            txtNamePageAvgCompDescription.Enabled = True
        Else
            txtNamePageAvgCompLabel.Enabled = False
            txtNamePageAvgCompDescription.Enabled = False
        End If
    End Sub

    Private Sub chkNamePageHpComp_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkNamePageHpComp.CheckedChanged
        If (chkNamePageHpComp.Checked) Then
            txtNamePageHpCompLabel.Enabled = True
            txtNamePageHpCompDescription.Enabled = True
        Else
            txtNamePageHpCompLabel.Enabled = False
            txtNamePageHpCompDescription.Enabled = False
        End If
    End Sub

    Private Sub chkNamePageLpComp_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkNamePageLpComp.CheckedChanged
        If (chkNamePageLpComp.Checked) Then
            txtNamePageLpCompLabel.Enabled = True
            txtNamePageLpCompDescription.Enabled = True
        Else
            txtNamePageLpCompLabel.Enabled = False
            txtNamePageLpCompDescription.Enabled = False
        End If
    End Sub

#End Region

#Region " Event Handlers of <Client> page"

    Private Sub pnlClientPageBack_SizeChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles pnlClientPageBack.SizeChanged
        pnlClientPageBackLeft.Width = (pnlClientPageBack.Width - splClientPageSplitter.Width - pnlClientPageSplitter.Width) \ 2
    End Sub

    Private Sub pnlClientPageSplitter_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles pnlClientPageSplitter.SizeChanged
        pnlClientPageButtons.Top = (pnlClientPageSplitter.Height - pnlClientPageButtons.Height) \ 2
    End Sub

    Private Sub lvwClientPageList_SizeChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles lvwClientPageUsedClient.SizeChanged, lvwClientPageUnusedClient.SizeChanged
        ListViewResize(CType(sender, ListView), ClientPageListField.ClientName)
    End Sub

    Private Sub btnClientPageSelectAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClientPageSelectAll.Click
        ClientPageMoveClient(lvwClientPageUnusedClient, lvwClientPageUsedClient, False)
    End Sub

    Private Sub btnClientPageSelect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClientPageSelect.Click
        ClientPageMoveClient(lvwClientPageUnusedClient, lvwClientPageUsedClient, True)
    End Sub

    Private Sub btnClientPageUnselect_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClientPageUnselect.Click
        ClientPageMoveClient(lvwClientPageUsedClient, lvwClientPageUnusedClient, True)
    End Sub

    Private Sub btnClientPageUnselectAll_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnClientPageUnselectAll.Click
        ClientPageMoveClient(lvwClientPageUsedClient, lvwClientPageUnusedClient, False)
    End Sub

    Private Sub lvwClientPageUnusedClient_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwClientPageUnusedClient.DoubleClick
        ClientPageMoveClient(lvwClientPageUnusedClient, lvwClientPageUsedClient, True)
    End Sub

    Private Sub lvwClientPageUsedClient_DoubleClick(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwClientPageUsedClient.DoubleClick
        ClientPageMoveClient(lvwClientPageUsedClient, lvwClientPageUnusedClient, True)
    End Sub

#End Region

#Region " Event Handlers of <Survey> page"

    Private Sub lnkSurveyPageSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkSurveyPageSelectAll.LinkClicked
        mTriggeredByProgram = True
        lvwSurveyPageList.SetAllChecked(True)
        lblSurveyPageSelectCount.Text = lvwSurveyPageList.CheckedItems.Count.ToString
        lvwSurveyPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkSurveyPageDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkSurveyPageDeselectAll.LinkClicked
        mTriggeredByProgram = True
        lvwSurveyPageList.SetAllChecked(False)
        lblSurveyPageSelectCount.Text = lvwSurveyPageList.CheckedItems.Count.ToString
        lvwSurveyPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkSurveyPageSelectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkSurveyPageSelectHighlight.LinkClicked
        mTriggeredByProgram = True
        lvwSurveyPageList.SetSelectedChecked(True)
        lblSurveyPageSelectCount.Text = lvwSurveyPageList.CheckedItems.Count.ToString
        lvwSurveyPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkSurveyPageDeselectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkSurveyPageDeselectHighlight.LinkClicked
        mTriggeredByProgram = True
        lvwSurveyPageList.SetSelectedChecked(False)
        lblSurveyPageSelectCount.Text = lvwSurveyPageList.CheckedItems.Count.ToString
        lvwSurveyPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lvwSurveyPageList_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwSurveyPageList.ItemCheck
        If (Me.mTriggeredByProgram) Then Return

        Dim lvw As ListView = CType(sender, ListView)
        Dim count As Integer = lvw.CheckedItems.Count
        If (e.CurrentValue <> e.NewValue) Then
            If (e.NewValue = CheckState.Checked) Then count += 1
            If (e.NewValue = CheckState.Unchecked) Then count -= 1
        End If
        lblSurveyPageSelectCount.Text = count.ToString
    End Sub

    Private Sub lvwSurveyPageList_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwSurveyPageList.SizeChanged
        With lvwSurveyPageList
            Dim width As Integer = .Width
            width -= .Columns(SurveyPageListField.ClientID).Width
            width -= .Columns(SurveyPageListField.StudyID).Width
            width -= .Columns(SurveyPageListField.SurveyID).Width
            width -= ComponentSize.ScrollBar

            .Columns(SurveyPageListField.StudyName).Width = width * 2 \ 9
            .Columns(SurveyPageListField.SurveyName).Width = width * 3 \ 9
            .Columns(SurveyPageListField.ClientName).Width = width - .Columns(SurveyPageListField.StudyName).Width - .Columns(SurveyPageListField.SurveyName).Width
        End With
    End Sub

    Private Sub lvwSurveyPageList_Sorted(ByVal sender As Object, ByVal e As NRC.WinForms.ListViewSortedEventArgs) Handles lvwSurveyPageList.Sorted
        Dim lvw As NRCListView = CType(sender, NRCListView)
        lvw.BeginUpdate()
        lvw.AutoFitColumnWidth()
        lvw.AutoAdjustColumnWidth()
        lvw.PaintAlternatingBackColor()
        lvw.EndUpdate()
    End Sub

    Private Sub btnSurveyPageLoad_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnSurveyPageLoad.Click
        LoadSurveyFromFile()
    End Sub

#End Region

#Region " Event Handlers of <Criteria> page"

    Private Sub txtCriteriaPageCriteria_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles txtCriteriaPageCriteria.TextChanged
        If (txtCriteriaPageCriteria.Text.Trim = "") Then
            lnkCriteriaPageCheck.Enabled = False
        Else
            lnkCriteriaPageCheck.Enabled = True
        End If
    End Sub

    Private Sub lnkCriteriaPageCheck_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkCriteriaPageCheck.LinkClicked
        Dim criteriaStmt As String = txtCriteriaPageCriteria.Text.Trim
        Dim errMsg As String = String.Empty

        Try
            Me.Cursor = Cursors.WaitCursor

            If (Me.mController.NormSetting.IsCriteriaCorrect(criteriaStmt, errMsg)) Then
                MessageBox.Show("Syntax Check Successful ", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Information)
                lnkCriteriaPageCheck.Enabled = False
            Else
                MessageBox.Show(errMsg, CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error)
            End If

        Catch ex As Exception
            ReportException(ex)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub lnkCriteriaPageHelp_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkCriteriaPageHelp.LinkClicked
        Try
            Me.Cursor = Cursors.WaitCursor
            Dim dlg As New TableColumnDialog
            dlg.NormSetting = Me.mController.NormSetting
            dlg.ShowDialog()

        Catch ex As Exception
            ReportException(ex)
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

#End Region

#Region " Event Handlers of <Rollup> page"

    Private Sub lnkRollupPageSelectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkRollupPageSelectAll.LinkClicked
        mTriggeredByProgram = True
        lvwRollupPageList.SetAllChecked(True)
        lblRollupPageSelectCount.Text = lvwRollupPageList.CheckedItems.Count.ToString
        lvwRollupPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkRollupPageDeselectAll_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkRollupPageDeselectAll.LinkClicked
        mTriggeredByProgram = True
        lvwRollupPageList.SetAllChecked(False)
        lblRollupPageSelectCount.Text = lvwRollupPageList.CheckedItems.Count.ToString
        lvwRollupPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkRollupPageSelectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkRollupPageSelectHighlight.LinkClicked
        mTriggeredByProgram = True
        lvwRollupPageList.SetSelectedChecked(True)
        lblRollupPageSelectCount.Text = lvwRollupPageList.CheckedItems.Count.ToString
        lvwRollupPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lnkRollupPageDeselectHighlight_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles lnkRollupPageDeselectHighlight.LinkClicked
        mTriggeredByProgram = True
        lvwRollupPageList.SetSelectedChecked(False)
        lblRollupPageSelectCount.Text = lvwRollupPageList.CheckedItems.Count.ToString
        lvwRollupPageList.Focus()
        mTriggeredByProgram = False
    End Sub

    Private Sub lvwRollupPageList_ItemCheck(ByVal sender As Object, ByVal e As System.Windows.Forms.ItemCheckEventArgs) Handles lvwRollupPageList.ItemCheck
        If (Me.mTriggeredByProgram) Then Return

        Dim lvw As ListView = CType(sender, ListView)
        Dim count As Integer = lvw.CheckedItems.Count
        If (e.CurrentValue <> e.NewValue) Then
            If (e.NewValue = CheckState.Checked) Then count += 1
            If (e.NewValue = CheckState.Unchecked) Then count -= 1
        End If
        lblRollupPageSelectCount.Text = count.ToString
    End Sub

    Private Sub lvwRollupPageList_SizeChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles lvwRollupPageList.SizeChanged
        ListViewResize(CType(sender, ListView), RollupPageListField.RollupName, 2, RollupPageListField.RollupDescription, 3)
    End Sub

#End Region

#Region " Event Handlers of <Approve> page"

    Private Sub btnApprovePageShowSummary_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnApprovePageShowSummary0.Click, btnApprovePageShowSummary1.Click, btnApprovePageShowSummary2.Click
        Dim btnApprovePageShowSummary As Button = CType(sender, Button)
        Dim group As Integer
        Dim checkItem As CanadaNormSettingApprove.CheckItemType

        For group = 0 To 2
            If (btnApprovePageShowSummary Is mApprovePageSummaryButtons(group)) Then
                Exit For
            End If
        Next

        checkItem = CType(mApprovePageCheckItems(group).Text, CanadaNormSettingApprove.CheckItemType)
        Dim approve As CanadaNormSettingApprove = Me.mController.ApproveInfo.Approve(checkItem)
        If (approve Is Nothing) Then Return

        Dim reportViewer As New frmReportReviewer

        Select Case checkItem
            Case CanadaNormSettingApprove.CheckItemType.GeneralSettings
                reportViewer.LoadGeneralSettingReport(Me.mController.NormSetting)
            Case CanadaNormSettingApprove.CheckItemType.SurveySelection
                reportViewer.LoadSurveySelectionReport(Me.mController.NormSetting)
            Case CanadaNormSettingApprove.CheckItemType.RollupSelection
                reportViewer.LoadRollupSelectionReport(Me.mController.NormSetting)
        End Select

        Dim result As DialogResult = reportViewer.ShowDialog(Me)
        Select Case result
            Case DialogResult.Yes
                approve.SetApproveStatus(CanadaNormSettingApprove.ApproveStatusType.Approved, _
                                         CurrentUser.Member.MemberId)
                ShowApproveInfo()
            Case DialogResult.No
                approve.SetApproveStatus(CanadaNormSettingApprove.ApproveStatusType.Disapproved, _
                                         CurrentUser.Member.MemberId)
                ShowApproveInfo()
        End Select

        reportViewer = Nothing
        Me.mController.NormSetting.ReportDateBegin.ToShortDateString()
    End Sub

#End Region

#Region " Private Methods of overall"

    Private Sub InitWizardStepInfo()
        mWizardData(WizardStep.Start) = _
                    New MapWizardData(WizardStep.Start, pnlStepStart, lblStepStart, True, False, True, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.ChooseTask) = _
                    New MapWizardData(WizardStep.ChooseTask, pnlStepTask, lblStepTask, True, True, True, False, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.NormNames) = _
                    New MapWizardData(WizardStep.NormNames, pnlStepName, lblStepName, True, True, True, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.NormSettings) = _
                    New MapWizardData(WizardStep.NormSettings, pnlStepSetting, lblStepSetting, True, True, True, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Clients) = _
                    New MapWizardData(WizardStep.Clients, pnlStepClient, lblStepClient, True, True, True, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Surveys) = _
                    New MapWizardData(WizardStep.Surveys, pnlStepSurvey, lblStepSurvey, True, True, True, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Criteria) = _
                    New MapWizardData(WizardStep.Criteria, pnlStepCriteria, lblStepCriteria, True, True, True, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Rollups) = _
                    New MapWizardData(WizardStep.Rollups, pnlStepRollup, lblStepRollup, True, True, True, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Approval) = _
                    New MapWizardData(WizardStep.Approval, pnlStepApproval, lblStepApproval, True, True, True, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON)
        mWizardData(WizardStep.Finish) = _
                    New MapWizardData(WizardStep.Finish, pnlStepFinish, lblStepFinish, False, False, False, True, CANCEL_BUTTON, BACK_BUTTON, NEXT_BUTTON, FINISH_BUTTON, Color.Red)

    End Sub

    Private Sub ResetWizard()
        Dim i As Integer

        'Reset wizard step objects
        For i = 0 To mWizardData.Length - 1
            mWizardData(i).Reset()
        Next

        'Reset caption
        pnlBackPanel.Caption = CAPTION

        'New norm group object
        mController = New CanadaNormSettingController

        'Pulling norm group list
        ShowCanadaNormList()

    End Sub

    Private Sub ListViewResize(ByVal lvw As ListView, ByVal resizableColumnIndex As Integer)
        If (lvw Is Nothing OrElse lvw.Columns.Count = 0) Then Return
        Dim width As Integer
        Dim column As ColumnHeader
        Dim columnId As Integer = 0

        With lvw
            width = .Width
            For Each column In .Columns
                If (columnId <> resizableColumnIndex) Then
                    width -= column.Width
                End If
                columnId += 1
            Next
            width -= ComponentSize.ScrollBar
            If width < ComponentSize.MinColumnSize Then width = ComponentSize.MinColumnSize
            .Columns(resizableColumnIndex).Width = width
        End With

    End Sub

    Private Sub ListViewResize(ByVal lvw As ListView, ByVal resizableColumnIndex1 As Integer, ByVal proportion1 As Double, ByVal resizableColumnIndex2 As Integer, ByVal proportion2 As Double)
        If (lvw Is Nothing OrElse lvw.Columns.Count = 0) Then Return
        Dim width As Integer
        Dim column As ColumnHeader
        Dim columnId As Integer = 0

        With lvw
            width = .Width
            For Each column In .Columns
                If (columnId <> resizableColumnIndex1 AndAlso _
                    columnId <> resizableColumnIndex2) Then
                    width -= column.Width
                End If
                columnId += 1
            Next
            width -= ComponentSize.ScrollBar
            Dim width1 As Integer = CInt(Math.Round(width * proportion1 / (proportion1 + proportion2), 0))
            Dim width2 As Integer = width - width1
            If width1 < 50 Then width1 = 50
            .Columns(resizableColumnIndex1).Width = width1
            If width2 < 50 Then width2 = 50
            .Columns(resizableColumnIndex2).Width = width2
        End With

    End Sub

    Private Sub ShowCanadaNormList()
        Dim itmListItem As ListViewItem
        Dim name As String
        Dim normID As Integer
        Dim description As String

        Dim dr As System.Data.SqlClient.SqlDataReader = Me.mController.SelectNormList

        lvwTaskPageNorm.BeginUpdate()
        lvwTaskPageNorm.Items.Clear()
        Do While dr.Read
            name = CStr(dr("NormLabel"))
            normID = CInt(dr("Norm_ID"))
            description = CStr(dr("NormDescription"))

            itmListItem = New ListViewItem(name)
            itmListItem.SubItems.Add(normID.ToString)
            itmListItem.SubItems.Add(description)
            lvwTaskPageNorm.Items.Add(itmListItem)
        Loop
        dr.Close()

        lvwTaskPageNorm.SortColumn = TaskPageListField.NormName
        lvwTaskPageNorm.SortOrder = SortOrder.Ascend
        If (lvwTaskPageNorm.Items.Count > 0) Then
            lvwTaskPageNorm.Items(0).Selected = True
        End If
        lvwTaskPageNorm.EndUpdate()

    End Sub

    Private Sub ShowNormInfoPages()
        ShowNormNamesPage()
        ShowNormSettingPage()
        ShowClientPage()
        ShowCriteriaPage()
        DisplayNormName()
    End Sub

    Private Sub ShowNormNamesPage()
        Dim normSetting As CanadaNormSetting = mController.NormSetting
        Dim comparisons As ComparisonTypeCollection = mController.ComparisonTypes
        Dim comparison As ComparisonType

        'Clear norm info
        lblNamePageNormID.Text = ""
        txtNamePageNormLabel.Text = ""
        txtNamePageNormDescription.Text = ""

        'Show norm info
        If normSetting.Task = TaskType.UpdateNorm Then
            lblNamePageNormID.Text = normSetting.NormID.ToString
        End If
        txtNamePageNormLabel.Text = normSetting.NormLabel
        txtNamePageNormDescription.Text = normSetting.NormDescription

        'Clear comparison types
        chkNamePageAvgComp.Checked = False
        chkNamePageAvgComp.Enabled = True
        lblNamePageAvgCompID.Text = ""
        txtNamePageAvgCompLabel.Text = ""
        txtNamePageAvgCompDescription.Text = ""
        txtNamePageAvgCompLabel.Enabled = False
        txtNamePageAvgCompDescription.Enabled = False

        chkNamePageHpComp.Checked = False
        chkNamePageHpComp.Enabled = True
        lblNamePageHpCompID.Text = ""
        txtNamePageHpCompLabel.Text = ""
        txtNamePageHpCompDescription.Text = ""
        txtNamePageHpCompLabel.Enabled = False
        txtNamePageHpCompDescription.Enabled = False

        chkNamePageLpComp.Checked = False
        chkNamePageLpComp.Enabled = True
        lblNamePageLpCompID.Text = ""
        txtNamePageLpCompLabel.Text = ""
        txtNamePageLpCompDescription.Text = ""
        txtNamePageLpCompLabel.Enabled = False
        txtNamePageLpCompDescription.Enabled = False

        'Show comparison types

        For Each comparison In comparisons
            Select Case comparison.NormType
                Case NormType.StandardNorm
                    chkNamePageAvgComp.Checked = True
                    If comparison.Task = TaskType.UpdateNorm Then
                        chkNamePageAvgComp.Enabled = False
                        lblNamePageAvgCompID.Text = comparison.CompTypeID.ToString
                    End If
                    txtNamePageAvgCompLabel.Text = comparison.SelectionBox
                    txtNamePageAvgCompDescription.Text = comparison.Description
                    txtNamePageAvgCompLabel.Enabled = True
                    txtNamePageAvgCompDescription.Enabled = True

                Case NormType.BestNorm
                    chkNamePageHpComp.Checked = True
                    If comparison.Task = TaskType.UpdateNorm Then
                        chkNamePageHpComp.Enabled = False
                        lblNamePageHpCompID.Text = comparison.CompTypeID.ToString
                    End If
                    txtNamePageHpCompLabel.Text = comparison.SelectionBox
                    txtNamePageHpCompDescription.Text = comparison.Description
                    txtNamePageHpCompLabel.Enabled = True
                    txtNamePageHpCompDescription.Enabled = True

                Case NormType.WorstNorm
                    chkNamePageLpComp.Checked = True
                    If comparison.Task = TaskType.UpdateNorm Then
                        chkNamePageLpComp.Enabled = False
                        lblNamePageLpCompID.Text = comparison.CompTypeID.ToString
                    End If
                    txtNamePageLpCompLabel.Text = comparison.SelectionBox
                    txtNamePageLpCompDescription.Text = comparison.Description
                    txtNamePageLpCompLabel.Enabled = True
                    txtNamePageLpCompDescription.Enabled = True

            End Select
        Next

    End Sub

    Private Sub ShowNormSettingPage()
        Dim normSetting As CanadaNormSetting = mController.NormSetting
        Dim comparisons As ComparisonTypeCollection = mController.ComparisonTypes
        Dim comparison As ComparisonType

        chkSettingPageWeight.Checked = normSetting.Weighted
        dtpSettingPageReportDateBegin.Value = normSetting.ReportDateBegin
        dtpSettingPageReportDateEnd.Value = normSetting.ReportDateEnd
        dtpSettingPageReturnDateMax.Value = normSetting.ReturnDateMax
        nudSettingPageHpSurvey.Enabled = False
        nudSettingPageLpSurvey.Enabled = False
        For Each comparison In comparisons
            Select Case comparison.NormType
                Case NormType.BestNorm
                    nudSettingPageHpSurvey.Value = comparison.UnitIncludedInBenchmarkNorm
                    nudSettingPageHpSurvey.Enabled = True
                Case NormType.WorstNorm
                    nudSettingPageLpSurvey.Value = comparison.UnitIncludedInBenchmarkNorm
                    nudSettingPageLpSurvey.Enabled = True
            End Select
        Next
    End Sub

    Private Sub ShowClientPage()
        Dim item As ListViewItem
        Dim clientName As String
        Dim clientID As Integer
        Dim rdr As System.Data.SqlClient.SqlDataReader

        'Show unused clients
        lvwClientPageUnusedClient.BeginUpdate()
        lvwClientPageUnusedClient.Items.Clear()
        rdr = mController.SelectClientUnused
        Do While rdr.Read
            clientName = CStr(rdr("strClient_NM"))
            clientID = CInt(rdr("Client_ID"))
            item = New ListViewItem(clientName)
            item.SubItems.Add(clientID.ToString)
            lvwClientPageUnusedClient.Items.Add(item)
        Loop
        If (Not rdr Is Nothing) Then rdr.Close()
        lvwClientPageUnusedClient.SortColumn = ClientPageListField.ClientName
        lvwClientPageUnusedClient.SortOrder = NRC.WinForms.SortOrder.Ascend
        lvwClientPageUnusedClient.EndUpdate()

        'Show used clients
        lvwClientPageUsedClient.BeginUpdate()
        lvwClientPageUsedClient.Items.Clear()
        rdr = mController.SelectClientUsed
        Do While rdr.Read
            clientName = CStr(rdr("strClient_NM"))
            clientID = CInt(rdr("Client_ID"))
            item = New ListViewItem(clientName)
            item.SubItems.Add(clientID.ToString)
            lvwClientPageUsedClient.Items.Add(item)
        Loop
        If (Not rdr Is Nothing) Then rdr.Close()

        lvwClientPageUsedClient.SortColumn = ClientPageListField.ClientName
        lvwClientPageUsedClient.SortOrder = NRC.WinForms.SortOrder.Ascend
        lvwClientPageUsedClient.EndUpdate()

    End Sub

    Private Sub ShowCriteriaPage()
        txtCriteriaPageCriteria.Text = Me.mController.NormSetting.CriteriaStmt
        lnkCriteriaPageCheck.Enabled = False
    End Sub

    Private Sub DisplayNormName()
        Dim normLabel As String = String.Empty

        If (Me.mController.NormSetting.NormLabel <> "") Then
            normLabel = " - " + Me.mController.NormSetting.NormLabel
            If (Me.mController.NormSetting.NormID = 0) Then
                normLabel += " (new)"
            Else
                normLabel += " (" & Me.mController.NormSetting.NormID & ")"
            End If
        End If

        pnlBackPanel.Caption = CAPTION + normLabel
    End Sub

#End Region

#Region " Private Methods of <Client> page"

    Private Sub ClientPageMoveClient(ByVal lvwSrc As NRCListView, ByVal lvwDest As NRCListView, ByVal highlightedOnly As Boolean)
        Dim item As ListViewItem = Nothing

        lvwSrc.BeginUpdate()
        lvwDest.BeginUpdate()

        For Each item In lvwDest.SelectedItems
            item.Selected = False
        Next

        If (highlightedOnly) Then
            For Each item In lvwSrc.SelectedItems
                lvwSrc.Items.Remove(item)
                lvwDest.Items.Add(item).Selected = True
            Next
        Else
            For Each item In lvwSrc.Items
                lvwSrc.Items.Remove(item)
                lvwDest.Items.Add(item).Selected = True
            Next
        End If

        If (item IsNot Nothing) Then
            lvwDest.Sort()
            item.EnsureVisible()
            item.Focused = True
            'lvwDest.Focus()
        End If

        lvwSrc.EndUpdate()
        lvwDest.EndUpdate()
    End Sub

#End Region

#Region " Private Methods of <Survey> page"

    Private Sub LoadSurveyFromFile()
        Dim rdr As System.Data.SqlClient.SqlDataReader = Nothing

        Try
            'Select file to load
            Dim ofdSurveyFile As New OpenFileDialog
            Dim path As String

            With ofdSurveyFile
                .CheckFileExists = True
                .ShowReadOnly = True
                .Filter = "All Files|*.*|Text Files (*.txt, *.dat)|*.txt;*.dat"
                .FilterIndex = 2
                .Multiselect = False
                .Title = CAPTION
                If .ShowDialog <> DialogResult.OK Then Return
                path = .FileName
            End With
            Me.Cursor = Cursors.WaitCursor

            'Load file
            rdr = Me.mController.LoadSurveyFromFile(path)
            If (rdr Is Nothing) Then
                MessageBox.Show("There is no survey in this file", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return
            End If

            'Show loaded surveys
            Dim item As ListViewItem
            Dim clientName As New StringBuilder
            Dim clientID As Integer
            Dim studyName As New StringBuilder
            Dim studyID As Integer
            Dim surveyName As New StringBuilder
            Dim surveyID As Integer

            Me.mTriggeredByProgram = True
            lvwSurveyPageList.BeginUpdate()
            lvwSurveyPageList.Items.Clear()

            Do While rdr.Read
                clientName.Remove(0, clientName.Length)
                clientName.Append(rdr("strClient_NM"))
                clientID = CInt(rdr("Client_ID"))
                studyName.Remove(0, studyName.Length)
                studyName.Append(rdr("strStudy_NM"))
                studyID = CInt(rdr("Study_ID"))
                surveyName.Remove(0, surveyName.Length)
                surveyName.Append(rdr("strSurvey_NM"))
                surveyID = CInt(rdr("Survey_ID"))

                item = New ListViewItem(clientName.ToString)
                item.SubItems.Add(clientID.ToString)
                item.SubItems.Add(studyName.ToString)
                item.SubItems.Add(studyID.ToString)
                item.SubItems.Add(surveyName.ToString)
                item.SubItems.Add(surveyID.ToString)
                item.Checked = True
                lvwSurveyPageList.Items.Add(item)
            Loop

            If (lvwSurveyPageList.SortColumn = -1 OrElse lvwSurveyPageList.SortOrder = SortOrder.NotSorted) Then
                lvwSurveyPageList.SortColumn = SurveyPageListField.ClientName
                lvwSurveyPageList.SortOrder = SortOrder.Ascend
            Else
                lvwSurveyPageList.Sort()
            End If

            Me.mTriggeredByProgram = False

            lblSurveyPageTotalCount.Text = lvwSurveyPageList.Items.Count.ToString
            lblSurveyPageSelectCount.Text = lvwSurveyPageList.CheckedItems.Count.ToString

        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
            lvwSurveyPageList.EndUpdate()
            mTriggeredByProgram = False
            Me.Cursor = Cursors.Default
        End Try

    End Sub


#End Region

#Region " Private Methods of <Approve> page"

    Private Sub InitApprovePageControls()
        mApprovePageCheckItems = New Label() {lblApprovePageCheckItem0, lblApprovePageCheckItem1, lblApprovePageCheckItem2}
        mApprovePageSummaryButtons = New Button() {btnApprovePageShowSummary0, btnApprovePageShowSummary1, btnApprovePageShowSummary2}
        mApprovePageGroups = New GroupBox() {grpApprovePageGroup0, grpApprovePageGroup1, grpApprovePageGroup2}
        mApprovePageModifierNames = New Label() {lblApprovePageModifierName0, lblApprovePageModifierName1, lblApprovePageModifierName2}
        mApprovePageModifyDates = New Label() {lblApprovePageModifyDate0, lblApprovePageModifyDate1, lblApprovePageModifyDate2}
        mApprovePageApproveStatus = New Label() {lblApprovePageApproveStatus0, lblApprovePageApproveStatus1, lblApprovePageApproveStatus2}
        mApprovePageApproverNameLabels = New Label() {lblApprovePageApproverNameLabel0, lblApprovePageApproverNameLabel1, lblApprovePageApproverNameLabel2}
        mApprovePageApproverNames = New Label() {lblApprovePageApproverName0, lblApprovePageApproverName1, lblApprovePageApproverName2}
        mApprovePageApproveDateLabels = New Label() {lblApprovePageApproveDateLabel0, lblApprovePageApproveDateLabel1, lblApprovePageApproveDateLabel2}
        mApprovePageApproveDates = New Label() {lblApprovePageApproveDate0, lblApprovePageApproveDate1, lblApprovePageApproveDate2}
        mApprovePageStatusImage = New PictureBox() {picApprovePageStatusImage0, picApprovePageStatusImage1, picApprovePageStatusImage2}
    End Sub


    Private Sub ShowApproveInfo()
        Me.mController.SelectApproveInfo()
        Dim approve As CanadaNormSettingApprove
        Dim i As Integer

        'Clear
        For i = 0 To mApprovePageGroups.Length - 1
            mApprovePageGroups(i).Visible = False
            mApprovePageCheckItems(i).Text = ""
            mApprovePageModifierNames(i).Text = ""
            mApprovePageModifyDates(i).Text = ""
            mApprovePageApproveStatus(i).Text = ""
            mApprovePageApproverNames(i).Text = ""
            mApprovePageApproveDates(i).Text = ""
        Next

        'Show data
        i = 0
        For Each approve In Me.mController.ApproveInfo
            Select Case approve.CheckItem
                Case CanadaNormSettingApprove.CheckItemType.GeneralSettings
                    mApprovePageGroups(i).Text = "General Settings"
                Case CanadaNormSettingApprove.CheckItemType.SurveySelection
                    mApprovePageGroups(i).Text = "Survey Selections"
                Case CanadaNormSettingApprove.CheckItemType.RollupSelection
                    mApprovePageGroups(i).Text = "Rollup Selections"
            End Select
            mApprovePageCheckItems(i).Text = CInt(approve.CheckItem).ToString
            mApprovePageModifierNames(i).Text = approve.ModifierName
            mApprovePageModifyDates(i).Text = approve.ModifyDate.ToString("MM/dd/yyyy hh:mm")
            Select Case approve.ApproveStatus
                Case CanadaNormSettingApprove.ApproveStatusType.Waiting
                    mApprovePageApproveStatus(i).Text = "Waiting to approve"
                    mApprovePageApproverNameLabels(i).Text = "Approved By"
                    mApprovePageApproveDateLabels(i).Text = "Date Approved"
                Case CanadaNormSettingApprove.ApproveStatusType.Approved
                    mApprovePageApproveStatus(i).Text = "Approved"
                    mApprovePageApproverNameLabels(i).Text = "Approved By"
                    mApprovePageApproverNames(i).Text = approve.ApproverName
                    mApprovePageApproveDateLabels(i).Text = "Date Approved"
                    mApprovePageApproveDates(i).Text = approve.ApproveDate.ToString("MM/dd/yyyy hh:mm")
                Case CanadaNormSettingApprove.ApproveStatusType.Disapproved
                    mApprovePageApproveStatus(i).Text = "Disapproved"
                    mApprovePageApproverNameLabels(i).Text = "Disapproved By"
                    mApprovePageApproverNames(i).Text = approve.ApproverName
                    mApprovePageApproveDateLabels(i).Text = "Date Disapproved"
                    mApprovePageApproveDates(i).Text = approve.ApproveDate.ToString("MM/dd/yyyy hh:mm")
            End Select
            mApprovePageStatusImage(i).Image = imlApproval.Images(approve.ApproveStatus - 1)
            mApprovePageGroups(i).Visible = True

            i += 1
        Next
    End Sub

#End Region

#Region " Display Pages"

    Private Sub DisplayChooseTaskPage(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        If (mController.NormSetting.Task = TaskType.NewNorm) Then
            optTaskPageNewNorm.Focus()
        Else
            lvwTaskPageNorm.Focus()
        End If
    End Sub

    Private Sub DisplayNormNamesPage(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        txtNamePageNormLabel.Focus()
    End Sub

    Private Sub DisplayNormSettingPage(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        chkSettingPageWeight.Focus()
        If (Me.mController.ComparisonTypes.SpecifiedComparison(NormType.BestNorm) Is Nothing) Then
            nudSettingPageHpSurvey.Enabled = False
        Else
            nudSettingPageHpSurvey.Enabled = True
        End If
        If (Me.mController.ComparisonTypes.SpecifiedComparison(NormType.WorstNorm) Is Nothing) Then
            nudSettingPageLpSurvey.Enabled = False
        Else
            nudSettingPageLpSurvey.Enabled = True
        End If
    End Sub

    Private Sub DisplayNormSurveyPage(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        lvwSurveyPageList.Focus()

        If (Not moveForward OrElse _
            Not Me.mController.NormSetting.ClientSelectionChanged) Then
            Return
        End If

        Dim rdr As System.Data.SqlClient.SqlDataReader = Nothing

        Try
            Me.Cursor = Cursors.WaitCursor
            rdr = Me.mController.SelectNormSurvey()

            Dim item As ListViewItem
            Dim clientName As New StringBuilder
            Dim clientID As Integer
            Dim studyName As New StringBuilder
            Dim studyID As Integer
            Dim surveyName As New StringBuilder
            Dim surveyID As Integer
            Dim surveySelected As Boolean

            Me.mTriggeredByProgram = True
            lvwSurveyPageList.BeginUpdate()
            lvwSurveyPageList.Items.Clear()

            Do While rdr.Read
                clientName.Remove(0, clientName.Length)
                clientName.Append(rdr("strClient_NM"))
                clientID = CInt(rdr("Client_ID"))
                studyName.Remove(0, studyName.Length)
                studyName.Append(rdr("strStudy_NM"))
                studyID = CInt(rdr("Study_ID"))
                surveyName.Remove(0, surveyName.Length)
                surveyName.Append(rdr("strSurvey_NM"))
                surveyID = CInt(rdr("Survey_ID"))
                surveySelected = CBool(rdr("SurveySelected"))

                item = New ListViewItem(clientName.ToString)
                item.SubItems.Add(clientID.ToString)
                item.SubItems.Add(studyName.ToString)
                item.SubItems.Add(studyID.ToString)
                item.SubItems.Add(surveyName.ToString)
                item.SubItems.Add(surveyID.ToString)
                item.Checked = surveySelected
                lvwSurveyPageList.Items.Add(item)
            Loop

            If (lvwSurveyPageList.SortColumn = -1 OrElse lvwSurveyPageList.SortOrder = SortOrder.NotSorted) Then
                lvwSurveyPageList.SortColumn = SurveyPageListField.ClientName
                lvwSurveyPageList.SortOrder = SortOrder.Ascend
            Else
                lvwSurveyPageList.Sort()
            End If

            Me.mTriggeredByProgram = False

            lblSurveyPageTotalCount.Text = lvwSurveyPageList.Items.Count.ToString
            lblSurveyPageSelectCount.Text = lvwSurveyPageList.CheckedItems.Count.ToString

        Catch ex As Exception
            ReportException(ex, CAPTION)
        Finally
            If (Not rdr Is Nothing) Then rdr.Close()
            lvwSurveyPageList.EndUpdate()
            mTriggeredByProgram = False
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub DisplayNormCriteriaPage(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
    End Sub

    Private Sub DisplayNormRollupPage(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        lvwRollupPageList.Focus()

        If (Not moveForward OrElse _
            Not Me.mController.NormSetting.ClientSelectionChanged) Then
            Return
        End If

        Dim rdr As System.Data.SqlClient.SqlDataReader = Me.mController.SelectNormRollup()
        Dim item As ListViewItem
        Dim rollupName As String
        Dim rollupID As Integer
        Dim rollupDescription As String
        Dim rollupSelected As Boolean

        Me.mTriggeredByProgram = True
        lvwRollupPageList.BeginUpdate()
        lvwRollupPageList.Items.Clear()

        Do While rdr.Read
            rollupName = CStr(rdr("Label"))
            rollupID = CInt(rdr("Rollup_ID"))
            rollupDescription = CStr(rdr("Description"))
            rollupSelected = CBool(rdr("RollupSelected"))

            item = New ListViewItem(rollupName)
            item.SubItems.Add(rollupID.ToString)
            item.SubItems.Add(rollupDescription)
            item.Checked = rollupSelected
            lvwRollupPageList.Items.Add(item)
        Loop
        If (Not rdr Is Nothing) Then rdr.Close()

        lvwRollupPageList.SortColumn = RollupPageListField.RollupName
        lvwRollupPageList.SortOrder = SortOrder.Ascend
        lvwRollupPageList.EndUpdate()
        Me.mTriggeredByProgram = False

        lblRollupPageTotalCount.Text = lvwRollupPageList.Items.Count.ToString
        lblRollupPageSelectCount.Text = lvwRollupPageList.CheckedItems.Count.ToString
    End Sub

    Private Sub DisplayNormApprovePage(ByVal currentStep As Integer, ByVal page As Object, ByVal moveForward As Boolean)
        ShowApproveInfo()
    End Sub

#End Region

#Region " Validate Pages"

    Private Sub ValidateChooseTaskPage(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        Dim task As TaskType
        Dim normID As Integer
        Dim i As Integer

        Try
            Me.Cursor = Cursors.WaitCursor

            'Check task type
            If (optTaskPageNewNorm.Checked) Then    'New norm group
                task = TaskType.NewNorm
                normID = 0
            Else                                    'Update norm group
                If (lvwTaskPageNorm.SelectedItems.Count <= 0) Then
                    MessageBox.Show("Select a norm group to continus.", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    CancelMove = True
                Else
                    task = TaskType.UpdateNorm
                    normID = CInt(lvwTaskPageNorm.SelectedItems(0).SubItems(TaskPageListField.NormID).Text)
                End If
            End If

            'Check if task changed
            If (mController.NormSetting.Task = task AndAlso _
                mController.NormSetting.NormID = normID) Then Return

            'Create NormGroup object
            mController = Nothing
            mController = New CanadaNormSettingController
            mController.NormSetting.Task = task
            If (task = TaskType.UpdateNorm) Then
                mController.NormSetting.NormID = normID
            End If

            'Load norm settings
            If (task = TaskType.UpdateNorm) Then
                mController.Load()
            End If

            'Show norm info
            ShowNormInfoPages()

            'Reset visited flag for wizard steps
            For i = WizardStep.NormNames To WizardStep.Finish
                mWizardData(i).Visited = False
            Next

        Catch ex As Exception
            ReportException(ex, CAPTION)
            CancelMove = True
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub ValidateNormNamePage(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        Try
            Me.Cursor = Cursors.WaitCursor

            'Check all the required data are input
            CancelMove = True

            If (txtNamePageNormLabel.Text.Trim = "") Then
                txtNamePageNormLabel.Focus()
                MessageBox.Show("Input norm group label", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If
            If (txtNamePageNormDescription.Text.Trim = "") Then
                txtNamePageNormDescription.Focus()
                MessageBox.Show("Input norm group description", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If (Not chkNamePageAvgComp.Checked AndAlso Not chkNamePageHpComp.Checked AndAlso Not chkNamePageLpComp.Checked) Then
                chkNamePageAvgComp.Focus()
                MessageBox.Show("At least one comparison type is required", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                Return
            End If

            If (chkNamePageAvgComp.Checked) Then
                If (txtNamePageAvgCompLabel.Text.Trim = "") Then
                    txtNamePageAvgCompLabel.Focus()
                    MessageBox.Show("Input average norm label", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                If (txtNamePageAvgCompDescription.Text.Trim = "") Then
                    txtNamePageAvgCompDescription.Focus()
                    MessageBox.Show("Input average norm description", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            End If

            If (chkNamePageHpComp.Checked) Then
                If (txtNamePageHpCompLabel.Text.Trim = "") Then
                    txtNamePageHpCompLabel.Focus()
                    MessageBox.Show("Input HP norm label", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                If (txtNamePageHpCompDescription.Text.Trim = "") Then
                    txtNamePageHpCompDescription.Focus()
                    MessageBox.Show("Input HP norm description", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            End If

            If (chkNamePageLpComp.Checked) Then
                If (txtNamePageLpCompLabel.Text.Trim = "") Then
                    txtNamePageLpCompLabel.Focus()
                    MessageBox.Show("Input LP norm label", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
                If (txtNamePageLpCompDescription.Text.Trim = "") Then
                    txtNamePageLpCompDescription.Focus()
                    MessageBox.Show("Input LP norm description", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            End If

            'Check if any 2 comparison labels are identical
            Dim label1, label2 As String

            If (chkNamePageAvgComp.Checked AndAlso chkNamePageHpComp.Checked) Then
                label1 = txtNamePageAvgCompLabel.Text.Trim.ToUpper
                label2 = txtNamePageHpCompLabel.Text.Trim.ToUpper
                If (label1 = label2) Then
                    txtNamePageAvgCompLabel.Focus()
                    MessageBox.Show("Labels for Avg and HP are identical", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            End If

            If (chkNamePageAvgComp.Checked AndAlso chkNamePageLpComp.Checked) Then
                label1 = txtNamePageAvgCompLabel.Text.Trim.ToUpper
                label2 = txtNamePageLpCompLabel.Text.Trim.ToUpper
                If (label1 = label2) Then
                    txtNamePageAvgCompLabel.Focus()
                    MessageBox.Show("Labels for Avg and LP are identical", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            End If

            If (chkNamePageHpComp.Checked AndAlso chkNamePageLpComp.Checked) Then
                label1 = txtNamePageHpCompLabel.Text.Trim.ToUpper
                label2 = txtNamePageLpCompLabel.Text.Trim.ToUpper
                If (label1 = label2) Then
                    txtNamePageHpCompLabel.Focus()
                    MessageBox.Show("Labels for HP and LP are identical", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Return
                End If
            End If

            'Get data from input
            Dim normSetting As CanadaNormSetting = mController.NormSetting
            Dim comparisonTypes As ComparisonTypeCollection = mController.ComparisonTypes
            Dim label As String
            Dim description As String

            label = txtNamePageNormLabel.Text.Trim
            description = txtNamePageNormDescription.Text.Trim
            normSetting.NormLabel = label
            normSetting.NormDescription = description

            If (chkNamePageAvgComp.Checked) Then
                label = txtNamePageAvgCompLabel.Text.Trim
                description = txtNamePageAvgCompDescription.Text.Trim
                comparisonTypes.SetComparisonData(NormType.StandardNorm, label, description)
            End If

            If (chkNamePageHpComp.Checked) Then
                label = txtNamePageHpCompLabel.Text.Trim
                description = txtNamePageHpCompDescription.Text.Trim
                comparisonTypes.SetComparisonData(NormType.BestNorm, label, description)
            End If

            If (chkNamePageLpComp.Checked) Then
                label = txtNamePageLpCompLabel.Text.Trim
                description = txtNamePageLpCompDescription.Text.Trim
                comparisonTypes.SetComparisonData(NormType.WorstNorm, label, description)
            End If

            Dim whichLabel As String = String.Empty
            If (Me.mController.IsNormLabelExist(whichLabel)) Then
                Select Case whichLabel
                    Case "Norm"
                        txtNamePageNormLabel.Focus()
                        txtNamePageNormLabel.SelectAll()
                        MessageBox.Show("Norm label is already in use", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Case NormType.StandardNorm.ToString
                        txtNamePageAvgCompLabel.Focus()
                        txtNamePageAvgCompLabel.SelectAll()
                        MessageBox.Show("Avg comparison label is already in use", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Case NormType.BestNorm.ToString
                        txtNamePageHpCompLabel.Focus()
                        txtNamePageHpCompLabel.SelectAll()
                        MessageBox.Show("HP comparison label is already in use", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                    Case NormType.WorstNorm.ToString
                        txtNamePageLpCompLabel.Focus()
                        txtNamePageLpCompLabel.SelectAll()
                        MessageBox.Show("LP comparison label is already in use", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
                End Select
                Return
            End If

            'Update norm label shown on other steps
            DisplayNormName()

            CancelMove = False

        Catch ex As Exception
            ReportException(ex, CAPTION)
            CancelMove = True
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub ValidateNormSettingPage(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        Try
            Me.Cursor = Cursors.WaitCursor

            'Get input values
            Dim weighted As Boolean = chkSettingPageWeight.Checked
            Dim unitIncludedInHpNorm As Integer = CInt(nudSettingPageHpSurvey.Value)
            Dim unitIncludedInLpNorm As Integer = CInt(nudSettingPageLpSurvey.Value)
            Dim reportDateBegin As Date = dtpSettingPageReportDateBegin.Value
            Dim reportDateEnd As Date = dtpSettingPageReportDateEnd.Value
            Dim returnDateMax As Date = dtpSettingPageReturnDateMax.Value

            'Check input values
            Dim msg As String

            If (unitIncludedInHpNorm < CanadaNormSetting.MIN_UNIT_IN_BENCHMARK_NORM OrElse _
                unitIncludedInHpNorm > CanadaNormSetting.MAX_UNIT_IN_BENCHMARK_NORM) Then
                msg = "Number of surveys to be included in HP norm is not valid. The valid value is between " & CanadaNormSetting.MIN_UNIT_IN_BENCHMARK_NORM & " and " & CanadaNormSetting.MAX_UNIT_IN_BENCHMARK_NORM
                MessageBox.Show(msg, CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error)
                nudSettingPageHpSurvey.Focus()
                CancelMove = True
                Return
            End If

            If (unitIncludedInLpNorm < CanadaNormSetting.MIN_UNIT_IN_BENCHMARK_NORM OrElse _
                unitIncludedInLpNorm > CanadaNormSetting.MAX_UNIT_IN_BENCHMARK_NORM) Then
                msg = "Number of surveys to be included in LP norm is not valid. The valid value is between " & CanadaNormSetting.MIN_UNIT_IN_BENCHMARK_NORM & " and " & CanadaNormSetting.MAX_UNIT_IN_BENCHMARK_NORM
                MessageBox.Show(msg, CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error)
                nudSettingPageLpSurvey.Focus()
                CancelMove = True
                Return
            End If

            If (returnDateMax < reportDateBegin OrElse returnDateMax < reportDateEnd) Then
                msg = "Cut off date can not be earlier than report date"
                MessageBox.Show(msg, CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error)
                dtpSettingPageReturnDateMax.Focus()
                CancelMove = True
                Return
            End If

            If (reportDateBegin > reportDateEnd) Then
                Dim tmpDate As Date = reportDateBegin
                reportDateBegin = reportDateEnd
                reportDateEnd = tmpDate
                dtpSettingPageReportDateBegin.Value = reportDateBegin
                dtpSettingPageReportDateEnd.Value = reportDateEnd
            End If

            'Save input values
            With mController.NormSetting
                .Weighted = weighted
                .ReportDateBegin = reportDateBegin
                .ReportDateEnd = reportDateEnd
                .ReturnDateMax = returnDateMax
            End With

            Dim comparison As ComparisonType
            comparison = mController.ComparisonTypes.SpecifiedComparison(NormType.BestNorm)
            If (Not comparison Is Nothing) Then
                comparison.UnitIncludedInBenchmarkNorm = unitIncludedInHpNorm
            End If

            comparison = mController.ComparisonTypes.SpecifiedComparison(NormType.WorstNorm)
            If (Not comparison Is Nothing) Then
                comparison.UnitIncludedInBenchmarkNorm = unitIncludedInLpNorm
            End If

        Catch ex As Exception
            ReportException(ex, CAPTION)
            CancelMove = True
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub ValidateNormClientPage(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        Try
            Me.Cursor = Cursors.WaitCursor

            If (lvwClientPageUsedClient.Items.Count = 0) Then
                MessageBox.Show("No client is selected", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error)
                CancelMove = True
                Return
            End If

            Dim count As Integer = lvwClientPageUsedClient.Items.Count
            Dim clientIDs(count - 1) As Integer
            Dim item As ListViewItem
            Dim clientID As Integer
            Dim i As Integer = 0

            For Each item In lvwClientPageUsedClient.Items
                clientID = CInt(item.SubItems(ClientPageListField.ClientID).Text)
                clientIDs(i) = clientID
                i += 1
            Next
            Me.mController.NormSetting.ClientIDs = clientIDs

        Catch ex As Exception
            ReportException(ex, CAPTION)
            CancelMove = True
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

    Private Sub ValidateNormSurveyPage(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        Try
            Me.Cursor = Cursors.WaitCursor

            Dim count As Integer = lvwSurveyPageList.CheckedItems.Count
            If (count = 0) Then
                MessageBox.Show("No survey is selected", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Error)
                CancelMove = True
                Return
            End If

            Dim surveyIDs(count - 1) As Integer
            Dim item As ListViewItem
            Dim surveyID As Integer
            Dim i As Integer = 0

            For Each item In lvwSurveyPageList.CheckedItems
                surveyID = CInt(item.SubItems(SurveyPageListField.SurveyID).Text)
                surveyIDs(i) = surveyID
                i += 1
            Next
            Me.mController.NormSetting.SurveyIDs = surveyIDs

        Catch ex As Exception
            ReportException(ex, CAPTION)
            CancelMove = True
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub ValidateNormCriteriaPage(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        If (lnkCriteriaPageCheck.Enabled) Then
            MessageBox.Show("Check syntax before moving forward", CAPTION, MessageBoxButtons.OK, MessageBoxIcon.Warning)
            CancelMove = True
        Else
            Me.mController.NormSetting.CriteriaStmt = txtCriteriaPageCriteria.Text.Trim
        End If
    End Sub

    Private Sub ValidateNormRollupPage(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        Try
            Me.Cursor = Cursors.WaitCursor

            'Check input data
            ValidateNormRollupPageSub(currentStep, CancelMove)
            If (CancelMove) Then Return

            'Save norm settings
            Me.mController.UpdateNormSettings()

            'If it is a new norm group, refresh norm group list
            If (Me.mController.NormSetting.Task = TaskType.NewNorm) Then
                ShowCanadaNormList()
            End If

        Catch ex As Exception
            ReportException(ex, CAPTION + vbCrLf + "Failed to update norm settings.")
            CancelMove = True
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    Private Sub ValidateNormRollupPageSub(ByVal currentStep As Integer, ByRef CancelMove As Boolean)
        Try
            Me.Cursor = Cursors.WaitCursor

            Dim count As Integer = lvwRollupPageList.CheckedItems.Count
            If (count = 0) Then
                Me.mController.NormSetting.RollupIDs = Nothing
                Return
            End If

            Dim rollupIDs(count - 1) As Integer
            Dim item As ListViewItem
            Dim rollupID As Integer
            Dim i As Integer = 0

            For Each item In lvwRollupPageList.CheckedItems
                rollupID = CInt(item.SubItems(RollupPageListField.RollupID).Text)
                rollupIDs(i) = rollupID
                i += 1
            Next
            Me.mController.NormSetting.RollupIDs = rollupIDs

        Catch ex As Exception
            ReportException(ex, CAPTION)
            CancelMove = True
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

#End Region
End Class
