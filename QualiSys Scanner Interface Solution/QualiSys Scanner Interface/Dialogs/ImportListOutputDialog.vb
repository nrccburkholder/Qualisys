Imports Nrc.QualiSys.Scanning.Library

Public Class ImportListOutputDialog

#Region " Private Members "

    Private mImages As ImageCollection
    Private mOutputType As OutputTypes

#End Region

#Region " Public Enums "

    Public Enum OutputTypes
        Barcodes = 0
        LithoCodes = 1
    End Enum

#End Region

#Region " Event Handlers "

    Private Sub OutputTypeBarcodeRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OutputTypeBarcodeRadioButton.CheckedChanged

        SetOutputTypeControls()

    End Sub

    Private Sub OutputTypeLithocodeRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OutputTypeLithocodeRadioButton.CheckedChanged

        SetOutputTypeControls()

    End Sub

    Private Sub RefreshListButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles RefreshListButton.Click

        'Repopulate the output list
        PopulateOutputList()

    End Sub

    Private Sub CreateDLVButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateDLVButton.Click

        'Create the DLV file
        Me.DialogResult = DialogResult.Yes
        Me.Close()

    End Sub

    Private Sub FinishedButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FinishedButton.Click

        Me.DialogResult = DialogResult.OK
        Me.Close()

    End Sub

#End Region

#Region " Public Methods "

    Public Sub InitDialog(ByVal images As ImageCollection, ByVal outputType As OutputTypes)

        'Save the parameters
        mImages = images
        mOutputType = outputType

        'Setup the screen
        If mOutputType = OutputTypes.Barcodes Then
            OutputTypeBarcodeRadioButton.Checked = True
        Else
            OutputTypeLithocodeRadioButton.Checked = True
        End If

        'Populate the output list
        PopulateOutputList()

    End Sub

#End Region

#Region " Private Methods "

    Private Sub PopulateOutputList()

        Dim itemSeparator As String
        Dim itemDelimiter As String

        If OutputTypeBarcodeRadioButton.Checked Then
            'Get the output parameters
            itemSeparator = BarcodeSeparatorTextBox.Text & CStr(IIf(BarcodeSeparatorCrLfCheckBox.Checked, vbCrLf, ""))
            itemDelimiter = BarcodeDelimiterTextBox.Text

            'Output the list of barcodes
            OutputListTextBox.Text = mImages.GetBarcodeList(itemSeparator, itemDelimiter)
        Else
            'Get the output parameters
            itemSeparator = LithoSeparatorTextBox.Text & CStr(IIf(LithoSeparatorCrLfCheckBox.Checked, vbCrLf, ""))
            itemDelimiter = LithoDelimiterTextBox.Text

            'Output the list of LithoCodes
            OutputListTextBox.Text = mImages.GetLithoList(itemSeparator, itemDelimiter)
        End If

        OutputListTextBox.Focus()
        OutputListTextBox.SelectAll()

    End Sub

    Private Sub SetOutputTypeControls()

        BarcodeSeparatorTextBox.Enabled = OutputTypeBarcodeRadioButton.Checked
        BarcodeSeparatorCrLfCheckBox.Enabled = OutputTypeBarcodeRadioButton.Checked
        BarcodeDelimiterTextBox.Enabled = OutputTypeBarcodeRadioButton.Checked
        BarcodeSeparatorLabel.Enabled = OutputTypeBarcodeRadioButton.Checked
        BarcodeDelimiterLabel.Enabled = OutputTypeBarcodeRadioButton.Checked

        LithoSeparatorTextBox.Enabled = OutputTypeLithocodeRadioButton.Checked
        LithoSeparatorCrLfCheckBox.Enabled = OutputTypeLithocodeRadioButton.Checked
        LithoDelimiterTextBox.Enabled = OutputTypeLithocodeRadioButton.Checked
        LithoSeparatorLabel.Enabled = OutputTypeLithocodeRadioButton.Checked
        LithoDelimiterLabel.Enabled = OutputTypeLithocodeRadioButton.Checked

    End Sub

#End Region
End Class
