Imports System.IO
Imports Nrc.LaunchPad.Library
Imports System.Drawing.Imaging
Public Class ApplicationManagerForm

#Region " Private Members "
    Dim mApplicationList As ApplicationCollection
    Dim mDeleteList As New ApplicationCollection
    Dim mApplicationProvider As ApplicationProvider
#End Region

#Region " Constructors "
    Sub New(ByVal provider As ApplicationProvider)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.

        'Set the provider for this instance of the form
        mApplicationProvider = provider

        'Get the list of deployment types
        Me.PopulateDelpoymentTypeList()

        'Get the list of applications and bind to the grid view
        mApplicationList = mApplicationProvider.GetAllApplications
        Me.ApplicationBindingSource.DataSource = mApplicationList


        'Set rendering colors
        If Windows.Forms.Application.RenderWithVisualStyles Then
            Me.BackColor = ProfessionalColors.MenuStripGradientBegin
            Me.TitleBar.BackColorLeft = ProfessionalColors.MenuStripGradientBegin
            Me.TitleBar.BackColorRight = ProfessionalColors.MenuStripGradientEnd

            Me.ApplicationDataGrid.ColumnHeadersDefaultCellStyle.BackColor = SystemColors.Highlight
            Me.ApplicationDataGrid.ColumnHeadersDefaultCellStyle.ForeColor = SystemColors.HighlightText
            Me.ApplicationDataGrid.RowHeadersDefaultCellStyle.BackColor = SystemColors.Highlight
            Me.ApplicationDataGrid.RowHeadersDefaultCellStyle.ForeColor = SystemColors.HighlightText
        Else
            Me.BackColor = Color.FromArgb(158, 190, 245)
            Me.TitleBar.BackColorLeft = Color.FromArgb(158, 190, 245)
            Me.TitleBar.BackColorRight = Color.FromArgb(196, 218, 250)
        End If

    End Sub
#End Region

#Region " Control Event Handlers "
    Private Sub ChangeImageMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChangeImageMenuItem.Click
        Me.ChangeImage()
    End Sub

    Private Sub RemoveImageToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RemoveImageToolStripMenuItem.Click
        Me.RemoveImage()
    End Sub


    Private Sub ExportImageToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ExportImageToolStripMenuItem.Click
        Me.ExportImage()
    End Sub

    Private Sub BrowseToolStripMenuItem_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles BrowseToolStripMenuItem.Click
        Me.BrowseForPath()
    End Sub

    Private Sub SaveButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SaveButton.Click
        Me.SaveApplications()

        'Close the form
        Me.DialogResult = Windows.Forms.DialogResult.OK
    End Sub

    Private Sub ImageMenu_Opening(ByVal sender As Object, ByVal e As System.ComponentModel.CancelEventArgs) Handles ImageMenu.Opening
        'When the Image Menu appears select the cell that the user is clicking on

        Dim pt As Point = Me.ApplicationDataGrid.PointToClient(System.Windows.Forms.Cursor.Position)
        Dim hitInfo As DataGridView.HitTestInfo = Me.ApplicationDataGrid.HitTest(pt.X, pt.Y)
        If hitInfo.RowIndex >= 0 AndAlso hitInfo.ColumnIndex >= 0 Then
            Dim row As DataGridViewRow = Me.ApplicationDataGrid.Rows(hitInfo.RowIndex)
            Dim cell As DataGridViewCell = row.Cells(hitInfo.ColumnIndex)
            cell.Selected = True
        End If
    End Sub

    Private Sub TitleBar_CloseButtonClicked(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TitleBar.CloseButtonClicked
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub AbortButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AbortButton.Click
        Me.DialogResult = Windows.Forms.DialogResult.Cancel
    End Sub

    Private Sub ApplicationDataGrid_DataError(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewDataErrorEventArgs) Handles ApplicationDataGrid.DataError
        MessageBox.Show(e.Exception.ToString, "Application Data Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
    End Sub

    Private Sub ApplicationDataGrid_EditingControlShowing(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewEditingControlShowingEventArgs) Handles ApplicationDataGrid.EditingControlShowing
        Dim txt As TextBox = TryCast(e.Control, TextBox)
        If txt IsNot Nothing Then
            If ApplicationDataGrid.CurrentCell.ColumnIndex = Me.PathColumn.Index Then
                txt.AutoCompleteMode = AutoCompleteMode.SuggestAppend
                txt.AutoCompleteSource = AutoCompleteSource.AllSystemSources
            Else
                txt.AutoCompleteMode = AutoCompleteMode.None
            End If
        End If
    End Sub

    Private Sub ApplicationDataGrid_UserDeletingRow(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewRowCancelEventArgs) Handles ApplicationDataGrid.UserDeletingRow
        Me.mDeleteList.Add(DirectCast(e.Row.DataBoundItem, Application))
    End Sub

    Private Sub ApplicationBindingSource_AddingNew(ByVal sender As Object, ByVal e As System.ComponentModel.AddingNewEventArgs) Handles ApplicationBindingSource.AddingNew
        'Create the default new instance when adding a new item to the grid
        Dim app As New Application
        app.DeploymentType = DeploymentType.LocalInstall
        e.NewObject = app
    End Sub
#End Region

#Region " Form Overrides "
    Protected Overrides Sub OnPaintBackground(ByVal e As System.Windows.Forms.PaintEventArgs)
        MyBase.OnPaintBackground(e)

        'Draw a form border
        Dim rect As New Rectangle(0, 0, Me.Width - 1, Me.Height - 1)
        e.Graphics.DrawRectangle(Pens.DimGray, rect)
    End Sub

#End Region

#Region " Private Methods "
    Private Sub PopulateDelpoymentTypeList()
        'Fill the column item list with the enum values
        Me.DeploymentTypeColumn.Items.Clear()

        'Get the list of enum value names and sort it
        Dim enumType As Type = GetType(DeploymentType)
        Dim enumNames As String() = (System.Enum.GetNames(enumType))
        Array.Sort(Of String)(enumNames)

        'Add each enum value to the column items list
        For Each name As String In enumNames
            Me.DeploymentTypeColumn.Items.Add(System.Enum.Parse(enumType, name))
        Next

        'Remove out the "NONE" value so it cannot be selected
        Me.DeploymentTypeColumn.Items.Remove(DeploymentType.None)
    End Sub

    Private Sub ChangeImage()
        'Show the file open dialog
        If Me.OpenDialog.ShowDialog(Me) = Windows.Forms.DialogResult.OK Then
            Dim img As Image
            'Get a stream to the file
            Using strm As Stream = Me.OpenDialog.OpenFile
                'If the file is a .ICO then convert icon to bitmap
                'If the file is a .EXE then extract icon from executable
                'If the file is anything else then assume it is an image format and load the image
                If Me.OpenDialog.FileName.EndsWith(".ico", StringComparison.CurrentCultureIgnoreCase) Then
                    Dim ico As New Icon(strm)
                    img = ico.ToBitmap
                ElseIf Me.OpenDialog.FileName.EndsWith(".exe", StringComparison.CurrentCultureIgnoreCase) Then
                    img = Drawing.Icon.ExtractAssociatedIcon(OpenDialog.FileName).ToBitmap
                Else
                    img = Image.FromStream(strm)
                End If

                'Resize the image if needed
                If img.Width > 32 OrElse img.Height > 32 Then
                    Dim bmp As New Bitmap(img, 32, 32)
                    img = bmp
                End If

                'Now load the image into the current cell
                Me.ApplicationDataGrid.CurrentRow.Cells("ImageColumn").Value = img
            End Using
        End If
    End Sub

    Private Sub ExportImage()
        Me.SaveImageDialog.FileName = Me.ApplicationDataGrid.CurrentRow.Cells("NameColumn").Value.ToString
        If Me.SaveImageDialog.ShowDialog = Windows.Forms.DialogResult.OK Then
            'Write the image out to a file
            Dim img As Image = CType(Me.ApplicationDataGrid.CurrentRow.Cells("ImageColumn").Value, Image)
            Dim format As ImageFormat
            Select Case System.IO.Path.GetExtension(Me.SaveImageDialog.FileName).ToUpper
                Case ".BMP"
                    format = ImageFormat.Bmp
                Case ".EMF"
                    format = ImageFormat.Emf
                Case ".GIF"
                    format = ImageFormat.Gif
                Case ".ICO"
                    format = ImageFormat.Icon
                Case ".JPG"
                    format = ImageFormat.Jpeg
                Case ".PNG"
                    format = ImageFormat.Png
                Case ".TIF"
                    format = ImageFormat.Tiff
                Case ".WMF"
                    format = ImageFormat.Wmf
                Case Else
                    Throw New ArgumentException("Unknown image type")
            End Select
            img.Save(Me.SaveImageDialog.FileName, format)
        End If
    End Sub

    Private Sub RemoveImage()
        'Clear the image out of the current cell
        Me.ApplicationDataGrid.CurrentRow.Cells("ImageColumn").Value = Nothing
    End Sub

    Private Sub BrowseForPath()
        'Show the file open dialog
        If Me.BrowseForPathDialog.ShowDialog(Me) = Windows.Forms.DialogResult.OK Then
            Me.ApplicationDataGrid.CurrentRow.Cells("PathColumn").Value = Me.BrowseForPathDialog.FileName
        End If
    End Sub

    Private Sub SaveApplications()
        'For every application in the grid view
        'If it is new then tell the provider to add it
        'If it has changed then tell the provider to update it
        For Each app As Application In Me.mApplicationList
            If app.IsNew Then
                Me.mApplicationProvider.AddApplication(app)
            ElseIf app.IsDirty Then
                Me.mApplicationProvider.UpdateApplication(app)
            End If
        Next

        'For every application in the deleted list:
        'If it is not new (it was previously in the data store) then tell the provider to delete it
        For Each app As Application In Me.mDeleteList
            If Not app.IsNew Then
                Me.mApplicationProvider.DeleteApplication(app)
            End If
        Next
    End Sub

#End Region


End Class