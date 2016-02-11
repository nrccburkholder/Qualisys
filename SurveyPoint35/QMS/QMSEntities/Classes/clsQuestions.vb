Imports System.Web
Imports System.Web.UI.WebControls
Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Enum qmsQuestionTypes
    SingleSelect = 1
    MultipleSelect = 2
    OpenAnswer = 3

End Enum

Public Class clsQuestions
    Inherits DMI.clsDBEntity2

    Private m_iFolderID As Integer = 0

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        FillQuestionFolders(drCriteria)
        FillQuestionType(_oConn, _ds.Tables("QuestionTypes"))
        'clsAnswerCategories.FillAnswerCategoryType(_oConn, _ds.Tables("AnswerCategoryTypes"))
        clsAnswerCategories.FilterAnswerCategoryType(_oConn, _ds.Tables("AnswerCategoryTypes"), CInt(Me.MainDataTable.Rows(0).Item("QuestionTypeID")))
        FillAnswerCategories(drCriteria)


    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsQuestions.SearchRow
        Dim sbSQL As New System.Text.StringBuilder()

        dr = CType(drCriteria, dsQuestions.SearchRow)
        'fix primary id criteria


        'Primary key criteria
        If Not dr.IsQuestionIDNull Then sbSQL.AppendFormat("QuestionID = {0} AND ", dr.QuestionID)
        'keyword criteria
        If Not dr.IsKeywordNull Then sbSQL.AppendFormat("ShortDesc + Text LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))
        'Folder criteria
        If Not dr.IsQuestionFolderIDNull Then sbSQL.AppendFormat("QuestionFolderID = {0} AND ", dr.QuestionFolderID)
        'Survey criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("QuestionID IN (SELECT QuestionID FROM SurveyQuestions WHERE SurveyID = {0}) AND ", dr.SurveyID)
        'Active folders
        If Not dr.IsActiveFoldersNull Then sbSQL.AppendFormat("QuestionFolderID IN (SELECT QuestionFolderID FROM QuestionFolders WHERE Active = {0}) AND ", dr.ActiveFolders)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM Questions ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_Questions", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionID", SqlDbType.Int, 4, "QuestionID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsQuestions()
        _dtMainTable = _ds.Tables("Questions")
        _sDeleteFilter = "QuestionID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_Questions", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionID", SqlDbType.Int, 4, "QuestionID"))
        oCmd.Parameters("@QuestionID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionFolderID", SqlDbType.Int, 4, "QuestionFolderID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Text", SqlDbType.VarChar, 3000, "Text"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ShortDesc", SqlDbType.VarChar, 100, "ShortDesc"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionTypeID", SqlDbType.Int, 4, "QuestionTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("QuestionID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_Questions", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionID", SqlDbType.Int, 4, "QuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionFolderID", SqlDbType.Int, 4, "QuestionFolderID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Text", SqlDbType.VarChar, 3000, "Text"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ShortDesc", SqlDbType.VarChar, 100, "ShortDesc"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@QuestionTypeID", SqlDbType.Int, 4, "QuestionTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("QuestionFolderID") = m_iFolderID
        dr.Item("Text") = ""
        dr.Item("ShortDesc") = ""
        dr.Item("QuestionTypeID") = 1
        dr.Item("ItemOrder") = Me.QuestionCount(m_iFolderID) + 1

    End Sub

    Protected Overrides Function VerifyDelete(ByRef dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder()
        Dim iCount As Integer

        'determine if responses exist for question
        sbSQL.AppendFormat("SELECT COUNT(ResponseID) FROM Responses WHERE AnswerCategoryID IN (SELECT AnswerCategoryID FROM AnswerCategories WHERE QuestionID = {0})", dr.Item("QuestionID", DataRowVersion.Original))
        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete question ID {0}. Question has answer categories.\n", dr.Item("QuestionID", DataRowVersion.Original))
            Return False

        End If

        'determine if question is being used by surveys
        sbSQL.Remove(0, sbSQL.Length)
        sbSQL.AppendFormat("SELECT COUNT(SurveyQuestionID) FROM SurveyQuestions WHERE QuestionID = {0}", dr.Item("QuestionID", DataRowVersion.Original))
        iCount = CInt(SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString))
        If iCount > 0 Then
            Me._sErrorMsg &= String.Format("Cannot delete question ID {0}. Question is being used by surveys.\n", dr.Item("QuestionID", DataRowVersion.Original))
            Return False

        End If

        sbSQL = Nothing

        Return True

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Dim sbSQL As New Text.StringBuilder
        Dim iInvalidCategories As Integer = 0
        Dim bValid As Boolean = True

        'check answer category types
        sbSQL.AppendFormat("SELECT COUNT(AnswerCategoryID) FROM AnswerCategories WHERE QuestionID = {0} AND AnswerCategoryTypeID NOT IN (SELECT AnswerCategoryTypeID FROM QuestionAnswerCategoryTypes WHERE QuestionTypeID = {1})", dr.Item("QuestionID"), dr.Item("QuestionTypeID"))
        iInvalidCategories = CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, sbSQL.ToString))
        sbSQL = Nothing
        If iInvalidCategories > 0 Then
            bValid = False
            Select Case CInt(dr.Item("QuestionTypeID"))
                Case 1, 2 'Single select and multiple select
                    Me._sErrorMsg &= "Unable to change question type. Question type does not not allow open answer categories. Please remove open answer categories before updating.\n"

                Case Else 'Open answer
                    Me._sErrorMsg &= "Unable to change question type. Question type does not not allow select categories. Please remove select categories before updating.\n"

            End Select

        End If

        'check text length
        If Not ValidateTextLength(dr) Then bValid = False

        Return bValid

    End Function

    Public Overloads Overrides Sub Save(ByRef dt As System.Data.DataTable)
        'update answer category types
        Try
            dt.DataSet.EnforceConstraints = False
            clsAnswerCategories.FilterAnswerCategoryType(_oConn, _ds.Tables("AnswerCategoryTypes"), CInt(Me.MainDataTable.Rows(0).Item("QuestionTypeID")))
            dt.DataSet.EnforceConstraints = True
            MyBase.Save(dt)

        Catch
            Me._sErrorMsg = "Cannot change question type.\nPlease remove answer category types that do not exist in new question type."
            dt.RejectChanges()

        End Try

    End Sub

#End Region

    Public Property QuestionFolderID() As Integer
        Get
            Return m_iFolderID

        End Get
        Set(ByVal Value As Integer)
            m_iFolderID = Value

        End Set
    End Property

    Public Function QuestionCount(ByVal iFolderID As Integer) As Integer
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(QuestionID) FROM Questions WHERE QuestionFolderID = {0}", iFolderID)

        iCount = SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString)
        sbSQL = Nothing

        Return iCount

    End Function

    Private Sub _ReOrderQuestions()
        Dim drv As DataRowView
        Dim iNewItemOrder As Integer = 1

        Me.MainDataTable.DefaultView.Sort = "ItemOrder"

        For Each drv In Me.MainDataTable.DefaultView
            If CInt(drv("ItemOrder")) <> iNewItemOrder Then drv("ItemOrder") = iNewItemOrder
            iNewItemOrder += 1

        Next

    End Sub

    Private Sub _CopyTo(ByVal iQuestionID, ByVal iFolderID)
        SqlHelper.ExecuteNonQuery(_oconn, CommandType.StoredProcedure, "dbo.copy_QuestionToFolder", _
            New SqlClient.SqlParameter("@QuestionID", iQuestionID), _
            New SqlClient.SqlParameter("@QuestionFolderID", iFolderID))

    End Sub

    Private Function ValidateTextLength(ByVal dr As DataRow) As Boolean

        If dr.Item("Text").ToString.Length > 3000 Then
            _sErrorMsg &= "Question text cannot be more than 3000 characters.\n"
            Return False

        End If

        Return True

    End Function

#Region "Question folder lookups"

    Public Sub FillQuestionFolders(ByVal drCriteria As DataRow)
        Dim dr1 As dsQuestions.SearchRow
        Dim dr2 As dsQuestionFolders.SearchRow
        Dim oQF As New clsQuestionFolders(Me._oConn)

        dr1 = CType(drCriteria, dsQuestions.SearchRow)
        dr2 = CType(oQF.NewSearchRow, dsQuestionFolders.SearchRow)

        If Not dr1.IsQuestionFolderIDNull Then dr2.QuestionFolderID = dr1.QuestionFolderID

        oQF.MainDataTable = Me.QuestionFolderTable
        oQF.FillMain(dr2)

        oQF.Close()
        oQF = Nothing
        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Function QuestionFolderTable() As DataTable
        Return _ds.Tables("QuestionFolders")

    End Function
#End Region

#Region "Question type lookups"

    Public Sub FillQuestionType()
        FillQuestionType(_oConn, Me.QuestionTypesTable)

    End Sub

    Public Shared Sub FillQuestionType(ByVal oConn As SqlClient.SqlConnection, ByVal dt As DataTable)
        Dim da As New SqlClient.SqlDataAdapter("SELECT * FROM QuestionTypes", oConn)

        da.Fill(dt)
        da.Dispose()
        da = Nothing

    End Sub

    Public Function QuestionTypesTable() As DataTable
        Return _ds.Tables("QuestionTypes")

    End Function

    Public Shared Function QuestionType(ByVal oConn As SqlClient.SqlConnection, ByVal QuestionID As Integer) As Integer
        Return CInt(SqlHelper.ExecuteScalar(oConn, CommandType.Text, _
            String.Format("SELECT QuestionTypeID FROM Questions WHERE QuestionID = {0}", QuestionID)))

    End Function
#End Region

#Region "Answer Categories lookup"

    Public Sub FillAnswerCategories(ByVal drCriteria As DataRow)
        Dim dr1 As dsQuestions.SearchRow
        Dim dr2 As dsAnswerCategories.SearchRow
        Dim oAC As New clsAnswerCategories(Me._oConn)

        dr1 = CType(drCriteria, dsQuestions.SearchRow)
        dr2 = CType(oAC.NewSearchRow, dsAnswerCategories.SearchRow)

        If Not dr1.IsQuestionIDNull Then dr2.QuestionID = dr1.QuestionID

        oAC.MainDataTable = Me.AnswerCategoriesTable
        oAC.FillMain(dr2)

        oAC.Close()
        oAC = Nothing
        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Function AnswerCategoriesTable() As DataTable
        Return _ds.Tables("AnswerCategories")

    End Function

#End Region

#Region "Answer Category Types lookup"

    Public Function AnswerCategoryTypesTable() As DataTable
        Return _ds.Tables("AnswerCategoryTypes")

    End Function
#End Region

#Region "Datagrid functions"
    'deletes selected rows in datagrid from dbentity
    Public Overrides Function DataGridDelete(ByRef dg As DataGrid, ByVal sSortBy As String) As Integer
        Dim dgi As DataGridItem
        Dim sDeleteFilter As String = "QuestionID = {0}"
        Dim sFilter As String
        Dim iDeleteCount As Integer = 0
        Dim iLastPageIndex As Integer = 0

        'cannot be in edit mode when deleting
        If dg.EditItemIndex = -1 Then
            For Each dgi In dg.Items
                If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                    sFilter = String.Format(sDeleteFilter, dg.DataKeys(dgi.ItemIndex))
                    If Not Me.Delete(sFilter) Then Exit For
                    iDeleteCount += 1

                End If
            Next

            If iDeleteCount > 0 Then
                'deletes were made, reorder questions and refresh dataset
                Me._ReOrderQuestions()
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

    'deletes selected rows in datagrid from dbentity
    Public Function DataGridUpdateOrder(ByRef dg As DataGrid, Optional ByVal sSortBy As String = "") As Integer
        Dim dgi As DataGridItem
        Dim dr As DataRow
        Dim iQuestionID As Integer
        Dim iSortIndex As Integer

        For Each dgi In dg.Items
            iQuestionID = dg.DataKeys(dgi.ItemIndex)
            iSortIndex = CType(dgi.FindControl("ddlSortIndex"), DropDownList).SelectedItem.Value
            dr = Me.SelectRow(String.Format("QuestionID = {0}", iQuestionID))
            If iSortIndex <> CInt(dr.Item("ItemOrder")) Then dr.Item("ItemOrder") = iSortIndex

        Next

        Me._ReOrderQuestions()
        Me.Save()
        If Me._sErrorMsg.Length > 0 Then _ds.RejectChanges()

        're-bind dataset to datagrid
        DMI.clsDataGridTools.DataGridBind(dg, Me, sSortBy)

    End Function

    'deletes selected rows in datagrid from dbentity
    Public Function DataGridCopyTo(ByRef dg As DataGrid, ByVal iCopyToFolderID As Integer, Optional ByVal sSortBy As String = "") As Integer
        Dim dgi As DataGridItem
        Dim dr As DataRow
        Dim iQuestionID As Integer

        Dim iCopyTo As Integer = 0

        'delete selected questions
        For Each dgi In dg.Items
            If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                iQuestionID = dg.DataKeys(dgi.ItemIndex)
                Me._CopyTo(iQuestionID, iCopyToFolderID)
                iCopyTo += 1

            End If

        Next

        'display delete results
        If Me.ErrMsg.Length > 0 Then
            DMI.WebFormTools.Msgbox(dg.Page, Me.ErrMsg)

        ElseIf iCopyTo > 0 Then
            DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Questions Copied", iCopyTo))

        Else
            DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

        End If

        If iCopyTo > 0 Then
            'check to refresh dataset
            dr = Me.SelectRow(String.Format("QuestionID = {0}", iQuestionID))
            If dr.Item("QuestionFolderID") = iCopyToFolderID Then
                'questions copied to same folder, refresh dataset
                dr = Me.NewSearchRow
                dr.Item("QuestionFolderID") = iCopyToFolderID
                Me.FillMain(dr)

            End If

        End If

        're-bind dataset to datagrid
        DMI.clsDataGridTools.DataGridBind(dg, Me, sSortBy)

    End Function

    'deletes selected rows in datagrid from dbentity
    Public Function DataGridAddQuestions(ByVal iSurveyID As Integer, ByRef dg As System.Web.UI.WebControls.DataGrid, ByVal sSortBy As String) As Integer
        Dim dgi As System.Web.UI.WebControls.DataGridItem
        Dim dr As DataRow
        Dim oSQ As New clsSurveyQuestions(Me._oConn)
        Dim iAddCount As Integer = 0
        Dim iSurveyQuestionCount As Integer

        oSQ.SurveyID = iSurveyID
        iSurveyQuestionCount = oSQ.SurveyQuestionCount

        For Each dgi In dg.Items
            If CType(dgi.FindControl("cbSelected"), System.Web.UI.WebControls.CheckBox).Checked Then
                iAddCount += 1
                dr = oSQ.NewMainRow
                dr.Item("SurveyID") = iSurveyID
                dr.Item("QuestionID") = CInt(dg.DataKeys(dgi.ItemIndex))
                dr.Item("ItemOrder") = iSurveyQuestionCount + iAddCount
                oSQ.AddMainRow(dr)

            End If

        Next

        oSQ.Save()

        If oSQ.ErrMsg.Length > 0 Then
            'error occured
            DMI.WebFormTools.Msgbox(dg.Page, oSQ.ErrMsg)
            Me.MainDataTable.RejectChanges()

        ElseIf iAddCount > 0 Then
            DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} questions added", iAddCount))

        Else
            DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

        End If

        're-bind dataset to datagrid
        DMI.clsDataGridTools.DataGridBind(dg, Me.MainDataTable, sSortBy)

    End Function

#End Region

End Class
