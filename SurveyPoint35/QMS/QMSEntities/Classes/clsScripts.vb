Option Explicit On
Option Strict On

Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Enum qmsScriptType As Integer
    DataEntry = 1
    CATI = 2
    Reminder = 3
    Web = 4
End Enum

Public Class clsScripts
    Inherits DMI.clsDBEntity2

    Private _oSurveys As clsSurveys
    Private _oScriptScreens As clsScriptScreens
    Private _iSurveyID As Integer
    Private _iUserID As Integer = 0

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        Me.FillScriptTypes()
        Me.FillSurveyNames(drCriteria)
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsScripts.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsScripts.SearchRow)

        'Primary key criteria
        If Not dr.IsScriptIDNull Then sbSQL.AppendFormat("ScriptID = {0} AND ", dr.ScriptID)
        'survey criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'script type criteria
        If Not dr.IsScriptTypeIDNull Then sbSQL.AppendFormat("ScriptTypeID = {0} AND ", dr.ScriptTypeID)
        'keyword criteria
        If Not dr.IsKeywordNull Then sbSQL.AppendFormat("Name + Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Scripts ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Scripts", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", SqlDbType.Int, 4, "ScriptID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsScripts
        _dtMainTable = _ds.Tables("Scripts")
        _sDeleteFilter = "ScriptID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Scripts", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", SqlDbType.Int, 4, "ScriptID"))
        oCmd.Parameters("@ScriptID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptTypeID", SqlDbType.Int, 4, "ScriptTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 1000, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CompletenessLevel", SqlDbType.Decimal, 9, "CompletenessLevel"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FollowSkips", SqlDbType.TinyInt, 1, "FollowSkips"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CalcCompleteness", SqlDbType.TinyInt, 1, "CalcCompleteness"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DefaultScript", SqlDbType.TinyInt, 1, "DefaultScript"))
        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ScriptID") = iEntityID
    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Scripts", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", SqlDbType.Int, 4, "ScriptID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptTypeID", SqlDbType.Int, 4, "ScriptTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Name", SqlDbType.VarChar, 100, "Name"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Description", SqlDbType.VarChar, 1000, "Description"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CompletenessLevel", SqlDbType.Decimal, 9, "CompletenessLevel"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FollowSkips", SqlDbType.TinyInt, 1, "FollowSkips"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CalcCompleteness", SqlDbType.TinyInt, 1, "CalcCompleteness"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DefaultScript0", SqlDbType.TinyInt, 1, "DefaultScript"))
        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)

        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("CompletenessLevel") = 100D
        dr.Item("SurveyID") = _iSurveyID
        dr.Item("DefaultScript") = 0
        dr.Item("ScriptTypeID") = 1
        dr.Item("CalcCompleteness") = 1
        dr.Item("FollowSkips") = 1

    End Sub

#End Region

    Public Shared Function Copy(ByVal iScriptID As Integer) As Integer
        Dim iNewScriptID As Integer

        iNewScriptID = CInt(SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, _
                  CommandType.StoredProcedure, "copy_Script", _
                  New SqlClient.SqlParameter("@fromScriptID", iScriptID)))

        'Return new script id
        Return iNewScriptID
    End Function

    Public Function GenerateScript(ByVal iSurveyID As Integer) As Integer
        Dim iScriptID As Integer

        iScriptID = CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.StoredProcedure, "generate_Script", _
            New SqlClient.SqlParameter("@SurveyID", iSurveyID)))

        Return iScriptID

    End Function

    Public ReadOnly Property ScriptsTable() As dsScripts.ScriptsDataTable
        Get
            Return CType(Me._ds.Tables("Scripts"), dsScripts.ScriptsDataTable)
        End Get
    End Property

    Public Property AuthorUserID() As Integer
        Get
            Return _iUserID
        End Get
        Set(ByVal Value As Integer)
            _iUserID = Value
        End Set
    End Property


#Region "ScriptType Lookup"
    Public Sub FillScriptTypes()
        DMI.DataHandler.GetDataTable(Me._oConn, Me.ScriptTypesTable, "SELECT * FROM ScriptTypes")
    End Sub

    Public Function ScriptTypesTable() As dsScripts.ScriptTypesDataTable
        Return CType(Me._ds.Tables("ScriptTypes"), dsScripts.ScriptTypesDataTable)
    End Function

#End Region

#Region "Survey Lookup"
    Public Sub FillSurveyNames(ByVal drCriteria As DataRow)
        Dim dr1 As dsScripts.SearchRow
        Dim dr2 As dsSurveys.SearchRow

        dr1 = CType(drCriteria, dsScripts.SearchRow)
        dr2 = CType(Surveys.NewSearchRow, dsSurveys.SearchRow)

        If Not dr1.IsSurveyIDNull Then dr2.SurveyID = dr1.SurveyID

        Surveys.FillMain(CType(dr2, DataRow))
        Surveys.MainDataTable.DefaultView.Sort = "Name"

        Surveys.Close()
        _oSurveys = Nothing

        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Sub FillSurveyNames(ByVal iSurveyID As Integer)
        Dim dr As DataRow

        dr = Me.NewSearchRow
        dr.Item("SurveyID") = iSurveyID
        Me.FillSurveyNames(dr)

        dr = Nothing
    End Sub

    <Obsolete("use SurveyTable")> _
    Public Function SurveyNamesTable() As DataTable
        Return Me._ds.Tables("Surveys")
    End Function

    Public ReadOnly Property SurveysTable() As DataTable
        Get
            Return Me._ds.Tables("Surveys")
        End Get
    End Property

    Public ReadOnly Property Surveys() As clsSurveys
        Get
            If IsNothing(_oSurveys) Then
                _oSurveys = New clsSurveys(_oConn)
                _oSurveys.MainDataTable = SurveysTable

            End If

            Return _oSurveys

        End Get
    End Property

    Public Property SurveyID() As Integer
        Get
            Return _iSurveyID

        End Get
        Set(ByVal Value As Integer)
            _iSurveyID = Value

        End Set
    End Property
#End Region

#Region "Script Screens"
    Public ReadOnly Property ScriptScreens() As clsScriptScreens
        Get
            If IsNothing(_oScriptScreens) Then
                _oScriptScreens = New clsScriptScreens(_oConn)
                _oScriptScreens.MainDataTable = ScriptScreensTable

            End If

            Return _oScriptScreens

        End Get
    End Property

    Public ReadOnly Property ScriptScreensTable() As DataTable
        Get
            Return Me._ds.Tables("ScriptScreens")

        End Get
    End Property

    Public Sub FillScriptScreens(ByVal drCriteria As DataRow)
        Dim dr1 As dsScripts.SearchRow
        Dim dr2 As dsScriptScreens.SearchRow

        dr1 = CType(drCriteria, dsScripts.SearchRow)
        dr2 = CType(ScriptScreens.NewSearchRow, dsScriptScreens.SearchRow)

        If Not dr1.IsScriptIDNull Then dr2.ScriptID = dr1.ScriptID

        ScriptScreens.FillMain(CType(dr2, DataRow))

        dr1 = Nothing
        dr2 = Nothing

    End Sub

#Region "Script Screen Calculation Types"
    Public Sub FillCalculationTypes()
        DMI.DataHandler.GetDataTable(Me._oConn, Me.CalculationTypesTable, "SELECT * FROM CalculationTypes")
    End Sub

    Public ReadOnly Property CalculationTypesTable() As DataTable
        Get
            Return _ds.Tables("CalculationTypes")

        End Get
    End Property
#End Region

#End Region

    Public Shared Function GetInputScripts(ByVal oConn As SqlClient.SqlConnection, ByVal iInputMode As qmsInputMode, ByVal iRespondentID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New Text.StringBuilder
        Dim sScriptTypeID As String = clsInputMode.Create(iInputMode).ScriptTypeIDList

        sbSQL.Append("SELECT Scripts.ScriptID, Scripts.Name, Scripts.DefaultScript ")
        sbSQL.Append("FROM Respondents INNER JOIN SurveyInstances ON Respondents.SurveyInstanceID = SurveyInstances.SurveyInstanceID INNER JOIN ")
        sbSQL.Append("Scripts ON SurveyInstances.SurveyID = Scripts.SurveyID ")
        sbSQL.AppendFormat("WHERE Respondents.RespondentID = {0} AND Scripts.ScriptTypeID IN ({1}) ", iRespondentID, sScriptTypeID)
        sbSQL.Append("ORDER BY Scripts.DefaultScript DESC, Scripts.Name")

        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, sbSQL.ToString)

    End Function

    Public Shared Function GetInputScriptsForRespondent(ByVal Connection As SqlClient.SqlConnection, ByVal iInputMode As qmsInputMode, ByVal RespondentID As Integer) As SqlClient.SqlDataReader
        Dim sScriptTypeID As String = clsInputMode.Create(iInputMode).ScriptTypeIDList

        If iInputMode = qmsInputMode.VIEW AndAlso iInputMode = qmsInputMode.READ_ONLY Then
            Return GetInputScriptsForRespondent(Connection, sScriptTypeID, RespondentID)
        Else
            Return GetDefaultScriptForRespondent(Connection, sScriptTypeID, RespondentID)
        End If

    End Function

    Public Shared Function GetInputScriptsForRespondent(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptTypeIDList As String, ByVal RespondentID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT x.ScriptID, x.Name ")
        sbSQL.Append("FROM (SELECT s.ScriptID, s.Name, s.DefaultScript, s.ScriptTypeID, si.SurveyInstanceID ")
        sbSQL.Append("FROM SurveyInstances si INNER JOIN Respondents r ON si.SurveyInstanceID = r.SurveyInstanceID RIGHT OUTER JOIN ")
        sbSQL.Append("Scripts s ON si.SurveyID = s.SurveyID ")
        sbSQL.AppendFormat("WHERE (r.RespondentID = {0}) AND s.ScriptTypeID IN ({1})) x LEFT OUTER JOIN ", RespondentID, ScriptTypeIDList)
        sbSQL.Append("SurveyInstanceDefaultScripts sids ON x.SurveyInstanceID = sids.SurveyInstanceID AND x.ScriptID = sids.ScriptID ")
        sbSQL.Append("ORDER BY ISNULL(sids.SurveyInstanceScriptID, x.DefaultScript) DESC")

        Return SqlHelper.ExecuteReader(Connection, CommandType.Text, sbSQL.ToString)

    End Function

    Public Shared Function GetDefaultScriptForRespondent(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptTypeIDList As String, ByVal RespondentID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT TOP 1 x.ScriptID, x.Name ")
        sbSQL.Append("FROM (SELECT s.ScriptID, s.Name, s.DefaultScript, s.ScriptTypeID, si.SurveyInstanceID ")
        sbSQL.Append("FROM SurveyInstances si INNER JOIN Respondents r ON si.SurveyInstanceID = r.SurveyInstanceID RIGHT OUTER JOIN ")
        sbSQL.Append("Scripts s ON si.SurveyID = s.SurveyID ")
        sbSQL.AppendFormat("WHERE (r.RespondentID = {0}) AND s.ScriptTypeID IN ({1})) x LEFT OUTER JOIN ", RespondentID, ScriptTypeIDList)
        sbSQL.Append("SurveyInstanceDefaultScripts sids ON x.SurveyInstanceID = sids.SurveyInstanceID AND x.ScriptID = sids.ScriptID ")
        sbSQL.Append("ORDER BY ISNULL(sids.SurveyInstanceScriptID, x.DefaultScript) DESC")

        Return SqlHelper.ExecuteReader(Connection, CommandType.Text, sbSQL.ToString)

    End Function

    Public Shared Function GetInputScriptsForRespondent(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptTypeID As Integer, ByVal RespondentID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT x.ScriptID, x.Name ")
        sbSQL.Append("FROM (SELECT Scripts.ScriptID, Scripts.Name, Scripts.DefaultScript, SurveyInstances.SurveyInstanceID ")
        sbSQL.Append("FROM SurveyInstances INNER JOIN Respondents ON SurveyInstances.SurveyInstanceID = Respondents.SurveyInstanceID RIGHT OUTER JOIN ")
        sbSQL.Append("Scripts ON SurveyInstances.SurveyID = Scripts.SurveyID ")
        sbSQL.AppendFormat("WHERE (Respondents.RespondentID = {0}) AND Scripts.ScriptTypeID = {1}) x LEFT OUTER JOIN ", RespondentID, ScriptTypeID)
        sbSQL.Append("SurveyInstanceDefaultScripts sids ON x.SurveyInstanceID = sids.SurveyInstanceID ")
        sbSQL.AppendFormat("WHERE (sids.ScriptTypeID = {0}) ", ScriptTypeID)
        sbSQL.Append("ORDER BY ISNULL(sids.ScriptID, x.DefaultScript) DESC")

        Return SqlHelper.ExecuteReader(Connection, CommandType.Text, sbSQL.ToString)

    End Function

    Public Shared Function GetInputScriptsForSurvey(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptTypeID As Integer, ByVal SurveyID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT ScriptID, Name, DefaultScript ")
        sbSQL.AppendFormat("FROM Scripts WHERE (SurveyID = {0}) ", SurveyID)
        sbSQL.Append("ORDER BY DefaultScript DESC, Name")

        Return SqlHelper.ExecuteReader(Connection, CommandType.Text, sbSQL.ToString)

    End Function

    Public Shared Function GetInputScriptsForSurveyInstance(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptTypeID As Integer, ByVal SurveyInstanceID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New Text.StringBuilder

        sbSQL.Append("SELECT Scripts.ScriptID, Scripts.Name, Scripts.DefaultScript ")
        sbSQL.Append("FROM Scripts INNER JOIN SurveyInstances ON Scripts.SurveyID = SurveyInstances.SurveyID ")
        sbSQL.AppendFormat("WHERE (SurveyInstances.SurveyInstanceID = {0}) AND (Scripts.ScriptTypeID = {1}) ", SurveyInstanceID, ScriptTypeID)
        sbSQL.Append("ORDER BY Scripts.DefaultScript DESC, Scripts.Name")

        Return SqlHelper.ExecuteReader(Connection, CommandType.Text, sbSQL.ToString)

    End Function

    Public Sub ClearAll()
        Dim bEnforce As Boolean = Me.EnforceConstraints
        Me.EnforceConstraints = False

        Me._ds.Tables("Search").Clear()
        Me.ClearMainTable()
        Me.ScriptTypesTable.Clear()
        Me.SurveysTable.Clear()

        Me.EnforceConstraints = bEnforce
    End Sub

    Public Shared Function GetScriptName(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptID As Integer) As String
        Return SqlHelper.ExecuteScalar(Connection, CommandType.Text, _
            "SELECT Name FROM Scripts WHERE ScriptID = @ScriptID", _
            New SqlClient.SqlParameter("@ScriptID", ScriptID)).ToString

    End Function

    Public Shared Function GetDefaultScript(ByVal connection As SqlClient.SqlConnection, ByVal surveyInstanceID As Integer, ByVal scriptTypeID As qmsScriptType) As Integer
        Dim sql As String
        Dim result As Object
        sql = String.Format("SELECT ScriptID FROM SurveyInstanceDefaultScripts WHERE (SurveyInstanceID = {0}) AND (ScriptTypeID = {1})", surveyInstanceID, scriptTypeID)
        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.DataHandler.NULLRECORDID
    End Function

    Public Shared Function GetDataEntryScript(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As SqlClient.SqlDataReader
        Dim sql As String
        sql = String.Format("SELECT * FROM Scripts WHERE (ScriptID IN (SELECT CAST(EventParameters AS int) AS ScriptID FROM EventLog el WHERE (EventDate IN (SELECT MAX(EventDate) AS EventDate FROM EventLog WHERE (EventID = 2011) AND (RespondentID = {0}))) AND (EventID = 2011) AND (RespondentID = {0})))", respondentID)
        Return SqlHelper.ExecuteReader(connection, CommandType.Text, sql)
    End Function

End Class
