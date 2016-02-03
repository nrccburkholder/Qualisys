Imports System.Web
Imports System.Web.UI.WebControls
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsAnswerCategories
    Inherits DMI.clsDBEntity2

    Private m_iQuestionID As Integer = 0
    Private m_iAnswerCategoryTypeID As Integer = 1

#Region "dbEntity2 Overrides"

    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        Me.FillAnswerCategoryType(_oConn, _ds.Tables("AnswerCategoryTypes"))
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsAnswerCategories.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()
        Dim sbSQLSurveyQuestions As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsAnswerCategories.SearchRow)

        '*** survey question table ***
        'survey criteria
        If Not dr.IsSurveyIDNull Then sbSQLSurveyQuestions.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)
        'survey question id
        If Not dr.IsSurveyQuestionIDNull Then sbSQLSurveyQuestions.AppendFormat("SurveyQuestionID = {0} AND ", dr.SurveyQuestionID)

        'Primary key criteria
        If Not dr.IsAnswerCategoryIDNull Then sbSQL.AppendFormat("AnswerCategoryID = {0} AND ", dr.AnswerCategoryID)
        'question criteria
        If Not dr.IsQuestionIDNull Then sbSQL.AppendFormat("QuestionID = {0} AND ", dr.QuestionID)
        'question folder criteria
        If Not dr.IsQuestionFolderIDNull Then sbSQL.AppendFormat("QuestionID IN (SELECT QuestionID FROM Questions WHERE QuestionFolderID = {0}) AND ", dr.QuestionFolderID)
        'survey questions criteria
        If sbSQLSurveyQuestions.Length > 0 Then
            DMI.clsUtil.Chop(sbSQLSurveyQuestions, 4)
            sbSQL.AppendFormat("QuestionID IN (SELECT QuestionID FROM SurveyQuestions WHERE {0}) AND ", sbSQLSurveyQuestions.ToString)

        End If

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM AnswerCategories ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_AnswerCategories", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsAnswerCategories()
        _dtMainTable = _ds.Tables("AnswerCategories")
        _sDeleteFilter = "AnswerCategoryID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_AnswerCategories", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters("@AnswerCategoryID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionID", SqlDbType.Int, 4, "QuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerValue", SqlDbType.Int, 4, "AnswerValue"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerText", SqlDbType.VarChar, 1000, "AnswerText"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryTypeID", SqlDbType.Int, 4, "AnswerCategoryTypeID"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("AnswerCategoryID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_AnswerCategories", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryID", SqlDbType.Int, 4, "AnswerCategoryID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionID", SqlDbType.Int, 4, "QuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerValue", SqlDbType.Int, 4, "AnswerValue"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerText", SqlDbType.VarChar, 1000, "AnswerText"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@AnswerCategoryTypeID", SqlDbType.Int, 4, "AnswerCategoryTypeID"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("QuestionID") = m_iQuestionID
        dr.Item("AnswerValue") = NextAnswerValue()
        dr.Item("AnswerText") = String.Format("Choice {0}", dr.Item("AnswerValue"))
        dr.Item("AnswerCategoryTypeID") = m_iAnswerCategoryTypeID

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder()
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(AnswerCategoryID) FROM Responses WHERE AnswerCategoryID = {0}", dr.Item("AnswerCategoryID", DataRowVersion.Original))
        'TP Change
        iCount = CInt(DMI.SqlHelper.Db(Me._oConn.ConnectionString).ExecuteScalar(CommandType.Text, sbSQL.ToString()))
        'iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete answer value {0}. Answer value has responses.\n", dr.Item("AnswerValue", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyUpdate(dr)

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        'check answer value
        If VerifyAnswerValue(dr) Then
            'check answer text
            If VerifyAnswerText(dr) Then
                Return True

            End If
        End If

        Return False

    End Function

#End Region

    'set the current question id
    Public Property QuestionID() As Integer
        Get
            Return m_iQuestionID

        End Get
        Set(ByVal Value As Integer)
            m_iQuestionID = Value

        End Set
    End Property

    Public Property AnswerCategoryType() As Integer
        Get
            Return m_iAnswerCategoryTypeID

        End Get
        Set(ByVal Value As Integer)
            m_iAnswerCategoryTypeID = Value

        End Set
    End Property

    'return next answer value for question
    Private Function NextAnswerValue() As Integer
        If m_iQuestionID > 0 Then
            'TP Change
            Return CInt(DMI.SqlHelper.Db(Me._oConn.ConnectionString).ExecuteScalar(CommandType.Text, String.Format("SELECT ISNULL(MAX(AnswerValue) + 1, 1) FROM AnswerCategories WHERE QuestionID = {0}", m_iQuestionID)))
            'Return SqlHelper.ExecuteScalar(_oConn, CommandType.Text, String.Format("SELECT ISNULL(MAX(AnswerValue) + 1, 1) FROM AnswerCategories WHERE QuestionID = {0}", m_iQuestionID))

        Else
            Return 1

        End If

    End Function

    'checks that answer categories do not have same values
    Private Function VerifyAnswerValue(ByVal dr As DataRow) As Boolean
        Dim sSQL As String
        Dim drResult As DataRow

        sSQL = String.Format("AnswerCategoryID <> {0} AND AnswerValue = {1}", dr.Item("AnswerCategoryID"), dr.Item("AnswerValue"))
        drResult = Me.SelectRow(sSQL)

        If IsNothing(drResult) Then
            Return True

        Else
            Me._sErrorMsg &= String.Format("Answer value {0} already exists. Please select a different value.\n", dr.Item("AnswerValue"))

        End If

    End Function

    'checks that answer categories do not have same text
    Private Function VerifyAnswerText(ByVal dr As DataRow) As Boolean
        Dim sSQL As String
        Dim drResult As DataRow

        sSQL = String.Format("AnswerCategoryID <> {0} AND AnswerText = '{1}'", dr.Item("AnswerCategoryID"), dr.Item("AnswerText"))
        drResult = Me.SelectRow(sSQL)

        If IsNothing(drResult) Then
            Return True

        Else
            Me._sErrorMsg &= String.Format("Answer text ""{0}"" already exists. Please change text.\n", dr.Item("AnswerText"))

        End If

    End Function


#Region "Answer category type lookups"

    Public Shared Sub FillAnswerCategoryType(ByVal oConn As SqlClient.SqlConnection, ByVal dt As DataTable)
        Dim da As New SqlClient.SqlDataAdapter("SELECT * FROM AnswerCategoryTypes", oConn)

        dt.Clear()
        da.Fill(dt)
        da.Dispose()
        da = Nothing

    End Sub

    Public Shared Sub FilterAnswerCategoryType(ByVal oConn As SqlClient.SqlConnection, ByVal dt As DataTable, ByVal QuestionTypeID As Integer)
        Dim sb As New Text.StringBuilder
        Dim da As SqlClient.SqlDataAdapter

        sb.Append("SELECT ac.AnswerCategoryTypeID, ac.Name ")
        sb.Append("FROM QuestionAnswerCategoryTypes q ")
        sb.Append("INNER JOIN AnswerCategoryTypes ac ")
        sb.Append("ON q.AnswerCategoryTypeID = ac.AnswerCategoryTypeID ")
        sb.AppendFormat("WHERE (q.QuestionTypeID = {0})", QuestionTypeID)

        da = New SqlClient.SqlDataAdapter(sb.ToString, oConn)
        sb = Nothing

        dt.Clear()
        da.Fill(dt)
        da.Dispose()
        da = Nothing

    End Sub

    Public Shared Sub FilterAnswerCategoryType(ByVal dt As DataTable, ByVal iQuestionTypeID As Integer)

        If iQuestionTypeID = 3 Then
            'Open answer type
            dt.DefaultView.RowFilter = "AnswerCategoryTypeID <> 1 OR AnswerCategoryTypeID <> 2"

        Else
            dt.DefaultView.RowFilter = "AnswerCategoryTypeID <> 3"

        End If

    End Sub

#End Region

#Region "Datagrid functions"

#End Region

    Public Overloads Overrides Sub DataGridNewItem(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String)
        'datagrid cannot already be in edit mode
        If dg.EditItemIndex = -1 Then
            Me.AddMainRow()
            _dtMainTable.DefaultView.RowStateFilter = DataViewRowState.CurrentRows

            'assume row is added to end of table
            dg.CurrentPageIndex = DMI.clsDataGridTools.LastPageIndex(dg, Me.MainDataTable.Rows.Count)
            dg.EditItemIndex = Me.MainDataTable.Rows.Count - 1
            're-bind dataset to datagrid
            DMI.clsDataGridTools.DataGridBind(dg, Me.MainDataTable, sSortBy)

        End If

    End Sub

    Public Sub ClearAll()
        Dim dt As DataTable

        Dim bEnforce As Boolean = Me.EnforceConstraints
        Me.EnforceConstraints = False

        For Each dt In _ds.Tables
            dt.Clear()
        Next

        Me.EnforceConstraints = bEnforce
    End Sub


End Class
