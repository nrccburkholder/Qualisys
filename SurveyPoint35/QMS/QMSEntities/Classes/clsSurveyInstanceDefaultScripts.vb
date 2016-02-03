Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsSurveyInstanceDefaultScripts
    Inherits DMI.clsDBEntity2

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'none
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As System.Data.DataRow) As String
        Dim dr As dsSurveyInstanceDefaultScripts.SearchRow
        Dim sbSQL As New Text.StringBuilder

        dr = CType(drCriteria, dsSurveyInstanceDefaultScripts.SearchRow)

        If Not dr.IsSurveyInstanceScriptIDNull Then sbSQL.AppendFormat("SurveyInstanceScriptID = {0} AND ", dr.SurveyInstanceScriptID)
        If Not dr.IsSurveyInstanceIDNull Then sbSQL.AppendFormat("SurveyInstanceID = {0} AND ", dr.SurveyInstanceID)
        If Not dr.IsScriptTypeIDNull Then sbSQL.AppendFormat("ScriptTypeID = {0} AND ", dr.ScriptTypeID)
        If Not dr.IsScriptIDNull Then sbSQL.AppendFormat("ScriptID = {0} AND ", dr.ScriptID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM SurveyInstanceDefaultScripts ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_SurveyInstanceDefaultScripts", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceScriptID", SqlDbType.Int, 4, "SurveyInstanceScriptID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsSurveyInstanceDefaultScripts
        _dtMainTable = _ds.Tables("SurveyInstanceDefaultScripts")
        _sDeleteFilter = "SurveyInstanceScriptID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_SurveyInstanceDefaultScripts", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceScriptID", SqlDbType.Int, 4, "SurveyInstanceScriptID"))
        oCmd.Parameters("@SurveyInstanceScriptID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptTypeID", SqlDbType.Int, 4, "ScriptTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", SqlDbType.Int, 4, "ScriptID"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("SurveyInstanceScriptID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_SurveyInstanceDefaultScripts", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceScriptID", SqlDbType.Int, 4, "SurveyInstanceScriptID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyInstanceID", SqlDbType.Int, 4, "SurveyInstanceID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptTypeID", SqlDbType.Int, 4, "ScriptTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", SqlDbType.Int, 4, "ScriptID"))

        Return oCmd

    End Function

#End Region

    Public Sub SetDefaultScript(ByVal SurveyInstanceID As Integer, ByVal ScriptTypeID As Integer, ByVal ScriptID As Integer)
        Dim dr As DataRow = SelectRow(String.Format("SurveyInstanceID = {0} AND ScriptTypeID = {1}", SurveyInstanceID, ScriptTypeID))

        'does default already exist for script type?
        If IsNothing(dr) Then
            'insert row
            dr = Me.NewMainRow()
            dr.Item("SurveyInstanceID") = SurveyInstanceID
            dr.Item("ScriptTypeID") = ScriptTypeID
            dr.Item("ScriptID") = ScriptID
            Me.AddMainRow(dr)

        Else
            'update row
            If ScriptID <> CInt(dr.Item("ScriptID")) Then dr.Item("ScriptID") = ScriptID

        End If

        'save changes to database
        Me.Save()

    End Sub

    Public Function GetDefaultScript(ByVal SurveyInstanceID As Integer, ByVal ScriptTypeID As Integer) As Integer
        Dim dr As DataRow = SelectRow(String.Format("ScriptTypeID = {0}", ScriptTypeID))

        'does default already exist for script type?
        If Not IsNothing(dr) Then
            'return existing default
            Return CInt(dr.Item("ScriptID"))

        Else
            'get default for survey
            Return GetSurveyDefaultScript(SurveyInstanceID, ScriptTypeID)

        End If

    End Function

    Public Function GetSurveyDefaultScript(ByVal SurveyInstanceID As Integer, ByVal ScriptTypeID As Integer) As Integer
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT TOP 1 Scripts.ScriptID ")
        sbSQL.Append("FROM SurveyInstances INNER JOIN ")
        sbSQL.Append("Scripts ON SurveyInstances.SurveyID = Scripts.SurveyID ")
        sbSQL.AppendFormat("WHERE (SurveyInstances.SurveyInstanceID = {0}) AND (Scripts.ScriptTypeID = {1}) ", SurveyInstanceID, ScriptTypeID)
        sbSQL.Append("ORDER BY Scripts.DefaultScript DESC")

        Return CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sbSQL.ToString))

    End Function

End Class
