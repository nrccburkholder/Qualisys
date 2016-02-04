Imports Nrc.SurveyPoint.Library
Public Enum ExportClickTypes
    Run = 1
    GetCount = 2
End Enum
Public Class ExportRunSection

    Private controller As New ExportRunSectionController
    Private mLoaded As Boolean

    'Steve Kennedy - If Export Group Id is sent from Log screen
    'we'll need to store local values for these values.
    Private mExportGroupID As Integer
    Private mStartDate As Nullable(Of Date)
    Private mEndDate As Nullable(Of Date)
    Private mIsSubmitted As Boolean
    Private mLogFileID As Integer
    'Private mIsReRun As Boolean = False
    Private mMode As ExportConfigurationButtonEnum


    Public Sub New(ByVal logFile As ExportFileLog)

        'Initialize the form
        InitializeComponent()

        'Steve Kennedy - comment this code
        'Load The Export Group From the logfileID 
        controller.LoadExportGroup(logFile.ExportGroupID)

        'Save the parameters
        'TP 20080415
        mStartDate = controller.ExportGroup.RerunCodeStartDate
        mEndDate = controller.ExportGroup.RerunCodeEndDate
        mExportGroupID = controller.ExportGroup.ExportGroupID
        mIsSubmitted = logFile.MarkSubmitted
        mLogFileID = logFile.ExportLogFileID
        'mIsReRun = True

        'Set Run Mode; Normally a Rerun via this constructor
        mMode = ExportConfigurationButtonEnum.ReRun



        'Populate The Run Screen
        PopulateRunScreen()


    End Sub

    Public Sub New(ByVal exportGroupID As Integer)

        'Initialize the form
        InitializeComponent()

        'Load The Export Group From the logfileID
        controller.LoadExportGroup(exportGroupID)

        'Set Run Mode; Normally a "run" via this constructor
        mMode = ExportConfigurationButtonEnum.Run

        'Populate The Run Screen
        PopulateRunScreen()

    End Sub
    'Public Sub New(ByVal exportGroupID As Integer, ByVal startDate As Nullable(Of Date), ByVal endDate As Nullable(Of Date), ByVal isSubmitted As Boolean)

    '    'Initialize the form
    '    InitializeComponent()

    '    mLoaded = False

    '    'Save the parameters
    '    mExportGroupID = exportGroupID
    '    mStartDate = startDate
    '    mEndDate = endDate
    '    mIsSubmitted = isSubmitted
    '    controller.LoadExportGroup(mExportGroupID)
    '    PopulateRunScreen()

    'End Sub
    Public Sub PopulateRunScreen()

        'ExportGroup Stuff 
        Me.ExportGroupExtensionCollectionBindingSource.DataSource = controller.ExportGroupExtensions
        Me.ExportGroupTextBox.Text = controller.ExportGroup.Name.ToString
        Me.FileLayoutTextBox.Text = controller.ExportGroup.ExportFileLayout.FilelayoutName
        Me.SurveyTextBox.Text = ExportSurvey.GetSurveyBySurveyID(controller.SelectedSurvey.SurveyID).Name.ToString
        Me.QuestionFileNameTextBox.Text = controller.ExportGroup.QuestionFileName
        Me.ResultFilenameTextBox.Text = controller.ExportGroup.ResultFileName
        Me.lblExportGroupProperties.Text = controller.ExportGroupFilePropertiesLabel
        'TODO: Steve Kennedy - comment this code addition
        Me.RemoveHTMLAndEncodingCheckbox.Checked = controller.ExportGroup.RemoveHTMLAndEncoding
        lblRunMode.Text = mMode.ToString
        ResetRunScreenTabControl()

        'Survey Stuff 
        Me.ExportSurveyBindingSource.DataSource = controller.AllSurveys
        Me.SurveyTextBox.Text = controller.SelectedSurvey.Name.ToString

        'Client Stuff        
        Me.ExportClientAvailablesBindingSource.DataSource = controller.AvailableClients
        Me.ExportClientSelectedsBindingSource.DataSource = controller.SelectedClients
        Me.lblClientProperties.Text = controller.ClientFilePropertiesLabel

        'Scripts Stuff
        Me.ExportScriptAvailableBindingSource.DataSource = controller.AvailableScripts
        Me.ExportScriptSelectedBindingSource.DataSource = controller.SelectedScripts
        Me.lblScriptProperties.Text = controller.ScriptFilePropertiesLabel

        'Events Stuff 
        Me.ExportEventAvailableBindingSource.DataSource = controller.AvailableEvents
        Me.ExportEventIncludedBindingSource.DataSource = controller.IncludedEvents
        Me.ExportEventExcludedBindingSource.DataSource = controller.ExcludedEvents

        'Based On Log Screen Change
        If Me.mExportGroupID > 0 Then
            'Me.Mark2401Checkbox.Checked = mIsSubmitted
            'Me.Mark2401Checkbox.Enabled = mIsSubmitted
            If mStartDate.HasValue AndAlso mEndDate.HasValue Then
                Me.CompleteStartDate.Value = mStartDate.Value
                Me.CompleteEndDate.Value = Me.mEndDate.Value
            End If
        End If
        mLoaded = True
    End Sub

    Public Sub LoadExportGroup(ByVal mode As ExportConfigurationButtonEnum, ByVal exportGroupID As Integer)
        mLoaded = False
        mMode = mode
        controller.LoadExportGroup(exportGroupID)
        PopulateRunScreen()
    End Sub

    Private Sub ResetRunScreenTabControl()
        'TODO: Steve Kennedy comment this code
        Me.RunButton.Enabled = False
        For Each tabpage As TabPage In Me.RunScreenTabControl.TabPages
            tabpage.ImageIndex = 0
        Next
        Me.RunScreenTabControl.SelectedTab.ImageIndex = -1
    End Sub

    Private Sub ExportEventIncludedBindingSource_ListChanged(ByVal sender As Object, ByVal e As System.ComponentModel.ListChangedEventArgs) Handles ExportEventIncludedBindingSource.ListChanged
        'TODO: Steve Kennedy document code
        CompleteDatesGroupBox.Enabled = Me.ExportEventIncludedBindingSource.List.Contains(ExportEventSelected.Get(2401))
        Me.Mark2401Checkbox.Enabled = Not Me.ExportEventIncludedBindingSource.List.Contains(ExportEventSelected.Get(2401))
        Me.Mark2401Checkbox.Checked = Not Me.ExportEventIncludedBindingSource.List.Contains(ExportEventSelected.Get(2401))

    End Sub

    Private Sub ExportClientSelectedsBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportClientSelectedsBindingSource.CurrentChanged
        Dim bs As System.Windows.Forms.BindingSource
        bs = TryCast(sender, System.Windows.Forms.BindingSource)
        controller.SelectedClient = TryCast(bs.Current, ExportClientSelected)
        Me.ExportClientExtensionBindingSource.DataSource = controller.SelectedClientExtensions
        Me.lblClientProperties.Text = controller.ClientFilePropertiesLabel
    End Sub

    Private Sub ExportScriptSelectedBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportScriptSelectedBindingSource.CurrentChanged
        Dim bs As System.Windows.Forms.BindingSource
        bs = TryCast(sender, System.Windows.Forms.BindingSource)
        controller.SelectedScript = TryCast(bs.Current, ExportScriptSelected)
        Me.ExportScriptExtensionBindingSource.DataSource = controller.SelectedScriptExtensions
        Me.lblScriptProperties.Text = controller.ScriptFilePropertiesLabel
    End Sub
    ''' <summary>This event handler passes the export group and required data to a
    ''' dialog which validates and Shows the respondent Count.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term></term>
    ''' <description></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description></description></item></list></RevisionList>
    Private Sub RespondentCountButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RespondentCountButton.Click
        HandleExportClick(ExportClickTypes.GetCount)
    End Sub
    ''' <summary>This event handler passes the export group and required data to a
    ''' dialog which validates and runs the export.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080414 - Tony Piccoli</term>
    ''' <description>Null the dates if they are disabled.</description></item>
    ''' <item>
    ''' <term>	20080417 - Tony Piccoli</term>
    ''' <description>cant run an export if one is currently
    ''' running.</description></item></list></RevisionList>
    Private Sub RunButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RunButton.Click
        HandleExportClick(ExportClickTypes.Run)        
    End Sub

    Private Sub HandleExportClick(ByVal type As ExportClickTypes)
        Dim exportGroup As ExportGroup = exportGroup.Get(controller.ExportGroup.ExportGroupID)
        exportGroup.QuestionFileName = QuestionFileNameTextBox.Text
        exportGroup.ResultFileName = ResultFilenameTextBox.Text
        Dim markSubmitted As Boolean = Me.Mark2401Checkbox.Checked
        Dim startDate As Nullable(Of Date) = Nothing
        If Me.CompleteStartDate.Enabled Then
            startDate = ExtractDate(Me.CompleteStartDate, Me.DateTimePicker1)
        End If
        Dim endDate As Nullable(Of Date) = Nothing
        If Me.CompleteEndDate.Enabled Then
            endDate = ExtractDate(Me.CompleteEndDate, Me.DateTimePicker2)
        End If
        If exportGroup.CheckForRunningExport() Then
            MessageBox.Show("You may not run this export group while an export is being run.")
        Else
            Dim dialog As ExportGroupRunLog            
            If Me.mMode = ExportConfigurationButtonEnum.ReRun Then
                exportGroup.RerunCodeStartDate = startDate
                exportGroup.RerunCodeEndDate = endDate
                If type = ExportClickTypes.Run Then
                    dialog = New ExportGroupRunLog(exportGroup, markSubmitted, Me.mLogFileID, False, Me.chkActiveOnly.Checked)
                Else
                    dialog = New ExportGroupRunLog(exportGroup, markSubmitted, Me.mLogFileID, True, Me.chkActiveOnly.Checked)
                End If
            Else                
                exportGroup.RerunCodeStartDate = startDate
                exportGroup.RerunCodeEndDate = endDate
                If type = ExportClickTypes.Run Then
                    dialog = New ExportGroupRunLog(exportGroup, markSubmitted, False, Me.chkActiveOnly.Checked)
                Else
                    dialog = New ExportGroupRunLog(exportGroup, markSubmitted, True, Me.chkActiveOnly.Checked)
                End If
            End If
            dialog.ShowDialog()
        End If
    End Sub
    Private Sub RunScreenTabControl_Selected(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TabControlEventArgs) Handles RunScreenTabControl.Selected

        'TODO: Steve Kennedy comment this code
        If Me.RunButton.Enabled = False Then
            e.TabPage.ImageIndex = -1
            For Each tabpage As TabPage In Me.RunScreenTabControl.TabPages
                If tabpage.ImageIndex = 0 Then Exit Sub
            Next
            Me.RunButton.Enabled = True
        End If

    End Sub

    ''' <summary>Helper function to combined dates from two controls one for date, one for time.</summary>
    ''' <param name="dayPicker"></param>
    ''' <param name="timePicker"></param>
    ''' <returns></returns>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function ExtractDate(ByVal dayPicker As DateTimePicker, ByVal timePicker As DateTimePicker) As Date
        Dim retVal As Date = Nothing
        Dim strDate As String
        strDate = dayPicker.Value.Month & "/" & dayPicker.Value.Day & "/" & dayPicker.Value.Year & " "
        strDate += timePicker.Value.TimeOfDay.ToString
        retVal = DateTime.Parse(strDate)
        Return retVal
    End Function

    ''' <summary>Click event used for user to select a question file they wish to create.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub QuestionFileBrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles QuestionFileBrowseButton.Click
        If Me.QuestionFileNameTextBox.Text.Trim <> "" Then
            Dim mInitialDirectory As String = Mid(Me.QuestionFileNameTextBox.Text, 1, Me.QuestionFileNameTextBox.Text.LastIndexOf("\") + 1)
            Me.FileSaveDialog.InitialDirectory = mInitialDirectory

        End If
        If Me.FileSaveDialog.ShowDialog() = DialogResult.OK Then
            Me.QuestionFileNameTextBox.Text = Me.FileSaveDialog.FileName
            Me.controller.ExportGroup.QuestionFileName = Me.FileSaveDialog.FileName
            Me.FileSaveDialog.FileName = String.Empty
        End If
    End Sub

    ''' <summary>Click event used for user to select an answer file they wisth to create.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ResultFileBrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResultFileBrowseButton.Click
        If Me.ResultFilenameTextBox.Text.Trim <> "" Then
            Dim mInitialDirectory As String = Mid(Me.ResultFilenameTextBox.Text, 1, Me.ResultFilenameTextBox.Text.LastIndexOf("\") + 1)
            Me.FileSaveDialog.InitialDirectory = mInitialDirectory
        End If
        If Me.FileSaveDialog.ShowDialog() = DialogResult.OK Then
            Me.ResultFilenameTextBox.Text = Me.FileSaveDialog.FileName
            Me.controller.ExportGroup.ResultFileName = Me.FileSaveDialog.FileName
            Me.FileSaveDialog.FileName = String.Empty
        End If
    End Sub

    
End Class
