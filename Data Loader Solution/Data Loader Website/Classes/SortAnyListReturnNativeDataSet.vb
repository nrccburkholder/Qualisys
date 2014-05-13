Imports System.Reflection

Public Class SortAnyListReturnNativeDataSet
    Public Shared Function GetDataSetNative(Of T)(ByVal list As List(Of T), ByVal SortProperty As String) As DataSet
        Dim resultDataSet As New DataSet()
        Dim resultDataTable As New DataTable("results")
        Dim resultDataRow As DataRow = Nothing
        Dim itemProperties() As PropertyInfo = list.Item(0).GetType().GetProperties()
        itemProperties = list.Item(0).GetType().GetProperties()
        For Each p As PropertyInfo In itemProperties
            If p.Name <> "OwnerMemberID" Then
                resultDataTable.Columns.Add(p.Name, p.GetGetMethod.ReturnType())
            End If
        Next
        For Each item As T In list
            itemProperties = item.GetType().GetProperties()
            resultDataRow = resultDataTable.NewRow()
            For Each p As PropertyInfo In itemProperties
                Try
                    resultDataRow(p.Name) = p.GetValue(item, Nothing)
                Catch exc As Exception
                    'do nothing at the moment as there are some properties 
                    'that are undefined yet still properties 
                End Try
            Next
            resultDataTable.Rows.Add(resultDataRow)
        Next
        Dim dv As New DataView(resultDataTable)
        dv.Sort = SortProperty
        resultDataSet.Tables.Add(dv.ToTable)
        resultDataTable.Dispose()
        Return resultDataSet
        resultDataSet.Dispose()
        dv.Dispose()
    End Function

End Class
