Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports DMI
Imports System.Data.Common
Public Class clsScriptScreens
    Inherits DMI.clsDBEntity2

    Private _iScriptID As Integer = 0
    Private _oScriptScreenCategories As clsScriptScreenCategories
    Private _oAnswerCategories As clsAnswerCategories
    Private _iUserID As Integer = 0

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef conn As String)
        MyBase.New(conn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        Me.FillCalculationTypes()
        Me.FillAnswerCategoryTypes()
    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim sbSQL As New System.Text.StringBuilder
        Dim dr As dsScriptScreens.SearchRow = CType(drCriteria, dsScriptScreens.SearchRow)

        'Primary key criteria
        If Not dr.IsScriptScreenIDNull Then sbSQL.AppendFormat("ScriptScreenID = {0} AND ", dr.ScriptScreenID)
        'script criteria
        If Not dr.IsScriptIDNull Then sbSQL.AppendFormat("ScriptID = {0} AND ", dr.ScriptID)
        'survey question criteria
        If Not dr.IsSurveyQuestionIDNull Then sbSQL.AppendFormat("SurveyQuestionID = {0} AND ", dr.SurveyQuestionID)
        'item order criteria
        If Not dr.IsItemOrderNull Then sbSQL.AppendFormat("ItemOrder = {0} AND ", dr.ItemOrder)
        'keyword criteria
        If Not dr.IsKeywordNull Then sbSQL.AppendFormat("Name + Description LIKE {0} AND ", DMI.DataHandler.QuoteString(dr.Keyword))

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")
        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM vw_ScriptScreens ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_ScriptScreens", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenID", SqlDbType.Int, 4, "ScriptScreenID"))

        Return oCmd
    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsScriptScreens
        _dtMainTable = _ds.Tables("ScriptScreens")
        _sDeleteFilter = "ScriptScreenID = {0}"
    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_ScriptScreens", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenID", SqlDbType.Int, 4, "ScriptScreenID"))
        oCmd.Parameters("@ScriptScreenID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", SqlDbType.Int, 4, "ScriptID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Title", SqlDbType.VarChar, 100, "Title"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Text", SqlDbType.VarChar, 4000, "Text"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CalculationTypeID", SqlDbType.Int, 4, "CalculationTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))

        Return oCmd
    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("ScriptScreenID") = iEntityID
    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_ScriptScreens", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptScreenID", SqlDbType.Int, 4, "ScriptScreenID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ScriptID", SqlDbType.Int, 4, "ScriptID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@SurveyQuestionID", SqlDbType.Int, 4, "SurveyQuestionID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Title", SqlDbType.VarChar, 100, "Title"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Text", SqlDbType.VarChar, 4000, "Text"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@CalculationTypeID", SqlDbType.Int, 4, "CalculationTypeID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ItemOrder", SqlDbType.Int, 4, "ItemOrder"))

        Return oCmd
    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        Dim typedDR As dsScriptScreens.ScriptScreensRow = CType(dr, dsScriptScreens.ScriptScreensRow)
        typedDR.CalculationTypeID = 1
        typedDR.ItemOrder = ScreenCount(Me._oConn, _iScriptID) + 1
        typedDR.ScriptID = _iScriptID
        typedDR.ScriptScreenID = 0
        'typedDR.SurveyQuestionID = 0
        typedDR.Title = ""
        typedDR.Text = ""
    End Sub

#End Region

#Region "CalculationType Lookup"
    Public Sub FillCalculationTypes()
        DMI.DataHandler.GetDataTable(Me._oConn, Me.CalculationTypesTable, "SELECT * FROM CalculationTypes")
    End Sub

    Public Function CalculationTypesTable() As dsScriptScreens.CalculationTypeDataTable
        Return Me._ds.Tables("CalculationType")
    End Function

#End Region

#Region "Script Screen Categories Lookup"

    Public ReadOnly Property ScriptScreenCategories() As clsScriptScreenCategories
        Get
            If IsNothing(_oScriptScreenCategories) Then
                _oScriptScreenCategories = New clsScriptScreenCategories(_oConn)
                _oScriptScreenCategories.MainDataTable = ScriptScreenCategoriesTable()

            End If

            Return _oScriptScreenCategories

        End Get
    End Property

    Public Sub FillScriptScreenCategories(ByVal drCriteria As dsScriptScreens.SearchRow)
        Dim dr1 As dsScriptScreens.SearchRow
        Dim dr2 As dsScriptScreenCategories.SearchRow

        dr1 = CType(drCriteria, dsScriptScreens.SearchRow)
        dr2 = CType(ScriptScreenCategories.NewSearchRow, dsScriptScreenCategories.SearchRow)

        If Not dr1.IsScriptIDNull Then dr2.ScriptID = dr1.ScriptID
        If Not dr1.IsScriptScreenIDNull Then dr2.ScriptScreenID = dr1.ScriptScreenID

        ScriptScreenCategories.FillMain(dr2)

        dr1 = Nothing
        dr2 = Nothing

    End Sub

    Public Sub FillScriptScreenCategories(ByVal iScriptScreenID As Integer)
        Dim dr As DataRow

        dr = Me.NewSearchRow
        dr.Item("ScriptScreenID") = iScriptScreenID
        Me.FillScriptScreenCategories(dr)

        dr = Nothing
    End Sub

    Public ReadOnly Property ScriptScreenCategoriesTable() As dsScriptScreens.ScriptScreenCategoriesDataTable
        Get
            Return Me._ds.Tables("ScriptScreenCategories")

        End Get
    End Property

    Public Sub AddAllScriptScreenCategories()
        Dim drAC As DataRow
        Dim drNew As DataRow
        ScriptScreenCategories.MainDataTable = ScriptScreenCategoriesTable
        ScriptScreenCategoriesTable.Clear()

        For Each drAC In AnswerCategoriesTable.Rows
            ScriptScreenCategories.ScriptScreenID = CInt(MainDataTable.Rows(0).Item("ScriptScreenID"))
            ScriptScreenCategories.AnswerCategoryID = CInt(drAC.Item("AnswerCategoryID"))
            drNew = ScriptScreenCategories.AddMainRow
            drNew.Item("Text") = drAC.Item("AnswerText")

        Next
        ScriptScreenCategories.Save()

    End Sub

#End Region

#Region "Answer Categories Lookup"
    Public ReadOnly Property AnswerCategories() As clsAnswerCategories
        Get
            If IsNothing(_oAnswerCategories) Then
                _oAnswerCategories = New clsAnswerCategories(_oConn)
                _oAnswerCategories.MainDataTable = AnswerCategoriesTable()
            End If

            Return _oAnswerCategories

        End Get
    End Property

    Public ReadOnly Property AnswerCategoriesTable() As dsScriptScreens.AnswerCategoriesDataTable
        Get
            Return Me._ds.Tables("AnswerCategories")

        End Get
    End Property

    Public Sub FillAnswerCategories()
        Dim dr As dsAnswerCategories.SearchRow
        Dim drSS As DataRow

        If Me.MainDataTable.Rows.Count > 0 Then
            drSS = Me.MainDataTable.Rows(0)
            If Not IsDBNull(drSS.Item("SurveyQuestionID")) Then
                dr = CType(AnswerCategories.NewSearchRow, dsAnswerCategories.SearchRow)
                dr.SurveyQuestionID = CInt(drSS.Item("SurveyQuestionID"))
                AnswerCategories.FillMain(dr)

            End If
            drSS = Nothing
            dr = Nothing

        End If

    End Sub

#End Region

#Region "Answer Category Types Lookup"
    Public Sub FillAnswerCategoryTypes()
        DMI.DataHandler.GetDataTable(Me._oConn, Me.AnswerCategoryTypesTable, "SELECT * FROM AnswerCategoryTypes")
    End Sub

    Public Function AnswerCategoryTypesTable() As dsScriptScreens.AnswerCategoryTypesDataTable
        Return Me._ds.Tables("AnswerCategoryTypes")
    End Function

#End Region

#Region "Data Reader List"
    Public Function GetSurveyQuestionsList() As SqlClient.SqlDataReader
        Dim oSQ As clsSurveyQuestions
        Dim dr As DataRow
        Dim sqlDR As SqlClient.SqlDataReader

        If Me.MainDataTable.Rows.Count > 0 Then
            oSQ = New clsSurveyQuestions(_oCOnn)
            dr = oSQ.NewSearchRow
            dr.Item("SurveyID") = CInt(SqlHelper.ExecuteScalar(_oConn, CommandType.Text, String.Format("SELECT Surveys.SurveyID FROM Scripts INNER JOIN Surveys ON Scripts.SurveyID = Surveys.SurveyID WHERE (Scripts.ScriptID = {0})", MainDataTable.Rows(0).Item("ScriptID"))))
            sqlDR = oSQ.GetDataReader(dr, "ItemOrder")
            dr = Nothing
            oSQ.Close()
            oSQ = Nothing

        End If

        Return sqlDR

    End Function

    Public Function GetScriptScreensTable() As DataTable
        Dim sSQL As String

        If Me.MainDataTable.Rows.Count > 0 Then
            sSQL = String.Format("SELECT * FROM ScriptScreens WHERE ScriptID = {0} ORDER BY ItemOrder", MainDataTable.Rows(0).Item("ScriptID"))
            DMI.DataHandler.GetDS(_oConn, _ds, sSQL, "ScriptScreensList")
            Return _ds.Tables("ScriptScreensList")
        End If

    End Function

    Public Shared Function GetScriptScreensDataReader(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptID As Integer) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(Connection, CommandType.Text, _
            "SELECT * , CAST(ItemOrder AS varchar(10)) + '. ' + Title AS ScreenTitle FROM ScriptScreens WHERE ScriptID = @ScriptID ORDER BY ItemOrder", _
            New SqlClient.SqlParameter("@ScriptID", ScriptID))

    End Function

#End Region
    Public Property ScriptID() As Integer
        Get
            Return _iScriptID

        End Get
        Set(ByVal Value As Integer)
            _iScriptID = Value

        End Set
    End Property

    Public Sub ClearAll()
        Dim bEnforce As Boolean = Me.EnforceConstraints
        Me.EnforceConstraints = False

        Me._ds.Tables("Search").Clear()
        Me.CalculationTypesTable.Clear()
        Me.ClearMainTable()
        Me.ScriptScreenCategoriesTable.Clear()

        Me.EnforceConstraints = bEnforce
    End Sub

#Region "datagrid funcs"
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
                Me._ReOrderScriptScreens()
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
        Dim iScriptScreenID As Integer
        Dim iSortIndex As Integer

        For Each dgi In dg.Items
            iScriptScreenID = dg.DataKeys(dgi.ItemIndex)
            iSortIndex = CType(dgi.FindControl("ddlItemOrder"), System.Web.UI.WebControls.DropDownList).SelectedItem.Value
            dr = Me.SelectRow(String.Format(_sDeleteFilter, iScriptScreenID))
            If iSortIndex <> CInt(dr.Item("ItemOrder")) Then dr.Item("ItemOrder") = iSortIndex

        Next

        Me._ReOrderScriptScreens()
        Me.Save()
        If Me._sErrorMsg.Length > 0 Then _ds.RejectChanges()

        're-bind dataset to datagrid
        DMI.clsDataGridTools.DataGridBind(dg, Me, sSortBy)

    End Function

#End Region

    Private Sub _ReOrderScriptScreens()
        Dim drv As DataRowView
        Dim iNewItemOrder As Integer = 1

        Me.MainDataTable.DefaultView.Sort = "ItemOrder"

        For Each drv In Me.MainDataTable.DefaultView
            If CInt(drv("ItemOrder")) <> iNewItemOrder Then drv("ItemOrder") = iNewItemOrder
            iNewItemOrder += 1

        Next

    End Sub

    Public Shared Function ScreenCount(ByVal connection As SqlClient.SqlConnection, ByVal iScriptID As Integer) As Integer
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(ScriptScreenID) FROM ScriptScreens WHERE ScriptID = {0}", iScriptID)

        iCount = SqlHelper.ExecuteScalar(connection, CommandType.Text, sbSQL.ToString)
        sbSQL = Nothing

        Return iCount

    End Function

    <Obsolete("Use FindScreenRowByIndex")> _
    Public Function FindByScreenIndex(ByVal i As Integer) As DataRow
        Dim dv As DataView = MainDataTable.DefaultView

        If i > 0 Then
            dv.Sort = "ItemOrder"
            Return dv.Item(i - 1).Row

        End If

        Return Nothing

    End Function

    Public Function FindScreenRowByIndex(ByVal Index As Integer) As DataRow
        Dim dr() As DataRow
        Dim sFilter As String = String.Format("ItemOrder = {0}", Index)

        dr = MainDataTable.Select(sFilter)
        If dr.Length > 0 Then Return dr(0)

        Return Nothing

    End Function

    Public Function FindScreenRowByID(ByVal ID As Integer) As DataRow
        Dim dr() As DataRow
        Dim sFilter As String = String.Format("ScriptScreenID = {0}", ID)

        dr = MainDataTable.Select(sFilter)
        If dr.Length > 0 Then Return dr(0)

        Return Nothing

    End Function

    Public Function LookupScreenID(ByVal Index As Integer) As Integer
        Dim dr As DataRow
        dr = FindScreenRowByIndex(Index)
        If Not IsNothing(dr) Then Return CInt(dr.Item("ScriptScreenID"))
        Return 0

    End Function

    Public Function LookupScreenIndex(ByVal ID As Integer) As Integer
        Dim dr As DataRow
        dr = FindScreenRowByID(ID)
        If Not IsNothing(dr) Then Return CInt(dr.Item("ItemOrder"))
        Return 0

    End Function

    Public Shared Function GetScriptScreenID(ByVal connection As SqlClient.SqlConnection, ByVal scriptID As Integer, ByVal screenIndex As Integer) As Integer
        Dim sql As String
        Dim result As Object
        sql = String.Format("SELECT ScriptScreenID FROM ScriptScreens WHERE ScriptID = {0} AND ItemOrder = {1}", scriptID, screenIndex)
        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.DataHandler.NULLRECORDID

    End Function

    Public Shared Function GetScriptScreenIndex(ByVal connection As SqlClient.SqlConnection, ByVal scriptID As Integer, ByVal screenID As Integer) As Integer
        Dim sql As String
        Dim result As Object
        sql = String.Format("SELECT ItemOrder FROM ScriptScreens WHERE ScriptID = {0} AND ScriptScreenID = {1}", scriptID, screenID)
        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return -1

    End Function

    Public Shared Function GetScriptID(ByVal connection As SqlClient.SqlConnection, ByVal scriptScreenID As Integer) As Integer
        Dim sql As String
        Dim result As Object
        sql = String.Format("SELECT ScriptID FROM ScriptScreens WHERE ScriptScreenID = {0}", scriptScreenID)
        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.DataHandler.NULLRECORDID

    End Function

    Public Shared Function GetSurveyQuestionID(ByVal connection As SqlClient.SqlConnection, ByVal scriptScreenID As Integer) As Integer
        Dim sql As String
        Dim result As Object
        sql = String.Format("SELECT SurveyQuestionID FROM ScriptScreens WHERE ScriptScreenID = {0}", scriptScreenID)
        result = SqlHelper.ExecuteScalar(connection, CommandType.Text, sql)
        If Not IsNothing(result) AndAlso Not IsDBNull(result) Then
            Return CInt(result)
        End If
        Return DMI.DataHandler.NULLRECORDID

    End Function

    Public Shared Function GetScreenTitle(ByVal Connection As SqlClient.SqlConnection, ByVal ScriptScreenID As Integer) As String
        Return SqlHelper.ExecuteScalar(Connection, CommandType.Text, _
            "SELECT Title FROM ScriptScreens WHERE ScriptScreenID = @ScriptScreenID", _
            New SqlClient.SqlParameter("@ScriptScreenID", ScriptScreenID))

    End Function
End Class
