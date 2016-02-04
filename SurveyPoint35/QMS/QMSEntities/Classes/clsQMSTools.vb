Option Explicit On
Option Strict On

Imports System.Web
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls
Imports System.Drawing
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common

Public Class clsQMSTools

    Public Const ENCRYPTION_KEY As String = "5E743D19621C40e9B5A888133F9AAD9D"

    'sets the css class styles for QMS data grids
    Public Shared Sub FormatQMSDataGrid(ByRef dg As DataGrid)

        dg.ItemStyle.CssClass = "itemcell"
        dg.AlternatingItemStyle.CssClass = "altcell"
        dg.HeaderStyle.CssClass = "headingcell"
        dg.HeaderStyle.ForeColor = Color.White
        dg.PagerStyle.CssClass = "gridborder"
        dg.PagerStyle.ForeColor = Color.White
        dg.CellPadding = 3

    End Sub

    Public Shared Function GetEventName(ByVal iEventID As Integer) As String
        Dim sSQL As String = String.Format("SELECT Name FROM Events WHERE EventID = {0}", iEventID)

        If iEventID > 0 Then
            Return SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, CommandType.Text, sSQL).ToString

        Else
            Return "None"

        End If

    End Function

    Public Shared Function GetFileDefFilterName(ByVal iFileDefFilterID As Integer) As String
        Dim sSQL As String = String.Format("SELECT FilterName FROM FileDefFilters WHERE FileDefFilterID = {0}", iFileDefFilterID)

        If iFileDefFilterID > 0 Then
            Return SqlHelper.ExecuteScalar(DMI.DataHandler.sConnection, CommandType.Text, sSQL).ToString

        Else
            Return "None"

        End If

    End Function

    Public Shared Function GetStatesDataSource(ByVal oConn As SqlClient.SqlConnection) As SqlClient.SqlDataReader                
        Return SqlHelper.ExecuteReader(oConn, CommandType.Text, _
            "SELECT State, StateName FROM States ORDER BY State")

    End Function

    Public Shared Function GetYesNoText(ByVal sValue As String) As String
        If IsNumeric(sValue) Then
            If CInt(sValue) = 0 Then
                Return "No"
            Else
                Return "Yes"
            End If
        End If
        Return "All"

    End Function

    Public Shared Function GetUserID(ByVal Connection As SqlClient.SqlConnection, ByVal SecurityToken As String) As Integer
        Dim SQL As New System.Text.StringBuilder

        'look for login token within last 8 hours and witout a logout
        SQL.Append("SELECT el1.UserID FROM EventLog el1 WHERE el1.EventID = 1000 AND ")
        SQL.Append("el1.EventDate > DATEADD([hour], -8, GETDATE()) AND ")
        SQL.AppendFormat("el1.EventParameters = {0} AND ", DMI.DataHandler.QuoteString(SecurityToken))
        SQL.Append("NOT EXISTS (SELECT el2.EventLogID FROM EventLog el2 WHERE el2.EventID = 1001 AND ")
        SQL.Append("el2.EventParameters = el1.EventParameters AND ")
        SQL.Append("el2.EventDate >= el1.EventDate AND el2.UserID = el1.UserID)")

        Try
            Return CInt(SqlHelper.ExecuteScalar(Connection, CommandType.Text, SQL.ToString))

        Catch ex As Exception
            Return Nothing

        End Try

    End Function

    Public Shared Function GetResponsesPointInTimeDR(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer) As SqlClient.SqlDataReader
        Dim sql As New System.Text.StringBuilder

        sql.Append("SELECT EventLog.*, Users.Username AS Username, Events.Name AS EventName, CONVERT(varchar(20), EventLog.EventDate, 101) + ")
        sql.Append("' ' + CONVERT(varchar(20), EventLog.EventDate, 108) + ' - ' + Events.Name + ' (' + Users.Username + ')' AS PointInTimeName ")
        sql.Append("FROM EventLog INNER JOIN ")
        sql.Append("Users ON EventLog.UserID = Users.UserID INNER JOIN ")
        sql.Append("Events ON EventLog.EventID = Events.EventID ")
        sql.AppendFormat("WHERE (EventLog.RespondentID = {0}) AND (EventLog.EventID IN (2011, 2021, 2031, 2033, 2041)) ", respondentID)
        sql.Append("ORDER BY EventLog.EventDate DESC ")

        Return SqlHelper.ExecuteReader(connection, CommandType.Text, sql.ToString)

    End Function

    Public Shared Sub SetResponsesPointInTimeControl(ByVal connection As SqlClient.SqlConnection, ByRef ddl As ListControl, ByVal respondentID As Integer)
        Dim dr As SqlClient.SqlDataReader

        dr = GetResponsesPointInTimeDR(connection, respondentID)
        ddl.DataSource = dr
        ddl.DataTextField = "PointInTimeName"
        ddl.DataValueField = "EventDate"
        ddl.DataBind()
        dr.Close()

    End Sub

    Public Shared Function GetProcessorDR(ByVal connection As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(connection, CommandType.Text, "SELECT * FROM Processors ORDER BY ProcessorName")

    End Function

    Public Shared Sub SetProcessorDDL(ByVal connection As SqlClient.SqlConnection, ByRef ctrl As ListControl)
        Dim dr As SqlClient.SqlDataReader
        dr = GetProcessorDR(connection)

        ctrl.DataSource = dr
        ctrl.DataTextField = "ProcessorName"
        ctrl.DataValueField = "ProcessorID"
        ctrl.DataBind()
        dr.Close()

        If ctrl.Items.Count = 0 Then
            ctrl.Items.Add(New ListItem("NONE", ""))
        Else
            ctrl.Items.Insert(0, New ListItem("Select Processor", ""))
        End If

    End Sub

    Public Shared Function GetProcessorCode(ByVal connection As SqlClient.SqlConnection, ByVal processorID As Integer) As String
        Dim results As Object

        results = SqlHelper.ExecuteScalar(connection, CommandType.Text, _
            String.Format("SELECT ProcessorCode FROM Processors WHERE ProcessorID = {0}", processorID))

        If Not IsNothing(results) AndAlso Not IsDBNull(results) Then
            Return results.ToString

        End If

        Return ""

    End Function

    Public Shared Function GetScriptScreensDR(ByVal connection As SqlClient.SqlConnection, ByVal scriptID As Integer) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(connection, CommandType.Text, _
            String.Format("SELECT  *, CAST(ItemOrder AS varchar(10)) + '. ' + Title AS ScreenName FROM ScriptScreens WHERE (ScriptID = {0}) ORDER BY ItemOrder", scriptID))

    End Function

    Public Shared Sub SetScriptScreensDDL(ByVal connection As SqlClient.SqlConnection, ByRef ctrl As ListControl, ByVal scriptID As Integer)
        Dim dr As SqlClient.SqlDataReader
        dr = GetScriptScreensDR(connection, scriptID)

        ctrl.DataSource = dr
        ctrl.DataTextField = "ScreenName"
        ctrl.DataValueField = "ScriptScreenID"
        ctrl.DataBind()
        dr.Close()

        If ctrl.Items.Count = 0 Then
            ctrl.Items.Add(New ListItem("NONE", ""))
        End If

    End Sub

    Public Shared Sub CleanRespondentResponses(ByVal connection As SqlClient.SqlConnection, ByVal respondentID As Integer)
        SqlHelper.ExecuteNonQuery(connection, CommandType.StoredProcedure, "clean_Responses", _
            New SqlClient.SqlParameter("@RespondentID", respondentID))

    End Sub

    Public Shared Function GetSurveyInstanceCategoriesDR(ByVal connection As SqlClient.SqlConnection) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(connection, CommandType.Text, "SELECT * FROM SurveyInstanceCategories ORDER BY SurveyInstanceCategoryName")
    End Function

    Public Shared Sub SetSurveyInstanceCategoryDDL(ByVal connection As SqlClient.SqlConnection, ByRef ctrl As ListControl)
        Dim dr As SqlClient.SqlDataReader
        dr = GetSurveyInstanceCategoriesDR(connection)

        ctrl.DataSource = dr
        ctrl.DataTextField = "SurveyInstanceCategoryName"
        ctrl.DataValueField = "SurveyInstanceCategoryID"
        ctrl.DataBind()
        dr.Close()

        ctrl.Items.Insert(0, New ListItem("None", ""))

    End Sub

    Public Shared Sub SetVerifyScriptDDL(ByVal connection As SqlClient.SqlConnection, ByRef ctrl As ListControl, ByVal respondentID As Integer)
        Dim dr As SqlClient.SqlDataReader
        dr = clsScripts.GetDataEntryScript(connection, respondentID)

        ctrl.DataSource = dr
        ctrl.DataTextField = "Name"
        ctrl.DataValueField = "ScriptID"
        ctrl.DataBind()
        dr.Close()

        If ctrl.Items.Count = 0 Then
            ctrl.Items.Add(New ListItem("NONE", ""))
        End If

    End Sub

End Class
