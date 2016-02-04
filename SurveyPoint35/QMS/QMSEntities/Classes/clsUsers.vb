Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsUsers
    Inherits DMI.clsDBEntity2

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsUsers.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsUsers.SearchRow)

        'Primary key criteria
        If Not dr.IsUserIDNull Then sbSQL.AppendFormat("UserID = {0} AND ", dr.UserID)
        'username criteria
        If Not dr.IsUsernameNull Then sbSQL.AppendFormat("Username LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Username))
        'full name criteria
        If Not dr.IsFullNameNull Then sbSQL.AppendFormat("FirstName + ' ' + LastName LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.FullName))
        'password criteria
        If Not dr.IsPasswordNull Then sbSQL.AppendFormat("Password = {0} AND ", DMI.DataHandler.QuoteString(dr.Password))
        'user group id criteria
        If Not dr.IsGroupIDNull Then sbSQL.AppendFormat("GroupID = {0} AND ", dr.GroupID)
        'active status criteria
        If Not dr.IsActiveNull Then sbSQL.AppendFormat("Active = {0} AND ", dr.Active)
        'survey author criteria
        If Not dr.IsIsSurveyAuthorNull AndAlso dr.IsSurveyAuthor = 1 Then sbSQL.Append("UserID IN (SELECT DISTINCT CreatedByUserID FROM Surveys) AND ")

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Users ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Users", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsUsers()
        _dtMainTable = _ds.Tables("Users")
        _sDeleteFilter = "UserID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Users", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
        oCmd.Parameters("@UserID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Username", SqlDbType.VarChar, 50, "Username"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Password", SqlDbType.VarChar, 100, "Password"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 100, "Email"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupID", SqlDbType.Int, 4, "GroupID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@VerificationRate", SqlDbType.Int, 4, "VerificationRate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@KeyMonitorRate", SqlDbType.Int, 4, "KeyMonitorRate"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("UserID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Users", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4, "UserID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Username", SqlDbType.VarChar, 50, "Username"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", SqlDbType.VarChar, 100, "FirstName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", SqlDbType.VarChar, 100, "LastName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Password", SqlDbType.VarChar, 100, "Password"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Email", SqlDbType.VarChar, 100, "Email"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupID", SqlDbType.Int, 4, "GroupID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@VerificationRate", SqlDbType.Int, 4, "VerificationRate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@KeyMonitorRate", SqlDbType.Int, 4, "KeyMonitorRate"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("Username") = ""
        dr.Item("FirstName") = ""
        dr.Item("LastName") = ""
        dr.Item("Password") = ""
        dr.Item("Email") = ""
        dr.Item("GroupID") = 0
        dr.Item("Active") = 1

    End Sub

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Return Me.ValidateUsername(CInt(dr.Item("UserID")), dr.Item("Username").ToString)

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Dim bValid As Boolean

        'check if username is already in use
        bValid = Me.ValidateUsername(CInt(dr.Item("UserID")), dr.Item("Username").ToString)

        'check that admin is not deactivated
        If CInt(dr.Item("UserID")) = 1 Then
            If CInt(dr.Item("Active")) = 0 Then
                Me._sErrorMsg &= "Cannot deactivate the administrator account.\n"
                bValid = False

            End If
        End If

        Return bValid

    End Function

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder()
        Dim iCount As Integer

        'check that user does not have event log data
        sbSQL.AppendFormat("SELECT COUNT(EventLogID) FROM EventLog WHERE UserID = {0}", dr.Item("UserID", DataRowVersion.Original))
        'TP Change
        'Need to create the command object because we need a longer timeout.
        Dim cmd As DbCommand = SqlHelper.Db(_oConn.ConnectionString).GetSqlStringCommand(sbSQL.ToString)
        cmd.CommandTimeout = 60
        iCount = CInt(SqlHelper.Db(_oConn.ConnectionString).ExecuteScalar(cmd))

        'iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete user ID {0} {1}. User has events in log.\n", dr.Item("UserID", DataRowVersion.Original), dr.Item("Username", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

#End Region

    'check if username is already in use
#Region "ValidateUsername Functions"
    Public Function ValidateUsername(ByVal iUserID As Integer, ByVal sUsername As String) As Boolean
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(UserID) FROM Users WHERE Username LIKE {0} AND UserID <> {1}", DMI.DataHandler.QuoteString(sUsername), iUserID)
        'TP Change
        If CInt(SqlHelper.Db(_oConn.ConnectionString).ExecuteScalar(CommandType.Text, sSQL)) > 0 Then
            'If CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL)) > 0 Then
            'username already in use
            Me._sErrorMsg &= String.Format("Username {0} already in use by another account. Please change username.", sUsername)
            Return False

        End If

        Return True

    End Function

#End Region

    'encrypts password for database store or to compare with database
    Public Shared Function EncryptPassword(ByVal sPassword As String) As String
        Return System.Web.Security.FormsAuthentication.HashPasswordForStoringInConfigFile(sPassword, "SHA1")

    End Function

    'check user sign-in creditals
    Public Function SignInUser(ByVal Username As String, ByVal Password As String, ByVal SessionID As String) As Boolean
        Dim drCriteria As DataRow = Me.NewSearchRow()

        'set search criteria
        drCriteria("Username") = Username
        drCriteria("Password") = Me.EncryptPassword(Password)

        'get user data
        Me.FillMain(drCriteria)

        'check for valid user
        If Me.MainDataTable.Rows.Count = 1 Then
            'log sign in
            Me.LogUserEvent(CInt(Me.MainDataTable.Rows(0).Item("UserID")), qmsEvents.USER_LOGON, SessionID)
            'user validated
            Return True

        End If

        'no user records found
        Return False

    End Function

    'returns array of user privledges
    Public Function Privledges(Optional ByVal iUserId As Integer = 0) As ArrayList
        Dim sbSQL As New Text.StringBuilder
        Dim dr As SqlClient.SqlDataReader
        Dim arl As New ArrayList

        If iUserId = 0 Then iUserId = CInt(Me.MainDataTable.Rows(0).Item(0))

        'get user privledges datareader
        sbSQL.Append("SELECT UserGroupPrivledges.EventID FROM Users INNER JOIN ")
        sbSQL.Append("UserGroups ON Users.GroupID = UserGroups.GroupID INNER JOIN ")
        sbSQL.Append("UserGroupPrivledges ON UserGroups.GroupID = UserGroupPrivledges.GroupID ")
        sbSQL.AppendFormat("WHERE Users.UserID = {0}", iUserId)
        'TP Change
        dr = DirectCast(SqlHelper.Db(DMI.DataHandler.sConnection).ExecuteReader(CommandType.Text, sbSQL.ToString()), SqlClient.SqlDataReader)        
        'dr = SqlHelper.ExecuteReader(Me._oConn, CommandType.Text, sbSQL.ToString)

        'read privledges into arraylist
        Do Until Not dr.Read()
            arl.Add(CInt(dr.Item("EventID")))

        Loop

        'clean up
        dr.Close()
        dr = Nothing
        sbSQL = Nothing

        'return arraylist of privledges
        Return arl

    End Function

    'log user event
#Region "LogUserEvent Functions"

    Public Shared Sub LogUserEvent(ByVal iUserID As Integer, ByVal iEventId As qmsEvents, ByVal oConn As SqlClient.SqlConnection, Optional ByVal sParameter As String = "")
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("INSERT INTO EventLog(EventDate, EventID, UserID, EventParameters) ")
        sbSQL.AppendFormat("VALUES(GETDATE(),{1},{0},{2})", iUserID, CInt(iEventId), DMI.DataHandler.QuoteString(sParameter))
        'TP Change
        SqlHelper.Db(oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, sbSQL.ToString())
        'SqlHelper.ExecuteNonQuery(oConn, CommandType.Text, sbSQL.ToString)

        sbSQL = Nothing

    End Sub

    Public Shared Sub LogUserEvent(ByVal iUserID As Integer, ByVal iEventId As qmsEvents, Optional ByVal sParameter As String = "")
        Dim oConn As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        LogUserEvent(iUserID, iEventId, oConn, sParameter)

        oConn.Close()
        oConn = Nothing

    End Sub

#End Region

    Public Shared Function GetUsersDataSource(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, "SELECT UserID, Username FROM Users WHERE Active = 1 ORDER BY Username"), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
        '    "SELECT UserID, Username FROM Users WHERE Active = 1 ORDER BY Username")

    End Function

    Public Shared Function GetUserID(ByVal connection As SqlClient.SqlConnection, ByVal userName As String) As Integer
        Dim sql As String
        Dim result As Object
        sql = String.Format("SELECT UserID FROM Users WHERE Username LIKE '{0}'", userName.Replace("'", "''"))
        'TP Change
        result = SqlHelper.Db(connection.ConnectionString).ExecuteScalar(CommandType.Text, sql)
        'result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.Null.NullInteger

    End Function

    Public Shared Function InsertUser(ByVal connection As SqlClient.SqlConnection, ByVal Username As String, ByVal Password As String, ByVal FirstName As String, ByVal LastName As String, ByVal Email As String, ByVal GroupID As Integer, ByVal Active As Integer) As Integer
        Dim userID As New SqlClient.SqlParameter("@UserID", SqlDbType.Int, 4)
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(connection.ConnectionString).GetStoredProcCommand("insert_Users")
        cmd.Parameters.Add(userID)
        cmd.Parameters.Add(New SqlClient.SqlParameter("@Username", Username))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@FirstName", FirstName))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@LastName", LastName))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@Password", Password))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@Email", Email))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@GroupID", GroupID))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@Active", Active))
        SqlHelper.Db(connection.ConnectionString).ExecuteNonQuery(cmd)
        'SqlHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, "insert_Users", _
        ' userID, _
        '    New SqlClient.SqlParameter("@Username", Username), _
        '    New SqlClient.SqlParameter("@FirstName", FirstName), _
        '    New SqlClient.SqlParameter("@LastName", LastName), _
        '    New SqlClient.SqlParameter("@Password", Password), _
        '    New SqlClient.SqlParameter("@Email", Email), _
        '    New SqlClient.SqlParameter("@GroupID", GroupID), _
        '    New SqlClient.SqlParameter("@Active", Active))
        Return CInt(userID.Value)
    End Function

    Public Shared Function GetVerificationRate(ByVal connection As SqlClient.SqlConnection, ByVal UserID As Integer) As Integer
        Dim sql As String = "SELECT ISNULL(Users.VerificationRate, UserGroups.VerificationRate) FROM UserGroups INNER JOIN Users ON UserGroups.GroupID = Users.GroupID WHERE (Users.UserID = @UserID)"
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(connection.ConnectionString).GetSqlStringCommand(sql)
        cmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", UserID))
        Return CInt(SqlHelper.Db(connection.ConnectionString).ExecuteScalar(cmd))
        'Return CInt(SqlHelper.ExecuteScalar(connection, CommandType.Text, sql, _
        '    New SqlClient.SqlParameter("@UserID", UserID)))

    End Function

    Public Shared Function GetKeyMonitorRate(ByVal connection As SqlClient.SqlConnection, ByVal UserID As Integer) As Integer
        Dim sql As String = "SELECT ISNULL(Users.KeyMonitorRate, UserGroups.KeyMonitorRate) FROM UserGroups INNER JOIN Users ON UserGroups.GroupID = Users.GroupID WHERE (Users.UserID = @UserID)"
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(connection.ConnectionString).GetSqlStringCommand(sql)
        cmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", UserID))
        Return CInt(SqlHelper.Db(connection.ConnectionString).ExecuteScalar(cmd))
        'Return CInt(SqlHelper.ExecuteScalar(connection, CommandType.Text, sql, _
        '   New SqlClient.SqlParameter("@UserID", UserID)))

    End Function

    Public Shared Function VerifyDataEntry(ByVal connection As SqlClient.SqlConnection, ByVal UserID As Integer) As Boolean
        Dim rate As Integer = GetVerificationRate(connection, UserID)
        Dim rnd As New System.Random
        Dim randNum As Integer = rnd.Next(1, 100)
        Return CBool(rate >= randNum)

    End Function

    <Obsolete("Do not use. Track 100%.")> _
    Public Shared Function TrackKeyRate(ByVal connection As SqlClient.SqlConnection, ByVal UserID As Integer) As Boolean
        Dim rate As Integer = GetKeyMonitorRate(connection, UserID)
        Dim rnd As New System.Random
        Dim randNum As Integer = rnd.Next(1, 100)
        Return CBool(rate >= randNum)

    End Function

End Class
