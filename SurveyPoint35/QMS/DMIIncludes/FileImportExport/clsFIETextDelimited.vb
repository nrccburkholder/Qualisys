Option Explicit On
Option Strict On

Public MustInherit Class clsFIETextDelimited
    Inherits clsFIETextFile

    Protected _sDelimiter As String = vbTab

    Public Sub New(Optional ByVal sFilename As String = "", Optional ByVal sDelimiter As String = "")
        MyBase.New(sFilename)

    End Sub

    Protected Overrides Function GetColValue(ByVal dr As System.Data.DataRow, ByVal drColDef As System.Data.DataRowView) As String
        If CInt(drColDef.Item("ColOrder")) > 1 Then
            Return String.Format("{0}{1}", _sDelimiter, MyBase.GetColValue(dr, drColDef))
        Else
            Return (MyBase.GetColValue(dr, drColDef))
        End If
    End Function

    Protected Overrides Function GetColName(ByVal drColDef As System.Data.DataRowView) As String
        If CInt(drColDef.Item("ColOrder")) > 1 Then
            Return String.Format("{0}{1}", _sDelimiter, MyBase.GetColName(drColDef))
        Else
            Return (MyBase.GetColName(drColDef))
        End If
    End Function
End Class
