Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsHouseholds
    Inherits DMI.clsDBEntity2

    Private _iSurveyInstanceID As Integer
    Private _iUserID As Integer

#Region "dbentity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New QMS.dsHousehold
        _dtMainTable = _ds.Tables("Households")
        _sDeleteFilter = "RespondentID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand

    End Function

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups - for now

    End Sub

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("RespondentID") = iEntityID

    End Sub

#End Region

    Public Sub GetHousehold(ByVal iRespondentID)
        Dim oCmd As New SqlClient.SqlCommand
        Dim da As New SqlClient.SqlDataAdapter

        oCmd.Connection = _oConn
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.CommandText = "get_Household"
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", iRespondentID))

        da.SelectCommand = oCmd
        da.Fill(Me.MainDataTable)

        oCmd.Dispose()
        da.Dispose()
        oCmd = Nothing
        da = Nothing

    End Sub

    Public Sub LogEvent(ByVal iRespondentID As Integer, ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal sParam As String)
        'TP Change
        Dim cmd As DbCommand = SqlHelper.Db(_oConn.ConnectionString).GetStoredProcCommand("spInsertHouseholdEventLog")
        cmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", iRespondentID))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@EventID", iEventID))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@UserID", iUserID))
        cmd.Parameters.Add(New SqlClient.SqlParameter("@EventParameters", sParam))
        SqlHelper.Db(_oConn.ConnectionString).ExecuteNonQuery(cmd)

        'SqlHelper.ExecuteNonQuery(_oConn, CommandType.StoredProcedure, _
        '    "spInsertHouseholdEventLog", _
        '    New SqlClient.SqlParameter("@RespondentID", iRespondentID), _
        '    New SqlClient.SqlParameter("@EventID", iEventID), _
        '    New SqlClient.SqlParameter("@UserID", iUserID), _
        '    New SqlClient.SqlParameter("@EventParameters", sParam))
    End Sub

    Public Sub LogEvent(ByVal iEventID As Integer, ByVal iUserID As Integer, ByVal sParam As String)
        Dim drMember As DataRow
        Dim iRespondentID As Integer

        For Each drMember In MainDataTable.Rows
            iRespondentID = CInt(drMember.Item("RespondentID"))
            clsRespondents.InsertEvent(_oConn, iEventID, iUserID, iRespondentID, sParam)

            If clsEvents.IsCallEvent(_oConn, iEventID) Then
                If clsRespondents.AtMaxCalls(_oConn, iRespondentID) Then
                    clsRespondents.InsertEvent(_oConn, qmsEvents.RESPONDENT_MAX_CALL_REACHED, iUserID, iRespondentID, "")

                End If
            End If
        Next

    End Sub

    Public Sub UpdateAddress(ByVal drRespondent As DataRow)
        Dim drMember As DataRow
        Dim sbSQL As New Text.StringBuilder
        Dim sUpdateSQL As String
        Dim sAddress1 As String
        Dim sAddress2 As String
        Dim sCity As String
        Dim sState As String
        Dim sPostalCode As String

        If IsDBNull(drRespondent.Item("Address1")) Then sAddress1 = "NULL" Else sAddress1 = DMI.DataHandler.QuoteString(drRespondent.Item("Address1"))
        If IsDBNull(drRespondent.Item("Address2")) Then sAddress2 = "NULL" Else sAddress2 = DMI.DataHandler.QuoteString(drRespondent.Item("Address2"))
        If IsDBNull(drRespondent.Item("City")) Then sCity = "NULL" Else sCity = DMI.DataHandler.QuoteString(drRespondent.Item("City"))
        If IsDBNull(drRespondent.Item("State")) Then sState = "NULL" Else sState = DMI.DataHandler.QuoteString(drRespondent.Item("State"))
        If IsDBNull(drRespondent.Item("PostalCode")) Then sPostalCode = "NULL" Else sPostalCode = DMI.DataHandler.QuoteString(drRespondent.Item("PostalCode"))

        sUpdateSQL = String.Format("UPDATE Respondents SET Address1 = {0}, Address2 = {1}, City = {2}, State = {3}, PostalCode = {4} ", _
            sAddress1, sAddress2, sCity, sState, sPostalCode)

        For Each drMember In MainDataTable.Rows
            sbSQL.AppendFormat("{0} WHERE RespondentID = {1};", sUpdateSQL, drMember.Item("RespondentID"))
            'log address change
            clsRespondents.InsertEvent(_oConn, qmsEvents.RESPONDENT_UPDATED_ADDRESS, _iUserID, CInt(drMember.Item("RespondentID")))

        Next
        'TP Change
        If sbSQL.Length > 0 Then SqlHelper.Db(_oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, sbSQL.ToString())
        'If sbSQL.Length > 0 Then SqlHelper.ExecuteNonQuery(_oConn, CommandType.Text, sbSQL.ToString)

    End Sub

    Public Sub UpdateTelephone(ByVal drRespondent As DataRow)
        Dim drMember As DataRow
        Dim sbSQL As New Text.StringBuilder
        Dim sUpdateSQL As String
        Dim sTelephoneDay As String
        Dim sTelephoneEvening As String

        If IsDBNull(drRespondent.Item("TelephoneDay")) Then sTelephoneDay = "NULL" Else sTelephoneDay = DMI.DataHandler.QuoteString(drRespondent.Item("TelephoneDay"))
        If IsDBNull(drRespondent.Item("TelephoneEvening")) Then sTelephoneEvening = "NULL" Else sTelephoneEvening = DMI.DataHandler.QuoteString(drRespondent.Item("TelephoneEvening"))

        sUpdateSQL = String.Format("UPDATE Respondents SET TelephoneDay = {0}, TelephoneEvening = {1} ", _
            sTelephoneDay, sTelephoneEvening)

        For Each drMember In MainDataTable.Rows
            sbSQL.AppendFormat("{0} WHERE RespondentID = {1};", sUpdateSQL, drMember.Item("RespondentID"))
            'log telephone change
            clsRespondents.InsertEvent(_oConn, qmsEvents.RESPONDENT_UPDATED_TELEPHONE, _iUserID, CInt(drMember.Item("RespondentID")))

        Next
        'TP Change
        If sbSQL.Length > 0 Then SqlHelper.Db(_oConn.ConnectionString).ExecuteNonQuery(CommandType.Text, sbSQL.ToString())
        'If sbSQL.Length > 0 Then SqlHelper.ExecuteNonQuery(_oConn, CommandType.Text, sbSQL.ToString)

    End Sub

    Protected Overrides Function SelectCommand(ByRef drCriteria As System.Data.DataRow) As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand
        Dim dr As dsHousehold.SearchRow

        dr = CType(drCriteria, dsHousehold.SearchRow)

        oCmd = New SqlClient.SqlCommand("get_Household", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        If Not dr.IsRespondentIDNull Then
            oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", dr.RespondentID))

        Else
            oCmd.Parameters.Add(New SqlClient.SqlParameter("@RespondentID", 0))

        End If
        oCmd.Parameters("@RespondentID").Direction = ParameterDirection.Input

        Return oCmd

    End Function

    Public Property UserID() As Integer
        Get
            Return _iUserID

        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value

        End Set
    End Property
End Class
