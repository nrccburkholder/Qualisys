Imports Nrc.QualiSys.Scanning.Library

Public Class DataEntryBatchAddDialog

#Region " Private Members "

    Private mBatchName As String = String.Empty

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property BatchName() As String
        Get
            Return mBatchName
        End Get
    End Property

#End Region

#Region " Private Properties "

    Private ReadOnly Property LithoCodes() As List(Of String)
        Get
            Dim lithos As New List(Of String)

            For Each item As ListViewItem In LithoCodesListView.Items
                lithos.Add(item.Text)
            Next

            Return lithos
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New()

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Setup the form
        SetInputControls()
        InputLithoCodeRadioButton.Checked = True
        InputTextBox.Focus()

    End Sub

#End Region

#Region " Events "

    Private Sub AddButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles AddButton.Click

        Dim isLithoCode As Boolean
        Dim type As String = String.Empty
        Dim lithoCode As String = String.Empty
        Dim barcode As String = String.Empty

        'Determine if we are entering barcodes or lithocodes
        If InputLithoCodeRadioButton.Checked Then
            isLithoCode = True
            type = "LithoCode"
        Else
            isLithoCode = False
            type = "Barcode"
        End If

        'Validate the entry
        If InputTextBox.Text.ToUpper <> VerifyTextBox.Text.ToUpper Then
            MessageBox.Show(String.Format("The entered {0} do not match!  Please try again.", type), String.Format("{0} Entry Error!", type), MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        'Get the entry
        If isLithoCode Then
            lithoCode = InputTextBox.Text.ToUpper
            barcode = Litho.LithoToBarcode(CInt(lithoCode))
            If barcode = "-1" Then
                MessageBox.Show("The entered LithoCode cannot be converted to a Barcode!", "Error Converting LithoCode!", MessageBoxButtons.OK, MessageBoxIcon.Error)
                InputTextBox.Focus()
                Exit Sub
            Else
                barcode = barcode.Substring(0, 6)
            End If
        Else
            barcode = InputTextBox.Text.ToUpper
            lithoCode = Litho.BarcodeToLitho(barcode)
            If lithoCode = String.Empty Then
                MessageBox.Show("The entered Barcode cannot be converted to a LithoCode!", "Error Converting Barcode!", MessageBoxButtons.OK, MessageBoxIcon.Error)
                InputTextBox.Focus()
                Exit Sub
            End If
        End If

        'Validate the LithoCode
        Dim message As String = QSIDataForm.ValidateLithoCode(lithoCode)
        If Not String.IsNullOrEmpty(message) Then
            MessageBox.Show(message, "Error Validating LithoCode!", MessageBoxButtons.OK, MessageBoxIcon.Error)
            InputTextBox.Focus()
            Exit Sub
        End If

        'Everything checks out so add this LithoCode to the list
        Dim item As New ListViewItem(lithoCode)
        item.Name = "LC-" & lithoCode
        item.SubItems.Add(barcode)
        If Not LithoCodesListView.Items.ContainsKey(item.Name) Then
            LithoCodesListView.Items.Add(item)
        End If

        'Clear the controls
        InputTextBox.Text = String.Empty
        VerifyTextBox.Text = String.Empty
        InputTextBox.Focus()

    End Sub

    Private Sub InputLithoCodeRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles InputLithoCodeRadioButton.CheckedChanged

        SetInputOptionControls()

    End Sub

    Private Sub InputBarcodeRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles InputBarcodeRadioButton.CheckedChanged

        SetInputOptionControls()

    End Sub

    Private Sub InputTextBox_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles InputTextBox.TextChanged

        SetInputControls()

    End Sub

    Private Sub VerifyTextBox_TextChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles VerifyTextBox.TextChanged

        SetInputControls()

    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click

        Dim batch As QSIDataBatch
        Dim litho As String = String.Empty

        'Check to see if there are any LithoCodes entered in the list
        If LithoCodesListView.Items.Count = 0 Then
            MessageBox.Show("You must add at least one LithoCode to the list!", "Empty LithoCode List", MessageBoxButtons.OK, MessageBoxIcon.Error)
            InputTextBox.Focus()
            Exit Sub
        End If

        'If we made it to here then the user has input the lithos to be added to a new batch
        Try
            'Create the batch
            batch = QSIDataBatch.NewQSIDataBatch()
            With batch
                .DateEntered = Date.Now
                .EnteredBy = CurrentUser.UserName
                .Locked = False
                .Save()
            End With

        Catch ex As Exception
            'Error encountered creating the batch so report it to the user and head out of Dodge
            Globals.ReportException(ex, "Error Creating Data Entry Batch!")
            Exit Sub

        End Try

        'Set the batch name
        mBatchName = batch.BatchName

        'Add the specified lithos to the batch
        Try
            For Each litho In LithoCodes
                QSIDataForm.Create(batch.BatchId, litho)
            Next

        Catch ex As Exception
            Globals.ReportException(ex, String.Format("Error Adding LithoCode {0} to Batch {1}", litho, mBatchName))
            batch.Delete()
            batch.Save()
            Exit Sub

        End Try

        'Return the OK button
        DialogResult = Windows.Forms.DialogResult.OK

    End Sub

    Private Sub Cancel_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Cancel_Button.Click

        DialogResult = Windows.Forms.DialogResult.Cancel

    End Sub

#End Region

#Region " Public Methods "

#End Region

#Region " Private Methods "

    Private Sub SetInputControls()

        VerifyTextBox.Enabled = (InputTextBox.Text.Trim.Length > 0)
        AddButton.Enabled = (InputTextBox.Text.Trim.Length > 0 And VerifyTextBox.Text.Trim.Length > 0)

    End Sub

    Private Sub SetInputOptionControls()

        Dim type As String = String.Empty
        Dim length As Integer

        'Determine the input type
        If InputLithoCodeRadioButton.Checked Then
            type = "LithoCode"
            length = 10
        Else
            type = "Barcode"
            length = 6
        End If

        'Setup the controls for the type
        InputGroupBox.Text = String.Format("Input {0}s", type)
        InputLabel.Text = String.Format("Enter {0}:", type)
        With InputTextBox
            .Text = String.Empty
            .MaxLength = length
        End With
        VerifyLabel.Text = String.Format("Verify {0}:", type)
        With VerifyTextBox
            .Text = String.Empty
            .MaxLength = length
        End With

        InputTextBox.Focus()

    End Sub

#End Region

End Class
