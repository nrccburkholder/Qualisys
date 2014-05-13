Imports Nrc.NotificationAdmin.Library
Imports Nrc.Framework.BusinessLogic.Configuration
Imports Nrc.Framework.Notification
Imports System.IO
Imports System.Text
Imports System.Data

Public Class NotificationTestSection

    Private mNotificationTestNavigator As NotificationTestNavigator
    Private mTemplate As Template = Nothing
    Private mMessage As Message = Nothing
    Private mCurrentListView As ListView
    Private mDefinitions As Dictionary(Of String, String) = New Dictionary(Of String, String)
    Private mTableDefintions As Dictionary(Of String, DataTable) = New Dictionary(Of String, DataTable)
    Private mTableList As List(Of TemplateDefinition) = New List(Of TemplateDefinition)    

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        MyBase.RegisterNavControl(navCtrl)

        mNotificationTestNavigator = TryCast(navCtrl, NotificationTestNavigator)

    End Sub

    Public Overrides Sub ActivateSection()

        AddHandler mNotificationTestNavigator.NotificationNavigatorChanged, AddressOf mNotificationNavigator_NavigatorChanged

    End Sub

    Public Overrides Sub InactivateSection()

        RemoveHandler mNotificationTestNavigator.NotificationNavigatorChanged, AddressOf mNotificationNavigator_NavigatorChanged

    End Sub

    Private Sub mNotificationNavigator_NavigatorChanged(ByVal sender As Object, ByVal e As NotificationNavigatorChangedEventArgs)

        Me.mTemplate = Template.Get(e.TemplateID)
        RefreshSection()

    End Sub

    Private Sub RefreshSection()

        Me.mMessage = New Message(Me.mTemplate.Name, AppConfig.SMTPServer)
        Me.NotificationTestSectionPanel.Caption = String.Format("Test Template: {0} ({1})", mTemplate.Name, mTemplate.Id)
        Me.TemplateIDTextBox.Text = Me.mTemplate.Id.ToString
        Me.TemplateNameTextBox.Text = Me.mTemplate.Name
        Me.FromEmailTextBox.Text = Me.mMessage.From.Email
        Me.FromNameTextBox.Text = Me.mMessage.From.Name
        Me.txtSubject.Text = Me.mMessage.Subject
        Me.txtSMTPServer.Text = Me.mTemplate.SMTPServer

        'Populate the email address list views
        PopulateAddressListView(ToListView, mMessage.To)
        PopulateAddressListView(CcListView, mMessage.Cc)
        PopulateAddressListView(BccListView, mMessage.Bcc)

        LoadDefinitionsTab(True)
        SetSummary(True)
        SetPreview(True)

    End Sub

    Private Sub LoadDefinitionsTab(Optional ByVal OnTemplateChanged As Boolean = False)

        Dim blnTables As Boolean = False

        Dim dt As DataTable = New DataTable("Defintions")
        dt.Columns.Add(New DataColumn("Definition Name"))
        dt.Columns.Add(New DataColumn("Definition Value"))

        'Only do this once per template selection
        If OnTemplateChanged Then
            mTableList = New List(Of TemplateDefinition)

            For Each def As TemplateDefinition In Me.mTemplate.Definitions
                If def.IsTable Then
                    mTableList.Add(def)
                    blnTables = True
                Else
                    mMessage.ReplacementValues.Add(def.Name, "")
                    dt.Rows.Add(def.Name, "")
                End If
            Next

            dt.Columns(0).ReadOnly = True
            dgFieldDefinitions.DataSource = dt
            dgFieldDefinitions.AllowUserToAddRows = False

            If blnTables Then
                cboTableNames.DataSource = Me.mTableList
                cboTableNames.DisplayMember = "Name"
                cboTableNames.Visible = True
                lblTableNames.Visible = False
                cboTableNames.SelectedIndex = 0
                Me.dgTableColumnDefs.Visible = True
                lblTableColumnDefs.Visible = True
            Else
                cboTableNames.Visible = False
                lblTableNames.Visible = True
                Me.dgTableColumnDefs.Visible = False
                lblTableColumnDefs.Visible = False
            End If
        End If

    End Sub

    Private Sub SetSummary(Optional ByVal blnHideDialog As Boolean = False)

        Dim tempFile As String = My.Computer.FileSystem.GetTempFileName()
        tempFile = Replace(tempFile, ".tmp", ".htm")
        Dim sb As StringBuilder = New StringBuilder()
        Dim summary As String = String.Empty
        Dim sw As StreamWriter = Nothing

        Try
            If Not Me.mMessage Is Nothing Then
                If Me.mMessage.Summary(summary) Then
                    sw = New StreamWriter(tempFile, False)
                    sw.Write(summary)
                Else
                    If Not blnHideDialog Then
                        Dim dialog As ValidationDialog = New ValidationDialog(Me.mMessage.ValidationErrors)
                        dialog.ShowDialog()
                    End If
                    sb.Append("<html><head></head><body><p align='center'>Unable to create summary, message object is not valid.</p></body></head></html>")
                    sw = New StreamWriter(tempFile, False)
                    sw.Write(sb.ToString)
                End If
            Else
                sb.Append("<html><head></head><body><p align='center'>Unable to create summary, message object is not valid.</p></body></head></html>")
                sw = New StreamWriter(tempFile, False)
                sw.Write(sb.ToString)
            End If

        Finally
            If Not sw Is Nothing Then
                sw.Close()
            End If

        End Try

        Me.wbSummary.Url = New Uri(tempFile)

    End Sub

    Private Sub SetPreview(Optional ByVal blnHideDialog As Boolean = False)

        Dim tempFile As String = My.Computer.FileSystem.GetTempFileName()
        tempFile = Replace(tempFile, ".tmp", ".htm")
        Dim sb As StringBuilder = New StringBuilder()
        Dim summary As String = String.Empty
        Dim sw As StreamWriter = Nothing

        Me.txtSubjectLine1.Text = ""    'Init
        Me.txtSubjectLine2.Text = ""    'Init
        Me.txtTextView.Text = ""        'Init

        Try
            If Not Me.mMessage Is Nothing Then
                If Not Me.mMessage.Validate Then
                    If Not blnHideDialog Then
                        Dim dialog As ValidationDialog = New ValidationDialog(Me.mMessage.ValidationErrors)
                        dialog.ShowDialog()
                    End If
                    sb.Append("<html><head></head><body><p align='center'>Unable to create preview, message object is not valid.</p></body></head></html>")
                    sw = New StreamWriter(tempFile, False)
                    sw.Write(sb.ToString)
                Else
                    Me.mMessage.MergeTemplate()
                    Dim htmlString As String = "<html><head></head><body>" & Me.mMessage.BodyHtml & "</body></html>"
                    sw = New StreamWriter(tempFile, False)
                    sw.Write(htmlString)
                    txtSubjectLine1.Text = Me.mMessage.Subject
                    txtSubjectLine2.Text = Me.mMessage.Subject
                    Me.txtTextView.Text = Me.mMessage.BodyText
                End If
            Else
                sb.Append("<html><head></head><body><p align='center'>Unable to create preview, message object is not valid.</p></body></head></html>")
                sw = New StreamWriter(tempFile, False)
                sw.Write(sb.ToString)
            End If

        Finally
            If Not sw Is Nothing Then
                sw.Close()
            End If

        End Try

        Me.wbPreview.Url = New Uri(tempFile)

    End Sub

    Private Sub PopulateAddressListView(ByVal listView As ListView, ByVal addresses As AddressCollection)

        listView.Items.Clear()
        listView.Tag = addresses
        For Each addr As Address In addresses
            AddAddressToListView(listView, addr)
        Next

    End Sub

    Private Sub AddAddressToListView(ByVal listView As ListView, ByVal addr As Address)

        Dim item As ListViewItem = listView.Items.Add(addr.Email, "EmailAddress")
        item.SubItems.Add(addr.Name)
        item.SubItems.Add(addr.Link)
        item.SubItems.Add(addr.Merged)
        item.Tag = addr

    End Sub

    Private Sub ListView_MouseDown(ByVal sender As Object, ByVal e As System.Windows.Forms.MouseEventArgs) Handles ToListView.MouseDown, CcListView.MouseDown, BccListView.MouseDown

        If e.Button = Windows.Forms.MouseButtons.Right Then
            mCurrentListView = TryCast(sender, ListView)
            Dim info As ListViewHitTestInfo = mCurrentListView.HitTest(e.Location)
            If info.Item Is Nothing Then
                mCurrentListView.SelectedItems.Clear()
                AddAddressToolStripMenuItem.Enabled = True
                EditAddressToolStripMenuItem.Enabled = False
                RemoveAddressToolStripMenuItem.Enabled = False
            Else
                info.Item.Selected = True
                AddAddressToolStripMenuItem.Enabled = True
                EditAddressToolStripMenuItem.Enabled = True
                RemoveAddressToolStripMenuItem.Enabled = True
            End If
        End If

    End Sub

    Private Sub AddAddressToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddAddressToolStripMenuItem.Click

        Dim dialog As New AddressDialog

        With dialog
            If .ShowDialog = DialogResult.OK Then
                'Create the new address object
                Dim addr As New Address(.EmailAddress, .EmailName)

                'Add the new address to the collection
                DirectCast(mCurrentListView.Tag, AddressCollection).Add(addr)

                'Add the new address to the listview
                AddAddressToListView(mCurrentListView, addr)
            End If
        End With

    End Sub

    Private Sub EditAddressToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles EditAddressToolStripMenuItem.Click

        Dim dialog As New AddressDialog
        Dim item As ListViewItem = mCurrentListView.SelectedItems(0)
        Dim addr As Address = DirectCast(item.Tag, Address)

        With dialog
            .EmailAddress = addr.Email
            .EmailName = addr.Name

            If .ShowDialog = DialogResult.OK Then
                'Update the address object
                addr.Email = .EmailAddress
                addr.Name = .EmailName

                'Update the listview
                item.Text = addr.Email
                item.SubItems(1).Text = addr.Name
                item.SubItems(2).Text = addr.Link
                item.SubItems(3).Text = addr.Merged
            End If
        End With

    End Sub

    Private Sub RemoveAddressToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveAddressToolStripMenuItem.Click

        Dim item As ListViewItem = mCurrentListView.SelectedItems(0)
        Dim addr As Address = DirectCast(item.Tag, Address)
        Dim addrCollection As AddressCollection = DirectCast(mCurrentListView.Tag, AddressCollection)

        If MessageBox.Show(String.Format("You have selected to remove the following address:{0}{0}Email: {1}{0}Name: {2}{0}{0}Do you wish to continue?", vbCrLf, addr.Email, addr.Name), "Remove Address", MessageBoxButtons.OKCancel, MessageBoxIcon.Question) = DialogResult.OK Then
            'Remove it from the listview
            mCurrentListView.Items.Remove(item)

            'Remove it from the address collection
            addrCollection.Remove(addr)
        End If

    End Sub

    Private Sub cboTableNames_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cboTableNames.SelectedIndexChanged

        Dim tableDef As TemplateDefinition = DirectCast(cboTableNames.SelectedItem, TemplateDefinition)
        Dim tableName As String = tableDef.Name
        Dim dt As DataTable

        If Me.mMessage.ReplacementTables.ContainsKey(tableName) Then
            dt = Me.mMessage.ReplacementTables(tableName)
        Else
            dt = New DataTable(tableName)
            For Each tblDef As TemplateTableDefinition In tableDef.TableDefinitions
                dt.Columns.Add(New DataColumn(tblDef.ColumnName))
            Next
            dt.Rows.Add()
            Me.mMessage.ReplacementTables.Add(tableName, dt)
        End If

        Me.dgTableColumnDefs.DataSource = Me.mMessage.ReplacementTables(tableName)
        Me.dgTableColumnDefs.AllowUserToAddRows = True
        Me.dgTableColumnDefs.AllowUserToDeleteRows = True

    End Sub

    Private Sub tabTemplate_Selected(ByVal sender As System.Object, ByVal e As System.Windows.Forms.TabControlEventArgs) Handles tabTemplate.Selected

        Dim tabName As String = e.TabPage.Text

        Select Case LCase(tabName)
            Case "preview"
                SetPreview()

            Case "summary"
                SetSummary()

        End Select

    End Sub

    Private Sub FromButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FromButton.Click

        Dim dialog As New AddressDialog

        With dialog
            .EmailAddress = mMessage.From.Email
            .EmailName = mMessage.From.Name

            If .ShowDialog = DialogResult.OK Then
                'Update the address object
                mMessage.From.Email = .EmailAddress
                mMessage.From.Name = .EmailName

                'Update the screen
                FromEmailTextBox.Text = mMessage.From.Email
                FromNameTextBox.Text = mMessage.From.Name
            End If
        End With

    End Sub

    Private Sub dgFieldDefinitions_CellLeave(ByVal sender As System.Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles dgFieldDefinitions.CellLeave

        If e.ColumnIndex = 1 Then
            Dim colName As String = dgFieldDefinitions.Rows(e.RowIndex).Cells(0).Value.ToString
            Dim colValue As String = dgFieldDefinitions.Rows(e.RowIndex).Cells(1).EditedFormattedValue.ToString

            Me.mMessage.ReplacementValues(colName) = colValue
        End If

    End Sub

    Private Sub cmdSend_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles cmdSend.Click

        If Not Me.mMessage Is Nothing Then
            If Not Me.mMessage.Send Then
                Dim dialog As ValidationDialog = New ValidationDialog(Me.mMessage.ValidationErrors)
                dialog.ShowDialog()
            Else
                MessageBox.Show("You message has been sent.")
            End If
        Else
            Dim msg As List(Of String) = New List(Of String)
            msg.Add("No message object currently exists.")
            Dim dialog As ValidationDialog = New ValidationDialog(msg)
            dialog.ShowDialog()
        End If

    End Sub

End Class
