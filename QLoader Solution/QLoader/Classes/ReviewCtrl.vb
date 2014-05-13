Option Explicit On 
Option Strict On

Imports System.Data.SqlClient
Imports Nrc.Qualisys.QLoader.Library.SqlProvider

Public Class ReviewCtrl

#Region " Private Constants "

    'The label for the option of showing load tables together
    Public Const ALL_TABLE_LABEL As String = "All Tables"

#End Region

#Region " Private Members "

    Private mPackage As DTSPackage          'DTS package
    Private mDataFile As DataFile           'Data File
    Private mPreloadTable As DataTable      'Preload table data
    Private mLoadTables As DataTable        'Load tables data
    Private mFirstRecordID As Integer       'First record ID
    Private mRecordCount As Integer         'Record count of preload table
    Private mRecordIncrement As Integer     'Increment for each retrieve
    Private mLoadRecordBeginID As Integer   'Begin record ID of retrieved data
    Private mLoadRecordEndID As Integer     'End record ID of retrieved data
    Private mCurrentRecordID As Integer     'Current record ID
    Private mViewSkippedOnly As Boolean     'View skipped record only
    Private mSkippedCount As Integer        'Skipped record count

#End Region

#Region " User Events "

    Event GroupChanged()    'a new group is selected
    Event FileSwitched()    'another file in the group is selected

#End Region

#Region " Public Properties "

    Public ReadOnly Property DataFileID() As Integer
        Get
            If (mDataFile Is Nothing) Then
                Return (0)
            Else
                Return (mDataFile.DataFileID)
            End If
        End Get
    End Property

    'Data available to show
    Public ReadOnly Property DataAvailable() As Boolean
        Get
            If ((Not mPackage Is Nothing) AndAlso _
                (Not mDataFile Is Nothing) AndAlso _
                (mDataFile.DataFileID > 0)) Then
                Return True
            Else
                Return False
            End If
        End Get
    End Property

    Public ReadOnly Property FirstRecordID() As Integer
        Get
            Return (mFirstRecordID)
        End Get
    End Property

    Public ReadOnly Property RecordCount() As Integer
        Get
            Return mRecordCount
        End Get
    End Property

    Public Property CurrentRecordID() As Integer
        Get
            Return mCurrentRecordID
        End Get
        Set(ByVal Value As Integer)
            mCurrentRecordID = Value
            RetrieveData()
        End Set
    End Property

    'Source table column list
    Public ReadOnly Property SourceColumns() As ReviewColumnCollection
        Get
            Dim columns As New ReviewColumnCollection
            Dim col As ReviewColumn
            Dim dtsColumns As ColumnCollection = mPackage.Source.Columns
            Dim dtsCol As SourceColumn
            Dim maxOrdinal As Integer = 0

            For Each dtsCol In dtsColumns
                col = New ReviewColumn(dtsCol.Ordinal, dtsCol.ColumnName)
                columns.Add(col)
                If (dtsCol.Ordinal > maxOrdinal) Then maxOrdinal = dtsCol.Ordinal
            Next

            'Add "DF_ID" column
            maxOrdinal += 1
            col = New ReviewColumn(maxOrdinal, "DF_ID")
            columns.Add(col)

            Return (columns)
        End Get
    End Property

    'Destination tables column list
    Public ReadOnly Property DestColumns(ByVal tableName As String) As ReviewColumnCollection
        Get
            Dim columns As New ReviewColumnCollection
            Dim col As ReviewColumn
            Dim dest As DTSDestination = Nothing
            Dim dtsCol As DestinationColumn

            Select Case tableName
                Case ALL_TABLE_LABEL
                    For Each dest In Me.mPackage.Destinations
                        If (Not dest.UsedInPackage) Then GoTo NextLoop
                        For Each dtsCol In dest.Columns
                            'If (dtsCol.ColumnName.ToLower <> "datafile_id" AndAlso _
                            '    dtsCol.ColumnName.ToLower <> "df_id") Then
                            If (dtsCol.ColumnName.ToLower <> "datafile_id") Then
                                col = New ReviewColumn(dest.TableName, dtsCol.Ordinal, dtsCol.ColumnName)
                                columns.Add(col)
                            End If
                        Next
NextLoop:
                    Next

                Case Else
                    For Each dest In Me.mPackage.Destinations
                        If (dest.UsedInPackage AndAlso _
                            dest.TableName = tableName) Then Exit For
                    Next
                    If (dest Is Nothing) Then
                        Throw New ArgumentException("ReviewCtrl: can not find destination table " & tableName)
                        Return Nothing
                    End If
                    For Each dtsCol In dest.Columns
                        'If (dtsCol.ColumnName.ToLower <> "datafile_id" AndAlso _
                        '    dtsCol.ColumnName.ToLower <> "df_id") Then
                        If (dtsCol.ColumnName.ToLower <> "datafile_id") Then
                            col = New ReviewColumn(dest.TableName, dtsCol.Ordinal, dtsCol.ColumnName)
                            columns.Add(col)
                        End If
                    Next

            End Select

            Return (columns)
        End Get
    End Property

    'Source column value
    Public ReadOnly Property SourceValue(ByVal columnName As String) As String
        Get
            Dim row As Integer = mCurrentRecordID - mLoadRecordBeginID

            If (mPreloadTable.Rows(row).Item(columnName) Is DBNull.Value) Then
                Return ("")
            Else
                Return (mPreloadTable.Rows(row).Item(columnName).ToString)
            End If
        End Get
    End Property

    'Destination column value
    Public ReadOnly Property DestValue(ByVal tableName As String, ByVal columnName As String) As String
        Get
            Dim row As Integer = SearchDestRow()
            If (row < 0) Then Return ""

            If (mLoadTables.Rows(row).Item(columnName) Is DBNull.Value) Then
                Return ("")
            Else
                Return (mLoadTables.Rows(row).Item(columnName).ToString)
            End If
        End Get
    End Property

    Public ReadOnly Property IsGrouped() As Boolean
        Get
            Return (mDataFile.IsGrouped)
        End Get
    End Property

    Public ReadOnly Property GroupList() As ArrayList
        Get
            If (Not Me.IsGrouped) Then Return (Nothing)
            Dim list As New ArrayList
            Dim file As New DataFile

            'Get files in the group
            Dim files() As String = mDataFile.GroupList.Split(","c)

            'Sort files by file ID
            Dim fileID(files.Length - 1) As Integer
            Dim i As Integer
            For i = 0 To files.Length - 1
                fileID(i) = CInt(files(i))
            Next i
            Array.Sort(fileID)

            'Save file ID and file original name to array of list item
            Dim value As Integer
            Dim text As String
            For i = 0 To fileID.Length - 1
                file.LoadFromDB(fileID(i))
                value = fileID(i)
                text = file.OriginalFileName + " (" & fileID(i) & ")"
                list.Add(New ListItem(value, text))
            Next

            Return (list)
        End Get
    End Property

    Public ReadOnly Property SkippedCount() As Integer
        Get
            Return (mSkippedCount)
        End Get
    End Property

    Public Property ViewSkippedOnly() As Boolean
        Get
            Return mViewSkippedOnly
        End Get
        Set(ByVal Value As Boolean)
            If (mViewSkippedOnly = Value) Then Return
            mViewSkippedOnly = Value
            Initial()
        End Set
    End Property

#End Region

#Region " Public methods "

    'This is the entrance method when a new package or file is selected on UI
    Public Sub Initial(ByVal fileID As Integer, ByVal sameGroup As Boolean)
        If (fileID <= 0) Then Return
        Dim file As New DataFile
        file.LoadFromDB(fileID)
        Dim package As New DTSPackage(file.PackageID, file.Version)
        Initial(package, file, sameGroup)
    End Sub

    'Get the destination table list
    Public Function DestTableList() As String()
        'Get destination table count
        Dim dest As DTSDestination
        Dim count As Integer = 0
        For Each dest In mPackage.Destinations
            If dest.UsedInPackage Then
                count += 1
            End If
        Next
        If (count > 1) Then count += 1 'space for "All Tables"

        Dim destTables(count - 1) As String
        Dim id As Integer = 0

        'Add "All Tables" entry to first of table list
        If (count > 1) Then
            destTables(id) = ALL_TABLE_LABEL
            id += 1
        End If

        'Add items to table list
        For Each dest In Me.mPackage.Destinations
            If dest.UsedInPackage Then
                destTables(id) = dest.TableName
                id += 1
            End If
        Next

        Return (destTables)

    End Function

    'Get the formula and related source columns 
    'for a specific destination column
    Public Function DestColumnFormula( _
                ByVal tableName As String, _
                ByVal columnName As String, _
                ByRef formula As String, _
                ByRef sourceColumns As ReviewColumnCollection _
            ) As Boolean

        tableName = tableName.ToLower
        columnName = columnName.ToLower

        'Find destination table
        Dim dest As DTSDestination = Nothing
        For Each dest In Me.mPackage.Destinations
            If (dest.TableName.ToLower = tableName) Then Exit For
        Next
        If (dest Is Nothing) Then Return False

        'Find destination column
        Dim col As DestinationColumn = Nothing
        For Each col In dest.Columns
            If (col.ColumnName.ToLower = columnName) Then Exit For
        Next
        If (col Is Nothing) Then Return False

        formula = col.Formula
        sourceColumns = New ReviewColumnCollection
        sourceColumns.CopySourceColumn(col.SourceColumns)

        Return True

    End Function

    Public Function NoData() As Boolean
        If (mLoadRecordBeginID = 0 OrElse mLoadRecordEndID = 0) Then
            Return True
        Else : Return False
        End If
    End Function
#End Region

#Region " Private Methods "

    Private Sub Initial(ByVal package As DTSPackage, ByVal file As DataFile, ByVal sameGroup As Boolean)
        mPackage = package
        mDataFile = file
        InitSettings(sameGroup)
        GetLoadDataInfo()
        RetrieveData()
        If (sameGroup) Then
            RaiseEvent FileSwitched()
        Else
            RaiseEvent GroupChanged()
        End If
    End Sub

    Private Sub Initial()
        InitSettings(True)
        GetLoadDataInfo()
        RetrieveData()
        RaiseEvent FileSwitched()
    End Sub

    'Initialize some settings
    Private Sub InitSettings(ByVal sameGroup As Boolean)
        mFirstRecordID = 0
        mRecordCount = 0
        mRecordIncrement = 0
        mLoadRecordBeginID = 0
        mLoadRecordEndID = 0
        mCurrentRecordID = 1
        If (Not sameGroup) Then mViewSkippedOnly = False
    End Sub

    'Get the general info of loading data:
    '(1) Preload table record count
    '(2) Increment for each retrieve
    Private Sub GetLoadDataInfo()
        Dim ds As DataSet
        Dim dt As DataTable
        Try
            'load dataset which includes 5 datatables
            ds = Me.mPackage.Review(mDataFile.DataFileID, 1, mViewSkippedOnly)

            '1st datatable: total record count and increment
            dt = ds.Tables(0)
            mRecordCount = CInt(dt.Rows(0).Item(0))
            mFirstRecordID = CInt(IIf(mRecordCount > 0, 1, 0))
            mRecordIncrement = CInt(dt.Rows(0).Item(1))

            mSkippedCount = GetSkippedCount()

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        End Try
    End Sub

    'Retrieve preload/load data
    'Note: we will not retrieve all the data from preload and load tables.
    '      every time we will only retrieve a segment (e.g. 100 records). 
    Private Sub RetrieveData()
        'check if needs to reload data.
        'if yes, set the begin ID
        If (mCurrentRecordID < mLoadRecordBeginID) Then
            mLoadRecordBeginID = mCurrentRecordID - mRecordIncrement + 1
            If (mLoadRecordBeginID < 1) Then mLoadRecordBeginID = 1
        ElseIf (mCurrentRecordID > mLoadRecordEndID) Then
            mLoadRecordBeginID = mCurrentRecordID
            If (mLoadRecordBeginID + mRecordIncrement - 1 > mRecordCount) Then
                mLoadRecordBeginID = mRecordCount - mRecordIncrement + 1
                If (mLoadRecordBeginID < 1) Then mLoadRecordBeginID = 1
            End If
        Else
            Return
        End If

        'load data
        Dim ds As DataSet
        Dim dt As DataTable
        Try
            'load dataset which includes 5 datatables
            ds = Me.mPackage.Review(mDataFile.DataFileID, mLoadRecordBeginID, mViewSkippedOnly)

            '2nd datatable: ID range
            dt = ds.Tables(1)
            If (dt.Rows(0).Item(0) Is DBNull.Value) Then
                mLoadRecordBeginID = 0
                'Else
                '    mLoadRecordBeginID = CInt(dt.Rows(0).Item(0))
            End If

            If (dt.Rows(0).Item(1) Is DBNull.Value) Then
                mLoadRecordEndID = 0
            Else
                mLoadRecordEndID = mLoadRecordBeginID _
                                   + CInt(dt.Rows(0).Item(1)) _
                                   - CInt(dt.Rows(0).Item(0))
            End If

            '3rd datatable: Preload table
            mPreloadTable = ds.Tables(2)

            '4th datatable: load tables
            mLoadTables = ds.Tables(3)

        Catch ex As Exception
            Throw New ArgumentException(ex.Message)
        End Try

    End Sub

    'Function:
    '   Search the related destination record.
    '   Because not always do we have destination record related to
    '   source record due to loading error. We use the "DF_ID" in
    '   source record to look for the related destination record.
    '
    'Return:
    '   >= 0: related destination row ID
    '   < 0:  no related destination row
    Private Function SearchDestRow() As Integer
        If (mLoadTables Is Nothing OrElse _
            mLoadTables.Rows.Count = 0) Then Return -1
        Dim row As Integer = mCurrentRecordID - mLoadRecordBeginID
        If (row > mLoadTables.Rows.Count - 1) Then
            row = mLoadTables.Rows.Count - 1
        End If
        Dim i As Integer

        For i = row To 0 Step -1
            If (CInt(mLoadTables.Rows(i).Item("DF_ID")) = mCurrentRecordID) Then Return i
        Next
        Return -1
    End Function

    Private Function GetSkippedCount() As Integer
        Return (PackageDB.GetSkippedCount(Me.DataFileID))
    End Function
#End Region

End Class

