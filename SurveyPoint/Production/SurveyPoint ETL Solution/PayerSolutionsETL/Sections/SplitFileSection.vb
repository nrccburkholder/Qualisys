Imports System.Xml
Imports System.IO
Imports System.Data
Imports System.Text
Imports System.Configuration

Public Class SplitFileSection
    Private mSplitFileNavigator As SplitFileNavigator
    Private ds As System.Data.DataSet

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)
        MyBase.RegisterNavControl(navCtrl)

        mSplitFileNavigator = TryCast(navCtrl, SplitFileNavigator)

    End Sub

    Public Overrides Sub ActivateSection()
        'AddHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    Public Overrides Sub InactivateSection()
        'RemoveHandler mFolderNavigator.FolderChanged, AddressOf mFolderNavigator_FolderChanged
    End Sub

    'Private Sub mFolderNavigator_FolderChanged(ByVal sender As Object, ByVal e As FolderChangedEventArgs)
    '    UpdateFolderContents(e.FolderPath)
    'End Sub


    Private Sub SplitFileSection_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        Dim covFiles As String = Config.CoventryFiles
        Dim files() As String = covFiles.Split("|"c)
        For Each file As String In files
            Me.cboCoventryFile.Items.Add(file)
        Next
        'Write a description for the user.
        Dim sb As New StringBuilder
        sb.AppendLine("Coventry Split File")
        sb.AppendLine("In this section you select from a list of possible coventry files that you wish to separate into multiple files based on group ID.")
        sb.AppendLine("Once the file 'Type' is select you choose the source file you wish to split, and the directory that the split files will go into.")
        sb.AppendLine("Current required file schema is:")
        sb.AppendLine("RecordID(1)")
        sb.AppendLine("Flag01(1)")
        sb.AppendLine("User1(2)")
        sb.AppendLine("LastName(18)")
        sb.AppendLine("FirstName(12)")
        sb.AppendLine("Middle(1)")
        sb.AppendLine("Address1(49)")
        sb.AppendLine("Address2(11)")
        sb.AppendLine("City(28)")
        sb.AppendLine("State(2)")
        sb.AppendLine("PostalCode(5)")
        sb.AppendLine("PostalCodeExt(4)")
        sb.AppendLine("TelephoneDay(10)")
        sb.AppendLine("TelephoneEvening(10)")
        sb.AppendLine("DOB(8)")
        sb.AppendLine("Gender(1)")
        sb.AppendLine("ClientRespondentID(9)")
        sb.AppendLine("MemberID(11)")
        sb.AppendLine("Relationship(3)")
        sb.AppendLine("Property_User1(11)")
        sb.AppendLine("MemberEffectiveDate(8)")
        sb.AppendLine("MemberTerminationDate(8)")
        sb.AppendLine("Member_Type(4)")
        sb.AppendLine("Contract_Desc(3)")
        sb.AppendLine("Contract(10)")
        sb.AppendLine("ContractEffectiveDate(8)")
        sb.AppendLine("ContractTerminationDate(8)")
        sb.AppendLine("MemberDependent(1)")
        sb.AppendLine("FSC(7)")
        sb.AppendLine("FSCEffectiveDate(8)")
        sb.AppendLine("FSCTerminationDate(8)")
        sb.AppendLine("MedConverageIndicator(1)")
        sb.AppendLine("EffectiveDate(8)")
        sb.AppendLine("Region(4)")
        sb.AppendLine("GroupID(10)")
        sb.AppendLine("SubgroupID(10)")
        sb.AppendLine("Department(30)")
        sb.AppendLine("RXCoverageIndicator(4)")
        sb.AppendLine("PlanType(5)")
        sb.AppendLine("Product(5)")
        sb.AppendLine("Product2(5)")
        sb.AppendLine("PlanID(5)")
        sb.AppendLine("PlanEffectiveDate(8)")
        sb.AppendLine("Copay(8)")
        sb.AppendLine("Rider01(7)")
        sb.AppendLine("Rider02(5)")
        sb.AppendLine("Rider03(8)")
        sb.AppendLine("PCPCode(8)")
        sb.AppendLine("PhysicianLastName(25)")
        sb.AppendLine("PhysicianID(7)")
        sb.AppendLine("PhysicianAddr1(7)")
        sb.AppendLine("PhysicianCity(8)")
        sb.AppendLine("PhysicianEffectiveDate(8)")
        sb.AppendLine("PhysicianTerminationDate(8)")
        sb.AppendLine("ProviderID(8)")
        sb.AppendLine("PhysicianFirstname(15)")
        sb.AppendLine("TerminationDesc(15)")
        sb.AppendLine("SkipField(1)")
        sb.AppendLine("HICN(15)")
        sb.AppendLine("SubscriberSSN(9)")
        sb.AppendLine("RelationshipCode(2)")
        Me.txtDescription.Text = sb.ToString
    End Sub

    Private Sub cmdOpen_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdOpen.Click

        Dim result As DialogResult = Me.OpenFileDialog1.ShowDialog()
        If result = Windows.Forms.DialogResult.OK Then
            txtFile.Text = Me.OpenFileDialog1.FileName
        End If
    End Sub

    Private Sub cmdDestination_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdDestination.Click
        Dim result As DialogResult = Me.FolderBrowserDialog1.ShowDialog()
        If result = Windows.Forms.DialogResult.OK Then
            txtDestination.Text = Me.FolderBrowserDialog1.SelectedPath
        End If
    End Sub
    Private Function ValidateUserInput() As Boolean
        Dim retVal As Boolean = False
        Dim sourceFile As String = Me.txtFile.Text        
        If Me.txtDestination.Text = "" OrElse System.IO.Directory.Exists(Me.txtDestination.Text) = False Then
            MessageBox.Show("Invalid Destination Directory", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf CStr(Me.cboCoventryFile.SelectedItem) = "" Then
            MessageBox.Show("No Coventry File Has been Selected", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        ElseIf sourceFile = "" Then
            MessageBox.Show("No Source File Has been Selected", "Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            retVal = True
        End If
        Return retVal
    End Function
    Private Sub cmdSplit_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSplit.Click
        Try
            If ValidateUserInput() Then
                ds = New System.Data.DataSet()
                ds.Tables.Add(New System.Data.DataTable("CoventrySplit"))
                Dim tbl As DataTable = ds.Tables("CoventrySplit")
                Dim cols() As String = Config.CoventryColumnNames.Split("|"c)
                For i As Integer = 0 To cols.Length - 1
                    tbl.Columns.Add(New DataColumn(cols(i)))
                Next
                Dim fs As System.IO.StreamReader = New StreamReader(Me.txtFile.Text, System.Text.Encoding.ASCII)
                Do While fs.Peek >= 0
                    Dim str As String = fs.ReadLine
                    AddToDataSet(str)
                Loop
                fs.Close()
                SplitFile()
                ds = Nothing
                MessageBox.Show("Files have been separated.")
            End If
        Catch ex As System.Exception
            Globals.ReportException(ex)
        End Try
    End Sub
    Private Sub SplitFile()

        Dim configVal As String = Replace(Replace(Replace(Me.cboCoventryFile.SelectedItem, " ", ""), ")", ""), "(", "")
        Dim GroupIDs As String = Config.GetConfigValue(configVal)
        If GroupIDs.Length = 0 Then
            writeFile()
        Else
            Dim groups() As String = GroupIDs.Split("|"c)
            Dim sqlGroupIDs As String = ""
            For i As Integer = 0 To groups.Length - 1
                Dim group() As String = groups(i).Split("*"c)
                sqlGroupIDs += group(0) & ","
                Dim dv1 As DataView = New DataView(ds.Tables(0), "GroupID=" & group(0), "", DataViewRowState.CurrentRows)
                System.Diagnostics.Debug.Print(ds.Tables(0).Rows.Count)
                System.Diagnostics.Debug.Print(dv1.Count)
                WriteFile(dv1, group(0), group(1) & ".txt")
            Next
            sqlGroupIDs = sqlGroupIDs.Substring(0, sqlGroupIDs.Length - 1)
            Dim dv As DataView = New DataView(ds.Tables(0), "GroupID not in (" & sqlGroupIDs & ")", "", DataViewRowState.CurrentRows)
            System.Diagnostics.Debug.Print(ds.Tables(0).Rows.Count)
            System.Diagnostics.Debug.Print(dv.Count)
            WriteFile(dv, "0", Me.cboCoventryFile.SelectedItem & "_0" & ".txt")
        End If
    End Sub
    Private Sub WriteFile(ByVal dv As DataView, ByVal groupID As String, ByVal fileName As String)
        Dim sb As New StringBuilder()        
        Dim sw As New StreamWriter(txtDestination.Text & "/" & fileName, False)

        For Each row As DataRowView In dv
            For i As Integer = 0 To 60
                Dim value As String = CStr(row(i))
                Select Case i
                    Case 14, 20, 25, 29, 42, 52
                        If IsDate(value) Then
                            value = CDate(value).ToString("MM/dd/yyyy")
                        ElseIf IsNumeric(value) Then
                            value = value.Substring(4, 2) & "/" & value.Substring(6, 2) & "/" & value.Substring(0, 4)
                        End If
                    Case 21, 26, 30, 32, 53
                        value = ""
                End Select
                If i = 60 Then
                    sb.Append(value)
                Else
                    sb.Append(value & vbTab)
                End If
            Next
            sw.WriteLine(sb.ToString)
            sb = New StringBuilder()
        Next
        sw.Close()
    End Sub
    Private Sub writeFile()
        Dim sb As New StringBuilder()
        Dim tbl As DataTable = ds.Tables("CoventrySplit")
        Dim fileName As String = Me.cboCoventryFile.SelectedItem & ".txt"
        Dim sw As New StreamWriter(txtDestination.Text & "/" & fileName, False)
        For Each row As DataRow In tbl.Rows
            For i As Integer = 0 To tbl.Columns.Count - 1
                Dim value As String = CStr(row(i))
                Select Case i
                    Case 14, 20, 25, 29, 42, 52
                        If IsDate(value) Then
                            value = CDate(value).ToString("MM/dd/yyyy")
                        ElseIf IsNumeric(value) Then
                            value = value.Substring(4, 2) & "/" & value.Substring(6, 2) & "/" & value.Substring(0, 4)
                        End If
                    Case 21, 26, 30, 32, 53
                        value = ""
                End Select
                If i = tbl.Columns.Count - 1 Then
                    sb.Append(value)
                Else
                    sb.Append(value & vbTab)
                End If
            Next
            sw.WriteLine(sb.ToString)
            sb = New StringBuilder()
        Next
        sw.Close()
    End Sub

    Private Sub AddToDataSet(ByVal str As String)
        Dim tbl As DataTable = ds.Tables("CoventrySplit")
        tbl.Rows.Add( _
        Trim(str.Substring(0, 1)), _
        Trim(str.Substring(1, 1)), _
        Trim(str.Substring(2, 2)), _
        Trim(str.Substring(4, 18)), _
        Trim(str.Substring(22, 12)), _
        Trim(str.Substring(34, 1)), _
        Trim(str.Substring(35, 49)), _
        Trim(str.Substring(84, 11)), _
        Trim(str.Substring(95, 28)), _
        Trim(str.Substring(123, 2)), _
        Trim(str.Substring(125, 5)), _
        Trim(str.Substring(130, 4)), _
        Trim(str.Substring(134, 10)), _
        Trim(str.Substring(144, 10)), _
        Trim(str.Substring(154, 8)), _
        Trim(str.Substring(162, 1)), _
        Trim(str.Substring(163, 9)), _
        Trim(str.Substring(172, 11)), _
        Trim(str.Substring(183, 3)), _
        Trim(str.Substring(186, 11)), _
        Trim(str.Substring(197, 8)), _
        Trim(str.Substring(205, 8)), _
        Trim(str.Substring(213, 4)), _
        Trim(str.Substring(217, 3)), _
        Trim(str.Substring(220, 10)), _
        Trim(str.Substring(230, 8)), _
        Trim(str.Substring(238, 8)), _
        Trim(str.Substring(246, 1)), _
        Trim(str.Substring(247, 7)), _
        Trim(str.Substring(254, 8)), _
        Trim(str.Substring(262, 8)), _
        Trim(str.Substring(270, 1)), _
        Trim(str.Substring(271, 8)), _
        Trim(str.Substring(279, 4)), _
        Trim(str.Substring(283, 10)), _
        Trim(str.Substring(293, 10)), _
        Trim(str.Substring(303, 30)), _
        Trim(str.Substring(333, 4)), _
        Trim(str.Substring(337, 5)), _
        Trim(str.Substring(342, 5)), _
        Trim(str.Substring(347, 5)), _
        Trim(str.Substring(352, 5)), _
        Trim(str.Substring(357, 8)), _
        Trim(str.Substring(365, 7)), _
        Trim(str.Substring(372, 5)), _
        Trim(str.Substring(377, 5)), _
        Trim(str.Substring(382, 8)), _
        Trim(str.Substring(390, 8)), _
        Trim(str.Substring(398, 25)), _
        Trim(str.Substring(423, 7)), _
        Trim(str.Substring(430, 7)), _
        Trim(str.Substring(437, 8)), _
        Trim(str.Substring(445, 8)), _
        Trim(str.Substring(453, 8)), _
        Trim(str.Substring(461, 8)), _
        Trim(str.Substring(469, 15)), _
        Trim(str.Substring(484, 15)), _
        Trim(str.Substring(499, 1)), _
        Trim(str.Substring(500, 15)), _
        Trim(str.Substring(515, 9)), _
        Trim(str.Substring(524, 2)))
        System.Diagnostics.Debug.Print(str.Substring(524, 2))
    End Sub
End Class
