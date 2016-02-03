Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsClients
    Inherits DMI.clsDBEntity2

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
        Me.FillSurveyInstances(drCriteria)

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsClients.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsClients.SearchRow)

        'Primary key criteria
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("ClientID = {0} AND ", dr.ClientID)
        'username criteria
        If Not dr.IsNameNull Then sbSQL.AppendFormat("Name LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Name))
        'active status criteria
        If Not dr.IsActiveNull Then sbSQL.AppendFormat("Active = {0} AND ", dr.Active)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Clients ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Clients", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 4, "ClientID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsClients
        _dtMainTable = _ds.Tables("Clients")
        _sDeleteFilter = "ClientID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Clients", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 4, "ClientID"))
        oCmd.Parameters("@ClientID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 50, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.VarChar, 100, "State"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Telephone", SqlDbType.VarChar, 50, "Telephone"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Fax", SqlDbType.VarChar, 50, "Fax"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ClientID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Clients", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ClientID", SqlDbType.Int, 4, "ClientID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 50, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address1", SqlDbType.VarChar, 250, "Address1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Address2", SqlDbType.VarChar, 250, "Address2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@City", SqlDbType.VarChar, 100, "City"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@State", SqlDbType.VarChar, 100, "State"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PostalCode", SqlDbType.VarChar, 50, "PostalCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Telephone", SqlDbType.VarChar, 50, "Telephone"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Fax", SqlDbType.VarChar, 50, "Fax"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Active", SqlDbType.TinyInt, 1, "Active"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)

        dr.Item("Name") = ""
        dr.Item("Address1") = ""
        dr.Item("Address2") = ""
        dr.Item("City") = ""
        dr.Item("State") = ""
        dr.Item("PostalCode") = ""
        dr.Item("Telephone") = ""
        dr.Item("Fax") = ""
        dr.Item("Active") = 1

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(SurveyInstanceID) FROM SurveyInstances WHERE ClientID = {0}", dr.Item("ClientID", DataRowVersion.Original))
        'TP Change
        iCount = CInt(SqlHelper.Db(Me._oConn.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString))
        'iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete client ID {0} {1}. Client has survey instances.\n", dr.Item("ClientID", DataRowVersion.Original), dr.Item("Name", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

#End Region

#Region "Survey Instance functions"

    Public Sub FillSurveyInstances(ByVal drCriteria As DataRow)
        Dim dr1 As dsClients.SearchRow
        Dim dr2 As dsSurveyInstances.SearchRow
        Dim oSI As New clsSurveyInstances(Me._oConn)

        dr1 = CType(drCriteria, dsClients.SearchRow)
        dr2 = CType(oSI.NewSearchRow, dsSurveyInstances.SearchRow)

        If Not dr1.IsClientIDNull Then dr2.ClientID = dr1.ClientID

        oSI.MainDataTable = Me.SurveyInstanceTable
        oSI.FillMain(dr2)

        oSI.Close()
        oSI = Nothing
        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Sub FillSurveyInstances(ByVal iClientID As Integer)
        Dim dr As DataRow

        dr = Me.NewSearchRow
        dr.Item("ClientID") = iClientID
        Me.FillSurveyInstances(dr)

        dr = Nothing

    End Sub

    Public Function SurveyInstanceTable() As DataTable
        Return Me._ds.Tables("SurveyInstances")

    End Function

#End Region

    Public Shared Function GetClientList(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        'TP Change
        Return SqlHelper.Db(oConn.ConnectionString).ExecuteReader(CommandType.Text, "SELECT ClientID, Name FROM Clients WHERE Active = 1 ORDER BY Name")
        'Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
        '    "SELECT ClientID, Name FROM Clients WHERE Active = 1 ORDER BY Name")

    End Function

End Class
