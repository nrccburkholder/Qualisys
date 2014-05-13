Imports Nrc.DataMart.Library
Imports System.Collections.ObjectModel

''' <summary>This class represents a dialog form that allows the user to export
''' multiple export sets to multiple files of the same type (xml, csv,
''' dbf).</summary>
''' <CreateBy>Jeff Fleming</CreateBy>
''' <RevisionList><list type="table">
''' <listheader>
''' <term>Date Modified - Modified By</term>
''' <description>Description</description></listheader>
''' <item>
''' <term>20071203 - TP</term>
''' <description>Multiple changes to allow for team number combo box, repopulating
''' the data grid when team number changes, and disabling the export button until a
''' team number is seleted.</description></item>
''' <item>
''' <term>	</term>
''' <description>
''' <para></para></description></item></list></RevisionList>
Public Class ExportManyFilesDialog

    Private mExportSets As Collection(Of ExportSet)
    Private mSurveyCache As New Dictionary(Of Integer, Survey)
    Private mStudyCache As New Dictionary(Of Integer, Study)
    Private mClientCache As New Dictionary(Of Integer, Client)
    Private mExportFileName As String
    Private mSelectedTeam As String = "TeamNum"
    Private mScheduleForExport As Boolean
    Private mNewId As Integer = 0
    'TP 20071204
    Private mTeams As Collection(Of Team)

#Region " Constructors "
    Public Sub New()
        ' This call is required by the Windows Form Designer.
        InitializeComponent()
    End Sub
    ''' <summary>Constructor overload that inits form vars and set the inital state of the form.</summary>
    ''' <param name="exportSets"></param>
    ''' <param name="scheduleForExport"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Public Sub New(ByVal exportSets As Collection(Of ExportSet), ByVal scheduleForExport As Boolean)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        Me.mExportSets = exportSets
        Me.mScheduleForExport = scheduleForExport
        Me.DatePanel.Visible = False
        Me.RunDate.Value = Date.Today

        'Select the proper defaults for the include options
        Select Case Me.mExportSets(0).ExportSetType
            Case ExportSetType.Standard
                Me.IncludeOnlyReturns.Enabled = True
                Me.IncludeOnlyDirects.Enabled = True
                Me.IncludePhoneFields.Visible = True

            Case ExportSetType.CmsHcahps, ExportSetType.CmsHHcahps, ExportSetType.CmsChart
                Me.IncludeOnlyReturns.Enabled = False
                Me.IncludeOnlyReturns.Checked = False

                Me.IncludeOnlyDirects.Enabled = False
                Me.IncludeOnlyDirects.Checked = True
                Me.IncludePhoneFields.Visible = False
        End Select

        If Me.mScheduleForExport Then
            Me.Caption = "Schedule File Creation"
            Me.ExportButton.Text = "Schedule"
            Me.DatePanel.Visible = True
            Me.FolderPanel.Visible = False
            'Me.FileNameColumn.Visible = False
            'Me.ExportSetColumn.AutoSizeMode = DataGridViewAutoSizeColumnMode.Fill
        End If
    End Sub
#End Region

#Region " Private Properties "
    ''' <summary>This property is a FileTypeItem class based of of the value in the fileTypeList form control (combobox).</summary>
    ''' <value></value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SelectedFileType() As FileTypeItem
        Get
            Return TryCast(Me.FileTypeList.SelectedItem, FileTypeItem)
        End Get
    End Property

    Public ReadOnly Property GetNewId() As Integer
        Get
            Return mNewId
        End Get
    End Property

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
    Private Property SelectedTeam() As String
        Get
            Return mSelectedTeam
        End Get
        Set(ByVal value As String)
            mSelectedTeam = value
        End Set
    End Property
    ''' <summary>Returns a survey based on the given survey ID.  If value doesn't exist, it fetches the object.</summary>
    ''' <param name="id"></param>
    ''' <value></value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property SurveyCache(ByVal id As Integer) As Survey
        Get
            If Not mSurveyCache.ContainsKey(id) Then
                mSurveyCache.Add(id, Survey.GetSurvey(id))
            End If

            Return mSurveyCache(id)
        End Get
    End Property

    ''' <summary>Returns a Study based on the given study ID.  If value doesn't exist, it fetches the object.</summary>
    ''' <param name="id">Study ID</param>
    ''' <value></value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property StudyCache(ByVal id As Integer) As Study
        Get
            If Not mStudyCache.ContainsKey(id) Then
                mStudyCache.Add(id, Study.GetStudy(id))
            End If

            Return mStudyCache(id)
        End Get
    End Property

    ''' <summary>Returns a Client based on the given study ID.  If value doesn't exist, it fetches the object.</summary>
    ''' <param name="id">Client ID</param>
    ''' <value></value>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private ReadOnly Property ClientCache(ByVal id As Integer) As Client
        Get
            If Not mClientCache.ContainsKey(id) Then
                mClientCache.Add(id, Client.GetClient(id))
            End If

            Return mClientCache(id)
        End Get
    End Property
#End Region

#Region " Control Event Handlers "

    ''' <summary>Populuates the data grid, output folder (text box) and list of
    ''' available file types.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20071203 - TP</term>
    ''' <description>Moved some of the logic in this event to a common method so that it
    ''' could be reused.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Sub ExportFileDialog_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        'Load the available file types
        Me.PopulateFileTypes()

        'TP 20071204
        Me.LoadTeams()
        'Load the output files with their proposed file names
        'TP 20071203 Moved logic to common method
        Me.LoadDataGrid()

        'Initialize the output path
        If String.IsNullOrEmpty(My.Settings.LastExportPath) Then
            Me.OutputPath.Text = My.Computer.FileSystem.SpecialDirectories.MyDocuments
        Else
            Me.OutputPath.Text = My.Settings.LastExportPath
        End If

    End Sub

    ''' <summary>When a team number is selected, change the data grid to reflect the new file names.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Tony Piccoli</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub cboTeam_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboTeam.SelectedIndexChanged
        Me.SelectedTeam = Me.cboTeam.Text
        Me.ExportDataGrid.Rows.Clear()
        'Me.mExportFileName = ExistingDefinitionsControl.GetExportFileName(Me.mExportSets, cboTeam.Text)
        LoadDataGrid()
        ExportButton.Enabled = True
    End Sub

    ''' <summary>When the selected file extension changes, change the file names in the data grid to reflect the current file extension.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub FileTypeList_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FileTypeList.SelectedIndexChanged
        For Each row As DataGridViewRow In Me.ExportDataGrid.Rows
            Dim cell As DataGridViewCell = row.Cells(Me.FileNameColumn.Index)
            Dim fileName As String = cell.Value.ToString
            If fileName.IndexOf(".") > -1 Then
                fileName = fileName.Substring(0, fileName.LastIndexOf("."))
            End If
            cell.Value = fileName & "." & Me.SelectedFileType.Extension
        Next
    End Sub

    ''' <summary>Browse to select a folder path that you wish the newly created files to be copied to.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub BrowseButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseButton.Click
        If System.IO.Directory.Exists(Me.OutputPath.Text) Then
            Me.FolderBrowser.SelectedPath = Me.OutputPath.Text
        End If

        If Me.FolderBrowser.ShowDialog = Windows.Forms.DialogResult.OK Then
            Me.OutputPath.Text = Me.FolderBrowser.SelectedPath
            My.Settings.LastExportPath = Me.FolderBrowser.SelectedPath
        End If
    End Sub

    ''' <summary>If sheduled, schedule the selected files for export.  Else, export the files to the given output path.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportButton.Click
        Try
            Me.Cursor = Cursors.WaitCursor
            'Populate filenames collection used to insure unique file names.
            Dim objFileNames As FileNames = SetFileNames()
            For Each row As DataGridViewRow In Me.ExportDataGrid.Rows
                Dim export As ExportSet = TryCast(row.Tag, ExportSet)

                If Not Me.mScheduleForExport Then
                    'Create the files
                    Dim fileName As String = System.IO.Path.Combine(Me.OutputPath.Text, row.Cells(Me.FileNameColumn.Index).Value.ToString)
                    'Make sure there are no duplicate file names.
                    fileName = objFileNames.GetFileName(fileName)
                    Try
                        mNewId = ExportFile.CreateExportFile(export, fileName, Me.SelectedFileType.ExportFileType, Me.IncludeOnlyReturns.Checked, Me.IncludeOnlyDirects.Checked, Me.IncludePhoneFields.Checked, CurrentUser.UserName, False)
                    Catch ex As ExportFileCreationException
                        If ex.ExceptionCause = ExportFileCreationException.ExportExceptionCause.ZeroRecordsFound Then
                            MessageBox.Show("No matching results were found for the following export definition:" & vbCrLf & vbCrLf & fileName, "No Results Exported", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Else
                            Throw
                        End If

                    End Try
                Else
                    'Schedule the files
                    Dim sets As New Collection(Of ExportSet)
                    sets.Add(export)

                    Dim fileName As String = Nrc.Framework.IO.Path.CleanFileName(row.Cells(Me.FileNameColumn.Index).Value.ToString)
                    '20071213 TP Remove the file extension for scheduled exports.
                    fileName = RemoveFileExtension(fileName)
                    'Schedule for export
                    ScheduledExport.CreateNew(sets, Me.RunDate.Value, Me.IncludeOnlyReturns.Checked, Me.IncludeOnlyDirects.Checked, Me.IncludePhoneFields.Checked, Me.SelectedFileType.ExportFileType, fileName, CurrentUser.UserName)

                End If
            Next

            Me.DialogResult = Windows.Forms.DialogResult.OK
        Catch ex As Exception
            ReportException(ex, "Error Creating Export File")
        Finally
            Me.Cursor = Cursors.Default
        End Try

    End Sub

    ''' <summary>If a cell in the data grid is editable, this method makes sure that no invalid values are entered.</summary>
    ''' <param name="sender"></param>
    ''' <param name="e"></param>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub ExportDataGrid_CellEndEdit(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles ExportDataGrid.CellEndEdit
        If e.ColumnIndex = Me.FileNameColumn.Index Then
            Dim cell As DataGridViewCell = Me.ExportDataGrid.Rows(e.RowIndex).Cells(e.ColumnIndex)
            If Not String.IsNullOrEmpty(cell.Value.ToString) Then
                cell.Value = Nrc.Framework.IO.Path.CleanFileName(cell.Value.ToString)
            End If

            If cell.Value.ToString = "" Then
                Dim srvyCell As DataGridViewCell = Me.ExportDataGrid.Rows(e.RowIndex).Cells(SurveyColumn.Index)
                Dim exportCell As DataGridViewCell = Me.ExportDataGrid.Rows(e.RowIndex).Cells(ExportSetColumn.Index)
                cell.Value = Me.GetDefaultFileName(srvyCell.Value.ToString, exportCell.Value.ToString)
            End If
        End If
    End Sub

#End Region

#Region " Private Methods "
    ''' <summary>This method removes an extension (ex, .xml) from a file name
    ''' string.</summary>
    ''' <param name="filename">The filename whose extension you wish to remove.</param>
    ''' <returns>The passed in file name minus the extension.</returns>
    ''' <CreateBy>Tony Piccoli</CreateBy>
    ''' <RevisionList><list type="table">
    ''' <listheader>
    ''' <term>Date Modified - Modified By</term>
    ''' <description>Description</description></listheader>
    ''' <item>
    ''' <term>20071213 - Tony Piccoli</term>
    ''' <description>Created the method.</description></item>
    ''' <item>
    ''' <term>	</term>
    ''' <description>
    ''' <para></para></description></item></list></RevisionList>
    Private Function RemoveFileExtension(ByVal filename As String) As String
        Dim retVal As String = filename
        If filename.LastIndexOf("."c) > 0 Then
            retVal = filename.Substring(0, filename.LastIndexOf("."c))
        End If
        Return retVal
    End Function
    ''' <summary>If HCAHPS, then populate the teams combo box.</summary>
    ''' <CreateBy>Tony Piccoli</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadTeams()
        If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
            For Each t As Team In Me.Teams
                cboTeam.Items.Add(t.Id)
            Next
        End If
    End Sub
    ''' <summary>Add the appropriate file extensions to the FileTypeList combo box.</summary>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub PopulateFileTypes()
        Me.FileTypeList.Items.Add(New FileTypeItem(ExportFileType.DBase, "dBase File (.dbf)", "dbf"))
        Me.FileTypeList.Items.Add(New FileTypeItem(ExportFileType.Csv, "CSV File (.csv)", "csv"))
        Me.FileTypeList.Items.Add(New FileTypeItem(ExportFileType.Xml, "XML File (.xml)", "xml"))

        Select Case Me.mExportSets(0).ExportSetType
            Case ExportSetType.CmsHcahps, ExportSetType.CmsHHcahps, ExportSetType.CmsChart
                Me.FileTypeList.SelectedIndex = 2
            Case Else
                Me.FileTypeList.SelectedIndex = 0
        End Select
    End Sub

    ''' <summary>Load the data grid from values based on the form and the passed in export set.</summary>
    ''' <CreateBy>Tony Piccoli</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Sub LoadDataGrid()
        For Each export As ExportSet In Me.mExportSets
            Dim srvy As Survey = SurveyCache(export.SurveyId)
            Dim stdy As Study = StudyCache(srvy.StudyId)
            Dim clnt As Client = ClientCache(stdy.ClientId)

            Dim newRow As Integer
            If MainForm.CmsDefinitionTab.IsActive = True OrElse MainForm.CHARTExportsTab.IsActive = True Then
                Me.FileNameColumn.ReadOnly = True
                Me.OutputPath.ReadOnly = True
                'TP 20071203 Made the file type dynamic to allow reuse of this method.
                'newRow = Me.ExportDataGrid.Rows.Add(clnt.Name, stdy.Name, srvy.Name, export.Name, mExportFileName & ".xml")
                newRow = Me.ExportDataGrid.Rows.Add(clnt.Name, stdy.Name, srvy.Name, export.Name, ExistingDefinitionsControl.GetExportFileName(export, SelectedTeam) & "." & Me.SelectedFileType.Extension)
                'TP 20071203  Show the Team combo and disable the export button until a team is selected.
                Me.TeamPanel.Visible = True
                Me.ExportButton.Enabled = False
                'ElseIf MainForm.HHCAHPSExportsTab.IsActive = True Then
                '    Me.FileNameColumn.ReadOnly = True
                '    Me.OutputPath.ReadOnly = True
                '    newRow = Me.ExportDataGrid.Rows.Add(clnt.Name, stdy.Name, srvy.Name, export.Name, ExistingDefinitionsControl.GetExportFileName(export, "HH") & "." & Me.SelectedFileType.Extension)
                '    Me.TeamPanel.Visible = False
                '    Me.ExportButton.Enabled = False
            Else
                If Me.mScheduleForExport Then
                    newRow = Me.ExportDataGrid.Rows.Add(clnt.Name, stdy.Name, srvy.Name, export.Name, Me.GetDefaultFileName(export.Name))
                Else
                    newRow = Me.ExportDataGrid.Rows.Add(clnt.Name, stdy.Name, srvy.Name, export.Name, Me.GetDefaultFileName(srvy.Name, export.Name))
                End If
            End If

            Me.ExportDataGrid.Rows(newRow).Tag = export
        Next
    End Sub

    ''' <summary>Loops through the givven string to check for invalid characters and replaces them with an empty string.</summary>
    ''' <param name="exportName">The entered export name</param>
    ''' <returns>Export Name as a string.</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function GetDefaultFileName(ByVal exportName As String) As String
        Return Nrc.Framework.IO.Path.CleanFileName(exportName)
    End Function

    ''' <summary>Concats the surveyname, exportname and file extention and replaces invalid characters with an empty string.</summary>
    ''' <param name="surveyName"></param>
    ''' <param name="exportName"></param>
    ''' <returns>A file name based on the survey name, export name and selected file extention.</returns>
    ''' <CreateBy>Jeff Fleming</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function GetDefaultFileName(ByVal surveyName As String, ByVal exportName As String) As String
        Dim fileName As String = String.Format("{0} ({1}).{2}", surveyName, exportName, Me.SelectedFileType.Extension)
        Return Nrc.Framework.IO.Path.CleanFileName(fileName)
    End Function

    ''' <summary>This is a helper class to allow us to check if multiple file of the same name are being exported.  If so, we make sure the file names are distinct by appending and underscore and number to the end of the filename.</summary>
    ''' <CreateBy>Tony Piccoli</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Class FileNames
        Private mFileNames As Collection(Of FileName) = New Collection(Of FileName)

        ''' <summary>We adding file names to the collection, if not unique, increment the file objects index, and flag that the existing file, and the one your are adding (creating).</summary>
        ''' <param name="fn">The passed in file name</param>
        ''' <CreateBy>Tony Piccoli</CreateBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Sub Add(ByVal fn As String)
            Dim index As Integer = 1
            Dim blnAlreadyExists As Boolean = False
            For Each f As FileName In mFileNames
                If f.Name = fn Then
                    f.MultNamesExist = True
                    blnAlreadyExists = True
                    index += 1
                End If
            Next
            Dim tempFile As FileName = New FileName(fn, index)
            tempFile.MultNamesExist = blnAlreadyExists
            mFileNames.Add(tempFile)
        End Sub

        ''' <summary>Return the file name with the appended underscore and number if needed.</summary>
        ''' <param name="fn">The passed in file name.</param>
        ''' <returns>the file name (append with an underscore and number if needed)</returns>
        ''' <CreateBy>Tony Piccoli</CreateBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Public Function GetFileName(ByVal fn As String) As String
            Dim retVal As String = ""
            For Each f As FileName In Me.mFileNames
                If f.Name.ToLower() = fn.ToLower Then
                    If f.IsDirty = False Then
                        Return f.ToString()
                    End If
                End If
            Next
            Return retVal
        End Function

        ''' <summary>This helper class hold a file name plus member to tell whether another file of the same namer exists and whether the file name has been used.  The to string method is overriden to allow you to return a unique file name once and only once.</summary>
        ''' <CreateBy>Tony Piccoli</CreateBy>
        ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
        Private Class FileName
            Private mName As String
            Private mIndex As Integer
            Private mIsDirty As Boolean
            Private mMultNamesExist As Boolean

            ''' <summary>File name Constructor.</summary>
            ''' <param name="name">The FileName for the object</param>
            ''' <param name="index">If the filename already exists in the parent collection, this records its index.</param>
            ''' <CreateBy>Tony Piccoli</CreateBy>
            ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
            Public Sub New(ByVal name As String, ByVal index As Integer)
                Me.mIndex = index
                Me.mName = name
            End Sub

            ''' <summary>Tell you whether a file object of the same name already exists in the parent collection.</summary>
            ''' <value></value>
            ''' <CreateBy>Tony Piccoli</CreateBy>
            ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
            Public Property MultNamesExist() As Boolean
                Get
                    Return Me.mMultNamesExist
                End Get
                Set(ByVal value As Boolean)
                    Me.mMultNamesExist = value
                End Set
            End Property

            ''' <summary>If the parent collection contains multiple file objects with the same name, this tells you the files index.</summary>
            ''' <value></value>
            ''' <CreateBy>Tony Piccoli</CreateBy>
            ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
            Public ReadOnly Property Index() As Integer
                Get
                    Return mIndex
                End Get
            End Property
            ''' <summary>The file name of the file object.</summary>
            ''' <value></value>
            ''' <CreateBy>Tony Piccoli</CreateBy>
            ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
            Public ReadOnly Property Name() As String
                Get
                    Return mName
                End Get
            End Property

            ''' <summary>Each time a file name is read (via the toString override), the object is marked as dirty.  This way, if you don't duplicate the file names when retrieving them from a collection</summary>
            ''' <value></value>
            ''' <CreateBy>Tony Piccoli</CreateBy>
            ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
            Public ReadOnly Property IsDirty() As Boolean
                Get
                    Return Me.mIsDirty
                End Get
            End Property

            ''' <summary>Returns the file name (with a unique underscore plus index if needed).  To String method marks as dirty once read so that if multiple object with the same name exist, it will return the next filename in the parent collection.</summary>
            ''' <returns></returns>
            ''' <CreateBy>Tony Piccoli</CreateBy>
            ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
            Public Overrides Function ToString() As String
                Dim retVal As String = ""
                If Me.MultNamesExist = True Then
                    If mName.LastIndexOf("."c) = mName.Length - 4 Then
                        Dim ext As String = mName.Substring(mName.Length - 4)
                        Dim fn As String = mName.Substring(0, mName.Length - 4)
                        retVal = fn & "_" & mIndex.ToString() & ext
                    Else
                        retVal = mName & "_" & mIndex.ToString()
                    End If
                Else
                    retVal = mName
                End If
                mIsDirty = True
                Return retVal
            End Function
        End Class
    End Class

    ''' <summary>Loops through the definitions, collection all selected file names into a collection.</summary>
    ''' <returns>A FileNames object that will allow you to retreive a unique file name.</returns>
    ''' <CreateBy>Tony Piccoli</CreateBy>
    ''' <RevisionList><list type="table"><listheader><term>Date Modified - Modified By</term><description>Description</description></listheader><item><term></term><description></description></item><item><term></term><description></description></item></list></RevisionList>
    Private Function SetFileNames() As FileNames
        Dim fileNames As FileNames = New FileNames()
        For Each row As DataGridViewRow In Me.ExportDataGrid.Rows
            Dim export As ExportSet = TryCast(row.Tag, ExportSet)
            If Not Me.mScheduleForExport Then
                'Create the files
                Dim fileName As String = System.IO.Path.Combine(Me.OutputPath.Text, row.Cells(Me.FileNameColumn.Index).Value.ToString)
                fileNames.Add(fileName)
            End If
        Next
        Return fileNames
    End Function

#End Region


End Class
