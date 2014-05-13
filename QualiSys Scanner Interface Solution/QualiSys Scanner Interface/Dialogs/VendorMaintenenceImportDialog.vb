Imports Nrc.QualiSys.Scanning.Library
Imports DevExpress.XtraGrid.Views.Base
Imports DevExpress.XtraGrid.Columns
Imports DevExpress.XtraGrid.Views.Grid
Imports System.IO

Public Class VendorMaintenenceImportDialog

    Private mVendorID As Integer

#Region " Public Methods "

    Public Sub InitializeImportGrid(ByVal strfilename As String, ByVal intvendorID As Integer, ByVal vendordispolist As VendorDispositionCollection, ByVal dispolist As QualiSys.Library.DispositionCollection)

        Dim swfile As StreamReader = Nothing
        Dim strline As String
        Dim strlinearray() As String

        Try
            System.Windows.Forms.Cursor.Current = Cursors.WaitCursor
            Me.DispositionBindingSource.DataSource = dispolist
            mVendorID = intvendorID

            swfile = New StreamReader(strfilename)
            strline = swfile.ReadLine
            While Not strline Is Nothing
                strlinearray = strline.Split(",".ToCharArray)
                Dim vendordispo As VendorDisposition = VendorDisposition.NewVendorDisposition
                vendordispolist.Add(vendordispo)
                With vendordispo
                    .VendorId = intvendorID
                    .VendorDispositionCode = strlinearray(0).ToString
                    .VendorDispositionLabel = strlinearray(1).ToString
                    .VendorDispositionDesc = strlinearray(2).ToString
                    .DateCreated = Now
                End With
                strline = swfile.ReadLine
            End While

            'Populate the vendor disposition binding source
            Me.VendorDispoBindingSource.DataSource = vendordispolist

        Catch ex As Exception
            Throw ex
        Finally
            If Not swfile Is Nothing Then
                swfile.Close()
                swfile.Dispose()
            End If
            System.Windows.Forms.Cursor.Current = Cursors.Default
        End Try

    End Sub

#End Region

#Region " Events "

#Region " Main "

    Private Sub ApplyButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SubmitButton.Click

        Dim dispolist As VendorDispositionCollection = DirectCast(Me.VendorDispoBindingSource.DataSource, VendorDispositionCollection)

        If Not dispolist.IsValid Then
            MessageBox.Show("You cannot submit until all errors are corrected.", "Save Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
        Else
            Me.DialogResult = Windows.Forms.DialogResult.OK
            Me.Close()
        End If

    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        Me.DialogResult = Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub

#End Region

#Region " Grid "

    Private Sub DispositionGridView_ShownEditor(ByVal sender As Object, ByVal e As System.EventArgs) Handles DispositionGridView.ShownEditor

        Dim view As GridView = TryCast(sender, GridView)
        Dim vendordispo As VendorDisposition = CType(DispositionGridView.GetRow(DispositionGridView.FocusedRowHandle), VendorDisposition)

        If view.IsNewItemRow(view.FocusedRowHandle) AndAlso view.FocusedColumn.FieldName <> "VendorDispositionId" Then
            view.ActiveEditor.IsModified = True
        End If
        If (view.IsNewItemRow(view.FocusedRowHandle) OrElse vendordispo.IsNew) AndAlso view.FocusedColumn.FieldName = "VendorDispositionCode" Then
            view.ActiveEditor.Properties.ReadOnly = False
        End If

    End Sub

    Private Sub VendorDespositionBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles VendorDispoBindingSource.AddingNew

        'Initialize vendor value for new record
        Dim myvendordispo As VendorDisposition = VendorDisposition.NewVendorDisposition
        myvendordispo.VendorId = mVendorID
        myvendordispo.DateCreated = Now
        e.NewObject = myvendordispo

    End Sub

    Private Sub NRCDispoLookUpEdit_Closed(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.Controls.ClosedEventArgs) Handles NRCDispoLookUpEdit.Closed

        'Using send keys to get a quick refresh of the HCAPS Dispo column
        SendKeys.Send("{TAB}")
        SendKeys.Send("+{TAB}")

    End Sub

    Private Sub DispositionGridControl_DataNavigator_ButtonClick(ByVal sender As Object, ByVal e As DevExpress.XtraEditors.NavigatorButtonClickEventArgs)

        If e.Button.ButtonType = DevExpress.XtraEditors.NavigatorButtonType.Remove Then
            Dim vendordispo As VendorDisposition = CType(DispositionGridView.GetRow(DispositionGridView.FocusedRowHandle), VendorDisposition)
            If vendordispo.IsNew Then
                If MessageBox.Show("Do you want to delete the current row?", "Confirm deletion", MessageBoxButtons.YesNo, MessageBoxIcon.Question) <> Windows.Forms.DialogResult.Yes Then
                    e.Handled = True
                End If
            End If
        End If

    End Sub

#End Region

#Region " Context Menu "

    Private Sub DispositionContextMenuStrip_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles DispositionContextMenuStrip.Click

        Dim selectedRow As Integer = DispositionGridView.GetSelectedRows(0)
        Dim dispo As VendorDisposition = DirectCast(DispositionGridView.GetRow(selectedRow), VendorDisposition)

        If Me.DispositionGridView.SelectedRowsCount > 0 Then
            If MessageBox.Show(String.Concat("Delete Row for vendor disposition '", dispo.VendorDispositionCode, "'?"), "Confirmation", MessageBoxButtons.YesNo, MessageBoxIcon.Question) = Windows.Forms.DialogResult.Yes Then
                Me.DispositionGridView.DeleteSelectedRows()
            End If
        End If

    End Sub

    Private Sub DispositionContextMenuStrip_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles DispositionContextMenuStrip.Opening

        Dim selectedRow As Integer = DispositionGridView.GetSelectedRows(0)
        Dim dispo As VendorDisposition = DirectCast(DispositionGridView.GetRow(selectedRow), VendorDisposition)

        If selectedRow < 0 OrElse Not dispo.IsNew Then
            e.Cancel = True
        End If

    End Sub

#End Region
#End Region

#Region " Constructors "

    Public Sub New()

        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        AddHandler DispositionGridControl.EmbeddedNavigator.ButtonClick, AddressOf DispositionGridControl_DataNavigator_ButtonClick

    End Sub
#End Region

End Class
