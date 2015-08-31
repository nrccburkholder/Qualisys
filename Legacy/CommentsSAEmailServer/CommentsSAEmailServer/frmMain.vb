Imports Microsoft.VisualBasic
Imports Microsoft.VisualBasic.CompilerServices
Imports System
Imports System.Collections
Imports System.ComponentModel
Imports System.Data
Imports System.Data.SqlClient
Imports System.Diagnostics
Imports System.Drawing
Imports System.Resources
Imports System.Runtime.CompilerServices
Imports System.Runtime.InteropServices
Imports System.Windows.Forms

Namespace CommentsSAEmailServer
    Public Class frmMain
        Inherits Form
        ' Methods
        Public Sub New()
            AddHandler MyBase.Load, New EventHandler(AddressOf Me.frmMain_Load)
            Me.InitializeComponent
        End Sub

        Private Sub btnGoDate_Click(ByVal sender As Object, ByVal e As EventArgs)
            If (DateTime.Compare(Me.dtpTo.Value, Me.dtpFrom.Value) < 0) Then
                Interaction.MsgBox("The 'To' date must be greater than the 'From' date!", MsgBoxStyle.Exclamation, Nothing)
            Else
                Me.Cursor = Cursors.WaitCursor
                Me.PopLogEntries(Me.dtpFrom.Value, Me.dtpTo.Value, "")
                Me.PopLogView
                Me.Cursor = Cursors.Default
            End If
        End Sub

        Private Sub btnGoLitho_Click(ByVal sender As Object, ByVal e As EventArgs)
            If (Me.txtLithoCode.Text.Trim.Length = 0) Then
                Interaction.MsgBox("You must enter a LithoCode!", MsgBoxStyle.Exclamation, Nothing)
            ElseIf Not Information.IsNumeric(Me.txtLithoCode.Text) Then
                Interaction.MsgBox("You must enter a numeric LithoCode!", MsgBoxStyle.Exclamation, Nothing)
            Else
                Me.Cursor = Cursors.WaitCursor
                Me.PopLogEntries(New DateTime(1900, 1, 1), New DateTime(1900, 1, 1), Me.txtLithoCode.Text)
                Me.PopLogView
                Me.Cursor = Cursors.Default
            End If
        End Sub

        Private Sub btnPreview_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim enumerator As IEnumerator
            Try 
                enumerator = Me.lvwEmailEntries.Items.GetEnumerator
                Do While enumerator.MoveNext
                    Dim current As ListViewItem = DirectCast(enumerator.Current, ListViewItem)
                    If current.Selected Then
                        Using formPreview As New frmPreview(modMain.gobjEmailEntries.Item(IntegerType.FromObject(current.Tag)).GetSampleEmail(Me.chkTo.Checked, Me.chkCC.Checked))
                            formPreview.ShowDialog()
                        End Using
                    End If
                Loop
            Finally
                If TypeOf enumerator Is IDisposable Then
                    DirectCast(enumerator, IDisposable).Dispose
                End If
            End Try
        End Sub

        Private Sub btnPreviewLog_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim enumerator As IEnumerator
            Try 
                enumerator = Me.lvwLog.Items.GetEnumerator
                Do While enumerator.MoveNext
                    Dim current As ListViewItem = DirectCast(enumerator.Current, ListViewItem)
                    If current.Selected Then
                        Dim formPreview As New frmPreview(modMain.gobjLogEntries.Item(IntegerType.FromObject(current.Tag)).GetSampleEmail(Me.chkTo.Checked, Me.chkCC.Checked))
                        formPreview.ShowDialog()
                    End If
                Loop
            Finally
                If TypeOf enumerator Is IDisposable Then
                    DirectCast(enumerator, IDisposable).Dispose
                End If
            End Try
        End Sub

        Private Sub btnSelect_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim enumerator As IEnumerator
            Try 
                enumerator = Me.lvwEmailEntries.Items.GetEnumerator
                Do While enumerator.MoveNext
                    Dim current As ListViewItem = DirectCast(enumerator.Current, ListViewItem)
                    current.Selected = True
                Loop
            Finally
                If TypeOf enumerator Is IDisposable Then
                    DirectCast(enumerator, IDisposable).Dispose
                End If
            End Try
        End Sub

        Private Sub btnSend_Click(ByVal sender As Object, ByVal e As EventArgs)
            Me.Cursor = Cursors.WaitCursor
            Dim item As ListViewItem
            For Each item In Me.lvwEmailEntries.Items
                If item.Selected Then
                    modMain.gobjEmailEntries.Item(IntegerType.FromObject(item.Tag)).SendEmail(Me.chkTo.Checked, Me.chkCC.Checked, -1)
                End If
            Next
            Me.Cursor = Cursors.Default
        End Sub

        Private Sub btnSendLog_Click(ByVal sender As Object, ByVal e As EventArgs)
            Me.Cursor = Cursors.WaitCursor
            Dim item As ListViewItem
            For Each item In Me.lvwLog.Items
                If item.Selected Then
                    modMain.gobjLogEntries.Item(IntegerType.FromObject(item.Tag)).SendEmail(Me.chkTo.Checked, Me.chkCC.Checked, -1)
                End If
            Next
            Me.Cursor = Cursors.Default
        End Sub

        Private Sub btnUnselect_Click(ByVal sender As Object, ByVal e As EventArgs)
            Dim enumerator As IEnumerator
            Try 
                enumerator = Me.lvwEmailEntries.Items.GetEnumerator
                Do While enumerator.MoveNext
                    Dim current As ListViewItem = DirectCast(enumerator.Current, ListViewItem)
                    current.Selected = False
                Loop
            Finally
                If TypeOf enumerator Is IDisposable Then
                    DirectCast(enumerator, IDisposable).Dispose
                End If
            End Try
        End Sub

        Protected Overrides Sub Dispose(ByVal disposing As Boolean)
            If (disposing AndAlso (Not Me.components Is Nothing)) Then
                Me.components.Dispose
            End If
            MyBase.Dispose(disposing)
        End Sub

        Private Sub frmMain_Load(ByVal sender As Object, ByVal e As EventArgs)
            modMain.WriteLogEntry("Program started")
            Dim str As String = Interaction.Command
            Me.PopEmailEntries
            If (StringType.StrCmp(str.Trim.ToUpper, "/SILENT", False) = 0) Then
                modMain.WriteLogEntry("Program running in silent mode")
                modMain.gobjEmailEntries.SendAllEmails(True, True)
                modMain.WriteLogEntry("Program ending in Silent Mode")
                Me.Close
            Else
                modMain.WriteLogEntry("Program running in interactive mode")
                Me.PopEmailView
                Me.dtpFrom.Value = DateTime.Now.AddDays(-7)
                Me.dtpTo.Value = DateTime.Now
                Me.sbrMain.Panels.Item(1).Text = ("Version: " & Application.ProductVersion)
            End If
        End Sub

        <DebuggerStepThrough> _
        Private Sub InitializeComponent()
            Dim manager As New ResourceManager(GetType(frmMain))
            Me.sbrMain = New StatusBar
            Me.tabMain = New TabControl
            Me.tabOutgoing = New TabPage
            Me.btnUnselect = New Button
            Me.btnSelect = New Button
            Me.grpRecipients = New GroupBox
            Me.btnPreview = New Button
            Me.btnSend = New Button
            Me.chkCC = New CheckBox
            Me.chkTo = New CheckBox
            Me.lvwEmailEntries = New ListView
            Me.chdClientUserID = New ColumnHeader
            Me.chdLithoList = New ColumnHeader
            Me.chdToList = New ColumnHeader
            Me.chdAccountDirector = New ColumnHeader
            Me.chdEmailFormat = New ColumnHeader
            Me.tabLog = New TabPage
            Me.grpFilterLog = New GroupBox
            Me.btnGoLitho = New Button
            Me.btnGoDate = New Button
            Me.txtLithoCode = New TextBox
            Me.lblLithoCode = New Label
            Me.dtpTo = New DateTimePicker
            Me.lblTo = New Label
            Me.dtpFrom = New DateTimePicker
            Me.lblFrom = New Label
            Me.grpEmailLog = New GroupBox
            Me.btnPreviewLog = New Button
            Me.btnSendLog = New Button
            Me.chkCCLog = New CheckBox
            Me.chkToLog = New CheckBox
            Me.lvwLog = New ListView
            Me.chdClientUserIDLog = New ColumnHeader
            Me.chdLithoListLog = New ColumnHeader
            Me.chdToListLog = New ColumnHeader
            Me.chdAcctDirectorLog = New ColumnHeader
            Me.chdEmailFormatLog = New ColumnHeader
            Me.chdDateSentLog = New ColumnHeader
            Me.sbpStatus = New StatusBarPanel
            Me.sbpVersion = New StatusBarPanel
            Me.tabMain.SuspendLayout
            Me.tabOutgoing.SuspendLayout
            Me.grpRecipients.SuspendLayout
            Me.tabLog.SuspendLayout
            Me.grpFilterLog.SuspendLayout
            Me.grpEmailLog.SuspendLayout
            Me.sbpStatus.BeginInit
            Me.sbpVersion.BeginInit
            Me.SuspendLayout
            Dim point As New Point(0, &H17F)
            Me.sbrMain.Location = point
            Me.sbrMain.Name = "sbrMain"
            Me.sbrMain.Panels.AddRange(New StatusBarPanel() { Me.sbpStatus, Me.sbpVersion })
            Me.sbrMain.ShowPanels = True
            Dim size As New Size(&H2A4, &H16)
            Me.sbrMain.Size = size
            Me.sbrMain.TabIndex = &H18
            Me.tabMain.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
            Me.tabMain.Controls.AddRange(New Control() { Me.tabOutgoing, Me.tabLog })
            point = New Point(8, 8)
            Me.tabMain.Location = point
            Me.tabMain.Name = "tabMain"
            Me.tabMain.SelectedIndex = 0
            size = New Size(660, &H16C)
            Me.tabMain.Size = size
            Me.tabMain.TabIndex = 0
            Me.tabOutgoing.Controls.AddRange(New Control() { Me.btnUnselect, Me.btnSelect, Me.grpRecipients, Me.lvwEmailEntries })
            Me.tabOutgoing.DockPadding.All = 8
            point = New Point(4, &H16)
            Me.tabOutgoing.Location = point
            Me.tabOutgoing.Name = "tabOutgoing"
            size = New Size(&H28C, &H152)
            Me.tabOutgoing.Size = size
            Me.tabOutgoing.TabIndex = 0
            Me.tabOutgoing.Text = "Outgoing Email"
            Me.btnUnselect.Anchor = (AnchorStyles.Left Or AnchorStyles.Bottom)
            point = New Point(&H68, &H108)
            Me.btnUnselect.Location = point
            Me.btnUnselect.Name = "btnUnselect"
            size = New Size(&H54, &H18)
            Me.btnUnselect.Size = size
            Me.btnUnselect.TabIndex = 3
            Me.btnUnselect.Text = "Unselect All"
            Me.btnSelect.Anchor = (AnchorStyles.Left Or AnchorStyles.Bottom)
            point = New Point(12, &H108)
            Me.btnSelect.Location = point
            Me.btnSelect.Name = "btnSelect"
            size = New Size(&H54, &H18)
            Me.btnSelect.Size = size
            Me.btnSelect.TabIndex = 2
            Me.btnSelect.Text = "Select All"
            Me.grpRecipients.Anchor = (AnchorStyles.Right Or AnchorStyles.Bottom)
            Me.grpRecipients.Controls.AddRange(New Control() { Me.btnPreview, Me.btnSend, Me.chkCC, Me.chkTo })
            point = New Point(&H14C, 260)
            Me.grpRecipients.Location = point
            Me.grpRecipients.Name = "grpRecipients"
            size = New Size(&H138, &H48)
            Me.grpRecipients.Size = size
            Me.grpRecipients.TabIndex = 4
            Me.grpRecipients.TabStop = False
            Me.grpRecipients.Text = " Email Recipients "
            point = New Point(&HB8, 40)
            Me.btnPreview.Location = point
            Me.btnPreview.Name = "btnPreview"
            size = New Size(&H74, &H18)
            Me.btnPreview.Size = size
            Me.btnPreview.TabIndex = 8
            Me.btnPreview.Text = "Preview Emails"
            point = New Point(&HB8, 12)
            Me.btnSend.Location = point
            Me.btnSend.Name = "btnSend"
            size = New Size(&H74, &H18)
            Me.btnSend.Size = size
            Me.btnSend.TabIndex = 7
            Me.btnSend.Text = "Send Emails"
            Me.chkCC.Checked = True
            Me.chkCC.CheckState = CheckState.Checked
            point = New Point(12, &H2C)
            Me.chkCC.Location = point
            Me.chkCC.Name = "chkCC"
            size = New Size(&H9C, &H10)
            Me.chkCC.Size = size
            Me.chkCC.TabIndex = 6
            Me.chkCC.Text = "CC List (Account Director)"
            Me.chkTo.Checked = True
            Me.chkTo.CheckState = CheckState.Checked
            point = New Point(12, 20)
            Me.chkTo.Location = point
            Me.chkTo.Name = "chkTo"
            size = New Size(&H9C, &H10)
            Me.chkTo.Size = size
            Me.chkTo.TabIndex = 5
            Me.chkTo.Text = "To List (Client)"
            Me.lvwEmailEntries.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
            Me.lvwEmailEntries.Columns.AddRange(New ColumnHeader() { Me.chdClientUserID, Me.chdLithoList, Me.chdToList, Me.chdAccountDirector, Me.chdEmailFormat })
            Me.lvwEmailEntries.FullRowSelect = True
            Me.lvwEmailEntries.HideSelection = False
            point = New Point(8, 8)
            Me.lvwEmailEntries.Location = point
            Me.lvwEmailEntries.Name = "lvwEmailEntries"
            size = New Size(&H27C, &HF8)
            Me.lvwEmailEntries.Size = size
            Me.lvwEmailEntries.TabIndex = 1
            Me.lvwEmailEntries.View = View.Details
            Me.chdClientUserID.Text = "ClientUserID"
            Me.chdClientUserID.Width = &H4B
            Me.chdLithoList.Text = "LithoCode List"
            Me.chdLithoList.Width = 240
            Me.chdToList.Text = "To List"
            Me.chdToList.Width = 120
            Me.chdAccountDirector.Text = "Acct Dir"
            Me.chdAccountDirector.Width = 90
            Me.chdEmailFormat.Text = "Email Format"
            Me.chdEmailFormat.Width = 90
            Me.tabLog.Controls.AddRange(New Control() { Me.grpFilterLog, Me.grpEmailLog, Me.lvwLog })
            point = New Point(4, &H16)
            Me.tabLog.Location = point
            Me.tabLog.Name = "tabLog"
            size = New Size(&H28C, &H152)
            Me.tabLog.Size = size
            Me.tabLog.TabIndex = 1
            Me.tabLog.Text = "Email Log"
            Me.grpFilterLog.Anchor = (AnchorStyles.Left Or AnchorStyles.Bottom)
            Me.grpFilterLog.Controls.AddRange(New Control() { Me.btnGoLitho, Me.btnGoDate, Me.txtLithoCode, Me.lblLithoCode, Me.dtpTo, Me.lblTo, Me.dtpFrom, Me.lblFrom })
            point = New Point(8, 260)
            Me.grpFilterLog.Location = point
            Me.grpFilterLog.Name = "grpFilterLog"
            size = New Size(&H13C, &H48)
            Me.grpFilterLog.Size = size
            Me.grpFilterLog.TabIndex = 10
            Me.grpFilterLog.TabStop = False
            Me.grpFilterLog.Text = " Log Filtering "
            point = New Point(&H10C, &H2C)
            Me.btnGoLitho.Location = point
            Me.btnGoLitho.Name = "btnGoLitho"
            size = New Size(&H24, 20)
            Me.btnGoLitho.Size = size
            Me.btnGoLitho.TabIndex = &H12
            Me.btnGoLitho.Text = "Go"
            point = New Point(&H10C, &H11)
            Me.btnGoDate.Location = point
            Me.btnGoDate.Name = "btnGoDate"
            size = New Size(&H24, 20)
            Me.btnGoDate.Size = size
            Me.btnGoDate.TabIndex = 15
            Me.btnGoDate.Text = "Go"
            point = New Point(&H4C, &H2C)
            Me.txtLithoCode.Location = point
            Me.txtLithoCode.Name = "txtLithoCode"
            size = New Size(&HB8, &H15)
            Me.txtLithoCode.Size = size
            Me.txtLithoCode.TabIndex = &H11
            Me.txtLithoCode.Text = ""
            point = New Point(12, &H30)
            Me.lblLithoCode.Location = point
            Me.lblLithoCode.Name = "lblLithoCode"
            size = New Size(&H40, &H10)
            Me.lblLithoCode.Size = size
            Me.lblLithoCode.TabIndex = &H10
            Me.lblLithoCode.Text = "LithoCode:"
            Me.dtpTo.Format = DateTimePickerFormat.Short
            point = New Point(&HAC, &H10)
            Me.dtpTo.Location = point
            Me.dtpTo.Name = "dtpTo"
            size = New Size(&H58, &H15)
            Me.dtpTo.Size = size
            Me.dtpTo.TabIndex = 14
            point = New Point(&H94, 20)
            Me.lblTo.Location = point
            Me.lblTo.Name = "lblTo"
            size = New Size(&H18, &H10)
            Me.lblTo.Size = size
            Me.lblTo.TabIndex = 13
            Me.lblTo.Text = "To:"
            Me.dtpFrom.Format = DateTimePickerFormat.Short
            point = New Point(&H34, &H10)
            Me.dtpFrom.Location = point
            Me.dtpFrom.Name = "dtpFrom"
            size = New Size(&H58, &H15)
            Me.dtpFrom.Size = size
            Me.dtpFrom.TabIndex = 12
            point = New Point(12, 20)
            Me.lblFrom.Location = point
            Me.lblFrom.Name = "lblFrom"
            size = New Size(40, &H10)
            Me.lblFrom.Size = size
            Me.lblFrom.TabIndex = 11
            Me.lblFrom.Text = "From:"
            Me.grpEmailLog.Anchor = (AnchorStyles.Right Or AnchorStyles.Bottom)
            Me.grpEmailLog.Controls.AddRange(New Control() { Me.btnPreviewLog, Me.btnSendLog, Me.chkCCLog, Me.chkToLog })
            point = New Point(&H14C, 260)
            Me.grpEmailLog.Location = point
            Me.grpEmailLog.Name = "grpEmailLog"
            size = New Size(&H138, &H48)
            Me.grpEmailLog.Size = size
            Me.grpEmailLog.TabIndex = &H13
            Me.grpEmailLog.TabStop = False
            Me.grpEmailLog.Text = " Email Recipients "
            point = New Point(&HB8, 40)
            Me.btnPreviewLog.Location = point
            Me.btnPreviewLog.Name = "btnPreviewLog"
            size = New Size(&H74, &H18)
            Me.btnPreviewLog.Size = size
            Me.btnPreviewLog.TabIndex = &H17
            Me.btnPreviewLog.Text = "Preview Emails"
            point = New Point(&HB8, 12)
            Me.btnSendLog.Location = point
            Me.btnSendLog.Name = "btnSendLog"
            size = New Size(&H74, &H18)
            Me.btnSendLog.Size = size
            Me.btnSendLog.TabIndex = &H16
            Me.btnSendLog.Text = "Send Emails"
            Me.chkCCLog.Checked = True
            Me.chkCCLog.CheckState = CheckState.Checked
            point = New Point(12, &H2C)
            Me.chkCCLog.Location = point
            Me.chkCCLog.Name = "chkCCLog"
            size = New Size(&H9C, &H10)
            Me.chkCCLog.Size = size
            Me.chkCCLog.TabIndex = &H15
            Me.chkCCLog.Text = "CC List (Account Director)"
            Me.chkToLog.Checked = True
            Me.chkToLog.CheckState = CheckState.Checked
            point = New Point(12, 20)
            Me.chkToLog.Location = point
            Me.chkToLog.Name = "chkToLog"
            size = New Size(&H9C, &H10)
            Me.chkToLog.Size = size
            Me.chkToLog.TabIndex = 20
            Me.chkToLog.Text = "To List (Client)"
            Me.lvwLog.Anchor = (AnchorStyles.Right Or (AnchorStyles.Left Or (AnchorStyles.Bottom Or AnchorStyles.Top)))
            Me.lvwLog.Columns.AddRange(New ColumnHeader() { Me.chdClientUserIDLog, Me.chdLithoListLog, Me.chdToListLog, Me.chdAcctDirectorLog, Me.chdEmailFormatLog, Me.chdDateSentLog })
            Me.lvwLog.FullRowSelect = True
            Me.lvwLog.HideSelection = False
            point = New Point(8, 8)
            Me.lvwLog.Location = point
            Me.lvwLog.Name = "lvwLog"
            size = New Size(&H27C, &HF8)
            Me.lvwLog.Size = size
            Me.lvwLog.TabIndex = 9
            Me.lvwLog.View = View.Details
            Me.chdClientUserIDLog.Text = "ClientUserID"
            Me.chdClientUserIDLog.Width = &H4B
            Me.chdLithoListLog.Text = "LithoCode List"
            Me.chdLithoListLog.Width = 180
            Me.chdToListLog.Text = "To List"
            Me.chdToListLog.Width = 120
            Me.chdAcctDirectorLog.Text = "Acct Dir"
            Me.chdAcctDirectorLog.Width = &H4B
            Me.chdEmailFormatLog.Text = "Email Format"
            Me.chdEmailFormatLog.Width = &H4B
            Me.chdDateSentLog.Text = "Date Sent"
            Me.chdDateSentLog.Width = 90
            Me.sbpStatus.AutoSize = StatusBarPanelAutoSize.Spring
            Me.sbpStatus.Text = "Ready"
            Me.sbpStatus.Width = &H24A
            Me.sbpVersion.Alignment = HorizontalAlignment.Center
            Me.sbpVersion.AutoSize = StatusBarPanelAutoSize.Contents
            Me.sbpVersion.Text = "1.00.0000.0"
            Me.sbpVersion.Width = &H4A
            size = New Size(5, 14)
            Me.AutoScaleBaseSize = size
            size = New Size(&H2A4, &H195)
            Me.ClientSize = size
            Me.Controls.AddRange(New Control() { Me.tabMain, Me.sbrMain })
            Me.Font = New Font("Tahoma", 8.25!, FontStyle.Regular, GraphicsUnit.Point, 0)
            Me.Icon = DirectCast(manager.GetObject("$this.Icon"), Icon)
            size = New Size(&H2AC, &H1B0)
            Me.MinimumSize = size
            Me.Name = "frmMain"
            Me.StartPosition = FormStartPosition.CenterScreen
            Me.Text = "Service Alert Email Server"
            Me.tabMain.ResumeLayout(False)
            Me.tabOutgoing.ResumeLayout(False)
            Me.grpRecipients.ResumeLayout(False)
            Me.tabLog.ResumeLayout(False)
            Me.grpFilterLog.ResumeLayout(False)
            Me.grpEmailLog.ResumeLayout(False)
            Me.sbpStatus.EndInit
            Me.sbpVersion.EndInit
            Me.ResumeLayout(False)
        End Sub

        <STAThread> _
        Public Shared Sub Main()
            Application.Run(New frmMain)
        End Sub

        Private Sub PopEmailEntries()
            modMain.WriteLogEntry("Getting list of emails to send from QP_Comments (sp_WA_SAEmail)")
            Dim connection As New SqlConnection(modMain.GetSQLConnectString("Comments"))
            Dim adapter As New SqlDataAdapter
            Dim command As New SqlCommand("sp_WA_SAEmail")
            Dim command2 As SqlCommand = command
            command2.CommandType = CommandType.StoredProcedure
            command2.Connection = connection
            command2 = Nothing
            adapter.SelectCommand = command
            Dim dataSet As New DataSet
            adapter.Fill(dataSet)
            modMain.gobjEmailEntries = New clsEmailEntries
            modMain.WriteLogEntry("Populating Collection")
            Dim set2 As DataSet = dataSet
            Dim num As Integer = 0
            Dim count As Integer = set2.Tables.Item(0).Rows.Count
            Dim num4 As Integer = (set2.Tables.Item(1).Rows.Count - 1)
            Dim i As Integer = 0
            Do While (i <= num4)
                Do While (num <> count)
                    If (ObjectType.ObjTst(set2.Tables.Item(1).Rows.Item(i).Item("ClientUser_id"), set2.Tables.Item(0).Rows.Item(num).Item("ClientUser_id"), False) = 0) Then
                        modMain.gobjEmailEntries.Add(IntegerType.FromObject(set2.Tables.Item(1).Rows.Item(i).Item("ClientUser_id")), StringType.FromObject(set2.Tables.Item(0).Rows.Item(num).Item("strLithoCode")), StringType.FromObject(Interaction.IIf(Information.IsDBNull(RuntimeHelpers.GetObjectValue(set2.Tables.Item(1).Rows.Item(i).Item("strEmailList"))), "", RuntimeHelpers.GetObjectValue(set2.Tables.Item(1).Rows.Item(i).Item("strEmailList")))), StringType.FromObject(Interaction.IIf(Information.IsDBNull(RuntimeHelpers.GetObjectValue(set2.Tables.Item(1).Rows.Item(i).Item("ad"))), "", RuntimeHelpers.GetObjectValue(set2.Tables.Item(1).Rows.Item(i).Item("ad")))), IntegerType.FromObject(Interaction.IIf(Information.IsDBNull(RuntimeHelpers.GetObjectValue(set2.Tables.Item(1).Rows.Item(i).Item("intEmailFormat"))), 1, RuntimeHelpers.GetObjectValue(set2.Tables.Item(1).Rows.Item(i).Item("intEmailFormat")))))
                    Else
                        Exit Do
                    End If
                    num += 1
                Loop
                i += 1
            Loop
            set2 = Nothing
            dataSet.Dispose
            adapter.Dispose
            connection.Close
            connection.Dispose
            modMain.WriteLogEntry(String.Format("Collection populated with info for {0} emails", modMain.gobjEmailEntries.Count))
            modMain.WriteLogEntry(String.Format("Collection contains {0} emails to be sent", modMain.gobjEmailEntries.CountToBeSent))
        End Sub

        Private Sub PopEmailView()
            Dim num3 As Integer = (modMain.gobjEmailEntries.Count - 1)
            Dim i As Integer = 0
            Do While (i <= num3)
                If modMain.gobjEmailEntries.Item(i).PrivSAEMail Then
                    Dim item2 As ListViewItem = Me.lvwEmailEntries.Items.Add(modMain.gobjEmailEntries.Item(i).ClientUserID.ToString)
                    item2.Tag = i
                    item2.SubItems.Add(modMain.gobjEmailEntries.Item(i).LithoCodeList)
                    item2.SubItems.Add(modMain.gobjEmailEntries.Item(i).EmailList)
                    item2.SubItems.Add(modMain.gobjEmailEntries.Item(i).AcctDirector)
                    item2.SubItems.Add(modMain.gobjEmailEntries.Item(i).EmailFormat.FormatName)
                    item2 = Nothing
                End If
                i += 1
            Loop
        End Sub

        Private Sub PopLogEntries(Optional ByVal datStartDate As DateTime = #1/1/1900#, Optional ByVal datEndDate As DateTime = #1/1/1900#, Optional ByVal strLithoCode As String = "")
            Dim connection As New SqlConnection(modMain.GetSQLConnectString("Comments"))
            connection.Open()
            Dim command As New SqlCommand("sp_WA_SAEmailLog")
            Dim command2 As SqlCommand = command
            command2.CommandType = CommandType.StoredProcedure
            command2.Connection = connection
            If (strLithoCode.Length > 0) Then
                command2.Parameters.Add("@strLithoCode", SqlDbType.VarChar, 10).Value = strLithoCode
            ElseIf ((DateTime.Compare(datStartDate, New DateTime(1900, 1, 1)) <> 0) And (DateTime.Compare(datEndDate, New DateTime(1900, 1, 1)) <> 0)) Then
                command2.Parameters.Add("@datStartDate", SqlDbType.DateTime).Value = datStartDate
                command2.Parameters.Add("@datEndDate", SqlDbType.DateTime).Value = datEndDate
            End If
            command2 = Nothing
            Dim reader As SqlDataReader = command.ExecuteReader
            If (Not modMain.gobjLogEntries Is Nothing) Then
                modMain.gobjLogEntries.Clear()
            End If
            modMain.gobjLogEntries = New clsEmailEntries
            Do While reader.Read
                modMain.gobjLogEntries.Add(IntegerType.FromObject(reader.Item("ClientUser_id")), StringType.FromObject(reader.Item("strLithoList")), StringType.FromObject(Interaction.IIf(Information.IsDBNull(RuntimeHelpers.GetObjectValue(reader.Item("strToList"))), "", RuntimeHelpers.GetObjectValue(reader.Item("strToList")))), StringType.FromObject(Interaction.IIf(Information.IsDBNull(RuntimeHelpers.GetObjectValue(reader.Item("strAcctDirector"))), "", RuntimeHelpers.GetObjectValue(reader.Item("strAcctDirector")))), IntegerType.FromObject(reader.Item("intEmailFormat")), DateType.FromObject(reader.Item("datDateSent_dt")))
            Loop
            reader.Close()
            connection.Close()
            connection.Dispose()
        End Sub

        Private Sub PopLogView()
            Me.lvwLog.Items.Clear
            Dim num3 As Integer = (modMain.gobjLogEntries.Count - 1)
            Dim i As Integer = 0
            Do While (i <= num3)
                Dim item2 As ListViewItem = Me.lvwLog.Items.Add(modMain.gobjLogEntries.Item(i).ClientUserID.ToString)
                item2.Tag = i
                item2.SubItems.Add(modMain.gobjLogEntries.Item(i).LithoCodeList)
                item2.SubItems.Add(modMain.gobjLogEntries.Item(i).EmailList)
                item2.SubItems.Add(modMain.gobjLogEntries.Item(i).AcctDirector)
                item2.SubItems.Add(modMain.gobjLogEntries.Item(i).EmailFormat.FormatName)
                item2.SubItems.Add(modMain.gobjLogEntries.Item(i).DateSent.ToString)
                item2 = Nothing
                i += 1
            Loop
        End Sub


        ' Properties
        Friend Overridable Property btnGoDate As Button
            Get
                Return Me._btnGoDate
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnGoDate Is Nothing) Then
                    RemoveHandler Me._btnGoDate.Click, New EventHandler(AddressOf Me.btnGoDate_Click)
                End If
                Me._btnGoDate = WithEventsValue
                If (Not Me._btnGoDate Is Nothing) Then
                    AddHandler Me._btnGoDate.Click, New EventHandler(AddressOf Me.btnGoDate_Click)
                End If
            End Set
        End Property

        Friend Overridable Property btnGoLitho As Button
            Get
                Return Me._btnGoLitho
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnGoLitho Is Nothing) Then
                    RemoveHandler Me._btnGoLitho.Click, New EventHandler(AddressOf Me.btnGoLitho_Click)
                End If
                Me._btnGoLitho = WithEventsValue
                If (Not Me._btnGoLitho Is Nothing) Then
                    AddHandler Me._btnGoLitho.Click, New EventHandler(AddressOf Me.btnGoLitho_Click)
                End If
            End Set
        End Property

        Friend Overridable Property btnPreview As Button
            Get
                Return Me._btnPreview
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnPreview Is Nothing) Then
                    RemoveHandler Me._btnPreview.Click, New EventHandler(AddressOf Me.btnPreview_Click)
                End If
                Me._btnPreview = WithEventsValue
                If (Not Me._btnPreview Is Nothing) Then
                    AddHandler Me._btnPreview.Click, New EventHandler(AddressOf Me.btnPreview_Click)
                End If
            End Set
        End Property

        Friend Overridable Property btnPreviewLog As Button
            Get
                Return Me._btnPreviewLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnPreviewLog Is Nothing) Then
                    RemoveHandler Me._btnPreviewLog.Click, New EventHandler(AddressOf Me.btnPreviewLog_Click)
                End If
                Me._btnPreviewLog = WithEventsValue
                If (Not Me._btnPreviewLog Is Nothing) Then
                    AddHandler Me._btnPreviewLog.Click, New EventHandler(AddressOf Me.btnPreviewLog_Click)
                End If
            End Set
        End Property

        Friend Overridable Property btnSelect As Button
            Get
                Return Me._btnSelect
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnSelect Is Nothing) Then
                    RemoveHandler Me._btnSelect.Click, New EventHandler(AddressOf Me.btnSelect_Click)
                End If
                Me._btnSelect = WithEventsValue
                If (Not Me._btnSelect Is Nothing) Then
                    AddHandler Me._btnSelect.Click, New EventHandler(AddressOf Me.btnSelect_Click)
                End If
            End Set
        End Property

        Friend Overridable Property btnSend As Button
            Get
                Return Me._btnSend
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnSend Is Nothing) Then
                    RemoveHandler Me._btnSend.Click, New EventHandler(AddressOf Me.btnSend_Click)
                End If
                Me._btnSend = WithEventsValue
                If (Not Me._btnSend Is Nothing) Then
                    AddHandler Me._btnSend.Click, New EventHandler(AddressOf Me.btnSend_Click)
                End If
            End Set
        End Property

        Friend Overridable Property btnSendLog As Button
            Get
                Return Me._btnSendLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnSendLog Is Nothing) Then
                    RemoveHandler Me._btnSendLog.Click, New EventHandler(AddressOf Me.btnSendLog_Click)
                End If
                Me._btnSendLog = WithEventsValue
                If (Not Me._btnSendLog Is Nothing) Then
                    AddHandler Me._btnSendLog.Click, New EventHandler(AddressOf Me.btnSendLog_Click)
                End If
            End Set
        End Property

        Friend Overridable Property btnUnselect As Button
            Get
                Return Me._btnUnselect
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Button)
                If (Not Me._btnUnselect Is Nothing) Then
                    RemoveHandler Me._btnUnselect.Click, New EventHandler(AddressOf Me.btnUnselect_Click)
                End If
                Me._btnUnselect = WithEventsValue
                If (Not Me._btnUnselect Is Nothing) Then
                    AddHandler Me._btnUnselect.Click, New EventHandler(AddressOf Me.btnUnselect_Click)
                End If
            End Set
        End Property

        Friend Overridable Property chdAccountDirector As ColumnHeader
            Get
                Return Me._chdAccountDirector
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdAccountDirector Is Nothing) Then
                End If
                Me._chdAccountDirector = WithEventsValue
                If (Not Me._chdAccountDirector Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdAcctDirectorLog As ColumnHeader
            Get
                Return Me._chdAcctDirectorLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdAcctDirectorLog Is Nothing) Then
                End If
                Me._chdAcctDirectorLog = WithEventsValue
                If (Not Me._chdAcctDirectorLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdClientUserID As ColumnHeader
            Get
                Return Me._chdClientUserID
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdClientUserID Is Nothing) Then
                End If
                Me._chdClientUserID = WithEventsValue
                If (Not Me._chdClientUserID Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdClientUserIDLog As ColumnHeader
            Get
                Return Me._chdClientUserIDLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdClientUserIDLog Is Nothing) Then
                End If
                Me._chdClientUserIDLog = WithEventsValue
                If (Not Me._chdClientUserIDLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdDateSentLog As ColumnHeader
            Get
                Return Me._chdDateSentLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdDateSentLog Is Nothing) Then
                End If
                Me._chdDateSentLog = WithEventsValue
                If (Not Me._chdDateSentLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdEmailFormat As ColumnHeader
            Get
                Return Me._chdEmailFormat
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdEmailFormat Is Nothing) Then
                End If
                Me._chdEmailFormat = WithEventsValue
                If (Not Me._chdEmailFormat Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdEmailFormatLog As ColumnHeader
            Get
                Return Me._chdEmailFormatLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdEmailFormatLog Is Nothing) Then
                End If
                Me._chdEmailFormatLog = WithEventsValue
                If (Not Me._chdEmailFormatLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdLithoList As ColumnHeader
            Get
                Return Me._chdLithoList
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdLithoList Is Nothing) Then
                End If
                Me._chdLithoList = WithEventsValue
                If (Not Me._chdLithoList Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdLithoListLog As ColumnHeader
            Get
                Return Me._chdLithoListLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdLithoListLog Is Nothing) Then
                End If
                Me._chdLithoListLog = WithEventsValue
                If (Not Me._chdLithoListLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdToList As ColumnHeader
            Get
                Return Me._chdToList
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdToList Is Nothing) Then
                End If
                Me._chdToList = WithEventsValue
                If (Not Me._chdToList Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chdToListLog As ColumnHeader
            Get
                Return Me._chdToListLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ColumnHeader)
                If (Not Me._chdToListLog Is Nothing) Then
                End If
                Me._chdToListLog = WithEventsValue
                If (Not Me._chdToListLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chkCC As CheckBox
            Get
                Return Me._chkCC
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As CheckBox)
                If (Not Me._chkCC Is Nothing) Then
                End If
                Me._chkCC = WithEventsValue
                If (Not Me._chkCC Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chkCCLog As CheckBox
            Get
                Return Me._chkCCLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As CheckBox)
                If (Not Me._chkCCLog Is Nothing) Then
                End If
                Me._chkCCLog = WithEventsValue
                If (Not Me._chkCCLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chkTo As CheckBox
            Get
                Return Me._chkTo
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As CheckBox)
                If (Not Me._chkTo Is Nothing) Then
                End If
                Me._chkTo = WithEventsValue
                If (Not Me._chkTo Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property chkToLog As CheckBox
            Get
                Return Me._chkToLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As CheckBox)
                If (Not Me._chkToLog Is Nothing) Then
                End If
                Me._chkToLog = WithEventsValue
                If (Not Me._chkToLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property dtpFrom As DateTimePicker
            Get
                Return Me._dtpFrom
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As DateTimePicker)
                If (Not Me._dtpFrom Is Nothing) Then
                End If
                Me._dtpFrom = WithEventsValue
                If (Not Me._dtpFrom Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property dtpTo As DateTimePicker
            Get
                Return Me._dtpTo
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As DateTimePicker)
                If (Not Me._dtpTo Is Nothing) Then
                End If
                Me._dtpTo = WithEventsValue
                If (Not Me._dtpTo Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property grpEmailLog As GroupBox
            Get
                Return Me._grpEmailLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As GroupBox)
                If (Not Me._grpEmailLog Is Nothing) Then
                End If
                Me._grpEmailLog = WithEventsValue
                If (Not Me._grpEmailLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property grpFilterLog As GroupBox
            Get
                Return Me._grpFilterLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As GroupBox)
                If (Not Me._grpFilterLog Is Nothing) Then
                End If
                Me._grpFilterLog = WithEventsValue
                If (Not Me._grpFilterLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property grpRecipients As GroupBox
            Get
                Return Me._grpRecipients
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As GroupBox)
                If (Not Me._grpRecipients Is Nothing) Then
                End If
                Me._grpRecipients = WithEventsValue
                If (Not Me._grpRecipients Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property lblFrom As Label
            Get
                Return Me._lblFrom
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Label)
                If (Not Me._lblFrom Is Nothing) Then
                End If
                Me._lblFrom = WithEventsValue
                If (Not Me._lblFrom Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property lblLithoCode As Label
            Get
                Return Me._lblLithoCode
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Label)
                If (Not Me._lblLithoCode Is Nothing) Then
                End If
                Me._lblLithoCode = WithEventsValue
                If (Not Me._lblLithoCode Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property lblTo As Label
            Get
                Return Me._lblTo
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As Label)
                If (Not Me._lblTo Is Nothing) Then
                End If
                Me._lblTo = WithEventsValue
                If (Not Me._lblTo Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property lvwEmailEntries As ListView
            Get
                Return Me._lvwEmailEntries
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ListView)
                If (Not Me._lvwEmailEntries Is Nothing) Then
                End If
                Me._lvwEmailEntries = WithEventsValue
                If (Not Me._lvwEmailEntries Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property lvwLog As ListView
            Get
                Return Me._lvwLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As ListView)
                If (Not Me._lvwLog Is Nothing) Then
                End If
                Me._lvwLog = WithEventsValue
                If (Not Me._lvwLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property sbpStatus As StatusBarPanel
            Get
                Return Me._sbpStatus
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As StatusBarPanel)
                If (Not Me._sbpStatus Is Nothing) Then
                End If
                Me._sbpStatus = WithEventsValue
                If (Not Me._sbpStatus Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property sbpVersion As StatusBarPanel
            Get
                Return Me._sbpVersion
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As StatusBarPanel)
                If (Not Me._sbpVersion Is Nothing) Then
                End If
                Me._sbpVersion = WithEventsValue
                If (Not Me._sbpVersion Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property sbrMain As StatusBar
            Get
                Return Me._sbrMain
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As StatusBar)
                If (Not Me._sbrMain Is Nothing) Then
                End If
                Me._sbrMain = WithEventsValue
                If (Not Me._sbrMain Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property tabLog As TabPage
            Get
                Return Me._tabLog
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As TabPage)
                If (Not Me._tabLog Is Nothing) Then
                End If
                Me._tabLog = WithEventsValue
                If (Not Me._tabLog Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property tabMain As TabControl
            Get
                Return Me._tabMain
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As TabControl)
                If (Not Me._tabMain Is Nothing) Then
                End If
                Me._tabMain = WithEventsValue
                If (Not Me._tabMain Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property tabOutgoing As TabPage
            Get
                Return Me._tabOutgoing
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As TabPage)
                If (Not Me._tabOutgoing Is Nothing) Then
                End If
                Me._tabOutgoing = WithEventsValue
                If (Not Me._tabOutgoing Is Nothing) Then
                End If
            End Set
        End Property

        Friend Overridable Property txtLithoCode As TextBox
            Get
                Return Me._txtLithoCode
            End Get
            <MethodImpl(MethodImplOptions.Synchronized)> _
            Set(ByVal WithEventsValue As TextBox)
                If (Not Me._txtLithoCode Is Nothing) Then
                End If
                Me._txtLithoCode = WithEventsValue
                If (Not Me._txtLithoCode Is Nothing) Then
                End If
            End Set
        End Property


        ' Fields
        <AccessedThroughProperty("btnGoDate")> _
        Private _btnGoDate As Button
        <AccessedThroughProperty("btnGoLitho")> _
        Private _btnGoLitho As Button
        <AccessedThroughProperty("btnPreview")> _
        Private _btnPreview As Button
        <AccessedThroughProperty("btnPreviewLog")> _
        Private _btnPreviewLog As Button
        <AccessedThroughProperty("btnSelect")> _
        Private _btnSelect As Button
        <AccessedThroughProperty("btnSend")> _
        Private _btnSend As Button
        <AccessedThroughProperty("btnSendLog")> _
        Private _btnSendLog As Button
        <AccessedThroughProperty("btnUnselect")> _
        Private _btnUnselect As Button
        <AccessedThroughProperty("chdAccountDirector")> _
        Private _chdAccountDirector As ColumnHeader
        <AccessedThroughProperty("chdAcctDirectorLog")> _
        Private _chdAcctDirectorLog As ColumnHeader
        <AccessedThroughProperty("chdClientUserID")> _
        Private _chdClientUserID As ColumnHeader
        <AccessedThroughProperty("chdClientUserIDLog")> _
        Private _chdClientUserIDLog As ColumnHeader
        <AccessedThroughProperty("chdDateSentLog")> _
        Private _chdDateSentLog As ColumnHeader
        <AccessedThroughProperty("chdEmailFormat")> _
        Private _chdEmailFormat As ColumnHeader
        <AccessedThroughProperty("chdEmailFormatLog")> _
        Private _chdEmailFormatLog As ColumnHeader
        <AccessedThroughProperty("chdLithoList")> _
        Private _chdLithoList As ColumnHeader
        <AccessedThroughProperty("chdLithoListLog")> _
        Private _chdLithoListLog As ColumnHeader
        <AccessedThroughProperty("chdToList")> _
        Private _chdToList As ColumnHeader
        <AccessedThroughProperty("chdToListLog")> _
        Private _chdToListLog As ColumnHeader
        <AccessedThroughProperty("chkCC")> _
        Private _chkCC As CheckBox
        <AccessedThroughProperty("chkCCLog")> _
        Private _chkCCLog As CheckBox
        <AccessedThroughProperty("chkTo")> _
        Private _chkTo As CheckBox
        <AccessedThroughProperty("chkToLog")> _
        Private _chkToLog As CheckBox
        <AccessedThroughProperty("dtpFrom")> _
        Private _dtpFrom As DateTimePicker
        <AccessedThroughProperty("dtpTo")> _
        Private _dtpTo As DateTimePicker
        <AccessedThroughProperty("grpEmailLog")> _
        Private _grpEmailLog As GroupBox
        <AccessedThroughProperty("grpFilterLog")> _
        Private _grpFilterLog As GroupBox
        <AccessedThroughProperty("grpRecipients")> _
        Private _grpRecipients As GroupBox
        <AccessedThroughProperty("lblFrom")> _
        Private _lblFrom As Label
        <AccessedThroughProperty("lblLithoCode")> _
        Private _lblLithoCode As Label
        <AccessedThroughProperty("lblTo")> _
        Private _lblTo As Label
        <AccessedThroughProperty("lvwEmailEntries")> _
        Private _lvwEmailEntries As ListView
        <AccessedThroughProperty("lvwLog")> _
        Private _lvwLog As ListView
        <AccessedThroughProperty("sbpStatus")> _
        Private _sbpStatus As StatusBarPanel
        <AccessedThroughProperty("sbpVersion")> _
        Private _sbpVersion As StatusBarPanel
        <AccessedThroughProperty("sbrMain")> _
        Private _sbrMain As StatusBar
        <AccessedThroughProperty("tabLog")> _
        Private _tabLog As TabPage
        <AccessedThroughProperty("tabMain")> _
        Private _tabMain As TabControl
        <AccessedThroughProperty("tabOutgoing")> _
        Private _tabOutgoing As TabPage
        <AccessedThroughProperty("txtLithoCode")> _
        Private _txtLithoCode As TextBox
        Private components As IContainer
    End Class
End Namespace

