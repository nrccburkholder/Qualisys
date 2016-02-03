Option Explicit On
Option Strict On

Public Class clsFIEFixedWidth
    Inherits clsFIETextFile

    Public Sub New(Optional ByVal sFilename As String = "")
        MyBase.New(sFilename)
        Me._iFileType = FileTypes.FIXED_WIDTH_TEXT
        Me._sFileFormat = "FixedLength"

    End Sub

    Protected Overrides Function GetColValue(ByVal dr As System.Data.DataRow, ByVal drColDef As System.Data.DataRowView) As String
        Dim sValue As String = dr.Item(drColDef.Item("ColName").ToString).ToString
        Dim iWidth As Integer = CInt(drColDef.Item("ColWidth"))

        If sValue.Length < iWidth Then
            If (IsNumeric(sValue)) Then
                Return sValue.PadLeft(iWidth)
            Else
                Return sValue.PadRight(iWidth)
            End If

        ElseIf sValue.Length > iWidth Then
            Return sValue.Substring(0, iWidth)

        End If

        Return sValue

    End Function

End Class
