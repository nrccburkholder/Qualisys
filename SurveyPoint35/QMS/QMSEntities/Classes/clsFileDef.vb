Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsFileDefs
    Inherits DMI.clsDBEntity2

    Private _oFileDefColumns As clsFileDefColumns
    Private _iClientID As Integer
    Private _iSurveyID As Integer
    Private _iFileDefTypeID As Integer
    Private _iFileTypeID As Integer

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef sConn As String)
        MyBase.New(sConn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        FillFileDefTypes()
        FillFileTypes()
        FillSurveys(drCriteria)
        FillClients(drCriteria)
        FillFileDefColumns(drCriteria)

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As QMS.dsFileDefs.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsFileDefs.SearchRow)

        'Primary key criteria
        If Not dr.IsFileDefIDNull Then sbSQL.AppendFormat("FileDefID = {0} AND ", dr.FileDefID)
        'client criteria
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'survey criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'file def type criteria
        If Not dr.IsFileDefTypeIDNull Then sbSQL.AppendFormat("FileDefTypeID = {0} AND ", dr.FileDefTypeID)
        'file format type criteria
        If Not dr.IsFileTypeIDNull Then sbSQL.AppendFormat("FileTypeID = {0} AND ", dr.FileTypeID)
        'keyword criteria
        If Not dr.IsKeywordNull Then sbSQL.AppendFormat("FileDefName + FileDefDescription LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM FileDefs ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_FileDefs", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefID", SqlDbType.Int, 4, "FileDefID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsFileDefs
        _dtMainTable = _ds.Tables("FileDefs")
        _sDeleteFilter = "FileDefID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_FileDefs", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefID", SqlDbType.Int, 4, "FileDefID"))
        oCmd.Parameters("@FileDefID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefName", SqlDbType.VarChar, 200, "FileDefName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefDescription", SqlDbType.VarChar, 200, "FileDefDescription"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 4, "ClientID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefTypeID", SqlDbType.Int, 4, "FileDefTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileTypeID", SqlDbType.Int, 4, "FileTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefDelimiter", SqlDbType.Char, 1, "FileDefDelimiter"))
        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("FileDefID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_FileDefs", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefID", SqlDbType.Int, 4, "FileDefID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefName", SqlDbType.VarChar, 200, "FileDefName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefDescription", SqlDbType.VarChar, 200, "FileDefDescription"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 4, "ClientID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefTypeID", SqlDbType.Int, 4, "FileDefTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileTypeID", SqlDbType.Int, 4, "FileTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefDelimiter", SqlDbType.Char, 1, "FileDefDelimiter"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("FileDefName") = ""
        dr.Item("FileDefDescription") = ""
        'dr.Item("ClientID") = Me.ClientsTable.Rows(0).Item("ClientID")
        'dr.Item("SurveyID") = Me.SurveysTable.Rows(0).Item("SurveyID")
        dr.Item("FileDefTypeID") = Me.FileDefTypesTable.Rows(0).Item("FileDefTypeID")
        dr.Item("FileTypeID") = Me.FileTypesTable.Rows(0).Item("FileTypeID")

    End Sub

    Public Overrides Sub Close()
        If Not _oFileDefColumns Is Nothing Then _oFileDefColumns.Close()
        MyBase.Close()

    End Sub

#End Region

#Region "File Def Columns Lookup"
    Public ReadOnly Property FileDefColumnsTable() As DataTable
        Get
            Return _ds.Tables("FileDefColumns")

        End Get
    End Property

    Public Sub FillFileDefColumns(ByVal drCriteria As DataRow)
        Dim dr1 As dsFileDefs.SearchRow
        Dim dr2 As dsFileDefColumns.SearchRow

        dr1 = CType(drCriteria, dsFileDefs.SearchRow)
        dr2 = CType(FileDefColumns.NewSearchRow, dsFileDefColumns.SearchRow)

        If Not dr1.IsFileDefIDNull Then dr2.FileDefID = dr1.FileDefID
        If Not dr1.IsClientIDNull Then dr2.ClientID = dr1.ClientID
        If Not dr1.IsSurveyIDNull Then dr2.SurveyID = dr1.SurveyID
        If Not dr1.IsFileDefTypeIDNull Then dr2.FileDefTypeID = dr1.FileDefTypeID
        If Not dr1.IsFileTypeIDNull Then dr2.FileTypeID = dr1.FileTypeID

        FileDefColumns.FillMain(dr2)

        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Property FileDefColumns() As clsFileDefColumns
        Get
            If _oFileDefColumns Is Nothing Then
                _oFileDefColumns = New clsFileDefColumns(_oConn)
                _oFileDefColumns.MainDataTable = Me.FileDefColumnsTable

            End If

            Return _oFileDefColumns

        End Get
        Set(ByVal Value As clsFileDefColumns)
            _oFileDefColumns = Value

        End Set
    End Property

#End Region

#Region "Client Lookup"
    Public ReadOnly Property ClientsTable() As DataTable
        Get
            Return _ds.Tables("Clients")

        End Get
    End Property

    Public Sub FillClients(ByVal drCriteria As DataRow)
        Dim dr1 As dsFileDefs.SearchRow
        Dim dr2 As dsClients.SearchRow
        Dim oC As New clsClients(Me._oConn)

        dr1 = CType(drCriteria, dsFileDefs.SearchRow)
        dr2 = CType(oC.NewSearchRow, dsClients.SearchRow)


        If Not dr1.IsClientIDNull Then dr2.ClientID = dr1.ClientID

        oC.MainDataTable = Me._ds.Tables("Clients")
        oC.FillMain(dr2)

        dr1 = Nothing
        dr2 = Nothing
        oC.Close()
        oC = Nothing

    End Sub

#End Region

#Region "Survey Lookup"
    Public ReadOnly Property SurveysTable() As DataTable
        Get
            Return _ds.Tables("Surveys")

        End Get
    End Property

    Public Sub FillSurveys(ByVal drCriteria As DataRow)
        Dim dr1 As dsFileDefs.SearchRow
        Dim dr2 As dsSurveys.SearchRow
        Dim oS As New clsSurveys(Me._oConn)

        dr1 = CType(drCriteria, dsFileDefs.SearchRow)
        dr2 = CType(oS.NewSearchRow, dsSurveys.SearchRow)

        If Not dr1.IsSurveyIDNull Then dr2.SurveyID = dr1.SurveyID

        oS.MainDataTable = Me._ds.Tables("Surveys")
        oS.FillMain(dr2)

        dr1 = Nothing
        dr2 = Nothing
        oS.Close()
        oS = Nothing

    End Sub

#End Region

#Region "File Def Type Lookup"
    Public ReadOnly Property FileDefTypesTable() As DataTable
        Get
            Return _ds.Tables("FileDefTypes")

        End Get
    End Property

    Public Sub FillFileDefTypes()
        Dim da As New SqlClient.SqlDataAdapter("SELECT * FROM FileDefTypes", _oConn)

        da.Fill(FileDefTypesTable)
        da.Dispose()
        da = Nothing

    End Sub

    Public Shared Function GetFileDefTypeList(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, "SELECT FileDefTypeID, FileDefTypeName FROM FileDefTypes ORDER BY FileDefTypeName"), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
        '    "SELECT FileDefTypeID, FileDefTypeName FROM FileDefTypes ORDER BY FileDefTypeName")

    End Function

    Public Shared Function GetFileTypeID(ByVal oConn As SqlClient.SqlConnection, ByVal iFileDefID As Integer) As Integer
        'TP Change
        Return SqlHelper.Db(oConn.ConnectionString).ExecuteScalar(CommandType.Text, String.Format("SELECT FileTypeID FROM FileDefs WHERE FileDefID = {0}", iFileDefID))
        'Return SqlHelper.ExecuteScalar(oConn, CommandType.Text, _
        '    String.Format("SELECT FileTypeID FROM FileDefs WHERE FileDefID = {0}", iFileDefID))

    End Function

#End Region

#Region "File Type Lookup"
    Public ReadOnly Property FileTypesTable() As DataTable
        Get
            Return _ds.Tables("FileTypes")

        End Get
    End Property

    Public Sub FillFileTypes()
        Dim da As New SqlClient.SqlDataAdapter("SELECT * FROM FileTypes", _oConn)

        da.Fill(FileTypesTable)
        da.Dispose()
        da = Nothing

    End Sub

    Public Shared Function GetFileTypeList(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, "SELECT FileTypeID, FileTypeName FROM FileTypes ORDER BY FileTypeName"), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
        '   "SELECT FileTypeID, FileTypeName FROM FileTypes ORDER BY FileTypeName")

    End Function

#End Region

    Public Shared Function Copy(ByRef oConn As SqlClient.SqlConnection, ByVal iFileDefID As Integer) As Integer
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(oConn.ConnectionString).GetStoredProcCommand("copy_FileDef", iFileDefID)
        Return CInt(SqlHelper.Db(oConn.ConnectionString).ExecuteScalar(cmd))
        'Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.StoredProcedure, _
        '    "copy_FileDef", New SqlClient.SqlParameter("@FileDefID", iFileDefID)))

    End Function

    Public Shared Function GetFileDefFilterDataSource(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, "SELECT FileDefFilterID, FilterName FROM FileDefFilters ORDER BY FilterName"), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
        '    "SELECT FileDefFilterID, FilterName FROM FileDefFilters ORDER BY FilterName")

    End Function

    Public Shared Function GetFileDefFilter(ByVal oConn As SqlClient.SqlConnection, ByVal iFileDefFilterID As Integer) As String
        Dim sSQL As String = String.Format("SELECT FilterWhere FROM FileDefFilters WHERE FileDefFilterID = {0}", iFileDefFilterID)
        'TP Change
        sSQL = SqlHelper.Db(oConn.ConnectionString).ExecuteScalar(CommandType.Text, sSQL).ToString()
        'sSQL = SqlHelper.ExecuteScalar(oConn, CommandType.Text, sSQL).ToString

        Return sSQL

    End Function


End Class
