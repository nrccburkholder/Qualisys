Imports DevExpress.XtraEditors.Controls
Imports Nrc.QualiSys.Scanning.Library

Public Class DataEntryVerifyQuestionControl

#Region " Private Members "

    Private mQuestion As QSIDataFormQuestion
    Private mQuestionNumber As Integer
    Private mDataEntryMode As DataEntryModes
    Private mEntryResponseValues As String = String.Empty
    Private mOverrideEntry As Boolean

    Private mIsChecking As Boolean

    Private Const mkCheckItemHeight As Integer = 17
    Private Const mkRadioItemHeight As Integer = 19
    Private Const mkRadioFirstItemHeight As Integer = 21

#End Region

#Region " Public Properties "

#End Region

#Region " Public ReadOnly Properties "

    Public ReadOnly Property Question() As QSIDataFormQuestion
        Get
            Return mQuestion
        End Get
    End Property

    Public ReadOnly Property OverrideEntry() As Boolean
        Get
            Return mOverrideEntry
        End Get
    End Property

    Public ReadOnly Property SelectedValues() As String
        Get
            Dim values As String = String.Empty

            'What type of question is this
            If mQuestion.ReadMethodId = 1 Then
                'This is a multiple response question so get the selected values
                For cnt As Integer = 0 To MultipleResponseControl.Items.Count - 1
                    If MultipleResponseControl.Items(cnt).CheckState = CheckState.Checked Then
                        If values.Length = 0 Then
                            If cnt = 0 Then
                                'This is the nothing selected option
                                values = "-9"
                            ElseIf cnt = 1 Then
                                'This is the don't know option
                                values = "-6"
                            ElseIf cnt = 2 Then
                                'This is the refused option
                                values = "-5"
                            Else
                                values = mQuestion.ScaleItems(cnt - 3).ScaleItem.ToString '3 special options above
                            End If
                        Else
                            If cnt = 0 Then
                                'This is the nothing selected option
                                values += ",-9"
                            ElseIf cnt = 1 Then
                                'This is the don't know option
                                values += ",-6"
                            ElseIf cnt = 2 Then
                                'This is the refused option
                                values += ",-5"
                            Else
                                values += String.Format(",{0}", mQuestion.ScaleItems(cnt - 3).ScaleItem) '3 special options above
                            End If
                        End If
                    End If
                Next
            Else
                'This is a single response question so get the selected value
                If SingleResponseControl.SelectedIndex > -1 Then
                    If SingleResponseControl.SelectedIndex = 0 Then
                        'This is the nothing selected option
                        values = "-9"
                    ElseIf SingleResponseControl.SelectedIndex = 1 Then
                        'This is the don't know option
                        values = "-6"
                    ElseIf SingleResponseControl.SelectedIndex = 2 Then
                        'This is the refused option
                        values = "-5"
                    Else
                        values = mQuestion.ScaleItems(SingleResponseControl.SelectedIndex - 3).ResponseValue.ToString '3 special options above
                    End If
                End If
            End If

            Return values
        End Get
    End Property

#End Region

#Region " Constructors "

    Public Sub New(ByVal question As QSIDataFormQuestion, ByVal questionNumber As Integer, ByVal dataEntryMode As DataEntryModes, ByVal entryResponseValues As String)

        'This call is required by the Windows Form Designer.
        InitializeComponent()

        'Save off the parameters
        mQuestion = question
        mQuestionNumber = questionNumber
        mDataEntryMode = dataEntryMode
        mEntryResponseValues = entryResponseValues

        'Initialize the control
        InitializeControl()

    End Sub

#End Region

#Region " Events "

    Private Sub MultipleResponseControl_ItemCheck(ByVal sender As Object, ByVal e As ItemCheckEventArgs) Handles MultipleResponseControl.ItemCheck

        If mIsChecking Then Exit Sub

        mIsChecking = True

        If e.Index = 0 Then
            'The user chose the no response so uncheck the remainder
            For cnt As Integer = 1 To MultipleResponseControl.Items.Count - 1
                MultipleResponseControl.Items(cnt).CheckState = CheckState.Unchecked
            Next
        Else
            'The user has selected one of the valid scale values so uncheck the no response
            MultipleResponseControl.Items(0).CheckState = CheckState.Unchecked
        End If

        'Check the new one
        MultipleResponseControl.Items(e.Index).CheckState = CheckState.Checked

        'Validate the control
        mOverrideEntry = False
        IsValid()

        mIsChecking = False

    End Sub

    Private Sub SingleResponseControl_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles SingleResponseControl.SelectedIndexChanged

        mOverrideEntry = False
        IsValid()

    End Sub

    Private Sub OverrideEntryButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles OverrideEntryButton.Click

        mOverrideEntry = True
        OverrideEntryButton.Visible = False
        IsValid()

    End Sub

#End Region

#Region " Private Methods "

    Private Sub InitializeControl()

        'Set the Questions Text
        QuestionLabel.Text = String.Format("{0}.  {1} ({2})", mQuestionNumber, mQuestion.QuestionText, mQuestion.QstnCore)

        'Format the controls
        If mQuestion.ReadMethodId = 1 Then
            'This is a multiple response question
            SingleResponseControl.Visible = False
            With MultipleResponseControl
                'Clear the list
                .Items.Clear()

                'Add the no answer scale
                .Items.Add("No Response Provided (-9)", CheckState.Unchecked, True)
                .Items.Add("Don't Know Response Provided (-6)", CheckState.Unchecked, True)
                .Items.Add("Refused Response Provided (-5)", CheckState.Unchecked, True)

                'Add the scale items
                For Each scale As QSIDataFormQuestionItem In mQuestion.ScaleItems
                    .Items.Add(scale.ScaleItemLabel, CheckState.Unchecked, True)
                Next

                'Set location and size
                .Visible = True
                .Top = 23
                .Height = mkCheckItemHeight * .Items.Count

                'Set the height of the control so all options are visible
                Height = .Top + .Height + 7
            End With
        Else
            'This is a single response question
            MultipleResponseControl.Visible = False
            With SingleResponseControl
                'Clear the list
                .Properties.Items.Clear()

                'Add the no answer scale
                .Properties.Items.Add(New RadioGroupItem(-9, "No Response Provided (-9)"))
                .Properties.Items.Add(New RadioGroupItem(-6, "Don't Know Response Provided (-6)"))
                .Properties.Items.Add(New RadioGroupItem(-5, "Refused Response Provided (-5)"))

                'Add the scale items
                For Each scale As QSIDataFormQuestionItem In mQuestion.ScaleItems
                    .Properties.Items.Add(New RadioGroupItem(scale.ResponseValue, scale.ResponseValueLabel))
                Next

                'Set location and size
                .Visible = True
                .Top = 19
                .Height = mkRadioFirstItemHeight + (mkRadioItemHeight * (.Properties.Items.Count - 1))

                'Set the height of the control so all options are visible
                Height = .Top + .Height + 4
            End With
        End If

        'Validate the control
        IsValid()

    End Sub

#End Region

#Region " Public Methods "

    Public Function IsValid() As Boolean

        Dim found As Boolean
        Dim message As String = String.Empty

        'Make sure something is selected
        If mQuestion.ReadMethodId = 1 Then
            'This is a multiple response question so make sure something is checked
            For Each item As CheckedListBoxItem In MultipleResponseControl.Items
                If item.CheckState = CheckState.Checked Then
                    found = True
                    Exit For
                End If
            Next

            'Make sure something was checked
            If Not found Then
                message = "You must select a response for this Question!"
            End If
        Else
            'This is a single response question so make sure one is selected
            If SingleResponseControl.SelectedIndex = -1 Then
                message = "You must select a response for this Question!"
                found = False
            Else
                found = True
            End If
        End If

        'If we are in verify mode then make sure that we selected the same thing as during entry
        If mDataEntryMode = DataEntryModes.Verify AndAlso found AndAlso Not mOverrideEntry Then
            'Check to see if this is the same as during entry
            If SelectedValues <> mEntryResponseValues Then
                'Build the message
                If message.Length = 0 Then
                    message = String.Format("Verification selections do not match entry selections ({0})!", mEntryResponseValues)
                Else
                    message += String.Format("{0}Verification selections do not match entry selections ({1})!", vbCrLf, mEntryResponseValues)
                End If

                'Show the override button
                OverrideEntryButton.Visible = True
            Else
                'We are good so hide the override button
                OverrideEntryButton.Visible = False
            End If
        End If

        'Update the error message
        DataEntryVerifyErrorProvider.SetError(QuestionLabel, message)

        Return (message.Length = 0)

    End Function

#End Region

End Class
