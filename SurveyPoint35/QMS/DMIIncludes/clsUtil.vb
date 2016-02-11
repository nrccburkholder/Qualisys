Option Strict On
Option Explicit On

Imports Microsoft.Practices.EnterpriseLibrary.Common
Imports Microsoft.Practices.EnterpriseLibrary.Data

Public Class clsUtil

    Public Const NULLDATE As DateTime = #1/1/1900#

    Public Shared Function MakeCSV(ByRef oDV As DataView, ByVal sFieldName As String, Optional ByVal bAlwaysReturnSomething As Boolean = True) As String
        Dim i As Integer
        Dim alKeys As New ArrayList()
        Dim drv As DataRowView
        Const NONIDENTITY As Integer = -2

        'Loop thru dataview column and add distinct values to arraylist
        For Each drv In oDV
            'key id must not be null
            If Not IsDBNull(drv.Item(sFieldName)) Then
                'has key id already been stored
                If Not alKeys.Contains(drv.Item(sFieldName)) Then
                    'add key id to array
                    alKeys.Add(drv.Item(sFieldName))

                End If

            End If
        Next

        'add non-valid identity value to arraylist if array is empty
        If alKeys.Count = 0 And bAlwaysReturnSomething Then alKeys.Add(NONIDENTITY)

        'transfer array values to string array
        Dim sKeys(alKeys.Count - 1) As String
        For i = 0 To alKeys.Count - 1
            sKeys(i) = CType(alKeys(i), String)

        Next

        'concat array values into comma delimited string
        Return String.Join(",", sKeys)

    End Function

    Public Shared Function AppendIfNotBlank(ByVal sValue As String, ByVal sAppend As String) As String

        If sValue.Length > 0 Then
            Return String.Format("{0}{1}", sValue, sAppend)

        End If

        Return ""

    End Function

    Shared Function DeNull(ByVal ThisValue As System.Object, Optional ByVal oIfNullValue As Object = "") As System.Object
        If IsDBNull(ThisValue) Then
            Return oIfNullValue

        ElseIf IsNothing(ThisValue) Then
            Return oIfNullValue

        Else
            Return ThisValue

        End If

    End Function

    Shared Function GetPath(ByVal sFilePath As String) As String
        Dim i As Integer

        i = sFilePath.LastIndexOf("\")
        Return sFilePath.Substring(0, i + 1)

    End Function

    Shared Function GetFile(ByVal sFilePath As String) As String
        Dim i As Integer

        i = sFilePath.LastIndexOf("\")
        Return sFilePath.Substring(i + 1)

    End Function

    Shared Function Chop(ByVal sInput As String, ByVal sChop As String) As String
        Dim re As System.Text.RegularExpressions.Regex

        Return re.Replace(sInput, String.Format("{0}$", sChop), "")

    End Function

    Shared Sub Chop(ByRef sInput As System.Text.StringBuilder, ByVal iLength As Integer)
        sInput.Remove(sInput.Length - iLength, iLength)

    End Sub

    Public Shared Function ZeroToNull(ByVal value As Object) As String

        If Integer.Parse("0" & value.ToString) = 0 Then
            Return "NULL"

        Else
            Return value.ToString

        End If

    End Function

    Shared Function LookupString(ByVal sLookupValue As String, ByVal sLookupString As String) As String
        Dim arLookup() As String
        Dim i As Integer

        arLookup = Split(sLookupString, ";")

        For i = 0 To arLookup.Length - 1 Step 2
            If sLookupValue.Equals(arLookup(i)) Then
                Return arLookup(i + 1)

            End If
        Next

        Return ""

    End Function

    Public Shared Function CountOfFileLines(ByVal sFilepath As String) As Integer
        Dim f As IO.File
        Dim sr As IO.StreamReader
        Dim sFileContents As String
        Dim tr As IO.TextReader
        Dim i As Integer = 0

        If f.Exists(sFilepath) Then
            tr = f.OpenText(sFilepath)

            While tr.Peek() > -1
                tr.ReadLine()
                i += 1

            End While

        End If

        Return i

    End Function

    Public Shared Sub CleanDir(ByVal sDirectory As String, ByVal iHoursOld As Integer)
        Dim f As IO.File
        Dim d As IO.Directory
        Dim sFiles() As String
        Dim sFile As String
        Dim dtLastWrite As DateTime

        If d.Exists(sDirectory) Then
            sFiles = d.GetFiles(sDirectory)
            For Each sFile In sFiles
                dtLastWrite = f.GetLastWriteTime(sFile)
                If DateDiff(DateInterval.Hour, dtLastWrite, Now()) > iHoursOld Then

                    Try
                        f.Delete(sFile)
                    Catch
                        'do nothing
                    End Try

                End If

            Next

        End If

    End Sub

    Public Shared Function FormatTelephone(ByVal sTelephone As String) As String
        Dim rx As System.Text.RegularExpressions.Regex

        Return rx.Replace(sTelephone, "^(\w{3})(\w{3})(\w{4})(.*)$", "$1-$2-$3 $4").Trim

    End Function

    Public Shared Function RemoveTelephoneFormat(ByVal sTelephone As String) As String
        Dim rx As System.Text.RegularExpressions.Regex

        Return rx.Replace(sTelephone, "[^A-Za-z0-9]", "").Trim

    End Function

    Public Shared Function FormatHTMLAddress(ByVal sAddress1 As Object, ByVal sAddress2 As Object, ByVal sCity As Object, ByVal sState As Object, ByVal sPostalCode As Object, Optional ByVal sPostalCodeExt As Object = "") As String
        Dim sbAddress As New Text.StringBuilder
        Dim sbCityStateZip As New Text.StringBuilder

        If Not IsNothing(sAddress1) AndAlso Not IsDBNull(sAddress1) AndAlso sAddress1.ToString.Length > 0 Then sbAddress.AppendFormat("{0}<br>", sAddress1.ToString)
        If Not IsNothing(sAddress2) AndAlso Not IsDBNull(sAddress2) AndAlso sAddress2.ToString.Length > 0 Then sbAddress.AppendFormat("{0}<br>", sAddress2.ToString)
        If Not IsNothing(sCity) AndAlso Not IsDBNull(sCity) AndAlso sCity.ToString.Length > 0 Then sbCityStateZip.Append(sCity.ToString)
        If Not IsNothing(sState) AndAlso Not IsDBNull(sState) AndAlso sState.ToString.Length > 0 Then
            If sbCityStateZip.Length > 0 Then sbCityStateZip.Append(", ")
            sbCityStateZip.Append(sState.ToString)
        End If
        If Not IsNothing(sPostalCode) AndAlso Not IsDBNull(sPostalCode) AndAlso sPostalCode.ToString.Length > 0 Then
            If sbCityStateZip.Length > 0 Then sbCityStateZip.Append(", ")
            sbCityStateZip.Append(sPostalCode.ToString)
            If Not IsNothing(sPostalCodeExt) AndAlso Not IsDBNull(sPostalCodeExt) AndAlso sPostalCodeExt.ToString.Length > 0 Then
                sbCityStateZip.AppendFormat("-{0}", sPostalCodeExt.ToString)
            End If
        End If
        If sbCityStateZip.Length > 0 Then sbAddress.Append(sbCityStateZip.ToString)
        sbCityStateZip = Nothing
        Return sbAddress.ToString

    End Function

    Public Shared Function FormatFullName(ByVal FirstName As String, ByVal MI As String, ByVal LastName As String) As String
        Dim sb As New Text.StringBuilder

        If FirstName.Length > 0 Then sb.Append(FirstName)
        If MI.Length > 0 Then
            If sb.Length > 0 Then sb.Append(" ")
            sb.Append(MI)

        End If
        If LastName.Length > 0 Then
            If sb.Length > 0 Then sb.Append(" ")
            sb.Append(LastName)

        End If

        Return sb.ToString

    End Function

    Public Shared Function IsBlank(ByVal oValue As Object, Optional ByVal oReturnIfBlank As Object = "") As Object

        'value is not null
        If Not IsDBNull(oValue) Then
            'value is not nothing
            If Not IsNothing(oValue) Then
                'value is not blank
                If oValue.ToString.Length > 0 Then
                    'value passed test
                    Return oValue

                End If
            End If
        End If

        'value failed test, return fail value
        Return oReturnIfBlank

    End Function

    Public Shared Function ChangedDataItem(ByVal dr As DataRow, ByVal ColName As String) As Boolean
        If IsDBNull(dr.Item(ColName, DataRowVersion.Original)) Then
            If Not IsDBNull(dr.Item(ColName, DataRowVersion.Current)) Then Return True

        ElseIf IsDBNull(dr.Item(ColName, DataRowVersion.Current)) Then
            If Not IsDBNull(dr.Item(ColName, DataRowVersion.Original)) Then Return True

        ElseIf dr.Item(ColName, DataRowVersion.Original).ToString <> dr.Item(ColName, DataRowVersion.Current).ToString Then
            Return True

        End If
        Return False

    End Function

    Public Shared Sub SetDropDownSelection(ByRef ddl As System.Web.UI.WebControls.DropDownList, ByVal selectedValue As String)
        ddl.SelectedIndex = ddl.Items.IndexOf(ddl.Items.FindByValue(selectedValue))

    End Sub

    Public Shared Function DBNow(ByVal connection As SqlClient.SqlConnection) As DateTime
        Dim sql As String = "SELECT GETDATE()"
        'TP Ent Lib Update
        Return CDate(SqlHelper.Db(connection.ConnectionString).ExecuteScalar(CommandType.Text, sql))
        'Return CDate(SqlHelper.ExecuteScalar(connection, CommandType.Text, sql))

    End Function

    Public Shared Function FirstOfMonth(ByVal dtDate As DateTime) As DateTime
        Dim iMonth As Integer = dtDate.Month
        Dim iYear As Integer = dtDate.Year
        Return DateSerial(iYear, iMonth, 1)
    End Function

    Public Shared Function LastOfMonth(ByVal dtDate As DateTime) As DateTime
        Dim nextMonth As DateTime = FirstOfMonth(dtDate.AddMonths(1))
        Return nextMonth.AddDays(-1)
    End Function

    Public Shared Function EndOfQuarter(ByVal dtDate As DateTime) As DateTime
        Dim iQuarter As Integer = CInt((dtDate.Month - 1) \ 3) + 1
        Dim iYear As Integer = dtDate.Year
        Dim dtEndQuarter As DateTime = DateSerial(iYear, iQuarter * 3, 1)
        Return LastOfMonth(dtEndQuarter)
    End Function

    'Shared Function DBQueryToListString(ByVal sSQL As String, ByVal sDataValueField As String, ByVal sDataTextField As String, Optional ByVal sListDelimiter As String = ";") As String
    '    Dim sbList As New Text.StringBuilder()
    '    Dim dr As SqlClient.SqlDataReader

    '    dr = SqlHelper.ExecuteReader(DataHandler.sConnection, CommandType.Text, sSQL)

    '    Do While dr.Read()
    '        If sbList.Length > 0 Then sbList.Append(sListDelimiter)
    '        sbList.AppendFormat("{0}{1}{2}", dr.Item(sDataValueField).ToString, dr.Item(sDataTextField).ToString, sListDelimiter)

    '    Loop

    '    dr.Close()
    '    dr = Nothing

    '    Return sbList.ToString

    'End Function

End Class
