Imports System.Data.SqlClient

Public Class UploadFileHistory


    Public Shared Function GetHistory(ByVal groupid As Integer) As DataTable
        'ObjectDataSource1.SelectParameters.Clear()
        'Dim GroupIDparameter As New System.Web.UI.WebControls.Parameter
        'GroupIDparameter.Name = "GroupId"
        'GroupIDparameter.DefaultValue = CurrentUser.SelectedGroup.GroupId
        'ObjectDataSource1.SelectParameters.Add(GroupIDparameter)
        Dim con As New SqlConnection(Config.QP_LoadConnection)
        Dim com As New SqlCommand("LD_SelectUploadFilesByGroupID", con)
        com.CommandType = CommandType.StoredProcedure
        Dim param As New SqlParameter
        Dim Dtb As New DataTable
        Dtb.TableName = "HistoryTable"
        param.ParameterName = "Group_ID"
        param.SqlValue = groupid
        com.Parameters.Add(param)
        param = Nothing
        Dtb.BeginLoadData()
        con.Open()
        Dtb.Load(com.ExecuteReader())
        con.Close()
        Dtb.EndLoadData()
        Dim col As New System.Data.DataColumn
        col.ColumnName = "Packages"
        Dtb.Columns.Add(col)
        col.Dispose()
        For Each row As System.Data.DataRow In Dtb.Rows
            Dim UploadID As String = row.Item("UploadFile_id").ToString
            com = New SqlCommand("LD_SelectUploadFilePackagesByUploadFileID", con)
            com.CommandType = CommandType.StoredProcedure
            param = New SqlParameter
            param.ParameterName = "UploadFile_ID"
            param.SqlValue = UploadID
            com.Parameters.Add(param)
            param = Nothing
            Dim dt As New DataTable
            dt.BeginLoadData()
            con.Open()
            dt.Load(com.ExecuteReader)
            con.Close()
            dt.EndLoadData()
            Dim packagestring As String = String.Empty
            If dt.Rows.Count < 1 Then
                com = New SqlCommand("LD_SelectMsmByUploadFileID", con)
                com.CommandType = CommandType.StoredProcedure
                param = New SqlParameter
                param.ParameterName = "UploadFile_ID"
                param.SqlValue = UploadID
                com.Parameters.Add(param)
                param = Nothing
                con.Open()
                packagestring = com.ExecuteScalar
                con.Close()
            Else
                Dim counter As Integer = 0
                For Each Drow As System.Data.DataRow In dt.Rows
                    counter += 1
                    Dim delimiter As String = String.Empty
                    If dt.Rows.Count > 1 And counter < dt.Rows.Count Then
                        delimiter = " | "
                    End If
                    packagestring += Drow.Item(3).ToString & delimiter
                Next
            End If
            row.Item("Packages") = packagestring
            row.Item("OrigFile_Nm") = row.Item("OrigFile_Nm")
            dt.Dispose()
        Next
        con.Dispose()
        com.Dispose()
        param = Nothing
        Return Dtb
        Dtb.Dispose()

    End Function


End Class
