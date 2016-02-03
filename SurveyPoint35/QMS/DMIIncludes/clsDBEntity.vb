Option Strict On
Option Explicit On

Public MustInherit Class clsDBEntity

    Protected _ds As DataSet
    Protected _da As SqlClient.SqlDataAdapter
    Protected _oConn As New SqlClient.SqlConnection(DataHandler.sConnection)
    Protected _drCriteria As DataRow
    Protected _sConnection As String = ""
    Protected _sTableName As String = ""
    Protected _sDSName As String = "NONE"
    Protected _iRowIndex As Integer = -1
    Protected _sErrorMsg As String = ""
    Protected _bEnforceConstraints As Boolean = True

    'Base constructor
    Public Sub New(Optional ByVal iEntityID As Integer = 0, Optional ByVal bFilterLookUps As Boolean = True)

        InitSettings()

        _sConnection = DataHandler.sConnection
        _oConn = New SqlClient.SqlConnection(_sConnection)
        _da = New SqlClient.SqlDataAdapter()

        '_ds.EnforceConstraints = False
        If iEntityID > 0 Then Fill(iEntityID, bFilterLookUps)

    End Sub

    'Constructor for not filling main table
    Public Sub New(ByVal bFilterLookUps As Boolean)
        Me.New(0, bFilterLookUps)

    End Sub

    Public Sub Close()
        _ds = Nothing
        _da = Nothing
        _oConn.Close()

    End Sub

    'set up identity criteria in _drCriteria
    Protected MustOverride Sub SetIdentityFilter(ByVal iEntityID As Integer)

    Public Overridable Sub Fill(Optional ByVal iEntityID As Integer = 0, Optional ByVal bFilterLookUps As Boolean = True)

        _ds.EnforceConstraints = False
        Me.BeginLoadData()

        'Set identity filter
        If iEntityID > 0 Then SetIdentityFilter(iEntityID)

        'Fill main table
        _FillMain()

        'Fill lookup tables
        _FillLookups(bFilterLookUps)

        Me.EndLoadData()
        _ds.EnforceConstraints = _bEnforceConstraints

    End Sub

    Public Overridable Sub Fill(ByVal bFilterLookups As Boolean)
        Me.Fill(0, bFilterLookups)

    End Sub

    'Set up entity variables
    Protected MustOverride Sub InitSettings()
    '   _ds = TypedDataSet
    '   _sConnection = DBConnectionString
    '   _oConn = New Connection
    '   _sTableName = NameOfMainTableInDataSet
    '
    ' End Sub

    'Setup data adapter to main table
    Protected Overridable Sub InitDataAdapter()

        '_da.SelectCommand = SelectCommand()
        _da.UpdateCommand = UpdateCommand()
        _da.DeleteCommand = DeleteCommand()
        _da.InsertCommand = InsertCommand()

    End Sub

    'Return update SQL for data adapter
    Protected MustOverride Function UpdateCommand() As SqlClient.SqlCommand
    '   Dim sSQL As String
    '   Dim oCmd As SqlClient.SqlCommand
    '
    '   sSQL = "UPDATE tblTimestamps SET BeginTime = GETDATE WHERE TimestampID = @TimestampID "
    '   oCmd = New SqlClient.SqlCommand(sSQL, Me._oConn)
    '   oCmd.CommandType = CommandType.Text
    '   oCmd.Parameters.Add(New SqlClient.SqlParameter("@TimestampID", SqlDbType.Int, 8, "TimestampID"))
    '
    '   Return oCmd
    '
    'End Function

    'Return insert SQL for data adapter
    Protected MustOverride Function InsertCommand() As SqlClient.SqlCommand
    '   Dim sSQL As String
    '   Dim oCmd As SqlClient.SqlCommand
    '
    '   sSQL = "INSERT INTO tblTimestamps(TimestampID, BeginTime) VALUES(@TimestampID, GETDATE())"
    '   oCmd = New SqlClient.SqlCommand(sSQL, Me._oConn)
    '   oCmd.CommandType = CommandType.Text
    '   oCmd.Parameters.Add(New SqlClient.SqlParameter("@TimestampID", SqlDbType.Int, 8, "TimestampID"))
    '
    '   Return oCmd
    '
    'End Function

    'Return delete SQL for data adapter
    Protected MustOverride Function DeleteCommand() As SqlClient.SqlCommand
    '   Dim sSQL As String
    '   Dim oCmd As SqlClient.SqlCommand
    '
    '   sSQL = "DELETE tblTimestamps WHERE TimestampID = @TimestampID "
    '   oCmd = New SqlClient.SqlCommand(sSQL, Me._oConn)
    '   oCmd.CommandType = CommandType.Text
    '   oCmd.Parameters.Add(New SqlClient.SqlParameter("@TimestampID", SqlDbType.Int, 8, "TimestampID"))
    '
    '   Return oCmd
    '
    'End Function

    'Return select SQL for data adapter
    Protected Overridable Function SelectCommand() As SqlClient.SqlCommand
        Dim oCmd As New SqlClient.SqlCommand()

        oCmd.Connection = Me._oConn
        oCmd.CommandType = CommandType.Text
        oCmd.CommandText = Me.BuildSelectSQL(Me._drCriteria)

        Return oCmd

    End Function

    'Fills main table in dataset
    Protected Overridable Sub _FillMain()
        _da.SelectCommand = SelectCommand()
        _ds.Tables(_sTableName).Clear()
        _da.Fill(_ds, _sTableName)

    End Sub

    'public method to fill main table
    Public Overridable Sub FillMain(Optional ByVal bEnforceConstraints As Boolean = True)

        If bEnforceConstraints Then
            Me.BeginLoadData()
            _FillMain()
            Me.EndLoadData()

        Else
            _ds.EnforceConstraints = False
            _FillMain()

        End If

    End Sub

    'Fills dataset with lookup tables
    Protected MustOverride Sub _FillLookups(Optional ByVal bRelatedRecordsOnly As Boolean = True)

    'public method to fill lookup tables
    Public Sub FillLookups(Optional ByVal bRelatedRecordsOnly As Boolean = True)

        _ds.EnforceConstraints = False
        Me.BeginLoadData()
        _FillLookups(bRelatedRecordsOnly)
        Me.EndLoadData()
        _ds.EnforceConstraints = _bEnforceConstraints

    End Sub

    'Generates where SQL to query main table
    Protected MustOverride Function BuildSelectSQL(ByVal drSearch As DataRow) As String

    'Remove column expressions to allow out-of-order table queries
    Protected Overridable Sub BeginLoadData()
        Dim dt As DataTable

        For Each dt In Me._ds.Tables
            dt.BeginLoadData()
        Next

    End Sub

    'Set column expressions once table queries have been run
    Protected Overridable Sub EndLoadData()
        Dim dt As DataTable

        For Each dt In Me._ds.Tables
            dt.EndLoadData()
        Next

    End Sub

    'Verifies inserts into main table
    Protected Overridable Function VerifyInsert(ByVal dr As DataRow) As Boolean
        Return True

    End Function

    'Verifies updates made to main table
    Protected Overridable Function VerifyUpdate() As Boolean
        Return True

    End Function

    'Verifies deletes to main table
    Protected Overridable Function VerifyDelete(ByRef dr As DataRow) As Boolean
        Return True

    End Function

    'Set and get unique dataset name
    Public Property DSName() As String
        Get
            Return _ds.DataSetName

        End Get
        Set(ByVal Value As String)
            _sDSName = Value

        End Set
    End Property

    'Verifies dataset name and reconsitutes dataset
    Public Overridable Function DSVerify(ByVal ds As DataSet) As Boolean

        'Is dataset empty
        If Not IsNothing(ds) Then
            'Does dataset have correct name
            If ds.DataSetName = _sDSName Then
                'Dataset successfully verified
                Me.DataSet = ds
                Return True

            End If
        End If

        'Input dataset not verified
        Return False

    End Function

    'Get and set entity dataset
    Public Overridable Property DataSet() As DataSet
        Get
            _ds.DataSetName = _sDSName
            Return _ds

        End Get
        Set(ByVal Value As DataSet)
            _ds = Value

        End Set
    End Property

    'Returns error messages
    Public ReadOnly Property ErrMsg() As String
        Get
            Return Me._sErrorMsg

        End Get
    End Property

    'creates new row and adds to datatable
    'used primarily for dategrid editing
    Public Overridable Function NewRow() As DataRow
        Dim dr As DataRow = Me._ds.Tables(Me._sTableName).NewRow
        SetNewRowDefaults(dr)
        Me.AddRow(dr)

        'Show only new row in datatable
        Me._ds.Tables(Me._sTableName).DefaultView.RowStateFilter = DataViewRowState.Added

        Return dr

    End Function

    Protected Overridable Sub SetNewRowDefaults(ByRef dr As DataRow)
        'set default values for new row to be added to datatable
        'used primarily for datagrid editing

    End Sub

    Public Overridable Sub AddRow(ByVal dr As DataRow)

        If Me.VerifyInsert(dr) Then
            Me._ds.Tables(Me._sTableName).Rows.Add(dr)

        End If

    End Sub

    Public Overridable Function NewSearch() As DataRow

        Return Me._ds.Tables("Search").NewRow

    End Function

    Public Sub Clear()

        Me._ds.Tables(Me._sTableName).Clear()

    End Sub

    'Base search method for main table and optionally fills lookup tables
    Public Overridable Sub Search(ByVal drCriteria As DataRow, Optional ByVal bFilterLookUps As Boolean = False)
        'set new search criteria
        Me._drCriteria = drCriteria

        'Turn off column expressions to allow dataset to be filled
        _ds.EnforceConstraints = False
        Me.BeginLoadData()

        'fill main table using search criteria
        Me.FillMain()

        'fill lookups only if filtered lookups are required, otherwise lookups should already be filled
        If bFilterLookUps Then Me.FillLookups()

        'store search criteria
        Me.DataSet.Tables("Search").Clear()
        Me.DataSet.Tables("Search").Rows.Add(drCriteria)

        'Turn on column expressions, dataset has been filled
        Me.EndLoadData()
        _ds.EnforceConstraints = _bEnforceConstraints

    End Sub

    'Performs search and fill external dataset
    Public Overridable Sub Search(ByVal drCriteria As DataRow, ByRef ds As DataSet, ByVal sTableName As String)
        Me._drCriteria = drCriteria

        Dim sSQL As String = Me.BuildSelectSQL(drCriteria)

        DataHandler.GetDS(Me._sConnection, ds, sSQL, sTableName)

    End Sub

    'Saves dataset to database
    Public Overridable Sub Save()
        'init data adapter
        InitDataAdapter()

        'commit to database
        Me._oConn.Open()
        Me._da.Update(Me._ds.Tables(Me._sTableName))
        Me._oConn.Close()

        'reset dataset view
        Me._ds.Tables(Me._sTableName).DefaultView.RowStateFilter = DataViewRowState.CurrentRows

    End Sub

    Public Enum RowCusor
        BOT = -1  'Beginning of table
        EOT = -99 'End of table

    End Enum

    Public Sub NextRow()
        'Increment row index
        Me._iRowIndex += 1

        'Reached end of table?
        If Me._ds.Tables(Me._sTableName).Rows.Count < Me._iRowIndex Then
            Me._iRowIndex = RowCusor.EOT

        End If

    End Sub

    Public Sub PrevRow()
        'Decrement row index
        Me._iRowIndex -= 1

        'Reached beginning of table?
        If Me._iRowIndex < 0 Then
            Me._iRowIndex = RowCusor.BOT

        End If

    End Sub

    Public Sub FirstRow()
        'Check for rows in table then set index to first row
        If Me._ds.Tables(Me._sTableName).Rows.Count > 0 Then
            Me._iRowIndex = 0

        Else
            'no rows in table, set row index to BOT
            Me._iRowIndex = RowCusor.BOT

        End If

    End Sub

    Public Sub LastRow()
        'Check for rows in table then set index to last row
        If Me._ds.Tables(Me._sTableName).Rows.Count > 0 Then
            Me._iRowIndex = Me._ds.Tables(Me._sTableName).Rows.Count - 1

        Else
            'no rows in table, set row index to EOT
            Me._iRowIndex = RowCusor.EOT

        End If

    End Sub

    Public Function Delete(ByVal sRowFilter As String) As Boolean
        Dim drs As DataRow()
        Dim dr As DataRow

        drs = Me._ds.Tables(Me._sTableName).Select(sRowFilter)

        If drs.Length > 0 Then

            For Each dr In drs

                If Me.VerifyDelete(dr) Then
                    dr.Delete()

                Else
                    'rollback deletes
                    Me._ds.RejectChanges()
                    Return False

                End If

            Next

        Else
            Me._sErrorMsg = "No Rows Available For Delete"
            Return False

        End If

        Return True

    End Function

    Public Sub ClearCancelledNewRow()
        Dim drv As DataRowView
        Dim dv As DataView

        dv = Me._ds.Tables(Me._sTableName).DefaultView
        dv.RowStateFilter = DataViewRowState.Added

        For Each drv In dv

            drv.Delete()

        Next

        dv.RowStateFilter = DataViewRowState.CurrentRows

        Me.Save()

    End Sub

    Public Function SelectRow(ByVal sRowFilter As String) As DataRow
        Dim drs As DataRow()

        drs = _ds.Tables(Me._sTableName).Select(sRowFilter)

        If drs.Length > 0 Then
            Return drs(0)

        Else
            Return Nothing

        End If

    End Function

    Public ReadOnly Property MainDataTable() As DataTable
        Get
            Return _ds.Tables(Me._sTableName)

        End Get
    End Property

    Public Property SearchCriteria() As DataRow
        Get
            Return Me._drCriteria

        End Get
        Set(ByVal Value As DataRow)
            Me._drCriteria = Value

        End Set
    End Property

    Public Property EnforceConstraints() As Boolean
        Get
            Return _bEnforceConstraints

        End Get
        Set(ByVal Value As Boolean)
            _bEnforceConstraints = Value

        End Set
    End Property

    Public Function NewSearchRow() As DataRow
        Return Me._ds.Tables("Search").NewRow

    End Function

    Public Function NewMainRow() As DataRow
        Return Me._ds.Tables(Me._sTableName).NewRow

    End Function

End Class

