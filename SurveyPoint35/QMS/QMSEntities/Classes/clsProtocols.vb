Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsProtocols
    Inherits DMI.clsDBEntity2

    Private _iUserID As Integer = 0
    Private _oProtocolSteps As clsProtocolSteps
    Private _oProtocolStepParams As clsProtocolStepParameters

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups
        FillUsers()

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsProtocols.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsProtocols.SearchRow)

        'Primary key criteria
        If Not dr.IsProtocolIDNull Then sbSQL.AppendFormat("ProtocolID = {0} AND ", dr.ProtocolID)
        'username criteria
        If Not dr.IsKeywordNull Then sbSQL.AppendFormat("Name + Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))
        'active status criteria
        If Not dr.IsUserIDNull Then sbSQL.AppendFormat("CreatedByUserID = {0} AND ", dr.UserID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Protocols ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Protocols", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolID", SqlDbType.Int, 4, "ProtocolID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsProtocols
        _dtMainTable = _ds.Tables("Protocols")
        _sDeleteFilter = "ProtocolID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Protocols", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolID", SqlDbType.Int, 4, "ProtocolID"))
        oCmd.Parameters("@ProtocolID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 50, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 250, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CreatedByUserID", SqlDbType.Int, 4, "CreatedByUserID"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ProtocolID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Protocols", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolID", SqlDbType.Int, 4, "ProtocolID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 50, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 250, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CreatedByUserID", SqlDbType.Int, 4, "CreatedByUserID"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("CreatedByUserID") = Me._iUserID

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(SurveyInstanceID) FROM SurveyInstances WHERE ProtocolID = {0}", dr.Item("ProtocolID", DataRowVersion.Original))

        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete Protocol ID {0} {1}. Protocol has survey instances.\n", dr.Item("ProtocolID", DataRowVersion.Original), dr.Item("Name", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

    Public Overrides Sub Close()
        If Not _oProtocolSteps Is Nothing Then _oProtocolSteps.Close()
        If Not _oProtocolStepParams Is Nothing Then _oProtocolStepParams.Close()
        MyBase.Close()

    End Sub

#End Region

    Public Property AuthorUserID() As Integer
        Get
            Return _iUserID

        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value

        End Set
    End Property

    Public Property ProtocolSteps() As clsProtocolSteps
        Get
            If _oProtocolSteps Is Nothing Then
                _oProtocolSteps = New clsProtocolSteps(_oConn)
                _oProtocolSteps.MainDataTable = Me.ProtocolStepsTable
                _oProtocolSteps.ProtocolStepParameters = Me.ProtocolStepParameters

            End If

            Return _oProtocolSteps

        End Get
        Set(ByVal Value As clsProtocolSteps)
            _oProtocolSteps = Value

        End Set
    End Property

    Public Property ProtocolStepParameters() As clsProtocolStepParameters
        Get
            If _oProtocolStepParams Is Nothing Then
                _oProtocolStepParams = New clsProtocolStepParameters(_oConn)
                _oProtocolStepParams.MainDataTable = Me.ProtocolStepParametersTable

            End If

            Return _oProtocolStepParams

        End Get
        Set(ByVal Value As clsProtocolStepParameters)
            _oProtocolStepParams = Value

        End Set
    End Property

    Public Shared Function SurveyInstanceProtocolID(ByVal oConn As SqlClient.SqlConnection, ByVal iSurveyInstanceID As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, _
            String.Format("SELECT ProtocolID FROM SurveyInstances WHERE SurveyInstanceID = {0}", iSurveyInstanceID)))

    End Function

#Region "User Lookup"
    Public Sub FillUsers()
        Dim dr As dsUsers.SearchRow
        Dim oU As New clsUsers(Me._oConn)

        dr = CType(oU.NewSearchRow, dsUsers.SearchRow)

        oU.MainDataTable = Me.UsersTable
        oU.FillMain(dr)

        oU.Close()
        oU = Nothing
        dr = Nothing

    End Sub

    Public Function UsersTable()
        Return Me._ds.Tables("Users")

    End Function

#End Region

#Region "Protocol Steps Lookup"
    Public Sub FillProtocolSteps(ByVal drCriteria As DataRow)
        Dim dr1 As dsProtocols.SearchRow
        Dim dr2 As dsProtocolSteps.SearchRow

        dr1 = CType(drCriteria, dsProtocols.SearchRow)
        dr2 = CType(ProtocolSteps.NewSearchRow, dsProtocolSteps.SearchRow)

        If Not dr1.IsProtocolIDNull Then dr2.ProtocolID = dr1.ProtocolID
        ProtocolSteps.FillMain(dr2)

        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public ReadOnly Property ProtocolStepsTable() As DataTable
        Get
            Return _ds.Tables("ProtocolSteps")

        End Get
    End Property

    Public ReadOnly Property ProtocolStepTypesTable() As DataTable
        Get
            Return _ds.Tables("ProtocolStepTypes")

        End Get
    End Property

#End Region

#Region "Protocol Step Parameters Lookup"
    Public Sub FillProtocolStepParameters(ByVal drCriteria As DataRow)
        Dim dr1 As dsProtocols.SearchRow
        Dim dr2 As dsProtocolStepParameters.SearchRow

        dr1 = CType(drCriteria, dsProtocols.SearchRow)
        dr2 = CType(ProtocolStepParameters.NewSearchRow, dsProtocolStepParameters.SearchRow)

        If Not dr1.IsProtocolIDNull Then dr2.ProtocolID = dr1.ProtocolID
        ProtocolStepParameters.FillMain(dr2)

        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public ReadOnly Property ProtocolStepParametersTable() As DataTable
        Get
            Return _ds.Tables("ProtocolStepParameters")

        End Get
    End Property

    Public ReadOnly Property ProtocolStepParameterTypesTable() As DataTable
        Get
            Return _ds.Tables("ProtocolStepTypeParameters")

        End Get
    End Property

#End Region

#Region "Protocol List Datareader"

    Public Shared Function GetProtocolList(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, "SELECT ProtocolID, Name FROM Protocols ORDER BY Name")

    End Function
#End Region

#Region "protocol info functions"
    Public Shared Function ProtocolStepCallAttempts(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolStepID As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.StoredProcedure, "get_CurrentCallAttempts", _
            New SqlClient.SqlParameter("@ProtocolStepID", iProtocolStepID)))

    End Function

    Public Shared Function ContainsProtocolStepType(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolID As Integer, ByVal iProtocolStepTypeID As Integer) As Boolean
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps ")
        sbSQL.AppendFormat("WHERE ProtocolID = {0} AND ProtocolStepTypeID = {1}", iProtocolID, iProtocolStepTypeID)

        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString)) > 0 Then Return True

        Return False

    End Function

    Public Shared Function ContainsBatching(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolID As Integer) As Boolean
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps WHERE ProtocolStepTypeID = 2 ")
        sbSQL.AppendFormat("AND ProtocolID = {0}", iProtocolID)

        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString)) > 0 Then Return True

        Return False

    End Function

    Public Shared Function ContainsDataEntry(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolID As Integer) As Boolean
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps WHERE ProtocolStepTypeID = 3 ")
        sbSQL.AppendFormat("AND ProtocolID = {0}", iProtocolID)

        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString)) > 0 Then Return True

        Return False

    End Function

    Public Shared Function ContainsVerification(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolID As Integer) As Boolean
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps WHERE ProtocolStepTypeID = 4 ")
        sbSQL.AppendFormat("AND ProtocolID = {0}", iProtocolID)

        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString)) > 0 Then Return True

        Return False

    End Function

    Public Shared Function ContainsCATI(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolID As Integer) As Boolean
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps WHERE ProtocolStepTypeID = 5 ")
        sbSQL.AppendFormat("AND ProtocolID = {0}", iProtocolID)

        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString)) > 0 Then Return True

        Return False

    End Function

    Public Shared Function ContainsReminderCalls(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolID As Integer) As Boolean
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps WHERE ProtocolStepTypeID = 6 ")
        sbSQL.AppendFormat("AND ProtocolID = {0}", iProtocolID)

        If CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString)) > 0 Then Return True

        Return False

    End Function

    Public Shared Function MaxCallAttempts(ByVal oConn As SqlClient.SqlConnection, ByVal iProtocolID As Integer) As Integer
        Dim sbSQL As New Text.StringBuilder

        'sbSQL.Append("SELECT COUNT(ProtocolStepID) FROM ProtocolSteps WHERE ProtocolStepTypeID IN (5,6) ")
        'sbSQL.AppendFormat("AND ProtocolID = {0}", iProtocolID)
        sbSQL.Append("SELECT MAX(CAST(ProtocolStepParamValue AS int)) + 1 FROM ProtocolStepParameters ")
        sbSQL.AppendFormat("WHERE ProtocolStepID IN (SELECT ProtocolStepID FROM ProtocolSteps WHERE ProtocolStepTypeID IN (5, 6) AND ProtocolID = {0}) ", iProtocolID)
        sbSQL.Append("AND ProtocolStepTypeParamID IN (8, 10)")

        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString))

    End Function

#End Region
End Class
