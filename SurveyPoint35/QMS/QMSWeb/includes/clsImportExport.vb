Option Strict On

Imports DMI

<Obsolete("Use QMS.clsImportExport")> _
Public Class clsImportExport

    Public Enum ImportExportSteps
        iesExport = 1
        iesImportToDS = 2
        iesImportToDB = 3

    End Enum

    Private Const MYPRIVATE_RESPONDENTID As String = "MyID"
    Private Const WORKING_TABLENAME As String = "ImportExport"

    Private m_sWorkingFolder As String
    Private m_iSurveyInstanceID As Integer = 0
    Private m_sUpdateOnColumns As String = ""
    Private m_sRespondentFilterSQL As String = ""
    Private m_iEventIDLog As Integer = 0
    Private m_iFileDefID As Integer = 0
    Private m_sIOFile As String = ""
    Private m_iUserID As Integer = 0
    Private m_sJobID As String
    Private m_sLogFile As String
    Private m_oFD As clsFileDef
    Private m_htFilters As Hashtable
    Private m_oJobStatus As DMI.clsJobStatus
    Private m_oRespondent As clsRespondents
    Private m_sConn As String

    Public Sub New()
        'generate random job id
        Randomize()
        m_sJobID = CInt(Rnd() * 10000000 + 1).ToString
        'log file name based on job id
        m_sLogFile = String.Format("{0}.log", m_sJobID)

    End Sub

    Public Property JobID() As String
        Get
            Return m_sJobID

        End Get
        Set(ByVal Value As String)
            m_sJobID = Value
            m_sLogFile = String.Format("{0}.log", m_sJobID)

        End Set
    End Property

    Public ReadOnly Property SurveyInstanceID() As Integer
        Get
            Return m_iSurveyInstanceID

        End Get
    End Property

    Public ReadOnly Property EventCodeLog() As Integer
        Get
            Return m_iEventIDLog

        End Get
    End Property

    Public ReadOnly Property FileDefID() As Integer
        Get
            Return m_iFileDefID

        End Get
    End Property

    Public ReadOnly Property IOFile() As String
        Get
            Return m_sIOFile

        End Get
    End Property

    Public Sub Execute(ByVal sConn As String, _
                        ByVal sIOFile As String, _
                        ByVal iFileDefID As Integer, _
                        ByVal iUserID As Integer, _
                        ByVal iEventIDLog As Integer, _
                        ByVal htCriteria As Hashtable, _
                        ByVal iSurveyInstanceID As Integer, _
                        ByVal sUpdateOnCols As String, _
                        Optional ByVal iStepID As ImportExportSteps = ImportExportSteps.iesExport)

        Dim oThread As Threading.Thread

        'copy parameters to private vars
        m_sConn = sConn
        m_sIOFile = sIOFile
        m_iFileDefID = iFileDefID
        m_iUserID = iUserID
        m_iEventIDLog = iEventIDLog
        m_oRespondent = New clsRespondents(m_sConn)

        'get file def values
        m_oFD = New clsFileDef(m_sConn, m_iFileDefID)

        'Check import export step value
        If CType(m_oFD.Details(tblFileDefs.FileDefTypeID), FileDefType) = FileDefType.EXPORT Then
            'export file defs must be export step
            iStepID = ImportExportSteps.iesExport

        ElseIf iStepID = ImportExportSteps.iesExport Then
            'import file defs cannot be export step, change to import to dataset
            iStepID = ImportExportSteps.iesImportToDS

        End If

        'kick off thread
        Select Case iStepID
            Case ImportExportSteps.iesExport
                m_htFilters = htCriteria
                'oThread = New Threading.Thread(AddressOf Export)
                'oThread.Start()
                Export()

            Case ImportExportSteps.iesImportToDS
                'get import specifc parameters
                m_iSurveyInstanceID = iSurveyInstanceID
                m_sUpdateOnColumns = sUpdateOnCols
                'start import process
                'oThread = New Threading.Thread(AddressOf ImportToDS)
                'oThread.Start()
                ImportToDS()

            Case ImportExportSteps.iesImportToDB
                'get import specifc parameters
                m_iSurveyInstanceID = iSurveyInstanceID
                m_sUpdateOnColumns = sUpdateOnCols
                'start import process
                'oThread = New Threading.Thread(AddressOf ImportToDB)
                'oThread.Start()
                ImportToDB()

        End Select

    End Sub

    'Execute import
    Public Sub Execute(ByVal sConn As String, _
                    ByVal sIOFile As String, _
                    ByVal iFileDefID As Integer, _
                    ByVal iUserID As Integer, _
                    ByVal iEventIDLog As Integer, _
                    ByVal iSurveyInstanceID As Integer, _
                    ByVal sUpdateOnCols As String, _
                    Optional ByVal iStepID As ImportExportSteps = ImportExportSteps.iesImportToDS)

        Me.Execute(sConn, sIOFile, iFileDefID, iUserID, iEventIDLog, Nothing, iSurveyInstanceID, sUpdateOnCols, iStepID)

    End Sub

    'Execute export
    Public Sub Execute(ByVal sConn As String, _
                        ByVal sIOFile As String, _
                        ByVal iFileDefID As Integer, _
                        ByVal iUserID As Integer, _
                        ByVal iEventIDLog As Integer, _
                        ByVal htCriteria As Hashtable)

        Me.Execute(sConn, sIOFile, iFileDefID, iUserID, iEventIDLog, htCriteria, Nothing, Nothing, ImportExportSteps.iesExport)

    End Sub

    'Manages data export from database to dataset to file
    Private Sub Export()
        Dim oDS As DataSet = m_oFD.DataSet

        'set job status
        m_oJobStatus.SetStatus(m_sJobID, 0)

        'prepare the results table
        BuildWorkingTableSchema(oDS)

        'set file def filter sql
        m_sRespondentFilterSQL = GetRespondentFilterSQL(Me.m_htFilters)

        'load various sources of data        
        Export_LoadDataTable_Respondents(oDS)
        If oDS.Tables("Respondents").Rows.Count > 0 Then
            Export_LoadDataTable_RespondentProperties(oDS)
            Export_LoadDataTable_Responses(oDS)

            'prepare results table        
            Me.Export_CopyDataFromDBTableToWorkingTable(oDS)

            'write it to file
            Export_DSToFile(oDS)

            'log export events
            Export_LogEvents(oDS)

        End If

        'end job status
        m_oJobStatus.RemoveJob(m_sJobID)

    End Sub

    'Manages data import from file to dataset
    Private Sub ImportToDS()
        Dim oDS As DataSet = m_oFD.DataSet

        'start new job
        m_oJobStatus.SetStatus(m_sJobID, 0)

        'parse file into dataset
        Import_FileToDS(oDS)
        'save dataset as file
        oDS.WriteXml(m_sIOFile, XmlWriteMode.WriteSchema)

        'end job
        m_oJobStatus.RemoveJob(m_sJobID)

    End Sub

    'Manages data import from dataset to database
    Private Sub ImportToDB()
        Dim oDS As DataSet = m_oFD.DataSet

        'start new job
        m_oJobStatus.SetStatus(m_sJobID, 0)

        'prepare the results table
        'BuildWorkingTableSchema(oDS)

        'read dataset from saved file
        oDS.ReadXml(m_sIOFile)
        FileSystem.Kill(m_sIOFile)
        m_oJobStatus.IncrementStatus(m_sJobID)

        'transfer data from dataset to database
        Import_WriteDataFromWorkingTableToDatabase(oDS)

        m_oJobStatus.RemoveJob(m_sJobID)

    End Sub

    'Imports data from file into dataset
    Private Sub Import_FileToDS(ByRef oDS As DataSet)
        Dim oFileIE As DMI.clsFileImportExport
        Dim sDelimiter As String

        If IsDBNull(m_oFD.Details(tblFileDefs.FileDefDelimiter)) Then
            sDelimiter = ""
        Else
            sDelimiter = m_oFD.Details(tblFileDefs.FileDefDelimiter).ToString
        End If
        oFileIE = DMI.clsFIEFactory.Make(CType(m_oFD.Details(tblFileDefs.FileTypeID), DMI.FileTypes), _
                                         m_sIOFile, sDelimiter)

        oFileIE.FileDef = GetImportExportFileDef(m_oFD)

        oFileIE.Fill(oDS, WORKING_TABLENAME)

    End Sub

    'Builds import export file def dataset to define file format
    Private Function GetImportExportFileDef(ByRef oFD As clsFileDef) As DMI.dsFileDef
        Dim oFDC As New clsFileDefColumn(m_oFD.ConnectionString)
        Dim oNC As New clsNamingConvention()
        Dim ds As New DMI.dsFileDef()
        Dim dtFileDef As DMI.dsFileDef.tblFileDefDataTable = ds.tblFileDef
        Dim drFileDef As DMI.dsFileDef.tblFileDefRow
        Dim dtFileDefCols As DataTable
        Dim drFileDefCols As DataRow
        Dim i As Integer = 0

        'first add filedefcolumns table to dataset
        oFDC.Details(tblFileDefColumns.FileDefID) = m_oFD.Details(tblFileDefs.FileDefID)
        oFDC.GetDetails()
        dtFileDefCols = oFDC.DataSet.Tables("FileDefColumns")
        dtFileDefCols.DefaultView.Sort = ""

        'now dynamically generate new results table, add it to the dataset
        For Each drFileDefCols In dtFileDefCols.Rows
            i += 1
            oNC.SetFileDefColName(drFileDefCols.Item("ColumnName").ToString)
            drFileDef = dtFileDef.NewtblFileDefRow
            drFileDef.ColName = oNC.DestColName
            drFileDef.ColType = oNC.FileDataType
            drFileDef.ColWidth = SafeDBInteger(drFileDefCols.Item("Width"))
            drFileDef.ColOrder = CInt(drFileDefCols.Item("DisplayOrder"))
            dtFileDef.Rows.Add(drFileDef)

        Next

        Return ds

    End Function

    Private Sub BuildWorkingTableSchema(ByRef oDS As DataSet)
        Dim oFDC As New clsFileDefColumn(m_oFD.ConnectionString)
        Dim oNC As New clsNamingConvention()
        Dim oTable As DataTable
        Dim oRow As DataRow
        Dim oCol As DataColumn

        'first add filedefcolumns table to dataset
        oFDC.Details(tblFileDefColumns.FileDefID) = m_oFD.Details(tblFileDefs.FileDefID)
        oFDC.GetDetails()

        oTable = oFDC.DataSet.Tables("FileDefColumns").Copy()
        oDS.Tables.Add(oTable)

        'now dynamically generate new results table, add it to the dataset
        oTable = New DataTable(WORKING_TABLENAME)
        For Each oRow In oDS.Tables("FileDefColumns").Rows
            oNC.SetFileDefColName(oRow.Item("ColumnName").ToString)
            oCol = New DataColumn(oNC.DestColName)
            oCol.ExtendedProperties("FormatString") = oRow("FormatString")
            oCol.ExtendedProperties("Width") = SafeDBInteger(oRow("Width"))
            oTable.Columns.Add(oCol)
        Next
        oDS.Tables.Add(oTable)

        oFDC = Nothing
        oNC = Nothing

    End Sub

    Private Sub Export_LoadDataTable_Respondents(ByRef oDS As DataSet)
        Dim sSQLRespondents As New StringBuilder()
        Dim oRespondents As New QMS.clsRespondents()
        Dim oCol As DataColumn
        Dim oTable As DataTable = oDS.Tables(WORKING_TABLENAME)
        Dim oNC As New clsNamingConvention()

        'start building select statement for respondent table
        sSQLRespondents.AppendFormat("SELECT RespondentID AS {0}", MYPRIVATE_RESPONDENTID)

        'pull out each of the fields from the Respondents table
        For Each oCol In oTable.Columns
            oNC.SetDestTableColName(oCol.ColumnName)
            If oNC.IsTableRespondents Then
                sSQLRespondents.AppendFormat(", {0}", oNC.SourceColName)
            End If
        Next

        'set where clause 
        sSQLRespondents.AppendFormat(" FROM vw_Respondents {0}", m_sRespondentFilterSQL)

        DataHandler.GetDS(m_oFD.ConnectionString, oDS, sSQLRespondents.ToString, "Respondents")

        m_oJobStatus.IncrementStatus(m_sJobID)

    End Sub

    Private Sub Export_LoadDataTable_RespondentProperties(ByRef oDS As DataSet)
        Dim sSQL As New StringBuilder()
        Dim oCol As DataColumn
        Dim sPropertyNameList As New StringBuilder("''")
        Dim oTable As DataTable = oDS.Tables(WORKING_TABLENAME)
        Dim oNC As New clsNamingConvention()

        'prepare the property name list        
        For Each oCol In oTable.Columns
            oNC.SetDestTableColName(oCol.ColumnName)
            If oNC.IsTableRespondentProperties Then
                sPropertyNameList.AppendFormat(", '{0}'", oNC.PropertyName)
            End If
        Next

        If sPropertyNameList.Length > 2 Then
            'create the SQL
            sSQL.AppendFormat("SELECT RespondentID AS {0}", Me.MYPRIVATE_RESPONDENTID)
            sSQL.Append(", PropertyName, PropertyValue FROM RespondentProperties")
            sSQL.Append(" WHERE RespondentID IN ")
            sSQL.AppendFormat("(SELECT RespondentID FROM vw_Respondents {0})", m_sRespondentFilterSQL)
            sSQL.AppendFormat(" AND PropertyName IN ({0})", sPropertyNameList.ToString)

            DataHandler.GetDS(m_oFD.ConnectionString, oDS, sSQL.ToString, "RespondentProperties")

        End If

        m_oJobStatus.IncrementStatus(m_sJobID)

    End Sub

    Private Sub Export_LoadDataTable_Responses(ByRef oDS As DataSet)
        Dim sSQL As New StringBuilder()
        Dim oCol As DataColumn
        Dim sQuestionIDList As New StringBuilder("-1")
        Dim oTable As DataTable = oDS.Tables(WORKING_TABLENAME)
        Dim oNC As New clsNamingConvention()

        'prepare the Question ID list.
        For Each oCol In oTable.Columns
            oNC.SetDestTableColName(oCol.ColumnName)
            If oNC.IsTableQuestions Then
                sQuestionIDList.AppendFormat(", {0}", oNC.SurveyQuestionID)
            End If
        Next

        'create the SQL
        If sQuestionIDList.Length > 2 Then
            sSQL.AppendFormat("SELECT RespondentID AS {0}, SurveyID, SurveyQuestionOrder, QuestionPartID, ResponseDesc, AnswerValue ", Me.MYPRIVATE_RESPONDENTID)
            sSQL.Append("FROM vr_Responses ")
            sSQL.AppendFormat("WHERE RespondentID IN (SELECT RespondentID FROM vw_Respondents {0}) ", m_sRespondentFilterSQL)
            sSQL.AppendFormat(" AND SurveyQuestionOrder IN ({0})", sQuestionIDList.ToString)

            DataHandler.GetDS(m_oFD.ConnectionString, oDS, sSQL.ToString, "Responses")

        End If

        m_oJobStatus.IncrementStatus(m_sJobID)

    End Sub

    Private Sub Export_CopyDataFromDBTableToWorkingTable(ByRef oDS As DataSet)
        Dim oRow, oNewRow, oChildRow As DataRow
        Dim oCol As DataColumn
        Dim i As Integer = 0
        Dim sNewRowColName As String

        'first, set up the relationships
        If oDS.Tables.Contains("RespondentProperties") Then
            oDS.Relations.Add("RespondentProperties", oDS.Tables("Respondents").Columns(MYPRIVATE_RESPONDENTID), oDS.Tables("RespondentProperties").Columns(MYPRIVATE_RESPONDENTID))
        End If
        If oDS.Tables.Contains("Responses") Then
            oDS.Relations.Add("Responses", oDS.Tables("Respondents").Columns(MYPRIVATE_RESPONDENTID), oDS.Tables("Responses").Columns(MYPRIVATE_RESPONDENTID))
        End If

        'now copy the data from base tables to results table
        For Each oRow In oDS.Tables("Respondents").Rows
            oNewRow = oDS.Tables(WORKING_TABLENAME).NewRow
            Me.Export_CopyDataFromDBTableToWorkingTable(oRow, oNewRow)

            If oDS.Tables.Contains("RespondentProperties") Then
                For Each oChildRow In oRow.GetChildRows("RespondentProperties")
                    Me.Export_CopyDataFromDBTableToWorkingTable(oChildRow, oNewRow)
                Next

            End If

            If oDS.Tables.Contains("Responses") Then
                For Each oChildRow In oRow.GetChildRows("Responses")
                    Me.Export_CopyDataFromDBTableToWorkingTable(oChildRow, oNewRow)
                Next

            End If

            oDS.Tables(WORKING_TABLENAME).Rows.Add(oNewRow)

            'update job status
            i += 1
            m_oJobStatus.SetStatus(m_sJobID, i, oDS.Tables("Respondents").Rows.Count, 4, 50)

        Next

    End Sub

    Private Sub Export_CopyDataFromDBTableToWorkingTable(ByRef oSourceRow As DataRow, ByRef oDestRow As DataRow)
        'Primay method        
        Dim oCol As DataColumn
        Dim i As Integer
        Dim sDestColName As String
        Dim oNC As New clsNamingConvention()

        'SKIP THE FIRST COLUMN ("MyPrivateRespondentID") from source table!
        For i = 1 To oSourceRow.Table.Columns.Count - 1
            oCol = oSourceRow.Table.Columns(i)
            Select Case oSourceRow.Table.TableName.ToUpper
                Case "RESPONDENTS"
                    oNC.SetSourceTableColName("RESPONDENTS", oCol.ColumnName)
                    sDestColName = oNC.DestColName

                Case "RESPONDENTPROPERTIES"
                    If oCol.ColumnName.ToUpper = "PROPERTYVALUE" Then
                        oNC.SetSourceTableColName("RESPONDENTPROPERTIES", "", oSourceRow("propertyname").ToString)
                        sDestColName = oNC.DestColName

                    Else
                        sDestColName = "NONE"

                    End If

                Case "RESPONSES"
                    If oCol.ColumnName.ToUpper = "ANSWERVALUE" Or oCol.ColumnName.ToUpper = "RESPONSEDESC" Then
                        oNC.SetSourceTableColName("RESPONSES", oCol.ColumnName, CInt(oSourceRow("SurveyQuestionOrder")), CInt(oSourceRow("QuestionPartID")))
                        sDestColName = oNC.DestColName

                    Else
                        sDestColName = "NONE"

                    End If

            End Select

            'check that column exists in destination table
            If oDestRow.Table.Columns.Contains(sDestColName) Then
                'copy value from source to destination table
                oDestRow(sDestColName) = oSourceRow(oCol.ColumnName)

            End If

            'check to copy open answer responses
            'If oNC.SourceTableName = "RESPONSES" Then
            '    oNC.SetSourceTableColName("RESPONSES", "RESPONSEDESC", CInt(oSourceRow("SurveyQuestionOrder")), CInt(oSourceRow("QuestionPartID")))
            '    sDestColName = oNC.DestColName
            '    If oDestRow.Table.Columns.Contains(sDestColName) Then oDestRow(sDestColName) = oSourceRow(oCol.ColumnName)

            'End If

        Next

    End Sub

    'Export data from dataset to file
    Private Sub Export_DSToFile(ByRef oDS As DataSet)
        Dim oFileIE As DMI.clsFileImportExport
        Dim sDelimiter As String

        m_oJobStatus.SetStatus(m_sJobID, 51)

        If IsDBNull(m_oFD.Details(tblFileDefs.FileDefDelimiter)) Then
            sDelimiter = ""
        Else
            sDelimiter = m_oFD.Details(tblFileDefs.FileDefDelimiter).ToString
        End If
        oFileIE = DMI.clsFIEFactory.Make(CType(m_oFD.Details(tblFileDefs.FileTypeID), DMI.FileTypes), _
                                         m_sIOFile, sDelimiter)

        oFileIE.FileDef = GetImportExportFileDef(m_oFD)

        oFileIE.Update(oDS, WORKING_TABLENAME)

        m_oJobStatus.SetStatus(m_sJobID, 100)

    End Sub

    'Log events for export
    Private Sub Export_LogEvents(ByRef oDS As DataSet)
        Dim dr As DataRow
        Dim iRespondentID As Integer

        'loop thru all respondents in working table
        For Each dr In oDS.Tables("Respondents").Rows
            'setup respondent id
            iRespondentID = CInt(dr.Item(MYPRIVATE_RESPONDENTID))
            m_oRespondent.Details(tblRespondents.RespondentID) = iRespondentID

            'log export
            m_oRespondent.InsertEvent(CInt(qmsEventCodes.RESPONDENT_EXPORTED), m_iUserID, m_iFileDefID.ToString)

            'log selected event
            If m_iEventIDLog > 0 Then m_oRespondent.InsertEvent(m_iEventIDLog, m_iUserID)

        Next

    End Sub

    Private Sub Import_WriteDataFromWorkingTableToDatabase(ByRef oDS As DataSet)
        Dim oRow As DataRow
        Dim iRespondentID As Integer
        Dim iCounter As Integer = 0

        For Each oRow In oDS.Tables(WORKING_TABLENAME).Rows
            Import_WriteToTable_Respondents(oRow, iRespondentID)
            Import_WriteToTable_RespondentProperties(oRow, iRespondentID)
            'Do not allow imports into response table at this point of development
            'Import_WriteToTable_Responses(oRow, iRespondentID)

            'update job status
            iCounter += 1
            m_oJobStatus.SetStatus(m_sJobID, iCounter, oDS.Tables(WORKING_TABLENAME).Rows.Count, 2, 100)

        Next

    End Sub

    Private Sub Import_WriteToTable_Respondents(ByRef oRow As DataRow, ByRef iRespondentID As Integer)
        'called during an import, copies row values from working table to respondent table
        Dim sSQL As New System.Text.StringBuilder()
        Dim sFields As New System.Text.StringBuilder()
        Dim sVals As New System.Text.StringBuilder()
        Dim iEvent As qmsEventCodes
        Dim oCol As DataColumn
        Dim oNC As New clsNamingConvention()

        'Check for imported respondent id
        iRespondentID = 0
        oNC.SetSourceTableColName("RESPONDENTS", "RESPONDENTID")
        If oRow.Table.Columns.Contains(oNC.DestColName) Then iRespondentID = SafeDBInteger(oRow(oNC.DestColName))

        If iRespondentID > 0 Then
            'do update
            sSQL.Append("UPDATE Respondents SET ")
            For Each oCol In oRow.Table.Columns
                oNC.SetDestTableColName(oCol.ColumnName)
                If (oNC.IsTableRespondents) AndAlso (oNC.SourceColName.ToUpper <> "RESPONDENTID") Then
                    If sFields.Length > 0 Then sFields.Append(", ")
                    sFields.AppendFormat("{0} = ", oNC.SourceColName)
                    If SafeDBString(oRow(oCol.ColumnName)) = "" Then
                        sFields.Append(" NULL ")
                    Else
                        sFields.Append(DataHandler.QuoteString(SafeDBString(oRow(oCol.ColumnName))))
                    End If
                End If
            Next
            sSQL.Append(sFields.ToString)
            sSQL.AppendFormat(" WHERE RespondentID = {0};", iRespondentID)
            sSQL.AppendFormat("SELECT {0) AS RespondentID", iRespondentID)

            iEvent = qmsEventCodes.RESPONDENT_UPDATED_IMPORT

        Else
            'do insert
            For Each oCol In oRow.Table.Columns
                oNC.SetDestTableColName(oCol.ColumnName)
                If oNC.IsTableRespondents Then
                    'field name
                    sFields.AppendFormat(", {0}", oNC.SourceColName)

                    'field value
                    If IsDBNull(oRow(oCol.ColumnName)) Then
                        sVals.Append(", NULL")

                    Else
                        sVals.AppendFormat(", '{0}'", SafeDBString(oRow(oCol.ColumnName)))

                    End If
                End If
            Next
            sSQL.AppendFormat("INSERT INTO Respondents (SurveyInstanceID{0}) VALUES ({1}{2}); ", sFields.ToString, m_iSurveyInstanceID, sVals.ToString)
            sSQL.Append("SELECT @@IDENTITY AS RespondentID")

            iEvent = qmsEventCodes.RESPONDENT_IMPORTED

        End If

        'DataHandler.GetDS(m_oFD.ConnectionString, oDS, sSQL.ToString)
        'iRespondentID = SafeDBInteger(oDS.Tables(0).Rows(0)("RespondentID"))
        iRespondentID = SafeDBInteger(DMI.SqlHelper.ExecuteScalar(m_oFD.ConnectionString, CommandType.Text, sSQL.ToString))

        'Log events
        m_oRespondent.Details(tblRespondents.RespondentID) = iRespondentID
        m_oRespondent.InsertEvent(CInt(iEvent), m_iUserID, m_iFileDefID.ToString)
        If m_iEventIDLog > 0 Then m_oRespondent.InsertEvent(m_iEventIDLog, m_iUserID)

    End Sub

    Private Sub Import_WriteToTable_RespondentProperties(ByRef oRow As DataRow, ByVal iRespondentID As Integer)
        'called during import, copy row values from working table to respondent properties table
        Dim sSQL As New StringBuilder()
        Dim oCol As DataColumn
        Dim oNC As New clsNamingConvention()

        'build insert sql for respondent properties table
        sSQL = New StringBuilder()
        For Each oCol In oRow.Table.Columns
            oNC.SetDestTableColName(oCol.ColumnName)
            If oNC.IsTableRespondentProperties Then
                If SafeDBString(oRow(oCol.ColumnName)) <> "" Then
                    sSQL.AppendFormat("EXEC spSetRespondentProperty {0}, '{1}', '{2}'; ", _
                        iRespondentID, SafeDBString(oNC.PropertyName), SafeDBString(oRow(oCol.ColumnName)))

                End If
            End If
        Next

        'execute insert sql if there are any property values to insert
        If Trim(sSQL.ToString) <> "" Then DMI.SqlHelper.ExecuteNonQuery(m_oFD.ConnectionString, CommandType.Text, sSQL.ToString)

    End Sub

    'Let QMS.clsRespondents build SQL WHERE clause (centralize criteria builder)
    Private Function GetRespondentFilterSQL(ByVal ht As Hashtable) As String
        Dim oRespondents As New QMS.clsRespondents()
        Dim dr As QMS.dsRespondents.SearchRow = CType(oRespondents.NewSearchRow, QMS.dsRespondents.SearchRow)
        Dim sWHERE As String

        If ht.Contains("SurveyInstanceID") Then dr.SurveyInstanceID = CInt(ht("SurveyInstanceID"))
        If ht.Contains("SurveyInstanceDateAfter") Then dr.SurveyInstanceStartRange = CDate(ht("SurveyInstanceDateAfter"))
        If ht.Contains("SurveyInstanceDateBefore") Then dr.SurveyInstanceEndRange = CDate(ht("SurveyInstanceDateBefore"))
        If ht.Contains("MailingSeeds") Then dr.IncludeMailSeeds = True
        If ht.Contains("SurveyID") Then dr.SurveyID = CInt(ht("SurveyID"))
        If ht.Contains("ClientID") Then dr.ClientID = CInt(ht("ClientID"))
        If ht.Contains("EventID") Then dr.EventID = CInt(ht("EventID"))
        If ht.Contains("EventDateAfter") Then dr.EventStartRange = CDate(ht("EventDateAfter"))
        If ht.Contains("EventDateBefore") Then dr.EventEndRange = CDate(ht("EventDateBefore"))
        If ht.Contains("BatchIDs") Then dr.BatchIDList = ht("BatchIDs").ToString
        If ht.Contains("FileDefFilterID") Then dr.FileDefFilterID = CInt(ht("FileDefFilterID"))
        If ht.Contains("ExcludeFinalCodes") Then dr.ExcludeFinalCodes = True

        sWHERE = oRespondents.GetWhereSQL(dr)
        dr = Nothing
        oRespondents = Nothing

        Return sWHERE

    End Function

    Private Sub WriteLineToLogFile(ByVal sMsg As String, ByVal sFileName As String)
        'Interface method
        sMsg = Now & " " & sMsg
        Me.WriteLineToFile(sMsg, sFileName)

    End Sub

    Private Sub WriteLineToFile(ByVal sMsg As String, ByVal sFileName As String)
        'Base Method
        Dim oText As New System.IO.StreamWriter(sFileName)
        oText.WriteLine(sMsg)
        oText.Close()

    End Sub

    Private Function SafeDBString(ByRef oObject As Object) As String
        Dim sRetval As String = ""
        If Not IsDBNull(oObject) Then
            If Not IsNothing(oObject) Then
                sRetval = CStr(oObject).Replace("'", "''")
            End If
        End If

        Return sRetval

    End Function

    Private Function SafeDBInteger(ByRef oObject As Object) As Integer
        Dim iRetval As Integer = 0
        If Not IsDBNull(oObject) Then
            If Not IsNothing(oObject) Then
                If IsNumeric(oObject) Then
                    iRetval = CInt(oObject)
                End If
            End If
        End If

        Return iRetval

    End Function

End Class
