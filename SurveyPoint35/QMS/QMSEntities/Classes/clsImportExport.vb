Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsImportExport
    Private _sWorkingFile As String
    Private _sJobID As String = Nothing
    Private _iUserID As Integer = 0
    Private _iEventID As Integer = 0
    Private _iFileDefID As Integer = 0
    Private _iImportSurveyInstanceID As Integer = 0
    Private _iImportedRows As Integer = 0
    Private _htFilters As Hashtable
    Private _htContactValidators As Hashtable
    Private _ds As dsImportExport
    Private _dsWorking As New DataSet
    Private _dtWorking As DataTable
    Private _oConn As SqlClient.SqlConnection
    Private _oTransaction As SqlClient.SqlTransaction
    Private _oFD As clsFileDefs
    Private _oFDC As clsFileDefColumns
    Private _oRespondents As clsRespondents
    Private _oResponses As clsResponses
    Private _oProperties As clsRespondentProperties
    Private _oEventLog As clsEventLog
    Private _oJobStatus As DMI.clsJobStatus
    Private _sbErr As New Text.StringBuilder
    Private _bHasRun As Boolean = False
    Private _sLogFilename As String
    Private _SimpleLog As DMI.clsSimpleLog

    Private Const WORKING_TABLENAME As String = "ImportExport"
    Public Const EXPORT_RESPONDENT_ID As String = "EXPORT_ROW_ID"
    Private Const RESPONDENT_DOB_COL_NAME As String = "Respondent: DOB"
    Private Const RESPONDENT_DOB_COL_DEFUALT_FORMAT As String = "d"

    Private Const MAX_RECORD_COUNT_PER_IMPORT_BATCH As Integer = 500

    Public Const JOB_PROPERTY_KEY_IMPORT_RECORD_COUNT As String = "JobProp - ImportRecordCount"

    Private m_ExportHeaders As Boolean = True

    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        'database connection
        _oConn = oConn
        If _oConn.State = ConnectionState.Closed Then _oConn.Open()

        'dataset
        _ds = New dsImportExport
        _ds.EnforceConstraints = True
    End Sub

    Public Sub New(ByVal oConn As SqlClient.SqlConnection, ByVal bPreCreateJob As Boolean)
        Me.New(oConn)

        If (bPreCreateJob) Then
            _sJobID = _oJobStatus.CreateJob()
        End If
    End Sub

    Public Sub Close()
        'clean up objects
        If Not IsNothing(_oFD) Then _oFD.Close()
        If Not IsNothing(_oFDC) Then _oFDC.Close()
        If Not IsNothing(_oRespondents) Then _oRespondents.Close()
        If Not IsNothing(_oResponses) Then _oResponses.Close()
        If Not IsNothing(_oProperties) Then _oProperties.Close()
        If Not IsNothing(_sJobID) Then _oJobStatus.RemoveJobNoThrow(_sJobID)
        _oFD = Nothing
        _oFDC = Nothing
        _oRespondents = Nothing
        _oResponses = Nothing
        _oProperties = Nothing
        _ds = Nothing
        _dtWorking = Nothing
        _dsWorking = Nothing
        _sbErr = Nothing

    End Sub

#Region "Properties"
    Public ReadOnly Property JobID() As String
        Get
            Return _sJobID
        End Get
    End Property

    Public Property WorkingFile() As String
        Get
            Return _sWorkingFile
        End Get
        Set(ByVal Value As String)
            _sWorkingFile = Value
        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return _iUserID
        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value
        End Set
    End Property

    Public Property LogEventID() As Integer
        Get
            Return _iEventID

        End Get
        Set(ByVal Value As Integer)
            _iEventID = Value

        End Set
    End Property

    Public Property FileDefID() As Integer
        Get
            Return _iFileDefID

        End Get
        Set(ByVal Value As Integer)
            _iFileDefID = Value

        End Set
    End Property

    Public ReadOnly Property FileDef() As clsFileDefs
        Get
            If IsNothing(_oFD) Then
                _oFD = New clsFileDefs(_oConn)
                _oFD.MainDataTable = _ds.Tables("FileDefs")
                'also init file def columns
                _oFDC = _oFD.FileDefColumns
                _oFDC.MainDataTable = _ds.Tables("FileDefColumns")

            End If

            Return _oFD

        End Get
    End Property

    Public ReadOnly Property FileDefColumns() As clsFileDefColumns
        Get
            If IsNothing(_oFDC) Then
                _oFDC = FileDef.FileDefColumns
                _oFDC.MainDataTable = _ds.Tables("FileDefColumns")

            End If

            Return _oFDC

        End Get
    End Property

    Public ReadOnly Property Respondents() As clsRespondents
        Get
            If IsNothing(_oRespondents) Then
                _oRespondents = New clsRespondents(_oConn)
                _oRespondents.MainDataTable = _ds.Tables("Respondents")

            End If

            Return _oRespondents

        End Get
    End Property

    Public ReadOnly Property Responses() As clsResponses
        Get
            If IsNothing(_oResponses) Then
                _oResponses = New clsResponses(_oConn)
                _oResponses.MainDataTable = _ds.Tables("Responses")

            End If

            Return _oResponses

        End Get
    End Property

    Public ReadOnly Property RespondentProperties() As clsRespondentProperties
        Get
            If IsNothing(_oProperties) Then
                _oProperties = New clsRespondentProperties(_oConn)
                _oProperties.MainDataTable = _ds.Tables("RespondentProperties")

            End If

            Return _oProperties

        End Get
    End Property

    Public ReadOnly Property EventLog() As clsEventLog
        Get
            If IsNothing(_oEventLog) Then
                _oEventLog = New clsEventLog(_oConn)
                _oEventLog.MainDataTable = _ds.Tables("EventLog")

            End If

            Return _oEventLog

        End Get
    End Property

    Public ReadOnly Property ErrorMsg() As String
        Get
            If IsNothing(_sbErr) Then
                Return ""
            Else
                Return _sbErr.ToString
            End If

        End Get
    End Property

    Public Property ImportToSurveyInstanceID() As Integer
        Get
            Return _iImportSurveyInstanceID

        End Get
        Set(ByVal Value As Integer)
            _iImportSurveyInstanceID = Value

        End Set
    End Property

    Public Property ExportFilters() As Hashtable
        Get
            Return _htFilters

        End Get
        Set(ByVal Value As Hashtable)
            _htFilters = Value

        End Set
    End Property

    Public Property InsertExportHeaderRow() As Boolean
        Get
            Return m_ExportHeaders
        End Get
        Set(ByVal Value As Boolean)
            m_ExportHeaders = Value
        End Set
    End Property

#End Region

#Region "Execute methods"

    'returns the job id
    Public Function Execute() As String
        Dim oThd As Threading.Thread
        Dim sTmpJobID As String = Nothing

        If (_bHasRun) Then
            Throw New InvalidOperationException("This instance of the Import/Export class has already been used. Any instace of clsImportExport can only be executed once.")
        End If

        'validate parameters
        If VerifyExecute() Then

            'update activated bit
            _bHasRun = True

            'create a new job
            If (_sJobID Is Nothing) Then
                _sJobID = _oJobStatus.CreateJob()
            End If

            'store a local copy of the job id in case the worker thread resets it before we can return
            sTmpJobID = _sJobID

            'build working table
            CreateWorkingTable()

            'determine import or export
            Dim iFileDefTypeID As Integer = CInt(FileDef.MainDataTable.Rows(0).Item("FileDefTypeID"))
            If iFileDefTypeID = 1 OrElse iFileDefTypeID = 3 Then
                'Export file def
                oThd = New Threading.Thread(AddressOf ExecuteExport)
                oThd.Priority = Threading.ThreadPriority.BelowNormal
                oThd.Start()
                'ExecuteExport()
            Else
                'Import file def
                If _iImportSurveyInstanceID = 0 Then
                    'import into dataset
                    oThd = New Threading.Thread(AddressOf ExecuteImportToDS)
                    oThd.Priority = Threading.ThreadPriority.BelowNormal
                    oThd.Start()
                    'ExecuteImportToDS()
                Else
                    'import into database for specified survey instance
                    oThd = New Threading.Thread(AddressOf ExecuteImportToDB)
                    oThd.Priority = Threading.ThreadPriority.BelowNormal
                    oThd.Start()
                    'ExecuteImportToDB()
                End If
            End If

            Return sTmpJobID
        End If

    End Function

#Region "Execute.Export methods"
    Private Sub ExecuteExport()
        System.Diagnostics.Debug.Assert(Not (_sJobID Is Nothing), "Undefined job id in ExecuteImport")
        Dim startTime As DateTime = DateTime.Now()
        Dim respondentsCount As Integer = 0
        Dim respondentsNdx As Integer = 0
        Dim respondentReader As Data.SqlClient.SqlDataReader = Nothing
        Dim exportFile As DMI.MultiUpdateFileWriter = Nothing
        Dim exportFileStreamWriterContainer As DMI.MultiUpdateFileWriterStreamContainer = Nothing

        Try
            clsJobStatus.SetStatus(_sJobID, 1)

            'generate respondents filters        
            Dim respondentsSearchRow As dsRespondents.SearchRow = CType(Respondents.NewSearchRow, dsRespondents.SearchRow)
            SetSearchCriteria(CType(respondentsSearchRow, DataRow))

            'get the respondents count
            Dim dxv As New clsDataExtractView(Me._oConn)
            dxv.SurveyID = respondentsSearchRow.SurveyID
            dxv.FileDefColumns = FileDefColumns
            respondentsCount = dxv.RespondentCount(respondentsSearchRow)

            clsJobStatus.SetStatus(_sJobID, 2)

            If respondentsCount > 0 Then
                'setup the file
                exportFile = SetupExportFile()
                exportFileStreamWriterContainer = exportFile.UpdateFileBegin()

                clsJobStatus.SetStatus(_sJobID, 3)

                'open explicit db connection for respondent datareader
                Dim oConnRespondent As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
                oConnRespondent.Open()

                'get the respondents data reader
                'respondentReader = dxv.GetRespondentIdDataReader(oConnRespondent, respondentsSearchRow)
                respondentReader = dxv.GetDXDataReader(oConnRespondent, respondentsSearchRow)
                clsJobStatus.SetStatus(_sJobID, 0, respondentsCount, 4, 97)

                'TP 20091015 The Reader is causing blocks, so quick change to DT.
                'Quick fix here. Need to rewrite the process to feed dataset to file processor.
                Dim respondentTable As New DataTable("respondentReader")
                For i As Integer = 0 To _dtWorking.Columns.Count - 1
                    respondentTable.Columns.Add(New DataColumn(_dtWorking.Columns(i).ColumnName, _dtWorking.Columns(i).DataType))
                Next
                If Not respondentTable.Columns.Contains(clsDataExtractView.RESPONDENT_ID_COLNAME) Then
                    respondentTable.Columns.Add(New DataColumn(clsDataExtractView.RESPONDENT_ID_COLNAME))
                End If
                While respondentReader.Read()
                    Dim respondentRow As DataRow
                    respondentRow = respondentTable.NewRow
                    CopyFromDXV(respondentReader, respondentRow)
                    respondentTable.Rows.Add(respondentRow)                    
                End While
                respondentTable.AcceptChanges()
                'close the data objects
                respondentReader.Close()
                respondentReader = Nothing
                oConnRespondent.Close()
                oConnRespondent = Nothing
                'Close the data reader.!!!
                'setup some working variables
                Dim respondentID As Integer
                Dim drNew As DataRow
                For j As Integer = 0 To respondentTable.Rows.Count - 1
                    Dim myRow As DataRow = respondentTable.Rows(j)
                    respondentID = CInt(myRow(clsDataExtractView.RESPONDENT_ID_COLNAME))
                    _dtWorking.Clear() 'TP 20090728
                    drNew = _dtWorking.NewRow
                    Dim c As DataColumn
                    'find all respondent columns in working table
                    For Each c In respondentTable.Columns
                        'dc.DestColName = c.ColumnName
                        'copy column value from data extract view to working table
                        If _dtWorking.Columns.Contains(c.ColumnName) Then
                            drNew(c.ColumnName) = myRow(c.ColumnName)
                        End If
                    Next
                    _dtWorking.Rows.Add(drNew)
                    _dtWorking.AcceptChanges()
                    'write the file
                    exportFile.UpdateFile(exportFileStreamWriterContainer, _dsWorking, WORKING_TABLENAME)
                    'log export events
                    LogExport(Me._oConn, respondentID)
                    respondentsNdx += 1
                    clsJobStatus.SetStatus(_sJobID, respondentsNdx, respondentsCount, 4, 97)
                    'log export progress every 1000 rows
                    If (respondentsNdx Mod 1000) = 0 Then
                        clsEventLog.InsertRow(Me._oConn, qmsEvents.EXPORT_INPROGRESS, _iUserID, String.Format("{0}: {1} Rows Exported", _sJobID, respondentsNdx))
                        'Throw New System.Exception("This is a test")
                    End If
                Next

                'While respondentReader.Read()
                '    'get the respondent ID for this data row
                '    respondentID = CInt(respondentReader.Item(dxv.RESPONDENT_ID_COLNAME))
                '    _dtWorking.Clear() 'TP 20090728

                '    'set up new row
                '    drNew = _dtWorking.NewRow
                '    'CopyFromDXV(respondentID, drNew, dxv)
                '    CopyFromDXV(respondentReader, drNew)

                '    'add row to working table
                '    '_dtWorking.Clear() TP 20090728
                '    _dtWorking.Rows.Add(drNew)

                '    'write the file
                '    exportFile.UpdateFile(exportFileStreamWriterContainer, _dsWorking, WORKING_TABLENAME)

                '    'log export events
                '    LogExport(Me._oConn, respondentID)

                '    respondentsNdx += 1
                '    _oJobStatus.SetStatus(_sJobID, respondentsNdx, respondentsCount, 4, 97)

                '    'log export progress every 1000 rows
                '    If (respondentsNdx Mod 1000) = 0 Then
                '        EventLog.InsertRow(Me._oConn, qmsEvents.EXPORT_INPROGRESS, _iUserID, String.Format("{0}: {1} Rows Exported", _sJobID, respondentsNdx))

                '    End If

                'End While

                ''close the data objects
                'respondentReader.Close()
                'respondentReader = Nothing
                'oConnRespondent.Close()
                'oConnRespondent = Nothing

                'close the file
                exportFile.UpdateFileEnd(exportFileStreamWriterContainer)
                exportFileStreamWriterContainer = Nothing
                exportFile = Nothing

                clsJobStatus.SetStatus(_sJobID, 98)

                'log completed export
                clsEventLog.InsertRow(Me._oConn, qmsEvents.EXPORT_COMPLETED, _iUserID, String.Format("{0}: {1} Rows Exported", _sJobID, respondentsNdx))

                clsJobStatus.SetStatus(_sJobID, 99)

                'turn off constraints before db update to avoid primary key error
                _ds.EnforceConstraints = False

                clsJobStatus.SetStatus(_sJobID, 100)

            End If
            dxv = Nothing

        Catch e As Exception
            clsEventLog.InsertRow(Me._oConn, qmsEvents.EXPORT_ERROR, _iUserID, String.Format("{0}: {1}", _sJobID, e.Message))

        Finally
            'make sure the file is closed
            If Not (exportFileStreamWriterContainer Is Nothing) Then
                exportFile.UpdateFileEnd(exportFileStreamWriterContainer)
                exportFileStreamWriterContainer = Nothing
                exportFile = Nothing
            End If

            'make sure the respondentsReader is closed
            If Not (respondentReader Is Nothing) Then
                If Not respondentReader.IsClosed() Then
                    respondentReader.Close()
                End If
                respondentReader = Nothing
            End If

            'dump the diagnostic info
            If respondentsCount > 0 Then
                Dim elapsedTime As TimeSpan = DateTime.Now().Subtract(startTime)
                Dim transferTimeSec As Double = elapsedTime.TotalMilliseconds / 1000.0
                Dim fa As System.IO.FileInfo = New System.IO.FileInfo(_sWorkingFile)
                Dim fileSizeKB As Double = fa.Length() / 1024.0
                fa = Nothing
                Dim kps As Double = fileSizeKB / transferTimeSec
                Debug.WriteLine(String.Format("Done exporting {0} respondents as a {1:#,0.0} KB file in {2:#,0.0000} seconds. Average Kps: {3}", respondentsNdx, fileSizeKB, transferTimeSec, kps))
            Else
                Debug.WriteLine("No respondents matched criteria. Nothing was exported.")
            End If

            'end job status
            clsJobStatus.RemoveJob(_sJobID)
            _sJobID = Nothing

            Close()
        End Try

    End Sub

    Private Function SetupExportFile() As DMI.MultiUpdateFileWriter
        Dim oFileIE As DMI.clsFileImportExport
        Dim dr As DataRow
        Dim sDelimiter As String
        Dim ft As DMI.FileTypes

        dr = FileDef.MainDataTable.Rows(0)
        ft = CType(dr.Item("FileTypeID"), DMI.FileTypes)

        If IsDBNull(dr.Item("FileDefDelimiter")) Then
            sDelimiter = ""
        Else
            sDelimiter = dr.Item("FileDefDelimiter").ToString
        End If

        oFileIE = DMI.clsFIEFactory.Make(ft, _sWorkingFile, sDelimiter)
        oFileIE.FileDef = GetImportExportFileDef()
        oFileIE.ExportHeaderRow = m_ExportHeaders

        Return CType(oFileIE, DMI.MultiUpdateFileWriter)
    End Function
#End Region  '#Region "Execute.Export methods"


    Private Sub ExecuteImportToDS()
        System.Diagnostics.Debug.Assert(Not (_sJobID Is Nothing), "Undefined job id in ExecuteImportToDS")
        Dim recordCount As Integer = -1

        Try
            _oJobStatus.SetStatus(_sJobID, 0)

            'import file to xml dataset files
            recordCount = Import_FileToDS()
            DMI.clsPersistedJobStorage.SetJobStorageValue(_sJobID, JOB_PROPERTY_KEY_IMPORT_RECORD_COUNT, recordCount)

            _oJobStatus.SetStatus(_sJobID, 100)
        Catch ex As Exception
            'TP Change
            Dim log As Logging.ILog = Logging.LogManager.GetLogger("ExecuteImportToDS")
            'Dim log As log4net.ILog = log4net.LogManager.GetLogger("ExecuteImportToDS")
            log.Error("ExecuteImportToDS", ex)
        Finally
            'end job status
            _oJobStatus.RemoveJob(_sJobID)
            _sJobID = Nothing
            Close()
        End Try
    End Sub

    Private Sub ExecuteImportToDB()
        System.Diagnostics.Debug.Assert(Not (_sJobID Is Nothing), "Undefined job id in ExecuteImportToDB")

        Try
            Logger.Log(String.Format("Starting job id = {0}", _sJobID))

            _oJobStatus.SetStatus(_sJobID, 0)
            Dim workingTable As DataTable = _dsWorking.Tables(WORKING_TABLENAME)

            'get the list of files
            Dim sWorkFilePath, sWorkFileName, sWorkFilePrefix, sWorkFileSuffix As String
            SplitFilenameAtPath(_sWorkingFile, sWorkFilePath, sWorkFileName)
            SplitFilenameAtExtension(sWorkFileName, sWorkFilePrefix, sWorkFileSuffix)
            Dim fileSearchPattern As String = MakeImportXMLDatasetFilenameSearchPattern(sWorkFilePrefix, sWorkFileSuffix)
            Dim dataFiles As String() = System.IO.Directory.GetFiles(sWorkFilePath, fileSearchPattern)

            Logger.Log(String.Format("Importing file = {0}", sWorkFileName))

            _oJobStatus.SetStatus(_sJobID, 1)

            Dim sFileName As String
            Dim iLoopCount As Integer = 0
            Dim iRowCount As Integer = 0
            For Each sFileName In dataFiles
                'empty the table
                workingTable.Clear()

                'read dataset from saved file then delete file
                _dsWorking.ReadXml(sFileName)
                FileSystem.Kill(sFileName)
                _oJobStatus.IncrementStatus(_sJobID)

                'get the status range
                Dim startStatus As Integer = _oJobStatus.CheckStatus(_sJobID)
                Dim endStatus As Integer = CInt((CDec(iLoopCount + 1) / CDec(dataFiles.Length)) * 99)

                'transfer data from dataset to database
                iRowCount += Import_DStoDB(startStatus, endStatus)

                iLoopCount += 1
            Next

            'log completed import
            EventLog.InsertRow(Me._oConn, qmsEvents.IMPORT_COMPLETED, _iUserID, String.Format("{0}: {1} Rows Processed, {2} Rows Imported", _sJobID, iRowCount, _iImportedRows))
            'EventLog.Save()

            _oJobStatus.SetStatus(_sJobID, 100)

            Logger.Log(String.Format("Ending job id = {0}", _sJobID))

        Catch ex As Exception
            Logger.Log("ExecuteImportToDB() error", ex)
            'TP Change
            Dim log As Logging.ILog = Logging.LogManager.GetLogger("ExecuteImportToDB")
            'Dim log As log4net.ILog = log4net.LogManager.GetLogger("ExecuteImportToDB")
            log.Error("ExecuteImportToDB", ex)

        Finally
            'end job status
            _oJobStatus.RemoveJob(_sJobID)
            _sJobID = Nothing
            Close()
        End Try
    End Sub

#End Region  '#Region "Execute methods"

#Region "Verify functions"
    Private Function VerifyExecute() As Boolean
        Dim dr As DataRow

        'check if user id is set
        If _iUserID = 0 Then
            _sbErr.Append("Please provide user id.\n")
            Return False

        End If

        'check if working file is set
        If _sWorkingFile.Length = 0 Then
            _sbErr.Append("Please provide a working file path.\n")
            Return False

        End If

        If _iFileDefID > 0 Then
            'get file definition
            dr = FileDef.NewSearchRow()
            dr.Item("FileDefID") = _iFileDefID
            FileDef.DataSet.EnforceConstraints = False
            FileDef.FillMain(dr)
            FileDef.FillFileDefColumns(dr)

            'valid id?
            If FileDef.MainDataTable.Rows.Count > 0 Then
                'must have columns
                If FileDefColumns.MainDataTable.Rows.Count > 0 Then
                    'determine import or export
                    Dim iFileDefTypeId As Integer = CInt(FileDef.MainDataTable.Rows(0).Item("FileDefTypeID"))
                    If iFileDefTypeId = 1 OrElse iFileDefTypeId = 3 Then
                        'Export file def
                        Return VerifyExport()

                    Else
                        'Import file def
                        Return VerifyImport()

                    End If

                Else
                    'file definition has no columns
                    _sbErr.AppendFormat("File definition id {0} has no columns.\n", _iFileDefID)
                    Return False

                End If

            Else
                'invalid file definition id
                _sbErr.AppendFormat("File definition id {0} is invalid.\n", _iFileDefID)
                Return False

            End If

        Else
            'file definition id not provided
            _sbErr.Append("Cannot execute file definition without id.\n")
            Return False

        End If

        Return True

    End Function

    Private Function VerifyImport() As Boolean
        Dim f As IO.File

        If _iImportSurveyInstanceID = 0 Then
            'an import to XML DS
            'check that import file exists
            If Not f.Exists(_sWorkingFile) Then
                _sbErr.Append("Cannot find import file. Please check working file path.\n")
                Return False
            End If
        Else
            'an import to DB
            'check that import file exists
            Dim sWorkFilePrefix, sWorkFileSuffix As String
            SplitFilenameAtExtension(_sWorkingFile, sWorkFilePrefix, sWorkFileSuffix)
            Dim sFirstXMLFile As String = QMS.clsImportExport.MakeImportXMLDatasetFilename(sWorkFilePrefix, sWorkFileSuffix, 0)

            If Not f.Exists(sFirstXMLFile) Then
                _sbErr.Append("Cannot find import file. Please check working file path.\n")
                Return False
            End If
        End If

        Return True
    End Function

    Private Function VerifyExport() As Boolean
        If _htFilters.Count = 0 Then
            _sbErr.Append("Please provide export filters.\n")
            Return False

        End If

        Return True

    End Function

#End Region

#Region "Export methods"

    Public Sub SetSearchCriteria(ByRef dr As DataRow)
        If _htFilters.Contains("RespondentID") AndAlso dr.Table.Columns.Contains("RespondentID") Then
            dr.Item("RespondentID") = CInt(_htFilters("RespondentID"))
        End If
        If _htFilters.Contains("SurveyInstanceID") AndAlso dr.Table.Columns.Contains("SurveyInstanceID") Then _
        dr.Item("SurveyInstanceID") = CInt(_htFilters("SurveyInstanceID"))
        'TP20091104
        If _htFilters.Contains("SurveyInstanceIDs") AndAlso dr.Table.Columns.Contains("SurveyInstanceIDs") Then _
        dr.Item("SurveyInstanceIDs") = CStr(_htFilters("SurveyInstanceIDs"))
        'TP20091104
        If _htFilters.Contains("SurveyInstanceDateAfter") AndAlso dr.Table.Columns.Contains("SurveyInstanceDateAfter") Then _
        dr.Item("SurveyInstanceStartRange") = CDate(_htFilters("SurveyInstanceDateAfter"))
        If _htFilters.Contains("SurveyInstanceDateBefore") AndAlso dr.Table.Columns.Contains("SurveyInstanceDateBefore") Then _
        dr.Item("SurveyInstanceEndRange") = CDate(_htFilters("SurveyInstanceDateBefore"))
        If _htFilters.Contains("IncludeMailSeeds") AndAlso dr.Table.Columns.Contains("IncludeMailSeeds") Then _
        dr.Item("IncludeMailSeeds") = CBool(_htFilters("IncludeMailSeeds"))
        If _htFilters.Contains("SurveyID") AndAlso dr.Table.Columns.Contains("SurveyID") Then _
        dr.Item("SurveyID") = CInt(_htFilters("SurveyID"))
        If _htFilters.Contains("ClientID") AndAlso dr.Table.Columns.Contains("ClientID") Then _
        dr.Item("ClientID") = CInt(_htFilters("ClientID"))
        If _htFilters.Contains("EventID") AndAlso dr.Table.Columns.Contains("EventID") Then _
        dr.Item("EventID") = CInt(_htFilters("EventID"))
        If _htFilters.Contains("EventDateAfter") AndAlso dr.Table.Columns.Contains("EventStartRange") Then _
        dr.Item("EventStartRange") = CDate(_htFilters("EventDateAfter"))
        If _htFilters.Contains("EventDateBefore") AndAlso dr.Table.Columns.Contains("EventEndRange") Then _
        dr.Item("EventEndRange") = CDate(_htFilters("EventDateBefore"))
        If _htFilters.Contains("BatchIDs") AndAlso dr.Table.Columns.Contains("BatchIDs") Then _
        dr.Item("BatchIDList") = _htFilters("BatchIDs").ToString
        If _htFilters.Contains("FileDefFilterID") AndAlso dr.Table.Columns.Contains("FileDefFilterID") Then _
        dr.Item("FileDefFilterID") = CInt(_htFilters("FileDefFilterID"))
        If _htFilters.Contains("Final") AndAlso dr.Table.Columns.Contains("Final") Then _
        dr.Item("Final") = CInt(_htFilters("Final"))
        If _htFilters.Contains("ExcludeFinalCodes") AndAlso dr.Table.Columns.Contains("ExcludeFinalCodes") Then _
        dr.Item("ExcludeFinalCodes") = True
        If _htFilters.Contains("Active") AndAlso dr.Table.Columns.Contains("Active") Then _
        dr.Item("Active") = 1

    End Sub


    Private Sub CopyFromRespondents(ByRef respondentsReader As Data.SqlClient.SqlDataReader, ByRef drDestination As DataRow)
        Dim c As DataColumn
        Dim dc As New clsDataColumn

        'find all respondent columns in working table
        For Each c In drDestination.Table.Columns
            dc.DestColName = c.ColumnName
            If dc.IsTableRespondents Then
                'copy column value from respondent to working table
                drDestination.Item(c.ColumnName) = respondentsReader.Item(dc.SourceColName)
            End If
        Next

        dc = Nothing
    End Sub

    Private Sub CopyFromDXV(ByVal respondentID As Integer, ByRef drDestination As DataRow, ByVal dxv As clsDataExtractView)
        Dim respondent As DataRow = dxv.GetDXRespondent(Me._oConn, respondentID)

        CopyFromDXV(respondent, drDestination)

    End Sub

    Private Sub CopyFromDXV(ByRef respondentsReader As Data.SqlClient.SqlDataReader, ByRef drDestination As DataRow)
        Dim c As DataColumn

        'find all respondent columns in working table
        For Each c In drDestination.Table.Columns
            'dc.DestColName = c.ColumnName
            'copy column value from data extract view to working table
            drDestination.Item(c.ColumnName) = respondentsReader.Item(c.ColumnName)

        Next

    End Sub

    Private Sub CopyFromDXV(ByRef respondent As DataRow, ByRef drDestination As DataRow)
        Dim c As DataColumn

        'find all respondent columns in working table
        For Each c In drDestination.Table.Columns
            'dc.DestColName = c.ColumnName
            'copy column value from data extract view to working table
            drDestination.Item(c.ColumnName) = respondent.Item(c.ColumnName)

        Next

    End Sub

    Private Sub CopyFromProperties(ByRef oProperties As clsRespondentProperties, ByRef drDestination As DataRow)
        Dim dc As New clsDataColumn
        Dim dr As DataRow

        If oProperties.MainDataTable.Rows.Count > 0 Then
            For Each dr In oProperties.MainDataTable.Rows
                dc.SetSourceTableColName("RESPONDENTPROPERTIES", "", dr.Item("PropertyName").ToString)
                'check that column exists in destination table
                If drDestination.Table.Columns.Contains(dc.DestColName) Then
                    'copy value from source to destination table
                    drDestination.Item(dc.DestColName) = dr.Item("PropertyValue")
                End If
            Next
        End If

        dc = Nothing
    End Sub

    Private Sub CopyFromResponses(ByRef oResponses As clsResponses, ByRef drDestination As DataRow)
        Dim dc As New clsDataColumn
        Dim drs As DataRow()
        Dim dr As DataRow

        If oResponses.MainDataTable.Rows.Count > 0 Then
            For Each dr In oResponses.MainDataTable.Rows
                'check answer value export
                dc.SetSourceTableColName("RESPONSES", "ANSWERVALUE", CInt(dr.Item("SurveyQuestionOrder")), CInt(dr.Item("QuestionPartID")))
                'check that column exists in destination table
                If drDestination.Table.Columns.Contains(dc.DestColName) Then
                    'copy value from source to destination table
                    drDestination.Item(dc.DestColName) = dr.Item("ANSWERVALUE")
                End If

                'check response text export
                dc.SetSourceTableColName("RESPONSES", "RESPONSEDESC", CInt(dr.Item("SurveyQuestionOrder")), CInt(dr.Item("QuestionPartID")))
                'check that column exists in destination table
                If drDestination.Table.Columns.Contains(dc.DestColName) Then
                    'copy value from source to destination table
                    drDestination.Item(dc.DestColName) = dr.Item("RESPONSEDESC")
                End If
            Next
        End If

        dc = Nothing
    End Sub

    <Obsolete("Please user LogEvents with connection")> _
    Private Sub LogExport(ByVal respondentID As Integer)
        LogEvents(respondentID, qmsEvents.RESPONDENT_EXPORTED)
    End Sub

    Private Sub LogExport(ByVal Connection As SqlClient.SqlConnection, ByVal RespondentID As Integer)
        LogEvents(Connection, RespondentID, qmsEvents.RESPONDENT_EXPORTED)

    End Sub

    Private Sub LogEvents(ByVal iRespondentID As Integer, ByVal iSpecfiedEventID As Integer)
        'log event
        LogEvent(iRespondentID, CType(iSpecfiedEventID, QMS.qmsEvents))

        'log user assigned event
        If _iEventID > 0 Then
            LogEvent(iRespondentID, CType(_iEventID, QMS.qmsEvents))
        End If
    End Sub

    Private Sub LogEvents(ByVal Connection As SqlClient.SqlConnection, ByVal RespondentID As Integer, ByVal SpecifiedEventID As Integer)
        'log specified event
        EventLog.InsertRow(Connection, SpecifiedEventID, _iUserID, RespondentID, "")

        'log user assigned event
        If _iEventID > 0 Then
            EventLog.InsertRow(Connection, _iEventID, _iUserID, RespondentID, "")

        End If

    End Sub

    Private Sub LogEvents(ByVal transaction As SqlClient.SqlTransaction, ByVal RespondentID As Integer, ByVal SpecifiedEventID As Integer)
        'log specified event
        EventLog.InsertRow(transaction, SpecifiedEventID, _iUserID, RespondentID, "")

        'log user assigned event
        If _iEventID > 0 Then
            EventLog.InsertRow(transaction, _iEventID, _iUserID, RespondentID, "")

        End If

    End Sub

    Private Sub LogEvent(ByVal iRespondentID As Integer, ByVal oEventID As QMS.qmsEvents)
        EventLog.InsertRow(oEventID, _iUserID, iRespondentID)
    End Sub

#End Region

    Private Sub CreateWorkingTable()
        Dim drv As DataRowView
        Dim c As DataColumn
        Dim dc As New clsDataColumn
        Dim fdc As clsFileDefColumns = FileDefColumns

        'sort file columns in correct order
        fdc.MainDataTable.DefaultView.Sort = "DisplayOrder"

        'create new table
        _dtWorking = New DataTable(WORKING_TABLENAME)

        'now dynamically generate working table
        For Each drv In fdc.MainDataTable.DefaultView
            'set data column name
            dc.FileDefColName = drv.Item("ColumnName").ToString
            'create column
            c = New DataColumn(dc.DestColName)
            If Not IsDBNull(drv.Item("FormatString")) Then
                c.ExtendedProperties(DMI.clsFIETextFile.EXPORT_WRITER_PROPERTY_FORMAT_STRING) = drv.Item("FormatString")
            ElseIf (dc.FileDefColName.Equals(RESPONDENT_DOB_COL_NAME)) Then
                'if there is no format string for the DOB, force it to date only
                c.ExtendedProperties(DMI.clsFIETextFile.EXPORT_WRITER_PROPERTY_FORMAT_STRING) = RESPONDENT_DOB_COL_DEFUALT_FORMAT
            End If
            If Not IsDBNull(drv.Item("Width")) Then
                c.ExtendedProperties(DMI.clsFIETextFile.EXPORT_WRITER_PROPERTY_WIDTH) = CInt(drv.Item("Width"))
            End If
            'add column to table
            _dtWorking.Columns.Add(c)

        Next

        'add table to dataset
        _dsWorking.Tables.Add(_dtWorking)

    End Sub

    'Builds import export file def dataset to define file format
    Private Function GetImportExportFileDef() As DMI.dsFileDef
        Dim oDC As New QMS.clsDataColumn
        Dim ds As New DMI.dsFileDef
        Dim dtFileDef As DMI.dsFileDef.tblFileDefDataTable = ds.tblFileDef
        Dim drFileDef As DMI.dsFileDef.tblFileDefRow
        Dim dtFileDefCols As DataTable
        Dim drv As DataRowView

        'get file def columns
        dtFileDefCols = FileDefColumns.MainDataTable
        dtFileDefCols.DefaultView.Sort = "DisplayOrder"

        'translate file def columns into define file format
        For Each drv In dtFileDefCols.DefaultView
            oDC.FileDefColName = drv.Item("ColumnName").ToString
            drFileDef = dtFileDef.NewtblFileDefRow
            drFileDef.ColName = oDC.DestColName
            drFileDef.ColType = oDC.FileDataType
            If IsDBNull(drv.Item("Width")) Then
                drFileDef.ColWidth = 0
            Else
                drFileDef.ColWidth = CInt(drv.Item("Width"))
            End If
            drFileDef.ColOrder = CInt(drv.Item("DisplayOrder"))
            dtFileDef.Rows.Add(drFileDef)

        Next

        oDC = Nothing

        Return ds
    End Function

#Region "FileName Utility Fuctions"
    Public Shared Sub SplitFilenameAtExtension(ByVal sFileName As String, ByRef sFileNamePrefix As String, ByRef sFileNameSuffix As String)
        Dim iExtensionPos As Integer = sFileName.LastIndexOf(".")
        sFileNamePrefix = sFileName.Substring(0, iExtensionPos)
        sFileNameSuffix = sFileName.Substring(iExtensionPos)
    End Sub

    Public Shared Sub SplitFilenameAtPath(ByVal sFullFileName As String, ByRef sFilePath As String, ByRef sFileName As String)
        Dim iFilePos As Integer = sFullFileName.LastIndexOf("\") + 1
        sFilePath = sFullFileName.Substring(0, iFilePos)
        sFileName = sFullFileName.Substring(iFilePos)
    End Sub

    Private Shared Function _MakeImportXMLDatasetFilename(ByVal sFileNamePrefix As String, ByVal sFileNameSuffix As String, ByVal sOtherText As String) As String
        Return String.Format("{0}{1}{2}{3}", sFileNamePrefix, "_XML_DS_", sOtherText, sFileNameSuffix)
    End Function

    Private Shared Function MakeImportXMLDatasetFilenameSearchPattern(ByVal sFileNamePrefix As String, ByVal sFileNameSuffix As String) As String
        Return _MakeImportXMLDatasetFilename(sFileNamePrefix, sFileNameSuffix, "*")
    End Function

    Public Shared Function MakeImportXMLDatasetFilename(ByVal sFileNamePrefix As String, ByVal sFileNameSuffix As String, ByVal iFileIndex As Integer) As String
        Return _MakeImportXMLDatasetFilename(sFileNamePrefix, sFileNameSuffix, iFileIndex.ToString)
    End Function

    Public Shared Function MakeImportXMLDatasetFilenameFromJobID(ByVal sWorkingFolder As String, ByVal sJobID As String, ByVal iFileIndex As Integer) As String
        Dim sFileNamePrefix As String = String.Format("{0}\{1}", sWorkingFolder, sJobID)
        Dim sFileNameSuffix As String = ".TXT"
        Return MakeImportXMLDatasetFilename(sFileNamePrefix, sFileNameSuffix, iFileIndex)
    End Function

#End Region

#Region "Log File"
    Public ReadOnly Property LogFilename() As String
        Get
            If IsNothing(_sLogFilename) Then
                Dim sFilepath As String
                Dim sFilename As String
                SplitFilenameAtPath(_sWorkingFile, sFilepath, sFilename)
                _sLogFilename = String.Format("{0}{1}_log.TXT", sFilepath, _sJobID)
            End If
            Return _sLogFilename
        End Get
    End Property

    Public ReadOnly Property Logger() As DMI.clsSimpleLog
        Get
            If IsNothing(_SimpleLog) Then
                _SimpleLog = New DMI.clsSimpleLog(LogFilename)
            End If
            Return _SimpleLog
        End Get
    End Property

#End Region

#Region "Import from File to DS"

    'Imports data from file into dataset
    Private Function Import_FileToDS() As Integer
        Dim oFileIE As DMI.clsFileImportExport
        Dim FileType As DMI.FileTypes
        Dim sDelimiter As String

        _oJobStatus.SetStatus(_sJobID, 1)

        'get import parameters
        FileType = CType(FileDef.MainDataTable.Rows(0).Item("FileTypeID"), DMI.FileTypes)
        If IsDBNull(FileDef.MainDataTable.Rows(0).Item("FileDefDelimiter")) Then
            sDelimiter = ""
        Else
            sDelimiter = FileDef.MainDataTable.Rows(0).Item("FileDefDelimiter").ToString
        End If

        'setup import
        oFileIE = DMI.clsFIEFactory.Make(FileType, _sWorkingFile, sDelimiter)
        oFileIE.FileDef = GetImportExportFileDef()

        'breakup the working filename, we'll need to mess with it
        Dim sWorkFilePrefix, sWorkFileSuffix As String
        SplitFilenameAtExtension(_sWorkingFile, sWorkFilePrefix, sWorkFileSuffix)

        'get some work varables for the loop
        Dim iRecordsReturned As Integer = 0
        Dim iCurrentRecord As Integer = 0
        Dim oFileMFFR As DMI.MultiFillFileReader = CType(oFileIE, DMI.MultiFillFileReader)
        Dim workingTable As DataTable = _dsWorking.Tables(WORKING_TABLENAME)
        Dim sWorkfileName As String
        Dim iLoopCount As Integer = 0

        _oJobStatus.SetStatus(_sJobID, 2)

        Dim iEstimatedTotalRecords As Integer = oFileMFFR.RecordCount() + 1
        Dim iNumberOfLoops As Integer = CInt(Math.Ceiling((CDbl(iEstimatedTotalRecords) / CDbl(MAX_RECORD_COUNT_PER_IMPORT_BATCH))))

        _oJobStatus.SetStatus(_sJobID, 3)

        'read in an import batch and write out an xml file
        Do
            _oJobStatus.SetStatus(_sJobID, iLoopCount, iNumberOfLoops, 4, 98)

            'read the records
            workingTable.Clear()
            iRecordsReturned = oFileMFFR.MaxRecordFill(_dsWorking, iCurrentRecord, MAX_RECORD_COUNT_PER_IMPORT_BATCH, WORKING_TABLENAME)
            iCurrentRecord = iCurrentRecord + iRecordsReturned

            'scrub the imported data
            ScrubWorkingTable()

            'generate the new filename
            sWorkfileName = MakeImportXMLDatasetFilename(sWorkFilePrefix, sWorkFileSuffix, iLoopCount)

            'save dataset as file
            _dsWorking.WriteXml(sWorkfileName, XmlWriteMode.WriteSchema)

            iLoopCount = iLoopCount + 1
            If (iLoopCount > iNumberOfLoops) Then
                iLoopCount = iNumberOfLoops
            End If
            _oJobStatus.SetStatus(_sJobID, iLoopCount, iNumberOfLoops, 4, 98)
        Loop Until (iRecordsReturned < MAX_RECORD_COUNT_PER_IMPORT_BATCH)

        'delete the raw data file, we now have the xml version of it
        FileSystem.Kill(_sWorkingFile)

        _oJobStatus.SetStatus(_sJobID, 99)

        Return iCurrentRecord
    End Function

    Private Sub ScrubWorkingTable()
        Dim scrubers As New ArrayList
        Dim scruber As scrubWorkingTable
        Dim i As Integer
        Dim dr As DataRow

        'determine scrubers to use
        scruber = New swtCleanGender(_oConn)
        If UseScruber(scruber) Then scrubers.Add(scruber)
        scruber = New swtCleanState(_oConn)
        If UseScruber(scruber) Then scrubers.Add(scruber)
        scruber = New swtCleanTelephone(_oConn)
        If UseScruber(scruber) Then scrubers.Add(scruber)
        scruber = New swtCleanEmail(_oConn)
        If UseScruber(scruber) Then scrubers.Add(scruber)

        'scrub rows in working table
        If scrubers.Count > 0 Then
            For Each dr In _dtWorking.Rows
                For Each scruber In scrubers
                    scruber.Clean(dr)
                Next
            Next
        End If

        scrubers = Nothing
        scruber = Nothing
    End Sub

    Private Function UseScruber(ByVal scruber As ScrubWorkingTable) As Boolean
        Dim sColumns() As String = scruber.AffectsColumns()
        Dim sColumn As String

        For Each sColumn In sColumns
            If _dtWorking.Columns.Contains(sColumn) Then
                Return True
            End If
        Next

        Return False
    End Function


    Public Function MakeDBImportSettings(ByVal iFileDefID As Integer, ByVal iSurveyInstanceID As Integer, ByVal iEventCodeID As Integer, ByVal sJobID As String) As Hashtable
        Dim htJobSettings As New Hashtable

        'save job settings
        htJobSettings.Add("FileDefID", iFileDefID)
        htJobSettings.Add("SurveyInstanceID", iSurveyInstanceID)
        htJobSettings.Add("EventCodeID", iEventCodeID)
        htJobSettings.Add("JobID", sJobID)

        Return htJobSettings
    End Function
#End Region

#Region "Import from DS to DB"
    Public Sub ReadDBImportSettings(ByVal ht As Hashtable)
        FileDefID = CInt(ht.Item("FileDefID"))
        ImportToSurveyInstanceID = CInt(ht.Item("SurveyInstanceID"))
        LogEventID = CInt(ht.Item("EventCode"))

    End Sub

    Private Function Import_DStoDB(ByVal iStartStatus As Integer, ByVal iEndStatus As Integer) As Integer
        Dim dr As DataRow
        Dim drRespondent As DataRow
        Dim iRespondentID As Integer
        Dim iCounter As Integer = 0
        Dim connStr As String = DMI.DataHandler.sConnection
        Dim connTrans As New SqlClient.SqlConnection(connStr)
        Dim trigger As New SurveyPointDAL.clsTriggers

        Logger.Log(String.Format("Start importing from {0} into database", _sWorkingFile))

        connTrans = New SqlClient.SqlConnection(connStr)
        trigger.UserID = UserID
        trigger.DBConnection = _oConn
        Respondents.DBConnection = connTrans
        RespondentProperties.DBConnection = connTrans

        Try
            connTrans.Open()

            For Each dr In _dtWorking.Rows
                Logger.Log(String.Format("Importing row {0}", _iImportedRows))

                _oTransaction = connTrans.BeginTransaction()

                Logger.Log(String.Format("Saving row {0}", _iImportedRows))
                'copy rows from working table to respondent tables
                drRespondent = CopyToRespondentsTable(dr)

                'save new respondent row to database
                Respondents.DBTransaction = _oTransaction
                Respondents.Save()
                iRespondentID = CInt(drRespondent.Item("RespondentID"))
                Debug.Assert(iRespondentID > 0, "Invalid respondent ID")
                Logger.Log(String.Format("Respondent id = {0}", iRespondentID))

                'validate contact respondent information
                RowContactInfoValid(drRespondent)

                'log events for import
                LogEvents(_oTransaction, iRespondentID, qmsEvents.RESPONDENT_IMPORTED)

                'save respondent properties
                If dr.RowState = DataRowState.Added AndAlso FileDefColumns.ContainsRespondentPropertyColumns Then CopyToPropertiesTable(dr, CInt(drRespondent.Item("RespondentID")))

                'run after import trigger
                trigger.RespondentID = iRespondentID
                trigger.DBTransaction = _oTransaction
                Dim cmdTrigger As String = trigger.RunTriggers(SurveyPointDAL.InvocationPoint.AFTER_IMPORT)

                If trigger.HasTriggerErrors() Then
                    Logger.Log(trigger.TriggerErrorMsg())
                    Logger.Log(String.Format("Trigger errors, rollback row {1}, respondent id = {0}", iRespondentID, _iImportedRows))
                    _oTransaction.Rollback()
                Else
                    Logger.Log(String.Format("Commiting respondent id = {0}", iRespondentID))
                    _oTransaction.Commit()
                    _iImportedRows += 1
                End If

                'clear table for next new row
                RespondentProperties.MainDataTable.Clear()
                RespondentProperties.DBTransaction = Nothing
                Respondents.MainDataTable.Clear()
                Respondents.DBTransaction = Nothing
                _oTransaction = Nothing

                'update job status
                iCounter += 1
                _oJobStatus.SetStatus(_sJobID, iCounter, _dtWorking.Rows.Count, iStartStatus, iEndStatus)

            Next

        Catch ex As Exception
            Logger.Log(String.Format("Import error occured at respondent {0}", iCounter), ex)
            If (Not IsNothing(_oTransaction)) Then _oTransaction.Rollback()
            EventLog.InsertRow(Me._oConn, qmsEvents.IMPORT_ERROR, _iUserID, String.Format("{0}: Row {1}, {2}", _sJobID, iCounter + 1, ex.Message))
            Throw ex

        Finally
            If Not IsNothing(connTrans) Then
                If connTrans.State = ConnectionState.Open Then connTrans.Close()
                connTrans.Dispose()
            End If

        End Try

        Return iCounter
    End Function

    Private Function CopyToRespondentsTable(ByVal dr As DataRow) As DataRow
        Dim drNew As DataRow = Respondents.NewMainRow
        Dim c As DataColumn
        Dim dc As New QMS.clsDataColumn

        drNew.Item("SurveyInstanceID") = _iImportSurveyInstanceID

        'check each column in working table for respondent table columns
        For Each c In dr.Table.Columns
            dc.DestColName = c.ColumnName
            If dc.IsTableRespondents Then
                'copy column value from working to respondent table
                If Not IsDBNull(dr(c.ColumnName)) Then drNew.Item(dc.SourceColName) = dr.Item(c.ColumnName)

            End If
        Next

        Respondents.AddMainRow(drNew)
        dc = Nothing

        Return drNew

    End Function

    Private Sub CopyToPropertiesTable(ByVal dr As DataRow, ByVal iRespondentID As Integer)
        Dim drNew As DataRow
        Dim c As DataColumn
        Dim dc As New QMS.clsDataColumn

        'check each column in working table for properties table columns
        For Each c In dr.Table.Columns
            dc.DestColName = c.ColumnName
            If dc.IsTableRespondentProperties Then
                'copy column value from working to respondent table
                If Not IsDBNull(dr(c.ColumnName)) Then
                    clsRespondentProperties.SaveRespondentProperty(Me._oTransaction, _
                        iRespondentID, dc.PropertyName, dr.Item(c.ColumnName).ToString)
                    'drNew = RespondentProperties.NewMainRow
                    'drNew.Item("RespondentID") = iRespondentID
                    'drNew.Item("PropertyName") = dc.PropertyName
                    'drNew.Item("PropertyValue") = dr.Item(c.ColumnName)
                    'RespondentProperties.AddMainRow(drNew)

                End If

            End If
        Next

        dc = Nothing

    End Sub

#End Region

#Region "Contact Validators"
    'validate respondent row with contact info
    Private Sub BulkTableContactInfoValid()
        Dim dr As DataRow
        Dim dt As DataTable = Respondents.MainDataTable

        For Each dr In dt.Rows
            RowContactInfoValid(dr)

        Next

    End Sub

    'run row through contact validation
    Private Sub RowContactInfoValid(ByRef dr As DataRow)
        Dim iSurveyInstanceID As Integer = CInt(dr.Item("SurveyInstanceID"))
        Dim arl As ArrayList = GetContactValidators(iSurveyInstanceID)
        Dim crv As validateRespondentContact
        Dim i As Integer

        For i = 0 To arl.Count - 1
            crv = CType(arl.Item(i), validateRespondentContact)
            If Not crv.Validate(dr) Then
                Logger.Log(String.Format("WARNING {0} invalid", crv.GetType().ToString()))
                If IsNothing(_oTransaction) Then
                    EventLog.InsertRow(Me._oConn, crv.EventCode, _iUserID, CInt(dr.Item("RespondentID")), "")
                Else
                    EventLog.InsertRow(_oTransaction, crv.EventCode, _iUserID, CInt(dr.Item("RespondentID")), "")
                End If

            End If

        Next

    End Sub

    'return array list of contact validators for survey instance
    Private Function GetContactValidators(ByVal iSurveyInstanceID As Integer) As ArrayList
        Dim arl As ArrayList
        Dim iProtocolID As Integer

        'init hashtable
        If IsNothing(_htContactValidators) Then _htContactValidators = New Hashtable

        'check if validators already exist for survey instance
        If _htContactValidators.ContainsKey(iSurveyInstanceID) Then
            Return CType(_htContactValidators.Item(iSurveyInstanceID), ArrayList)

        Else
            'get validators for new survey instance
            arl = InitContactValidators(clsProtocols.SurveyInstanceProtocolID(_oConn, iSurveyInstanceID))
            _htContactValidators.Add(iSurveyInstanceID, arl)
            Return arl

        End If

    End Function

    'create new array list of contact validators for protocol
    Private Function InitContactValidators(ByVal iProtocolID As Integer) As ArrayList
        Dim arl As New ArrayList
        Dim rcv As validateRespondentContact

        rcv = New vrcValidateTelephone
        If UseContactValidator(iProtocolID, rcv) Then arl.Add(rcv)
        rcv = New vrcValidateAddress
        If UseContactValidator(iProtocolID, rcv) Then arl.Add(rcv)
        rcv = New vrcValidateEmail
        If UseContactValidator(iProtocolID, rcv) Then arl.Add(rcv)

        Return arl

    End Function

    'check if contact validator should be used for protocol
    Private Function UseContactValidator(ByVal iProtocolID As Integer, ByVal vrc As validateRespondentContact) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim psts As Integer() = vrc.AffectsProtocolStepTypes()
        Dim iProtocolStepTypeID As Integer

        sbSQL.Append("SELECT COUNT(ProtocolStepTypeID) FROM ProtocolSteps WHERE ProtocolStepTypeID IN (")
        For Each iProtocolStepTypeID In psts
            sbSQL.AppendFormat("{0},", iProtocolStepTypeID)

        Next
        sbSQL.Append("0)")
        'TP Change
        If CInt(SqlHelper.Db(_oConn.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString())) > 0 Then
            Return True
        End If
        'If CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sbSQL.ToString)) > 0 Then
        '    Return True

        'End If

        Return False

    End Function

#End Region

End Class

#Region "Scrub working table classes"
Public MustInherit Class scrubWorkingTable
    Protected _oConn As SqlClient.SqlConnection
    Public MustOverride Function Clean(ByVal dr As DataRow) As Boolean
    Public MustOverride Function AffectsColumns() As String()
End Class

Public Class swtCleanGender
    Inherits scrubWorkingTable

    Private Const COLUMN_NAME As String = "GENDER"

    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        _oConn = oConn
    End Sub

    Public Overrides Function Clean(ByVal dr As DataRow) As Boolean
        Dim sGender As String

        If Not IsDBNull(dr.Item(Me.COLUMN_NAME)) Then
            sGender = dr.Item(Me.COLUMN_NAME).ToString
            'gender can be single character
            If sGender.Length > 1 Then sGender = sGender.Substring(0, 1)
            'gender must be upper case
            sGender = sGender.ToUpper
            'gender may be blank, female, or male
            If sGender = "" Or sGender = "F" Or sGender = "M" Then
                dr.Item(Me.COLUMN_NAME) = sGender
                Return True
            End If

            dr.Item(Me.COLUMN_NAME) = ""
            Return False
        End If

        Return True
    End Function

    Public Overrides Function AffectsColumns() As String()
        Return New String(0) {Me.COLUMN_NAME}
    End Function
End Class

Public Class swtCleanState
    Inherits scrubWorkingTable

    Private Const COLUMN_NAME As String = "STATE"

    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        _oConn = oConn
    End Sub

    Public Overrides Function Clean(ByVal dr As DataRow) As Boolean
        Dim sSQL As String
        Dim sState As String
        Dim iCount As Integer
        Dim retval As Object

        If Not IsDBNull(dr.Item(Me.COLUMN_NAME)) Then
            sState = dr.Item(Me.COLUMN_NAME).ToString.Trim.ToUpper
            'correct state abbreviation
            sSQL = "SELECT Count(State) FROM States WHERE State = @State"
            'TP Change
            Dim cmd As DbCommand = SqlHelper.Db(_oConn.ConnectionString).GetSqlStringCommand(sSQL)
            iCount = CInt(cmd.Parameters.Add(New SqlClient.SqlParameter("@State", sState)))
            iCount = CInt(sqlhelper.Db(_oConn.ConnectionString).ExecuteScalar(cmd))
            'iCount = CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL, New SqlClient.SqlParameter("@State", sState)))
            If iCount > 0 Then Return True

            'match state
            sSQL = "SELECT TOP 1 State FROM States WHERE StateName LIKE @State"
            'TP Change
            cmd = SqlHelper.Db(_oConn.ConnectionString).GetSqlStringCommand(sSQL)
            cmd.Parameters.Add(New SqlClient.SqlParameter("@State", sState))
            retval = SqlHelper.Db(_oConn.ConnectionString).ExecuteScalar(cmd)
            'retval = SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL, New SqlClient.SqlParameter("@State", sState))
            If Not IsNothing(retval) AndAlso Not IsDBNull(retval) Then
                dr.Item(Me.COLUMN_NAME) = retval.ToString
                Return True
            End If

            dr.Item(Me.COLUMN_NAME) = DBNull.Value
            Return False
        End If

        Return True
    End Function

    Public Overrides Function AffectsColumns() As String()
        Return New String(0) {Me.COLUMN_NAME}

    End Function

End Class

Public Class swtCleanTelephone
    Inherits scrubWorkingTable

    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        _oConn = oConn
    End Sub

    Public Overrides Function Clean(ByVal dr As DataRow) As Boolean
        Dim sColName As String
        Dim sColNames() As String = AffectsColumns()
        Dim sNumber As String
        Dim rx As Text.RegularExpressions.Regex

        For Each sColName In sColNames
            If dr.Table.Columns.Contains(sColName) Then
                If Not IsDBNull(dr.Item(sColName)) Then
                    'remove telephone formatting
                    sNumber = DMI.clsUtil.RemoveTelephoneFormat(dr.Item(sColName).ToString)
                    dr.Item(sColName) = sNumber

                    'null all zero telephones
                    If rx.IsMatch(sNumber, "^0+$", Text.RegularExpressions.RegexOptions.Compiled) Then
                        dr.Item(sColName) = DBNull.Value
                        Return False
                    End If
                End If
            End If
        Next

        Return True
    End Function

    Public Overrides Function AffectsColumns() As String()
        Return New String(1) {"TELEPHONEDAY", "TELEPHONEEVENING"}
    End Function

End Class

Public Class swtCleanEmail
    Inherits scrubWorkingTable

    Private Const COLUMN_NAME As String = "EMAIL"

    Public Sub New(ByVal oConn As SqlClient.SqlConnection)
        _oConn = oConn
    End Sub

    Public Overrides Function Clean(ByVal dr As DataRow) As Boolean
        Dim rx As Text.RegularExpressions.Regex

        If Not IsDBNull(dr.Item(Me.COLUMN_NAME)) Then
            If rx.IsMatch(dr.Item(Me.COLUMN_NAME).ToString, DMI.RegExLibrary.EMAIL_ADDRESS_VALIDATION_REGEX, Text.RegularExpressions.RegexOptions.Compiled) Then
                Return True
            End If
        Else
            Return True
        End If

        'dr.Item(Me.COLUMN_NAME) = DBNull.Value
        Return False
    End Function

    Public Overrides Function AffectsColumns() As String()
        Return New String(0) {Me.COLUMN_NAME}
    End Function

End Class

#End Region
