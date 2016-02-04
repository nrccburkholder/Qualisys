Imports System.Text
Imports System.IO
Imports System.Data
Public Class VoviciUnpivotSection
#Region " Private Fields "
    Private mVoviciUnPivotNavigator As VoviciUnpivotNavigator
    Private sbIntroText As New StringBuilder()
    Private questionList As New List(Of String)
#End Region
#Region " Overrides "
    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mVoviciUnPivotNavigator = TryCast(navCtrl, VoviciUnpivotNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub
#End Region
#Region " Event Handlers "
    Private Sub cmdUnPivot_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdUnPivot.Click
        If FileValidate() Then
            UnPivotFile()
        End If
    End Sub
    Private Sub VoviciUnpivotSection_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        sbIntroText.AppendLine("Welcome to the Vovici Unpivot tab")
        sbIntroText.AppendLine("This tab takes a specific Vovici CSV file (See format below)")
        sbIntroText.AppendLine("and Unpivots the Questions from the Respondent information.")
        sbIntroText.AppendLine("Source Fields: " & "recordid	Medicaid ID (Q1_1)	Date of Birth (Q2_1)	Date of Birth (Q2_2)	Date of Birth (Q2_3)	Last Name (Q3_1)	First Name (Q4_1)	Phone number (Q5_1)	Email (Q6_1)	Who Completing Survey for (Q7)	Member's age you are answering for (Q8)	Q1 (Q9)	Q2 (Q10)	Q3 (Q11)	Q4 (Q12)	Q5 (Q13)	Q6 (Q14)	Q7 (Q15)	Q8 (Q16)	Q9 (Q17)	Q10 (Q18)	Q11 (Q19)	Q12 (Q20)	Q13 (Q21)	Q14 (Q22)	Q14a (Q23_1)	Q14a (Q23_2)	Q14a (Q23_3)	Q15 (Q24)	Contact from Medical Mgmnt (Q26)	Mailing address - Name (Q27_1)	Mailing address - Name (Q27_2)	Mailing address - Name (Q27_3)	Mailing address - Name (Q27_4)	Mailing address - Name (Q27_5)	Begin new survey (Q25)	started	completed	modified")
        sbIntroText.AppendLine("Result Fields:  " & "SURVEY_NAME	SURVEY_DATE	MEM_ID	MEM_LAST_NAME	MEM_FIRST_NAME	MEM_DOB	MEM_HOME_PHONE	MEM_E_MAIL 	SURVEY_FOR	MEMBER_AGE	QUESTION_NAME	ANSWER	MEM_ADDRESS_LINE_1	MEM_ADDRESS_LINE_2	MEM_CITY	MEM_STA_CODE	MEM_POC_CODE")
        Me.txtResults.Text = sbIntroText.ToString()
        questionList.Add("Q1")
        questionList.Add("Q2")
        questionList.Add("Q3")
        questionList.Add("Q4")
        questionList.Add("Q5")
        questionList.Add("Q6")
        questionList.Add("Q7")
        questionList.Add("Q8")
        questionList.Add("Q9")
        questionList.Add("Q10")
        questionList.Add("Q11")
        questionList.Add("Q12")
        questionList.Add("Q13")
        questionList.Add("Q14")
        questionList.Add("Q14a")
        questionList.Add("Q15")
        questionList.Add("Q16")
    End Sub
    Private Sub cmdGetFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdGetFile.Click
        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtFileName.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub
    Private Sub cmdResultFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdResultFile.Click
        Dim result As DialogResult = Me.SaveFileDialog1.ShowDialog()
        If result = DialogResult.OK Then
            Me.txtResultsFile.Text = Me.SaveFileDialog1.FileName
        End If
    End Sub
#End Region
#Region " Private Methods "
    Private Function FileValidate() As Boolean
        Dim sb As New StringBuilder()
        If Me.txtFileName.Text.Length = 0 Then
            sb.AppendLine("No File has been selected.")
            Me.txtResults.Text = Me.txtResults.Text & sb.ToString
            Return False
        End If
        If Not System.IO.File.Exists(Me.txtFileName.Text) Then
            sb.AppendLine("The selected file does not exist.")
            Me.txtResults.Text = Me.txtResults.Text & sb.ToString
            Return False
        End If
        If Me.txtResultsFile.Text.Length = 0 Then
            sb.AppendLine("No Result File has been selected.")
            Me.txtResults.Text = Me.txtResults.Text & sb.ToString
            Return False
        End If
        If Not System.IO.Directory.Exists(Me.txtResultsFile.Text.Substring(0, Me.txtResultsFile.Text.LastIndexOf("\"c))) Then
            sb.AppendLine("The Directory for the result file is invalid.")
            Me.txtResults.Text = Me.txtResults.Text & sb.ToString
            Return False
        End If
        Return True
    End Function
    Private Sub UnPivotFile()
        Try
            Dim tempString As String = Me.txtFileName.Text
            Dim fileName As String = tempString.Substring(tempString.LastIndexOf("\"c) + 1)
            Dim path As String = tempString.Substring(0, tempString.LastIndexOf("\"c))
            Dim connStr As String = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & _
            path & ";Extended Properties=""Text;HDR=1;FMT=Delimited\"""
            Dim sbOutput As New StringBuilder()
            BuildHeader(sbOutput)
            Dim conn As New OleDb.OleDbConnection(connStr)
            Dim ds As New DataSet
            Dim da As New OleDb.OleDbDataAdapter("Select * from " & fileName, conn)
            da.Fill(ds, "TextFile")            
            For icnt As Integer = 0 To ds.Tables(0).Rows.Count - 1
                Dim row As DataRow = ds.Tables(0).Rows(icnt)
                For i As Integer = 0 To questionList.Count - 1
                    sbOutput.Append("IN_ONLINE_SURVEY" & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(38))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(1))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(5))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(6))) & ",")
                    If IsDBNull(row(2)) OrElse IsDBNull(row(2)) OrElse IsDBNull(row(2)) Then
                        sbOutput.Append("" & ",")
                    Else
                        sbOutput.Append(ScrubStringForCSV(CastString(row(2))) & "/" & ScrubStringForCSV(CastString(row(3))) & "/" & ScrubStringForCSV(CastString(row(4))) & ",")
                    End If
                    sbOutput.Append(ScrubStringForCSV(CastString(row(7))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(8))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(9))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(10))) & ",")
                    sbOutput.Append(questionList(i) & ",")
                    sbOutput.Append(GetAnswers(questionList(i), row) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(30))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(31))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(32))) & ",")
                    sbOutput.Append(ScrubStringForCSV(CastString(row(33))) & ",")
                    sbOutput.AppendLine(ScrubStringForCSV(CastString(row(34))))
                Next
            Next
            Dim myWriter As New StreamWriter(Me.txtResultsFile.Text, False)
            myWriter.Write(sbOutput.ToString())
            myWriter.Close()
            myWriter = Nothing
            Me.txtResults.Text = Me.txtResults.Text & "File has been exported to new format." & vbCrLf
        Catch ex As System.Exception
            Me.txtResults.Text = Me.txtResults.Text & ex.Message & vbCrLf
            Globals.ReportException(ex)        
        End Try
    End Sub
    Private Function ScrubStringForCSV(ByVal str As String) As String
        Dim retVal As String = str
        If InStr(str, ",") > 0 Then            
            retVal = Replace(retVal, Chr(34), Chr(34) & Chr(34))
            retVal = Chr(34) & retVal & Chr(34)        
        End If
        Return retVal
    End Function
    Private Function GetAnswers(ByVal qColName As String, ByRef row As DataRow) As String        
        Select Case qColName
            Case "Q1"
                Return ScrubStringForCSV(CastString(row(11), True))
            Case "Q2"
                Return ScrubStringForCSV(CastString(row(12), True))
            Case "Q3"
                Return ScrubStringForCSV(CastString(row(13), True))
            Case "Q4"
                Return ScrubStringForCSV(CastString(row(14), True))
            Case "Q5"
                Return ScrubStringForCSV(CastString(row(15), True))
            Case "Q6"
                Return ScrubStringForCSV(CastString(row(16), True))
            Case "Q7"
                Return ScrubStringForCSV(CastString(row(17), True))
            Case "Q8"
                Return ScrubStringForCSV(CastString(row(18), True))
            Case "Q9"
                Return ScrubStringForCSV(CastString(row(19), True))
            Case "Q10"
                Return ScrubStringForCSV(CastString(row(20), True))
            Case "Q11"
                Return ScrubStringForCSV(CastString(row(21), True))
            Case "Q12"
                Return ScrubStringForCSV(CastString(row(22), True))
            Case "Q13"
                Return ScrubStringForCSV(CastString(row(23), True))
            Case "Q14"
                Return ScrubStringForCSV(CastString(row(24), True))
            Case "Q14a"
                If IsDBNull(row(25)) OrElse IsDBNull(row(26)) OrElse IsDBNull(row(27)) OrElse CStr(row(25)) = "" OrElse CStr(row(26)) = "" OrElse CStr(row(27)) = "" Then
                    Return "N/A"
                Else
                    Return ScrubStringForCSV(CastString(row(25))) & "/" & ScrubStringForCSV(CastString(row(26))) & "/" & ScrubStringForCSV(CastString(row(27)))
                End If
            Case "Q15"
                Return ScrubStringForCSV(CastString(row(28), True))
            Case "Q16"
                Return ScrubStringForCSV(IIf(CastString(row(29), False) = "", "2", CastString(row(29))))
            Case Else
                Throw New System.Exception("An invalid question was given.")
        End Select
    End Function
    Private Function CastString(ByVal obj As Object, Optional ByVal addNA As Boolean = False) As String
        If addNA Then
            If IsDBNull(obj) Then
                Return "N/A"
            Else
                If CStr(obj) = "" Then
                    Return "N/A"
                Else
                    Return CStr(obj)
                End If
            End If
        ElseIf IsDBNull(obj) Then
            Return ""
        Else
            Return CStr(obj)
        End If
    End Function
    Private Sub BuildHeader(ByRef sb As StringBuilder)        
        sb.Append("SURVEY_NAME" & ",")
        sb.Append("SURVEY_DATE" & ",")
        sb.Append("MEM_ID" & ",")
        sb.Append("MEM_LAST_NAME" & ",")
        sb.Append("MEM_FIRST_NAME" & ",")
        sb.Append("MEM_DOB" & ",")
        sb.Append("MEM_HOME_PHONE" & ",")
        sb.Append("MEM_E_MAIL" & ",")
        sb.Append("SURVEY_FOR" & ",")
        sb.Append("MEMBER_AGE" & ",")
        sb.Append("QUESTION_NAME" & ",")
        sb.Append("ANSWER" & ",")
        sb.Append("MEM_ADDRESS_LINE_1" & ",")
        sb.Append("MEM_ADDRESS_LINE_2" & ",")
        sb.Append("MEM_CITY" & ",")
        sb.Append("MEM_STA_CODE" & ",")
        sb.AppendLine("MEM_POC_CODE")        
    End Sub
#End Region
End Class
