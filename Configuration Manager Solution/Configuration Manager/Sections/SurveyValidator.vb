Imports Nrc.Qualisys.Library


Public Class SurveyValidator

    Private mEndConfigCallback As EndConfigCallBackMethod
    Private mSurvey As Survey
    Private mWarningMessage As String
    Private mIsReadOnly As Boolean
    Private mValidationResult As SurveyValidationResult
    Private mPreviouslySelectedRadioButton As RadioButton

    Public Sub New(ByVal endConfigCallback As EndConfigCallBackMethod, ByVal srvy As Survey)
        ' This call is required by the Windows Form Designer.
        InitializeComponent()

        ' Add any initialization after the InitializeComponent() call.
        mEndConfigCallback = endConfigCallback
        mSurvey = srvy

        Me.InitializeUI()
    End Sub

    Public Sub New(ByVal endConfigCallback As EndConfigCallBackMethod, ByVal srvy As Survey, ByVal warningMessage As String, ByVal isReadOnly As Boolean)
        Me.New(endConfigCallback, srvy)
        mWarningMessage = warningMessage
        mIsReadOnly = isReadOnly

        If String.IsNullOrEmpty(mWarningMessage) Then
            Me.InformationBar1.Visible = False
        Else
            Me.InformationBar1.Visible = True
            Me.InformationBar1.Information = mWarningMessage
        End If

        Me.EditorPanel.Enabled = (Not isReadOnly)

        Me.InitializeUI()
    End Sub

    Private Sub InitializeUI()
        Dim lastValidation As String = ""
        Dim currentStatus As String = ""
        If Me.mSurvey.DateValidated = DateTime.MinValue Then
            lastValidation = "Never"
        Else
            lastValidation = Me.mSurvey.DateValidated.ToLongDateString & " " & Me.mSurvey.DateValidated.ToLongTimeString
        End If

        If Me.mSurvey.IsValidated AndAlso Me.mSurvey.IsFormGenReleased Then
            currentStatus = "Validated and Form Gen Released"
            Me.ValidatedFormGenReleasedRadioButton.Checked = True
            mPreviouslySelectedRadioButton = Me.ValidatedFormGenReleasedRadioButton
        ElseIf Me.mSurvey.IsValidated AndAlso Me.mSurvey.IsFormGenReleased = False Then
            currentStatus = "Validated and NOT Form Gen Released"
            Me.ValidatedNotFormGenReleasedRadioButton.Checked = True
            mPreviouslySelectedRadioButton = Me.ValidatedNotFormGenReleasedRadioButton
        Else
            currentStatus = "Not Validated"
            Me.NotValidatedRadioButton.Checked = True
            mPreviouslySelectedRadioButton = Me.NotValidatedRadioButton
        End If

        Me.LastValidationLabel.Text = lastValidation
        Me.CurrentStatusLabel.Text = "Status:  " & currentStatus
        Me.OKButton.Enabled = False

        Me.SetStatusOptions()

        Me.CopyToClipboardButton.Enabled = False
    End Sub

    Private Sub OKButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OKButton.Click
        If Me.NotValidatedRadioButton.Checked = False Then
            Me.mSurvey.IsValidated = True
            Me.mSurvey.DateValidated = DateTime.Now
            Me.mSurvey.IsFormGenReleased = Me.ValidatedFormGenReleasedRadioButton.Checked
        Else
            Me.mSurvey.IsValidated = False
            Me.mSurvey.IsFormGenReleased = False
        End If

        If Me.mSurvey.IsDirty Then
            mSurvey.Update()
        End If
        mEndConfigCallback(ConfigResultActions.SurveyRefresh, Nothing)
    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click
        mEndConfigCallback(ConfigResultActions.None, Nothing)
    End Sub

    Private Sub ValidateSurvey()
        If mValidationResult Is Nothing Then
            mValidationResult = mSurvey.PerformSurveyValidation
        End If

        Dim passImg As Image = My.Resources.Validation16
        Dim warnImg As Image = My.Resources.Caution16
        Dim failImg As Image = My.Resources.Error16

        For Each resultMessage As String In mValidationResult.PassList
            Me.PassedGrid.Rows.Add(passImg, "Passed", resultMessage)
        Next
        For Each resultMessage As String In mValidationResult.WarningList
            Me.WarningsGrid.Rows.Add(warnImg, "Warning", resultMessage, False)
        Next
        For Each resultMessage As String In mValidationResult.FailureList
            Me.FailuresGrid.Rows.Add(failImg, "Failed", resultMessage)
        Next

        Me.CopyToClipboardButton.Enabled = True
    End Sub

    Private Sub WarningsGrid_CellValueChanged(ByVal sender As Object, ByVal e As System.Windows.Forms.DataGridViewCellEventArgs) Handles WarningsGrid.CellValueChanged
        If Me.WarningsGrid.Columns(e.ColumnIndex).Name = "AcceptedColumn" Then Me.ToggleOKButton()
    End Sub

    Private Sub WarningsGrid_CurrentCellDirtyStateChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles WarningsGrid.CurrentCellDirtyStateChanged
        'force the commit of the cell edit immediately.  This allows us to respond to the cell value changed
        'event before the user leaves the cell.  This is needed to allow us to check if the OK button should be
        'enabled as soon as they check the accept check box.
        If Me.WarningsGrid.IsCurrentCellDirty Then Me.WarningsGrid.CommitEdit(DataGridViewDataErrorContexts.Commit)
    End Sub

    Private Function GetTextFromValidationMessages() As String
        Dim text As New System.Text.StringBuilder()

        text.AppendLine("Result" + vbTab + "Rule")
        For Each resultMessage As String In mValidationResult.PassList
            text.AppendLine("Passed" + vbTab + resultMessage)
        Next
        For Each resultMessage As String In mValidationResult.WarningList
            text.AppendLine("Warning" + vbTab + resultMessage)
        Next
        For Each resultMessage As String In mValidationResult.FailureList
            text.AppendLine("Failed" + vbTab + resultMessage)
        Next

        Return text.ToString
    End Function

    Private Function GetHTMLFromValidationMessages() As String
        Dim sb As New System.Text.StringBuilder

        sb.AppendLine("Version:1.0")
        sb.AppendLine("StartHTML:000000-1")
        sb.AppendLine("EndHTML:000000-1")
        sb.AppendLine("StartFragment:000000-1")
        sb.AppendLine("EndFragment:000000-1")
        sb.AppendLine("<!DOCTYPE HTML PUBLIC " & Chr(34) & "-//W3C//DTD HTML 4.0 Transitional//EN" & Chr(34) & ">")
        sb.AppendLine("<html>")
        sb.AppendLine("<head>")
        sb.AppendLine("<META http-equiv=Content-Type content=" & Chr(34) & "text/html; charset=utf-8" & Chr(34) & ">")
        sb.AppendLine("<STYLE>")
        sb.AppendLine(".tableStyle{background-color: LightSteelBlue; font-family:Verdana; font-size:x-small;}")
        sb.AppendLine(".cellStyle{background-color: #FFFFFF;}")
        sb.AppendLine("</STYLE>")
        sb.AppendLine("</head>")
        sb.AppendLine("<body>")
        sb.AppendLine("<!--StartFragment-->")

        'Dynamic content
        sb.AppendLine("<TABLE border=""1"" class=""tableStyle"" cellpadding=""4"" cellspacing=""1"">")

        'Add Header Row
        sb.Append("<TR>")

        sb.Append("<TD class=""cellStyle""><span style='font-size:16.0pt;'>")
        sb.Append("Result")
        sb.Append("</TD>")

        sb.Append("<TD class=""cellStyle""><span style='font-size:16.0pt;'>")
        sb.Append("Rule")
        sb.Append("</TD>")
        sb.AppendLine("</TR>")

        'Add each message
        For Each resultMessage As String In mValidationResult.PassList
            sb.Append("<TR>")

            sb.Append("<TD class=""cellStyle""><span style='color:blue'>")
            sb.Append("Passed")
            sb.Append("</TD>")

            sb.Append("<TD class=""cellStyle""><span style='color:blue'>")
            sb.Append(resultMessage)
            sb.Append("</TD>")
            sb.AppendLine("</TR>")
        Next
        For Each resultMessage As String In mValidationResult.WarningList
            sb.Append("<TR>")

            sb.Append("<TD class=""cellStyle""><span style='color:#FF9900'>")
            sb.Append("Warning")
            sb.Append("</TD>")

            sb.Append("<TD class=""cellStyle""><span style='color:#FF9900'>")
            sb.Append(resultMessage)
            sb.Append("</TD>")
            sb.AppendLine("</TR>")
        Next
        For Each resultMessage As String In mValidationResult.FailureList
            sb.Append("<TR>")

            sb.Append("<TD class=""cellStyle""><span style='color:red'>")
            sb.Append("Failed")
            sb.Append("</TD>")

            sb.Append("<TD class=""cellStyle""><span style='color:red'>")
            sb.Append(resultMessage)
            sb.Append("</TD>")
            sb.AppendLine("</TR>")
        Next

        sb.AppendLine("</TABLE>")

        'END
        sb.AppendLine("<!--EndFragment-->")
        sb.AppendLine("</body>")
        sb.AppendLine("</html>")

        Return sb.ToString

    End Function

    Private Sub CopyToClipboardButton_LinkClicked(ByVal sender As System.Object, ByVal e As System.Windows.Forms.LinkLabelLinkClickedEventArgs) Handles CopyToClipboardButton.LinkClicked
        Dim data As New DataObject()

        'Text
        data.SetData(DataFormats.Text, GetTextFromValidationMessages)

        'HTML
        data.SetData(DataFormats.Html, GetHTMLFromValidationMessages)

        'Add to clipboard
        Clipboard.SetDataObject(data, True)
    End Sub

    Private Sub NotValidatedRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NotValidatedRadioButton.CheckedChanged
        If NotValidatedRadioButton.Checked Then
            ValidateButtonAction(False)
            mPreviouslySelectedRadioButton = Me.NotValidatedRadioButton
            Me.CopyToClipboardButton.Enabled = False
        End If
    End Sub

    Private Sub ValidatedNotFormGenReleasedRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ValidatedNotFormGenReleasedRadioButton.CheckedChanged
        If ValidatedNotFormGenReleasedRadioButton.Checked Then
            ValidateButtonAction(True)
            mPreviouslySelectedRadioButton = Me.ValidatedNotFormGenReleasedRadioButton
        End If
    End Sub

    Private Sub ValidatedFormGenReleasedRadioButton_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ValidatedFormGenReleasedRadioButton.CheckedChanged
        If ValidatedFormGenReleasedRadioButton.Checked Then
            ValidateButtonAction(True)
            mPreviouslySelectedRadioButton = Me.ValidatedFormGenReleasedRadioButton
        End If
    End Sub

    Private Sub ValidateButtonAction(ByVal checkValidation As Boolean)
        If Me.NotValidatedRadioButton.Checked = True Then
            Me.PassedGrid.Rows.Clear()
            Me.FailuresGrid.Rows.Clear()
            Me.WarningsGrid.Rows.Clear()
        End If

        If Me.mPreviouslySelectedRadioButton Is Me.NotValidatedRadioButton Then
            ExecuteValidationIfNeeded()
        End If

        Me.ToggleOKButton()
    End Sub

    Private Sub ExecuteValidationIfNeeded()
        If mSurvey.IsValidated = False Then
            Me.ValidateSurvey()
        End If
    End Sub

    Private Sub ToggleOKButton()
        'See if this is the original state
        If Me.mSurvey.IsValidated AndAlso Me.mSurvey.IsFormGenReleased Then
            If Me.ValidatedFormGenReleasedRadioButton.Checked Then
                Me.OKButton.Enabled = False
                Return
            End If
        ElseIf Me.mSurvey.IsValidated AndAlso Me.mSurvey.IsFormGenReleased = False Then
            If Me.ValidatedNotFormGenReleasedRadioButton.Checked Then
                Me.OKButton.Enabled = False
                Return
            End If
        Else
            If Me.NotValidatedRadioButton.Checked Then
                Me.OKButton.Enabled = False
                Return
            End If
        End If

        If Me.NotValidatedRadioButton.Checked Then
            Me.OKButton.Enabled = True
            Return
        End If

        If Me.mValidationResult IsNot Nothing AndAlso Me.mValidationResult.Result = SurveyValidationResult.ValidationResult.Failed Then
            Me.OKButton.Enabled = False
            Return
        End If

        If Me.mValidationResult IsNot Nothing AndAlso Me.mValidationResult.Result = SurveyValidationResult.ValidationResult.SuccessWithWarnings Then
            For Each row As DataGridViewRow In Me.WarningsGrid.Rows
                If CBool(row.Cells(Me.AcceptedColumn.Name).Value) = False Then
                    Me.OKButton.Enabled = False
                    Return
                End If
            Next
        End If

        Me.OKButton.Enabled = True
    End Sub

    Private Sub SetStatusOptions()
        Me.ValidatedFormGenReleasedRadioButton.Visible = Me.mSurvey.SurveyTypeName.ToLower() <> "connect"
    End Sub


End Class
