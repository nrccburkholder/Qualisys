Imports Nrc.QualiSys.Library
Imports Nrc.QualiSys.Scanning.Library
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Columns
Imports DevExpress.XtraGrid.Views.Grid
Imports System.IO

Public Class VendorMaintenanceSection

#Region " Private Members "

    Private mVendor As Vendor

    Private WithEvents mNavControl As VendorMaintenanceNavigator

#End Region

#Region " Base Class Overrides"

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        mNavControl = DirectCast(navCtrl, VendorMaintenanceNavigator)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        'Check to see if last vendor was modified before loading next
        If mVendor IsNot Nothing Then
            Dim contactlist As VendorContactCollection = DirectCast(Me.VendorContactBindingSource.DataSource, VendorContactCollection)
            Dim dispolist As VendorDispositionCollection = DirectCast(Me.VendorDespositionBindingSource.DataSource, VendorDispositionCollection)
            If mVendor.IsDirty OrElse contactlist.IsDirty OrElse dispolist.IsDirty Then
                If MessageBox.Show(String.Concat("Vendor '", mVendor.VendorName, "' has been modified. Do you wish to save?"), mVendor.VendorName, MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
                    If mVendor.IsValid AndAlso contactlist.IsValid AndAlso dispolist.IsValid Then
                        'Everything looks good so save it
                        SaveVendor()
                        Return True
                    Else
                        'There is invalid data so tell the user to fix it.
                        MessageBox.Show("Invalid data exists.  Please correct and try again.", "Invalid Vendor", MessageBoxButtons.OK, MessageBoxIcon.Error)
                        Return False
                    End If
                Else
                    mVendor.CancelEdit()
                    contactlist.CancelEdit()
                    dispolist.CancelEdit()
                End If
            End If
        End If

        Return True

    End Function
#End Region

#Region " Navigator Events "

    Private Sub mNavControl_SelectedNodeChanging(ByVal sender As Object, ByVal e As SelectedNodeChangingEventArgs) Handles mNavControl.SelectedNodeChanging

        e.Cancel = Not AllowInactivate()

    End Sub

    Private Sub mNavControl_VendorChanged(ByVal sender As Object, ByVal e As VendorChangedEventArgs) Handles mNavControl.VendorChanged

        Me.VendorSplitContainer.Enabled = True

        mVendor = e.CurrentVendor
        mVendor.BeginEdit()
        PopulateVendorInfo()
        PopulateContactsGrid()
        PopulateDispositionsGrid()
        Me.txtVendorCode.Focus()

    End Sub
#End Region

#Region " Private Events "

#Region " Main "

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ApplyButton.Click

        Try
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor
            SaveVendor()

        Catch ex As Exception
            Throw ex
        Finally
            System.Windows.Forms.Cursor.Current = Cursors.Default
        End Try

    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Try
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor
            If mVendor.IsNew Then
                'clear and disable section for new vendor
                ClearScreen()
                mVendor = Nothing
                Me.ContactsGridControl.DataSource = Nothing
                Me.DispositionGridControl.DataSource = Nothing
                Me.VendorSplitContainer.Enabled = False
                Me.mNavControl.PopulateTree()
            Else
                'Roll back vendor information
                mVendor.CancelEdit()
                PopulateVendorInfo()
                PopulateContactsGrid()
                PopulateDispositionsGrid()
            End If

        Catch ex As Exception
            Throw ex
        Finally
            System.Windows.Forms.Cursor.Current = Cursors.Default
        End Try

    End Sub

#End Region

#Region " Contacts Tab "

    Private Sub VendorContactBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles VendorContactBindingSource.AddingNew

        'Initialize vendor value for new record
        Dim myvendorcontact As VendorContact = VendorContact.NewVendorContact
        myvendorcontact.VendorId = mVendor.VendorId
        e.NewObject = myvendorcontact

    End Sub

    Private Sub ContactsContextMenuStrip_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles ContactsContextMenuStrip.Opening

        Dim selectedRow As Integer = ContactsGridView.GetSelectedRows(0)

        If selectedRow < 0 Then
            e.Cancel = True
        End If

    End Sub

    Private Sub DeleteRecordToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles DeleteRecordToolStripMenuItem.Click

        Dim selectedRow As Integer = ContactsGridView.GetSelectedRows(0)
        Dim contact As VendorContact = DirectCast(ContactsGridView.GetRow(selectedRow), VendorContact)

        If Me.ContactsGridView.SelectedRowsCount > 0 Then
            If MessageBox.Show(String.Concat("Delete Row for contact type of '", contact.Type, "'?"), "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = DialogResult.Yes Then
                Me.ContactsGridView.DeleteSelectedRows()
            End If
        End If

    End Sub

    Private Sub ContactsGridView_ShownEditor(ByVal sender As Object, ByVal e As System.EventArgs) Handles ContactsGridView.ShownEditor

        Dim view As GridView = TryCast(sender, GridView)
        If view.IsNewItemRow(view.FocusedRowHandle) AndAlso view.FocusedColumn.FieldName <> "VendorContactId" Then
            view.ActiveEditor.IsModified = True
        End If

    End Sub

#End Region

#Region " Disposition Tab "

    Private Sub btnDispoImportFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDispoImportFile.Click

        Dim vendordispolist As VendorDispositionCollection = DirectCast(Me.VendorDespositionBindingSource.DataSource, VendorDispositionCollection)
        Dim dispolist As QualiSys.Library.DispositionCollection = DirectCast(Me.DispositionBindingSource.DataSource, QualiSys.Library.DispositionCollection)
        Dim importvendordispolist As VendorDispositionCollection = vendordispolist.Clone

        With Me.OpenFileDialog
            .InitialDirectory = "c:\"
            .Filter = "CSV files (*.csv)|*.csv|All files (*.*)|*.*"
            .FilterIndex = 1
            .RestoreDirectory = True
            .FileName = ""

            If .ShowDialog() = Windows.Forms.DialogResult.OK Then
                Dim importDialog As New VendorMaintenenceImportDialog
                importDialog.InitializeImportGrid(.FileName, mVendor.VendorId, importvendordispolist, dispolist)

                If importDialog.ShowDialog(Me) = DialogResult.OK Then
                    Me.VendorDespositionBindingSource.DataSource = importvendordispolist
                End If
            End If
        End With

    End Sub

    Private Sub btnDispoExportFile_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnDispoExportFile.Click

        Try
            With SaveFileDialog
                .Filter = "Excel files (*.xls)|*.xls|All files (*.*)|*.*"
                .FilterIndex = 1
                .FileName = ""

                If .ShowDialog() = Windows.Forms.DialogResult.OK Then
                    System.Windows.Forms.Cursor.Current = Cursors.WaitCursor
                    Dim xlsexportopt As New DevExpress.XtraPrinting.XlsExportOptions
                    With xlsexportopt
                        .TextExportMode = DevExpress.XtraPrinting.TextExportMode.Value
                        .SheetName = "Vendor Dispositions"
                    End With
                    Me.DispositionGridView.ExportToXls(.FileName, xlsexportopt)
                End If
            End With

        Catch ex As Exception
            Throw ex
        Finally
            System.Windows.Forms.Cursor.Current = Cursors.Default
        End Try

    End Sub



    Private Sub DispositionGridView_ShownEditor(ByVal sender As Object, ByVal e As System.EventArgs) Handles DispositionGridView.ShownEditor

        Dim view As GridView = TryCast(sender, GridView)
        If view.IsNewItemRow(view.FocusedRowHandle) AndAlso view.FocusedColumn.FieldName <> "VendorDispositionId" Then
            view.ActiveEditor.IsModified = True
        End If
        If view.IsNewItemRow(view.FocusedRowHandle) AndAlso view.FocusedColumn.FieldName = "VendorDispositionCode" Then
            view.ActiveEditor.Properties.ReadOnly = False
        End If

    End Sub

    Private Sub VendorDespositionBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles VendorDespositionBindingSource.AddingNew

        'Initialize vendor value for new record
        Dim myvendordispo As VendorDisposition = VendorDisposition.NewVendorDisposition
        myvendordispo.VendorId = mVendor.VendorId
        myvendordispo.DateCreated = Now
        e.NewObject = myvendordispo

    End Sub

    Private Sub NRCDispoLookUpEdit_Closed(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ClosedEventArgs) Handles NRCDispoLookUpEdit.Closed

        'Using send keys to get a quick refresh of the HCAPS Dispo column
        SendKeys.Send("{TAB}")
        SendKeys.Send("+{TAB}")

    End Sub

#End Region

#End Region

#Region " Private Methods "

    Private Sub ClearScreen()

        'Clear the screen and all bindings
        With txtVendorCode
            .DataBindings.Clear()
            .Text = ""
        End With
        With txtVendorName
            .DataBindings.Clear()
            .Text = ""
        End With
        With txtLocalFTPLoginName
            .DataBindings.Clear()
            .Text = ""
        End With
        With cboOutgoingFileType
            .DataBindings.Clear()
            .SelectedIndex = -1
        End With
        With txtNoResponseChar
            .DataBindings.Clear()
            .Text = ""
        End With
        With txtSkipResponseChar
            .DataBindings.Clear()
            .Text = ""
        End With
        With txtDontKnowResponseChar
            .DataBindings.Clear()
            .Text = ""
        End With
        With txtRefusedResponseChar
            .DataBindings.Clear()
            .Text = ""
        End With
        With txtMultiRespItemNotPickedChar
            .DataBindings.Clear()
            .Text = ""
        End With
        With chkAutoLoad
            .DataBindings.Clear()
            .Checked = False
        End With
        VendorErrorProvider.DataSource = Nothing
        VendorErrorProvider.Clear()

    End Sub

    Private Sub PopulateVendorInfo()

        'Clear the screen and all bindings
        ClearScreen()

        'Populate the vendor information section
        txtVendorCode.DataBindings.Add("Text", mVendor, "VendorCode", False, DataSourceUpdateMode.OnPropertyChanged)
        txtVendorName.DataBindings.Add("Text", mVendor, "VendorName", False, DataSourceUpdateMode.OnPropertyChanged)
        txtLocalFTPLoginName.DataBindings.Add("Text", mVendor, "LocalFTPLoginName", False, DataSourceUpdateMode.OnPropertyChanged)
        cboOutgoingFileType.DataBindings.Add("SelectedValue", mVendor, "VendorFileOutgoTypeId", False, DataSourceUpdateMode.OnPropertyChanged)
        txtNoResponseChar.DataBindings.Add("Text", mVendor, "NoResponseChar", False, DataSourceUpdateMode.OnPropertyChanged)
        txtSkipResponseChar.DataBindings.Add("Text", mVendor, "SkipResponseChar", False, DataSourceUpdateMode.OnPropertyChanged)
        txtDontKnowResponseChar.DataBindings.Add("Text", mVendor, "DontKnowResponseChar", False, DataSourceUpdateMode.OnPropertyChanged)
        txtRefusedResponseChar.DataBindings.Add("Text", mVendor, "RefusedResponseChar", False, DataSourceUpdateMode.OnPropertyChanged)
        txtMultiRespItemNotPickedChar.DataBindings.Add("Text", mVendor, "MultiRespItemNotPickedChar", False, DataSourceUpdateMode.OnPropertyChanged)
        chkAutoLoad.DataBindings.Add("Checked", mVendor, "AcceptFilesFromVendor", False, DataSourceUpdateMode.OnPropertyChanged)

        VendorErrorProvider.DataSource = mVendor

    End Sub

    Private Sub PopulateContactsGrid()

        'Populate the vendor contact grid
        Dim contactlist As VendorContactCollection = VendorContact.GetAllByVendor(mVendor.VendorId)
        contactlist.AllowNew = True
        Me.VendorContactBindingSource.DataSource = contactlist

    End Sub

    Private Sub PopulateDispositionsGrid()

        'Populate the vendor disposition grid
        Dim dispolist As VendorDispositionCollection = VendorDisposition.GetByVendorId(mVendor.VendorId)
        dispolist.AllowNew = True
        Me.VendorDespositionBindingSource.DataSource = dispolist

    End Sub

    Private Sub PopulateDispositions()

        'Populate the vendor disposition binding source
        Dim dispolist As QualiSys.Library.DispositionCollection = QualiSys.Library.Disposition.GetAll
        Me.DispositionBindingSource.DataSource = dispolist

    End Sub

    Private Sub PopulateOutgoingFileTypes()

        'Populate the Outgoing File Type combobox
        With Me.cboOutgoingFileType
            .DataSource = VendorFileOutgoType.GetAll
            .DisplayMember = "DisplayName"
            .ValueMember = "VendorFileOutgoTypeId"
        End With

    End Sub

    Private Sub SaveVendor()

        'Commit any uncommitted contact changes
        If Me.ContactsGridView.IsEditing Then
            If Me.ContactsGridView.ValidateEditor Then
                Me.ContactsGridView.CloseEditor()
            End If
        End If

        'Commit any uncommitted disposition changes
        If Me.DispositionGridView.IsEditing Then
            If Me.DispositionGridView.ValidateEditor Then
                Me.DispositionGridView.CloseEditor()
            End If
        End If

        'Update vendor contacts and dispositions
        Dim contactlist As VendorContactCollection = DirectCast(Me.VendorContactBindingSource.DataSource, VendorContactCollection)
        Dim dispolist As VendorDispositionCollection = DirectCast(Me.VendorDespositionBindingSource.DataSource, VendorDispositionCollection)

        If mVendor.IsNew Then
            If Not mVendor.IsValid Then
                MessageBox.Show("You cannot save until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
                Exit Sub
            Else
                mVendor.ApplyEdit()
                mVendor.Save()
                For Each contact As VendorContact In contactlist
                    contact.VendorId = mVendor.VendorId
                Next
                For Each dispo As VendorDisposition In dispolist
                    dispo.VendorId = mVendor.VendorId
                Next
            End If
        End If

        'Validate vendor objects
        If Not mVendor.IsValid OrElse Not contactlist.IsValid OrElse Not dispolist.IsValid Then
            MessageBox.Show("You cannot save until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            'Save vendor information
            If mVendor.IsDirty Then
                mVendor.DateModified = Now
                mVendor.ApplyEdit()
                mVendor.Save()
            End If

            'Save vendor contacts and dispositions
            If contactlist.IsDirty Then contactlist.Save()
            If dispolist.IsDirty Then dispolist.Save()

            'Refresh vendor tree
            mNavControl.PopulateTree()
        End If

    End Sub
#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        PopulateDispositions()
        PopulateOutgoingFileTypes()

    End Sub

#End Region

End Class
