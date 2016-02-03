Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsSurveyInstances
    Inherits DMI.clsDBEntity2

    Protected _SurveyInstanceDefaultScripts As clsSurveyInstanceDefaultScripts

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByVal bFillLookUps As Boolean)
        MyBase.New(bFillLookUps)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsSurveyInstances.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsSurveyInstances.SearchRow)

        'Primary key criteria
        If Not dr.IsSurveyInstanceIDNull Then sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        'survey id criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'client id criteria
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'protocol id criteria
        If Not dr.IsProtocolIDNull Then sbSQL.AppendFormat("ProtocolID = {0} AND ", dr.ProtocolID)
        'name criteria
        If Not dr.IsNameNull Then sbSQL.AppendFormat("Name LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Name))
        'instance date range criteria
        If Not dr.IsBeginInstanceDateNull Then sbSQL.AppendFormat("InstanceDate >= '{0}' AND ", dr.BeginInstanceDate)
        If Not dr.IsEndInstanceDateNull Then sbSQL.AppendFormat("InstanceDate <= '{0}' AND ", dr.EndInstanceDate)
        'start date range id criteria
        If Not dr.IsBeginStartDateNull Then sbSQL.AppendFormat("StartDate >= '{0}' AND ", dr.BeginStartDate)
        If Not dr.IsEndStartDateNull Then sbSQL.AppendFormat("StartDate <= '{0}' AND ", dr.EndStartDate)
        'active criteria
        If Not dr.IsActiveNull Then sbSQL.AppendFormat("Active = {0} AND ", dr.Active)
        'household criteria
        If Not dr.IsGroupByHouseholdNull Then sbSQL.AppendFormat("GroupByHousehold = {0} AND ", dr.GroupByHousehold)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vr_SurveyInstances ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_SurveyInstances", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsSurveyInstances
        _dtMainTable = _ds.Tables("SurveyInstances")
        _sDeleteFilter = "SurveyInstanceID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_SurveyInstances", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters("@SurveyInstanceID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 4, "ClientID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolID", SqlDbType.Int, 4, "ProtocolID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@InstanceDate", SqlDbType.DateTime, 10, "InstanceDate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@StartDate", SqlDbType.DateTime, 10, "StartDate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupByHousehold", SqlDbType.TinyInt, 1, "GroupByHousehold"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceCategoryID", SqlDbType.Int, 4, "SurveyInstanceCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuarterEnding", SqlDbType.DateTime, 10, "QuarterEnding"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyName", SqlDbType.VarChar, 100, "SurveyName"))
        oCmd.Parameters("@SurveyName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientName", SqlDbType.VarChar, 100, "ClientName"))
        oCmd.Parameters("@ClientName").Direction = ParameterDirection.Output

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("SurveyInstanceID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_SurveyInstances", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 4, "ClientID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ProtocolID", SqlDbType.Int, 4, "ProtocolID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@InstanceDate", SqlDbType.DateTime, 10, "InstanceDate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@StartDate", SqlDbType.DateTime, 10, "StartDate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupByHousehold", SqlDbType.TinyInt, 1, "GroupByHousehold"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceCategoryID", SqlDbType.Int, 4, "SurveyInstanceCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuarterEnding", SqlDbType.DateTime, 10, "QuarterEnding"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyName", SqlDbType.VarChar, 100, "SurveyName"))
        oCmd.Parameters("@SurveyName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientName", SqlDbType.VarChar, 100, "ClientName"))
        oCmd.Parameters("@ClientName").Direction = ParameterDirection.Output

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("SurveyID") = 0
        dr.Item("ClientID") = 0
        dr.Item("ProtocolID") = 0
        dr.Item("Name") = ""
        dr.Item("InstanceDate") = Now()
        dr.Item("StartDate") = Now()
        dr.Item("Active") = 1
        dr.Item("GroupByHousehold") = 0

    End Sub
#End Region

    'Insert survey instance events for a survey instance
    Public Sub InitSurveyInstanceEvents()
        Dim sbSQL As New Text.StringBuilder

        If Me.MainDataTable.Rows.Count = 1 Then
            sbSQL.Append("INSERT INTO SurveyInstanceEvents (SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours) ")
            sbSQL.Append("SELECT SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours FROM v_SurveyInstanceEvents ")
            sbSQL.Append("WHERE SurveyInstanceID ={0} AND SurveyInstanceEventID = 0", Me.MainDataTable.Rows(0).Item("SurveyInstanceID"))

            SqlHelper.ExecuteNonQuery(Me._oConn, CommandType.Text, sbSQL.ToString)

        End If

        sbSQL = Nothing

    End Sub

    Public Shared Function Copy(ByVal iSurveyInstanceID) As Integer
        Dim sbSQL As New Text.StringBuilder
        Dim iNewSurveyInstanceID As Integer
        Dim oConn As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        oConn.Open()

        'copy survey instance record
        sbSQL.Append("INSERT INTO SurveyInstances (SurveyID, ClientID, ProtocolID, Name, InstanceDate, StartDate, Active, GroupByHousehold) ")
        sbSQL.Append("SELECT SurveyID, ClientID, ProtocolID, 'Copy of ' + Name, InstanceDate, GETDATE(), Active, GroupByHousehold FROM SurveyInstances ")
        sbSQL.AppendFormat("WHERE SurveyInstanceID = {0}; SELECT ISNULL(@@IDENTITY,0) ", iSurveyInstanceID)
        iNewSurveyInstanceID = CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, sbSQL.ToString))

        'copy survey instance event records
        sbSQL.Remove(0, sbSQL.Length)
        sbSQL.Append("INSERT INTO SurveyInstanceEvents (SurveyInstanceID, EventID, TranslationValue, Final, NonContactHours) ")
        sbSQL.AppendFormat("SELECT {0}, EventID, TranslationValue, Final, NonContactHours FROM SurveyInstanceEvents ", iNewSurveyInstanceID)
        sbSQL.AppendFormat("WHERE SurveyInstanceID = {0}; ", iSurveyInstanceID)

        'copy mailing seed records
        sbSQL.Append("INSERT INTO Respondents (SurveyInstanceID, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode) ")
        sbSQL.AppendFormat("SELECT {0}, FirstName, MiddleInitial, LastName, Address1, Address2, City, State, PostalCode FROM Respondents ", iNewSurveyInstanceID)
        sbSQL.AppendFormat("WHERE SurveyInstanceID = {0} AND MailingSeedFlag = 1", iSurveyInstanceID)

        SqlHelper.ExecuteNonQuery(oConn, CommandType.Text, sbSQL.ToString)

        oConn.Close()
        oConn.Dispose()
        oConn = Nothing

        Return iNewSurveyInstanceID

    End Function

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(RespondentID) FROM Respondents WHERE SurveyInstanceID = {0}", dr.Item("SurveyInstanceID", DataRowVersion.Original))

        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete survey instance ID {0}. Survey instance has respondents.\n", dr.Item("SurveyInstanceID", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

    Public Shared Function GetSurveyInstanceDataSource(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Dim sbSQL As New System.Text.StringBuilder

        'build select query
        sbSQL.Append("SELECT SurveyInstanceID, SurveyName + ': ' + ClientName + ': ' + SurveyInstanceName AS Name FROM v_SurveyInstances ")
        sbSQL.Append("WHERE Active = 1 ORDER BY SurveyName, ClientName, SurveyInstanceName")

        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, sbSQL.ToString)

    End Function

    Public Shared Function GetSurveyInstanceDataSource(ByVal oConn As SqlClient.SqlConnection, ByVal iSurveyID As Integer, ByVal iClientID As Integer) As SqlClient.SqlDataReader
        Dim sSQL As New System.Text.StringBuilder

        'build survey instance criteria
        sSQL.Append("SELECT SurveyInstanceID, SurveyName + ': ' + ClientName + ': ' + SurveyInstanceName AS Name FROM v_SurveyInstances ")
        sSQL.Append("WHERE Active = 1 ")
        If iSurveyID > 0 Then sSQL.AppendFormat("AND SurveyID = {0} ", iSurveyID)
        If iClientID > 0 Then sSQL.AppendFormat("AND ClientID = {0} ", iClientID)
        sSQL.Append("ORDER BY SurveyName, ClientName, SurveyInstanceName")

        Return SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL.ToString)

    End Function

    Public Shared Function GetSurveyID(ByVal oConn As SqlClient.SqlConnection, ByVal iSurveyInstanceID As Integer) As Integer
        Dim sql As String = String.Format("SELECT SurveyID FROM SurveyInstances WHERE (SurveyInstanceID = {0})", iSurveyInstanceID)
        Dim result As Object

        Try
            result = SqlHelper.ExecuteScalar(oConn, CommandType.Text, sql)
            If IsNothing(result) OrElse IsDBNull(result) Then result = -1
        Catch ex As Exception
            result = -1
        End Try

        Return CInt(result)

    End Function

#Region "Survey Instance Default Scripts"
    Public ReadOnly Property SurveyInstanceDefaultScripts() As clsSurveyInstanceDefaultScripts
        Get
            If IsNothing(_SurveyInstanceDefaultScripts) Then
                _SurveyInstanceDefaultScripts = New clsSurveyInstanceDefaultScripts(_oConn)
                _SurveyInstanceDefaultScripts.MainDataTable = _ds.Tables("SurveyInstanceDefaultScripts")

            End If

            Return _SurveyInstanceDefaultScripts

        End Get
    End Property

    Public Sub FillDefaultScripts()
        Dim SurveyInstanceID As Integer
        Dim dr As dsSurveyInstanceDefaultScripts.SearchRow = SurveyInstanceDefaultScripts.NewSearchRow

        If MainDataTable.Rows.Count > 0 Then
            SurveyInstanceID = CInt(MainDataTable.Rows(0).Item("SurveyInstanceID"))
            dr.SurveyInstanceID = SurveyInstanceID
            SurveyInstanceDefaultScripts.FillMain(dr)

        End If

    End Sub
#End Region

End Class
