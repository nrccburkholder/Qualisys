Imports Nrc.QualiSys.Scanning.Library
Imports System.IO

Public Class ImportSection

#Region " Private Members "

    Private mImportNavigator As ImportNavigator

    Private mImportActive As Boolean = False
    Private mBadImageMode As Boolean = False
    Private mCreateDLVMode As Boolean = False
    Private mCanceling As Boolean = False

    Private mGoodCount As Integer
    Private mErrorCount As Integer
    Private mBadImageCount As Integer
    Private mZoomScale As Double

    Private mBadImages As ImageCollection

    Private WithEvents mImages As ImageCollection

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        'Call into the base class
        MyBase.RegisterNavControl(navCtrl)

        'Save a reference to the navigator
        mImportNavigator = TryCast(navCtrl, ImportNavigator)

    End Sub

    Public Overrides Sub ActivateSection()

        'Call into the base class
        MyBase.ActivateSection()

        'Initialize the screen
        ImageFolderTSTextBox.Text = ""
        ImageCountTSTextBox.Text = "0"
        OutputTypeCreateDLVRadioButton.Checked = True
        ImageCountCurrentLabel.Text = "0"
        ImageCountTotalLabel.Text = "0"
        ImageCountGoodLabel.Text = "0"
        ImageCountErrorLabel.Text = "0"
        ImportProgressBar.Value = 0
        OutputTypeGroupBox.Enabled = False
        ImportButton.Enabled = False
        ImportStatusPanel.Enabled = False
        BarcodeEntrySectionPanel.Enabled = False

        'Add a handler for the navigator's events
        AddHandler mImportNavigator.FolderChanged, AddressOf mImportNavigator_FolderChanged

        'Add key press event handlers to all controls
        AddKeyEventHandler(Me)

    End Sub

    Public Overrides Sub InactivateSection()

        'Call into the base class
        MyBase.InactivateSection()

        'Remove the handler for the navigator's events
        RemoveHandler mImportNavigator.FolderChanged, AddressOf mImportNavigator_FolderChanged

        'Remove key press event handlers to all controls
        RemoveKeyEventHandler(Me)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        If mImportActive Then
            Return False
        Else
            Return True
        End If

    End Function

#End Region

#Region " Event Handlers "

#Region " Event Handlers - Main "

    Private Sub ImportButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ImportButton.Click

        If ImportButton.Text = "Import Images" Then
            'Start the import
            mCanceling = False
            mImportActive = True
            Me.Cursor = Cursors.WaitCursor

            'Setup the screen
            With ImportButton
                .Text = "Cancel Import"
                .Enabled = True
            End With
            mImportNavigator.Enabled = False
            OutputTypeGroupBox.Enabled = False
            ImportStatusPanel.Enabled = True
            ImageCountTotalLabel.Text = ImageCountTSTextBox.Text
            ImageCountGoodLabel.Text = "0"
            ImageCountErrorLabel.Text = "0"
            With ImportProgressBar
                .Value = 0
                .Maximum = CInt(ImageCountTSTextBox.Text)
            End With
            ImageCountLabel.Text = "Currently Processing Image:"

            'Import the images
            mGoodCount = 0
            mErrorCount = 0
            Dim imageFolder As DirectoryInfo = New DirectoryInfo(ImageFolderTSTextBox.Text)
            mImages = New ImageCollection
            mImages.Populate(imageFolder.GetFiles("*.tif"))

            If mCanceling Then
                'The user has chosen to cancel the import
                TerminateImport()

            Else
                'If there are surveys that could not be read then let's cycle through them
                If mErrorCount > 0 Then
                    StartBadImageMode()
                Else
                    EndImport()
                End If

            End If

        Else
            'The user wants to cancel the current import
            mCanceling = True
            With ImportButton
                .Text = "Canceling Import"
                .Enabled = False
            End With

            'If we are in bad image mode then just end things
            If mBadImageMode Then
                NextTSButton.Text = "Next"
                mBadImageMode = False
                SurveyPictureBox.Image = Nothing
                TerminateImport()
            End If
        End If

    End Sub

#End Region

#Region " Event Handlers - BarcodeEntryToolStrip "

    Private Sub NextTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NextTSButton.Click

        Dim errorMsg As String = ""

        'Validate barcode
        Dim newBarcode As String = BarcodeTSTextBox.Text.Trim
        If Not Image.ValidateBarcode(newBarcode, errorMsg) Then
            'Tell the user that the barcode is bad
            MessageBox.Show(errorMsg, "Bad Barcode Entry", MessageBoxButtons.OK, MessageBoxIcon.Error)

            'Head out of dodge
            With BarcodeTSTextBox
                .Focus()
                .SelectAll()
            End With
            Exit Sub
        End If

        'Update status counts
        ImageCountGoodLabel.Text = (CInt(ImageCountGoodLabel.Text) + 1).ToString
        ImageCountErrorLabel.Text = (CInt(ImageCountErrorLabel.Text) - 1).ToString

        'Save barcode
        mBadImages(mBadImageCount).Barcode = newBarcode

        'Load next image
        mBadImageCount += 1
        LoadBadImage()

    End Sub

    Private Sub SkipTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SkipTSButton.Click

        'Make sure the user wants to skip this image
        If MessageBox.Show("Are you sure you want to skip this image?", "Skip Barcode Entry", MessageBoxButtons.OKCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.OK Then
            'Update status counts
            mBadImageCount += 1

            'Load the next image
            LoadBadImage()
        End If

    End Sub

    Private Sub ZoomInTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ZoomInTSButton.Click

        ZoomIn()

    End Sub

    Private Sub ZoomOutTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ZoomOutTSButton.Click

        ZoomOut()

    End Sub

    Private Sub RotateClockwiseTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RotateClockwiseTSButton.Click

        RotateClockwise()

    End Sub

    Private Sub RotateCounterClockwiseTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RotateCounterClockwiseTSButton.Click

        RotateCounterClockwise()

    End Sub

#End Region

#Region " Event Handlers - Navigator "

    Private Sub mImportNavigator_FolderChanged(ByVal sender As Object, ByVal e As FolderChangedEventArgs)

        Dim imageCount As Integer

        'Clear the contents of the screen
        ImageFolderTSTextBox.Text = ""
        ImageCountTSTextBox.Text = "0"
        ImageCountCurrentLabel.Text = "0"
        ImageCountTotalLabel.Text = "0"
        ImageCountGoodLabel.Text = "0"
        ImageCountErrorLabel.Text = "0"
        OutputTypeGroupBox.Enabled = False
        ImportButton.Enabled = False

        Application.DoEvents()
        Me.Cursor = Cursors.WaitCursor

        'If we clicked on a file system component then populate screen
        If e.FolderItem.IsFileSystem Then
            'Check to see if we can access the drive
            Try
                ImageFolderTSTextBox.Text = e.FolderPath
                ''TODO: Change back to TIF instead of JPG
                imageCount = e.FolderItem.GetFiles("*.tif").Count
                'imageCount = e.FolderItem.GetFiles("*.jpg").Count
                ImageCountTSTextBox.Text = imageCount.ToString
                If imageCount > 0 Then
                    OutputTypeGroupBox.Enabled = True
                    ImportButton.Enabled = True
                    OutputTypeCreateDLVRadioButton.Checked = True
                    OutputTypeCreateDLVRadioButton.Focus()
                End If

            Catch ex As Exception
                'do nothing

            End Try
        End If
        Me.Cursor = Cursors.Default

    End Sub

#End Region

#Region " Event Handlers - Images Collection "

    Private Sub mImages_CreateDLVBegin(ByVal sender As Object, ByVal e As System.EventArgs) Handles mImages.CreateDLVBegin

        'Setup the screen
        ImageGoodLabel.Visible = False
        ImageCountGoodLabel.Visible = False
        ImageErrorLabel.Visible = False
        ImageCountErrorLabel.Visible = False
        ImageCountCurrentLabel.Text = "0"
        ImportProgressBar.Value = 0
        ImageCountLabel.Text = "Writing DLV Image:"

    End Sub

    Private Sub mImages_CreateDLVComplete(ByVal sender As Object, ByVal e As System.EventArgs) Handles mImages.CreateDLVComplete

        'Setup the screen
        ImageGoodLabel.Visible = True
        ImageCountGoodLabel.Visible = True
        ImageErrorLabel.Visible = True
        ImageCountErrorLabel.Visible = True

    End Sub

    Private Sub mImages_CreateDLVUpdate(ByVal sender As Object, ByVal e As QualiSys.Scanning.Library.CreateDLVUpdateEventArgs) Handles mImages.CreateDLVUpdate

        ImageCountCurrentLabel.Text = e.CurrentImage.ToString
        ImportProgressBar.Value = e.CurrentImage
        Application.DoEvents()
        Me.Cursor = Cursors.WaitCursor

    End Sub

    Private Sub mImages_ProcessImageBegin(ByVal sender As Object, ByVal e As QualiSys.Scanning.Library.ProcessImageBeginEventArgs) Handles mImages.ProcessImageBegin

        ImageCountCurrentLabel.Text = e.CurrentImage.ToString
        ImportProgressBar.Value = e.CurrentImage
        Application.DoEvents()
        Me.Cursor = Cursors.WaitCursor
        e.Cancel = mCanceling

    End Sub

    Private Sub mImages_ProcessImageComplete(ByVal sender As Object, ByVal e As QualiSys.Scanning.Library.ProcessImageCompleteEventArgs) Handles mImages.ProcessImageComplete

        If e.NewImage.IsBarcodeValid Then
            mGoodCount += 1
            ImageCountGoodLabel.Text = mGoodCount.ToString
        Else
            mErrorCount += 1
            ImageCountErrorLabel.Text = mErrorCount.ToString
        End If
        Application.DoEvents()
        Me.Cursor = Cursors.WaitCursor
        e.Cancel = mCanceling

    End Sub

#End Region

#Region " Event Handlers - KeyDown "

    'Adds an event handler for the KeyDown event for all children of a control
    Private Sub AddKeyEventHandler(ByVal ctrl As Control)

        Dim child As Control

        'Add the handler for the passed in control
        AddHandler ctrl.KeyDown, New KeyEventHandler(AddressOf KeyDownHandler)

        'Add the handler for all children controls of the one passed in
        For Each child In ctrl.Controls
            AddKeyEventHandler(child)
        Next

    End Sub


    'Removes the event handler for the KeyDown event for all children of a control
    Private Sub RemoveKeyEventHandler(ByVal ctrl As Control)

        Dim child As Control

        'Remove the handler for the passed in control
        RemoveHandler ctrl.KeyDown, New KeyEventHandler(AddressOf KeyDownHandler)

        'Remove the handler for all children controls of the one passed in
        For Each child In ctrl.Controls
            RemoveKeyEventHandler(child)
        Next

    End Sub


    'KEY DOWN for all controls
    Private Sub KeyDownHandler(ByVal sender As Object, ByVal e As KeyEventArgs)

        If e.KeyData = My.Settings.ImportNextKey AndAlso mBadImageMode Then
            Me.NextTSButton.PerformClick()
            e.Handled = True
        ElseIf e.KeyData = My.Settings.ImportSkipKey AndAlso mBadImageMode Then
            Me.SkipTSButton.PerformClick()
            e.Handled = True
        ElseIf e.KeyData = My.Settings.ImportZoomInKey AndAlso mBadImageMode Then
            ZoomIn()
            e.Handled = True
        ElseIf e.KeyData = My.Settings.ImportZoomOutKey AndAlso mBadImageMode Then
            ZoomOut()
            e.Handled = True
        ElseIf e.KeyData = My.Settings.ImportRotateClockwiseKey AndAlso mBadImageMode Then
            RotateClockwise()
            e.Handled = True
        ElseIf e.KeyData = My.Settings.ImportRotateCounterClockwiseKey AndAlso mBadImageMode Then
            RotateCounterClockwise()
            e.Handled = True
        End If

    End Sub

#End Region

#End Region

#Region " Private Methods "

    Private Sub StartBadImageMode()

        'Set the bad image mode flag
        mBadImageMode = True
        Me.Cursor = Cursors.Default

        'Get the bad images
        mBadImages = mImages.BadImages

        'Load the first bad image
        BarcodeEntrySectionPanel.Enabled = True
        mBadImageCount = 0
        LoadBadImage()

    End Sub

    Private Sub LoadBadImage()

        'Check for special conditions
        If mBadImageCount >= mBadImages.Count Then
            'There are no more bad images so let's wrap things up
            NextTSButton.Text = "Next"
            mBadImageMode = False
            SurveyPictureBox.Image = Nothing
            EndImport()
            Exit Sub
        ElseIf mBadImageCount = mBadImages.Count - 1 Then
            'This is the last bad image
            NextTSButton.Text = "Finish"
        End If

        'Load the image
        With BarcodeTSTextBox
            .Text = ""
            .Focus()
        End With
        BarcodeEntrySectionPanel.Caption = "Barcode Entry - " & (mBadImageCount + 1).ToString & " of " & mErrorCount.ToString
        With SurveyPictureBox
            .SizeMode = PictureBoxSizeMode.AutoSize
            .Image = System.Drawing.Image.FromFile(mBadImages(mBadImageCount).ImageFile.FullName)
            .Tag = .Size
            mZoomScale = 0.9
            .SizeMode = PictureBoxSizeMode.StretchImage
            ZoomIn()
        End With

    End Sub

    Private Sub EndImport()

        'Disable the cancel button
        ImportButton.Enabled = False

        'Save the results
        If OutputTypeCreateDLVRadioButton.Checked Then
            'We are sending the results to a DLV file
            CreateDLVFile()

        ElseIf OutputTypeBarcodesRadioButton.Checked Then
            'We are providing a list of barcodes
            Dim listOutputDialog As New ImportListOutputDialog
            listOutputDialog.InitDialog(mImages, ImportListOutputDialog.OutputTypes.Barcodes)
            If listOutputDialog.ShowDialog(Me) = DialogResult.Yes Then
                'The user chose to output to a DLV
                CreateDLVFile()
            End If

        Else
            'We are providing a list of LithoCodes
            Dim listOutputDialog As New ImportListOutputDialog
            listOutputDialog.InitDialog(mImages, ImportListOutputDialog.OutputTypes.LithoCodes)
            If listOutputDialog.ShowDialog(Me) = DialogResult.Yes Then
                'The user chose to output to a DLV
                CreateDLVFile()
            End If

        End If

        'Finish things up
        TerminateImport()

    End Sub

    Private Sub TerminateImport()

        'Reset the screen
        With ImportButton
            .Text = "Import Images"
            .Enabled = False
        End With
        mCanceling = False

        ImportStatusPanel.Enabled = False
        BarcodeEntrySectionPanel.Enabled = False
        mImportNavigator.Enabled = True
        BarcodeTSTextBox.Text = ""
        SurveyPictureBox.Size = New Size(10, 10)
        ImportProgressBar.Value = 0
        mGoodCount = 0
        mErrorCount = 0
        BarcodeEntrySectionPanel.Caption = "Barcode Entry"
        ImageCountLabel.Text = "Currently Processing Image:"
        ImageCountTotalLabel.Text = "0"
        ImageCountCurrentLabel.Text = "0"
        ImageCountGoodLabel.Text = "0"
        ImageCountErrorLabel.Text = "0"

        Me.Cursor = Cursors.Default
        mImportActive = False

    End Sub

    Private Sub CreateDLVFile()

        'Set the hourglass
        mCreateDLVMode = True
        Me.Cursor = Cursors.WaitCursor

        Try
            mImages.CreateDLVFile()

            MessageBox.Show("DLV File Successfully Created!", "DLV File Creation", MessageBoxButtons.OK, MessageBoxIcon.Information)

        Catch ex As Exception
            Globals.ReportException(ex, "Error Creating DLV File")
            mImages_CreateDLVComplete(Me, New EventArgs)

        Finally
            mCreateDLVMode = False

        End Try

    End Sub

    Private Sub ZoomIn()
        'Keep the screen from refreshing until we are done
        SurveyPictureBox.SuspendLayout()

        'Zoom the image
        If mZoomScale < 2.0 Then
            mZoomScale += 0.1
            SurveyPictureBox.Size = New Size(CInt(CType(SurveyPictureBox.Tag, Size).Width * mZoomScale), _
                                             CInt(CType(SurveyPictureBox.Tag, Size).Height * mZoomScale))
        End If

        'Refresh the screen now
        SurveyPictureBox.ResumeLayout()
    End Sub

    Private Sub ZoomOut()
        'Keep the screen from refreshing until we are done
        SurveyPictureBox.SuspendLayout()

        'Zoom the image
        If mZoomScale > 0.1 Then
            mZoomScale -= 0.1
            SurveyPictureBox.Size = New Size(CInt(CType(SurveyPictureBox.Tag, Size).Width * mZoomScale), _
                                             CInt(CType(SurveyPictureBox.Tag, Size).Height * mZoomScale))
        End If

        'Refresh the screen now
        SurveyPictureBox.ResumeLayout()
    End Sub

    Private Sub RotateClockwise()

        'Keep the screen from refreshing until we are done
        SurveyPictureBox.SuspendLayout()

        'Rotate the image
        SurveyPictureBox.Size = New Size(SurveyPictureBox.Size.Height, SurveyPictureBox.Size.Width)
        SurveyPictureBox.Tag = New Size(CType(SurveyPictureBox.Tag, Size).Height, CType(SurveyPictureBox.Tag, Size).Width)
        SurveyPictureBox.Image.RotateFlip(RotateFlipType.Rotate90FlipNone)
        SurveyPictureBox.Invalidate()

        'Refresh the screen now
        SurveyPictureBox.ResumeLayout()

    End Sub

    Private Sub RotateCounterClockwise()

        'Keep the screen from refreshing until we are done
        SurveyPictureBox.SuspendLayout()

        'Rotate the image
        SurveyPictureBox.Size = New Size(SurveyPictureBox.Size.Height, SurveyPictureBox.Size.Width)
        SurveyPictureBox.Tag = New Size(CType(SurveyPictureBox.Tag, Size).Height, CType(SurveyPictureBox.Tag, Size).Width)
        SurveyPictureBox.Image.RotateFlip(RotateFlipType.Rotate270FlipNone)
        SurveyPictureBox.Invalidate()

        'Refresh the screen now
        SurveyPictureBox.ResumeLayout()

    End Sub

#End Region
End Class
