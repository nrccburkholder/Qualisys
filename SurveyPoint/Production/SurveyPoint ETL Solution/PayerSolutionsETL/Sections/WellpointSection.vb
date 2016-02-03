Imports System.Xml
Imports System.IO
Imports System.Data
Imports System.Text
Imports System.Configuration
Imports Nrc.SurveyPoint.Library

Public Class WellpointSection

#Region " Private Variables "
    Private mWellpointNavigator As WellpointNavigator
    Private ds As System.Data.DataSet    
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mWellpointNavigator = TryCast(navCtrl, WellpointNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region
    

#Region " Event Handlers "
    Private Sub cmdSplitFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSplitFile.Click
        Dim wellPointClients As String = Config.WellpointClients
        ds = New System.Data.DataSet()
        ds.Tables.Add(New System.Data.DataTable("WellpointSplit"))
        Dim tbl As DataTable = ds.Tables("WellpointSplit")
        Dim cols() As String = Config.WellpointSchema.Split("|"c)
        For i As Integer = 0 To cols.Length - 1
            tbl.Columns.Add(New DataColumn(cols(i)))
        Next
        Dim fs As System.IO.StreamReader = New StreamReader(Me.txtSourceFile.Text, System.Text.Encoding.ASCII)
        Do While fs.Peek >= 0
            Dim str As String = fs.ReadLine
            'Remove the trailer record.
            If Not (str.Contains("*****THIS FILE CONTAINS")) Then
                AddToDataSet(str)
            End If
        Loop
        fs.Close()
        SplitFile()
        MessageBox.Show("Done")
    End Sub
    Private Sub WellpointSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        'Write a description for the user.
        Dim sb As New StringBuilder
        sb.AppendLine("Wellpoint Split File")
        sb.AppendLine("With the 'Split File' button,  you select a Wellpoint file that you wish to separate into multiple files based on company code and state code.")
        sb.AppendLine("You choose the source file you wish to split, and the directory that the split files will go into.")
        sb.AppendLine("With the 'Remove Dups' button, all records from the text file that already exist in the data store will be displayed, but not split into the new file(s).")
        sb.AppendLine("Remove Duplicates logic has been put on hold.  20080819.")
        sb.AppendLine("Current required file schema is:")
        sb.AppendLine("LastName(25)")
        sb.AppendLine("FirstName(20)")
        sb.AppendLine("Address1(100)")
        sb.AppendLine("Address2(50)")
        sb.AppendLine("City(20)")
        sb.AppendLine("State(2)")
        sb.AppendLine("Code(5)")
        sb.AppendLine("Phone(12)")
        sb.AppendLine("Sex(1)")
        sb.AppendLine("DOB(8)")
        sb.AppendLine("SSN(11)")
        sb.AppendLine("EnrollmentDate(7)")
        sb.AppendLine("StateCode(2)")
        sb.AppendLine("ProductFamily(4)")
        sb.AppendLine("ProductCode(4)")
        sb.AppendLine("ProductLongDesc(50)")
        sb.AppendLine("CompanyCode(4)")
        sb.AppendLine("CountyName(11)")
        Me.txtDescription.Text = sb.ToString
    End Sub
    Private Sub cmdSourceFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSourceFile.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = Windows.Forms.DialogResult.OK Then
            Me.txtSourceFile.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub
    Private Sub cmdDestinationFolder_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDestinationFolder.Click
        Dim result As DialogResult = Me.FolderBrowserDialog1.ShowDialog()
        If result = Windows.Forms.DialogResult.OK Then
            Me.txtDestinationFolder.Text = Me.FolderBrowserDialog1.SelectedPath
        End If
    End Sub
    Private Sub cmdRemoveDups_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdRemoveDups.Click
        If ValidateDupInput() Then
            DeDupFile()
        End If
    End Sub
#End Region
#Region " Private Methods "
    Private Sub SplitFile()
        Dim strFiles As String = Config.WellpointClients
        Dim files() As String = strFiles.Split("|"c)
        Dim reverseWhereClause As New List(Of String)
        For Each file As String In files
            Dim strFilterValues As String = Config.GetConfigValue(file)
            Dim filterValues() As String = strFilterValues.Split("|"c)
            Dim whereClause As New List(Of String)
            For Each filters As String In filterValues
                Dim filter() As String = filters.Split("*"c)
                'Dim sWhere As String = "(CompanyCode='" & PadString(filter(0), 4) & "' and StateCode='" & PadString(filter(1), 2) & "' and ProductCode='" & PadString(filter(2), 4) & "')"
                'Dim sreverseWhere As String = "(CompanyCode<>'" & PadString(filter(0), 4) & "' and StateCode<>'" & PadString(filter(1), 2) & "' and ProductCode<>'" & PadString(filter(2), 4) & "')"
                Dim sWhere As String = "(CompanyCode='" & PadString(filter(0), 4) & "' and StateCode='" & PadString(filter(1), 2) & "')"
                Dim sreverseWhere As String = "(CompanyCode='" & PadString(filter(0), 4) & "' and StateCode='" & PadString(filter(1), 2) & "')"
                whereClause.Add(sWhere)
                reverseWhereClause.Add(sreverseWhere)
            Next
            Dim whereString As String = ""
            For Each condition As String In whereClause
                whereString += condition & " or "
            Next
            System.Diagnostics.Debug.Print(whereString)
            whereString = whereString.Substring(0, whereString.Length - 4)
            System.Diagnostics.Debug.Print(whereString)
            Dim dv1 As DataView = New DataView(ds.Tables(0), whereString, "", DataViewRowState.CurrentRows)
            Dim fileName As String = Replace(file, " ", "_") & ".txt"
            WriteFile(dv1, fileName)
        Next
        'Now write the file for any that did not meed the crtieria
        Dim reverseWhereString As String = ""
        For Each condition As String In reverseWhereClause
            reverseWhereString += condition & " OR "
        Next
        System.Diagnostics.Debug.Print(reverseWhereString)
        reverseWhereString = "NOT (" & reverseWhereString.Substring(0, reverseWhereString.Length - 4) & ")"
        System.Diagnostics.Debug.Print(reverseWhereString)
        Dim dv2 As DataView = New DataView(ds.Tables(0), reverseWhereString, "", DataViewRowState.CurrentRows)
        Dim fn As String = "LeftOvers.txt"
        WriteFile(dv2, fn)
    End Sub
    Private Sub WriteFile(ByVal dv As DataView, ByVal fileName As String)
        Dim sb As New StringBuilder()
        Dim sw As New StreamWriter(Me.txtDestinationFolder.Text & "/" & fileName)

        For Each row As DataRowView In dv
            sb.Append(CharString(CStr(row(0)), 25))
            sb.Append(CharString(CStr(row(1)), 20))
            sb.Append(CharString(CStr(row(2)), 100))
            sb.Append(CharString(CStr(row(3)), 50))
            sb.Append(CharString(CStr(row(4)), 20))
            sb.Append(CharString(CStr(row(5)), 2))
            sb.Append(CharString(CStr(row(6)), 5))
            sb.Append(CharString(CStr(row(7)), 12))
            sb.Append(CharString(CStr(row(8)), 1))
            Dim value As String = CStr(row(9))
            If IsDate(value) Then
                value = CDate(value).ToString("MM/dd/yyyy")
            ElseIf IsNumeric(value) Then
                value = value.Substring(0, 2) & "/" & value.Substring(2, 2) & "/" & value.Substring(4, 4)
            End If
            sb.Append(CharString(value, 10))
            sb.Append(CharString(CStr(row(10)), 11))
            sb.Append(CharString(CStr(row(11)), 7))
            sb.Append(CharString(CStr(row(12)), 2))
            sb.Append(CharString(CStr(row(13)), 4))
            sb.Append(CharString(CStr(row(14)), 4))
            sb.Append(CharString(CStr(row(15)), 50))
            sb.Append(CharString(CStr(row(16)), 4))
            sb.Append(CharString(CStr(row(17)), 11))
            sw.WriteLine(sb.ToString)
            sb = New StringBuilder()
        Next
        sw.Close()
    End Sub
    Private Function CharString(ByVal str As String, ByVal padLength As Integer) As String
        Dim retVal As String = str
        If str.Length > padLength Then
            retVal = retVal.Substring(0, padLength)
        ElseIf str.Length < padLength Then
            retVal.PadRight(padLength - str.Length)
        End If
        Return retVal
    End Function
    Private Sub AddToDataSet(ByVal str As String)
        Dim tbl As DataTable = ds.Tables("WellpointSplit")
        tbl.Rows.Add( _
        str.Substring(0, 25), _
        str.Substring(25, 20), _
        str.Substring(45, 100), _
        str.Substring(145, 50), _
        str.Substring(195, 20), _
        str.Substring(215, 2), _
        str.Substring(217, 5), _
        str.Substring(222, 12), _
        str.Substring(234, 1), _
        str.Substring(235, 8), _
        str.Substring(243, 11), _
        str.Substring(254, 7), _
        str.Substring(261, 2), _
        str.Substring(263, 4), _
        str.Substring(267, 4), _
        str.Substring(271, 50), _
        str.Substring(321, 4), _
        PadString(str.Substring(325), 11))

        'System.Diagnostics.Debug.Print(str.Substring(524, 2))
    End Sub
    Private Function PadString(ByVal str As String, ByVal padLength As Integer) As String
        Dim retVal As String = str
        If str.Length < padLength Then
            Dim pad As String = ""
            For i As Integer = 1 To padLength - str.Length
                pad += " "
            Next
            retVal = retVal & pad
        End If
        System.Diagnostics.Debug.Print(retVal.Length.ToString)
        Return retVal
    End Function
#Region " DeDup Methods "
    Private Function ValidateDupInput() As Boolean
        Dim retVal As Boolean = False
        If Not System.IO.File.Exists(Me.txtSourceFile.Text) Then
            MessageBox.Show("Source file is invalid.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf Not System.IO.Directory.Exists(Me.txtDestinationFolder.Text) Then
            MessageBox.Show("Destination folder is invalid.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf Not IsNumeric(Me.txtClientID.Text) Then
            MessageBox.Show("Client ID is invalid.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf Not IsDate(Me.dteSurveyInstanceStartDate.Value) Then
            MessageBox.Show("Survey Instance Start date is invalid.", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            Return True
        End If
        Return retVal
    End Function
    Private Sub DeDupFile()
        Dim fs As System.IO.StreamReader = Nothing
        Dim clientID As Integer = CInt(txtClientID.Text)
        Dim surveyInstanceStartDate As Nullable(Of Date) = CDate(Me.dteSurveyInstanceStartDate.Value)
        Try
            LoadDeDupOriginalFile()
            fs = New StreamReader(Me.txtSourceFile.Text, System.Text.Encoding.ASCII)
            Dim recordsID As String = Guid.NewGuid.ToString
            Dim fName As String = ""
            Dim lName As String = ""
            Dim dob As Nullable(Of Date) = Nothing
            Do While fs.Peek >= 0
                Dim str As String = fs.ReadLine
                'Remove the trailer record.
                If Not (str.Contains("*****THIS FILE CONTAINS")) Then
                    lName = Trim(str.Substring(0, 25))
                    fName = Trim(str.Substring(25, 20))
                    Dim value As String = str.Substring(235, 8)
                    If IsDate(value) Then
                        dob = CDate(value).ToString("MM/dd/yyyy")
                    ElseIf IsNumeric(value) Then
                        dob = value.Substring(0, 2) & "/" & value.Substring(2, 2) & "/" & value.Substring(4, 4)
                    Else
                        dob = Nothing
                    End If
                    InsertDeDup(recordsID, lName, fName, dob)
                End If
            Loop
            fs.Close()
            fs = Nothing
            'Get any duplicates
            Dim dupRespondents As WPSplitRespondentCollection = Nrc.SurveyPoint.Library.WPSplitRespondent.GetDuplicateWPRespondents(recordsID, clientID, surveyInstanceStartDate)
            'Create filter
            Dim criteria As String = ""
            For Each resp As WPSplitRespondent In dupRespondents
                criteria += "(LastName= '" & ReplaceTicks(resp.LastName) & "' and FirstName = '" & ReplaceTicks(resp.FirstName) & "' and DOB = '" & resp.DOB.Value & "') OR "
            Next
            If criteria.Length <> 0 Then
                criteria = criteria.Substring(0, criteria.Length - 4)
            End If
            WriteDeDupFile(criteria)
        Catch ex As Exception
            Globals.ReportException(ex)
        Finally
            If Not fs Is Nothing Then
                fs.Close()
            End If
        End Try
    End Sub
    Private Sub WriteDeDupFile(ByVal criteriaString As String)
        If criteriaString.Length > 0 Then
            criteriaString = "NOT (" & criteriaString & ")"
        End If
        Dim dv As DataView = New DataView(ds.Tables(0), criteriaString, "", DataViewRowState.CurrentRows)
        Dim filePath As String = Me.txtSourceFile.Text.Substring(0, Me.txtSourceFile.Text.LastIndexOf("\"c))
        Dim fileName As String = Me.txtSourceFile.Text.Substring(Me.txtSourceFile.Text.LastIndexOf("\"c) + 1)
        fileName = fileName.Substring(0, fileName.LastIndexOf("."c)) & "DeDupFile" & fileName.Substring(fileName.LastIndexOf("."c))
        WriteFile(dv, filePath & fileName)
    End Sub
    Private Sub LoadDeDupOriginalFile()
        Dim wellPointClients As String = Config.WellpointClients
        ds = New System.Data.DataSet()
        ds.Tables.Add(New System.Data.DataTable("WellpointSplit"))
        Dim tbl As DataTable = ds.Tables("WellpointSplit")
        Dim cols() As String = Config.WellpointSchema.Split("|"c)
        For i As Integer = 0 To cols.Length - 1
            tbl.Columns.Add(New DataColumn(cols(i)))
        Next
        Dim fs As System.IO.StreamReader = New StreamReader(Me.txtSourceFile.Text, System.Text.Encoding.ASCII)
        Do While fs.Peek >= 0
            Dim str As String = fs.ReadLine
            'Remove the trailer record.
            If Not (str.Contains("*****THIS FILE CONTAINS")) Then
                AddToDataSet(str)
            End If
        Loop
        fs.Close()
    End Sub
    Private Sub InsertDeDup(ByVal recordsID As String, ByVal lName As String, ByVal fName As String, ByVal dob As Nullable(Of Date))
        Nrc.SurveyPoint.Library.WPSplitRespondent.InsertDeDupRespondent(recordsID, lName, fName, dob)
    End Sub
#End Region
    Private Function ReplaceTicks(ByVal str As String) As String
        Return Replace(str, "'", "''")
    End Function
#End Region
End Class
