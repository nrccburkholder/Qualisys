Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsScriptTriggers
    Inherits DMI.clsDBEntity2

    Private _iScriptID As Integer
    Private _iScriptScreenID As Integer
    Private _UserID As Integer

#Region "dbEntity2 overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As System.Data.DataRow) As String
        Dim dr As dsScriptTriggers.SearchRow = CType(drCriteria, dsScriptTriggers.SearchRow)
        Dim sbSQL As New Text.StringBuilder

        If Not dr.IsScriptedTriggerIDNull Then sbSQL.AppendFormat("ScriptedTriggerID = {0} AND ", dr.ScriptedTriggerID)
        If Not dr.IsTriggerIDNull Then sbSQL.AppendFormat("TriggerID = {0} AND ", dr.TriggerID)
        If Not dr.IsScriptIDNull Then sbSQL.AppendFormat("TriggerIDValue1 = {0} AND ", dr.ScriptID)
        If Not dr.IsScriptScreenIDNull Then sbSQL.AppendFormat("TriggerIDValue2 = {0} AND ", dr.ScriptScreenID)
        If Not dr.IsScriptScreenCategoryIDNull Then sbSQL.AppendFormat("TriggerIDValue3 = {0} AND ", dr.ScriptScreenCategoryID)
        If Not dr.IsRunBeforeAfterNull Then sbSQL.AppendFormat("TriggerIDValue4 = {0} AND ", dr.RunBeforeAfter)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")
        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vw_ScriptTriggers ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_ScriptedTriggers", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptedTriggerID", SqlDbType.Int, 4, "ScriptedTriggerID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsScriptTriggers
        _dtMainTable = _ds.Tables("ScriptedTriggers")
        _sDeleteFilter = "ScriptedTriggerID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_ScriptedTriggers", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptedTriggerID", SqlDbType.Int, 4, "ScriptedTriggerID"))
        oCmd.Parameters("@ScriptedTriggerID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerID", SqlDbType.Int, 4, "TriggerID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue1", SqlDbType.Int, 4, "TriggerIDValue1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue2", SqlDbType.Int, 4, "TriggerIDValue2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue3", SqlDbType.Int, 4, "TriggerIDValue3"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue4", SqlDbType.Int, 4, "TriggerIDValue4"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerName", SqlDbType.VarChar, 100, "TriggerName"))
        oCmd.Parameters("@TriggerName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))
        oCmd.Parameters("@ItemOrder").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScreenTitle", SqlDbType.VarChar, 100, "ScreenTitle"))
        oCmd.Parameters("@ScreenTitle").Direction = ParameterDirection.Output

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ScriptTriggerID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_ScriptedTriggers", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptedTriggerID", SqlDbType.Int, 4, "ScriptedTriggerID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerID", SqlDbType.Int, 4, "TriggerID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue1", SqlDbType.Int, 4, "TriggerIDValue1"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue2", SqlDbType.Int, 4, "TriggerIDValue2"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue3", SqlDbType.Int, 4, "TriggerIDValue3"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerIDValue4", SqlDbType.Int, 4, "TriggerIDValue4"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerName", SqlDbType.VarChar, 100, "TriggerName"))
        oCmd.Parameters("@TriggerName").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))
        oCmd.Parameters("@ItemOrder").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScreenTitle", SqlDbType.VarChar, 100, "ScreenTitle"))
        oCmd.Parameters("@ScreenTitle").Direction = ParameterDirection.Output

        Return oCmd

    End Function
#End Region

#Region "Properties"
    Public Property ScriptID() As Integer
        Get
            Return _iScriptID

        End Get
        Set(ByVal Value As Integer)
            _iScriptID = Value

        End Set
    End Property

    Public Property ScriptScreenID() As Integer
        Get
            Return _iScriptScreenID

        End Get
        Set(ByVal Value As Integer)
            _iScriptScreenID = Value

        End Set
    End Property

    Public Property UserID() As Integer
        Get
            Return _UserID

        End Get
        Set(ByVal Value As Integer)
            _UserID = Value

        End Set
    End Property

#End Region

#Region "Script Triggers"
    Public Function TriggerPreScript(ByVal RespondentID As Integer) As String
        Return RunScriptTrigger(RespondentID, 0)

    End Function

    Public Function TriggerPostScript(ByVal RespondentID As Integer) As String
        Return RunScriptTrigger(RespondentID, 1)

    End Function

    Public Function RunScriptTrigger(ByVal userID As Integer, ByVal respondentID As Integer, ByVal PrePost As PrePostTrigger, ByVal scriptID As Integer) As String
        Return RunScriptTrigger(userID, respondentID, PrePost, scriptID, 0)

    End Function

    Public Function RunScriptTrigger(ByVal userID As Integer, ByVal respondentID As Integer, ByVal PrePost As PrePostTrigger, ByVal scriptID As Integer, ByVal scriptScreenID As Integer) As String
        Dim drConnection As New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        Dim dr As SqlClient.SqlDataReader
        Dim result As New Text.StringBuilder

        Try
            dr = SqlHelper.ExecuteReader(drConnection, CommandType.Text, BuildSQL(scriptID, scriptScreenID, PrePost))

            Do While dr.Read
                Dim t As New clsTriggers(_oConn)
                If Not IsNothing(DBTransaction) Then t.DBTransaction = DBTransaction
                t.UserID = userID
                result.Append(t.RunTrigger(CInt(dr.Item("TriggerID")), respondentID, scriptScreenID, True))
                t.Close()
                t = Nothing
            Loop

        Catch ex As Exception
            Throw ex
        Finally
            dr.Close()
            drConnection.Dispose()
        End Try

        Return result.ToString

    End Function

    Public Shared Function BuildSQL(ByVal scriptID As Integer, ByVal scriptScreenID As Integer, ByVal prePost As PrePostTrigger) As String
        Dim sql As New Text.StringBuilder
        sql.Append("SELECT * FROM vw_ScriptTriggers WHERE ")
        sql.AppendFormat("TriggerIDValue1 = {0} AND ", scriptID)
        If scriptScreenID > 0 Then
            sql.AppendFormat("TriggerIDValue2 = {0} AND ", scriptScreenID)
        Else
            sql.Append("TriggerIDValue2 IS NULL AND ")
        End If
        sql.AppendFormat("TriggerIDValue4 = {0}", CInt(prePost))

        Return sql.ToString

    End Function

    Private Function RunScriptTrigger(ByVal RespondentID As Integer, ByVal PrePost As Integer) As String
        Dim dr As DataRow
        Dim drs() As DataRow
        Dim sFilter As String
        Dim sResult As String = ""

        sFilter = String.Format("TriggerIDValue2 IS NULL AND TriggerIDValue3 IS NULL AND TriggerIDValue4 = {1}", ScriptScreenID, PrePost)
        drs = _dtMainTable.Select(sFilter)

        For Each dr In drs
            Dim t As New clsTriggers(_oConn)
            If Not IsNothing(DBTransaction) Then t.DBTransaction = DBTransaction
            t.UserID = UserID
            sResult &= t.RunTrigger(CInt(dr.Item("TriggerID")), RespondentID, 0, True)
            t.Close()
            t = Nothing

        Next

        Return sResult

    End Function

#End Region

#Region "Screen Triggers"
    Public Function TriggerPreScreen(ByVal ScriptScreenID As Integer, ByVal RespondentID As Integer) As String
        Return RunScreenTrigger(ScriptScreenID, RespondentID, 0)

    End Function

    Public Function TriggerPostScreen(ByVal ScriptScreenID As Integer, ByVal RespondentID As Integer) As String
        Return RunScreenTrigger(ScriptScreenID, RespondentID, 1)

    End Function

    Private Function RunScreenTrigger(ByVal ScriptScreenID As Integer, ByVal RespondentID As Integer, ByVal PrePost As Integer) As String
        Dim dr() As DataRow
        Dim sFilter As String
        Dim sResult As String = ""
        Dim sTmpResult As String = ""

        sFilter = String.Format("TriggerIDValue2 = {0} AND TriggerIDValue3 IS NULL AND TriggerIDValue4 = {1}", ScriptScreenID, PrePost)
        dr = _dtMainTable.Select(sFilter)

        If dr.Length > 0 Then
            Dim t As New clsTriggers(_oConn)
            sTmpResult = t.RunTrigger(CInt(dr(0).Item("TriggerID")), RespondentID, ScriptScreenID, True)
            If sTmpResult.Length > 0 Then sResult = sTmpResult
            t.Close()
            t = Nothing

        End If

        Return sResult

    End Function

#End Region

End Class

Public Enum PrePostTrigger As Integer
    PRE = 0
    POST = 1
End Enum