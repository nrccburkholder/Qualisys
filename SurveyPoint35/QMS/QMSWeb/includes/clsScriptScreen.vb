Public Enum tblScriptScreens
    ScriptScreenID = 0
    ScriptID = 1
    SurveyQuestionID = 2
    Title = 3
    Text = 4
    CalculationTypeID = 5
    ItemOrder = 6
    ScriptName = 7
    SurveyID = 8
    SurveyName = 9

End Enum

<Obsolete("use QMS.ScriptScreens")> _
Public Class clsScriptScreen
    Inherits clsDBEntity

    Protected _iScriptID As Integer = 0

    Sub New(Optional ByVal sConn As String = "", Optional ByVal iEntityID As Integer = 0)
        MyBase.New(sConn, iEntityID)

    End Sub

    Default Public Overloads Property Details(ByVal qField As tblScriptScreens) As Object
        Get
            Return MyBase.Details(qField.ToString)

        End Get

        Set(ByVal Value As Object)
            If qField = tblScriptScreens.ScriptScreenID Then
                Me._iEntityID = Value

            ElseIf qField = tblScriptScreens.ScriptID Then
                Me._iScriptID = Value

            End If

            MyBase.Details(qField.ToString) = Value

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
                    Me._iEntityID = Me.Details(tblScriptScreens.ScriptScreenID)
                    Me._iScriptID = Me.Details(tblScriptScreens.ScriptID)

                End If
            End If
        End Set

    End Property

    'Function to provide all class parameters, like _sTableName
    Protected Overrides Sub InitClass()
        'Define table
        Me._sTableName = "ScriptScreens"

        'INSERT SQL for table
        Me._sInsertSQL = "INSERT INTO ScriptScreens (ScriptID, SurveyQuestionID, Title, Text, CalculationTypeID, ItemOrder) "
        Me._sInsertSQL &= "(SELECT {1}, {2}, {3}, {4}, {5}, ISNULL(MAX(ItemOrder),0) + 1 "
        Me._sInsertSQL &= "FROM ScriptScreens "
        Me._sInsertSQL &= "WHERE (ScriptID = {1}))"

        'UPDATE SQL for table
        Me._sUpdateSQL = "UPDATE ScriptScreens SET SurveyQuestionID = {2}, Title = {3}, Text = {4}, CalculationTypeID = {5} "
        Me._sUpdateSQL &= "WHERE ScriptScreenID = {0} "

        'DELETE SQL for table
        Me._sDeleteSQL = "DELETE FROM ScriptScreenCategories WHERE ScriptScreenID = {0}; " & vbCrLf
        Me._sDeleteSQL &= "DELETE FROM ScriptScreens WHERE ScriptScreenID = {0} "

        'SELECT SQL for table
        Me._sSelectSQL = "SELECT ss.ScriptScreenID, ss.ScriptID, ss.SurveyQuestionID, ss.Title, ss.Text, ss.CalculationTypeID, ss.ItemOrder, scr.Name AS ScriptName, scr.SurveyID, "
        Me._sSelectSQL &= "s.Name AS SurveyName, ct.Name AS CalculationTypeName "
        Me._sSelectSQL &= "FROM ScriptScreens ss INNER JOIN "
        Me._sSelectSQL &= "Scripts scr ON ss.ScriptID = scr.ScriptID INNER JOIN "
        Me._sSelectSQL &= "Surveys s ON scr.SurveyID = s.SurveyID INNER JOIN "
        Me._sSelectSQL &= "CalculationTypes ct ON ss.CalculationTypeID = ct.CalculationTypeID "

    End Sub

    'Builds insert SQL from dataset
    Protected Overrides Function GetInsertSQL() As String

        Return String.Format(Me._sInsertSQL, Details(tblScriptScreens.ScriptScreenID), _
                            Details(tblScriptScreens.ScriptID), _
                            DMI.clsUtil.ZeroToNull(Details(tblScriptScreens.SurveyQuestionID)), _
                            DMI.DataHandler.QuoteString(Details(tblScriptScreens.Title)), _
                            DMI.DataHandler.QuoteString(Details(tblScriptScreens.Text)), _
                            Details(tblScriptScreens.CalculationTypeID))

    End Function

    'Builds update SQL from dataset
    Protected Overrides Function GetUpdateSQL() As String

        Return String.Format(Me._sUpdateSQL, Details(tblScriptScreens.ScriptScreenID), _
                            Details(tblScriptScreens.ScriptID), _
                            DMI.clsUtil.ZeroToNull(Details(tblScriptScreens.SurveyQuestionID)), _
                            DMI.DataHandler.QuoteString(Details(tblScriptScreens.Title)), _
                            DMI.DataHandler.QuoteString(Details(tblScriptScreens.Text)), _
                            Details(tblScriptScreens.CalculationTypeID))

    End Function

    'Builds select SQL from dataset for search
    Protected Overrides Function GetSearchSQL() As String
        Dim sWHERESQL As String = ""
        Dim bIdentity As Boolean = False

        If Me._iEntityID > 0 Then
            sWHERESQL &= String.Format("ss.ScriptScreenID = {0} AND ", Me._iEntityID)
            bIdentity = True

        End If

        If Not bIdentity Then

            If Not IsDBNull(Details(tblScriptScreens.ScriptID)) Then
                sWHERESQL &= String.Format("ss.ScriptID = {0} AND ", Details(tblScriptScreens.ScriptID))

            End If

            If Not IsDBNull(Details(tblScriptScreens.SurveyQuestionID)) Then
                If Details(tblScriptScreens.SurveyQuestionID) > 0 Then
                    sWHERESQL &= String.Format("ss.SurveyQuestionID = {0} AND ", Details(tblScriptScreens.SurveyQuestionID))

                End If

            End If

            If Details(tblScriptScreens.Text).ToString.Length > 0 Then
                sWHERESQL &= String.Format("ss.Text LIKE {0} AND ", DMI.DataHandler.QuoteString(Details(tblScriptScreens.Text)))

            End If

            If Not IsDBNull(Details(tblScriptScreens.CalculationTypeID)) Then
                If Details(tblScriptScreens.CalculationTypeID) > 0 Then
                    sWHERESQL &= String.Format("ss.CalculationTypeID = {0} AND ", Details(tblScriptScreens.CalculationTypeID))

                End If

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

        Return String.Format(Me._sDeleteSQL, Details(tblScriptScreens.ScriptScreenID))

    End Function

    'Called by Create method to fill datarow with default values for new record
    Protected Overrides Sub SetRecordDefaults(ByRef dr As DataRow)

        dr.Item("ScriptScreenID") = 0
        dr.Item("ScriptID") = Me._iScriptID
        dr.Item("SurveyQuestionID") = 0
        dr.Item("Title") = ""
        dr.Item("Text") = ""
        dr.Item("CalculationTypeID") = 1
        dr.Item("ItemOrder") = 0

    End Sub

    Protected Overrides Function Create() As DataSet
        Dim ds As DataSet
        Dim sSQL As String

        If Not IsDBNull(Details(tblScriptScreens.ScriptID)) Then
            If Details(tblScriptScreens.ScriptID) > 0 Then
                sSQL = "SELECT 0 AS ScriptScreenID, scr.ScriptID, 0 AS SurveyQuestionID, '' AS Title, '' AS Text, "
                sSQL &= "0 AS CalculationTypeID, 0 AS ItemOrder, scr.SurveyID, scr.Name AS ScriptName, s.Name AS SurveyName "
                sSQL &= "FROM Scripts scr INNER JOIN Surveys s ON scr.SurveyID = s.SurveyID "
                sSQL &= String.Format("WHERE scr.ScriptID = {0} ", Details(tblScriptScreens.ScriptID))

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

    Public Function GetSurveyQuestions() As DataTable
        Dim sSQL As String

        If Me._dsEntity.Tables.IndexOf("SurveyQuestions") > -1 Then
            Me._dsEntity.Tables.Remove("SurveyQuestions")

        End If

        sSQL = "SELECT sq.SurveyQuestionID, CAST(sq.ItemOrder AS varchar) + '. ' + CASE Questions.ShortDesc WHEN '' THEN Questions.Text ELSE Questions.ShortDesc END As QuestionText "
        sSQL &= "FROM Scripts scr INNER JOIN "
        sSQL &= "Surveys s ON scr.SurveyID = s.SurveyID INNER JOIN "
        sSQL &= "SurveyQuestions sq ON s.SurveyID = sq.SurveyID INNER JOIN "
        sSQL &= "Questions ON sq.QuestionID = Questions.QuestionID "
        sSQL &= String.Format("WHERE scr.ScriptID = {0} ", Details(tblScriptScreens.ScriptID))
        sSQL &= "ORDER BY sq.ItemOrder "

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, "SurveyQuestions") Then
            Return Me._dsEntity.Tables("SurveyQuestions")

        End If

    End Function

    Public Function GetCalculationTypes() As DataTable
        Dim sSQL As String

        If Me._dsEntity.Tables.IndexOf("CalculationTypes") > -1 Then
            Me._dsEntity.Tables.Remove("CalculationTypes")

        End If

        sSQL = "SELECT CalculationTypeID, Name FROM CalculationTypes "

        If DMI.DataHandler.GetDS(Me.ConnectionString, Me._dsEntity, sSQL, "CalculationTypes") Then
            Return Me._dsEntity.Tables("CalculationTypes")

        End If

    End Function

    Public Function GetScreenCategories() As DataTable
        Dim ssc As New clsScriptScreenCategories(Me.ConnectionString)
        Dim dt As DataTable

        If Me._dsEntity.Tables.IndexOf("ScriptScreenCategories") > -1 Then
            Me._dsEntity.Tables.Remove("ScriptScreenCategories")

        End If

        ssc.Details(tblScriptScreenCategories.ScriptScreenID) = Me._iEntityID

        dt = ssc.GetDetails().Tables("ScriptScreenCategories").Copy

        Me._dsEntity.Tables.Add(dt)

        Return dt

    End Function

    Public Sub DeleteScreenCategories(Optional ByVal sscid As Integer = -1)
        Dim ssc As clsScriptScreenCategories
        Dim sSQL As String

        If sscid > -1 Then
            ssc = New clsScriptScreenCategories(Me.ConnectionString)
            ssc.Delete(sscid)

        Else
            sSQL = String.Format("DELETE FROM ScriptScreenCategories WHERE ScriptScreenID = {0}", Me._iEntityID)
            DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

        End If

    End Sub

    Public Function GetJumpToList() As DataTable
        Dim sSQL As String
        Dim ds As DataSet
        Dim dr As DataRow

        If Me._dsEntity.Tables.IndexOf("JumpToList") > -1 Then
            Me._dsEntity.Tables.Remove("JumpToList")

        End If

        sSQL = String.Format("SELECT ScriptScreenID, CAST(ItemOrder AS varchar) + ': ' + ISNULL(Title, 'No Title') As Description FROM ScriptScreens WHERE ScriptID = {0} AND ScriptScreenID <> {1} ORDER BY ItemOrder", _
            Me.Details(tblScriptScreens.ScriptID), _
            Me._iEntityID)

        If DMI.DataHandler.GetDS(Me.ConnectionString, ds, sSQL, "JumpToList") Then
            Me._dsEntity.Tables.Add(ds.Tables("JumpToList").Copy)

            dr = Me._dsEntity.Tables("JumpToList").NewRow

            Return Me._dsEntity.Tables("JumpToList")

        End If

    End Function

    Public Sub InitScreenCategories()
        Dim sSQL As String

        Me.DeleteScreenCategories()

        sSQL = "INSERT INTO ScriptScreenCategories (ScriptScreenID, AnswerCategoryID, JumpToScriptScreenID, Text) "
        sSQL &= "SELECT ScriptScreenID, AnswerCategoryID, JumpToScriptScreenID, Text FROM v_ScriptScreenCategories "
        sSQL &= String.Format("WHERE ScriptScreenID = {0}", Me.Details(tblScriptScreens.ScriptScreenID))

        DMI.SqlHelper.ExecuteNonQuery(Me.ConnectionString, CommandType.Text, sSQL)

    End Sub

End Class
