''' <summary>
''' This dialog form displays the Medicare ID errors to the user when creating a CMS export file.
''' The user is given the option to click the override button to create a CMS export file, or 
''' discard the export transaction. 
''' </summary>
''' <remarks></remarks>
Public Class ExportIndividualFilesErrorDialog

    Private mErrorMessage As String
    Private mSelectedExports As ObjectModel.Collection(Of Nrc.DataMart.Library.ExportSet)
    Private misCombined As Boolean
    Private misScheduleForExport As Boolean



    Sub New(ByVal ErrorMessage As String, ByVal SelectedExports As ObjectModel.Collection(Of Nrc.DataMart.Library.ExportSet), ByVal isCombined As Boolean, ByVal isScheduleForExport As Boolean)


        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        'Set Private file path to incoming parameter
        mErrorMessage = ErrorMessage
        mSelectedExports = SelectedExports
        misCombined = isCombined
        misScheduleForExport = isScheduleForExport

    End Sub

    Private Sub ExportIndividualFileError_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        PictureBox1.Image = ImageList1.Images(0)

        Error_Message_Textbox.Text = mErrorMessage

        If Not String.IsNullOrEmpty(mErrorMessage) Then
            Error_Message_Label.Text = "Please select export definitions from all units and create a combined file."
        End If


        Error_Message_Label.Visible = Not misCombined


        If CurrentUser.IsMedicareOverride Then
            CreateFileButton.Visible = True
        End If

        'Check each Medicare Id in the ExportSet. 
        'If they all don't match, set DisplayOverride to true.
        Dim FirstMedicareId As Integer = mSelectedExports(0).Id
        Dim DisplayOverrideButton As Boolean = True
        For Each export As Nrc.DataMart.Library.ExportSet In mSelectedExports
            If FirstMedicareId <> export.Id Then
                DisplayOverrideButton = False
                Exit For
            End If
        Next

        'If DisplayOverride is set to true, disable button, show link.
        If Not DisplayOverrideButton Then
            CreateFileButton.Enabled = DisplayOverrideButton
            IDsArentUnique_Label.Visible = True
        End If

        'Disabled Override if this is a scheduled export
        'A scheduled export should never be allowed if it
        'requires a medicare override.
        If misScheduleForExport = True Then
            Error_Message_Label.Text = "Medicare Override is disabled for scheduled exports."
            CreateFileButton.Enabled = False
        End If



    End Sub

    Private Sub CreateFileButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CreateFileButton.Click
        'Close the Form
        Me.DialogResult = System.Windows.Forms.DialogResult.Yes
        Me.Close()
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        'Close the Form
        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()
    End Sub

End Class
