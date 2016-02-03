Imports Microsoft.Practices.EnterpriseLibrary.Data
Imports System.Text.RegularExpressions
Imports DMI
Imports System.Data.Common

Public Class clsFileDefColumns
    Inherits DMI.clsDBEntity2

    Private _iFileDefID As Integer
    Private _sColumnName As String

#Region "dbEntity2 Overrides"
    Public Sub New(ByRef conn As SqlClient.SqlConnection)
        MyBase.New(conn)

    End Sub

    Public Sub New(ByRef sConn As String)
        MyBase.New(sConn)

    End Sub

    Protected Overrides Sub _FillLookups(ByRef drCriteria As System.Data.DataRow)
        'no lookups

    End Sub

    Protected Overrides Function BuildSelectSQL(ByVal drCriteria As DataRow) As String
        Dim dr As dsFileDefColumns.SearchRow
        Dim sbSQL As New System.Text.StringBuilder

        dr = CType(drCriteria, dsFileDefColumns.SearchRow)

        'Primary key criteria
        If Not dr.IsFileDefColumnIDNull Then sbSQL.AppendFormat("FileDefColumnID = {0} AND ", dr.FileDefColumnID)
        'file def criteria
        If Not dr.IsFileDefIDNull Then sbSQL.AppendFormat("FileDefID = {0} AND ", dr.FileDefID)
        'client criteria
        If Not dr.IsClientIDNull Then sbSQL.AppendFormat("FileDefID IN (SELECT FileDefID FROM FileDefs WHERE ClientID = {0}) AND ", dr.ClientID)
        'survey criteria
        If Not dr.IsSurveyIDNull Then sbSQL.AppendFormat("FileDefID IN (SELECT FileDefID FROM FileDefs WHERE SurveyID = {0}) AND ", dr.SurveyID)
        'file def type criteria
        If Not dr.IsFileDefTypeIDNull Then sbSQL.AppendFormat("FileDefID IN (SELECT FileDefID FROM FileDefs WHERE FileDefTypeID = {0}) AND ", dr.FileDefTypeID)
        'file type criteria
        If Not dr.IsFileTypeIDNull Then sbSQL.AppendFormat("FileDefID IN (SELECT FileDefID FROM FileDefs WHERE FileTypeID = {0}) AND ", dr.FileTypeID)

        'Clean up criteria
        If sbSQL.Length > 0 Then
            DMI.clsUtil.Chop(sbSQL, 4)
            sbSQL.Insert(0, "WHERE ")

        End If

        'Add select statement
        sbSQL.Insert(0, "SELECT * FROM FileDefColumns ")

        Return sbSQL.ToString

    End Function

    Protected Overrides Function DeleteCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("delete_FileDefColumns", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefColumnID", SqlDbType.Int, 4, "FileDefColumnID"))

        Return oCmd

    End Function

    Protected Overrides Sub InitSettings()
        'init class variables
        _ds = New dsFileDefColumns
        _dtMainTable = _ds.Tables("FileDefColumns")
        _sDeleteFilter = "FileDefColumnID = {0}"

    End Sub

    Protected Overrides Function InsertCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("insert_FileDefColumns", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefColumnID", SqlDbType.Int, 4, "FileDefColumnID"))
        oCmd.Parameters("@FileDefColumnID").Direction = ParameterDirection.Output
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefID", SqlDbType.Int, 4, "FileDefID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ColumnName", SqlDbType.VarChar, 250, "ColumnName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DisplayOrder", SqlDbType.Int, 4, "DisplayOrder"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Width", SqlDbType.Int, 4, "Width"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FormatString", SqlDbType.VarChar, 50, "FormatString"))

        Return oCmd

    End Function

    Protected Overrides Sub SetIdentityFilter(ByVal iEntityID As Integer, ByRef drCriteria As System.Data.DataRow)
        drCriteria.Item("FileDefColumnID") = iEntityID

    End Sub

    Protected Overrides Function UpdateCommand() As System.Data.SqlClient.SqlCommand
        Dim oCmd As SqlClient.SqlCommand

        oCmd = New SqlClient.SqlCommand("update_FileDefColumns", Me._oConn)
        oCmd.CommandType = CommandType.StoredProcedure
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefColumnID", SqlDbType.Int, 4, "FileDefColumnID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FileDefID", SqlDbType.Int, 4, "FileDefID"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@ColumnName", SqlDbType.VarChar, 250, "ColumnName"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@DisplayOrder", SqlDbType.Int, 4, "DisplayOrder"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@Width", SqlDbType.Int, 4, "Width"))
        oCmd.Parameters.Add(New SqlClient.SqlParameter("@FormatString", SqlDbType.VarChar, 50, "FormatString"))

        Return oCmd

    End Function

    Protected Overrides Sub SetNewRowDefaults(ByRef dr As System.Data.DataRow)
        dr.Item("FileDefID") = _iFileDefID
        dr.Item("ColumnName") = _sColumnName
        dr.Item("DisplayOrder") = ColumnCount(_iFileDefID) + 1
        If clsFileDefs.GetFileTypeID(_oConn, _iFileDefID) = 4 Then
            dr.Item("Width") = DefaultColumnWidth(_sColumnName)

        End If

    End Sub

    Protected Overrides Function VerifyInsert(ByVal dr As System.Data.DataRow) As Boolean
        Dim bVerify As Boolean = True

        If Not VerifyExistingColumn(dr) Then bVerify = False
        If Not VerifyColumnWidth(dr) Then bVerify = False

        Return bVerify

    End Function

    Protected Overrides Function VerifyUpdate(ByVal dr As System.Data.DataRow) As Boolean
        Return VerifyColumnWidth(dr)

    End Function

#End Region

    Public Property FileDefID() As Integer
        Get
            Return _iFileDefID

        End Get
        Set(ByVal Value As Integer)
            _iFileDefID = Value

        End Set
    End Property

    Public Property ColumnName() As String
        Get
            Return _sColumnName

        End Get
        Set(ByVal Value As String)
            _sColumnName = Value

        End Set
    End Property

    Public Function ColumnCount(ByVal iFileDefID As Integer) As Integer
        Dim sbSQL As New Text.StringBuilder
        Dim iCount As Integer

        sbSQL.AppendFormat("SELECT COUNT(FileDefColumnID) FROM FileDefColumns WHERE FileDefID = {0}", iFileDefID)

        iCount = SqlHelper.ExecuteScalar(Me._oConn, CommandType.Text, sbSQL.ToString)
        sbSQL = Nothing

        Return iCount

    End Function

    Private Sub _ReOrderColumns()
        Dim drv As DataRowView
        Dim iNewItemOrder As Integer = 1

        Me.MainDataTable.DefaultView.Sort = "DisplayOrder"

        For Each drv In Me.MainDataTable.DefaultView
            If CInt(drv("DisplayOrder")) <> iNewItemOrder Then drv("DisplayOrder") = iNewItemOrder
            iNewItemOrder += 1

        Next

    End Sub

    Public Shared Function GetColumnNames(ByVal oConn As SqlClient.SqlConnection, ByVal iFileDefID As Integer) As SqlClient.SqlDataReader
        Return SqlHelper.ExecuteReader(oConn, CommandType.StoredProcedure, "spFileDefColumns", _
            New SqlClient.SqlParameter("@FileDefID", iFileDefID))

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
                Me._ReOrderColumns()
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
    Public Function DataGridUpdateOrder(ByRef dg As System.Web.UI.WebControls.DataGrid, Optional ByVal sSortBy As String = "") As Integer
        Dim dgi As System.Web.UI.WebControls.DataGridItem
        Dim dr As DataRow
        Dim iQuestionID As Integer
        Dim iSortIndex As Integer

        For Each dgi In dg.Items
            iQuestionID = dg.DataKeys(dgi.ItemIndex)
            iSortIndex = CType(dgi.FindControl("ddlSortIndex"), System.Web.UI.WebControls.DropDownList).SelectedItem.Value
            dr = Me.SelectRow(String.Format(_sDeleteFilter, iQuestionID))
            If iSortIndex <> CInt(dr.Item("DisplayOrder")) Then dr.Item("DisplayOrder") = iSortIndex

        Next

        Me._ReOrderColumns()
        Me.Save()
        If Me._sErrorMsg.Length > 0 Then _ds.RejectChanges()

        're-bind dataset to datagrid
        DMI.clsDataGridTools.DataGridBind(dg, Me, sSortBy)

    End Function

#End Region

    Private Function DefaultColumnWidth(ByVal sColName As String) As Integer
        Dim oDC As New clsDataColumn

        oDC.FileDefColName = sColName

        Return oDC.GetColWidth

    End Function

    Private Function VerifyColumnWidth(ByVal dr As DataRow) As Boolean
        If clsFileDefs.GetFileTypeID(_oConn, _iFileDefID) = 4 Then
            If dr.Item("Width") = 0 Then
                Me._sErrorMsg &= String.Format("{0} must be greater than zero.\n", dr.Item("ColumnName"))
                Return False

            End If

        End If

        Return True

    End Function

    Private Function VerifyExistingColumn(ByVal dr As DataRow) As Boolean
        Dim drResult() As DataRow

        'if has parent row
        If Not IsNothing(dr.GetParentRow("FileDefsFileDefColumns")) Then
            If dr.Table.Select(String.Format("ColumnName = '{0}' AND FileDefColumnID <> {1}", Replace(dr.Item("ColumnName"), "'", "''"), dr.Item("FileDefColumnID"))).Length > 0 Then
                Me._sErrorMsg &= String.Format("{0} column already exists.\n", dr.Item("ColumnName"))
                dr.RejectChanges()
                Return False

            End If
        End If

        Return True

    End Function

    Public Function ContainsColumnName(ByVal sColumnName As String) As Boolean
        ' allow multiple skip fields
        If (sColumnName = "Skip Field") Then Return False
        ' all other fields are allowed only once
        If MainDataTable.Select(String.Format("ColumnName = '{0}'", Replace(sColumnName, "'", "''"))).Length > 0 Then
            Me._sErrorMsg &= String.Format("{0} column already exists.\n", sColumnName)
            Return True

        End If

        Return False

    End Function

    Public Function ContainsRespondentColumns() As Boolean
        Dim dc As New clsDataColumn
        Dim dr As DataRow

        For Each dr In Me.MainDataTable.Rows
            dc.FileDefColName = dr.Item("ColumnName").ToString
            If dc.IsTableRespondents Then
                dc = Nothing
                Return True

            End If

        Next

        dc = Nothing
        Return False

    End Function

    Public Function ContainsQuestionColumns() As Boolean
        Dim dc As New clsDataColumn
        Dim dr As DataRow

        For Each dr In Me.MainDataTable.Rows
            dc.FileDefColName = dr.Item("ColumnName").ToString
            If dc.IsTableQuestions Then
                dc = Nothing
                Return True

            End If

        Next

        dc = Nothing
        Return False

    End Function

    Public Function ContainsRespondentPropertyColumns() As Boolean
        Dim dc As New clsDataColumn
        Dim dr As DataRow

        For Each dr In Me.MainDataTable.Rows
            dc.FileDefColName = dr.Item("ColumnName").ToString
            If dc.IsTableRespondentProperties Then
                dc = Nothing
                Return True

            End If

        Next

        dc = Nothing
        Return False

    End Function

    Public Function AllowMultiSkipFields(ByVal sColumnName As String) As String
        Dim sSkipField As String = "Skip Field"

        If (sColumnName = sSkipField) Then
            Dim drArray As DataRow() = MainDataTable.Select(String.Format("ColumnName LIKE '{0}%'", sSkipField))
            If (drArray.Length > 0) Then
                Dim i As Integer = 1
                Dim dr As DataRow
                For Each dr In drArray
                    Dim m As Match = Regex.Match(dr("ColumnName"), "\d+")
                    If (m.Groups.Count > 0) AndAlso IsNumeric(m.Groups(0).ToString) Then
                        If (CInt(m.Groups(0).ToString) >= i) Then
                            i += 1
                        End If
                    End If
                Next

                Return String.Format("Skip Field {0}", i)

            End If
        End If
        Return sColumnName

    End Function

End Class
