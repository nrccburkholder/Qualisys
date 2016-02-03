Imports System.Text
Imports System.IO
Imports PS.Framework.BusinessLogic.Validation

Public Class CommonMethods
    Public Shared Function Get1stStackTrace(ByVal valiadtions As ObjectValidations) As String
        Dim retVal As String = String.Empty
        For Each item As ObjectValidation In valiadtions.MyValidations
            If item.MessageType = PS.Framework.BusinessLogic.Validation.MessageTypes.Error Then
                If item.StackTrace.Length > 0 Then
                    retVal = item.StackTrace
                    Exit For
                End If
            End If
        Next
        Return retVal
    End Function
    Public Shared Function DataFileToCSV(ByVal dt As DataTable) As String
        Dim sb As New StringBuilder
        Dim line As String = ""
        For i As Integer = 0 To dt.Columns.Count - 1
            Dim col As DataColumn = dt.Columns(i)
            line += Escape(col.ColumnName) & ","
        Next
        If line.Length > 0 Then line = line.Substring(0, line.Length - 1)
        sb.AppendLine(line)
        line = ""
        For j As Integer = 0 To dt.Rows.Count - 1
            Dim row As DataRow = dt.Rows(j)
            For Each col As DataColumn In dt.Columns
                line += Escape(NullString(row(col.ColumnName))) & ","
            Next
            If line.Length > 0 Then line = line.Substring(0, line.Length - 1)
            sb.AppendLine(line)
            line = ""
        Next
        Return sb.ToString
    End Function
    Public Shared Function AppendLastSlash(ByVal dirName As String) As String
        dirName = dirName.Trim
        If (Not dirName.EndsWith("\")) Then
            dirName += "\"
        End If
        Return dirName
    End Function
    Public Shared Function AddLeadingChar(ByVal data As String, ByVal leadingChar As Char, ByVal length As Integer) As String
        'Static result As New StringBuilder
        Dim result As New StringBuilder
        result.Remove(0, result.Length)
        result.Append(leadingChar, length)
        result.Append(data)
        Return result.ToString.Substring(result.Length - length, length)
    End Function
    Public Shared Function Escape(ByVal strValue As String) As String
        If InStr(strValue, ",") > 0 Then
            strValue = Replace(strValue, Chr(34), "/" & Chr(34))
            strValue = Chr(34) & strValue & Chr(34)
            Return strValue
        Else
            Return strValue
        End If
    End Function
    Public Shared Function NullString(ByVal val As Object) As String
        If IsDBNull(val) Then
            Return ""
        Else
            Return CStr(val)
        End If
    End Function
    Public Shared Function CleanFolderName(ByVal Str As String) As String
        Dim tempString As String = "F_"
        For Each c As Char In Str
            Dim charInt As Integer = Asc(c)
            If (charInt >= 48 And charInt <= 57) OrElse (charInt >= 65 And charInt <= 90) OrElse (charInt >= 97 And charInt <= 122) OrElse c = "_"c Then
                tempString += c
            End If
        Next
        If tempString.Length > 250 Then
            Return tempString.Substring(0, 250)
        Else
            Return tempString
        End If
    End Function
    Public Shared Function FileSize(ByVal filePath As String) As Long
        If (Not File.Exists(filePath)) Then Return 0
        Return (New FileInfo(filePath)).Length
    End Function
    Public Shared Function GetYYYMMDDDate() As String
        Return String.Format("{0:D4}{1:D2}{2:D2}", Year(Now).ToString(), Month(Now).ToString, Day(Now).ToString())
    End Function
    Public Shared Function VTToString(ByVal vt As ValidationTypes) As String
        Return [Enum].GetName(vt.GetType(), vt)
    End Function

End Class
