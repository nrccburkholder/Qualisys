Option Strict On
Option Explicit On

Imports Microsoft.Practices.EnterpriseLibrary.Data

'encapsulates data access and manipulation of database tables
Public MustInherit Class clsDBEntity2

    Protected _ds As DataSet
    Protected _oConn As SqlClient.SqlConnection
    Protected _oTransaction As SqlClient.SqlTransaction
    'Protected _sTableName As String = ""
    Protected _dtMainTable As DataTable
    Protected _sDSName As String = "NONE"
    Protected _sErrorMsg As String = ""
    Protected _bCanView As Boolean = True
    Protected _bCanCreate As Boolean = True
    Protected _bCanEdit As Boolean = True
    Protected _bCanDelete As Boolean = True
    Protected _sDeleteFilter As String
    

#Region "Constructor functions"

    'Base constructor
    Public Sub New(ByRef conn As SqlClient.SqlConnection, Optional ByVal iEntityID As Integer = 0, Optional ByVal bFillLookUps As Boolean = False)
        InitSettings()
        _oConn = conn
        If iEntityID > 0 Then FillAll(iEntityID, bFillLookUps)

    End Sub

    'Constructor for not filling main table
    Public Sub New(ByRef conn As SqlClient.SqlConnection, ByVal bFillLookUps As Boolean)
        Me.New(conn, 0, bFillLookUps)

    End Sub

    'With connection string and entity id
    Public Sub New(ByRef sConn As String, Optional ByVal iEntityID As Integer = 0, Optional ByVal bFillLookUps As Boolean = False)
        Me.New(New SqlClient.SqlConnection(sConn), iEntityID, bFillLookUps)

    End Sub

    'With connection string
    Public Sub New(ByRef sConn As String, ByVal bFillLookUps As Boolean)
        Me.New(sConn, 0, bFillLookUps)

    End Sub

    'With entity id and no connection string
    Public Sub New(Optional ByVal iEntityID As Integer = 0, Optional ByVal bFillLookUps As Boolean = False)
        'use shared connection string in datahander class
        Me.New(New SqlClient.SqlConnection(DataHandler.sConnection), iEntityID, bFillLookUps)

    End Sub

    'With no connection string
    Public Sub New(ByVal bFillLookUps As Boolean)
        Me.New(0, bFillLookUps)

    End Sub

#End Region

    'Set up entity variables
    Protected MustOverride Sub InitSettings()
    '   _ds = TypedDataSet
    '   _sTableName = NameOfMainTableInDataSet
    '   _sDeleteFilter = criteria to find data row in dataset ex. "RespondentID = {0}"
    '
    ' End Sub

    Public Overridable Sub Close()
        'release resources
        _ds = Nothing
        _oConn = Nothing

    End Sub

    'set up identity criteria in _drCriteria
    Protected MustOverride Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As DataRow)
    '   drCriteria.Item("RespondentID") = iEntityID
    '
    'End Sub

#Region "FillAll functions"
    'call this to fill main table on specific row entity and related lookup tables
    Public Overridable Sub FillAll(Optional ByVal iEntityID As Integer = 0, Optional ByVal bFillLookUps As Boolean = True)
        Dim drCriteria As DataRow = Me.NewSearchRow()

        'Set identity filter
        If iEntityID > 0 Then SetIdentityFilter(iEntityID, drCriteria)

        FillAll(drCriteria, bFillLookUps)

        drCriteria = Nothing

    End Sub

    'call this to fill main and lookup tables
    Public Overridable Sub FillAll(ByVal bFillLookUps As Boolean)
        FillAll(0, bFillLookUps)

    End Sub

    'call this to fill main and lookup tables for custom criteria
    Public Overridable Sub FillAll(ByRef drCriteria As DataRow, Optional ByVal bFillLookUps As Boolean = True)
        Dim bEnforceConstraints As Boolean = _ds.EnforceConstraints

        _ds.EnforceConstraints = False
        Me.BeginLoadData()

        'Fill main table
        _FillMain(drCriteria)

        'Fill lookup tables
        If bFillLookUps Then _FillLookups(drCriteria)        
        'clean up
        Me.EndLoadData()
        _ds.EnforceConstraints = bEnforceConstraints

    End Sub
#End Region

#Region "DataAdapter functions"
    'Setup data adapter to main table
    Protected Overridable Function InitDataAdapter() As SqlClient.SqlDataAdapter
        Dim da As New SqlClient.SqlDataAdapter()

        da.UpdateCommand = UpdateCommand()
        da.DeleteCommand = DeleteCommand()
        da.InsertCommand = InsertCommand()

        If Not IsNothing(DBTransaction) Then
            da.UpdateCommand.Transaction = DBTransaction
            da.DeleteCommand.Transaction = DBTransaction
            da.InsertCommand.Transaction = DBTransaction
        End If

        Return da

    End Function

    'Return update SQL command for data adapter
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

    'Return insert SQL command for data adapter
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

    'Return delete SQL command for data adapter
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
    Protected Overridable Function SelectCommand(ByRef drCriteria As DataRow) As SqlClient.SqlCommand
        Dim oCmd As New SqlClient.SqlCommand()

        oCmd.Connection = Me._oConn
        oCmd.CommandType = CommandType.Text
        oCmd.CommandText = Me.BuildSelectSQL(drCriteria)

        If Not IsNothing(DBTransaction) Then oCmd.Transaction = DBTransaction

        Return oCmd

    End Function

#End Region

#Region "FillMain functions"

    'Fills main table in dataset
    Protected Overridable Sub _FillMain(ByRef drCriteria As DataRow)
        Dim da As New SqlClient.SqlDataAdapter()

        'check for read rights
        If Me.CanRead Then            
            da.SelectCommand = SelectCommand(drCriteria)
            'drCriteria(3) = "C0B137FE2D792459F26FF763CCE44574A5B5AB03"
            'da.SelectCommand.CommandText = "SELECT * FROM Users WHERE Username LIKE 'tpiccoli' AND Password = 'C0B137FE2D792459F26FF763CCE44574A5B5AB03'"


            '_ds.Tables(_sTableName).Clear()
            'da.Fill(_ds, _sTableName)
            _dtMainTable.Clear()
            da.Fill(_dtMainTable)
        Else
            Throw New dbEntitySecurityException("User does not have read rights")

        End If

    End Sub

    'public method to fill main table
    Public Overridable Sub FillMain(ByRef drCriteria As DataRow)
        _FillMain(drCriteria)

    End Sub

    'fill main table filter by id column
    Public Overridable Sub FillMain(ByVal iEntityID As Integer)
        Dim drCriteria As DataRow = Me.NewSearchRow

        SetIdentityFilter(iEntityID, drCriteria)
        _FillMain(drCriteria)
        drCriteria = Nothing

    End Sub

    'public method to fill main table
    Public Overridable Sub FillMain()
        Dim drCriteria As DataRow = Me.NewSearchRow

        _FillMain(drCriteria)
        drCriteria = Nothing

    End Sub

    'Performs search and fill external dataset
    <Obsolete("Set MainDataTable instead")> _
    Public Overridable Sub FillMain(ByVal drCriteria As DataRow, ByRef ds As DataSet, ByVal sTableName As String)
        'check for read rights
        If Me.CanRead Then
            Dim sSQL As String = Me.BuildSelectSQL(drCriteria)
            DataHandler.GetDS(Me._oConn, ds, sSQL, sTableName)

        Else
            Throw New dbEntitySecurityException("User does not have read rights")

        End If

    End Sub

    'Performs search and fill external datatable
    <Obsolete("Set MainDataTable instead")> _
    Public Overridable Sub FillMain(ByVal drCriteria As DataRow, ByRef dt As DataTable)
        'check for read rights
        If Me.CanRead Then
            Dim sSQL As String = Me.BuildSelectSQL(drCriteria)
            DataHandler.GetDataTable(Me._oConn, dt, sSQL)

        Else
            Throw New dbEntitySecurityException("User does not have read rights")

        End If

    End Sub
#End Region

#Region "FillLookup functions"

    'Fills dataset with lookup tables
    Protected MustOverride Sub _FillLookups(ByRef drCriteria As DataRow)
    '   Call custom functions to fill each look up table, can be empty
    '
    'End Sub

    'public method to fill lookup tables
    Public Sub FillLookups(ByRef drCriteria As DataRow)
        Dim bEnforceConstraints As Boolean = _ds.EnforceConstraints

        _ds.EnforceConstraints = False
        Me.BeginLoadData()
        _FillLookups(drCriteria)
        Me.EndLoadData()
        _ds.EnforceConstraints = bEnforceConstraints

    End Sub
#End Region

#Region "GetDataReader functions"

    'Returns datareader for main table
    Public Overridable Function GetDataReader(ByRef drCriteria As DataRow, ByVal sSortBy As String) As SqlClient.SqlDataReader
        Return GetDataReader(_oConn, drCriteria, sSortBy)

    End Function

    Public Overridable Function GetDataReader(ByVal sConnection As String, ByRef drCriteria As DataRow, ByVal sSortBy As String) As SqlClient.SqlDataReader
        Dim oConn As New SqlClient.SqlConnection(sConnection)

        Return GetDataReader(oConn, drCriteria, sSortBy)

    End Function

    Public Overridable Function GetDataReader(ByRef oConn As SqlClient.SqlConnection, ByRef drCriteria As DataRow, ByVal sSortBy As String) As SqlClient.SqlDataReader
        'check read rights
        If Me.CanRead Then
            Dim sSQL As String = Me.BuildSelectSQL(drCriteria)
            If sSortBy.Length > 0 Then sSQL &= String.Format(" ORDER BY {0}", sSortBy)
            'TP EntLib update.
            Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, sSQL), SqlClient.SqlDataReader)
            'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, sSQL)

        Else
            Throw New dbEntitySecurityException("User does not have read rights")

        End If

    End Function

    Public Overridable Function GetDataReader(Optional ByVal sSortBy As String = "") As SqlClient.SqlDataReader
        Dim drCriteria As DataRow = Me.NewSearchRow
        Return GetDataReader(drCriteria, sSortBy)

    End Function

    Public Overridable Function GetDataReaderNoTimeout(ByRef drCriteria As DataRow, ByVal sSortBy As String) As SqlClient.SqlDataReader
        Return GetDataReaderNoTimeout(_oConn, drCriteria, sSortBy)

    End Function

    Public Overridable Function GetDataReaderNoTimeout(ByVal sConnection As String, ByRef drCriteria As DataRow, ByVal sSortBy As String) As SqlClient.SqlDataReader
        Dim oConn As New SqlClient.SqlConnection(sConnection)

        Return GetDataReaderNoTimeout(oConn, drCriteria, sSortBy)

    End Function

    Public Overridable Function GetDataReaderNoTimeout(ByRef oConn As SqlClient.SqlConnection, ByRef drCriteria As DataRow, ByVal sSortBy As String) As SqlClient.SqlDataReader
        'check read rights
        If Me.CanRead Then
            Dim sSQL As String = Me.BuildSelectSQL(drCriteria)
            If sSortBy.Length > 0 Then sSQL &= String.Format(" ORDER BY {0}", sSortBy)
            Return SqlHelperNoTimeout.ExecuteReader(oConn, CommandType.Text, sSQL)

        Else
            Throw New dbEntitySecurityException("User does not have read rights")

        End If

    End Function

    'TP20091102
    Public Function GetDataTable(ByVal oConn As String, ByRef drCriteria As DataRow, Optional ByVal sSortBy As String = "") As DataTable
        Dim sSQL As String = Me.BuildSelectSQL(drCriteria)
        If sSortBy.Length > 0 Then sSQL &= String.Format(" ORDER BY {0}", sSortBy)
        Dim da As New SqlClient.SqlDataAdapter(sSQL, oConn)
        Dim ds As New DataSet
        da.Fill(ds)
        Return ds.Tables(0)
    End Function
    'ENDTP20091102
    Public Overridable Function GetDataReaderNoTimeout(Optional ByVal sSortBy As String = "") As SqlClient.SqlDataReader
        Dim drCriteria As DataRow = Me.NewSearchRow
        Return GetDataReaderNoTimeout(drCriteria, sSortBy)

    End Function

#End Region

#Region "Validation functions"
    'Verifies inserts into main table
    Protected Overridable Function VerifyInsert(ByVal dr As DataRow) As Boolean
        'add error message to _sErrorMsg if invalid
        Return True

    End Function

    'Verifies updates made to main table
    Protected Overridable Function VerifyUpdate(ByVal dr As DataRow) As Boolean
        'add error message to _sErrorMsg if invalid
        Return True

    End Function

    'Verifies deletes to main table
    Protected Overridable Function VerifyDelete(ByRef dr As DataRow) As Boolean
        'add error message to _sErrorMsg if invalid
        Return True

    End Function

    'Verifies all inserts into main table
    Protected Function VerifyTableInsert(ByVal dt As DataTable) As Boolean
        Dim rs As DataViewRowState
        Dim drv As DataRowView
        Dim bVerify As Boolean = True

        'save row state filter and set row state to added rows
        rs = _dtMainTable.DefaultView.RowStateFilter
        _dtMainTable.DefaultView.RowStateFilter = DataViewRowState.Added

        If _dtMainTable.DefaultView.Count > 0 Then
            'check for create rights
            If Me.CanCreate Then
                'loop thru added rows and verify
                For Each drv In _dtMainTable.DefaultView
                    If Not VerifyInsert(drv.Row) Then
                        bVerify = False
                    End If

                Next

            Else
                Throw New dbEntitySecurityException("User does not have create rights")

            End If

        End If

        'restore previous row state filter
        _dtMainTable.DefaultView.RowStateFilter = rs

        Return bVerify

    End Function

    'Verifies all updates made to main table
    Protected Function VerifyTableUpdate(ByVal dt As DataTable) As Boolean
        Dim rs As DataViewRowState
        Dim drv As DataRowView
        Dim bVerify As Boolean = True

        'save row state filter and set row state to modified rows
        rs = _dtMainTable.DefaultView.RowStateFilter
        _dtMainTable.DefaultView.RowStateFilter = DataViewRowState.ModifiedOriginal

        If _dtMainTable.DefaultView.Count > 0 Then
            'check for edit rights
            If Me.CanEdit Then
                'loop thru modified rows and verify
                For Each drv In _dtMainTable.DefaultView
                    If Not VerifyUpdate(drv.Row) Then
                        bVerify = False
                    End If

                Next

            Else
                Throw New dbEntitySecurityException("User does not have edit rights")

            End If
        End If

        'restore previous row state filter
        _dtMainTable.DefaultView.RowStateFilter = rs

        Return bVerify

    End Function

    'Verifies all deletes to main table
    Protected Function VerifyTableDelete(ByVal dt As DataTable) As Boolean
        Dim rs As DataViewRowState
        Dim drv As DataRowView
        Dim bVerify As Boolean = True
        Dim dr As DataRow

        'save row state filter and set row state to deleted rows
        rs = _dtMainTable.DefaultView.RowStateFilter
        _dtMainTable.DefaultView.RowStateFilter = DataViewRowState.Deleted

        If _dtMainTable.DefaultView.Count > 0 Then
            'check for edit rights
            If Me.CanDelete Then
                'loop thru deleted rows and verify
                For Each drv In _dtMainTable.DefaultView
                    dr = drv.Row
                    If Not VerifyDelete(dr) Then
                        dr.RejectChanges()
                        bVerify = False
                    End If

                Next

            Else
                Throw New dbEntitySecurityException("User does not have delete rights")

            End If
        End If

        'restore previous row state filter
        _dtMainTable.DefaultView.RowStateFilter = rs

        Return bVerify

    End Function

    'verifies all updates, inserts, and deletes in the table
    'called when save occurs
    Private Function VerifyTable(ByVal dt As DataTable) As Boolean

        If VerifyTableUpdate(dt) Then
            If VerifyTableInsert(dt) Then
                If VerifyTableDelete(dt) Then
                    Return True

                End If
            End If
        End If

        Return False

    End Function

#End Region

#Region "Data Access functions"
    'Generates where SQL to query main table
    Protected MustOverride Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
    '   Check drCriteria settings to build WHERE clause and then return SELECT WHERE sql statement
    '
    'End Function

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
                MainDataTable = _ds.Tables(_dtMainTable.TableName)
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
    Public Overridable Function AddMainRow() As DataRow
        Dim dr As DataRow = _dtMainTable.NewRow
        SetNewRowDefaults(dr)
        Me.AddMainRow(dr)

        'Show only new row in datatable
        '_dtMainTable.DefaultView.RowStateFilter = DataViewRowState.Added

        Return dr


    End Function

    'create and insert new row into main table
    Public Overridable Sub AddMainRow(ByVal dr As DataRow)
        'check for create rights
        If Me.CanCreate Then
            _dtMainTable.Rows.Add(dr)

        Else
            Throw New dbEntitySecurityException("User does not have create rights")

        End If

    End Sub

    Protected Overridable Sub SetNewRowDefaults(ByRef dr As DataRow)
        'set default values for new row to be added to datatable
        'used primarily for datagrid editing

    End Sub

    'returns new data row from main table
    Public Overridable Function NewMainRow() As DataRow
        Return _dtMainTable.NewRow

    End Function

    'returns search datarow
    Public Overridable Function NewSearchRow() As DataRow
        Return Me._ds.Tables("Search").NewRow

    End Function

    'clears datarows from main table
    Public Sub ClearMainTable()
        _dtMainTable.Clear()

    End Sub

    'Saves dataset to database
    Public Overridable Sub Save()
        Save(_dtMainTable)

    End Sub

    'Saves datatable to database
    Public Overridable Sub Save(ByRef dt As DataTable)
        Dim da As SqlClient.SqlDataAdapter
        Dim bEnforceConstraints As Boolean

        If VerifyTable(dt) Then
            'init data adapter
            da = InitDataAdapter()

            'commit to database
            If Me._oConn.State = ConnectionState.Closed Then Me._oConn.Open()
            bEnforceConstraints = dt.DataSet.EnforceConstraints
            dt.DataSet.EnforceConstraints = False
            da.Update(dt)
            dt.DataSet.EnforceConstraints = bEnforceConstraints

            'reset dataset view, in some cases view is filled on new rows
            dt.DefaultView.RowStateFilter = DataViewRowState.CurrentRows

        End If

    End Sub

    'deletes rows from main table
    Public Overridable Function Delete(ByVal sRowFilter As String) As Boolean
        Dim drs As DataRow()
        Dim dr As DataRow

        'check for delete rights
        If Me.CanDelete Then
            drs = _dtMainTable.Select(sRowFilter)

            If drs.Length > 0 Then

                For Each dr In drs
                    dr.Delete()

                Next

            Else
                Me._sErrorMsg = "No Rows Available For Delete"
                Return False

            End If

            Return True

        Else
            Throw New dbEntitySecurityException("User does not have delete rights")

        End If

    End Function

    'removes new rows added to main table
    Public Sub ClearCancelledNewRow()
        Dim drv As DataRowView
        Dim dv As DataView

        dv = _dtMainTable.DefaultView
        dv.RowStateFilter = DataViewRowState.Added

        For Each drv In dv
            drv.Delete()

        Next

        dv.RowStateFilter = DataViewRowState.CurrentRows

        Me.Save()

    End Sub

    'returns datarow from main table
    Public Function SelectRow(ByVal sRowFilter As String) As DataRow
        Dim drs As DataRow()

        drs = _dtMainTable.Select(sRowFilter)

        If drs.Length > 0 Then
            Return drs(0)

        Else
            Return Nothing

        End If

    End Function

    Public Function SelectRow(ByVal ID As Integer) As DataRow
        Dim drs As DataRow()

        drs = _dtMainTable.Select(String.Format(Me._sDeleteFilter, ID))

        If drs.Length > 0 Then
            Return drs(0)

        Else
            Return Nothing

        End If

    End Function

    'returns reference to main table
    Public Property MainDataTable() As DataTable
        Get
            Return _dtMainTable

        End Get
        Set(ByVal Value As DataTable)
            _dtMainTable = Value

        End Set
    End Property

    'set enforce constraints property of dataset
    Public Property EnforceConstraints() As Boolean
        Get
            Return _ds.EnforceConstraints

        End Get
        Set(ByVal Value As Boolean)
            _ds.EnforceConstraints = Value

        End Set
    End Property

    'converts search row into xml to save search settings
    Public Function SaveSearch(ByVal drCriteria As DataRow, ByVal sDataSetName As String) As String
        Dim ds As New DataSet        
        'Me._ds.Tables("Search").Clear()
        Me._ds.Tables("Search").Rows.Add(drCriteria)
        ds.Tables.Add(Me._ds.Tables("Search").Copy)
        ds.Namespace = sDataSetName

        Return ds.GetXml

    End Function

    'restores saved xml search settings into search row
    Public Function RestoreSearch(ByVal sXML As String, ByVal sDataSetName As String) As DataRow
        Dim xmlDS As New Xml.XmlDocument
        Dim xmlNode As Xml.XmlNode
        Dim drCriteria As DataRow
        Dim sColName As String
        xmlDS.LoadXml(sXML)

        'get new search row
        drCriteria = Me.NewSearchRow
        'dataset has correct name
        If xmlDS.FirstChild.Attributes("xmlns").Value = sDataSetName Then
            'copy search values into search row
            For Each xmlNode In xmlDS.FirstChild.FirstChild.ChildNodes
                'chek if node exists in datarow
                sColName = xmlNode.Name
                If drCriteria.Table.Columns.Contains(sColName) Then
                    'copy node value into datarow
                    'drcriteria.item(sColname).GetType
                    drCriteria.Item(sColName) = xmlNode.InnerText

                End If

            Next
        End If

        xmlNode = Nothing
        xmlDS = Nothing

        Return drCriteria

    End Function

    Public Property DBTransaction() As SqlClient.SqlTransaction
        Get
            Return _oTransaction
        End Get
        Set(ByVal Value As SqlClient.SqlTransaction)
            _oTransaction = Value
        End Set
    End Property

    Public Property DBConnection() As SqlClient.SqlConnection
        Get
            Return _oConn
        End Get
        Set(ByVal Value As SqlClient.SqlConnection)
            _oConn = Value
        End Set
    End Property

#End Region

#Region "Security properties"
    'up to subclass to set the security variables
    'these will be used by validation functions

    'user can read records
    Public ReadOnly Property CanRead() As Boolean
        Get
            Return _bCanView

        End Get
    End Property

    'user can create new records
    Public ReadOnly Property CanCreate() As Boolean
        Get
            Return _bCanCreate

        End Get
    End Property

    'user can edit and update existing records
    Public ReadOnly Property CanEdit() As Boolean
        Get
            Return _bCanEdit

        End Get
    End Property

    'user can delete records
    Public ReadOnly Property CanDelete() As Boolean
        Get
            Return _bCanDelete

        End Get
    End Property

#End Region

#Region "Datagrid functions"
    'Datagrid helper functions to bind data table to datagrid

    'Binds table to datagrid
    Public Overridable Function DataGridBind(ByVal dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String) As Integer
        Return DMI.clsDataGridTools.DataGridBind(dg, Me.MainDataTable, sSortBy)

    End Function

    'Sorts column in datagrid
    Public Overridable Function DataGridSort(ByVal dg As System.Web.UI.WebControls.DataGrid, ByVal e As System.Web.UI.WebControls.DataGridSortCommandEventArgs, ByVal sSortBy As String) As String
        Return DMI.clsDataGridTools.DataGridSort(dg, Me.MainDataTable, e, sSortBy)

    End Function

    'Deletes rows from datagrid and commits deletes to database
    Public Overridable Function DataGridDelete(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String) As Integer
        If Not IsNothing(_sDeleteFilter) Then
            Return DMI.clsDataGridTools.DataGridDelete(dg, Me, _sDeleteFilter, sSortBy)

        End If

    End Function

    'Changes page index in datagrid
    Public Overridable Sub DataGridPageChange(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs, ByVal sSortBy As String)
        DMI.clsDataGridTools.DataGridPageChange(dg, Me.MainDataTable, e, sSortBy)

    End Sub

    'Set edit mode for row in datagrid
    Public Overridable Sub DataGridEditItem(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs, ByVal sSortBy As String)
        DMI.clsDataGridTools.DataGridEditItem(dg, Me.MainDataTable, e, sSortBy)

    End Sub

    'Adds row to datagrid and set new row in edit mode
    Public Overridable Sub DataGridNewItem(ByRef dg As System.Web.UI.WebControls.DataGrid, ByRef dr As DataRow, ByVal sSortBy As String)
        'Set sSortBy value to ensure new row in last row in datagrid
        DMI.clsDataGridTools.DataGridNewItem(dg, Me, dr, sSortBy)

    End Sub

    'Adds new row to datagrid and set new row in edit mode
    Public Overridable Sub DataGridNewItem(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String)
        'Set sSortBy value to ensure new row in last row in datagrid
        DMI.clsDataGridTools.DataGridNewItem(dg, Me, sSortBy)

    End Sub

    'turns off edit mode in datagrid
    Public Overridable Sub DataGridCancel(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String)
        DMI.clsDataGridTools.DataGridCancel(dg, Me, sSortBy)

    End Sub

#End Region

End Class

'Exception for security violations
Public Class dbEntitySecurityException : Inherits ApplicationException
    Public Sub New(ByVal message As String)
        MyBase.New(message)

    End Sub

End Class

'Exception for validation violations
Public Class dbEntityValidationException : Inherits ApplicationException
    Public Sub New(ByVal message As String)
        MyBase.New(message)

    End Sub

End Class

'class used to process a single row in datatable or datareader
Public MustInherit Class clsRowProcessor
    Protected _sErrMsg As String = ""
    Protected _Connection As SqlClient.SqlConnection
    Public Sub Init(ByVal sqlConnection As SqlClient.SqlConnection)
        _Connection = sqlConnection
        _Init()
    End Sub
    Protected Overridable Sub _Init()
        'fill in initialization code
    End Sub
    Public MustOverride Function Process(ByVal Row As DataRow) As Boolean
    Public MustOverride Function Process(ByVal Row As SqlClient.SqlDataReader) As Boolean
    Public ReadOnly Property ErrorMessage() As String
        Get
            Return _sErrMsg
        End Get

    End Property
    Public Overridable Sub Close()
        'fill in with clean up code
    End Sub

End Class

'helper class to process rows in a datareader via thread
Public Class clsRowProcessorThread
    Protected _Connection As SqlClient.SqlConnection
    Protected _DataReader As SqlClient.SqlDataReader
    Protected _RowProcessor As clsRowProcessor
    Protected _dt As DataTable

    'kicks off threaded process
    Public Sub Start(ByVal Connection As String, ByVal sqlDataReader As SqlClient.SqlDataReader, ByVal RowProcessor As clsRowProcessor)
        Dim oThd As Threading.Thread
        _Connection = New SqlClient.SqlConnection(Connection)
        _DataReader = sqlDataReader
        _RowProcessor = RowProcessor

        oThd = New Threading.Thread(AddressOf Processor)
        oThd.Priority = Threading.ThreadPriority.Lowest
        oThd.Start()
        'Processor()

    End Sub
    'TP20091102
    Public Sub start(ByVal Connection As String, ByVal dt As DataTable, ByVal RowProcessor As clsRowProcessor)
        Dim oThd As Threading.Thread
        _dt = dt
        _Connection = New SqlClient.SqlConnection(Connection)
        _RowProcessor = RowProcessor
        oThd = New Threading.Thread(AddressOf DTProcessor)
        oThd.Priority = Threading.ThreadPriority.Lowest
        oThd.Start()
    End Sub
    Protected Sub DTProcessor()
        _RowProcessor.Init(_Connection)
        For Each r As DataRow In _dt.Rows
            If Not _RowProcessor.Process(r) Then
                Exit For
            End If
        Next
        _RowProcessor.Close()
        _RowProcessor = Nothing
        If _Connection.State = ConnectionState.Open Then _Connection.Close()
        _Connection.Dispose()
        _Connection = Nothing
    End Sub
    'TP20091102
    'threaded method that processes each row in datareader
    Protected Overridable Sub Processor()
        _Connection.Open()
        _RowProcessor.Init(_Connection)
        Do While _DataReader.Read
            If Not _RowProcessor.Process(_DataReader) Then
                Exit Do

            End If
        Loop
        _RowProcessor.Close()
        _RowProcessor = Nothing
        _DataReader.Close()
        _DataReader = Nothing
        If _Connection.State = ConnectionState.Open Then _Connection.Close()
        _Connection.Dispose()
        _Connection = Nothing

    End Sub

End Class

Public MustInherit Class clsProtoDataObject
    Protected _Connection As SqlClient.SqlConnection
    Protected _ErrorMsg As String

    Public Sub New(ByVal Connection As SqlClient.SqlConnection)
        _Connection = Connection

    End Sub

    Public ReadOnly Property ErrorMsg() As String
        Get
            Return _ErrorMsg

        End Get
    End Property

End Class