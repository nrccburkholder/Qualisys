Imports Nrc.QualiSys.Scanning.Library

Public Class DataEntryVerifySection

#Region " Private Members "

    Private mDataEntryMode As DataEntryModes
    Private mNode As DataEntryTemplateNode
    Private mForms As QSIDataFormCollection
    Private mCurrentForm As Integer

    Private WithEvents mNavControl As DataEntryVerifyNavigator

#End Region

#Region " Base Class Overrides "

    Public Overrides Sub ActivateSection()

        mNavControl.PopulateTree(True)

    End Sub

    Public Overrides Function AllowInactivate() As Boolean

        'Check to see if we are editing anything
        If Not QuestionGroupPanel.Visible Then
            'We are not editing anything so we are fine
            Return True
        ElseIf IsValid() Then
            'Ask the user if they want to save
            If MessageBox.Show("The current LithoCode has not been saved.  Do you wish to save it now?", "Save LithoCode", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
                'The user wants to save so do it
                Save()
            End If
            Return True
        Else
            'The form is not valid so ask the user if they are sure
            If MessageBox.Show("Are you sure you want to cancel the changes to this LithoCode?", "Cancel LithoCode", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                'The user wants to cancel
                Return True
            End If
        End If

        'We do not want to leave just yet
        Return False

    End Function

    Public Overrides Sub InactivateSection()

        'Clear the form
        ClearForm()

    End Sub

    Public Overrides Sub RegisterNavControl(ByVal navCtrl As Navigator)

        'Save a reference to the Navigator
        mNavControl = DirectCast(navCtrl, DataEntryVerifyNavigator)

    End Sub

#End Region

#Region " Constructors "

    Public Sub New(ByVal dataEntryMode As DataEntryModes)

        'Initialize the form
        InitializeComponent()

        'Save parameters
        mDataEntryMode = dataEntryMode

    End Sub

#End Region

#Region " Events "

#Region " Events - Navigator Control "

    Private Sub mNavControl_SelectedNodeChanging(ByVal sender As Object, ByVal e As SelectedNodeChangingEventArgs) Handles mNavControl.SelectedNodeChanging

        'Check to see if we are editing anything
        If Not QuestionGroupPanel.Visible Then
            'We are not editing anything so we are fine
            e.Cancel = False
        ElseIf IsValid() Then
            'Ask the user if they want to save
            If MessageBox.Show("The current LithoCode has not been saved.  Do you wish to save it now?", "Save LithoCode", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
                'The user wants to save so do it
                Save()
            End If
            e.Cancel = False
        Else
            'The form is not valid so ask the user if they are sure
            If MessageBox.Show("Are you sure you want to cancel the changes to this LithoCode?", "Cancel LithoCode", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.Yes Then
                'The user wants to cancel
                e.Cancel = False
            Else
                'The user wants to stay here
                e.Cancel = True
            End If
        End If

        'If we are allowing the node to change then clear the form
        If Not e.Cancel Then
            ClearForm()
        End If

    End Sub

    Private Sub mNavControl_BeginEditingTemplate(ByVal sender As Object, ByVal e As SelectedNodeChangedEventArgs) Handles mNavControl.BeginEditingTemplate

        'Get the template node
        mNode = DirectCast(e.Node, DataEntryTemplateNode)

        'Get the forms to be edited
        mForms = QSIDataForm.GetByTemplateName(mNode.Source.BatchID, mNode.Source.TemplateName, mDataEntryMode)

        'Set the current form
        If mForms.Count = 0 Then
            MessageBox.Show("There are no forms to show for this Template!", "Error Getting LithoCodes for Template", MessageBoxButtons.OK, MessageBoxIcon.Error)
            ClearForm()
            Exit Sub
        Else
            mCurrentForm = 0
        End If

        'Show the form
        ShowForm()

    End Sub

#End Region

#Region " Events - Section Control "

    Private Sub NextButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles NextButton.Click

        'Validate current LithoCode
        If Not IsValid() Then
            'This LithoCode is not valid
            MessageBox.Show("One or more questions have not been answered!", "LithoCode Validation Error", MessageBoxButtons.OK, MessageBoxIcon.Error)
            Exit Sub
        End If

        'Save this LithoCode
        Save()

        'Increment the current form and show it
        If mCurrentForm = mForms.Count - 1 Then
            'We have just saved the last LithoCode in the Template
            'Check to see if entire batch is now complete
            If mDataEntryMode = DataEntryModes.Verify AndAlso QSIDataBatch.IsBatchComplete(mForms(mCurrentForm).BatchId) Then
                'Finalize the batch
                Dim batch As QSIDataBatch = QSIDataBatch.Get(mForms(mCurrentForm).BatchId)
                batch.FinalizeBatch(CurrentUser.UserName)
            End If

            'Clear the form
            ClearForm()

            'Repopulate the tree
            mNavControl.PopulateTree(True)

            'Notify User
            MessageBox.Show(String.Format("Template {0} - {1} has been completed", mNode.Source.BatchName, mNode.Source.TemplateName), "Template Completed", MessageBoxButtons.OK, MessageBoxIcon.Information, MessageBoxDefaultButton.Button1)
        Else
            'Increment the form and show it
            mCurrentForm += 1
            ShowForm()
        End If

    End Sub

    Private Sub CancelButton_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CancelButton.Click

        'Check to see if the form is valid
        If IsValid() Then
            'Ask the user if they want to save
            If MessageBox.Show("The current LithoCode has not been saved.  Do you wish to save it now?", "Save LithoCode", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button1) = DialogResult.Yes Then
                'The user wants to save so do it
                Save()
            End If
        Else
            'The form is not valid so ask the user if they are sure
            If MessageBox.Show("Are you sure you want to cancel the changes to this LithoCode?", "Cancel LithoCode", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) = DialogResult.No Then
                'The user has changed their mind and wishes to stick around for a while
                Exit Sub
            End If
        End If

        'Clear the form
        ClearForm()

        'Repopulate the tree
        mNavControl.PopulateTree(True)

    End Sub

#End Region

#End Region

#Region " Public Methods "

#End Region

#Region " Private Methods "

    Private Sub ClearForm()

        'Clear the form
        QuestionGroupPanel.Visible = False
        BottomPanel.Visible = False
        QuestionGroupPanel.Controls.Clear()

        'Set the section caption
        DataEntryVerifySectionPanel.Caption = String.Empty

        'Unlock the batch
        If mForms IsNot Nothing Then
            Dim batch As QSIDataBatch = QSIDataBatch.Get(mForms(mCurrentForm).BatchId)
            With batch
                .Locked = False
                .Save()
            End With
        End If

    End Sub

    Private Sub ShowForm()

        Dim questionCtrl As DataEntryVerifyQuestionControl
        Dim top As Integer = 3
        Dim questionNumber As Integer

        'Lock the form
        QuestionGroupPanel.Visible = False
        SuspendLayout()

        'Clear the form
        QuestionGroupPanel.Controls.Clear()

        'Set the section caption
        DataEntryVerifySectionPanel.Caption = String.Format("{0} - {1} - {2}", mNode.Source.BatchName, mNode.Source.TemplateName, mForms(mCurrentForm).LithoCode)

        'Add the question controls
        For Each question As QSIDataFormQuestion In mForms(mCurrentForm).Questions
            questionNumber += 1
            questionCtrl = New DataEntryVerifyQuestionControl(question, questionNumber, mDataEntryMode, mForms(mCurrentForm).Results.ResultString(question.QstnCore))
            questionCtrl.Top = top
            questionCtrl.Width = QuestionGroupPanel.Width
            QuestionGroupPanel.Controls.Add(questionCtrl)
            questionCtrl.Anchor = AnchorStyles.Left Or AnchorStyles.Top Or AnchorStyles.Right
            top += questionCtrl.Height
        Next

        'If we are in entry mode and this for already has QSIDataResults for this form then they got there in error so delete them
        If mDataEntryMode = DataEntryModes.Entry Then
            If mForms(mCurrentForm).Results.Count > 0 Then
                'Oops, gonna have to make them go away
                mForms(mCurrentForm).DeleteResults()
            End If
        End If

        'Unlock the form
        ResumeLayout()
        QuestionGroupPanel.Visible = True
        BottomPanel.Visible = True

    End Sub

    Private Function IsValid() As Boolean

        Dim valid As Boolean = True

        'Loop through all of the questions to see if they are all valid
        For Each questionCtrl As DataEntryVerifyQuestionControl In QuestionGroupPanel.Controls
            If Not questionCtrl.IsValid Then
                valid = False
                Exit For
            End If
        Next

        Return valid

    End Function

    Private Function Save() As Boolean

        Dim saveResults As Boolean
        Dim questionCtrl As DataEntryVerifyQuestionControl

        'Validate the form
        If Not IsValid() Then Return False

        'Save the results
        For cnt As Integer = 0 To QuestionGroupPanel.Controls.Count - 1
            'Get the questionCtrl
            saveResults = False
            questionCtrl = DirectCast(QuestionGroupPanel.Controls(cnt), DataEntryVerifyQuestionControl)

            'Determine what mode we are in
            If mDataEntryMode = DataEntryModes.Entry Then
                'We are in data entry mode so save the result
                saveResults = True
            Else
                'We are in data verification mode
                'Determine if we need to delete the results for this question
                If questionCtrl.OverrideEntry Then
                    'Delete the results for this question
                    mForms(mCurrentForm).DeleteResultsByQstnCore(questionCtrl.Question.QstnCore)

                    'Save result
                    saveResults = True
                End If
            End If

            'Save the results if required
            If saveResults Then
                For Each value As String In questionCtrl.SelectedValues.Split(","c)
                    'Create the result object
                    Dim result As QSIDataResult = QSIDataResult.NewQSIDataResult
                    With result
                        .FormId = mForms(mCurrentForm).FormId
                        .QstnCore = questionCtrl.Question.QstnCore
                        .ResponseValue = CInt(value)
                        .Save()
                    End With

                    'Add the result to the collection
                    mForms(mCurrentForm).Results.Add(result)
                Next
            End If
        Next

        'Update the form
        If mDataEntryMode = DataEntryModes.Entry Then
            With mForms(mCurrentForm)
                .KeyedBy = CurrentUser.UserName
                .DateKeyed = Date.Now
                .Save()
            End With
        Else
            With mForms(mCurrentForm)
                .VerifiedBy = CurrentUser.UserName
                .DateVerified = Date.Now
                .Save()
            End With
        End If

        'Update the tree
        mNode.Refresh()

    End Function

#End Region

End Class
