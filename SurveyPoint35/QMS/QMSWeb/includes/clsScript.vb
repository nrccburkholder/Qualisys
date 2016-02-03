Public Enum qmsQuestionType
    SingleSelect = 1
    MultipleSelect = 2
    OpenAnswer = 3
    Numeric = 4
    Datetime = 5

End Enum

Public Enum tblScripts
    ScriptID = 0
    SurveyID = 1
    ScriptTypeID = 2
    Name = 3
    Description = 4
    CompletenessLevel = 5
    FollowSkips = 6
    CalcCompleteness = 7
    DefaultScript = 8
    SurveyName = 9
    ScriptTypeName = 10
    Keyword = 11

End Enum

<Obsolete("use QMS.clsScripts")> _
Public Class clsScript
    Inherits clsDBEntity

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Private _iSurveyID As Integer

    Private _sKeyword As String

    Default Public Overloads Property Details(ByVal eField As tblScripts) As Object
        Get
            If eField = tblScripts.Keyword Then
                Return Me._sKeyword

            Else
                Return MyBase.Details(eField.ToString)

            End If

        End Get

        Set(ByVal Value As Object)
            If eField = tblScripts.ScriptID Then
                Me._iEntityID = Value

            ElseIf eField = tblScripts.SurveyID Then
                Me._iSurveyID = Value

            ElseIf eField = tblScripts.Keyword Then

                Me._sKeyword = Value
                Return

            End If

            MyBase.Details(eField.ToString) = Value

        End Set

    End Property

    Public Overrides Property DataSet() As System.Data.DataSet
        Get
            Return Me._dsEntity

        End Get

        Set(ByVal Value As DataSet)
            Me._dsEntity = Value

            If Me._dsEntity.Tables.IndexOf(Me._sTableName) > -1 Then
                If Me._dsEntity.Tables(Me._sTableName).Rows.Count > 0 Then
                    Me._iEntityID = Me.Details(tblScripts.ScriptID)
                    Me._iSurveyID = Me.Details(tblScripts.SurveyID)

                End If
            End If
        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()
        'Define table
        Me._sTableName = "Scripts"

        'INSERT SQL for Users table
        Me._sInsertSQL = "INSERT INTO Scripts (SurveyID, ScriptTypeID, Name, Description, CompletenessLevel, FollowSkips, CalcCompleteness, DefaultScript) VALUES({1},{2},{3},{4},{5},{6},{7},{8}) "

        'UPDATE SQL for Users table
        Me._sUpdateSQL = "UPDATE Scripts SET SurveyID = {1}, ScriptTypeID = {2}, Name = {3}, Description = {4}, CompletenessLevel = {5}, FollowSkips = {6}, CalcCompleteness = {7}, DefaultScript = {8} "
        Me._sUpdateSQL &= "WHERE ScriptID = {0} "

        'DELETE SQL for Users table
        Me._sDeleteSQL = "DELETE FROM ScriptScreenCategories WHERE ScriptScreenID IN "
        Me._sDeleteSQL &= "(SELECT ScriptScreenID FROM ScriptScreens WHERE ScriptID = {0}); " & vbCrLf
        Me._sDeleteSQL &= "DELETE FROM ScriptScreens WHERE ScriptID = {0}; " & vbCrLf
        Me._sDeleteSQL &= "DELETE FROM Scripts WHERE ScriptID = {0} "

        'SELECT SQL for Users table
        Me._sSelectSQL = "SELECT scr.ScriptID, scr.ScriptTypeID, scr.SurveyID, scr.Name, scr.Description, "
        Me._sSelectSQL &= "scr.CompletenessLevel, scr.FollowSkips, scr.CalcCompleteness, scr.DefaultScript, "
        Me._sSelectSQL &= "s.Name AS SurveyName, st.Name AS ScriptTypeName "
        Me._sSelectSQL &= "FROM Scripts scr INNER JOIN Surveys s ON scr.SurveyID = s.SurveyID "
        Me._sSelectSQL &= "INNER JOIN ScriptTypes st ON scr.ScriptTypeID = st.ScriptTypeID "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblScripts.ScriptID), _
                            Details(tblScripts.SurveyID), _
                            Details(tblScripts.ScriptTypeID), _
                            DMI.DataHandler.QuoteString(Details(tblScripts.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblScripts.Description)), _
                            Details(tblScripts.CompletenessLevel), _
                            Math.Abs(Details(tblScripts.FollowSkips)), _
                            Math.Abs(Details(tblScripts.CalcCompleteness)), _
                            Math.Abs(Details(tblScripts.DefaultScript)))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblScripts.ScriptID), _
                            Details(tblScripts.SurveyID), _
                            Details(tblScripts.ScriptTypeID), _
                            DMI.DataHandler.QuoteString(Details(tblScripts.Name)), _
                            DMI.DataHandler.QuoteString(Details(tblScripts.Description)), _
                            Details(tblScripts.CompletenessLevel), _
                            Math.Abs(Details(tblScripts.FollowSkips)), _
                            Math.Abs(Details(tblScripts.CalcCompleteness)), _
                            Math.Abs(Details(tblScripts.DefaultScript)))

    End Function

    Protected Overrides Function VerifyInsert() As String
        Dim sSQL As String = ""

        'Is submitted script the default
        If Me.Details(tblScripts.DefaultScript) <> 0 Then
            sSQL = String.Format("UPDATE Scripts SET DefaultScript = 0 WHERE SurveyID = {0} AND ScriptTypeID = {1}", Me.Details(tblScripts.SurveyID), Me.Details(tblScripts.ScriptTypeID))
            DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        End If

        Return ""

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL = String.Format("scr.ScriptID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Not IsDBNull(Details(tblScripts.SurveyID)) Then
                If Details(tblScripts.SurveyID) > 0 Then
                    sWHERESQL = String.Format("scr.SurveyID = {0} AND ", Details(tblScripts.SurveyID))
                End If

            End If

            If Not IsDBNull(Details(tblScripts.ScriptTypeID)) Then
                If Details(tblScripts.ScriptTypeID) > 0 Then
                    sWHERESQL = String.Format("scr.ScriptTypeID = {0} AND ", Details(tblScripts.ScriptTypeID))
                End If

            End If

            If Details(tblScripts.Name).ToString.Length > 0 Then
                sWHERESQL &= String.Format("scr.Name LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblScripts.Name)))

            End If

            If Details(tblScripts.Description).ToString.Length > 0 Then
                sWHERESQL &= String.Format("scr.Description LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblScripts.Description)))

            End If

            If Details(tblScripts.CompletenessLevel).ToString.Length > 0 Then
                sWHERESQL &= String.Format("scr.CompletenessLevel = {0} AND ", Details(tblScripts.CompletenessLevel))

            End If

            If Details(tblScripts.FollowSkips).ToString.Length > 0 Then
                sWHERESQL &= String.Format("scr.FollowSkips = {0} AND ", Math.Abs(Details(tblScripts.FollowSkips)))

            End If

            If Details(tblScripts.Keyword) <> "" Then
                sWHERESQL &= String.Format("scr.Name + ' ' + scr.Description LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblScripts.Keyword)))
            End If

        End If

        If sWHERESQL <> "" Then
            sWHERESQL = "WHERE " & sWHERESQL
            sWHERESQL = Left(sWHERESQL, Len(sWHERESQL) - 4)

        End If

        Return Me._sSelectSQL & sWHERESQL

    End Function

    'Builds delete SQL from dataset
    Protected Overrides Function GetDeleteSQL() As String

        Return String.Format(Me._sDeleteSQL, Details(tblScripts.ScriptID))

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("ScriptID") = 0
        dr.Item("SurveyID") = Me._iSurveyID
        dr.Item("ScriptTypeID") = 1
        dr.Item("Name") = ""
        dr.Item("Description") = ""
        dr.Item("CompletenessLevel") = 0
        dr.Item("FollowSkips") = 1
        dr.Item("CalcCompleteness") = 1
        dr.Item("DefaultScript") = 0

    End Sub

    Protected Overrides Function Create() As DataSet
        Dim ds As DataSet
        Dim sSQL As String

        If Not IsDBNull(Details(tblScripts.SurveyID)) Then
            If Details(tblScripts.SurveyID) > 0 Then
                sSQL = "SELECT 0 AS ScriptID, SurveyID, 1 AS ScriptTypeID, '' AS Name, '' AS Description, "
                sSQL &= "1 AS QuestionTypeID, 0 AS ItemOrder, '' AS QuestionTypeName, 1 AS CalcCompleteness, "
                sSQL &= "100 AS CompletenessLevel, 1 AS FollowSkips, 0 AS DefaultScript, Name AS SurveyName "
                sSQL &= "FROM Surveys WHERE SurveyID = {0} "
                sSQL = String.Format(sSQL, Details(tblScripts.SurveyID))

                If Not Me._dsEntity Is Nothing Then
                    Me._dsEntity.Clear()
                End If

                If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, Me._sTableName) Then
                    Me._iEntityID = -1

                    Return Me._dsEntity

                End If

            End If

        End If

        Return MyBase.Create()

    End Function

    Public Function GetScriptScreens() As DataTable
        Dim ss As New clsScriptScreen(Me.ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("ScriptScreens") > -1 Then
            Me._dsEntity.Tables.Remove("ScriptScreens")

        End If

        ss.Details(tblScriptScreens.ScriptID) = Me._iEntityID
        dt = ss.GetDetails().Tables("ScriptScreens").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

    Public Sub ResortScreens()
        Dim sSQL As String = ""
        Dim dv As DataView
        Dim drv As DataRowView
        Dim iItemOrder As Integer = 1

        dv = Me._dsEntity.Tables("ScriptScreens").DefaultView
        dv.Sort = "ItemOrder"

        For Each drv In dv.Table.DefaultView
            sSQL &= String.Format("UPDATE ScriptScreens SET ItemOrder = {1} WHERE ScriptScreenID = {0}; " & vbCrLf, _
                                    drv.Item("ScriptScreenID"), iItemOrder)
            drv.Item("ItemOrder") = iItemOrder

            iItemOrder += 1

        Next

        If sSQL.Length > 0 Then
            DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        End If

    End Sub

    Public Sub ResortScreens(ByVal ht As Hashtable)
        Dim dr As DataRow
        Dim iScriptScreenID As Integer

        For Each dr In Me._dsEntity.Tables("ScriptScreens").Rows
            iScriptScreenID = dr.Item("ScriptScreenID")
            dr.Item("ItemOrder") = ht.Item(iScriptScreenID)

        Next

        Me.ResortScreens()

    End Sub

    Public ReadOnly Property ScreenCount() As Integer
        Get

            If Me._dsEntity.Tables.IndexOf("ScriptScreens") = -1 Then
                Me.GetScriptScreens()
            End If

            Return Me._dsEntity.Tables("ScriptScreens").Rows.Count

        End Get

    End Property

    Public Function GetScriptTypes() As DataTable
        Dim sSQL As String

        If Me._dsEntity.Tables.IndexOf("ScriptTypes") > -1 Then
            Me._dsEntity.Tables.Remove("ScriptTypes")

        End If

        sSQL = "SELECT ScriptTypeID, Name FROM ScriptTypes"

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, "ScriptTypes") Then
            Return Me._dsEntity.Tables("ScriptTypes")

        End If

    End Function

    Public Function GenerateScript() As Integer
        Dim iSurveyID As Integer
        Dim iScriptID As Integer
        Dim sSQL As String

        iSurveyID = Me.Details(tblScripts.SurveyID)

        Me.Details(tblScripts.ScriptID) = 0
        Me.Details(tblScripts.Name) = String.Format("Auto Generated Script {0}", Now())
        Me.Details(tblScripts.ScriptTypeID) = 1
        Me.Details(tblScripts.CompletenessLevel) = 100
        Me.Details(tblScripts.CalcCompleteness) = 1

        iScriptID = Me.Submit
        Me.Details(tblScripts.ScriptID) = iScriptID

        'build insert sql for script screens
        sSQL &= "INSERT INTO ScriptScreens (ScriptID, SurveyQuestionID, Title, Text, CalculationTypeID, ItemOrder) "
        sSQL &= String.Format("SELECT {0} AS ScriptID, sq.SurveyQuestionID, q.ShortDesc, q.Text, 1 AS CalculationTypeID, sq.ItemOrder ", iScriptID)
        sSQL &= "FROM SurveyQuestions sq INNER JOIN Questions q ON sq.QuestionID = q.QuestionID "
        sSQL &= String.Format("WHERE sq.SurveyID = {0} ORDER BY sq.ItemOrder; ", iSurveyID)

        'build insert sql for script screen categories
        sSQL &= "INSERT INTO ScriptScreenCategories (ScriptScreenID, AnswerCategoryID, JumpToScriptScreenID, Text) "
        sSQL &= "SELECT ss.ScriptScreenID, ac.AnswerCategoryID, 0 AS JumpToScriptScreenID, ac.AnswerText AS Text "
        sSQL &= "FROM ScriptScreens ss INNER JOIN "
        sSQL &= "SurveyQuestions sq ON ss.SurveyQuestionID = sq.SurveyQuestionID INNER JOIN "
        sSQL &= "Questions q ON sq.QuestionID = q.QuestionID INNER JOIN "
        sSQL &= "AnswerCategories ac ON q.QuestionID = ac.QuestionID "
        sSQL &= String.Format("WHERE(ss.ScriptID = {0}) ORDER BY ss.ScriptScreenID, ac.AnswerCategoryID ", iScriptID)

        If DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL) Then
            Return iScriptID

        End If

        Return 0

    End Function

    Public Shared Function Copy(ByVal iScriptID As Integer) As Integer
        Dim iNewScriptID As Integer

        iNewScriptID = DMI.SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, _
                                    CommandType.StoredProcedure, "spCopyScript", _
                                    New SqlClient.SqlParameter("@fromScriptID", iScriptID))

        'Return new script id
        Return iNewScriptID

    End Function

    Public Shared Function GetInputScripts(ByVal iInputMode As QMS.qmsInputMode, ByVal iRespondentID As Integer) As SqlClient.SqlDataReader
        Dim sbSQL As New StringBuilder()
        Dim sScriptTypeID As String

        Select Case iInputMode
            Case QMS.qmsInputMode.DATAENTRY, QMS.qmsInputMode.VERIFY
                sScriptTypeID = "1"

            Case QMS.qmsInputMode.CATI
                sScriptTypeID = "2"

            Case QMS.qmsInputMode.RCALL
                sScriptTypeID = "3"

            Case Else
                sScriptTypeID = "1,2,3"

        End Select

        sbSQL.Append("SELECT Scripts.ScriptID, Scripts.Name, Scripts.DefaultScript ")
        sbSQL.Append("FROM Respondents INNER JOIN SurveyInstances ON Respondents.SurveyInstanceID = SurveyInstances.SurveyInstanceID INNER JOIN ")
        sbSQL.Append("Scripts ON SurveyInstances.SurveyID = Scripts.SurveyID ")
        sbSQL.AppendFormat("WHERE Respondents.RespondentID = {0} AND Scripts.ScriptTypeID IN ({1}) ", iRespondentID, sScriptTypeID)
        sbSQL.Append("ORDER BY Scripts.DefaultScript DESC, Scripts.Name")

        Return DMI.SqlHelper.ExecuteReader(DMI.DataHandler.sConnection, CommandType.Text, sbSQL.ToString)

    End Function

End Class
