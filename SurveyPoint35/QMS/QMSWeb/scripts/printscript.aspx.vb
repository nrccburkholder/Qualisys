Imports Microsoft.ApplicationBlocks.Data

Partial Class frmPrintScript
    Inherits System.Web.UI.Page

#Region " Web Form Designer Generated Code "

    'This call is required by the Web Form Designer.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()

    End Sub

    'NOTE: The following placeholder declaration is required by the Web Form Designer.
    'Do not delete or move it.
    Private designerPlaceholderDeclaration As System.Object

    Private Sub Page_Init(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
        'CODEGEN: This method call is required by the Web Form Designer
        'Do not modify it using the code editor.
        InitializeComponent()
    End Sub

#End Region

    Public Const SCRIPT_ID_KEY As String = "id"

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Try
            Dim scriptID As Integer = GetScriptID()

            DisplayScriptDetails(scriptID)
            BindScriptScreens(scriptID)

        Catch ex As Exception
            DMI.WebFormTools.Msgbox(Me, ex.Message)

        End Try

    End Sub

    Private Function GetScriptID() As Integer
        If IsNumeric(Request.QueryString(SCRIPT_ID_KEY)) Then
            Return CInt(Request.QueryString(SCRIPT_ID_KEY))
        Else
            Throw New ApplicationException("Script id is not numeric")
        End If

    End Function

    Private Sub DisplayScriptDetails(ByVal scriptID As Integer)
        Dim conn As SqlClient.SqlConnection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        Dim dr As SqlClient.SqlDataReader

        Try
            dr = GetScriptDetails(scriptID, conn)
            If dr.Read Then
                ltSurveyID.Text = dr.Item("SurveyID")
                ltSurveyName.Text = dr.Item("SurveyName")
                ltScriptID.Text = dr.Item("ScriptID")
                ltScriptName.Text = dr.Item("Name")
                ltScriptDesc.Text = dr.Item("Description")
                ltScriptType.Text = dr.Item("ScriptTypeName")
                ltCompleteness.Text = String.Format("{0}%", dr.Item("CompletenessLevel"))
                cbFollowSkips.Checked = (dr.Item("FollowSkips") = 1)
                cbCalculate.Checked = (dr.Item("CalcCompleteness") = 1)
                cbDefaultScript.Checked = (dr.Item("DefaultScript") = 1)

            Else
                Throw New ApplicationException("Script id not found.")
            End If

        Catch ex As Exception
            Throw ex

        Finally
            If Not IsNothing(dr) AndAlso Not dr.IsClosed Then dr.Close()
            If Not IsNothing(conn) Then
                conn.Close()
                conn.Dispose()
            End If

        End Try

    End Sub

    Private Function GetScriptDetails(ByVal scriptID As Integer, ByVal connection As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Dim dr As SqlClient.SqlDataReader
        dr = SqlHelper.ExecuteReader(connection, CommandType.Text, _
            String.Format("SELECT s.*, st.Name AS ScriptTypeName, su.Name AS SurveyName FROM Scripts s INNER JOIN ScriptTypes st ON s.ScriptTypeID = st.ScriptTypeID INNER JOIN Surveys su ON s.SurveyID = su.SurveyID WHERE (s.ScriptID = {0})", scriptID))
        If Not IsNothing(dr) Then
            Return dr
        Else
            Throw New ApplicationException("Invalid script id")
        End If

    End Function

    Private Sub BindScriptScreens(ByVal scriptID As Integer)
        Dim conn As SqlClient.SqlConnection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
        Dim dr As SqlClient.SqlDataReader

        Try
            dr = GetScriptScreens(scriptID, conn)
            rptScriptScreens.DataSource = dr
            rptScriptScreens.DataBind()

        Catch ex As Exception
            Throw ex

        Finally
            If Not IsNothing(dr) AndAlso Not dr.IsClosed Then dr.Close()
            If Not IsNothing(conn) Then
                conn.Close()
                conn.Dispose()
            End If

        End Try

    End Sub

    Private Function GetScriptScreens(ByVal scriptID As Integer, ByVal connection As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Dim dr As SqlClient.SqlDataReader
        dr = SqlHelper.ExecuteReader(connection, CommandType.Text, _
            String.Format("SELECT ss.*, ISNULL(CAST(sq.ItemOrder AS varchar(10)) + '. ' + q.ShortDesc, 'NONE') AS SurveyQuestionDesc, ct.Name AS CalculationTypeName, qt.Name AS QuestionTypeName FROM QuestionTypes qt INNER JOIN Questions q INNER JOIN SurveyQuestions sq ON q.QuestionID = sq.QuestionID ON qt.QuestionTypeID = q.QuestionTypeID RIGHT OUTER JOIN CalculationTypes ct INNER JOIN ScriptScreens ss ON ct.CalculationTypeID = ss.CalculationTypeID ON sq.SurveyQuestionID = ss.SurveyQuestionID WHERE (ss.ScriptID = {0}) ORDER BY ss.ItemOrder", scriptID))
        If Not IsNothing(dr) Then
            Return dr
        Else
            Throw New ApplicationException("Unable to retrieve script screens.")
        End If

    End Function

    Private Function GetScriptCategories(ByVal scriptScreenID As Integer, ByVal connection As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Dim dr As SqlClient.SqlDataReader
        Dim sql As New System.Text.StringBuilder

        sql.Append("SELECT ssc.*, ac.AnswerValue, act.Name AS CategoryTypeName, ")
        sql.Append("CASE ssc.JumpToScriptScreenID WHEN 0 THEN 'NONE' WHEN - 999 THEN 'END SURVEY' WHEN - 99 THEN 'EXIT SURVEY' ")
        sql.Append("ELSE (SELECT CAST(ss.ItemOrder AS varchar(10)) + '. ' + ss.Title FROM ScriptScreens ss WHERE  (ss.ScriptScreenID = ssc.JumpToScriptScreenID)) END AS Jump ")
        sql.Append("FROM ScriptScreenCategories ssc INNER JOIN AnswerCategories ac ON ssc.AnswerCategoryID = ac.AnswerCategoryID INNER JOIN ")
        sql.Append("AnswerCategoryTypes act ON ac.AnswerCategoryTypeID = act.AnswerCategoryTypeID ")
        sql.AppendFormat("WHERE ssc.ScriptScreenID = {0} ORDER BY ac.AnswerValue", scriptScreenID)

        dr = SqlHelper.ExecuteReader(connection, CommandType.Text, sql.ToString)
        If Not IsNothing(dr) Then
            Return dr
        Else
            Throw New ApplicationException("Unable to retrieve script categories.")
        End If

    End Function

    Private Sub rptScriptScreens_ItemDataBound(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.RepeaterItemEventArgs) Handles rptScriptScreens.ItemDataBound
        If e.Item.ItemType = ListItemType.Item OrElse e.Item.ItemType = ListItemType.AlternatingItem Then
            Dim conn As SqlClient.SqlConnection = New SqlClient.SqlConnection(DMI.DataHandler.sConnection)
            Dim dr As SqlClient.SqlDataReader
            Dim drv As Data.Common.DbDataRecord

            Try
                drv = CType(e.Item.DataItem, Data.Common.DbDataRecord)
                dr = GetScriptCategories(CInt(drv.Item("ScriptScreenID")), conn)
                With CType(e.Item.FindControl("dgScriptCategories"), DataGrid)
                    .DataSource = dr
                    .DataBind()
                End With

            Catch ex As Exception
                Throw ex

            Finally
                If Not IsNothing(dr) AndAlso Not dr.IsClosed Then dr.Close()
                If Not IsNothing(conn) Then
                    conn.Close()
                    conn.Dispose()
                End If

            End Try

        End If
    End Sub
End Class
