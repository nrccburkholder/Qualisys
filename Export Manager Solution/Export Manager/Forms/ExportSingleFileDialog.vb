Imports Nrc.DataMart.Library
Imports System.Collections.ObjectModel
''' <summary>This class represents a dialog form that allows the user to export
''' a single or multiple export sets to a single files of the same type (xml, csv,
''' dbf).</summary>
''' <CreateBy>Jeff Fleming</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>20071203 - TP</term>
''' <description>Multiple changes to allow for team number combo box and disabling the export button until a
''' team number is seleted.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Public Class ExportSingleFileDialog

    Private mExports As Collection(Of ExportSet)
    Private mExportFileNameNoExtension As String
    Private mScheduleForExport As Boolean
    Private mNewId As Integer = 0

    Private mTeams As Collection(Of Team)

#Region " Constructors "
    Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
    End Sub
    ''' <summary>Constructor overload that inits form vars and set the inital state of the form.</summary>
    ''' <param name="exportSets"></param>
    ''' <param name="scheduleForExport"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Sub New(ByVal exportSets As Collection(Of ExportSet), ByVal pExportFileName As String, ByVal scheduleForExport As Boolean)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mExports = exportSets
        ExportFileNameNoExtension = pExportFileName
        mScheduleForExport = scheduleForExport
        Me.DatePanel.Visible = False
        Me.FileNamePanel.Visible = False
        Me.RunDate.Value = Date.Today

        'Select the proper defaults for the include options
        Select Case Me.mExports(0).ExportSetType
            Case ExportSetType.Standard
                Me.IncludeOnlyReturns.Enabled = True
                Me.IncludeOnlyDirects.Enabled = True
                Me.IncludePhoneFields.Visible = True
            Case ExportSetType.CmsHcahps, ExportSetType.CmsHHcahps, ExportSetType.CmsChart
                Me.IncludeOnlyReturns.Enabled = False
                Me.IncludeOnlyReturns.Checked = False

                Me.IncludeOnlyDirects.Enabled = False
                Me.IncludeOnlyDirects.Checked = True
                'My.Settings.LastExportPath & "\" & ExportFileName
                Me.IncludePhoneFields.Visible = False
        End Select


        If mScheduleForExport Then
            Me.Caption = "Schedule File Creation"
            Me.ExportButton.Text = "Schedule"
            Me.DatePanel.Visible = True
            Me.FileNamePanel.Visible = True
            Me.FilePathPanel.Visible = False
        End If

        'Create a default name if only 1 export was chosen
        If Me.mExports.Count = 1 Then Me.FileNameTextBox.Text = Nrc.Framework.IO.Path.CleanFileName(mExports(0).Name)

    End Sub
#End Region

#Region " Private Properties "
    ''' <summary>Retrieves a collection of teams to be used in the team combo box.</summary>
    ''' <value></value>
    ''' <CreateBy>Tony Piccoli</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property Teams() As Collection(Of Team)
        Get
            If Me.mTeams Is Nothing Then
                mTeams = Team.GetTwoDigitTeams()
            End If
            Return mTeams
        End Get
    End Property

    ''' <summary>Retrieves the last windows file path used during a file directory browse function</summary>
    ''' <value></value>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property FullOutputPath() As String
        Get
            Dim backSlash As String = "\"
            If LastExportPath.EndsWith("\") Then backSlash = ""
            Return LastExportPath & backSlash & ExportFileName
        End Get
    End Property

    ''' <summary>This property is must be set to true to enable export to a file</summary>
    ''' <value></value>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private WriteOnly Property ExportEnabled() As Boolean
        Set(ByVal value As Boolean)
            Me.FileNamePanel.Visible = value
            Me.FileTypePanel.Visible = value
            Me.ExportButton.Enabled = value
        End Set
    End Property
    
    ''' <summary>Holds the export file name passed as a constructor parameter to this control</summary>
    ''' <value></value>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Property ExportFileNameNoExtension() As String
        Get
            If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
                Return SelectedTeam & mExportFileNameNoExtension

                'ElseIf MainForm.HHCAHPSExportsTab.IsActive = True Then
                '    Return "HH" & mExportFileNameNoExtension

            Else
                Return mExportFileNameNoExtension
            End If
        End Get
        Set(ByVal value As String)
            mExportFileNameNoExtension = value
        End Set
    End Property
    Private ReadOnly Property SelectedTeam() As String
        Get
            If Me.cboTeam IsNot Nothing AndAlso (Not String.IsNullOrEmpty(Me.cboTeam.Text)) Then
                Return Me.cboTeam.Text
            Else
                Return "TeamNum"
            End If
        End Get
    End Property
    ''' <summary>Retrieves the export file name and its file extension</summary>
    ''' <value></value>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property ExportFileName() As String
        Get
            If Not String.IsNullOrEmpty(mExportFileNameNoExtension) Then
                Return ExportFileNameNoExtension & "." & Me.SelectedFileType.Extension
            Else
                Return ""
            End If
        End Get
    End Property
    ''' <summary>Retrieves the export file format type</summary>
    ''' <value></value>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SelectedFileType() As FileTypeItem
        Get
            If Me.FileTypeList.SelectedItem IsNot Nothing Then
                Return TryCast(Me.FileTypeList.SelectedItem, FileTypeItem)
            Else
                Return New FileTypeItem(ExportFileType.Xml, "XML", "XML")
            End If
        End Get
    End Property
    ''' <summary>Retrieve the new export file id</summary>
    ''' <value></value>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public ReadOnly Property GetNewId() As Integer
        Get
            Return mNewId
        End Get
    End Property
    ''' <summary>This property stores the file path for the last export file</summary>
    ''' <value></value>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Property LastExportPath() As String
        Get
            If String.IsNullOrEmpty(My.Settings.LastExportPath) Then
                Return My.Computer.FileSystem.SpecialDirectories.MyDocuments
            Else
                Return My.Settings.LastExportPath
            End If
        End Get
        Set(ByVal value As String)
            My.Settings.LastExportPath = value
        End Set
    End Property
#End Region

#Region " Control Events Handlers"
    ''' <summary>This event handler initially loads the dialog form</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportSingleFileDialog_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Initialize the output path
        Me.FileBrowser.InitialDirectory = LastExportPath
        Me.FilePathPanel.Visible = Not Me.mScheduleForExport

        If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
            Me.ExportEnabled = False '2007-11-19
            Me.OutputPath.Text = FullOutputPath
            Me.FileNameTextBox.Text = mExportFileNameNoExtension
            Me.FileNameTextBox.ReadOnly = True
            Me.OutputPath.ReadOnly = True
            '20071203
            Me.TeamPanel.Visible = True

            For Each t As Team In Me.Teams
                cboTeam.Items.Add(t.Id)
            Next
            'ElseIf MainForm.HHCAHPSExportsTab.IsActive = True Then
            '    Me.ExportEnabled = True
            '    Me.OutputPath.Text = FullOutputPath
            '    Me.FileNameTextBox.Text = mExportFileNameNoExtension
            '    Me.FileNameTextBox.ReadOnly = True
            '    Me.OutputPath.ReadOnly = True
            '    Me.TeamPanel.Visible = False
        Else
            If Me.mExports.Count = 1 Then
                Me.FileNameTextBox.Text = Me.mExports(0).Name
                Me.ExportFileNameNoExtension = Me.mExports(0).Name
            Else
                Me.FileNameTextBox.Text = ""
                Me.ExportFileNameNoExtension = ""
            End If
        End If

        'Populate the possible file types
        Me.PopulateFileTypes()
    End Sub

    ''' <summary>This event handler changes the file extension on the export file name when a different file type is choosen</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub FileTypeList_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles FileTypeList.SelectedIndexChanged
        Me.OutputPath.Text = Me.FullOutputPath()
        Me.FileNameTextBox.Text = Me.ExportFileNameNoExtension

        'End If
    End Sub

    ''' <summary>This event handler calls a file browser dialog box to appear when the browse button is clicked</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
            If Me.FolderBrowserDialog.ShowDialog = Windows.Forms.DialogResult.OK Then
                Dim BackSlash As String = "\"
                If Me.FolderBrowserDialog.SelectedPath.EndsWith("\") Then BackSlash = ""
                Me.OutputPath.Text = Me.FolderBrowserDialog.SelectedPath & BackSlash & ExportFileName 'mExportFileNameNoExtension & "." & Me.SelectedFileType.Extension
                My.Settings.LastExportPath = Me.FolderBrowserDialog.SelectedPath
            End If
        Else
            Me.FileBrowser.Filter = Me.SelectedFileType.Label & "|*." & Me.SelectedFileType.Extension
            Me.FileBrowser.DefaultExt = Me.SelectedFileType.Extension
            'Me.FileBrowser.ShowDialog()
            If Me.mExports.Count = 1 Then
                Me.FileBrowser.FileName = Nrc.Framework.IO.Path.CleanFileName(mExports(0).Name)
            End If

            If Me.FileBrowser.ShowDialog = Windows.Forms.DialogResult.OK Then
                Me.OutputPath.Text = Me.FileBrowser.FileName
                My.Settings.LastExportPath = System.IO.Path.GetDirectoryName(Me.FileBrowser.FileName)
            End If
        End If
    End Sub

    ''' <summary>This event handler initiates the creation of the export file when the export button is clicked</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            If Not Me.mScheduleForExport Then
                'Export the file
                If Me.OutputPath.Text <> "" Then
                    'Write the export file
                    Try
                        mNewId = ExportFile.CreateExportFile(mExports, Me.OutputPath.Text, Me.SelectedFileType.ExportFileType, Me.IncludeOnlyReturns.Checked, Me.IncludeOnlyDirects.Checked, Me.IncludePhoneFields.Checked, CurrentUser.UserName, False)
                    Catch ex As ExportFileCreationException
                        If ex.ExceptionCause = ExportFileCreationException.ExportExceptionCause.ZeroRecordsFound Then
                            MessageBox.Show("No matching results were found for the export definition.", "No Results Exported", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Else
                            Throw
                        End If
                    End Try
                End If
            Else
                'Schedule for export
                ScheduledExport.CreateNew(mExports, RunDate.Value, Me.IncludeOnlyReturns.Checked, Me.IncludeOnlyDirects.Checked, Me.IncludePhoneFields.Checked, Me.SelectedFileType.ExportFileType, Nrc.Framework.IO.Path.CleanFileName(Me.FileNameTextBox.Text), CurrentUser.UserName)

            End If

            Me.DialogResult = Windows.Forms.DialogResult.OK
        Catch ex As Exception
            ReportException(ex, "Error Creating Export File")
        Finally
            Me.Cursor = Cursors.Default
        End Try
    End Sub

#End Region

#Region " Private Methods "

    ''' <summary>This event handler populates the file type combo box with its value set during form load</summary>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub PopulateFileTypes()
        Me.FileTypeList.Items.Add(New FileTypeItem(ExportFileType.DBase, "dBase File (.dbf)", "dbf"))
        Me.FileTypeList.Items.Add(New FileTypeItem(ExportFileType.Csv, "CSV File (.csv)", "csv"))
        Me.FileTypeList.Items.Add(New FileTypeItem(ExportFileType.Xml, "XML File (.xml)", "xml"))

        Select Case Me.mExports(0).ExportSetType
            Case ExportSetType.CmsHcahps, ExportSetType.CmsHHcahps, ExportSetType.CmsChart
                Me.FileTypeList.SelectedIndex = 2
            Case Else
                Me.FileTypeList.SelectedIndex = 0
        End Select
    End Sub

#End Region

    '2007-11-19
    ''' <summary>This event handler changes the export file name when a team number is selected, and then enables the export button</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Steve Grunberg</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cboTeam_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboTeam.SelectedIndexChanged
        'If String.IsNullOrEmpty(ExportFileNameNoExtension) Then
        'Me.ExportFileNameNoExtension = ExistingDefinitionsControl.GetExportFileName(Me.mExports(0), Me.cboTeam.Text)
        'End If
        Me.FileNameTextBox.Text = Me.ExportFileNameNoExtension
        Me.OutputPath.Text = FullOutputPath
        Me.ExportEnabled = True
        Me.FilePathPanel.Visible = Not Me.mScheduleForExport
    End Sub

End Class