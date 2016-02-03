Imports Nrc.SurveyPoint.Library
Imports DevExpress.XtraGrid.Views.Grid
Public Class ExportConfigurationSection
    Public Event ExportGroupModified As EventHandler(Of ExportGroupSelectedEventArgs)

#Region "Private Members"
    Private controller As New ExportConfigurationSectionController
    Private mLoaded As Boolean
    Private mParentSection As ExportSection = Nothing
#End Region

#Region "Baseclass Overrides"

    Public Overrides Sub ActivateSection()
    End Sub

    ''' <summary>This override is checking if there're changes made to the current ExportGroup and if so 
    ''' prompts to save before letting the user to leave.</summary>
    ''' <returns></returns>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Overrides Function AllowInactivate() As Boolean
        If controller.ExportGroup.IsDirty Then
            If MessageBox.Show("You modified the configuration, would you like to save?", "Warning", MessageBoxButtons.YesNo) = DialogResult.Yes Then
                If Me.SaveConfiguration() Then
                    Return True
                Else
                    Return False
                End If
            Else
                Return True
            End If
        Else
            Return True
        End If
        ' Return True

    End Function

    Public Overrides Sub InactivateSection()

    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

    End Sub

#End Region

#Region "Constructors"

    Public Sub New(ByVal parentSection As ExportSection)

        'Initialize the form
        InitializeComponent()
        Me.mParentSection = parentSection
        controller.NewExportGroup()
        PopulateExportGroupScreen()
    End Sub

    Public Sub New(ByVal parentSection As ExportSection, ByVal exportGroupID As Integer)

        'Initialize the form
        InitializeComponent()

        'Save the parameters
        Me.mParentSection = parentSection
        controller.LoadExportGroup(exportGroupID)
        Me.ExportGroupTextBox.Text = controller.ExportGroup.Name
        Me.QuestionFileNameTextBox.Text = controller.ExportGroup.QuestionFileName
        Me.ResultFilenameTextBox.Text = controller.ExportGroup.ResultFileName
        PopulateExportGroupScreen()
    End Sub
    Public Sub LoadExportGroup(ByVal exportGroupID As Integer)
        mLoaded = False
        controller.LoadExportGroup(exportGroupID)
        'This is done outside of the populate method so that the value doesn't revert back when selecting a new combo.
        Me.ExportGroupTextBox.Text = controller.ExportGroup.Name
        Me.QuestionFileNameTextBox.Text = controller.ExportGroup.QuestionFileName
        Me.ResultFilenameTextBox.Text = controller.ExportGroup.ResultFileName
        PopulateExportGroupScreen()
    End Sub

#End Region

#Region "Events"

    ''' <summary>Load event populates the ExportGroup Configuration screen.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub UpdateEventLogSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Load screen with the data
        'PopulateExportGroupScreen()
    End Sub

    ''' <summary>Intial screen populate routine</summary>
    ''' <CreatedBy>Steve Kennedy, Tony Piccoli, Arman Mnatsakanyan</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub PopulateExportGroupScreen()

        'ExportGroup Stuff 
        Me.ExportGroupExtensionCollectionBindingSource.DataSource = controller.ExportGroupExtensions
        Me.lblExportGroupProperties.Text = controller.ExportGroupFilePropertiesLabel
        'TODO: Steve Kennedy - comment this code addition
        Me.RemoveHTMLAndEncodingCheckbox.Checked = controller.ExportGroup.RemoveHTMLAndEncoding

        'Survey Stuff 
        Me.ExportSurveyBindingSource.DataSource = controller.AllSurveys
        Me.SurveyComboBox.ValueMember() = "SurveyID"
        Me.SurveyComboBox.SelectedItem = controller.SelectedSurvey

        'Client Stuff        
        Me.ExportClientAvailablesBindingSource.DataSource = controller.AvailableClients
        Me.ExportClientSelectedsBindingSource.DataSource = controller.SelectedClients
        Me.ExportClientExtensionBindingSource.DataSource = controller.SelectedClientExtensions

        Me.lblClientProperties.Text = controller.ClientFilePropertiesLabel
        Me.ToolTipProvider.SetToolTip(Me.MoveToSelectedClientsButton, "Move to Selected Clients")
        Me.ToolTipProvider.SetToolTip(Me.MoveToAvailableClientsButton, "Remove from Selected Clients")

        'Scripts Stuff
        Me.ExportScriptAvailableBindingSource.DataSource = controller.AvailableScripts
        Me.ExportScriptSelectedBindingSource.DataSource = controller.SelectedScripts
        Me.lblScriptProperties.Text = controller.ScriptFilePropertiesLabel
        Me.ToolTipProvider.SetToolTip(Me.MoveToSelectedScriptsButton, "Move to Selected Scripts")
        Me.ToolTipProvider.SetToolTip(Me.MoveToAvailableScriptsButton, "Remove from Selected Scripts")
        Me.ExportScriptExtensionBindingSource.DataSource = controller.SelectedScriptExtensions

        'Events Stuff 
        Me.ExportEventAvailableBindingSource.DataSource = controller.AvailableEvents
        Me.ExportEventIncludedBindingSource.DataSource = controller.IncludedEvents
        Me.ExportEventExcludedBindingSource.DataSource = controller.ExcludedEvents
        Me.ToolTipProvider.SetToolTip(Me.MoveFromExcludedEventsButton, "Remove from Excluded Events")
        Me.ToolTipProvider.SetToolTip(Me.MoveFromIncludedEventsButton, "Remove from Included Events")
        Me.ToolTipProvider.SetToolTip(Me.MoveToIncludedEventsButton, "Move to Included Events")
        Me.ToolTipProvider.SetToolTip(Me.MoveToExcludedEventsButton, "Move to Excluded Events")

        'File Layout Stuff
        Me.FileLayoutComboBox.DataSource = controller.AllFileLayouts
        Me.FileLayoutComboBox.DisplayMember = "FileLayoutName"
        Me.FileLayoutComboBox.ValueMember = "FileLayoutID"
        Me.FileLayoutComboBox.SelectedItem = controller.SelectedFileLayout

        'Default selection stuff
        Me.SelectClientsGridView.SelectRow(0)
        Me.AvailableClientsGridView.SelectRow(0)
        Me.SelectedScriptsGridView.SelectRow(0)
        Me.AvailableScriptGridView.SelectRow(0)

        mLoaded = True

    End Sub
    ''' <summary>Refreshes the available and selected scripts and clients list each time after a user moves a client or a script.</summary>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub RebindClientsAndScripts()
        'Clients        
        Me.ExportClientAvailablesBindingSource.DataSource = controller.AvailableClients
        Me.ExportClientSelectedsBindingSource.DataSource = controller.SelectedClients
        Me.AvailableClientsGridView.Columns.View.BeginSort()
        Me.AvailableClientsGridView.Columns.View.EndSort()
        'Scripts
        Me.ExportScriptAvailableBindingSource.DataSource = controller.AvailableScripts
        Me.ExportScriptSelectedBindingSource.DataSource = controller.SelectedScripts
        Me.ExportClientExtensionBindingSource.DataSource = controller.SelectedClientExtensions
    End Sub

    Private Sub SortMovableGrids()
        'If Me.AvailableClientsGridView.SortedColumns.Count = 0 Then
        '    Me.AvailableClientsGridView
        'End If
        Me.AvailableClientsGridView.Columns.View.BeginSort()
        Me.AvailableClientsGridView.Columns.View.EndSort()
        Me.SelectClientsGridView.Columns.View.BeginSort()
        Me.SelectClientsGridView.Columns.View.EndSort()
        Me.AvailableEventCodesGridView.Columns.View.BeginSort()
        Me.AvailableEventCodesGridView.Columns.View.EndSort()
        Me.IncludeEventCodesGridView.Columns.View.BeginSort()
        Me.IncludeEventCodesGridView.Columns.View.EndSort()
        Me.ExcludeEventCodesGridView.Columns.View.BeginSort()
        Me.ExcludeEventCodesGridView.Columns.View.EndSort()
        Me.AvailableScriptGridView.Columns.View.BeginSort()
        Me.SelectClientsGridView.Columns.View.EndSort()
    End Sub
#End Region

    ''' <summary>Every time a new Survey is selected the program has to repopulate the 
    ''' ExportGroup configuration screen since scripts and clients are associated with the selected survey.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub SurveyComboBox_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SurveyComboBox.SelectedIndexChanged
        'we don't want to overwrite the selection from the PopulateExportGroupItems()
        If mLoaded Then
            'If MessageBox.Show("Changing the survey will remove any selected clients and scripts along with their associated extensions." & vbCrLf & "Click OK to proceed.", "Survey Selection", MessageBoxButtons.OKCancel, MessageBoxIcon.Warning) = DialogResult.OK Then
            controller.SelectedSurvey = TryCast(SurveyComboBox.SelectedItem, ExportSurvey)
            mLoaded = False
            PopulateExportGroupScreen()
            'End If
        End If
    End Sub

    ''' <summary>Moves the list of selected available events to the included events.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveToIncludedEventsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveToIncludedEventsButton.Click

        'Build The Selected Collection
        Dim eventCollection As New ExportEventAvailableCollection
        For Each i As Integer In Me.AvailableEventCodesGridView.GetSelectedRows()
            Dim SourceExportEvent As ExportEventAvailable = CType(Me.AvailableEventCodesGrid.DefaultView.GetRow(i), ExportEventAvailable)
            eventCollection.Add(SourceExportEvent)
        Next

        'Call to Move the Selected Collection
        controller.MoveToIncludedEvents(eventCollection)

        'Select the current row on the Available Events Grid
        Dim CurrentAvailableEventIndex As Integer = controller.AvailableEvents.IndexOf(controller.CurrentAvailableEvent)
        Me.AvailableEventCodesGridView.SelectRow(Me.AvailableEventCodesGridView.GetRowHandle(CurrentAvailableEventIndex))

    End Sub

    ''' <summary>Moves the list of selected included events back to the available events.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveFromIncludedEventsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveFromIncludedEventsButton.Click

        'Build The Selected Collection
        Dim eventCollection As New ExportEventSelectedCollection
        For Each i As Integer In Me.IncludeEventCodesGridView.GetSelectedRows()
            Dim SourceExportEvent As ExportEventSelected = CType(Me.IncludeEventCodesGrid.DefaultView.GetRow(i), ExportEventSelected)
            eventCollection.Add(SourceExportEvent)
        Next

        'Call to Move the Selected Collection
        controller.MoveFromIncludedEvents(eventCollection)

    End Sub
    ''' <summary>Moves the list of selected available events to the excluded events collection.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveToExcludedEventsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveToExcludedEventsButton.Click

        'Build The Selected Collection
        Dim eventCollection As New ExportEventAvailableCollection
        For Each i As Integer In Me.AvailableEventCodesGridView.GetSelectedRows()
            Dim SourceExportEvent As ExportEventAvailable = CType(Me.AvailableEventCodesGrid.DefaultView.GetRow(i), ExportEventAvailable)
            eventCollection.Add(SourceExportEvent)
        Next

        'Call to Move the Selected Collection
        controller.MoveToExcludedEvents(eventCollection)

        Dim CurrentAvailableEventIndex As Integer = controller.AvailableEvents.IndexOf(controller.CurrentAvailableEvent)
        Me.AvailableEventCodesGridView.SelectRow(Me.AvailableEventCodesGridView.GetRowHandle(CurrentAvailableEventIndex))
    End Sub

    ''' <summary>Moves the list of selected excluded events back to the available events.</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveFromExcludedEventsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveFromExcludedEventsButton.Click

        'Build The Selected Collection
        Dim eventCollection As New ExportEventSelectedCollection
        For Each i As Integer In Me.ExcludeEventCodesGridView.GetSelectedRows()
            Dim SourceExportEvent As ExportEventSelected = CType(Me.ExcludeEventCodesGrid.DefaultView.GetRow(i), ExportEventSelected)
            eventCollection.Add(SourceExportEvent)
        Next

        'Call to Move the Selected Collection
        controller.MoveFromExcludedEvents(eventCollection)

    End Sub

    ''' <summary>Passes the IDs of selected "Available Scripts" to the controller to move them to the "Selected Scripts" list then rebinds clients and scripts.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveToSelectedScriptsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveToSelectedScriptsButton.Click
        Dim scriptIDs As List(Of Integer) = New List(Of Integer)
        Dim i As Integer

        For Each i In Me.AvailableScriptGridView.GetSelectedRows
            Dim sourceScript As ExportScriptAvailable = CType(Me.AvailableScriptsGrid.DefaultView.GetRow(i), ExportScriptAvailable)
            scriptIDs.Add(sourceScript.ScriptID)
        Next
        controller.MoveToSelectedScripts(scriptIDs)
        'TP 20080225  needs to be done for new groups with no scripts selected.

        'Select the current row on the Available Clients Grid
        Dim CurrentAvailableScriptIndex As Integer = controller.AvailableScripts.IndexOf(controller.CurrentAvailableScript)
        Me.AvailableScriptGridView.SelectRow(Me.AvailableScriptGridView.GetRowHandle(CurrentAvailableScriptIndex))

        RebindClientsAndScripts()
    End Sub

    ''' <summary>Passes the IDs of selected "Selected Scripts" to the controller to move them back to the "Available Scripts" list then rebinds clients and scripts.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveToAvailableScriptsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveToAvailableScriptsButton.Click
        Dim scriptIDs As List(Of Integer) = New List(Of Integer)
        Dim i As Integer

        For Each i In Me.SelectedScriptsGridView.GetSelectedRows
            Dim sourceScript As ExportScriptSelected = CType(Me.SelectedScriptsGrid.DefaultView.GetRow(i), ExportScriptSelected)
            scriptIDs.Add(sourceScript.ScriptID)
        Next
        'controller.ExportGroup.ExportSelectedSurvey.MoveScripts(scriptIDs, ExportGroupMoveDirection.RemoveSelected)
        controller.MoveToAvailableScripts(scriptIDs)

        Dim SelectedScriptIndex As Integer = _
            controller.SelectedScripts.IndexOf(controller.SelectedScript)
        Me.SelectedScriptsGridView.SelectRow(Me.SelectedScriptsGridView.GetRowHandle(SelectedScriptIndex))

        'reset the extensions
        Me.ExportScriptExtensionBindingSource.DataSource = controller.SelectedScriptExtensions

    End Sub

    ''' <summary>Passes the IDs of selected "Available Clients" to the controller to move them to the "Selected Clients" list then rebinds clients and Clients.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveToSelectedClientsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveToSelectedClientsButton.Click
        Dim clientIDs As List(Of Integer) = New List(Of Integer)
        Dim i As Integer

        For Each i In Me.AvailableClientsGridView.GetSelectedRows
            Dim sourceClient As ExportClientAvailable = CType(Me.AvailableClientsGrid.DefaultView.GetRow(i), ExportClientAvailable)
            clientIDs.Add(sourceClient.ClientID)
        Next
        controller.MoveToSelectedClients(clientIDs)

        'Select the current row on the Available Clients Grid
        Dim CurrentAvailableClientIndex As Integer = controller.AvailableClients.IndexOf(controller.CurrentAvailableClient)
        Me.AvailableClientsGridView.SelectRow(Me.AvailableClientsGridView.GetRowHandle(CurrentAvailableClientIndex))

        RebindClientsAndScripts()
    End Sub

    ''' <summary>Passes the IDs of selected "Selected Clients" to the controller to move them back to the "Available Clients" list then rebinds clients and Clients.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub MoveToAvailableClientsButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MoveToAvailableClientsButton.Click
        Dim clientIDs As List(Of Integer) = New List(Of Integer)
        Dim i As Integer

        For Each i In Me.SelectClientsGridView.GetSelectedRows
            Dim sourceClient As ExportClientSelected = CType(Me.SelectClientsGrid.DefaultView.GetRow(i), ExportClientSelected)
            clientIDs.Add(sourceClient.ClientID)
        Next
        controller.MoveToAvailableClients(clientIDs)

        Dim SelectedClientIndex As Integer = _
            controller.SelectedClients.IndexOf(controller.SelectedClient)
        Me.SelectClientsGridView.SelectRow(Me.SelectClientsGridView.GetRowHandle(SelectedClientIndex))


        RebindClientsAndScripts()
    End Sub

    ''' <summary>Opens File Save Dialog. Stores result in Question File Name textbox</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub QuestionFileBrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles QuestionFileBrowseButton.Click

        'TODO: Steve Kennedy - Comment This Code
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

    ''' <summary>Opens File Save Dialog. Stores result in Result File Name textbox</summary>
    ''' <CreatedBy>Steve Kennedy</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ResultFileBrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ResultFileBrowseButton.Click
        'TODO: Steve Kennedy - Comment This Code
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

    ''' <summary>Saves the current ExportGroup configuration changes to the database and
    ''' gives a &quot;success&quot; or &quot;Fail&quot; feedback.</summary>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20080417 - Tony Piccoli</term>
    ''' <description>Changed the dialog used when validating an export
    ''' group</description></item>
    ''' <item>
    ''' <term>20080417 - Tony Piccoli</term>
    ''' <description>Dont save if another export group is
    ''' running</description></item></list></RevisionList>
    Private Function SaveConfiguration() As Boolean
        Dim msg As String = String.Empty
        Dim clientScriptValidation As Boolean = controller.ExportGroup.ExportSelectedSurvey.VaildateClientsAndScripts(msg, False)
        controller.ExportGroup.QuestionFileName = Me.QuestionFileNameTextBox.Text
        controller.ExportGroup.ResultFileName = Me.ResultFilenameTextBox.Text
        controller.ExportGroup.Name = ExportGroupTextBox.Text
        'TODO: Steve Kennedy - comment this code
        controller.ExportGroup.RemoveHTMLAndEncoding = Me.RemoveHTMLAndEncodingCheckbox.Checked
        If Not controller.ExportGroup.ValidateAll OrElse Not clientScriptValidation Then
            'TP Changed the dialog I'm using 20080417
            Dim dialog As ExportGroupRunLog = New ExportGroupRunLog(controller.ExportGroup)
            dialog.ShowDialog()
            Return False
        Else
            'Choose to save and passed validation.
            If ExportGroup.CheckExportGroupByName(Me.ExportGroupTextBox.Text, controller.ExportGroup.ExportGroupID) And controller.ExportGroup.IsNew() Then
                MessageBox.Show("The name for your export group already exists in the database.", "Export Group Name.", MessageBoxButtons.OK)
                Me.ExportGroupTextBox.Focus()
                Return False
            Else
                'TP can only save if not exports are being run.
                If ExportGroup.CheckForRunningExport() AndAlso Not controller.ExportGroup.IsNew Then
                    MessageBox.Show("You may not save this export group while an export is being run.")
                    Return False
                Else
                    controller.ExportGroup.Save()
                    Me.mParentSection.mNavigator.ResetExportGroupList(controller.ExportGroup.ExportGroupID)
                    MessageBox.Show("Export Group has been successfully saved.", "Export Group Save", MessageBoxButtons.OK)
                    Return True
                End If
            End If
        End If
    End Function

    ''' <summary>Event handler of "Save" button.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub SaveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        SaveConfiguration()
    End Sub

    ''' <summary>Keeps track of currently selected file layout.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub FileLayoutComboBox_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileLayoutComboBox.SelectedIndexChanged
        If mLoaded Then
            controller.SelectedFileLayout = TryCast(Me.FileLayoutComboBox.SelectedItem, ExportFileLayout)
        End If
    End Sub

    ''' <summary>Keeps track of currently selected Client (to display its extensions). </summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportClientSelectedsBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportClientSelectedsBindingSource.CurrentChanged
        'Reset the selected client
        Dim bs As System.Windows.Forms.BindingSource
        bs = TryCast(sender, System.Windows.Forms.BindingSource)
        controller.SelectedClient = TryCast(bs.Current, ExportClientSelected)
        Me.ExportClientExtensionBindingSource.DataSource = controller.SelectedClientExtensions
        'Me.SelectClientsGridView.SelectRow(0)
        Me.lblClientProperties.Text = controller.ClientFilePropertiesLabel
    End Sub

    ''' <summary>Keeps track of the current selected script.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportScriptSelectedBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportScriptSelectedBindingSource.CurrentChanged
        Dim bs As System.Windows.Forms.BindingSource
        bs = TryCast(sender, System.Windows.Forms.BindingSource)
        controller.SelectedScript = TryCast(bs.Current, ExportScriptSelected)
        Me.ExportScriptExtensionBindingSource.DataSource = controller.SelectedScriptExtensions
        Me.lblScriptProperties.Text = controller.ScriptFilePropertiesLabel
    End Sub


    ''' <summary>Reverts the export group to its original value if the user cancels.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click
        If MessageBox.Show("Are you sure you wish to cancel and lose any changes made?", "Cancel Export Config", MessageBoxButtons.OKCancel) = DialogResult.OK Then
            If controller.ExportGroup.ExportGroupID = 0 Then
                controller.NewExportGroup()
                PopulateExportGroupScreen()
            Else
                LoadExportGroup(controller.ExportGroup.ExportGroupID)
            End If
        End If
    End Sub
    ''' <summary>
    ''' Saves the current row of the Available Clients Grid for later selection after move
    ''' </summary>
    ''' <param name="sender"></param>
    ''' <CreatedBy>Arman Mnatsakanyan</CreatedBy>
    ''' <param name="e"></param>
    ''' <remarks></remarks>
    Private Sub ExportClientAvailablesBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportClientAvailablesBindingSource.CurrentChanged
        Dim bs As System.Windows.Forms.BindingSource
        bs = TryCast(sender, System.Windows.Forms.BindingSource)
        controller.CurrentAvailableClient = TryCast(bs.Current, ExportClientAvailable)
    End Sub

    ''' <summary>Keeping track of the currently selected Avaliable Event (for moving if move button is pressed).</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportEventAvailableBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportEventAvailableBindingSource.CurrentChanged
        Dim bs As System.Windows.Forms.BindingSource
        bs = TryCast(sender, System.Windows.Forms.BindingSource)
        controller.CurrentAvailableEvent = TryCast(bs.Current, ExportEventAvailable)
    End Sub

    ''' <summary>Keeping track of the currently selected Avaliable Script (for moving if move button is pressed).</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportScriptAvailableBindingSource_CurrentChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportScriptAvailableBindingSource.CurrentChanged
        Dim bs As System.Windows.Forms.BindingSource
        bs = TryCast(sender, System.Windows.Forms.BindingSource)
        controller.CurrentAvailableScript = TryCast(bs.Current, ExportScriptAvailable)
    End Sub

    ''' <summary>Updates the Controller.ExportGroup property to mark it Dirty.</summary>
    ''' <remarks>It is nesessary for keeping track of the ExportGroup configuration
    ''' change status. If it's changed then it should prompt to save when the user
    ''' leaves current ExportGroup.</remarks>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Arman Mnatsakanyan</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub ExportGroupTextBox_LostFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles ExportGroupTextBox.LostFocus
        Me.controller.ExportGroup.Name = Me.ExportGroupTextBox.Text
    End Sub

    ''' <summary>This event handler changes the File properties label to include the name that is being typed in the export group name text box.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreatedBy>Tony Piccoli</CreatedBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportGroupTextBox_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportGroupTextBox.TextChanged
        Me.lblExportGroupProperties.Text = "File Properties for " & Me.ExportGroupTextBox.Text
    End Sub
End Class
