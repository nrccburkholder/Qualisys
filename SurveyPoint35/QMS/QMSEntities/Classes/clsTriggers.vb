Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsTriggers
    Inherits DMI.clsDBEntity2

    Protected _SurveyID As Integer
    Protected _UserID As Integer

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
        Dim dr As dsTriggers.SearchRow
        Dim sbSQL As New Text.StringBuilder
        Dim sbScriptTriggersSQL As New Text.StringBuilder

        dr = CType(drCriteria, dsTriggers.SearchRow)

        'script trigger criteria
        If Not dr.IsScriptedTriggerIDNull Then sbScriptTriggersSQL.AppendFormat("ScriptedTriggerID = {0} AND ", dr.ScriptedTriggerID)
        If Not dr.IsPrePostFlagNull Then sbScriptTriggersSQL.AppendFormat("TriggerIDValue4 = {0} AND ", dr.PrePostFlag)
        If Not dr.IsScriptIDNull Then sbScriptTriggersSQL.AppendFormat("TriggerIDValue1 = {0} AND ", dr.ScriptID)
        If Not dr.IsScriptScreenIDNull Then sbScriptTriggersSQL.AppendFormat("TriggerIDValue2 = {0} AND ", dr.ScriptScreenID)

        'trigger criteria
        If Not dr.IsTriggerIDNull Then sbSQL.AppendFormat("TriggerID = {0} AND ", dr.TriggerID)
        If Not dr.IsCriteriaIDNull Then sbSQL.AppendFormat("CriteriaID = {0} AND ", dr.CriteriaID)
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        If Not dr.IsTriggerNameNull Then sbSQL.AppendFormat("TriggerName LIKE '{0}' AND ", dr.TriggerName)
        If Not dr.IsTriggerTypeIDNull Then sbSQL.AppendFormat("TriggerTypeID = {0} AND ", dr.TriggerTypeID)
        If sbScriptTriggersSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbScriptTriggersSQL, 4)
            sbSQL.AppendFormat("TriggerID IN (SELECT TriggerID FROM ScriptedTriggers WHERE {0}) AND ", sbScriptTriggersSQL.ToString)

        End If
        sbScriptTriggersSQL = Nothing

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Triggers ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Triggers", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerID", SqlDbType.Int, 4, "TriggerID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsTriggers
        _dtMainTable = _ds.Tables("Triggers")
        _sDeleteFilter = "TriggerID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Triggers", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerID", SqlDbType.Int, 4, "TriggerID"))
        oCmd.Parameters("@TriggerID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerTypeID", SqlDbType.Int, 4, "TriggerTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerName", SqlDbType.VarChar, 100, "TriggerName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaID", SqlDbType.Int, 4, "CriteriaID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TheCode", SqlDbType.VarChar, 8000, "TheCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PerodicyDate", SqlDbType.DateTime, 10, "PerodicyDate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PerodicyNextDate", SqlDbType.DateTime, 10, "PerodicyNextDate"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("TriggerID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Triggers", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerID", SqlDbType.Int, 4, "TriggerID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerTypeID", SqlDbType.Int, 4, "TriggerTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TriggerName", SqlDbType.VarChar, 100, "TriggerName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CriteriaID", SqlDbType.Int, 4, "CriteriaID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@TheCode", SqlDbType.VarChar, 8000, "TheCode"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PerodicyDate", SqlDbType.DateTime, 10, "PerodicyDate"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@PerodicyNextDate", SqlDbType.DateTime, 10, "PerodicyNextDate"))

        Return oCmd

    End Function


    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("TriggerTypeID") = 1
        If Not IsNothing(_SurveyID) Then dr.Item("SurveyID") = _SurveyID

    End Sub

#End Region

    Public WriteOnly Property ScriptID() As Integer
        Set(ByVal Value As Integer)
            Me.SurveyID = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, _
                String.Format("SELECT SurveyID FROM Scripts WHERE ScriptID = {0}", Value)))

        End Set
    End Property

    Public Property SurveyID() As Integer
        Get
            Return _SurveyID

        End Get
        Set(ByVal Value As Integer)
            _SurveyID = Value

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

#Region "Execute Trigger"
    Public Function RunTrigger(ByVal iTriggerID As Integer, ByVal iRespondentID As Integer, ByVal iScriptScreenID As Integer, Optional ByVal bRunCriteria As Boolean = True) As String
        Dim bRunTrigger As Boolean = True
        Dim drTrigger As SqlClient.SqlDataReader
        Dim sResult As String = ""

        'get trigger
        drTrigger = GetTriggerDataReader(iTriggerID)
        If drTrigger.Read Then
            'check criteria
            If Not IsDBNull(drTrigger.Item("CriteriaID")) Then
                'run criteria
                If bRunCriteria Then bRunTrigger = CheckCriteria(CInt(drTrigger.Item("CriteriaID")), iRespondentID)

            End If

            'execute trigger
            If bRunTrigger Then sResult = ExecuteTrigger(iTriggerID, CInt(drTrigger.Item("TriggerTypeID")), drTrigger.Item("TheCode").ToString, iRespondentID, iScriptScreenID, True)

        End If

        'clean up
        drTrigger.Close()
        drTrigger = Nothing

        Return sResult

    End Function

    Private Function ExecuteTrigger(ByVal TriggerID As Integer, ByVal TriggerTypeID As Integer, ByVal TriggerCode As String, ByVal RespondentID As Integer, ByVal ScriptScreenID As Integer, ByVal RunCriteria As Boolean) As String
        Dim drTriggerType As SqlClient.SqlDataReader
        Dim sbCode As New Text.StringBuilder
        Dim ds As DataSet
        Dim sbResults As New Text.StringBuilder

        'get trigger type code
        drTriggerType = GetTriggerTypeDataReader(TriggerTypeID)
        drTriggerType.Read()

        'build sql code
        If Not IsDBNull(drTriggerType.Item("IntroCode")) Then sbCode.AppendFormat(drTriggerType.Item("IntroCode"), RespondentID, ScriptScreenID)
        If Not IsDBNull(TriggerCode) Then sbCode.AppendFormat(TriggerCode, RespondentID, ScriptScreenID, UserID)
        If Not IsDBNull(drTriggerType.Item("ExitCode")) Then sbCode.AppendFormat(drTriggerType.Item("ExitCode"), RespondentID, ScriptScreenID)

        'clean up data readers
        drTriggerType.Close()
        drTriggerType = Nothing

        'substitute {0} for respondent id

        'execute generated code
        Try
            sbResults.Append(RunTriggerCode(sbCode.ToString))

            'log trigger success
            LogTrigger(TriggerID, RespondentID, ScriptScreenID, True)

        Catch
            'log trigger failure
            LogTrigger(TriggerID, RespondentID, ScriptScreenID, False)
            Return ""

        End Try

        sbResults.Append(RunDependentTriggers(TriggerID, RespondentID, ScriptScreenID, RunCriteria))

        Return sbResults.ToString

    End Function

    Private Function RunTriggerCode(ByVal TriggerCode As String) As String
        Dim sResult As String = ""
        Dim rx As Text.RegularExpressions.Regex

        If TriggerCode.Length > 0 Then
            If TriggerCode.Chars(0) = "%" Then
                'trigger command
                sResult = TriggerCode.Substring(1)

            Else
                'sql code
                If IsNothing(DBTransaction) Then
                    sResult = SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, CommandType.Text, TriggerCode)
                Else
                    sResult = SqlHelper.ExecuteScalar(DBTransaction, CommandType.Text, TriggerCode)
                End If

            End If
        End If

        Return String.Format("{0} ", sResult)

    End Function

    Public Function VerifyTriggerCode(ByVal TriggerCode As String) As Boolean
        If TriggerCode.Length > 0 Then
            If TriggerCode.Chars(0) = "%" Then
                Return True

            Else
                Try
                    'check code againt sql server
                    SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.Text, _
                        String.Format("SET PARSEONLY ON {0}", String.Format(TriggerCode, 1, 1, 1)))

                Catch ex As Exception
                    Me._sErrorMsg = ex.Message

                Finally
                    SqlHelper.ExecuteNonQuery(DMI.DataHandler.sConnection, CommandType.Text, "SET PARSEONLY OFF")

                End Try

                If Me.ErrMsg.Length > 0 Then
                    Return False
                Else
                    Return True
                End If

            End If
        End If

        Me._sErrorMsg = "Trigger code cannot be blank"
        Return False

    End Function

    Private Function RunDependentTriggers(ByVal TriggerID As Integer, ByVal RespondentID As Integer, ByVal ScriptScreenID As Integer, ByVal RunCriteria As Boolean) As String
        Dim drTrigger As SqlClient.SqlDataReader
        Dim sbResults As New Text.StringBuilder
        'check if there are other triggers to run, then execute self
        drTrigger = GetDependentTriggersDataReader(TriggerID, RespondentID, ScriptScreenID, -7777, -7777)
        Do Until Not drTrigger.Read
            sbResults.Append(RunTrigger(CInt(drTrigger.Item("TriggerID")), RespondentID, ScriptScreenID, RunCriteria))

        Loop
        drTrigger.Close()
        drTrigger = Nothing

        Return sbResults.ToString

    End Function

    Private Function GetTriggerDataReader(ByVal iTriggerID As Integer) As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = String.Format("SELECT * FROM Triggers WHERE TriggerID = {0}", iTriggerID)
        Return SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Private Function GetTriggerTypeDataReader(ByVal iTriggerTypeID As Integer) As SqlClient.SqlDataReader
        Dim sSQL As String

        sSQL = String.Format("SELECT * FROM TriggerTypes WHERE TriggerTypeID = {0}", iTriggerTypeID)
        Return SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sSQL)

    End Function

    Private Function CheckCriteria(ByVal iCriteriaID As Integer, ByVal iRespondentID As Integer) As Boolean
        Dim sSQL As String = String.Format("SELECT dbo.DoesRespondentMatchCriteria({0},{1})", iCriteriaID, iRespondentID)
        Dim result As Integer

        If IsNothing(DBTransaction) Then
            result = CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sSQL))
        Else
            result = CInt(SqlHelper.ExecuteScalar(DBTransaction, CommandType.Text, sSQL))
        End If

        If result = 1 Then Return True

        Return False

    End Function

    Private Function GetDependentTriggersDataReader(ByVal iTriggerID As Integer, ByVal iValue1 As Integer, ByVal iValue2 As Integer, ByVal iValue3 As Integer, ByVal iValue4 As Integer) As SqlClient.SqlDataReader

        If IsNothing(DBTransaction) Then
            Return SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.StoredProcedure, _
                "spGetListOfDependantTriggersToRun", _
                New SqlClient.SqlParameter("@triggerid", iTriggerID), _
                New SqlClient.SqlParameter("@value1", iValue1), _
                New SqlClient.SqlParameter("@value2", iValue2), _
                New SqlClient.SqlParameter("@value3", iValue3), _
                New SqlClient.SqlParameter("@value4", iValue4))
        Else
            Return SqlHelper.ExecuteReader(DBTransaction, CommandType.StoredProcedure, _
                "spGetListOfDependantTriggersToRun", _
                New SqlClient.SqlParameter("@triggerid", iTriggerID), _
                New SqlClient.SqlParameter("@value1", iValue1), _
                New SqlClient.SqlParameter("@value2", iValue2), _
                New SqlClient.SqlParameter("@value3", iValue3), _
                New SqlClient.SqlParameter("@value4", iValue4))

        End If


    End Function

    Private Sub LogTrigger(ByVal TriggerID As Integer, ByVal RespondentID As Integer, ByVal ScriptScreenID As Integer, ByVal Success As Boolean)
        Dim iSuccess As Integer

        If Success Then iSuccess = 1 Else iSuccess = 0

        'log trigger success
        If IsNothing(DBTransaction) Then
            SqlHelper.ExecuteNonQuery(_oConn, CommandType.StoredProcedure, _
                "spLogTrigger", _
                New SqlClient.SqlParameter("@triggerID", TriggerID), _
                New SqlClient.SqlParameter("@value1", RespondentID), _
                New SqlClient.SqlParameter("@value2", ScriptScreenID), _
                New SqlClient.SqlParameter("@value3", DBNull.Value), _
                New SqlClient.SqlParameter("@value4", DBNull.Value), _
                New SqlClient.SqlParameter("@successFlag", iSuccess), _
                New SqlClient.SqlParameter("@parameterText", ""))
        Else
            SqlHelper.ExecuteNonQuery(DBTransaction, CommandType.StoredProcedure, _
                "spLogTrigger", _
                New SqlClient.SqlParameter("@triggerID", TriggerID), _
                New SqlClient.SqlParameter("@value1", RespondentID), _
                New SqlClient.SqlParameter("@value2", ScriptScreenID), _
                New SqlClient.SqlParameter("@value3", DBNull.Value), _
                New SqlClient.SqlParameter("@value4", DBNull.Value), _
                New SqlClient.SqlParameter("@successFlag", iSuccess), _
                New SqlClient.SqlParameter("@parameterText", ""))

        End If

    End Sub
#End Region

End Class
