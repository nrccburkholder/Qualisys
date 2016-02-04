Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsSurveyQuestions
    Inherits DMI.clsDBEntity2

    Private m_iSurveyID As Integer = 0

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsSurveyQuestions.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsSurveyQuestions.SearchRow)

        'Primary key criteria
        If Not dr.IsSurveyQuestionIDNull Then sbSQL.AppendFormat("SurveyQuestionID = {0} AND ", dr.SurveyQuestionID)
        'keyword criteria
        If Not dr.IsQuestionIDNull Then sbSQL.AppendFormat("QuestionID = {0} AND ", dr.QuestionID)
        'SurveyQuestion author
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("SurveyID = {0} AND ", dr.SurveyID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vw_SurveyQuestions ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_SurveyQuestions", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsSurveyQuestions
        _dtMainTable = _ds.Tables("SurveyQuestions")
        _sDeleteFilter = "SurveyQuestionID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_SurveyQuestions", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
        oCmd.Parameters("@SurveyQuestionID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionID", SqlDbType.Int, 4, "QuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DisplayNumber", SqlDbType.VarChar, 50, "DisplayNumber"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("SurveyQuestionID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_SurveyQuestions", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyID", SqlDbType.Int, 4, "SurveyID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionID", SqlDbType.Int, 4, "QuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DisplayNumber", SqlDbType.VarChar, 50, "DisplayNumber"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("SurveyID") = m_iSurveyID
        dr.Item("QuestionID") = 0
        dr.Item("DisplayNumber") = ""
        dr.Item("ItemOrder") = Me.SurveyQuestionCount() + 1

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(SurveyQuestionID) FROM ScriptScreens WHERE SurveyQuestionID = {0}", dr.Item("SurveyQuestionID", DataRowVersion.Original))

        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete survey question ID {0}. Survey question is being used by scripts.\n", dr.Item("SurveyQuestionID", DataRowVersion.Original))
            Return False

        End If

        Return True

    End Function

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(SurveyQuestionID) FROM SurveyQuestions WHERE QuestionID = {0} AND SurveyID = {1}", dr.Item("QuestionID"), dr.Item("SurveyID"))

        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing

        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot add question ID {0}. Question already exists in survey.\n", dr.Item("QuestionID"))
            Return False

        End If

        Return True

    End Function

#End Region

    Public Property SurveyID() As Integer
        Get
            Return m_iSurveyID

        End Get
        Set(ByVal Value As Integer)
            m_iSurveyID = Value

        End Set
    End Property

    Public Function SurveyQuestionCount() As Integer
        Return SurveyQuestionCount(m_iSurveyID)

    End Function

    Public Function SurveyQuestionCount(ByVal iSurveyID As Integer) As Integer
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(SurveyQuestionID) FROM SurveyQuestions WHERE SurveyID = {0}", iSurveyID)

        iCount = SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString)
        sbSQL = Nothing

        Return iCount

    End Function

    Private Sub _ReOrderSurveyQuestions()
        Dim drv As DataRowView
        Dim iNewItemOrder As Integer = 1

        Me.MainDataTable.DefaultView.Sort = "ItemOrder"

        For Each drv In Me.MainDataTable.DefaultView
            If CInt(drv("ItemOrder")) <> iNewItemOrder Then drv("ItemOrder") = iNewItemOrder
            iNewItemOrder += 1

        Next

    End Sub

    Public Shared Function QuestionType(ByVal oConn As SqlClient.SqlConnection, ByVal SurveyQuestionID As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, _
            String.Format("SELECT Questions.QuestionTypeID FROM SurveyQuestions INNER JOIN Questions ON SurveyQuestions.QuestionID = Questions.QuestionID WHERE(SurveyQuestions.SurveyQuestionID = {0})", SurveyQuestionID)))

    End Function

    Public Shared Function QuestionID(ByVal oConn As SqlClient.SqlConnection, ByVal SurveyID As Integer, ByVal QuestionOrder As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, _
            String.Format("SELECT QuestionID FROM SurveyQuestions WHERE SurveyID = {0} AND ItemOrder = {1}", SurveyID, QuestionOrder)))

    End Function

    Public Shared Function GetSurveyQuestions(ByVal connection As SqlClient.SqlConnection, ByVal surveyID As Integer) As SqlClient.SqlDataReader
        Dim sql As New Text.StringBuilder

        sql.AppendFormat("SELECT * FROM vw_SurveyQuestions WHERE (surveyID = {0}) ORDER BY ItemOrder", surveyID)

        Return SqlHelper.ExecuteReader(connection, CommandType.Text, sql.ToString)

    End Function

#Region "Datagrid functions"

    'deletes selected rows in datagrid from dbentity
    Public Overrides Function DataGridDelete(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String) As Integer
        Dim dgi As System.Web.UI.WebControls.DataGridItem
        Dim sFilter As String
        Dim iDeleteCount As Integer = 0
        Dim iLastPageIndex As Integer = 0

        'cannot be in edit mode when deleting
        If dg.EditItemIndex = -1 Then
            For Each dgi In dg.Items
                If CType(dgi.FindControl("cbSelected"), System.Web.UI.WebControls.CheckBox).Checked Then
                    sFilter = String.Format(_sDeleteFilter, dg.DataKeys(dgi.ItemIndex))
                    If Not Me.Delete(sFilter) Then Exit For
                    iDeleteCount += 1

                End If
            Next

            If iDeleteCount > 0 Then
                'deletes were made, reorder questions and refresh dataset
                Me._ReOrderSurveyQuestions()
                Me.Save()

            End If

            'display delete results
            If Me.ErrMsg.Length > 0 Then
                'error occured
                DMI.WebFormTools.Msgbox(dg.Page, Me.ErrMsg)
                Me.MainDataTable.RejectChanges()

            ElseIf iDeleteCount > 0 Then
                'successful deletes
                DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Deletes", iDeleteCount))

                'calculate last page index
                iLastPageIndex = DMI.clsDataGridTools.LastPageIndex(dg, Me.MainDataTable.Rows.Count)

                'if datagrid paging is in use, check for valid current page index 
                If dg.CurrentPageIndex > 0 AndAlso dg.CurrentPageIndex > iLastPageIndex Then
                    dg.CurrentPageIndex = iLastPageIndex

                End If

            Else
                'no deletes
                DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

            End If

            're-bind dataset to datagrid
            DMI.clsDataGridTools.DataGridBind(dg, Me, sSortBy)

        End If

        Return iDeleteCount

    End Function

    'update row order in datagrid from dbentity
    Public Function DataGridUpdateOrder(ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String) As Integer
        Dim dgi As System.Web.UI.WebControls.DataGridItem
        Dim dr As DataRow
        Dim iSurveyQuestionID As Integer
        Dim iSortIndex As Integer

        For Each dgi In dg.Items
            iSurveyQuestionID = dg.DataKeys(dgi.ItemIndex)
            iSortIndex = CType(dgi.FindControl("ddlItemOrder"), System.Web.UI.WebControls.DropDownList).SelectedItem.Value
            dr = Me.SelectRow(String.Format(_sDeleteFilter, iSurveyQuestionID))
            If iSortIndex <> CInt(dr.Item("ItemOrder")) Then dr.Item("ItemOrder") = iSortIndex

        Next

        Me._ReOrderSurveyQuestions()
        Me.Save()
        If Me._sErrorMsg.Length > 0 Then _ds.RejectChanges()

        're-bind dataset to datagrid
        DMI.clsDataGridTools.DataGridBind(dg, Me, sSortBy)

    End Function

#End Region

End Class
