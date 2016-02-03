Imports Nrc.SurveyPoint.Library

Public Class UpdateExceptionsDialog

    Public Sub New(ByVal exceptions As UpdateFileCollection, ByVal viewMode As UpdateExceptionsDialogViewModes)

        Me.InitializeComponent()

        'Set the view mode
        SetViewMode(viewMode)

        'Display the collection
        UpdateExceptionsBindingSource.DataSource = exceptions

    End Sub

    Private Sub OK_Button_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OK_Button.Click

        Me.Close()

    End Sub

    Private Sub UpdateExceptionsExcelTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateExceptionsExcelTSButton.Click

        'Prompt user for filename
        If SaveFileDialog.ShowDialog = DialogResult.OK Then
            'Save the file
            UpdateExceptionsGridView.ExportToXls(SaveFileDialog.FileName)
        End If

    End Sub

    Private Sub UpdateExceptionsPrintTSButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles UpdateExceptionsPrintTSButton.Click

        'Opens the Preview window.
        UpdateExceptionsGrid.ShowPreview()

    End Sub

    Private Sub UpdateExceptionsDialog_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Disable the print button if the printing engine is not installed
        If Not UpdateExceptionsGrid.IsPrintingAvailable Then
            UpdateExceptionsPrintTSButton.Enabled = False
            UpdateExceptionsExcelTSButton.Enabled = False
        End If

    End Sub

    Private Sub SetViewMode(ByVal viewMode As UpdateExceptionsDialogViewModes)

        Dim enabled As Boolean

        Select Case viewMode
            Case UpdateExceptionsDialogViewModes.ViewExpanded
                enabled = True
                Me.Caption = "Update Exceptions"

            Case UpdateExceptionsDialogViewModes.ViewFileNamesOnly
                enabled = False
                Me.Caption = "Files With No Respondents Being Updated"

        End Select

        With UpdateExceptionsGridView
            .OptionsView.ShowDetailButtons = enabled
            .OptionsPrint.ExpandAllDetails = enabled
            .OptionsPrint.PrintDetails = enabled
        End With

    End Sub

End Class
