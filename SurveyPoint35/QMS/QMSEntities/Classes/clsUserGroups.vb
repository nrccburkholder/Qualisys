Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsUserGroups
    Inherits DMI.clsDBEntity2

#Region "dbEntity overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        FillUserGroupPrivledges(drCriteria)

    End Sub

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("GroupID") = iEntityID

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsUserGroups.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsUserGroups.SearchRow)

        'Primary key criteria
        If Not dr.IsGroupIDNull Then sbSQL.AppendFormat("GroupID = {0} AND ", dr.GroupID)
        'name criteria
        If Not dr.IsNameNull Then sbSQL.AppendFormat("Name LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Name))
        'description criteria
        If Not dr.IsDescriptionNull Then sbSQL.AppendFormat("Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Description))

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM UserGroups ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_UserGroups", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupID", SqlDbType.Int, 4, "GroupID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsUserGroups()
        _dtMainTable = _ds.Tables("UserGroups")
        _sDeleteFilter = "GroupID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_UserGroups", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupID", SqlDbType.Int, 4, "GroupID"))
        oCmd.Parameters("@GroupID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 500, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@VerificationRate", SqlDbType.Int, 4, "VerificationRate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@KeyMonitorRate", SqlDbType.Int, 4, "KeyMonitorRate"))

        Return oCmd

    End Function

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_UserGroups", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupID", SqlDbType.Int, 4, "GroupID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 500, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@VerificationRate", SqlDbType.Int, 4, "VerificationRate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@KeyMonitorRate", SqlDbType.Int, 4, "KeyMonitorRate"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("Name") = ""
        dr.Item("Description") = ""

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder()
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(UserID) FROM Users WHERE GroupID = {0}", dr.Item("GroupID", DataRowVersion.Original))
        'TP Change
        iCount = CInt(SqlHelper.Db(_oConn.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString()))
        'iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete user group ID {0}. User group has users.\n", dr.Item("GroupID", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyUserGroupName(CInt(dr.Item("GroupID")), dr.Item("Name").ToString)

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyUserGroupName(CInt(dr.Item("GroupID")), dr.Item("Name").ToString)

    End Function

#End Region

#Region "User Group Privledges functions"

#Region "FillUserGroupPrivledges functions"

    Public Sub FillUserGroupPrivledges(ByVal drCriteria As DataRow)
        Dim dr1 As dsUserGroups.SearchRow
        Dim da As SqlClient.SqlDataAdapter

        dr1 = CType(drCriteria, dsUserGroups.SearchRow)
        da = New SqlClient.SqlDataAdapter(GetUserGroupPrivledgesSQL(dr1), Me._oConn)

        da.Fill(Me._ds.Tables("UserGroupPrivledges"))

        da = Nothing
        dr1 = Nothing

    End Sub

    Public Sub FillUserGroupPrivledges(ByVal iUserGroupID As Integer)
        Dim dr As DataRow

        dr = Me.NewSearchRow
        dr.Item("GroupID") = iUserGroupID
        Me.FillUserGroupPrivledges(dr)

        dr = Nothing

    End Sub

    Public Function GetDRUserGroupPrivledges(ByVal drCriteria As DataRow) As SqlClient.SqlDataReader
        Dim dr As dsUserGroups.SearchRow

        dr = CType(drCriteria, dsUserGroups.SearchRow)
        Return DirectCast(SqlHelper.Db(_oConn.ConnectionString).ExecuteReader(CommandType.Text, GetUserGroupPrivledgesSQL(dr)), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(Me._oConn, CommandType.Text, GetUserGroupPrivledgesSQL(dr))

    End Function

    Public Function GetDRUserGroupPrivledges(ByVal iUserGroupID As Integer) As SqlClient.SqlDataReader
        Dim dr As DataRow

        dr = Me.NewSearchRow
        dr.Item("GroupID") = iUserGroupID
        Return Me.GetDRUserGroupPrivledges(dr)

    End Function

    Protected Function GetUserGroupPrivledgesSQL(ByRef drCriteria As dsUserGroups.SearchRow) As String
        Dim sbSQL As New Text.StringBuilder

        'build where criteria
        If Not drCriteria.IsGroupIDNull Then sbSQL.AppendFormat("GroupID = {0} AND ", drCriteria.GroupID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM UserGroupPrivledges ")

        Return sbSQL.ToString

    End Function

#End Region

#Region "GetDRPrivledgesList functions"

    Public Shared Function GetDRPrivledgesList(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Dim sSQL As String = "SELECT EventID, Name, Description FROM Events WHERE EventTypeID = 6"
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, sSQL), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, sSQL)

    End Function

    Public Shared Function GetDRPrivledgesList() As SqlClient.SqlDataReader
        Dim oConn As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)

        Return GetDRPrivledgesList(oConn)

    End Function
#End Region

    Public Function PrivledgesTable() As DataTable
        Return Me._ds.Tables("UserGroupPrivledges")

    End Function

    Public Property Privledges(ByVal iEventID As Integer) As Boolean
        Get
            'get privledge row
            Dim dr As DataRow()
            dr = DMI.DataHandler.GetRS(Me._ds, String.Format("SELECT * FROM UserGroupPrivledges WHERE EventID = {0}", iEventID))

            If dr.Length > 0 Then
                'row exists, group has privledge
                dr = Nothing
                Return True

            Else
                'row does not exist, group does not have privledge
                dr = Nothing
                Return False

            End If

        End Get
        Set(ByVal Value As Boolean)
            'get privledge row
            Dim dr As DataRow()
            dr = DMI.DataHandler.GetRS(Me._ds, String.Format("SELECT * FROM UserGroupPrivledges WHERE EventID = {0}", iEventID))

            If Value Then
                'add privledge
                If dr.Length = 0 Then Me.AddPrivledge(iEventID)

            ElseIf dr.Length > 0 AndAlso VerifyPrivledgesDelete(dr(0)) Then
                'remove privledge, if row exists
                dr(0).Delete()

            End If

            dr = Nothing

        End Set
    End Property

    Private Sub AddPrivledge(ByVal iEventID As Integer)
        Dim dr As dsUserGroups.UserGroupPrivledgesRow

        dr = CType(Me.PrivledgesTable.NewRow, dsUserGroups.UserGroupPrivledgesRow)

        dr.GroupID = CInt(Me.MainDataTable.Rows(0).Item("GroupID"))
        dr.EventID = iEventID

        Me.PrivledgesTable.Rows.Add(dr)

    End Sub

    Private Function PrivledgesDeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_UserGroupPrivledges", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupPrivledgeID", SqlDbType.Int, 4, "GroupPrivledgeID"))

        Return oCmd

    End Function

    Private Function PrivledgesInsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_UserGroupPrivledges", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupPrivledgeID", SqlDbType.Int, 4, "GroupPrivledgeID"))
        oCmd.Parameters("@GroupPrivledgeID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@GroupID", SqlDbType.Int, 4, "GroupID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", SqlDbType.Int, 4, "EventID"))

        Return oCmd

    End Function

    Public Sub SavePrivledges()
        Dim da As New SqlClient.SqlDataAdapter

        da.DeleteCommand = PrivledgesDeleteCommand()
        da.InsertCommand = PrivledgesInsertCommand()

        If Me._oConn.State = ConnectionState.Closed Then Me._oConn.Open()

        da.Update(Me.PrivledgesTable)

        da = Nothing

    End Sub

    Private Function VerifyPrivledgesDelete(ByVal dr As DataRow) As Boolean
        If CInt(dr.Item("GroupID")) = 1 Then
            Me._sErrorMsg &= String.Format("Cannot remove privledge {0} from Administrators group.\n", dr.Item("EventID"))
            Return False

        End If

        Return True

    End Function

#End Region

    Private Function VerifyUserGroupName(ByVal iGroupID As Integer, ByVal sGroupName As String) As Boolean
        Dim sSQL As String

        sSQL = String.Format("SELECT COUNT(GroupID) FROM UserGroups WHERE Name LIKE {0} AND GroupID <> {1}", DMI.DataHandler.QuoteString(sGroupName), iGroupID)
        'TP Change
        If CInt(SqlHelper.Db(_oConn.ConnectionString).ExecuteScalar(CommandType.Text, sSQL)) > 0 Then
            'If CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL)) > 0 Then
            'username already in use
            Me._sErrorMsg &= String.Format("Group name {0} already in use by another account. Please change group name.", sGroupName)
            Return False

        End If

        Return True

    End Function

    Public Shared Function GetUserGroupsDataSource(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return DirectCast(SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, "SELECT GroupID, Name FROM UserGroups ORDER BY Name"), SqlClient.SqlDataReader)
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
        '   "SELECT GroupID, Name FROM UserGroups ORDER BY Name")

    End Function

    Public Shared Function GetUserGroupID(ByVal connection As SqlClient.SqlConnection, ByVal GroupName As String) As Integer
        Dim sql As String
        Dim result As Object
        sql = String.Format("SELECT GroupID FROM UserGroups WHERE Name LIKE '{0}'", GroupName.Replace("'", "''"))
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.Null.NullInteger
    End Function

    Public Shared Function InsertUserGroup(ByVal connection As SqlClient.SqlConnection, ByVal GroupName As String, ByVal GroupDesc As String) As Integer
        Dim groupID As New SqlClient.SqlParameter("@GroupID", SqlDbType.Int, 4)
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(connection.ConnectionString).GetStoredProcCommand("insert_UserGroup")
        cmd.Parameters.Add(groupID)
        cmd.Parameters.Add(New SqlClient.SqlParameter("@Name", GroupName))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@Description", GroupDesc))
        SqlHelper.Db(connection.ConnectionString).ExecuteNonQuery(cmd)

        'SqlHelper.ExecuteNonQuery(connection, CommandType.Text, "insert_UserGroup", _
        '    groupID, _
        '    New SqlClient.SqlParameter("@Name", GroupName), _
        '    New SqlClient.SqlParameter("@Description", GroupDesc))
        Return CInt(groupID.Value)

    End Function

End Class
