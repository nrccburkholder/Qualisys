Imports System.Drawing
Imports System.Windows.Forms

Public Class PickedPrints


    Public Sub AutoSizeCol(ByVal NumCols As Integer, ByVal numRows As Integer, ByRef grd As DataGrid)

        Dim width As Single
        width = 0
        Dim g As Graphics = Graphics.FromHwnd(grd.Handle)
        Dim sf As  New StringFormat(StringFormat.GenericTypographic)
        Dim size As SizeF
        Dim i, j As Integer

        'grd.RowHeaderWidth()
        For j = 0 To NumCols - 1
            size = g.MeasureString(grd.TableStyles("griddata").GridColumnStyles(j).HeaderText() + "MMM", grd.Font, 500, sf)
            width = size.Width
            For i = 0 To numRows - 1
                If Not IsDBNull(grd(i, j)) Then
                    size = g.MeasureString(grd(i, j).ToString + "mm", grd.Font, 500, sf)
                    If (size.Width > width) Then
                        width = size.Width
                    End If
                End If
            Next
            'Try

            grd.TableStyles("griddata").GridColumnStyles(j).Width = CType(width, Integer)
            'Catch
            ' End Try

        Next

        g.Dispose()


    End Sub
    Friend Function showform(ByRef objData As DataTable, ByRef s As String, ByRef frmOwner As frmTestPrint) As Windows.Forms.DialogResult
        Dim frmPickedPrints As New frmPickedPrints
        Dim tableStyle As New DataGridTableStyle
        tableStyle.MappingName = "griddata"
        frmPickedPrints.Label1.Text = s
        frmPickedPrints.grdResult.DataSource = objData
        frmPickedPrints.grdResult.TableStyles.Add(tableStyle)
        If Not objData Is Nothing Then AutoSizeCol(objData.Columns.Count, objData.Rows.Count, frmPickedPrints.grdResult)
        showform = frmPickedPrints.ShowDialog(frmOwner)
    End Function
End Class
