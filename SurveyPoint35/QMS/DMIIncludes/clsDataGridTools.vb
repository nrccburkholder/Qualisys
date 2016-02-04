Option Explicit On
Option Strict On

Imports System.Web
Imports System.Web.UI.WebControls
Imports System.Web.UI.HtmlControls

Public Class clsDataGridTools

#Region "Datatable Functions"
    'bind datatable to datagrid, handing sorting issues
    Shared Function DataGridBind(ByRef dg As DataGrid, ByRef dt As DataTable, Optional ByVal sSortBy As String = "") As Integer
        'Set sort
        If sSortBy.Length > 0 Then dt.DefaultView.Sort = sSortBy

        'Set data source and bind datagrid
        dg.DataSource = dt.DefaultView
        dg.DataBind()

        'return number of rows displayed
        Return dt.Rows.Count

    End Function

    'sorts and binds datatable to datagrid
    Shared Function DataGridSort(ByRef dg As DataGrid, ByRef dt As DataTable, ByVal e As DataGridSortCommandEventArgs, ByVal sLastSort As String) As String
        Dim sSortBy As String

        'cannot be in edit mode when sorting
        If dg.EditItemIndex = -1 Then
            If sLastSort = e.SortExpression Or sLastSort = "" Then
                'click on new column
                sSortBy = e.SortExpression & " DESC"

            Else
                'clicked on same column, restore sort
                sSortBy = e.SortExpression

            End If

            're-bind dataset to datagrid
            DataGridBind(dg, dt, sSortBy)

        End If

        Return sSortBy

    End Function

    'deletes select rows in datagrid from datatable
    'note: deletes are not committed to database - db update must be handled by calling routine
    Shared Function DataGridDelete(ByRef dg As DataGrid, ByRef dt As DataTable, ByVal sDeleteFilter As String, Optional ByVal sSortBy As String = "") As Integer
        Dim dgi As DataGridItem
        Dim sFilter As String
        Dim iDeleteCount As Integer = 0
        Dim iLastPageIndex As Integer

        'cannot be in edit mode when deleting
        If dg.EditItemIndex = -1 Then
            For Each dgi In dg.Items
                If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                    sFilter = String.Format(sDeleteFilter, dg.DataKeys(dgi.ItemIndex))
                    If Not DataTableDelete(dt, sFilter) Then Exit For
                    iDeleteCount += 1

                End If
            Next

            If iDeleteCount > 0 Then
                'if datagrid paging is in use, check for valid current page index 
                iLastPageIndex = LastPageIndex(dg, dt.Rows.Count)
                If dg.CurrentPageIndex > 0 AndAlso dg.CurrentPageIndex > iLastPageIndex Then
                    dg.CurrentPageIndex = iLastPageIndex

                End If

            End If

            'display delete results
            If iDeleteCount > 0 Then
                'successful deletes
                DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Deletes", iDeleteCount))

            Else
                'no deletes
                DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

            End If

            're-bind dataset to datagrid
            DataGridBind(dg, dt, sSortBy)

        End If

        Return iDeleteCount

    End Function

    'changes page index and binds datagrid to datatable
    Shared Sub DataGridPageChange(ByRef dg As DataGrid, ByRef dt As DataTable, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs, Optional ByVal sSortBy As String = "")
        'datagrid cannot be in edit mode when changing page
        If dg.EditItemIndex = -1 Then
            'change page index
            dg.CurrentPageIndex = e.NewPageIndex
            're-bind dataset to datagrid
            DataGridBind(dg, dt, sSortBy)

        End If

    End Sub

    'deletes rows from datatable based on row filter
    Public Shared Function DataTableDelete(ByVal dt As DataTable, ByVal sRowFilter As String) As Boolean
        Dim drs As DataRow()
        Dim dr As DataRow

        'get rows to delete
        drs = dt.Select(sRowFilter)

        If drs.Length > 0 Then

            For Each dr In drs

                Try
                    'delete each row
                    dr.Delete()

                Catch
                    'error occurred, rollback deletes
                    dt.RejectChanges()
                    Return False

                End Try

            Next

        Else
            'no rows deleted
            Return False

        End If

        Return True

    End Function

    'set row to edit mode and binds datagrid to datatable
    Shared Sub DataGridEditItem(ByRef dg As DataGrid, ByRef dt As DataTable, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs, Optional ByVal sSortBy As String = "")
        'datagrid cannot already be in edit mode when changing page
        If dg.EditItemIndex = -1 Then
            'set edit index
            dg.EditItemIndex = e.Item.ItemIndex
            're-bind dataset to datagrid
            DataGridBind(dg, dt, sSortBy)

        End If

    End Sub

    'add new row and set for edit
    Shared Sub DataGridNewItem(ByRef dg As DataGrid, ByRef dt As DataTable, ByRef dr As DataRow, ByVal sSortBy As String)
        'datagrid cannot already be in edit mode
        If dg.EditItemIndex = -1 Then
            dt.Rows.Add(dr)
            'assume row is added to end of table
            dg.CurrentPageIndex = LastPageIndex(dg, dt.Rows.Count)
            dg.EditItemIndex = dt.Rows.Count - 1
            're-bind dataset to datagrid
            DataGridBind(dg, dt, sSortBy)

        End If
    End Sub

#End Region

#Region "dbEntity Functions"
    'binds dbentity to datagrid, handling sorting issues
    Shared Function DataGridBind(ByRef dg As DataGrid, ByRef en As clsDBEntity, Optional ByVal sSortBy As String = "") As Integer
        Dim dt As DataTable = en.MainDataTable

        'return number of rows displayed
        Return DataGridBind(dg, dt, sSortBy)

    End Function

    'sorts and binds dbentity to datagrid
    Shared Function DataGridSort(ByRef dg As DataGrid, ByRef en As clsDBEntity, ByVal e As DataGridSortCommandEventArgs, ByVal sLastSort As String) As String
        Dim dt As DataTable = en.MainDataTable

        Return DataGridSort(dg, dt, e, sLastSort)

    End Function

    'deletes selected rows in datagrid from dbentity
    Shared Function DataGridDelete(ByRef dg As DataGrid, ByRef en As clsDBEntity, ByVal sDeleteFilter As String, Optional ByVal sSortBy As String = "") As Integer
        Dim dgi As DataGridItem
        Dim sFilter As String
        Dim iDeleteCount As Integer = 0

        'cannot be in edit mode when deleting
        If dg.EditItemIndex = -1 Then
            For Each dgi In dg.Items
                If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                    sFilter = String.Format(sDeleteFilter, dg.DataKeys(dgi.ItemIndex))
                    If Not en.Delete(sFilter) Then Exit For
                    iDeleteCount += 1

                End If
            Next

            If iDeleteCount > 0 Then
                'deletes were made, refresh dataset
                en.Save()

                'if datagrid paging is in use, check for valid current page index 
                If dg.CurrentPageIndex > 0 AndAlso (en.MainDataTable.Rows.Count \ dg.PageSize) <= (dg.CurrentPageIndex + 1) Then
                    dg.CurrentPageIndex = en.MainDataTable.Rows.Count \ dg.PageSize - 1

                End If

            End If

            'display delete results
            If en.ErrMsg.Length > 0 Then
                'error occured
                DMI.WebFormTools.Msgbox(dg.Page, en.ErrMsg)

            ElseIf iDeleteCount > 0 Then
                'successful deletes
                DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Deletes", iDeleteCount))

            Else
                'no deletes
                DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

            End If

            're-bind dataset to datagrid
            DataGridBind(dg, en, sSortBy)

        End If

        Return iDeleteCount

    End Function

    'changes page index and binds datagrid to dbentity
    Shared Sub DataGridPageChange(ByRef dg As DataGrid, ByRef en As clsDBEntity, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs, Optional ByVal sSortBy As String = "")
        Dim dt As DataTable = en.MainDataTable

        DataGridPageChange(dg, dt, e, sSortBy)

    End Sub

    'set row to edit mode and binds datagrid to datatable
    Shared Sub DataGridEditItem(ByRef dg As DataGrid, ByRef en As clsDBEntity, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs, Optional ByVal sSortBy As String = "")
        Dim dt As DataTable = en.MainDataTable

        DataGridEditItem(dg, dt, e, sSortBy)

    End Sub

#End Region

#Region "dbEntity2 DataSet Functions"
    'binds dbentity to datagrid, handling sorting issues
    Shared Function DataGridBind(ByRef dg As DataGrid, ByRef en As clsDBEntity2, Optional ByVal sSortBy As String = "") As Integer
        Dim dt As DataTable = en.MainDataTable

        'return number of rows displayed
        Return DataGridBind(dg, dt, sSortBy)

    End Function

    'sorts and binds dbentity to datagrid
    Shared Function DataGridSort(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal e As DataGridSortCommandEventArgs, ByVal sLastSort As String) As String
        Dim dt As DataTable = en.MainDataTable

        Return DataGridSort(dg, dt, e, sLastSort)

    End Function

    'deletes selected rows in datagrid from dbentity
    Shared Function DataGridDelete(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal sDeleteFilter As String, Optional ByVal sSortBy As String = "") As Integer
        Dim dgi As DataGridItem
        Dim sFilter As String
        Dim iDeleteCount As Integer = 0
        Dim iLastPageIndex As Integer = 0

        'cannot be in edit mode when deleting
        If dg.EditItemIndex = -1 Then
            For Each dgi In dg.Items
                If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                    sFilter = String.Format(sDeleteFilter, dg.DataKeys(dgi.ItemIndex))
                    If Not en.Delete(sFilter) Then Exit For
                    iDeleteCount += 1

                End If
            Next

            If iDeleteCount > 0 Then
                'deletes were made, refresh dataset
                en.Save()

            End If

            'display delete results
            If en.ErrMsg.Length > 0 Then
                'error occured
                DMI.WebFormTools.Msgbox(dg.Page, en.ErrMsg)

                'rollback deletes
                en.MainDataTable.RejectChanges()

            ElseIf iDeleteCount > 0 Then
                'successful deletes
                DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Deletes", iDeleteCount))

                'calculate last page index
                iLastPageIndex = LastPageIndex(dg, en.MainDataTable.Rows.Count)

                'if datagrid paging is in use, check for valid current page index 
                If dg.CurrentPageIndex > 0 AndAlso dg.CurrentPageIndex > iLastPageIndex Then
                    dg.CurrentPageIndex = iLastPageIndex

                End If

            Else
                'no deletes
                DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

            End If

            're-bind dataset to datagrid
            DataGridBind(dg, en, sSortBy)

        End If

        Return iDeleteCount

    End Function

    'changes page index and binds datagrid to dbentity
    Shared Sub DataGridPageChange(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs, Optional ByVal sSortBy As String = "")
        Dim dt As DataTable = en.MainDataTable

        DataGridPageChange(dg, dt, e, sSortBy)

    End Sub

    'set row to edit mode and binds datagrid to datatable
    Shared Sub DataGridEditItem(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal e As System.Web.UI.WebControls.DataGridCommandEventArgs, Optional ByVal sSortBy As String = "")
        Dim dt As DataTable = en.MainDataTable

        DataGridEditItem(dg, dt, e, sSortBy)

    End Sub

    'add new row and set for edit
    Shared Sub DataGridNewItem(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByRef dr As DataRow, ByVal sSortBy As String)
        'datagrid cannot already be in edit mode
        If dg.EditItemIndex = -1 Then
            en.AddMainRow(dr)
            'assume row is added to end of table
            dg.CurrentPageIndex = LastPageIndex(dg, en.MainDataTable.Rows.Count)
            dg.EditItemIndex = en.MainDataTable.Rows.Count - 1
            're-bind dataset to datagrid
            DataGridBind(dg, en.MainDataTable, sSortBy)

        End If
    End Sub

    'add new row and set for edit
    Shared Sub DataGridNewItem(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal sSortBy As String)
        'datagrid cannot already be in edit mode
        If dg.EditItemIndex = -1 Then
            en.AddMainRow()
            'assume row is added to end of table
            dg.CurrentPageIndex = LastPageIndex(dg, en.MainDataTable.Rows.Count)
            dg.EditItemIndex = LastRowIndex(dg, en.MainDataTable.Rows.Count)
            're-bind dataset to datagrid
            DataGridBind(dg, en.MainDataTable, sSortBy)

        End If
    End Sub

    'cancel edit mode
    Shared Sub DataGridCancel(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal sSortBy As String)
        'is datagrid in edit mode
        If dg.EditItemIndex >= 0 Then
            'remove any new rows
            en.ClearCancelledNewRow()
            dg.EditItemIndex = -1
            're-bind dataset to datagrid
            DataGridBind(dg, en.MainDataTable, sSortBy)

        End If

    End Sub

    Shared Function DataGridRowProcessor(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal RowProcessor As DMI.clsRowProcessor, Optional ByVal sSortBy As String = "") As Integer
        Dim dgi As DataGridItem
        Dim sFilter As String
        Dim iRowCount As Integer = 0
        Dim iLastPageIndex As Integer = 0
        Dim dr As DataRow

        'cannot be in edit mode when deleting
        If dg.EditItemIndex = -1 Then
            For Each dgi In dg.Items
                If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                    dr = en.SelectRow(CInt(dg.DataKeys(dgi.ItemIndex)))
                    If Not IsNothing(dr) Then
                        If RowProcessor.Process(dr) Then
                            iRowCount += 1

                        Else
                            Exit For

                        End If

                    End If
                End If
            Next

            'display results
            If RowProcessor.ErrorMessage.Length > 0 Then
                'error occured
                DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Rows Affected\n{1}", iRowCount, RowProcessor.ErrorMessage))

            ElseIf iRowCount > 0 Then
                'successful row processing
                DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Rows Affected", iRowCount))

                'calculate last page index
                iLastPageIndex = LastPageIndex(dg, en.MainDataTable.Rows.Count)

                'if datagrid paging is in use, check for valid current page index 
                If dg.CurrentPageIndex > 0 AndAlso dg.CurrentPageIndex > iLastPageIndex Then
                    dg.CurrentPageIndex = iLastPageIndex

                End If

            Else
                'nothing done
                DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

            End If

            're-bind dataset to datagrid
            DataGridBind(dg, en, sSortBy)

        End If

        Return iRowCount

    End Function

#End Region

#Region "dbEntity2 DataReader Functions"
    'binds dbentity to datagrid, handling sorting issues
    Shared Function DRDataGridBind(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal drCriteria As DataRow, Optional ByVal sSortBy As String = "") As Integer
        Dim dr As SqlClient.SqlDataReader

        dr = en.GetDataReader(drCriteria, sSortBy)

        'Set data source and bind datagrid
        dg.DataSource = dr
        dg.DataBind()
        dr.Close()

        'return number of rows displayed
        Return dg.Items.Count

    End Function

    'returns new sort column name
    Shared Function DataGridSort(ByVal e As DataGridSortCommandEventArgs, ByVal sLastSort As String) As String

        If sLastSort = e.SortExpression Then
            'clicked on same column, reverse sort
            sLastSort = e.SortExpression & " DESC"

        Else
            'click on new column
            sLastSort = e.SortExpression

        End If

        're-bind dataset to datagrid
        Return sLastSort

    End Function

    'deletes selected rows in datagrid from dbentity
    <Obsolete("Not completed yet", False)> _
    Shared Function DRDataGridDelete(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal drCriteria As DataRow, ByVal sDeleteFilter As String, Optional ByVal sLastSort As String = "") As Integer
        Dim dgi As DataGridItem
        Dim sFilter As String
        Dim iDeleteCount As Integer = 0

        'cannot be in edit mode when deleting
        If dg.EditItemIndex = -1 Then
            For Each dgi In dg.Items
                If CType(dgi.FindControl("cbSelected"), CheckBox).Checked Then
                    sFilter = String.Format(sDeleteFilter, dg.DataKeys(dgi.ItemIndex))
                    If Not en.Delete(sFilter) Then Exit For
                    iDeleteCount += 1

                End If
            Next

            If iDeleteCount > 0 Then
                'deletes were made, refresh dataset
                en.Save()

                'if datagrid paging is in use, check for valid current page index 
                If dg.CurrentPageIndex > 0 AndAlso (en.MainDataTable.Rows.Count \ dg.PageSize) <= (dg.CurrentPageIndex + 1) Then
                    dg.CurrentPageIndex = en.MainDataTable.Rows.Count \ dg.PageSize - 1

                End If

            End If

            'display delete results
            If en.ErrMsg.Length > 0 Then
                'error occured
                DMI.WebFormTools.Msgbox(dg.Page, en.ErrMsg)

            ElseIf iDeleteCount > 0 Then
                'successful deletes
                DMI.WebFormTools.Msgbox(dg.Page, String.Format("{0} Deletes", iDeleteCount))

            Else
                'no deletes
                DMI.WebFormTools.Msgbox(dg.Page, "Nothing Selected")

            End If

            're-bind dataset to datagrid
            DRDataGridBind(dg, en, drCriteria, sLastSort)

        End If

        Return iDeleteCount

    End Function

    'changes page index and binds datagrid to dbentity
    <Obsolete("Not completed yet", False)> _
    Shared Sub DRDataGridPageChange(ByRef dg As DataGrid, ByRef en As clsDBEntity2, ByVal drCriteria As DataRow, ByVal e As System.Web.UI.WebControls.DataGridPageChangedEventArgs, Optional ByVal sLastSort As String = "")
        'datagrid cannot be in edit mode when changing page
        If dg.EditItemIndex = -1 Then
            'change page index
            dg.CurrentPageIndex = e.NewPageIndex
            're-bind dataset to datagrid
            DRDataGridBind(dg, en, drCriteria, sLastSort)

        End If

    End Sub

#End Region

    <Obsolete("use version with datagrid parameter")> _
    Public Shared Function LastPageIndex(ByVal iPageSize As Integer, ByVal iRecordCount As Integer) As Integer
        If iPageSize > 0 Then
            'note: add 1 for fraction of page minus 1 for base 0 index
            Return (iRecordCount \ iPageSize) + CInt(IIf(iRecordCount Mod iPageSize > 0, 1, 0)) - 1

        Else
            Return 0

        End If

    End Function

    Public Shared Function LastPageIndex(ByRef dg As DataGrid, ByVal iRecordCount As Integer) As Integer
        Dim iPageSize As Integer

        If dg.PageCount > 1 Then
            iPageSize = dg.PageSize
            If iPageSize > 0 Then
                'note: add 1 for fraction of page minus 1 for base 0 index
                Return (iRecordCount \ iPageSize) + CInt(IIf(iRecordCount Mod iPageSize > 0, 1, 0)) - 1

            End If

        End If

        Return 0

    End Function

    <Obsolete("use version with datagrid parameter")> _
    Public Shared Function LastRowIndex(ByVal iPageSize As Integer, ByVal iRecordCount As Integer) As Integer
        If iPageSize > 0 Then
            Return (iRecordCount Mod iPageSize) - 1

        Else
            Return iRecordCount - 1

        End If

    End Function

    Public Shared Function LastRowIndex(ByRef dg As DataGrid, ByVal iRecordCount As Integer) As Integer
        Dim iPageSize As Integer

        If dg.PageCount > 1 Then
            iPageSize = dg.PageSize
            If iPageSize > 0 Then
                Return (iRecordCount Mod iPageSize) - 1
            End If

        End If

        Return iRecordCount - 1

    End Function

End Class
